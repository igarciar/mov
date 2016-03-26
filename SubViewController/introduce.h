//
//  introduce.h
//  LEDcontrol
//
//  Created by Ignacio Garcia on 13-5-23.
//
//

#define MAXPAGE             5-1
#define PNGNAME             @"introduce"

#import <UIKit/UIKit.h>

@interface introduce : UIViewController
@property (weak, nonatomic) IBOutlet UIView *introuduceView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)pageControlValueChangedEvent:(UIPageControl *)sender;
- (IBAction)backButtonEvent:(UIButton *)sender;

@end
