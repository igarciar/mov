//
//  Setting.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-15.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "blePeripheral.h"


@interface Perifericos : UIViewController
@property (nonatomic) IBOutlet UITableView *blePeriperalTableView;
@property (nonatomic) IBOutlet UIActivityIndicatorView *scanActivityIndicatorView;

@property (nonatomic) IBOutlet UIButton *scanButton;

@property (readwrite) blePeripheral *currentPeripheral;

@end
