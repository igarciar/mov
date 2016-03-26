//
//  SelectImageFromImages.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//


// 消息通知
//==============================================
// 发送消息
#define nSelectImageFromImages   [[NSNotificationCenter defaultCenter]postNotificationName:@"nCBSelectImageFromImages"  object:nil];
// 接收消息
#define nCBSelectImageFromImages [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBSelectImageFromImages) name:@"nCBSelectImageFromImages" object:nil];
//==============================================

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"

@interface SelectImageFromImages : UIViewController
- (IBAction)selectedPhotoButtonEvent:(UIButton *)sender;


@property (readwrite) blePeripheral *currentPeripheral;

@end
