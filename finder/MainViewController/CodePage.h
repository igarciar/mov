//
//  codePage.h
//  Magalie121
//
//  Created by Ignacio Garcia Ruiz on 6/6/16.
//  Copyright © 2016 Magalie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CodePage : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *codeField;
- (IBAction)find:(id)sender;
-(void)setParent:(NSObject*)value;

@end
