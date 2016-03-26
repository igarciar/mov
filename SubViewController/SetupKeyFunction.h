//
//  SetupKeyFunction.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-22.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#define kDisabel                                0x00
#define kSetupDistance                          0x01
#define kWorkOnOff                              0x02

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"

@interface SetupKeyFunction : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *listView;

@property (nonatomic) blePeripheral *currentPeripheral;
@end
