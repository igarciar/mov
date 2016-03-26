//
//  SetTimerOnOff.h
//  finder
//
//  Created by David ding on 13-3-18.
//  Copyright (c) 2013年 David ding. All rights reserved.
//
#define kHourComponent      0
#define kMinuteComponent    1

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"

@interface SetTimerOnOff : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *pickerShowOrHideBtn;
@property (nonatomic, strong) UISwitch *switchTime;
- (IBAction)backButtonEvent:(UIButton *)sender;
- (IBAction)enabelTimerSwitchEvent:(UISwitch *)sender;

@property (nonatomic) blePeripheral *currentPeripheral;
@end
