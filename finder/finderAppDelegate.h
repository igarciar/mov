//
//  finderAppDelegate.h
//  finder
//
//  Created by Ignacio Garcia on 16-03-23.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#define Screen40    YES
#define Screen35    NO

#import <UIKit/UIKit.h>
#import "bleCentralManager.h"
#import "AddObjects.h"

#import "Finder.h"
#import "Setting.h"
#import "SetupProperty.h"
#import "Perifericos.h"
#import "ScanPeripheral.h"
#import "CodePage.h"


@class finderViewController;

@interface finderAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBar;

@property (strong, nonatomic) Finder *fvc;
//@property (strong, nonatomic) Setting *svc;
@property (strong, nonatomic) Perifericos *svc;
@property (strong, nonatomic) ScanPeripheral *add;
@property (strong, nonatomic) Setting *info;
@property (strong, nonatomic) CodePage *codepage;

@property (strong, nonatomic) bleCentralManager *ble;
@property (readonly)          bool screenType;
@property (strong, nonatomic) UINavigationController *fvcNavigation,*svcNavifation,*addNavifation,*infoNavifation;
-(void)loadcontrols;
@end
