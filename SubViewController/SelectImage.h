//
//  SelectImage.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

// 消息通知
//==============================================
// 发送消息
#define nSelectImage   [[NSNotificationCenter defaultCenter]postNotificationName:@"nCBSelectImage"  object:nil];
// 接收消息
#define nCBSelectImage [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBSelectImage) name:@"nCBSelectImage" object:nil];
//==============================================

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"

@interface SelectImage : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) IBOutlet UIImageView *chooseImageView;
@property (nonatomic) IBOutlet UIButton *includedButton;
@property (nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic) IBOutlet UIButton *akbumButton;

- (IBAction)selectFromImagesButtonEvent:(UIButton *)sender;
- (IBAction)selectFromCameraButtonEvent:(UIButton *)sender;
- (IBAction)selectFromPhotoButtonEvent:(UIButton *)sender;

@property (nonatomic) blePeripheral *currentPeripheral;

@end
