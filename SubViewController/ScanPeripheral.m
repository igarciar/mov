//
//  ScanPeripheral.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "ScanPeripheral.h"
#import "finderAppDelegate.h"
#import "SetupProperty.h"

@interface ScanPeripheral (){
    finderAppDelegate    *blead;
    NSTimer                 *AutoStopScanTimer;
    BOOL                    ScanFlag;
    NSString                *scanString;
    NSString                *stopString;
}

@end

@implementation ScanPeripheral

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
    
    _scanActivityIndicatorView.hidden = YES;
    
    [_blePeriperalTableView setDelegate:(id<UITableViewDelegate>)self];
    [_blePeriperalTableView setDataSource:(id<UITableViewDataSource>)self];
    [_blePeriperalTableView reloadData];
    
    ScanFlag = NO;
    [self scanButtonEvent:nil];
//    _blePeriperalTableView.backgroundColor=[UIColor blackColor];
//    CGRect frame=_blePeriperalTableView.frame;
  //  _blePeriperalTableView.frame=CGRectMake(frame.origin.x,frame.origin.y,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-frame.origin.y-64);
 //   CGRect frame2=_scanActivityIndicatorView.frame;
 //   _scanActivityIndicatorView.frame=CGRectMake(frame2.origin.x,frame2.origin.y+64,frame2.size.width,frame2.size.height);
 //   frame2=_scanButton.frame;
  //  _scanButton.frame=CGRectMake(frame2.origin.x,frame2.origin.y+64,frame2.size.width,frame2.size.height);
    
    nCBCentralStateChange
    nCBSetupPropertyFromScanPeripherialToFinder
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    //[self setHidesBottomBarWhenPushed:YES];
}
- (void)viewDidUnload
{
    _currentPeripheral = nil;
    [self setBlePeriperalTableView:nil];
    [self setScanActivityIndicatorView:nil];
    [self setScanButton:nil];
   // [self setTitleLabel:nil];
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

        // English
       // self.title = _titleLabel.text = NSLocalizedString(@"SCAN PERIPHERAL",nil);
        scanString = NSLocalizedString(@"ScanString", nil);
        stopString = NSLocalizedString(@"StopString", nil);
    [_scanButton setTitle:scanString forState:UIControlStateNormal];
}

//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//
- (IBAction)backButtonEvent:(id)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
    [self autoStopScanEvent];
    [blead.ble startScanning];
}

- (IBAction)scanButtonEvent:(id)sender{
    if (ScanFlag == NO) {
        ScanFlag = YES;
        _scanActivityIndicatorView.hidden = NO;
        [_scanActivityIndicatorView startAnimating];
        [_scanButton setTitle:stopString forState:UIControlStateNormal];
        blead.ble.ScanPeripheralArray = [[NSMutableArray alloc]init];
        [_blePeriperalTableView reloadData];
        [blead.ble resetScanning];
        
        [AutoStopScanTimer invalidate];
        AutoStopScanTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(autoStopScanEvent) userInfo:nil repeats:NO];
    }
    else{
        ScanFlag = NO;
        _scanActivityIndicatorView.hidden = YES;
        [_scanActivityIndicatorView stopAnimating];
        [_scanButton setTitle:scanString forState:UIControlStateNormal];
        [blead.ble stopScanning];
        [AutoStopScanTimer invalidate];
        AutoStopScanTimer = nil;
    }
}

-(void)autoStopScanEvent{
    ScanFlag = NO;
    _scanActivityIndicatorView.hidden = YES;
    [_scanActivityIndicatorView stopAnimating];
    [_scanButton setTitle:scanString forState:UIControlStateNormal];
    [blead.ble stopScanning];
}

//**************************************************//
#pragma
#pragma 回调函数
//**************************************************//
-(void)CBCentralStateChange{
    [_blePeriperalTableView reloadData];
}

-(void)CBSetupPropertyFromScanPeripherialToFinder{
   
    
    //[self autoStopScanEvent];
    [blead.ble resetScanning];
}


#pragma 表格处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return blead.ble.ScanPeripheralArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    NSDictionary *ad = [blead.ble.ScanPeripheralArray objectAtIndex:indexPath.row];
    
    CBPeripheral *ap = [ad objectForKey:kPeripheralKey];
    
    
    NSData *macData = [ad objectForKey:kMacdataKey];
    Byte *macByte = (Byte *)[macData bytes];
    cell.textLabel.text = ap.name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"Magalie Security %@", ap.identifier.UUIDString];
    
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (blead.ble.ScanPeripheralArray.count > indexPath.row) {
        SetupProperty *svc;
        if (blead.screenType == YES) {
            // 4寸
            svc = [[SetupProperty alloc]initWithNibName:@"SetupProperty@568" bundle:nil];
        }
        else{
            // 3.5寸
            svc = [[SetupProperty alloc]initWithNibName:@"SetupProperty" bundle:nil];
        }
        [blead.ble addNewConnectPeripheralToBlePeripheralArrayFromScanPeripheralArrayAtInteger:indexPath.row];
        svc.currentPeripheral = [blead.ble.blePeripheralArray objectAtIndex:0];
        svc.backMainViewController = NO;
        [self autoStopScanEvent];
        //NSLog(@"svc.currentPeripheral:%@",svc.currentPeripheral);
        // 连接当前设备
        //blead.ble.connectPeripheralAtUInteger = svc.currentIntegerFromScanPeripheral;
//        [AddObjects ViewControllerTransition:self presentModalVC:svc duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
       // self.hidesBottomBarWhenPushed = YES;
        //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        //[self.navigationItem setBackBarButtonItem:backItem];
        [self.navigationController pushViewController:svc animated:true];
    }
    else{
        NSLog(@"ERROR ROW");
    }
    self.navigationController.navigationBarHidden = YES;
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


@end
