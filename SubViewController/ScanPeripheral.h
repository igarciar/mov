//
//  ScanPeripheral.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "blePeripheral.h"

@interface ScanPeripheral : UIViewController
@property (nonatomic) IBOutlet UITableView *blePeriperalTableView;
@property (nonatomic) IBOutlet UIActivityIndicatorView *scanActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UIButton *scanButton;

@property (readwrite) blePeripheral *currentPeripheral;
- (IBAction)scanButtonEvent:(id)sender;
@end
