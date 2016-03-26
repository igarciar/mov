//
//  Setting.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-15.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "Perifericos.h"
#import "finderAppDelegate.h"
#import "SetupProperty.h"


@interface Perifericos (){
    finderAppDelegate    *blead;
    NSTimer                 *AutoStopScanTimer;
    BOOL                    ScanFlag;
    NSString                *scanString;
    NSString                *stopString;
}

@end

@implementation Perifericos
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
    
}
- (void)viewDidUnload
{
    _currentPeripheral = nil;
    [self setBlePeriperalTableView:nil];
    [self setScanActivityIndicatorView:nil];
    [self setScanButton:nil];

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
    //    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"]) {
    //        // 中文
    //        self.title = _titleLabel.text = @"扫描防丢器";
    //        scanString = @"扫描";
    //        stopString = @"停止";
    //    }
    //    else{
    // English
    //self.title = _titleLabel.text = NSLocalizedString(@"SCAN PERIPHERAL",nil);
    scanString = NSLocalizedString(@"ScanString", nil);
    stopString = NSLocalizedString(@"StopString", nil);
    //    }
    }


@end
