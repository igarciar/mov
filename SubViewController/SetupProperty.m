//
//  SetupProperty.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "SetupProperty.h"
#import "SetupKeyFunction.h"
#import "SelectImage.h"
#import "SetRingtone.h"
#import "SetTimerOnOff.h"

#define firstCellHeight               36
#define  firstCell                    0
#define secondCell                    1
#define thirdCell                     2
#define fourthCell                    3
#define widthCell                     302
@interface SetupProperty (){
    finderAppDelegate   *blead;
    NSTimer             *refreshTimer;
    NSString            *recordString;
    NSString            *timerString;
    NSString            *holdkeyDisabelString;
    NSString            *holdkeySetupDistanceString;
    NSString            *holdkeyLostAlarmOnOffString;
    
    UITextField         *nameEdit;
    NSString            *nameEditTextStr;
    NSString            *nameDeviceStr;
    NSString            *workModelStr;
    NSString            *finishStr;
    NSString            *nearStr;
    NSString            *farStr;
    
    NSString            *autoSetStr;
    NSMutableArray      *cellItemArray;
    
    NSString            *alarmSoundStr;
    NSString            *keyFunctionStr;
    NSString            *nameEditHintStr;
    NSString            *timeOnStr,*timeOffStr;
    NSString            *timeOnNameStr,*timeOffNameStr;
    
    float               sliderValue;
    
    NSString            *recordLocaleStr; //本地录音
    
    NSArray             *hourArray;
    NSArray             *minuteArray;
    
    Byte                chooseSetupTimer;
}

@end

@implementation SetupProperty

#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.onOff.tintColor = [UIColor lightGrayColor];
        self.onOff.layer.cornerRadius=0;
        self.listView.backgroundColor=[UIColor blackColor];
        
    }
    self.guardado=YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 使用全局全量
    blead = [[UIApplication sharedApplication]delegate];
    
    // 设置界面语言
    [self loadCurrentLocale];
    

    NSMutableArray *tempHourArray , *tempMinteArray;
    
    tempHourArray = [[NSMutableArray alloc]init];
    tempMinteArray = [[NSMutableArray alloc]init];
    for (Byte idx=0; idx<24; idx++) {
        NSString *hourString = [[NSString alloc]initWithFormat:@"%d",idx];
        [tempHourArray addObject:hourString];
    }
    for (Byte idx=0; idx<60; idx++) {
        [tempMinteArray addObject:[[NSString alloc]initWithFormat:@"%02d",idx]];
    }
    
    hourArray = [[NSArray alloc]initWithArray:tempHourArray];
    minuteArray = [[NSArray alloc]initWithArray:tempMinteArray];
    
    [_pickerShowOrHideBtn addTarget:self action:@selector(pickerViewShorOrHideEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    _pickerView.showsSelectionIndicator = YES;
    
    [self loadNavigationViews];
    _backProgress = self.distanciaActual;
    _sliderView = self.distanciaAviso;
    nameEdit = [UITextField new];
    
    nCBSelectImage
    nCBPeripheralStateChange
    nCBTxRssi

    [self setCurrentPeripheral:_currentPeripheral];
    [self firstViewCell];
    [self.onOff setSelectedSegmentIndex:_currentPeripheral.enabelAlarmTimer?0:1];

}
-(void)viewWillAppear:(BOOL)animated
{
   // [self setHidesBottomBarWhenPushed:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"did disspear");
  [self loadCurrentLocale];
    [_listView reloadData];
//    [self performSelectorOnMainThread:@selector(refreshListView) withObject:nil waitUntilDone:NO];
}
-(void)refreshListView
{
    [_listView reloadData];
}
- (void) loadNavigationViews
{
    UIBarButtonItem *rightBtn = [UIBarButtonItem new];
    rightBtn.title = finishStr;
    rightBtn.target = self;
    [rightBtn setAction:@selector(finishButtonEvent:)];
    //self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)viewDidUnload
{
    _currentPeripheral = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//**************************************************//
#pragma
#pragma 本地语言
//**************************************************//
-(void)loadCurrentLocale{
// if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"])  {
//        // 中文
//        self.title = @"设置参数";
//        finishStr = @"完成";
//
//        recordString = @"用户录音";
//        timerString = @"未设置定时";
//        holdkeyDisabelString = @"未使用";
//        holdkeySetupDistanceString = @"设定距离";
//        holdkeyLostAlarmOnOffString = @"开关防丢";
//        
//        nameDeviceStr = @"设备名称";
//        nameEditHintStr = @"输入防丢名称";
//        workModelStr =  @"防丢功能开关";
//        nearStr = @"近";
//        farStr = @"远";
//        autoSetStr =  @"距离设定";
//        cellItemArray = [[NSMutableArray alloc]initWithCapacity:4];
//        Item *item1 = [Item new];
//        item1.name = @"提示设定";
//        item1.detail = alarmSoundStr;
//
//        timeOnNameStr = @"设置定时开";
//        timeOffNameStr = @"设置定时关";
//        
//        Item *item4 = [Item new];
//        item4.name =  @"长按键功能";
//        item4.detail = keyFunctionStr;
//        [cellItemArray addObject:item1];
//        [cellItemArray addObject:item4];
//        
//        recordLocaleStr  = @"录音文件";
//    }
//    else{
        // English
    
        self.title  = NSLocalizedString(@"SETUP PROPERTY", nil);
        finishStr = NSLocalizedString(@"finishStr", nil);
        recordString = NSLocalizedString(@"recordString", nil);
        timerString = NSLocalizedString(@"timerString", nil);
        holdkeyDisabelString = NSLocalizedString(@"holdkeyDisabelString", nil);
        holdkeySetupDistanceString = NSLocalizedString(@"holdkeySetupDistanceString", nil);
        holdkeyLostAlarmOnOffString = NSLocalizedString(@"holdkeyLostAlarmOnOffString", nil);
        
        nameDeviceStr = NSLocalizedString(@"nameDeviceStr", nil);
        nameEditHintStr =NSLocalizedString(@"nameEditHintStr", nil);
        workModelStr = NSLocalizedString(@"workModelStr", nil);
        nearStr = NSLocalizedString(@"nearStr", nil);
        farStr = NSLocalizedString(@"farStr", nil);
        autoSetStr = NSLocalizedString(@"autoSetStr", nil);
        cellItemArray = [[NSMutableArray alloc]initWithCapacity:3];
        
        timeOnNameStr =  NSLocalizedString(@"timeOnNameStr", nil);
        timeOffNameStr = NSLocalizedString(@"timeOffNameStr", nil);
        
        Item *item1 = [Item new];
        item1.name = NSLocalizedString(@"item1.name", nil);
        item1.detail = alarmSoundStr;
        
        Item *item4 = [Item new];
        item4.name =  NSLocalizedString(@"item4.name", nil);
        item4.detail = keyFunctionStr;
        [cellItemArray addObject:item1];
        [cellItemArray addObject:item4];
        
        recordLocaleStr = NSLocalizedString(@"recordLocaleStr", nil);
//    }
}

//**************************************************//
#pragma
#pragma 按键功能       
//**************************************************//

- (IBAction)finishButtonRemoveEvent:(UIButton *)sender{
    [blead.ble disconnectPeripheralFromBlePeripheralArrayAtInteger:_index];
    [blead.ble.blePeripheralArray removeObjectAtIndex:_index];
    [blead.ble resetScanning];
    [self finishButtonEvent:sender];

  
}
- (IBAction)finishButtonEvent:(UIButton *)sender {
    if(self.guardado){
        @try {
            [blead.ble SavePeripheralProperty];
        } @catch (NSException *exception) {
            NSLog(@"error guardar: %@ ",exception);
        } @finally {
            
            
            nFinishSetupProperty
            if (_backMainViewController == NO) {
                // 从Scan返回主界面
                [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:self];
                [self.navigationController popViewControllerAnimated:YES];
                nSetupPropertyFromScanPeripherialToFinder
            }
            else{
                // 直接返回主界面
                [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:self];
                //        [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


- (IBAction)chooseImageButtonEvent:(UIButton *)sender {
    SelectImage *svc;
    if (blead.screenType == YES) {
        // 4寸
        svc = [[SelectImage alloc]initWithNibName:@"SelectImage@568" bundle:nil];
    }
    else{
        // 3.5寸
        svc = [[SelectImage alloc]initWithNibName:@"SelectImage" bundle:nil];
    }
    svc.currentPeripheral = _currentPeripheral;
//    [AddObjects ViewControllerTransition:self presentModalVC:svc duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
    //[self setHidesBottomBarWhenPushed:YES];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)chooseRingToneButtonEvent:(UIButton *)sender {
    [self alarmSoundButton];
}
-(void)alarmSoundButton
{
    SetRingtone *svc;
    if (blead.screenType == YES) {
        // 4寸
        svc = [[SetRingtone alloc]initWithNibName:@"SetRingtone@568" bundle:nil];
    }
    else{
        // 3.5寸
        svc = [[SetRingtone alloc]initWithNibName:@"SetRingtone" bundle:nil];
    }
    svc.currentPeripheral = _currentPeripheral;
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:svc animated:YES];
  
}
-(void)keyFunctionButton
{
    SetupKeyFunction *svc;
    if (blead.screenType == YES) {
        // 4寸
        svc = [[SetupKeyFunction alloc]initWithNibName:@"SetupKeyFunction@568" bundle:nil];
    }
    else{
        // 3.5寸
        svc = [[SetupKeyFunction alloc]initWithNibName:@"SetupKeyFunction" bundle:nil];
    }
    svc.currentPeripheral = _currentPeripheral;
    //    [AddObjects ViewControllerTransition:self presentModalVC:svc duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)autosetButtonEvent:(UIButton *)sender {
    [_currentPeripheral autoSetupToggleAlarmValue];
}

- (IBAction)toogleRssiValueSliderEvent:(UISlider *)sender {
    _currentPeripheral.toggleAlarmValue = sender.value;
    NSLog(@"setupProperty_ToggleAlarmValue:%d",_currentPeripheral.toggleAlarmValue);
}

-(void)setCurrentPeripheral:(blePeripheral *)CP{
   
    _currentPeripheral = CP;
    if (_currentPeripheral != nil) {
        [self CBSelectImage];
        NSLog(@"nameString:%@",_currentPeripheral.nameString);
        nameEditTextStr = _currentPeripheral.nameString;
        
        sliderValue = _currentPeripheral.toggleAlarmValue;
        
        if (_currentPeripheral.alarmSoundID > kMaxChooseSoundID) {
//            _currentPeripheral.alarmSoundID = 0;
            alarmSoundStr = recordLocaleStr;
            alarmSoundStr = _currentPeripheral.recordID;
        }else {
            alarmSoundStr = [audioName objectAtIndex:_currentPeripheral.alarmSoundID];
        }
//        if (_currentPeripheral.enabelAlarmTimer == YES) {
            timeOnStr = [[NSString alloc]initWithFormat:@"%d:%02d", _currentPeripheral.timerOnHour, _currentPeripheral.timerOnMinute];
            timeOffStr = [[NSString alloc]initWithFormat:@"%d:%02d",_currentPeripheral.timerOffHour,_currentPeripheral.timerOffMinute ];
//        }
        switch (_currentPeripheral.holdKeyPressedFunctions) {
            case kDisabel:
                keyFunctionStr =  holdkeyDisabelString;
                break;
                
            case kSetupDistance:
                keyFunctionStr = holdkeySetupDistanceString;
                break;
            case kWorkOnOff:
                keyFunctionStr =  holdkeyLostAlarmOnOffString;
                break;
            default:
                break;
        }
        [_switchView setOn:_currentPeripheral.enabelAntilostWork];
        [_listView reloadData];
        [_sliderView setValue:_currentPeripheral.toggleAlarmValue];
        NSLog(@"输入 防丢名称   %@  ",nameEditHintStr);
    }
}

//**************************************************//
#pragma
#pragma 回调函数
//**************************************************//
-(void)CBSelectImage{
//    if (_currentPeripheral.choosePicture != nil) {
//        [_imageButton setBackgroundImage:_currentPeripheral.choosePicture forState:UIControlStateNormal];
//        [_imageButton setTitle:@"" forState:UIControlStateNormal];
//        [_imageButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    }
//    else{
//        [_imageButton setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
//        [_imageButton setTitle:@"Click me" forState:UIControlStateNormal];
//        [_imageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }
}

-(void)CBPeripheralStateChange{
    [self setCurrentPeripheral:_currentPeripheral];
}

-(void)CBTxRssi{
    float progressValue;
    if (_currentPeripheral.TxFilteringValue < kMinResponseRssiValue) {
        progressValue = 0.0f;
    }
    else if (_currentPeripheral.TxFilteringValue>kMaxSetResponseRssiValue){
        progressValue = 1.0f;
    }
    else{
        progressValue = ((float)(_currentPeripheral.TxFilteringValue - kMinResponseRssiValue)/(kMaxSetResponseRssiValue - kMinResponseRssiValue));
    }
    _backProgress.progress = progressValue;
    
    // 设定显示进度条颜色
    if (_currentPeripheral.TxFilteringValue <= kStopAlarmRxRssi) {
        [_backProgress setProgressTintColor:[UIColor greenColor]];
    }
    else if ((_currentPeripheral.TxFilteringValue > kStopAlarmRxRssi) && (_currentPeripheral.TxFilteringValue < _currentPeripheral.toggleAlarmValue))
    {
        [_backProgress setProgressTintColor:[UIColor yellowColor]];
    }
    
    else if (_currentPeripheral.TxFilteringValue >= _currentPeripheral.toggleAlarmValue)
    {
        [_backProgress setProgressTintColor:[UIColor redColor]];
    }
    
    NSLog(@"progressValue:%f currentPeripheral.TxFilteringValue:%d  _currentPeripheral.toggleAlarmValue:%d ",progressValue, _currentPeripheral.TxFilteringValue,_currentPeripheral.toggleAlarmValue);
}

#pragma mark - 限制文本框输入内容
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [textField resignFirstResponder];
    _currentPeripheral.nameString = textField.text;
    nCentralStateChange
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_hideKeyBoradBtn setHidden:NO];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"textField.text:%@",textField.text);
    static NSString *tempString;
    NSData *nameData = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
    textField.tintColor=[UIColor redColor];
    if (nameData.length>19) {
        //NSLog(@"输出字符超出19个");
        textField.text = tempString;
    }
    else{
        tempString = textField.text;
    }
    //NSLog(@"tempString:%@",tempString);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField.text:%@",textField.text);
    _currentPeripheral.nameString = textField.text;
    nCentralStateChange
}


#pragma mark - 触摸背景来关闭虚拟键盘
- (IBAction)backgroundEvent:(id)sender {
    [nameEdit resignFirstResponder];
    [_hideKeyBoradBtn setHidden:YES];
}

- (IBAction)enabelAntilostWorkEvent:(UISwitch *)sender {
    [_currentPeripheral setEnabelAntilostWork:sender.on];
    [_currentPeripheral setEnabelAlarmTimer:sender.on];
    NSLog(@"setEnabelAlarmTimer.on:%d",sender.on);
    [self refreshListView];
    
}


#pragma  uitableView delegate datasource 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == firstCell)
    {
        return firstCellHeight;
    }
    return 40;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 2)
    {
        return autoSetStr;
    }else
        if(section == 3)
    {
        return autoSetStr;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == fourthCell)
    {
        return cellItemArray.count;
    }else if(section == secondCell){
        if(_currentPeripheral.enabelAlarmTimer)
        {
            return 3;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}

-(void) customThemeCell:(UITableViewCell* ) cell{
    cell.backgroundColor=[UIColor blackColor];
    cell.backgroundColor=[UIColor blackColor];
    


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
    
    if(indexPath.section == firstCell)
    {
        static NSString  *identifier = @"customCellId1";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryView = [self firstViewCell];
    }else if(indexPath.section == secondCell){
        static NSString  *identifier = @"customCellId2";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row == 0)
        {
            cell.accessoryView = [self secondViewCell];    
        }else if(indexPath.row == 1){
            [cell.textLabel setText:timeOnNameStr];
            UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            detail.backgroundColor = [UIColor clearColor];
            detail.font = [UIFont systemFontOfSize:14];
            detail.textAlignment = NSTextAlignmentRight;
        
            detail.text = timeOnStr;
            cell.accessoryView = detail;
        }else if(indexPath.row == 2){
            [cell.textLabel setText:timeOffNameStr];
            UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            detail.backgroundColor = [UIColor clearColor];
            detail.font = [UIFont systemFontOfSize:14];
            detail.textAlignment = NSTextAlignmentRight;
       
            detail.text = timeOffStr;
            cell.accessoryView = detail;
        }

    }else if(indexPath.section == thirdCell){
        static NSString  *identifier = @"customCellId3";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryView = [self thirdViewCell];
    }else if(indexPath.section == fourthCell){
        static NSString  *identifier = @"customCellId4";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        Item *item = cellItemArray[indexPath.row];
        cell.textLabel.text = item.name;
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        detail.backgroundColor = [UIColor clearColor];
        detail.font = [UIFont systemFontOfSize:14];
        detail.textAlignment = NSTextAlignmentRight;
        detail.text = item.detail;
        cell.accessoryView = detail;
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    chooseSetupTimer = 0;
    if(indexPath.section == fourthCell)
    {
        if (indexPath.row  == 0) {
            [self alarmSoundButton];
        }else if(indexPath.row == 1){
            [self keyFunctionButton];
        }
    }else if (indexPath.section == secondCell){
        if(indexPath.row == 1){
            [self pickerViewShow];
            [_pickerView selectRow:_currentPeripheral.timerOnHour inComponent:kHourComponent animated:YES];
            [_pickerView selectRow:_currentPeripheral.timerOnMinute inComponent:kMinuteComponent animated:YES];
            chooseSetupTimer = 1;
            
        }else if(indexPath.row == 2){
            [self pickerViewShow];
            [_pickerView selectRow:_currentPeripheral.timerOffHour inComponent:kHourComponent animated:YES];
            [_pickerView selectRow:_currentPeripheral.timerOffMinute inComponent:kMinuteComponent animated:YES];
            chooseSetupTimer = 2;
        }
    }
}
/////////////////
-(UIView *)firstViewCell   //第一个cell中的数据
{
    
    self.tituloPersonalizar.text = [[NSString alloc]initWithFormat:@"%@",NSLocalizedString(@"CUSTOMBLELABEL", nil)];
   
   
    [[self.imagen imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    if(_currentPeripheral.choosePicture != NULL)
    {
        [self.imagen setBackgroundImage:_currentPeripheral.choosePicture forState:UIControlStateNormal];
    }else {
        [self.imagen setBackgroundImage:[UIImage imageNamed:@"bolso_amarillo.png"] forState:UIControlStateNormal];
    }
    
    [self.imagen addTarget:self action:@selector(chooseImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    [self.tono setTitle:alarmSoundStr forState:UIControlStateNormal];
    
    
    [self.nombre setDelegate:self];
    if(nameEditTextStr !=nil)
    {
        [self.nombre setPlaceholder:nameEditTextStr];
    }else{
        [self.nombre setPlaceholder:nameEditHintStr];
    }

    
    
    
    
    
    return [self firstViewCellOLD];
}























/////////////old
-(UIView *)firstViewCellOLD   //第一个cell中的数据
{
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, widthCell, 100)];
    customView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [customView addGestureRecognizer:tap];
    customView.userInteractionEnabled = YES;
    
    UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(10, 4, 88, 88)];
    
    if(_currentPeripheral.choosePicture != NULL)
    {
        [imageView setBackgroundImage:_currentPeripheral.choosePicture forState:UIControlStateNormal];
    }else {
        [imageView setBackgroundImage:[UIImage imageNamed:@"icon77@2x.png"] forState:UIControlStateNormal];
    }
   
    [imageView addTarget:self action:@selector(chooseImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *deviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x, 28, 180, 21)];
    [deviceLabel setBackgroundColor:[UIColor clearColor]];
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    deviceLabel.text = nameDeviceStr;
    
    [nameEdit setFrame:CGRectMake(deviceLabel.frame.origin.x, deviceLabel.frame.origin.y+deviceLabel.frame.size.height+12, 180, 30)];
    nameEdit.borderStyle = UITextBorderStyleRoundedRect;
    [nameEdit setDelegate:self];
    if(nameEditTextStr !=nil)
    {
        [nameEdit setPlaceholder:nameEditTextStr];
    }else{
        [nameEdit setPlaceholder:nameEditHintStr];
    }
    
    [customView addSubview:imageView];
    [customView addSubview:deviceLabel];
    [customView addSubview:nameEdit];
    return customView;
}

-(UIView *) secondViewCell   //每二个cell中的view
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthCell+30, 45)];
    customView.userInteractionEnabled = YES;
    customView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];

    
    UILabel *workModeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 13, 202, 20)];
    [workModeLabel setBackgroundColor:[UIColor  clearColor]];
    [workModeLabel setFont:[UIFont boldSystemFontOfSize:17]];
   
    [workModeLabel setText:workModelStr];

        _switchView = [[UISwitch alloc]initWithFrame:CGRectMake(workModeLabel.frame.size.width+workModeLabel.frame.origin.x, workModeLabel.frame.origin.y-3, 40, workModeLabel.frame.size.height)];
         _switchView.on = _currentPeripheral.enabelAlarmTimer;
        [_switchView addTarget:self action:@selector(enabelAntilostWorkEvent:) forControlEvents:UIControlEventValueChanged];
        [customView addGestureRecognizer:tap];
     
        [customView addSubview:_switchView];
    
   [customView addSubview:workModeLabel];
    return customView;
}

-(UIView *)thirdViewCell  //第三个cellView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthCell+30, 45)];
    [customView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [customView addGestureRecognizer:tap];
    customView.backgroundColor = [UIColor clearColor];
    
    UIFont *font = [UIFont systemFontOfSize:12];
    UILabel *nearLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 12, 80, 14)];
    nearLabel.text = nearStr;
    [nearLabel setBackgroundColor:[UIColor clearColor]];
    [nearLabel setFont:font];
    
    UILabel *farLabel = [[UILabel alloc]initWithFrame:CGRectMake(213, nearLabel.frame.origin.y, nearLabel.frame.size.width, nearLabel.frame.size.height)];
    [farLabel setText:farStr];
    [farLabel setFont:font];
    [farLabel setBackgroundColor:[UIColor clearColor]];
    farLabel.textAlignment = NSTextAlignmentRight;
    
    [_backProgress setFrame:CGRectMake(18, 25, 277, 15)];
    [_backProgress setProgressTintColor:[UIColor lightGrayColor]];
    
    [_sliderView setFrame:CGRectMake(165, 22, 132, 15)];
    [_sliderView setBackgroundColor:[UIColor clearColor]];
    [_sliderView setMinimumTrackTintColor:[UIColor clearColor]];
    [_sliderView setMaximumTrackTintColor:[UIColor clearColor]];
    [_sliderView setMinimumValue:60];
    [_sliderView setMaximumValue:85];
    [_sliderView setValue:sliderValue];
    [_sliderView addTarget:self action:@selector(toogleRssiValueSliderEvent:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *minLabel = [[UILabel alloc]initWithFrame:CGRectMake(146, _backProgress.frame.origin.y,2, 10)];
    [minLabel setBackgroundColor:[UIColor greenColor]];
    
    [customView addSubview:nearLabel];
    [customView addSubview:farLabel];
    [customView addSubview:_backProgress];
    [customView addSubview:_sliderView];
    [customView addSubview:minLabel];
    return customView;
}

-(void)tap:(UIGestureRecognizer *)sender
{
    NSLog(@"tap");
    if(nameEdit != nil)
    {
        [nameEdit resignFirstResponder];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    if (component == kHourComponent)
//        return 120;
//    return 130;
//}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kHourComponent)
        return [hourArray count];
    return [minuteArray count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == kHourComponent)
        return [hourArray objectAtIndex:row];
    return [minuteArray  objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(chooseSetupTimer > 0)
    {
       // NSString *str= nil;
        if(chooseSetupTimer == 1){
            _currentPeripheral.timerOnHour = [pickerView selectedRowInComponent:kHourComponent];
            _currentPeripheral.timerOnMinute = [pickerView selectedRowInComponent:kMinuteComponent];
            
        }
        else if(chooseSetupTimer == 2){
            _currentPeripheral.timerOffHour = [pickerView selectedRowInComponent:kHourComponent];
            _currentPeripheral.timerOffMinute = [pickerView selectedRowInComponent:kMinuteComponent];
            
        }
        nPeripheralStateChange  // 监视数据的变更
        //因为个个修改的是选中状态下的cell ,picker选择后就TableView reloadData，
        //UITableViewCell *cell = [self.listView cellForRowAtIndexPath:indexPath];
        //UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,150, 20)];
        //[detailLabel setBackgroundColor:[UIColor clearColor]];
    
        //detailLabel.font = [UIFont systemFontOfSize:14];
        //[detailLabel setText:str];
        //detailLabel.textAlignment = NSTextAlignmentRight;
        //cell.accessoryView = nil;
        //cell.accessoryView = detailLabel;
        //NSLog(@"listview 选中          %@", @"dss");
    }
    //else{
    //    NSLog(@"picker data is null");
    //}
}
-(void)pickerViewHide   //隐藏pickerView
{
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.pickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
    self.pickerView.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = self.listView.frame;
	newFrame.size.height += self.pickerView.frame.size.height;
	self.listView.frame = newFrame;
	
    
    [_pickerShowOrHideBtn setHidden:YES];   // hide the pikcViewBtn
    
    // deselect the current table row
	NSIndexPath *indexPath = [self.listView indexPathForSelectedRow];
	[self.listView deselectRowAtIndexPath:indexPath animated:YES];
	
}
- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}
-(IBAction)pickerViewShorOrHideEvent:(id)sender  // 处理pickerview隐藏
{
    [self pickerViewHide];
    
}
-(IBAction)doneAction:(id)sender
{
    [self pickerViewHide];
}
-(void)pickerViewShow        //显示picker
{
    _pickerShowOrHideBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    _pickerShowOrHideBtn.backgroundColor = [UIColor clearColor];
    [_pickerShowOrHideBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:_pickerShowOrHideBtn];
    
    [self.view.window addSubview:self.pickerView];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.origin.y + screenRect.size.height,
                                  pickerSize.width, pickerSize.height);
    self.pickerView.frame = startRect;
    
    // compute the end frame
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    
    self.pickerView.frame = pickerRect;
    
    // shrink the table vertical size to make room for the date picker
    CGRect newFrame = self.listView.frame;
    newFrame.size.height -= self.pickerView.frame.size.height;
    self.listView.frame = newFrame;
    [UIView commitAnimations];
    [_pickerShowOrHideBtn setHidden:NO];
}


///////////////////////////////////////////////////////


- (IBAction)enabelAntilostWorkEventSegmentedControl:(UISegmentedControl *)sender {
    
    BOOL state=sender.selectedSegmentIndex==0;
    [_currentPeripheral setEnabelAntilostWork:state];
    [_currentPeripheral setEnabelAlarmTimer:state];
    
    NSLog(@"setEnabelAlarmTimer.on:%d",state);
    
}

@end
@implementation Item


@end