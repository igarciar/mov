//
//  Radar.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "Radar.h"
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
@interface Radar (){
    finderAppDelegate   *blead;
    }

@end

@implementation Radar

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
        
    }
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

    
    [self loadNavigationViews];
    _backProgress = self.distanciaActual;
    
    [self.distanciaAviso setProgress:1.8/90.0*_currentPeripheral.toggleAlarmValue];
    
    nCBSelectImage
    nCBPeripheralStateChange
    nCBTxRssi
    
    [self setCurrentPeripheral:_currentPeripheral];
    self.tituloPersonalizar.text=_currentPeripheral.nameString;

}
-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
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
    
//    }
}

//**************************************************//
#pragma
#pragma 按键功能       
//**************************************************//
- (IBAction)finishButtonEvent:(UIButton *)sender {
    [blead.ble SavePeripheralProperty];
    nFinishSetupProperty
    if (_backMainViewController == NO) {
        // 从Scan返回主界面
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:self];
//        [self.navigationController popViewControllerAnimated:YES];
        nSetupPropertyFromScanPeripherialToFinder
    }
    else{
        // 直接返回主界面
          [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:self];
//        [self.navigationController popViewControllerAnimated:YES];
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
/*
    [self setHidesBottomBarWhenPushed:YES];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController pushViewController:svc animated:YES];
 */
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
      
        
        [_switchView setOn:_currentPeripheral.enabelAntilostWork];
        [_listView reloadData];
        [_sliderView setValue:_currentPeripheral.toggleAlarmValue];
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
    
    [self.distanciaActual setProgress:progressValue];
    
    // 设定显示进度条颜色
    int result=(int)(_currentPeripheral.TxFilteringValue/70.0*6.0)-2;
    NSLog(@"result  %d",result );
    //imagen de radar
    switch (result) {
        case 5:
            [self.radar setImage:[UIImage imageNamed:@"radar6.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra6.png"]];
            break;
        case 4:
            [self.radar setImage:[UIImage imageNamed:@"radar5.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra5.png"]];
            break;
        case 3:
            [self.radar setImage:[UIImage imageNamed:@"radar4.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra4.png"]];
            break;
        case 2:
            [self.radar setImage:[UIImage imageNamed:@"radar3.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra3.png"]];
            break;
        case 1:
            [self.radar setImage:[UIImage imageNamed:@"radar2.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra2.png"]];
            break;
        case 0:
            [self.radar setImage:[UIImage imageNamed:@"radar1.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra1.png"]];
            break;
            
        default:
            [self.radar setImage:[UIImage imageNamed:@"radar.png"]];
            [self.barra setImage:[UIImage imageNamed:@"barra.png"]];
            break;
    }

    
   
 /*
    
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
    */
    
    NSLog(@"progressValue:%f currentPeripheral.TxFilteringValue:%d  _currentPeripheral.toggleAlarmValue:%d ",progressValue, _currentPeripheral.TxFilteringValue,_currentPeripheral.toggleAlarmValue);
}

#pragma mark - 限制文本框输入内容



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
        return nil;
    }else
        if(section == 3)
    {
        return nil;
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
        return 1;
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
           
            UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            detail.backgroundColor = [UIColor clearColor];
            detail.font = [UIFont systemFontOfSize:14];
            detail.textAlignment = NSTextAlignmentRight;
        
           
            cell.accessoryView = detail;
        }else if(indexPath.row == 2){
           
            UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            detail.backgroundColor = [UIColor clearColor];
            detail.font = [UIFont systemFontOfSize:14];
            detail.textAlignment = NSTextAlignmentRight;
       
            
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
       
       
        UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        detail.backgroundColor = [UIColor clearColor];
        detail.font = [UIFont systemFontOfSize:14];
        detail.textAlignment = NSTextAlignmentRight;
       
        cell.accessoryView = detail;
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       if(indexPath.section == fourthCell)
    {
        if (indexPath.row  == 0) {
            [self alarmSoundButton];
        }else if(indexPath.row == 1){
            [self keyFunctionButton];
        }
    }
}
/////////////////
-(UIView *)firstViewCell   //第一个cell中的数据
{
    
    self.tituloPersonalizar.text = _currentPeripheral.nameString;
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
    
    [customView addSubview:imageView];
    [customView addSubview:deviceLabel];
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
  
    [nearLabel setBackgroundColor:[UIColor clearColor]];
    [nearLabel setFont:font];
    
    UILabel *farLabel = [[UILabel alloc]initWithFrame:CGRectMake(213, nearLabel.frame.origin.y, nearLabel.frame.size.width, nearLabel.frame.size.height)];

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



///////////////////////////////////////////////////////


- (IBAction)enabelAntilostWorkEventSegmentedControl:(UISegmentedControl *)sender {
    
    BOOL state=sender.selectedSegmentIndex==0;
    [_currentPeripheral setEnabelAntilostWork:state];
    [_currentPeripheral setEnabelAlarmTimer:state];
    NSLog(@"setEnabelAlarmTimer.on:%d",state);
    
}

@end
