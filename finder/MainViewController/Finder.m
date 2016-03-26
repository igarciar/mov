//
//  Finder.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-15.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "Finder.h"
#import "finderAppDelegate.h"
#import "AddObjects.h"
#import "ScanPeripheral.h"
#import "SetupProperty.h"
#import "cell.h"


@interface Finder (){
    finderAppDelegate   *blead;
    NSString            *editString;
    NSString            *finishString;
    NSString            *addString;
    NSString            *backString;
    
    NSUInteger          idx;
    NSTimer             *deleteTimer;
}

@end

@implementation Finder

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //NSLog(NSLocalizedString(@"title", @""));
    // 设置界面语言
    [self loadCurrentLocale];
    //[self loadNavigationViews];
    // 使用全局全量
    blead = [[UIApplication sharedApplication]delegate];
    
    [_AntilostTableView setDelegate:(id<UITableViewDelegate>)self];
    [_AntilostTableView setDataSource:(id<UITableViewDataSource>)self];
    
    
    NSLog(@"%0.0f",self.navigationController.navigationBar.frame.size.height);
    self.navigationController.navigationBar.hidden=true;
    _AntilostTableView.frame=CGRectMake(0,100,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-100-100);
    _AntilostTableView.layer.borderWidth = 1.0;
    _AntilostTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_AntilostTableView reloadData];
    nCBCentralStateChange
    nCBFinishSetupProperty
    nCBPeripheralStateChange
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"back" object:nil];
}
-(void)backHome  //返回到主页
{
    //NSLog(@"%@",@"homepage action");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loadNavigationViews//加载navigationViews
{
 
    UIBarButtonItem *leftBtn = [UIBarButtonItem new]; //initWithTitle:editString style:nil target:self action:@selector(editButtonEvent:)];
    leftBtn.title = editString;
    //leftBtn.target = self;
    [leftBtn setAction:@selector(editButtonEvent:)];
   // self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [UIBarButtonItem new];
    rightBtn.title = addString;
   // rightBtn.target = self;
    [rightBtn setAction:@selector(addButtonEvent:)];
   // self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)viewDidUnload
{
    [self setAntilostTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//**************************************************//
#pragma
#pragma 本地语言
//**************************************************//
-(void)loadCurrentLocale{
    
    //    _titleView = [[TitleNavigationView alloc]init];
    //    [self.view addSubview:_titleView];
//    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"])  {
//        // 中文
//        self.title  =  @"防丢器列表";
//        editString = @"编辑";
//        finishString = @"完成";
//        addString = @"添加";
//        backString = @"返回";
//    }
//    else{
        // English
        //self.title  = NSLocalizedString(@"AntilostTitle", nil);// @"Antilost";
        editString = NSLocalizedString(@"EditString", nil);//@"edit";
        finishString = NSLocalizedString(@"FinishString", nil);//@"finish";
        addString = NSLocalizedString(@"AddString", nil);//@"add";
        backString =NSLocalizedString(@"BackString", nil);//@"back";
//    }
    
}

//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//
- (IBAction)addButtonEvent:(UIButton *)sender {
    //blead.bfvc.HiddentabBar = YES;
    // 停止扫描
    [blead.ble stopScanning];
    blead.ble.ScanPeripheralArray = [[NSMutableArray alloc]init];
    
    ScanPeripheral *viewController ;
    if (blead.screenType == YES) {
        // 4寸
        //        [AddObjects ViewControllerTransition:self presentModalVC:[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral@568" bundle:nil] duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
        viewController =[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral@568" bundle:nil];
    }
    else{
        // 3.5寸
        //        [AddObjects ViewControllerTransition:self presentModalVC:[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral" bundle:nil] duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
        viewController =[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral" bundle:nil];
    }
    [self setHidesBottomBarWhenPushed:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    //[AddObjects setViewTransition:self.navigationController.view duration:DurationTime withTyte:@"cube" andSubtype:kCATransitionFromRight];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [_AntilostTableView setEditing:NO animated:YES];
    
}

- (IBAction)editButtonEvent:(UIButton *)sender {
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    if (_AntilostTableView.editing == YES) {
        _AntilostTableView.editing = NO;
        //        [_editButton setTitle:editString forState:UIControlStateNormal];
        [button setTitle:editString];
    }
    else{
        _AntilostTableView.editing = YES;
        //        [_editButton setTitle:finishString forState:UIControlStateNormal];
        [button setTitle:finishString];
    }
}

//**************************************************//
#pragma
#pragma 回调函数
//**************************************************//
-(void)CBFinishSetupProperty{
    if (_AntilostTableView.editing == NO) {
        [_AntilostTableView reloadData];
    }
}

-(void)CBCentralStateChange{
    [self CBFinishSetupProperty];
}

-(void)CBPeripheralStateChange{
    [self CBFinishSetupProperty];
}
//**************************************************//
#pragma mark -
#pragma 表格处理
//**************************************************//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blead.ble.blePeripheralArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellTableIdentifier";
    
    UINib *nib ;
    if(blead.ble.blePeripheralArray.count>1){
    nib=[UINib nibWithNibName:@"cell" bundle:nil];
        tableView.rowHeight=120;
    }
    else{
        tableView.rowHeight=370;
        nib=[UINib nibWithNibName:@"cell2" bundle:nil];
    }
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor blackColor];
    // 自动更新
    
    if (![cell.currentPeripheral isEqual:[blead.ble.blePeripheralArray objectAtIndex:indexPath.row]]) {
        cell.currentPeripheral = [blead.ble.blePeripheralArray objectAtIndex:indexPath.row];
        //NSLog(@"当前的数组： %@", blead.ble.blePeripheralArray);
        //NSLog(@"cell.currentPeripheral:%@",cell.currentPeripheral);
    }
    else{
        [cell refreshCurrentShow];
    }
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        blePeripheral *bp = [blead.ble.blePeripheralArray objectAtIndex:indexPath.row];
        bp.cv.AntilostPoweOn = NO;
        bp.cv.EnabelAntilostWork = NO;
        bp.cv.alarmSoundState = kStopAlarmState;
        [bp sendControlValueEvent];
        [bp stopAlarm];
        idx = indexPath.row;
        [deleteTimer invalidate];
        deleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(deleteBLEPeripheral) userInfo:nil repeats:NO];
        
        //
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //0                                     nPlayAlarmStopPost
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)deleteBLEPeripheral{
    [deleteTimer invalidate];
    deleteTimer = nil;
    [blead.ble disconnectPeripheralFromBlePeripheralArrayAtInteger:idx];
    [blead.ble.blePeripheralArray removeObjectAtIndex:idx];
    [blead.ble resetScanning];
    [blead.ble SavePeripheralProperty];
    
    if (blead.ble.blePeripheralArray.count == 0) {
        [self editButtonEvent:nil];
    }
    
    [_AntilostTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _AntilostTableView.editing = NO;
    //blead.bfvc.HiddentabBar = YES;
    SetupProperty *svc;//
    if (blead.screenType == YES) {
        // 4寸
        svc = [[SetupProperty alloc]initWithNibName:@"SetupProperty@568" bundle:nil];
    }
    else{
        // 3.5寸
        svc = [[SetupProperty alloc]initWithNibName:@"SetupProperty" bundle:nil];
    }
    NSLog(@"didclick %@",[[blead.ble.blePeripheralArray objectAtIndex:indexPath.row] recordID]);
    svc.currentPeripheral = [blead.ble.blePeripheralArray objectAtIndex:indexPath.row];
    svc.backMainViewController = YES;
    //    [AddObjects ViewControllerTransition:self presentModalVC:svc duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
    [self setHidesBottomBarWhenPushed:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    //[AddObjects setViewTransition:self.navigationController.view duration:DurationTime withTyte:@"cube" andSubtype:kCATransitionFromRight];
    [self.navigationController pushViewController:svc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
