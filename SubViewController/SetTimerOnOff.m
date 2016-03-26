//
//  SetTimerOnOff.m
//  finder
//
//  Created by David ding on 13-3-18.
//  Copyright (c) 2013年 David ding. All rights reserved.
//

#import "SetTimerOnOff.h"
@interface SetTimerOnOff (){
    BOOL        OnOffFlag;  // NO -> ON | YES -> OFF
    NSArray     *hourArray;
    NSArray     *minuteArray;
    
    NSMutableArray    *arraySource;
    NSString          *doneBtnStr;
    NSMutableArray    *timeArray;
    BOOL              isSetFlag;   //是否开启设置
}

@end

@implementation SetTimerOnOff

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
    [self loadCurrentLocale];
    
    [self setCurrentPeripheral:_currentPeripheral];
  
    NSString *timeOnStr = [[NSString alloc]initWithFormat:@"%d:%02d", _currentPeripheral.timerOnHour, _currentPeripheral.timerOnMinute];
    NSString *timeOffStr = [[NSString alloc]initWithFormat:@"%d:%02d",_currentPeripheral.timerOffHour,_currentPeripheral.timerOffMinute ];
    
    timeArray  = [[NSMutableArray alloc]initWithObjects:timeOffStr , timeOnStr,  timeOffStr, nil];
    
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
    
    _switchTime =[[UISwitch alloc]initWithFrame:CGRectZero];
    _switchTime.userInteractionEnabled = NO;
    _switchTime.on = isSetFlag;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self pickerViewHide];
}
- (void)viewDidUnload
{
    _currentPeripheral = nil;

    [self setListView:nil];
    [self setPickerShowOrHideBtn:nil];
    [self setPickerView:nil];
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
if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])  {
        // 中文
        self.title  = @"设置定时";
        
        arraySource = [[NSMutableArray alloc]initWithObjects:@"防丢功能开关",@"设置定时开",@"设置定时关", nil];
        doneBtnStr = @"完成";
    }
    else{
        // English
        self.title = @"SET TIMER";
        
        arraySource = [[NSMutableArray alloc] initWithObjects:@"FUCTION SWITCH",@"SET TIMER ON",@"SET TIMER OFF", nil];
        doneBtnStr = @"done";
    }
}

//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//
- (IBAction)backButtonEvent:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)enabelTimerSwitchEvent:(UISwitch *)sender {
    _currentPeripheral.enabelAlarmTimer = sender.on;
//    [self TimerSwitch:_enabelTimerSwitch.on];

    nPeripheralStateChange
}

/*
- (IBAction)setTimerDataPickerEvent:(UIDatePicker *)sender {
    NSDate *selected = [sender date];
    NSLog(@"selected:%@",selected);
    
    if (OnOffFlag == YES) {
        _timerOffLabel.text =@"";
    }
    else{
        _timerOnLaber.text =@"";
    }
}
*/

-(void)setCurrentPeripheral:(blePeripheral *)CP{
    _currentPeripheral = CP;
    if (_currentPeripheral != nil) {
        isSetFlag = _currentPeripheral.enabelAlarmTimer;
    }
    else{
        _currentPeripheral = [[blePeripheral alloc]init];
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
	NSIndexPath *indexPath = [self.listView indexPathForSelectedRow];
    NSString *str= nil;
    if(indexPath.row == 1)
    {
        _currentPeripheral.timerOnHour = [pickerView selectedRowInComponent:kHourComponent];
        _currentPeripheral.timerOnMinute = [pickerView selectedRowInComponent:kMinuteComponent];
        str = [[NSString alloc]initWithFormat:@"%d:%02d",_currentPeripheral.timerOnHour, _currentPeripheral.timerOnMinute ];

    }else if(indexPath.row == 2)
    {
        _currentPeripheral.timerOffHour = [pickerView selectedRowInComponent:kHourComponent];
        _currentPeripheral.timerOffMinute = [pickerView selectedRowInComponent:kMinuteComponent];
        str = [[NSString alloc]initWithFormat:@"%d:%02d",_currentPeripheral.timerOffHour, _currentPeripheral.timerOffMinute ];

    }
    nPeripheralStateChange  // 监视数据的变更
	UITableViewCell *cell = [self.listView cellForRowAtIndexPath:indexPath];
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, 40)];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setText:str];
    cell.accessoryView = nil;
    cell.accessoryView = detailLabel;
    NSLog(@"listview 选中          %@", cell.textLabel.text);
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
	
	// remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;

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
#pragma uitableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_switchTime.on)
        return arraySource.count;
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if(indexPath.row != 0 )
     {
        
         [self pickerViewShow];
         if(indexPath.row == 1)
         {
             [_pickerView selectRow:_currentPeripheral.timerOnHour inComponent:kHourComponent animated:YES];
             [_pickerView selectRow:_currentPeripheral.timerOnMinute inComponent:kMinuteComponent animated:YES];
         }if(indexPath.row == 2){
             [_pickerView selectRow:_currentPeripheral.timerOffHour inComponent:kHourComponent animated:YES];
             [_pickerView selectRow:_currentPeripheral.timerOffMinute inComponent:kMinuteComponent animated:YES];
         }
     }else if(indexPath.row == 0){
         if(_switchTime.on)
         {
             _switchTime.on = NO;
         }else{  //skfdkfj
             _switchTime.on = YES;
         }
         _currentPeripheral.enabelAlarmTimer = _switchTime.on;
         nPeripheralStateChange
         [tableView reloadData];
     }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifierCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    if(indexPath.row == 0)
    {
        cell.accessoryView = _switchTime;
        cell.textLabel.text = arraySource[indexPath.row];
        
    }else {

        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, 40)];
        [detailLabel setBackgroundColor:[UIColor clearColor]];
            [detailLabel setText:timeArray[indexPath.row]];
        cell.accessoryView = detailLabel;
        cell.textLabel.text = arraySource[indexPath.row];

    }
  
    return cell;
}
@end
