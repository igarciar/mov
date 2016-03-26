//
//  SetRingtone.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "SetRingtone.h"


#define localeRing                   0
#define recordRing                   1
#define kFooterHeight                50

@interface SetRingtone (){
    AVAudioPlayer   *tempAudioPlayer;
    NSArray         *ringtoneTabelArray;
    Byte            chooseRingRow;
    
    NSString        *startRecordString;
    NSString        *stopRecordString;
    NSString        *detailString;
    NSString        *configStr;
    
    NSString        *setTitleStr;
    NSString        *ringTitleStr;
    NSString        *localRingStr,*recordRingStr;
    
    BOOL            flashLightBoo;
    BOOL            vibrateBoo;
    BOOL            muteBoo;
    BOOL            msgBoo;
    
    NSMutableArray  *recorderArray;
    NSInteger       whichOne;
    NSString        *addStr;   //添加录音信息
    
    NSString        *playRecordStr;
    NSString        *updateRecordStr; //更新record
    RecorderModel   *recordModel;
    UILabel                         *timeLab;
    UILabel                         *sizeLab;
    NSString                         *recodeTimeStr,*recodeSizeStr;
    
    
    
}

@end

@implementation SetRingtone

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
    [self setCurrentPeripheral:_currentPeripheral];


    [self loadCurrentLocale];
    [_listView reloadData];

    recordModel = [RecorderModel new];
    recordModel.delegateRecord = self;
    recorderArray = [NSMutableArray new];
    if([recordModel getRecordArray] != nil)
    {
        [recorderArray addObjectsFromArray:[recordModel getRecordArray]];
    }
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)viewDidUnload{
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
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
//        self.title = @"设置报警方式";
//        configStr = @"确定";
//        stopRecordString = @"停止录音";
//        detailString = @"已选择";
//        
//        setTitleStr = @"功能设置";
//        ringTitleStr = @"报警铃声";
//        _setArray = [NSMutableArray arrayWithObjects:@"报警时闪灯",@"报警时振动",@"报警时静音",@"报警发消息", nil];
//        addStr = @"添加录音";
//        playRecordStr = @"播放录音";
//        updateRecordStr = @"更新录音文件";
//     
//     localRingStr = @"本地铃音";
//     recordRingStr = @"录音";
//     recodeSizeStr = @"大小:";
//     recodeTimeStr = @"时间:";
//    }
//    else{
        // English
        self.title = NSLocalizedString(@"SETUP ALARM", nil);
        configStr = NSLocalizedString(@"configStr", nil);
        stopRecordString = NSLocalizedString(@"stopRecordString", nil);
        detailString = NSLocalizedString(@"detailString", nil);
        
        setTitleStr = NSLocalizedString(@"setTitleStr", nil);
        ringTitleStr = NSLocalizedString(@"ringTitleStr", nil);
        
        _setArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"FLASHLIGHT ON ALARM", nil),NSLocalizedString(@"VIBRATE ON ALARM", nil),NSLocalizedString(@"MUTE ON ALARM", nil),NSLocalizedString(@"MSG ON ALARM", nil), nil];
        addStr = NSLocalizedString(@"addStr", nil);
        playRecordStr = NSLocalizedString(@"playRecordStr", nil);
        updateRecordStr = NSLocalizedString(@"updateRecordStr", nil);
        
        localRingStr =NSLocalizedString(@"localRingStr", nil);
        recordRingStr = NSLocalizedString(@"recordRingStr", nil);
        recodeSizeStr = NSLocalizedString(@"recodeSizeStr", nil);
        recodeTimeStr = NSLocalizedString(@"recodeTimeStr", nil);
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (tempAudioPlayer.isPlaying == YES) {
        [tempAudioPlayer stop];
    }
    [recordModel stopPlayRecordEvent];
}
//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//
-(void)changeData   // 数据更改后保存
{
    _currentPeripheral.alarmSoundID = chooseRingRow;
    _currentPeripheral.enabelFlashLight = flashLightBoo;
    _currentPeripheral.enabelVibrate = vibrateBoo;
    _currentPeripheral.enabelMute = muteBoo;
    _currentPeripheral.enabelPushMsg = msgBoo;
   
    nPeripheralStateChange
}
-(AVAudioPlayer *)setPlayer:(AVAudioPlayer *)aPlayer AtIndex:(Byte)idx{
    // 选择报警音源
    NSString *filePath = [[NSBundle mainBundle]pathForResource:[audioArray objectAtIndex:idx] ofType:@"mp3"];
    aPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:filePath] error:nil];
    aPlayer.currentTime = 0;
    //aPlayer.volume = 1.0f;
    //aPlayer.numberOfLoops = 0;
    [aPlayer prepareToPlay];
    [aPlayer setDelegate:(id<AVAudioPlayerDelegate>)self];
//    AVAudioSession *session = [AVAudioSession sharedInstance];    //会和录音文件RecorderModel中init中初始的session相冲突
//    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //在后台工作的时候，使系统能够播发声音文件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 设置系统音量
    if (SystemVolume != 1.0) {
        SystemVolume = 1.0;
    }
    return aPlayer;
}

-(void)setCurrentPeripheral:(blePeripheral *)CP{
    _currentPeripheral = CP;
    if (_currentPeripheral != nil) {
//        if (_currentPeripheral.alarmSoundID > kMaxChooseSoundID) {
//            chooseRingRow = 0;
//        }
        chooseRingRow = _currentPeripheral.alarmSoundID;
        NSLog(@"choose ring row  %d",(int)chooseRingRow);
        flashLightBoo = _currentPeripheral.enabelFlashLight;
        vibrateBoo = _currentPeripheral.enabelVibrate;
        muteBoo = _currentPeripheral.enabelMute;
        msgBoo = _currentPeripheral.enabelPushMsg;
        NSLog(@"Currenr Peripheral uuid: %@",_currentPeripheral.uuidString);
        [_listView reloadData];
    }
}


#pragma mark -
#pragma mark TableView Delegates
// 表格处理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return setTitleStr;
    }else if (section == 1)
    {
        return ringTitleStr;
    }
    return self.title;
}

// 显示格式
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
    {
        return _setArray.count;
    }else if(section == 1)
    {
        if (whichOne == localeRing)
        {
            return [audioName count]-1;
        }else if(whichOne == recordRing){
            return recorderArray.count;
        }
    }
    return [audioName count]-1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        static NSString *cellID = @"cellid0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.textLabel.text = _setArray[indexPath.row];
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        [switchView setTag:indexPath.row];
        switch (indexPath.row) {
            case 0:
                switchView.on = flashLightBoo;
                break;
            case 1:
                switchView.on = vibrateBoo;
                break;
            case 2:
                switchView.on = muteBoo;
                break;
            case 3:
                switchView.on = msgBoo;
                break;
            default:
                break;
        }
        cell.accessoryView = switchView;
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell;
        if(whichOne == localeRing)  // 本地铃声
        {
            static NSString *cellID1 = @"cellid1";

            cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID1];
            }
            [[cell textLabel] setText:[audioName objectAtIndex:indexPath.row]];
                  
            // 显示名字信息
            cell.detailTextLabel.text = detailString;

            // 显示时间长度
            AVAudioPlayer *cellPlayer;
//            cellPlayer =
            [self setPlayer:cellPlayer AtIndex:indexPath.row];
            if (_currentPeripheral != nil) {
                cell.detailTextLabel.hidden = YES;
                if (indexPath.row == chooseRingRow) {
                    cell.detailTextLabel.hidden = NO;
                }
            }
        }else if(whichOne == recordRing){  // 录音文件
            static NSString *cellID2 = @"cellid2";
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID2];
            }
            if(recorderArray != nil)
            {
                [[cell textLabel] setText:recorderArray[indexPath.row]];
                if(chooseRingRow == audioArray.count && [_currentPeripheral.recordID isEqualToString:[recordModel getRecordArray][indexPath.row] ])
                {
                    // 显示名字信息
                    cell.detailTextLabel.text = detailString;
                }else{
                    cell.detailTextLabel.text = @"";
                }
            }
        }
        return  cell;
    }
	return nil;
}


// 点击连接操作
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {

    }else if(indexPath.section == 1){
        if(whichOne == localeRing)
        {
            if(recordModel !=nil && [recordModel playing])
            {
                [recordModel stopPlayRecordEvent];
            }
            // 管理连接
            if (tempAudioPlayer.isPlaying == YES) {
                [tempAudioPlayer stop];
            }
            if ([audioName count]> indexPath.row) {
                chooseRingRow = indexPath.row;
                tempAudioPlayer = [self setPlayer:tempAudioPlayer AtIndex:chooseRingRow];
                [tempAudioPlayer play];
                _currentPeripheral.recordID = nil;
            }
            [self changeData];
            
        }else if(whichOne == recordRing){
            if (tempAudioPlayer !=nil && [tempAudioPlayer play]) {
                [tempAudioPlayer stop];
            }
            [recordModel playRecordEvent:recorderArray[indexPath.row] isLoop:NO];
            chooseRingRow = [audioArray count];
            NSLog(@"uuid %@",_currentPeripheral.uuidString);
            _currentPeripheral.recordID = recorderArray[indexPath.row];
            [self changeData];
        }
        [tableView deselectRowAtIndexPath: indexPath animated: YES];
        [tableView reloadData];
    }
}
// Override to support editing the table view.  删除列
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (whichOne == recordRing && indexPath.section == 1)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [recordModel stopRecordEvent];
            [recordModel deleteRecorderFile:recorderArray[indexPath.row]];
            [recorderArray removeAllObjects];
            [recorderArray addObjectsFromArray:[recordModel getRecordArray]];
            chooseRingRow = 0;
            [tableView reloadData];
        }
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 1){
        if (whichOne == 0) {
            return NO;
        }else if(whichOne == 1){
            return YES;
        }
    }
    return NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 25;
    }
    if(section == 1)
    {
        return 50;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    customView.userInteractionEnabled = YES;
    
    if(section == 1)
    {
        UISegmentedControl *segmentView = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:localRingStr,recordRingStr, nil]];
        [segmentView setFrame:CGRectMake(10, 7, 300, 35)];
        [segmentView setSelectedSegmentIndex:whichOne];
        [segmentView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        [customView addSubview:segmentView];
        return customView;
    }
    return  nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (whichOne == recordRing && section == 1) //录音
    { UIView *customView = [[ UIView alloc]initWithFrame:CGRectMake(0, 0, 300, kFooterHeight)];
        customView.backgroundColor = [UIColor clearColor];
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(10, 5, 300, kFooterHeight - 10)];
  
        [button setTitle:addStr forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(addRecoderRing:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:button];
        return customView;
    }
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 && whichOne == recordRing) {
        return kFooterHeight;
    }
    return 0;
}
#pragma mark- switch事件
-(IBAction)switchClick:(id)sender
{
    UISwitch *switchTmp =(UISwitch *) sender;
    if(switchTmp.tag == 0)
    {
        flashLightBoo = switchTmp.on;
    }else if(switchTmp.tag ==1) {
        vibrateBoo = switchTmp.on;
    }else if(switchTmp.tag == 2){
        muteBoo = switchTmp.on;
    }else if (switchTmp.tag == 3){
        msgBoo = switchTmp.on;
    }
    [self changeData];
}
#pragma mark- segment事件
- (void)segmentAction:(id)sender
{
    whichOne = [sender selectedSegmentIndex];

    [_listView reloadData];
}

#pragma mark- UIAlertView delegate
-(IBAction)addRecoderRing:(id)sender
{
    UIAlertView	*alert = [[UIAlertView alloc] initWithTitle:recordRingStr message:@"   "
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    [alert addSubview:[self messageView]];
   [recordModel startRecordEvent];
	[alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) { //结束录音
        [recorderArray removeAllObjects]; //先清空
        [recordModel stopRecordEvent];
        [recorderArray addObjectsFromArray:[recordModel getRecordArray]]; //再加入数据
    }else if(buttonIndex == 0){  //取消录音
        [recordModel cancelRecordEvent];//取消录音
    }
    [_listView reloadData];
}


-(id)messageView   //alert Message View
{
    UIColor *clearcolor = [UIColor clearColor];
    UIColor *fontColor = [UIColor whiteColor];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(20, 34, 245, 46)];
    customView.backgroundColor = clearcolor;
    
    UILabel *timeName = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 40, 15)];
    UILabel *sizeName = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 40, 15)];
    timeName.backgroundColor = clearcolor;
    sizeName.backgroundColor = clearcolor;
    timeName.textColor = fontColor;
    sizeName.textColor = fontColor;
    
    timeLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 15)];
    timeLab.textAlignment = NSTextAlignmentCenter;
    sizeLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 25, 100, 15)];
    sizeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.backgroundColor = clearcolor;
    sizeLab.backgroundColor = clearcolor;
    timeLab.textColor = fontColor;
    sizeLab.textColor = fontColor;
    
    [timeName setText:recodeTimeStr];
    [sizeName setText:recodeSizeStr];
    
    
    [customView addSubview:timeName];
    [customView addSubview:sizeName];
    [customView addSubview:timeLab];
    [customView addSubview:sizeLab];
    return customView;
}
#pragma mark- RecorderModelDelegate
-(void)updateTime:(NSString *)recordTime size:(NSString *)recordSize
{
    timeLab.text = recordTime;
    sizeLab.text = recordSize;
}
@end
