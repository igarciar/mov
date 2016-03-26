//
//  Setting.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-15.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface Setting : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSArray *aboutArray,*sharArray;

@end
