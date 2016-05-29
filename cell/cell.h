//
//  cell.h
//  testiPadCell
//
//  Created by Ignacio Garcia on 13-1-14.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "blePeripheral.h"
#import "Finder.h"

@class blePeripheral;
@interface cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *FindKeyButton;
@property (strong, nonatomic) IBOutlet UILabel *NameLabel;
@property (strong, nonatomic) IBOutlet UILabel *OnOffAntilostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagen2;
@property (strong, nonatomic) IBOutlet UIImageView *flashImageView;
@property (strong, nonatomic) IBOutlet UIImageView *vibrateImageView;
@property (strong, nonatomic) IBOutlet UIImageView *msgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *muteImageView;
@property (strong, nonatomic) IBOutlet UIImageView *BatteryImageView;
@property (strong, nonatomic) IBOutlet UIImageView *RssiImageView;
@property (strong, nonatomic) IBOutlet UIImageView *antilostWorkImageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *onOffBUttons;
- (IBAction)FindKeyPressedEvent:(UIButton *)sender;
- (IBAction)radarButtonEvent:(UIButton *)sender;
- (IBAction)deleteEvent:(UIButton *)sender;

// Property
@property (nonatomic) blePeripheral *currentPeripheral;
@property (nonatomic) Finder *parent;
-(void)refreshCurrentShow;

@end
