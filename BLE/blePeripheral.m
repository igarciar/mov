//
//  blePeripheral.m
//  MonitoringCenter
//
//  Created by Ignacio Garcia on 13-1-10.
//
//

#import "blePeripheral.h"
#import "finderAppDelegate.h"
#import "RecorderModel.h"
#import "callEvent.h"

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
    //AVAudioPlayer           *disconnectPlayer;
    AVAudioPlayer           *connectPlayer;
    AVAudioPlayer           *keyPlayer;
    AVAudioPlayer           *autoSetupFinishPlayer;
    NSTimer                 *flashLightTimer;
    NSTimer                 *holdKeyPressedTimer;
    NSTimer                 *checkOutrangeAlarmTimer;
    NSTimer                 *checkWorkOnOffTimer;
    NSTimer                 *notificationTimer;
    NSTimer                 *connectedFinishTimer;
    NSTimer                 *autoReconnectTimer;
    
    UIAlertView             *autosetAlert;
    
    RecorderModel           *recorderModel;
    
    callEvent               *call;
    
    Byte                    count; //计算灯闪的次数
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
        [self initPropert];
        [self initPeripheralWithSeviceAndCharacteristic];
    }
    return self;
}

-(id)initWithPeripheralwithMacData:(NSData *)data{
    self = [super init];
    if (self) {
        [self initPropert];
        [self initPeripheralWithSeviceAndCharacteristic];
        _macData = data;
    }
    return self;
}
-(void)setActivePeripheral:(CBPeripheral *)activePeripheral{
    _activePeripheral = activePeripheral;
    NSString *auuid = [[NSString alloc]initWithFormat:@"%@",_activePeripheral.identifier.UUIDString];
//                       _activePeripheral.UUID];
    if (auuid.length >= 36) {
        _uuidString = [auuid substringWithRange:NSMakeRange(auuid.length-36, 36)];
    }
}

-(void)initAlert{
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"])  {
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
    _activePeripheral                       = nil;
    // CBService and CBCharacteristic
    _AntilostServiceService                 = nil;
    _AntilostRWControlValueCharateristic    = nil;
    _AntilostRWNameCharateristic            = nil;
    _AntilostRNKeypressedValueCharateristic = nil;
    _AntilostRNCurrentRssiCharateristic     = nil;
    _AntilostRNBatteryCharateristic         = nil;
    
    _currentPeripheralState     = blePeripheralStateInit;
    _connectedFinish            = NO;
    _antilostAlarmWorkStart     = NO;
    
    _cv.AntilostPoweOn          = YES;
    _cv.EnabelAntilostWork      = NO;
    _cv.alarmSoundState         = kStopAlarmState;
    _cv.connectionInterval      = kSlowRssiResponseRate;
    
    _currentTxRssi              = 0;
    _TxFilteringValue           = 0;
    _txRssiArray                = [[NSMutableArray alloc]init];
    //_currentRxRssi              = 0;
    _currentBattery             = 0;
    
    
}

-(void)initPropert{
    // Property
    _macData                    = nil;
    _uuidString                 = nil;
    _choosePicture              = [UIImage imageNamed:@"bolso_amarillo.png"];
    
//    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"])  {
//        // 中文
//        _nameString             = @"防丢器";
//    }
//    else{
        // English
        _nameString             = NSLocalizedString(@"AntilostName",nil);
//    }
    
    _toggleAlarmValue           = kDefaultAlarmRssi;
    _enabelFlashLabel           = NO;
    _enabelFlashLight           = YES;
    _enabelVibrate              = YES;
    _enabelPushMsg              = YES;
    _enabelMute                 = NO;
    _alarmSoundID               = 0;
    
    InitAlarmPlayer
    InitConnectPlayer
    //InitDisconnectPlayer
    InitKeyPlayer
    InitAutoSetupFinishPlayer
    [self setSession];
    
    _enabelAlarmTimer           = YES;
    _timerOnHour                = 8;
    _timerOnMinute              = 0;
    _timerOffHour               = 20;
    _timerOffMinute             = 0;
    _holdKeyPressedFunctions    = kHoldKeyDisabel;
    
    _cv                         = [[controlValue alloc]init];
    
    // 提示消息
    [self initAlert];

    // 电话事件
    call                        = [[callEvent alloc]init];
}

#pragma mark -
#pragma mark Alert
/****************************************************************************/
/*						   		AlertButton                                 */
/****************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    
    if ([alertView isEqual:autosetAlert]) {
        if (buttonIndex == 1) {
            [self autoSetupToggleAlarmValue];
        }
    }
}

#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*						   		Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startPeripheral:(CBPeripheral *)peripheral DiscoverServices:(NSArray *)services{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state==CBPeripheralStateConnected){
        _activePeripheral = peripheral;
        [_activePeripheral setDelegate:(id<CBPeripheralDelegate>)self];
        [_activePeripheral discoverServices:services];

        NSLog(@"%@开始扫描服务", _nameString);
        // 如果正在断开连接报警则停止
        _enabelFlashLabel = NO;
        //[self stopAlarm];
    }
}

-(void)disconnectPeripheral:(CBPeripheral *)peripheral{
    if ([peripheral isEqual:_activePeripheral]){
        NSLog(@"AntilostPoweOn:%d",_cv.AntilostPoweOn);
        if (_cv.EnabelAntilostWork == YES) {
            if (_cv.AntilostPoweOn == YES) {
                // 非主动断开
                if (_cv.EnabelAntilostWork == YES) {
                    [self startAlarm];
                }
                else{
                    if (_enabelVibrate == YES) {
                        SystemVibrate
                    }
                }
                _enabelFlashLabel = YES;
                if (_enabelPushMsg == YES){
                    [self pushMsg:@"断开连接报警" enMsg:@" is disconnect"];
                }
            }
            else{
                // 主动断开
                if (_enabelPushMsg == YES){
                    [self pushMsg:@"关机" enMsg:@" is power-off"];
                }
            }
        }
        
        // 内存释放 CBPeripheral & CBService & CBCharacteristic = nil 
        [self initPeripheralWithSeviceAndCharacteristic];
        
        [checkOutrangeAlarmTimer invalidate];
        checkOutrangeAlarmTimer = nil;
        
        // Property
        _currentPeripheralState = blePeripheralStateInit;
        nPeripheralStateChange
    }
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
    if (!error){
        if ([peripheral isEqual:_activePeripheral]){
            // 开始扫描服务
            NSArray *services = [peripheral services];
            if (!services || ![services count]){
                //NSLog(@"发现错误的服务 %@\r\n", peripheral.services);
            }
            else{
                // 开始扫描服务
                for (CBService *services in peripheral.services){
                    NSLog(@"servicioUUID: %@\r\n", services.UUID);
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
    if (!error){
        if ([peripheral isEqual:_activePeripheral]){
            // 开始扫描特征值
            NSArray *characteristics = [service characteristics];
            CBCharacteristic *characteristic;
            //===================== AntiLost ========================FE21、FE22、FE23、FE24、FE25
            if ([[service UUID] isEqual:[CBUUID UUIDWithString:kAntilostServiceUUID]]){
                for (characteristic in characteristics){
                    //NSLog(@"发现特值UUID: %@\n", [characteristic UUID]);
                    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRWControlValueCharateristicUUID]]){
                        _AntilostRWControlValueCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRWNameCharateristicUUID]]){
                        _AntilostRWNameCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRNKeypressedValueCharateristicUUID]]){
                        _AntilostRNKeypressedValueCharateristic = characteristic;
                        [self notification:peripheral characteristicUUID:_AntilostRNKeypressedValueCharateristic state:YES];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRNCurrentRssiCharateristicUUID]]){
                        _AntilostRNCurrentRssiCharateristic = characteristic;
                        [self notification:peripheral characteristicUUID:_AntilostRNCurrentRssiCharateristic state:YES];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kAntilostRNBatteryCharateristicUUID]]){
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
    NSLog(@"characteristic: %@",characteristic.value);
    if ([error code] == 0) {
        if ([peripheral isEqual:_activePeripheral]){
            //===================== AntiLost ========================FE21、FE22、FE23、FE24、FE25
            // 控制数据
            if ([characteristic isEqual:_AntilostRNKeypressedValueCharateristic]){
                [self updataKeypressedValue:_AntilostRNKeypressedValueCharateristic.value];
            }
            
            else if ([characteristic isEqual:_AntilostRNCurrentRssiCharateristic]){
                [self updataCurrentTxRssi:_AntilostRNCurrentRssiCharateristic.value];
            }
            
            else if ([characteristic isEqual:_AntilostRNBatteryCharateristic]){
                [self updataCurrentBattery:_AntilostRNBatteryCharateristic.value];
            }
            //======================== END =========================
            [peripheral readRSSI];
        }
    }
    else{
        NSLog(@"参数更新出错: %ld",(long)[error code]);
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
    
    if (checkout == YES){
        Byte keyPressed = KeypressedByte[0];
        
        static Byte KeyPressedBack = 0xFF;
        if (KeyPressedBack != keyPressed){
            KeyPressedBack = keyPressed;
            // 改变时进入
            if (keyPressed == 1){
                [holdKeyPressedTimer invalidate];
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
//            NSLog(@"Name:%@ TxFilteringValue:%d",_nameString , _TxFilteringValue);
        }
        
//        NSLog(@"%d  %d  %d",_cv.EnabelAntilostWork,_toggleAlarmValue,_currentTxRssi);
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
    connectedFinishTimer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(connectedFinishEvent) userInfo:nil repeats:NO];
    
    [autoReconnectTimer invalidate];
    autoReconnectTimer = [NSTimer scheduledTimerWithTimeInterval:60.f target:self selector:@selector(autoReconnectEvent) userInfo:nil repeats:NO];
}

-(void)autoReconnectEvent{
    [autoReconnectTimer invalidate];
    autoReconnectTimer = nil;
}

-(void)connectedFinishEvent{
    [connectedFinishTimer invalidate];
    connectedFinishTimer = nil;
    
    // 更新标志
    _connectedFinish = YES;
    _currentPeripheralState = blePeripheralStateConnected;
    nPeripheralStateChange
    
    // 连接完成提示
    if (connectPlayer.isPlaying == NO) {
        if (_enabelMute == YES) {
            connectPlayer.volume = 0.f;
        }
        else{
            connectPlayer.volume = 1.f;
        }
        [connectPlayer play];
    }
    
    if (_enabelVibrate == YES) {
        SystemVibrate
    }
    
    // 检测定时与工作模式
    [self setEnabelAntilostWork:_cv.EnabelAntilostWork];
    [self setEnabelAlarmTimer:_enabelAlarmTimer];
    NSLog(@"连接完成\n  uuidString:%@  %d",_uuidString,_cv.EnabelAntilostWork);
}

-(void)setEnabelAntilostWork:(BOOL)enabelAntilostWork{
    NSLog(@"antilost %d",enabelAntilostWork);
    _cv.EnabelAntilostWork = enabelAntilostWork;
    if (_cv.EnabelAntilostWork == YES) {
        _cv.connectionInterval = kNormolHRssiResponseRate;
        [self sendControlValueEvent];
        
        NSLog(@"antilost ");
        // 开启检测超距离功能
        [checkOutrangeAlarmTimer invalidate];
        checkOutrangeAlarmTimer = [NSTimer scheduledTimerWithTimeInterval:CheckOutrangeTime target:self selector:@selector(outrangeAlarmEvent) userInfo:nil repeats:YES];
    }
    else{
        _cv.connectionInterval = kSlowRssiResponseRate;
        [self sendControlValueEvent];
        // 停止报警警
        [self stopAlarm];
    }
}

-(void)setEnabelAlarmTimer:(BOOL)enabelAlarmTimer{
    NSLog(@"timer %d",enabelAlarmTimer);
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
    if(_activePeripheral.state==CBPeripheralStateConnected){
//    if (_activePeripheral.isConnected == YES) {
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
    if (keyPlayer.isPlaying == YES) {
        [keyPlayer stop];
        
        [flashLightTimer invalidate];
        flashLightTimer = nil;
        [self turnOffLed];
        
        _currentPeripheralState = blePeripheralStateSearchPhoneStop;
        nPeripheralStateChange
    }
    else{
        if (keyPlayer.isPlaying == NO) {
            if (connectPlayer.isPlaying == NO) {
                if (_enabelMute == YES) {
                    keyPlayer.volume = 0.f;
                }
                else{
                    keyPlayer.volume = 1.f;
                }
                keyPlayer.currentTime = 0.f;
                [keyPlayer play];
            }
            
            if (_enabelVibrate == YES) {
                SystemVibrate
            }
            
            if (_enabelFlashLight == YES) {
                [flashLightTimer invalidate];
                flashLightTimer = [NSTimer scheduledTimerWithTimeInterval:1/(float)kFlashLightFrg target:self selector:@selector(flashLightEvent) userInfo:nil repeats:YES];
            }
            
            if (_enabelPushMsg == YES) {
                [self pushMsg:@"寻找手机" enMsg:@" is found"];
            }
        }
        
        _currentPeripheralState = blePeripheralStateSearchPhoneStart;
        nPeripheralStateChange
    }
}

-(void)holdKeyFunctionEvent{
    [holdKeyPressedTimer invalidate];
    holdKeyPressedTimer = nil;
    
    _currentPeripheralState = blePeripheralStateHoldKeypressed;
    nPeripheralStateChange
    
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
            if (_enabelAlarmTimer == YES) {
                [self setEnabelAlarmTimer:NO];
                [self setEnabelAntilostWork:NO];
            }
            else{
                [self setEnabelAlarmTimer:YES];
                [self setEnabelAntilostWork:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)autoSetupToggleAlarmValue{
    if (abs(_TxFilteringValue - _currentTxRssi) < MaxRssiABS ) {
        // 更新设定值
        if ((_TxFilteringValue + abs(_TxFilteringValue - _currentTxRssi)) > kMaxSetResponseRssiValue){
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
    if (_cv.EnabelAntilostWork == YES){
        NSLog(@"callEventState:%@",call.callEventState);
        if (_TxFilteringValue > _toggleAlarmValue) {
            // 使能报警
            if (call.callEventState == CTCallStateDisconnected) {
                _antilostAlarmWorkStart = YES;
            }
        }
        if (_TxFilteringValue < kStopAlarmRxRssi) {
            // 停止报警
            _antilostAlarmWorkStart = NO;
        }
    }
}

-(void)outrangeAlarmEvent{
    if (_antilostAlarmWorkStart == YES) {
        // 超出距离 警告或防丢模式报警
        if ([self checkAlarmPlayerIsplaying] == NO) {
            _currentPeripheralState = blePeripheralStateAlarm;
            nPeripheralStateChange
            [self startAlarm];
            if (_enabelPushMsg == YES) {
                [self pushMsg:@"超出范围报警" enMsg:@" is outrange"];
            }
            _enabelFlashLabel = YES;
        }
    }
    else{
        if ([self checkAlarmPlayerIsplaying] == YES) {
            _currentPeripheralState = blePeripheralStateStopAlarm;
            nPeripheralStateChange
            [self stopAlarm];
            _enabelFlashLabel = NO;
        }
    }
}

-(BOOL)checkAlarmPlayerIsplaying{
    BOOL checkout = NO;
    if (_alarmSoundID >= audioArray.count) {
        NSLog(@"_alarmSoundID:%d报警录音",_alarmSoundID);
        if ([recorderModel playing] == YES) {
            checkout = YES;
        }
    }
    else{
        recorderModel = nil;
        if (alarmPlayer.isPlaying == YES) {
            checkout = YES;
        }
    }
    return checkout;
}

-(void)playAlarmPlayer{    
    if (_alarmSoundID >= audioArray.count) {
        if (recorderModel == nil) {
            recorderModel = [RecorderModel new];
        }
        if (recorderModel.playing == NO) {
            if (_enabelMute == NO) {
                if (SystemVolume != 1.0f) {
                    SystemVolume = 1.0f;
                }
                [recorderModel playRecordEvent:_recordID isLoop:YES];
            }
        }
    }
    else{
        if (alarmPlayer.isPlaying == NO) {
            InitAlarmPlayer
            if (_enabelMute == YES) {
                alarmPlayer.volume = 0.f;
            }
            else{
                alarmPlayer.volume = 1.f;
                if (SystemVolume != 1.0f) {
                    SystemVolume = 1.0f;
                }
            }
            [alarmPlayer play];
        }
    }
}

-(void)stopAlarmPlayer{
    if (_alarmSoundID >= audioArray.count) {
        if (recorderModel == nil) {
            recorderModel = [RecorderModel new];
            
        }
        if (recorderModel.playing == YES) {
            [recorderModel stopPlayRecordEvent];
        }
    }
    else{
        if (alarmPlayer.isPlaying == YES) {
            [alarmPlayer stop];
        }
    }
}

-(void)startAlarm{
    if ([self checkAlarmPlayerIsplaying] == NO){
        [self playAlarmPlayer];
        
        if (_enabelVibrate == YES) {
            SystemVibrate
        }
        
        if (_enabelFlashLight == YES) {
            [flashLightTimer invalidate];
            flashLightTimer = [NSTimer scheduledTimerWithTimeInterval:1/(float)kFlashLightFrg target:self selector:@selector(flashLightEvent) userInfo:nil repeats:YES];
        }
        
        _cv.alarmSoundState = kAlarmValueState;
        [self sendControlValueEvent];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber++;
    }
}

-(void)stopAlarm{
    if ([self checkAlarmPlayerIsplaying] == YES){
        [self stopAlarmPlayer];
    }
    
    if (keyPlayer.isPlaying == YES) {
        [keyPlayer stop];
    }
    
    [flashLightTimer invalidate];
    flashLightTimer = nil;
    [self turnOffLed];
    
    _cv.alarmSoundState = kStopAlarmState;
    [self sendControlValueEvent];
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
        NSLog(@"-->sendControlValueData:%@",sendControlValueData);
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
        
        _recordID = [_activeAntiLostProperty objectForKey:@"recordID"] ;                                                    // 17
    
        //NSLog(@"_choosePicture:%@",_choosePicture);
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
                               
                               [[NSString alloc]initWithFormat:@"%@",_recordID],@"recordID",                                // 17
                               nil];
    //NSLog(@"_choosePicture:%@",_choosePicture);
    //NSLog(@"存储数据：%@",_activeAntiLostProperty);
}

-(AVAudioPlayer *)setPlayer:(AVAudioPlayer *)aPlayer AtIndex:(Byte)idx WithLoop:(char)loop{
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
    //nPlayAlarmStopCreate
    return aPlayer;
}

-(void)setSession{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride
                             );
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
}

#pragma mark -
#pragma mark LED闪烁
/******************************************************/
//              LED闪烁函数                             //
/******************************************************/
-(void)turnOnLed{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}
-(void)turnOffLed{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

-(void)flashLightEvent{
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
    count++;

}

#pragma mark -
#pragma mark 推送消息
/******************************************************/
//              推送消息函数                            //
/******************************************************/
-(void)pushMsg:(NSString *)cnString enMsg:(NSString *)enString{
    // 推送消息
    NSString *nDetail;
//    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"]){
//        // 中文
//        nDetail = [[NSString alloc]initWithFormat:@"%@%@", _nameString, cnString];
//    }
//    else{
        // English
        nDetail = [[NSString alloc]initWithFormat:@"%@%@", _nameString,NSLocalizedString(enString,nil)];
//    }
    UILocalNotification *ln = [[UILocalNotification alloc]init];
    ln.alertLaunchImage = @"icon77@2x.png";
    ln.alertBody = nDetail;
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

#pragma mark -
#pragma mark read/write/notification
/******************************************************/
//          读写通知等基础函数                           //
/******************************************************/
// 写数据到特征值
-(void) writeValue:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data{
    if ([peripheral isEqual:_activePeripheral] &&peripheral.state==CBPeripheralStateConnected ){//[peripheral isConnected]){
        if (characteristic != nil) {
            //NSLog(@"成功写数据到特征值: %@ 数据:%@\n", characteristic.UUID, data);
            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

// 从特征值读取数据
-(void) readValue:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state==CBPeripheralStateConnected){//[peripheral isConnected]){
        if (characteristic != nil) {
            //NSLog(@"成功从特征值:%@ 读数据\n", characteristic);
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

// 发通知到特征值
-(void) notification:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic state:(BOOL)state{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state==CBPeripheralStateConnected){//[peripheral isConnected]){
        if (characteristic != nil) {
            //NSLog(@"成功发通知到特征值: %@\n", characteristic);
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
    for(Byte idx=0; idx<arrayLengh; idx++){
        arrayEncode[idx+1] = crcChecksum ^ arrayDecode[idx];
    }
}

-(BOOL)arrayCrcDecode:(Byte)arrayLengh encodeArray:(Byte *)arrayEncode decodeArray:(Byte *)arrayDecode{
    bool checkout = NO;
    // 生成新数组
    for(Byte idx=0; idx<arrayLengh; idx++){
        arrayDecode[idx] = arrayEncode[0] ^ arrayEncode[idx+1];
    }
    
    // 计算crcChecksum
	Byte crcChecksum = [self CRC_Checksum:arrayLengh Array:arrayDecode];
    if (crcChecksum == arrayEncode[0]){
        checkout = YES;
    }
    
    return checkout;
}

-(Byte)CRC_Checksum:(Byte)arrayLengh Array:(Byte *)array{
    Byte i,j;
    
    Byte crcPassword[8] = CRCPASSWORD;
    Byte CRC_Checkout = 0x0;
    
    for (i=0;i<arrayLengh; i++){
        Byte CRC_Temp = array[i];
        for (j=0;j<8;j++){
            if (CRC_Temp & 0x01){
                CRC_Checkout = CRC_Checkout ^ crcPassword[j];
            }
            CRC_Temp = CRC_Temp >> 1;
        }
    }
    return(CRC_Checkout);
}

@end
