//
//  blePeripheral.m
//  MonitoringCenter
//
//  Created by David ding on 13-1-10.
//
//

#import "blePeripheral.h"
#import "finderAppDelegate.h"
#import "MPNotificationView.h"
#import "RecorderModel.h"

//===================== SIMGAII ========================
// SIMGAII Service UUID
NSString *kAntilostServiceUUID                          = @"FE20";
// SIMGAII characteristics UUID
NSString *kAntilostRWControlValueCharateristicUUID      = @"FE21";
NSString *kAntilostRWNameCharateristicUUID              = @"FE22";
NSString *kAntilostRNKeypressedValueCharateristicUUID   = @"FE23";
NSString *kAntilostRNCurrentRssiCharateristicUUID       = @"FE24";
NSString *kAntilostRNBatteryCharateristicUUID           = @"FE25";

@implementation blePeripheral{
    AVAudioPlayer           *alarmPlayer;
    AVAudioPlayer           *disconnectPlayer;
    AVAudioPlayer           *connectPlayer;
    AVAudioPlayer           *keyPlayer;
    AVAudioPlayer           *autoSetupFinishPlayer;
    NSTimer                 *flashLightTimer;
    NSTimer                 *holdKeyPressedTimer;
    NSTimer                 *checkOutrangeAlarmTimer;
    NSTimer                 *checkWorkOnOffTimer;
    NSTimer                 *notificationTimer;
    
    UIAlertView             *autosetAlert;
    Byte                    currentWorkMode;
    NSTimer                 *recallWorkModeTimer;
    
    RecorderModel           *recorderModel;
        Byte                count; //计算灯闪的次数
    
    NSString                *nTitle, *nDetail;  //notification中的相关信息
    
}

#pragma mark -
#pragma mark Init
/******************************************************/
//          类初始化                                   //
/******************************************************/
// 初始化蓝牙
-(id)initWithPeripheral{
    self = [super init];
    if (self) {
        [self initPeripheralWithSeviceAndCharacteristic];
        [self initPropert];

    }
    return self;
}

-(id)initWithPeripheralwithMacData:(NSData *)data{
    self = [super init];
    if (self) {
        [self initPeripheralWithSeviceAndCharacteristic];
        [self initPropert];
        _macData = data;
    }
    return self;
}

-(void)setActivePeripheral:(CBPeripheral *)AP{
    _activePeripheral = AP;
    NSString *auuid = [[NSString alloc]initWithFormat:@"%@", _activePeripheral.UUID];
    if (auuid.length >= 36) {
        _uuidString = [auuid substringWithRange:NSMakeRange(auuid.length-36, 36)];
    }
}

-(void)initAlert{
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])  {
        // 中文
        autosetAlert = [[UIAlertView alloc]initWithTitle:@"自动设置出错"
                                                 message:@"是否再次设置?"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
    }
    else{
        // English
        autosetAlert = [[UIAlertView alloc]initWithTitle:@"AUTOSET ERROR"
                                                 message:@"Do you try again?"
                                                delegate:self
                                       cancelButtonTitle:@"Cannel"
                                       otherButtonTitles:@"OK", nil];
    }
    [autosetAlert setDelegate:(id<UIAlertViewDelegate>)self];
}

-(void)initPeripheralWithSeviceAndCharacteristic{
    // CBPeripheral
    [_activePeripheral setDelegate:nil];
    _activePeripheral = nil;
    // CBService and CBCharacteristic
    _AntilostServiceService = nil;
    _AntilostRWControlValueCharateristic = nil;
    _AntilostRWNameCharateristic = nil;
    _AntilostRNKeypressedValueCharateristic = nil;
    _AntilostRNCurrentRssiCharateristic = nil;
    _AntilostRNBatteryCharateristic = nil;
    
    _currentPeripheralState = blePeripheralDelegateStateInit;
    _connectedFinish = NO;
}

-(void)initPropert{
    // Property
    _macData                    = nil;
    _uuidString                 = nil;
    _choosePicture              = nil;
    
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])  {
        // 中文
        _nameString             = @"防丢器";
    }
    else{
        // English
        _nameString             = @"Antilost";
    }
    
    _toggleAlarmValue           = kDefaultAlarmRssi;
    _enabelFlashLabel           = NO;
    _enabelFlashLight           = YES;
    _enabelVibrate              = YES;
    _enabelPushMsg              = YES;
    _enabelMute                 = NO;
    _alarmSoundID               = 0;
    
    InitAlarmPlayer
    InitDisconnectPlayer
    InitKeyPlayer
       [self defaultRing];
    InitAutoSetupFinishPlayer

    
    _enabelAlarmTimer           = YES;
    _timerOnHour                = 8;
    _timerOnMinute              = 0;
    _timerOffHour               = 20;
    _timerOffMinute             = 0;
    _holdKeyPressedFunctions    = kHoldKeyDisabel;
    
    _cv                         = [[controlValue alloc]init];
    _cv.AntilostPoweOn          = YES;
    _cv.EnabelAntilostWork      = NO;
    _cv.alarmSoundState         = kStopAlarmState;
    _cv.connectionInterval      = kSlowRssiResponseRate;
    
    _currentTxRssi              = 0;
    _TxFilteringValue           = 0;
    _txRssiArray                = [[NSMutableArray alloc]init];
    //_currentRxRssi              = 0;
    _currentBattery             = 0;
    
    // 提示消息
    [self initAlert];
}
#pragma mark- 调用系统默认铃声
-(void)defaultRing
{
//    AudioServicesPlaySystemSound(1108);//新邮件消息提示
}

#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*						   		Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startPeripheral:(CBPeripheral *)peripheral DiscoverServices:(NSArray *)services{
    if ([peripheral isEqual:_activePeripheral] && [peripheral isConnected]){
        _activePeripheral = peripheral;
        [_activePeripheral setDelegate:(id<CBPeripheralDelegate>)self];
        [_activePeripheral discoverServices:services];
        
        // 如果正在断开连接报警则停止
        
        _enabelFlashLabel = NO;
        if (alarmPlayer.isPlaying == YES) {
            [alarmPlayer stop];
        }
        if (disconnectPlayer.isPlaying == YES) {
            [disconnectPlayer stop];
        }
        // 如果LED灯在闪烁则停止
        if (flashLightTimer.isValid == YES){
            [flashLightTimer invalidate];
            flashLightTimer = nil;
            [self turnOffLed];
        }
    }
}

-(void)disconnectPeripheral:(CBPeripheral *)peripheral{
    if ([peripheral isEqual:_activePeripheral]){
        // 内存释放 CBPeripheral & CBService & CBCharacteristic = nil 
        [self initPeripheralWithSeviceAndCharacteristic];
        
        // Property
        _currentPeripheralState = blePeripheralDelegateStateInit;
        _connectedFinish = NO;
        
        if (disconnectPlayer.isPlaying == NO && alarmPlayer.isPlaying == NO) {
            InitDisconnectPlayer                             //注释播放报警音
//            if (_enabelMute == YES) {
//                disconnectPlayer.volume = MuteVolume;
//            }
//            [disconnectPlayer play];
            
            _enabelFlashLabel = YES;
            if (_enabelFlashLight == YES) {
                if (flashLightTimer.isValid == NO) {
                    [flashLightTimer invalidate];
//                    onOrOffLight = YES;
                    flashLightTimer = [NSTimer scheduledTimerWithTimeInterval:1/(float)kFlashLightFrg target:self selector:@selector(flashLightEvent) userInfo:nil repeats:YES];
                }
            }
            
            if (_enabelVibrate) {
                SystemVibrate
            }
            
            if (_enabelPushMsg == YES) {
                // 推送消息

                if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])  {
                    // 中文
                    nTitle = @"断开连接";
                    nDetail = [[NSString alloc]initWithFormat:@"%@断开连接报警",_nameString];;
                }
                else{
                    // English
                    nTitle = @"DISCONNECT";
                    nDetail = [[NSString alloc]initWithFormat:@"%@ is disconnect",_nameString];;
                }
                SystemVibrate
  
                UILocalNotification *ln = [[UILocalNotification alloc]init];
                ln.alertBody = nDetail;
                UIApplication *app = [UIApplication sharedApplication];
                [app scheduleLocalNotification:ln];
                
                if(notificationTimer.isValid == NO){
                    [notificationTimer invalidate];
                    notificationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(notificationEvent) userInfo:nil repeats:NO];
                }
            }
        }
    }
}
-(void)notificationEvent
{
    [MPNotificationView notifyWithText:nTitle
                                detail:nDetail
                                 image:_choosePicture
                           andDuration:5.0];
}
#pragma mark -
#pragma mark CBPeripheral
/****************************************************************************/
/*                              CBPeripheral								*/
/****************************************************************************/
// 更新RSSI
//- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{}

// 扫描服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error)
    {
        if ([peripheral isEqual:_activePeripheral]){
            // 新建服务数组
            NSArray *services = [peripheral services];
            if (!services || ![services count])
            {
                NSLog(@"发现错误的服务 %@\r\n", peripheral.services);
            }
            else
            {
                // 开始扫描服务
                _currentPeripheralState = blePeripheralDelegateStateDiscoverServices;
                nPeripheralStateChange
                for (CBService *services in peripheral.services)
                {
                    NSLog(@"发现服务UUID: %@\r\n", services.UUID);
                    //===================== AntiLost ========================FE20
                    if ([[services UUID] isEqual:[CBUUID UUIDWithString:kAntilostServiceUUID]]){
                        // 扫描服务特征值UUID
                        _AntilostServiceService = services;
                        [peripheral discoverCharacteristics:nil forService:_AntilostServiceService];
                    }
                    //======================== END =========================
                }
            }
        }
    }
}

// 从服务中扫描特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (!error) {
        if ([peripheral isEqual:_activePeripheral]){
            // 开始扫描特征值
            _currentPeripheralState = blePeripheralDelegateStateDiscoverCharacteristics;
            nPeripheralStateChange
            // 新建特征值数组
            NSArray *characteristics = [service characteristics];
            CBCharacteristic *characteristic;
            //===================== AntiLost ========================FE21、FE22、FE23、FE24、FE25
            if ([[service UUID] isEqual:[CBUUID UUIDWithString:kAntilostServiceUUID]])
            {
                for (characteristic in characteristics)
                {
                    NSLog(@"发现特值UUID: %@\n", [characteristic UUID]);
                    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRWControlValueCharateristicUUID]])
                    {
                        _AntilostRWControlValueCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRWNameCharateristicUUID]])
                    {
                        _AntilostRWNameCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRNKeypressedValueCharateristicUUID]])
                    {
                        _AntilostRNKeypressedValueCharateristic = characteristic;
                        [self notification:peripheral characteristicUUID:_AntilostRNKeypressedValueCharateristic state:YES];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRNCurrentRssiCharateristicUUID]])
                    {
                        _AntilostRNCurrentRssiCharateristic = characteristic;
                        [self notification:peripheral characteristicUUID:_AntilostRNCurrentRssiCharateristic state:YES];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRNBatteryCharateristicUUID]])
                    {
                        _AntilostRNBatteryCharateristic = characteristic;
                        [self notification:peripheral characteristicUUID:_AntilostRNBatteryCharateristic state:YES];
                        [self readValue:peripheral characteristicUUID:_AntilostRNBatteryCharateristic];
                        // 完成连接
                        [self FinishLink];
                    }
                }
            }
            //======================== END =========================
        }
    }
}

// 更新特征值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if ([error code] == 0) {
        if ([peripheral isEqual:_activePeripheral]){
            //===================== AntiLost ========================FE21、FE22、FE23、FE24、FE25
            // 控制数据
            if ([characteristic isEqual:_AntilostRNKeypressedValueCharateristic])
            {
                [self updataKeypressedValue:_AntilostRNKeypressedValueCharateristic.value];
            }
            
            else if ([characteristic isEqual:_AntilostRNCurrentRssiCharateristic])
            {
                [self updataCurrentTxRssi:_AntilostRNCurrentRssiCharateristic.value];
            }
            
            else if ([characteristic isEqual:_AntilostRNBatteryCharateristic])
            {
                [self updataCurrentBattery:_AntilostRNBatteryCharateristic.value];
            }
            //======================== END =========================
            [peripheral readRSSI];
        }
    }
    else{
        NSLog(@"参数更新出错: %d",[error code]);
    }
}


#pragma mark -
#pragma mark Set updata
/******************************************************/
//              更析特征值数据                           //
/******************************************************/
-(void)updataKeypressedValue:(NSData *)data{
    Byte KeypressedByte[ANTILOST_RN_KEYPRESSED_LENGTH];
    bool checkout = YES;
    if (ENABLE_ENCODE == YES) {
        Byte EncodeKeypressedValue[ANTILOST_RN_KEYPRESSED_LENGTH+1];
        
        [data getBytes:EncodeKeypressedValue length:ANTILOST_RN_KEYPRESSED_LENGTH+1];
        checkout = [self arrayCrcDecode:ANTILOST_RN_KEYPRESSED_LENGTH encodeArray:EncodeKeypressedValue decodeArray:KeypressedByte];
    }
    else{
        [data getBytes:KeypressedByte length:ANTILOST_RN_KEYPRESSED_LENGTH];
    }
    
    if (checkout == YES) {
        Byte keyPressed = KeypressedByte[0];
        
        static Byte KeyPressedBack = 0xFF;
        if (KeyPressedBack != keyPressed) {
            KeyPressedBack = keyPressed;
            // 改变时进入
            if (keyPressed == 1) {
                if (holdKeyPressedTimer.isValid == YES) {
                    [holdKeyPressedTimer invalidate];
                }
                holdKeyPressedTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(holdKeyFunctionEvent) userInfo:nil repeats:NO];
            }
            else{
                if (holdKeyPressedTimer.isValid == YES) {
                    [holdKeyPressedTimer invalidate];
                    holdKeyPressedTimer = nil;
                    // 单次按键功能
                    [self singleKeyPressedUpEvent];
                }
            }
        }
    }
}

-(void)updataCurrentTxRssi:(NSData *)data{
    Byte txRssi[ANTILOST_RN_CURRENT_RSSI_LENGTH];
    bool checkout = YES;
    if (ENABLE_ENCODE == YES) {
        Byte EncodeTxRssi[ANTILOST_RN_CURRENT_RSSI_LENGTH+1];
        
        [data getBytes:EncodeTxRssi length:ANTILOST_RN_CURRENT_RSSI_LENGTH+1];
        checkout = [self arrayCrcDecode:ANTILOST_RN_CURRENT_RSSI_LENGTH encodeArray:EncodeTxRssi decodeArray:txRssi];
    }
    else{
        [data getBytes:txRssi length:ANTILOST_RN_CURRENT_RSSI_LENGTH];
    }
    
    if (checkout == YES) {
        _currentTxRssi = (char)-txRssi[0];
        nTxRssi
        [_txRssiArray insertObject:[NSNumber numberWithChar:_currentTxRssi] atIndex:0];
        
        
        if (_txRssiArray.count >= kRssiResponseRate) {
            // 如果采样的个数超过过滤值
            UInt16 txRssiSum = 0;
            for (Byte idx=0; idx<kRssiResponseRate; idx++) {
                txRssiSum += [[_txRssiArray objectAtIndex:idx]charValue];
            }
            _TxFilteringValue = (Byte)((float)txRssiSum/(float)kRssiResponseRate);
            //NSLog(@"Name:%@ TxFilteringValue:%d",_nameString , _TxFilteringValue);
        }
        
        if (_cv.EnabelAntilostWork == YES) {
            // 如果开启防丢功能检测报警条件
            [self CheckTxRssiIfAlarm];
        }
        else{
            _antilostAlarmWorkStart = NO;
        }
    }
}

-(void)updataCurrentBattery:(NSData *)data{
    Byte batteryValue[ANTILOST_RN_CURRENT_BATTERY_LENGTH];
    bool checkout = YES;
    if (ENABLE_ENCODE == YES) {
        Byte EncodeBatteryValue[ANTILOST_RN_CURRENT_BATTERY_LENGTH+1];
        
        [data getBytes:EncodeBatteryValue length:ANTILOST_RN_CURRENT_BATTERY_LENGTH+1];
        checkout = [self arrayCrcDecode:ANTILOST_RN_CURRENT_BATTERY_LENGTH encodeArray:EncodeBatteryValue decodeArray:batteryValue];
    }
    else{
        [data getBytes:batteryValue length:ANTILOST_RN_CURRENT_BATTERY_LENGTH];
    }
    
    if (checkout == YES) {
        _currentBattery = batteryValue[0];
    }
}

#pragma mark -
#pragma mark Set property
/******************************************************/
//              BLE属性操作函数                          //
/******************************************************/
-(void)FinishLink{
    [connectedFinishTimer invalidate];
    connectedFinishTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(connectedFinishEvent) userInfo:nil repeats:NO];
}

-(void)connectedFinishEvent{
    [connectedFinishTimer invalidate];
    connectedFinishTimer = nil;
    
    // 更新标志
    _connectedFinish = YES;
    _currentPeripheralState = blePeripheralDelegateStateKeepActive;
    nPeripheralStateChange
    
    // 连接完成提示
    if (_enabelMute == NO) {
        InitConnectPlayer
        [connectPlayer play];
        //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        SystemVibrate
    }
    if (_enabelVibrate == YES) {
        SystemVibrate
    }
    
    // 检测定时与工作模式
    [self setEnabelAntilostWork:_cv.EnabelAntilostWork];
    [self setEnabelAlarmTimer:_enabelAlarmTimer];
    NSLog(@"连接完成\n  uuidString:%@",_uuidString);
}
-(void)setEnabelAntilostWork:(BOOL)enabelAntilostWork{
    _cv.EnabelAntilostWork = enabelAntilostWork;
    if (_cv.EnabelAntilostWork == YES) {
        _cv.connectionInterval = kHighRssiResponseRate;
        [self sendControlValueEvent];
        if (checkOutrangeAlarmTimer != nil) {
            [checkOutrangeAlarmTimer invalidate];
        }
        checkOutrangeAlarmTimer = [NSTimer scheduledTimerWithTimeInterval:CheckOutrangeTime target:self selector:@selector(outrangeAlarmEvent) userInfo:nil repeats:YES];
    }
    else{
        _cv.connectionInterval = kSlowRssiResponseRate;
        [self sendControlValueEvent];
        if (alarmPlayer.isPlaying == YES) {
            [alarmPlayer stop];
        }
    
        if (disconnectPlayer.isPlaying == YES) {
            [disconnectPlayer stop];
        }
        
        if (flashLightTimer.isValid == YES) {
            [flashLightTimer invalidate];
            flashLightTimer = nil;
            [self turnOffLed];
        }
    }
}

-(void)setEnabelAlarmTimer:(BOOL)enabelAlarmTimer{
    _enabelAlarmTimer = enabelAlarmTimer;
    if (_enabelAlarmTimer == YES) {
        if (checkWorkOnOffTimer.isValid == NO) {
            [checkWorkOnOffTimer invalidate];
            checkWorkOnOffTimer = [NSTimer scheduledTimerWithTimeInterval:60.f target:self selector:@selector(CheckWorkOnOffEvent) userInfo:nil repeats:YES];
            [checkWorkOnOffTimer fire];
        }
    }
    else{
        if (checkWorkOnOffTimer.isValid == YES) {
            [checkWorkOnOffTimer invalidate];
            checkWorkOnOffTimer = nil;
        }
    }
}

-(void)CheckWorkOnOffEvent{
    UInt16 currentTimeValue = [self getCurrentTime];
    UInt16 timerOnValue, timerOffValue;
    if (_timerOffHour > _timerOnHour) {
        // 当天开，当天关
        Byte timerOnByte[2] = {_timerOnHour, _timerOnMinute };
        Byte timerOffByte[2] = {_timerOffHour, _timerOffMinute };
        timerOnValue = BUILD_UINT16(timerOnByte[1], timerOnByte[0]);
        timerOffValue = BUILD_UINT16(timerOffByte[1], timerOffByte[0]);
    }
    else{
        // 当天开，隔天关
        Byte timerOnByte[2] = {_timerOnHour, _timerOnMinute };
        Byte timerOffByte[2] = {_timerOffHour+24, _timerOffMinute };
        timerOnValue = BUILD_UINT16(timerOnByte[1], timerOnByte[0]);
        timerOffValue = BUILD_UINT16(timerOffByte[1], timerOffByte[0]);
    }
    
    if ((currentTimeValue >= timerOnValue) && (currentTimeValue < timerOffValue)) {
        // 关闭防丢功能
        [self setEnabelAntilostWork:YES];
    }
    else{
        // 开启防丢功能
        [self setEnabelAntilostWork:NO];
    }
}

-(UInt16)getCurrentTime{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    //Byte CurrentYear = [dateComponent year];
    //Byte CurrentMonth = [dateComponent month];
    //Byte CurrentDay = [dateComponent day];
    Byte CurrentHour = [dateComponent hour];
    Byte CurrentMinut = [dateComponent minute];
    return BUILD_UINT16(CurrentMinut, CurrentHour);
}

-(void)singleKeyPressedUpEvent{
    NSLog(@"keyPressed");
    if (_enabelFlashLabel == YES) {
        _enabelFlashLabel= NO;
        _cv.alarmSoundState = kStopAlarmState;
        [self sendControlValueEvent];
        [self setEnabelAntilostWork:NO];
    }
    else{
        if (alarmPlayer.isPlaying == NO) {
            if (keyPlayer.isPlaying == YES) {
                [keyPlayer stop];
                [flashLightTimer invalidate];
                [self turnOffLed];
            }
            else{
                if (keyPlayer.isPlaying == NO) {
                    InitKeyPlayer
                    [self defaultRing];
                    [keyPlayer play];
                    
                    if (_enabelVibrate == YES) {
                        // 震动
                        SystemVibrate
                    }
                    
                    if (_enabelFlashLight == YES) {
                        if (flashLightTimer.isValid == NO) {
                            [flashLightTimer invalidate];
                            count = 0;
                            flashLightTimer = [NSTimer scheduledTimerWithTimeInterval:1/(float)kFlashLightFrg target:self selector:@selector(flashLightEvent) userInfo:nil repeats:YES];
                        }
                    }
                    
                    if (_enabelPushMsg) {
                        // 推送消息
                        //                    NSString *nTitle, *nDetail;
                        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])  {
                            // 中文
                            nTitle = @"寻找手机";
                            nDetail = [[NSString alloc]initWithFormat:@"%@寻找手机",_nameString];
                        }
                        else{
                            // English
                            nTitle = @"FOUND";
                            nDetail = [[NSString alloc]initWithFormat:@"%@ is found",_nameString];;
                        }
                        UILocalNotification *ln = [[UILocalNotification alloc]init];
                        ln.alertBody = nDetail;
                        UIApplication *app = [UIApplication sharedApplication];
                        [app scheduleLocalNotification:ln];
                        
                        [MPNotificationView notifyWithText:nTitle
                                                    detail:nDetail
                                                     image:_choosePicture
                                               andDuration:5.0];
                        
                    }
                }
            }
        }
    }
}

-(void)holdKeyFunctionEvent{
    if (holdKeyPressedTimer.isValid == YES) {
        [holdKeyPressedTimer invalidate];
        holdKeyPressedTimer = nil;
    }
    // 长按按键功能
    switch (_holdKeyPressedFunctions) {
        case kHoldKeySetupDistance:
        {
            // 设定距离
            [self autoSetupToggleAlarmValue];
        }
            break;
            
        case kHoldKeyWorkOnOff:
        {
            // 开关防丢
            NSLog(@"%d %d",_enabelAlarmTimer, !_enabelAlarmTimer);
            if (_enabelAlarmTimer == YES) {
                [self setEnabelAlarmTimer:NO];
                [self setEnabelAntilostWork:NO];
            }
            else{
                [self setEnabelAlarmTimer:YES];
                [self setEnabelAntilostWork:YES];
            }
            nPeripheralStateChange
            
        }
            break;
            
        default:
            break;
    }
}

-(void)autoSetupToggleAlarmValue{
    if (abs(_TxFilteringValue - _currentTxRssi) < MaxRssiABS ) {
        // 更新设定值
        if ((_TxFilteringValue + abs(_TxFilteringValue - _currentTxRssi)) > kMaxSetResponseRssiValue) {
            _toggleAlarmValue = kMaxSetResponseRssiValue;
        }
        else if ((_TxFilteringValue + abs(_TxFilteringValue - _currentTxRssi)) < kMinSetResponseRssiValue){
            _toggleAlarmValue = kMinSetResponseRssiValue;
        }
        else{
            _toggleAlarmValue = _TxFilteringValue + abs(_TxFilteringValue - _currentTxRssi);
        }
        
        _cv.EnabelAntilostWork = NO;
        
        
        // 提醒学习完成
        [autoSetupFinishPlayer play];
        nPeripheralStateChange
        if (_enabelVibrate == YES) {
            SystemVibrate
        }
        
        _cv.alarmSoundState= kStopAlarmState;
        [self sendControlValueEvent];
        
        _cv.alarmSoundState = kSetupValueState;
        [self sendControlValueEvent];
        
    }
    else{
        [autosetAlert show];
    }
}

-(void)CheckTxRssiIfAlarm{
    if (_cv.EnabelAntilostWork == YES) {
        if (_TxFilteringValue > _toggleAlarmValue) {
            // 使能报警
            _antilostAlarmWorkStart = YES;
            //nPeripheralStateChange
        }
        if (_TxFilteringValue < kStopAlarmRxRssi) {
            // 停止报警
            _antilostAlarmWorkStart = NO;
            //nPeripheralStateChange
        }
    }
}

-(void)outrangeAlarmEvent{
    if (_antilostAlarmWorkStart == YES) {
        // 超出距离 警告或防丢模式报警
        if (alarmPlayer.isPlaying == NO){
            [UIApplication sharedApplication].applicationIconBadgeNumber++;
            
            _cv.alarmSoundState = kAlarmValueState;
            [self sendControlValueEvent];
            nPeripheralStateChange
        
            if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])
            {
                // 中文
                nTitle = @"超出范围";
                nDetail = [[NSString alloc]initWithFormat:@"%@超出范围报警",_nameString];
            }
            else{
                // English
                nTitle = @"OUTRANGE";
                nDetail = [[NSString alloc]initWithFormat:@"%@ is outrange",_nameString];
            }
            
            if (_alarmSoundID >= audioArray.count) { //录音报警////////////////////////////////////////////////////////////////////////////////
                //                _alarmSoundID = 0;
                NSLog(@"_alarmSoundID   报警录音");
                // 设置系统音量
                if (SystemVolume != 1.0) {
                    SystemVolume = 1.0;
                }
                if(recorderModel ==nil)
                {
                    recorderModel = [RecorderModel new];
                }
                if(![recorderModel playing])
                {
                    [recorderModel playRecordEvent:_recordID isLoop:YES];
                    [MPNotificationView notifyWithText:nTitle
                                                detail:nDetail
                                                 image:_choosePicture
                                           andDuration:5.0];
                }
            }else{ //铃声报警
                InitAlarmPlayer
                if (_enabelMute == YES) {
                    alarmPlayer.volume = MuteVolume;
                }
                [alarmPlayer play];
                recorderModel = nil;  //让recorderModel为空
            }
            
            
//            _enabelFlashLabel = YES; 
            
//            if (_enabelFlashLight == YES) {
//                if (flashLightTimer.isValid == NO) {
//                    [flashLightTimer invalidate];
//                    flashLightTimer = [NSTimer scheduledTimerWithTimeInterval:1/(float)kFlashLightFrg target:self selector:@selector(flashLightEvent) userInfo:nil repeats:YES];
//                }
//            }
//            
            if (_enabelVibrate) {
                SystemVibrate
                
            }
            if (_enabelPushMsg) {
                // 推送消息
//                NSString *nTitle, *nDetail;
             
                
                if(recorderModel == nil)
                {
                
                    [MPNotificationView notifyWithText:nTitle
                                                    detail:nDetail
                                                     image:_choosePicture
                                               andDuration:5.0];
                    UILocalNotification *ln = [[UILocalNotification alloc]init];
                    ln.alertBody = nDetail;
                    UIApplication *app = [UIApplication sharedApplication];
                    [app scheduleLocalNotification:ln];
                    
                }else if(recorderModel !=nil && [recorderModel getNotificationBoolean]){
                  
                    NSLog(@"弹出的消息  %@",nTitle);
                    [MPNotificationView notifyWithText:nTitle
                                                detail:nDetail
                                                 image:_choosePicture
                                           andDuration:5.0];
                    
                    UILocalNotification *ln = [[UILocalNotification alloc]init];
                    ln.alertBody = nDetail;
                    UIApplication *app = [UIApplication sharedApplication];
                    [app scheduleLocalNotification:ln];
                    
                    [recorderModel setNotifitcationBoolean:NO];
                }
            }
        }
    }
    else{
        if (alarmPlayer.isPlaying == YES) {
            _cv.alarmSoundState = kStopAlarmState;
            [self sendControlValueEvent];
            
             if (_alarmSoundID < audioArray.count)
             {
                // 停止报警
                [alarmPlayer stop];
             }
            
            _enabelFlashLabel = NO;
            
            if (_enabelFlashLight == YES) {
                if (flashLightTimer.isValid == YES) {
                    [flashLightTimer invalidate];
                    
                    flashLightTimer = nil;
                    [self turnOffLed];
                }
            }
        }
        if(recorderModel.playing)
        {
            if (_alarmSoundID >= audioArray.count)
            {
                [recorderModel stopPlayRecordEvent];
            }
            
            _cv.alarmSoundState = kStopAlarmState;
            [self sendControlValueEvent];
            
            _enabelFlashLabel = NO;
            
            if (_enabelFlashLight == YES) {
                if (flashLightTimer.isValid == YES) {
                    [flashLightTimer invalidate];
                    
                    flashLightTimer = nil;
                    [self turnOffLed];
                }
            }
        }
    }
}

-(void)sendControlValueEvent{
    NSData *sendControlValueData;
    Byte ControlValueByte[ANTILOST_RW_CONTROL_VALUE_LENGTH] = {_cv.AntilostPoweOn, _cv.EnabelAntilostWork, _cv.alarmSoundState, _cv.connectionInterval };
    NSLog(@"ControlValueByte:%02d %02d %02d %02d", _cv.AntilostPoweOn, _cv.EnabelAntilostWork, _cv.alarmSoundState, _cv.connectionInterval);
    if (ENABLE_ENCODE == YES) {
        // 加密
        Byte EncodeControlValueByte[ANTILOST_RW_CONTROL_VALUE_LENGTH+1];
        [self arrayCrcEncode:ANTILOST_RW_CONTROL_VALUE_LENGTH encodeArray:EncodeControlValueByte decodeArray:ControlValueByte];
        sendControlValueData = [[NSData alloc]initWithBytes:&EncodeControlValueByte length:ANTILOST_RW_CONTROL_VALUE_LENGTH+1];
    }
    else{
        sendControlValueData = [[NSData alloc]initWithBytes:&ControlValueByte length:ANTILOST_RW_CONTROL_VALUE_LENGTH];
    }
    
    static NSData *sendControlValueDataBack = nil;
    if (![sendControlValueData isEqualToData:sendControlValueDataBack]) {
        sendControlValueDataBack = sendControlValueData;
        [self writeValue:_activePeripheral characteristic:_AntilostRWControlValueCharateristic data:sendControlValueData];
        //NSLog(@"sendControlValueData:%@",sendControlValueData);
    }
}

-(void)setActiveAntiLostProperty:(NSDictionary *)aalp{
    _activeAntiLostProperty = aalp;
    //if (_activeAntiLostProperty.count == 17) {
        _macData = [_activeAntiLostProperty objectForKey:@"macData"];                                                       // 0
        _uuidString = [_activeAntiLostProperty objectForKey:@"uuidString"];                                                 // 1
        _choosePicture = [UIImage imageWithData:[_activeAntiLostProperty objectForKey:@"choosePicture"]];                   // 2
        _nameString = [_activeAntiLostProperty objectForKey:@"nameString"];                                                 // 3
        _cv.EnabelAntilostWork = [[_activeAntiLostProperty objectForKey:@"enabelAntilostWork"] boolValue];                  // 4
        _toggleAlarmValue = [[_activeAntiLostProperty objectForKey:@"toggleAlarmValue"] unsignedCharValue];                 // 5
        _enabelFlashLight = [[_activeAntiLostProperty objectForKey:@"enabelFlashLight"] boolValue];                         // 6
        _enabelVibrate = [[_activeAntiLostProperty objectForKey:@"enabelVibrate"] boolValue];                               // 7
        _enabelPushMsg = [[_activeAntiLostProperty objectForKey:@"enabelPushMsg"] boolValue];                               // 8
        _enabelMute = [[_activeAntiLostProperty objectForKey:@"enabelMute"] boolValue];                                     // 9
        _alarmSoundID = [[_activeAntiLostProperty objectForKey:@"alarmSoundID"] unsignedCharValue];                         // 10
        _enabelAlarmTimer = [[_activeAntiLostProperty objectForKey:@"enabelAlarmTimer"] boolValue];                         // 11
        _timerOnHour = [[_activeAntiLostProperty objectForKey:@"timerOnHour"] unsignedCharValue];                           // 12
        _timerOnMinute = [[_activeAntiLostProperty objectForKey:@"timerOnMinute"] unsignedCharValue];                       // 13
        _timerOffHour = [[_activeAntiLostProperty objectForKey:@"timerOffHour"] unsignedCharValue];                         // 14
        _timerOffMinute = [[_activeAntiLostProperty objectForKey:@"timerOffMinute"] unsignedCharValue];                     // 15
        _holdKeyPressedFunctions = [[_activeAntiLostProperty objectForKey:@"holdKeyPressedFunctions"] unsignedCharValue];   // 16
        
        _recordID = [_activeAntiLostProperty objectForKey:@"recordID"] ;   //Kevin添加
        
        //NSLog(@"读取数据：%@",_activeAntiLostProperty);
    //}
}

-(void)savedActiveAntiLostProperty{
    _activeAntiLostProperty = [[NSDictionary alloc]initWithObjectsAndKeys:
                               [[NSData alloc]initWithData:_macData],@"macData",                                            // 0
                               [[NSString alloc]initWithFormat:@"%@",_uuidString],@"uuidString",                            // 1
                               UIImagePNGRepresentation(_choosePicture),@"choosePicture",                                   // 2
                               [[NSString alloc]initWithFormat:@"%@",_nameString],@"nameString",                            // 3
                               [NSNumber numberWithBool:_cv.EnabelAntilostWork],@"enabelAntilostWork",                      // 4
                               [NSNumber numberWithUnsignedChar:_toggleAlarmValue],@"toggleAlarmValue",                     // 5
                               [NSNumber numberWithBool:_enabelFlashLight],@"enabelFlashLight",                             // 6
                               [NSNumber numberWithBool:_enabelVibrate],@"enabelVibrate",                                   // 7
                               [NSNumber numberWithBool:_enabelPushMsg],@"enabelPushMsg",                                   // 8
                               [NSNumber numberWithBool:_enabelMute],@"enabelMute",                                         // 9
                               [NSNumber numberWithUnsignedChar:_alarmSoundID],@"alarmSoundID",                             // 10
                               [NSNumber numberWithBool:_enabelAlarmTimer],@"enabelAlarmTimer",                             // 11
                               [NSNumber numberWithUnsignedChar:_timerOnHour],@"timerOnHour",                               // 12
                               [NSNumber numberWithUnsignedChar:_timerOnMinute],@"timerOnMinute",                           // 13
                               [NSNumber numberWithUnsignedChar:_timerOffHour],@"timerOffHour",                             // 14
                               [NSNumber numberWithUnsignedChar:_timerOffMinute],@"timerOffMinute",                         // 15
                               [NSNumber numberWithUnsignedChar:_holdKeyPressedFunctions],@"holdKeyPressedFunctions",       // 16
                                [[NSString alloc]initWithFormat:@"%@",_recordID],@"recordID",
                               nil];
             //NSLog(@" save alarmSoundID  %d",_alarmSoundID);
    //NSLog(@"存储数据：%@",_activeAntiLostProperty);
}

-(AVAudioPlayer *)setPlayer:(AVAudioPlayer *)aPlayer AtIndex:(Byte)idx WithLoop:(char) loop{
    // 选择报警音源
    NSString *filePath = [[NSBundle mainBundle]pathForResource:[audioArray objectAtIndex:idx] ofType:@"mp3"];
    aPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:filePath] error:nil];
    aPlayer.currentTime = 0;
    aPlayer.volume = 1.0;
    aPlayer.numberOfLoops = loop;
    [aPlayer prepareToPlay];
    [aPlayer setDelegate:(id<AVAudioPlayerDelegate>)self];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //在后台工作的时候，使系统能够播发声音文件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    return aPlayer;
}

#pragma mark -
#pragma mark 录音控制
/******************************************************/
//              录音控制函数                             //
/******************************************************/
-(void)recordBegain{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                              [NSNumber numberWithInt: [self formatIndexToEnum:0]], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityLow], AVEncoderAudioQualityKey,
                              nil];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:kRecordPathList];
    NSError* error;
    _recorderPlayer = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:settings error:&error];
    
    NSLog(@"%@", [error description]);
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"your device doesn't support your setting"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    [_recorderPlayer prepareToRecord];
}

-(AVAudioPlayer *)getAudioPlayerFromRecorder{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:kRecordPathList];
    NSError* error;
    AVAudioPlayer *aPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    aPlayer.meteringEnabled = YES;
    aPlayer.currentTime = 0;
    aPlayer.volume = 1.0;
    aPlayer.numberOfLoops = -1.0;
    [aPlayer prepareToPlay];
    
    if (aPlayer == nil)
    {
        NSLog(@"ERror creating player: %@", [aPlayer description]);
    }
    [aPlayer setDelegate:(id<AVAudioPlayerDelegate>)self];
    
    return aPlayer;
}

- (NSInteger) formatIndexToEnum:(NSInteger) index
{
    //auto generate by python
    switch (index) {
        case 0: return kAudioFormatLinearPCM; break;
        case 1: return kAudioFormatAC3; break;
        case 2: return kAudioFormat60958AC3; break;
        case 3: return kAudioFormatAppleIMA4; break;
        case 4: return kAudioFormatMPEG4AAC; break;
        case 5: return kAudioFormatMPEG4CELP; break;
        case 6: return kAudioFormatMPEG4HVXC; break;
        case 7: return kAudioFormatMPEG4TwinVQ; break;
        case 8: return kAudioFormatMACE3; break;
        case 9: return kAudioFormatMACE6; break;
        case 10: return kAudioFormatULaw; break;
        case 11: return kAudioFormatALaw; break;
        case 12: return kAudioFormatQDesign; break;
        case 13: return kAudioFormatQDesign2; break;
        case 14: return kAudioFormatQUALCOMM; break;
        case 15: return kAudioFormatMPEGLayer1; break;
        case 16: return kAudioFormatMPEGLayer2; break;
        case 17: return kAudioFormatMPEGLayer3; break;
        case 18: return kAudioFormatTimeCode; break;
        case 19: return kAudioFormatMIDIStream; break;
        case 20: return kAudioFormatParameterValueStream; break;
        case 21: return kAudioFormatAppleLossless; break;
        case 22: return kAudioFormatMPEG4AAC_HE; break;
        case 23: return kAudioFormatMPEG4AAC_LD; break;
        case 24: return kAudioFormatMPEG4AAC_ELD; break;
        case 25: return kAudioFormatMPEG4AAC_ELD_SBR; break;
        case 26: return kAudioFormatMPEG4AAC_ELD_V2; break;
        case 27: return kAudioFormatMPEG4AAC_HE_V2; break;
        case 28: return kAudioFormatMPEG4AAC_Spatial; break;
        case 29: return kAudioFormatAMR; break;
        case 30: return kAudioFormatAudible; break;
        case 31: return kAudioFormatiLBC; break;
        case 32: return kAudioFormatDVIIntelIMA; break;
        case 33: return kAudioFormatMicrosoftGSM; break;
        case 34: return kAudioFormatAES3; break;
        default:
            return -1;
            break;
    }
}

#pragma mark -
#pragma mark LED闪烁
/******************************************************/
//              LED闪烁函数                             //
/******************************************************/
-(void) turnOnLed
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}
-(void) turnOffLed
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

-(void)flashLightEvent{
//    static

    if (count%2) {
            [self turnOnLed];
    }else{
        [self turnOffLed];
        if (count > 20) {
            // 闪烁10次 则停止闪烁
            count = 0;
            [flashLightTimer invalidate];
            flashLightTimer = nil;
        }
    }
    count ++;
}


#pragma mark -
#pragma mark read/write/notification
/******************************************************/
//          读写通知等基础函数                           //
/******************************************************/
// 写数据到特征值
-(void) writeValue:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data{
    if ([peripheral isEqual:_activePeripheral] && [peripheral isConnected])
    {
        if (characteristic != nil) {
            NSLog(@"成功写数据到特征值: %@ 数据:%@\n", characteristic.UUID, data);
            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

// 从特征值读取数据
-(void) readValue:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic{
    if ([peripheral isEqual:_activePeripheral] && [peripheral isConnected])
    {
        if (characteristic != nil) {
            NSLog(@"成功从特征值:%@ 读数据\n", characteristic);
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

// 发通知到特征值
-(void) notification:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic state:(BOOL)state{
    if ([peripheral isEqual:_activePeripheral] && [peripheral isConnected])
    {
        if (characteristic != nil) {
            NSLog(@"成功发通知到特征值: %@\n", characteristic);
            [peripheral setNotifyValue:state forCharacteristic:characteristic];
        }
    }
}

#pragma mark -
#pragma mark 数据加密解密
-(void)arrayCrcEncode:(Byte)arrayLengh encodeArray:(Byte *)arrayEncode decodeArray:(Byte *)arrayDecode{
    // 计算crcChecksum
	Byte crcChecksum = [self CRC_Checksum:arrayLengh Array:arrayDecode];
    
    // 生成新数组
    arrayEncode[0] = crcChecksum;
    for(Byte idx=0; idx<arrayLengh; idx++)
    {
        arrayEncode[idx+1] = crcChecksum ^ arrayDecode[idx];
    }
}

-(BOOL)arrayCrcDecode:(Byte)arrayLengh encodeArray:(Byte *)arrayEncode decodeArray:(Byte *)arrayDecode{
    bool checkout = NO;
    // 生成新数组
    for(Byte idx=0; idx<arrayLengh; idx++)
    {
        arrayDecode[idx] = arrayEncode[0] ^ arrayEncode[idx+1];
    }
    
    // 计算crcChecksum
	Byte crcChecksum = [self CRC_Checksum:arrayLengh Array:arrayDecode];
    
    if (crcChecksum == arrayEncode[0])
    {
        checkout = YES;
    }
    
    return checkout;
}

-(Byte)CRC_Checksum:(Byte)arrayLengh Array:(Byte *)array{
    Byte i,j;
    
    Byte crcPassword[8] = CRCPASSWORD;
    Byte CRC_Checkout = 0x0;
    
    for (i=0;i<arrayLengh; i++)
    {
        Byte CRC_Temp = array[i];
        for (j=0;j<8;j++)
        {
            if (CRC_Temp & 0x01)
            {
                CRC_Checkout = CRC_Checkout ^ crcPassword[j];
            }
            CRC_Temp = CRC_Temp >> 1;
        }
    }
    return(CRC_Checkout);
}


#pragma mark -
#pragma mark Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%d",buttonIndex);
    
    if ([alertView isEqual:autosetAlert]) {
        if (buttonIndex == 1) {
            [self autoSetupToggleAlarmValue];
        }
    }
}


#pragma mark -
#pragma mark Enter Background/Foreground
-(void)CBEnterBackground{}

-(void)CBEnterForeground{}
@end
