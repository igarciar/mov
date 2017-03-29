//
//  finderAppDelegate.m
//  finder
//
//  Created by Ignacio Garcia on 16-03-23.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "finderAppDelegate.h"

@implementation finderAppDelegate
@synthesize tabBar =_tabBar;
@synthesize fvc = _fvc;
//@synthesize rvc = _rvc;
@synthesize svc = _svc;
@synthesize info = _info;
@synthesize codepage = _codepage;
@synthesize add = _add;
@synthesize ble;
@synthesize screenType;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//     Override point for customization after application launch.
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    NSLog(@"--------=====%@",NSLocalizedString(@"InformationTitle", nil));
    
    // 初始化蓝牙
    ble = [[bleCentralManager alloc]init];
    [ble ReadPeripheralProperty];
    
    // 判断屏幕大小
    CGRect currentFrame = [UIScreen mainScreen].bounds;
    const float ScreenRatio40 = 568.0/320.0;
    //const float ScreenRatio40_2 = 568.0/300.0;
    float currentScreenRatio = currentFrame.size.height/currentFrame.size.width;
    //NSLog(@"ScreenRatio40_1:%f ScreenRatio40_2:%f currentScreenRatio:%f", ScreenRatio40_1, ScreenRatio40_2, currentScreenRatio);
    if (currentScreenRatio == ScreenRatio40) {
        // 4.0
        screenType = Screen40;
    }
    else{
        // 3.5
        screenType = Screen35;
    }
    screenType = Screen40;
     self.window.backgroundColor = [UIColor blackColor]; //白色背景
    // 添加TabBar
    //comprovar activacion
    if([self activado]){
        [self loadcontrols];
    }else{
        
        [self addTabBar];
        _codepage= [[CodePage alloc] initWithNibName:@"codepage" bundle:nil];
        //[_codepage setParent:self];
         self.window.rootViewController=_codepage;
        [[_fvcNavigation navigationController] setNavigationBarHidden:YES animated:YES];
       [_fvcNavigation pushViewController:_codepage animated:YES];
    /*
       UIWindow* window = [UIApplication sharedApplication].keyWindow;
        self.window.rootViewController=_codepage;
       
       
       [_codepage.view setFrame:self.window.frame];
       [self.window addSubview:_codepage.view];
      */
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(BOOL) activado{

    return [self displayContent];
}
-(void)loadcontrols{
    [self writeToTextFile];
    [self addTabBar];
[_fvcNavigation pushViewController:_fvc animated:YES];
_tabBar.viewControllers = [NSArray arrayWithObjects:_fvcNavigation,_addNavifation,_infoNavifation,nil];
    [self.window makeKeyAndVisible];
    
   // exit(0);
 

}

-(void)addTabBar{
    _fvcNavigation = [UINavigationController new];
    _addNavifation = [UINavigationController new];
    _infoNavifation = [UINavigationController new];

    if (screenType == YES) {
        _fvc = [[Finder alloc]initWithNibName:@"Finder@568" bundle:nil];
        _info = [[Setting alloc]initWithNibName:@"Setting@568" bundle:nil];
        _add= [[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral@568" bundle:nil];
    }
    else{
        _fvc = [[Finder alloc]initWithNibName:@"Finder" bundle:nil];
        _info = [[Setting alloc]initWithNibName:@"Setting" bundle:nil];
        _add = [[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral" bundle:nil];
    }
   

    _fvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabItem1", nil) image:[UIImage imageNamed:@"main_ico.png"] tag:0];
    _add.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabItem3", nil) image:[UIImage imageNamed:@"add_ico_white.png"] tag:1];
    _info.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabItem4", nil) image:[UIImage imageNamed:@"info_w.png"] tag:2];
//    }
//    [_fvcNavigation pushViewController:_fvc animated:YES];
    [_addNavifation pushViewController:_add animated:YES];
    [_infoNavifation pushViewController:_info animated:YES];
    
    _tabBar = [[UITabBarController alloc]init];
    _tabBar.tabBar.backgroundColor=[UIColor blackColor];
    _tabBar.tabBar.barTintColor=[UIColor blackColor];
    _tabBar.tabBar.barTintColor=[UIColor blackColor];
    _tabBar.tabBar.tintColor=[UIColor whiteColor];
    
    
    
    
    
    //  _tabBar.viewControllers = [NSArray arrayWithObjects:_fvcNavigation, _svcNavifation,_addNavifation,_infoNavifation,nil];
    
    _tabBar.viewControllers = [NSArray arrayWithObjects:_fvcNavigation,nil];
    
   [self.window addSubview:_tabBar.view];
//    NSLog(@"%.0f",_tabBar.tabBar.frame.size.height);
    self.window.rootViewController=_tabBar;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 存储设备信息
    [ble SavePeripheralProperty];
    nEnterBackground
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    nEnterForeground
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[ble SavePeripheralProperty];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addButtonEvent:(UIButton *)sender {
    //blead.bfvc.HiddentabBar = YES;
    // 停止扫描
    [ble stopScanning];
    ble.ScanPeripheralArray = [[NSMutableArray alloc]init];

    /* lo comente yo
    
    ScanPeripheral *viewController ;
    if (screenType == YES) {
        // 4寸
        //        [AddObjects ViewControllerTransition:self presentModalVC:[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral@568" bundle:nil] duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
        viewController =[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral@568" bundle:nil];
    }
    else{
        // 3.5寸
        //        [AddObjects ViewControllerTransition:self presentModalVC:[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral" bundle:nil] duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
        viewController =[[ScanPeripheral alloc]initWithNibName:@"ScanPeripheral" bundle:nil];
    }

    [self setHidesBottomBarWhenPushed:NO];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    //[AddObjects setViewTransition:self.navigationController.view duration:DurationTime withTyte:@"cube" andSubtype:kCATransitionFromRight];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [_AntilostTableView setEditing:NO animated:YES];
 */
    
}


//////////////////////////////
//  SAVE FILE    ////
NSString * nameFile=@"activacion.code";

//Method writes a string to a text file

-(void) writeToTextFile{
    //get the documents directory:
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:nameFile];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
}


//Method retrieves content from documents directory and
//displays it in an alert
-(BOOL) displayContent{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:nameFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    { return NO;}
    return NO;
    
}


@end
