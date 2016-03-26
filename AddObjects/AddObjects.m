//
//  AddObjects.m
//  HIDDongle
//
//  Created by Ignacio Garcia on 12-11-8.
//
//


#import "AddObjects.h"

@implementation AddObjects


/******************************************************/
#pragma mark -
#pragma mark 手动添加控件设置
/******************************************************/
+(UILabel *)addUILabelToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Text:(NSString *)text{
    UILabel *aLabel;
    aLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
    aLabel.adjustsFontSizeToFitWidth = YES;
    aLabel.text = text;
    aLabel.numberOfLines = 1;
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:aLabel];
    return aLabel;
}

+(UIButton *)addUIButtonToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Imagename:(NSString *)imagename Title:(NSString *)title{
    UIButton *aButton;
    aButton = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [aButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    if (title != nil) {
        [aButton setTitle:title forState:UIControlStateNormal];
        //[aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [aButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (imagename != nil) {
        [aButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    }
    [view addSubview:aButton];
    return aButton;
}

+(UIButton *)addInfoDarkToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    UIButton *aInfoDark = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [aInfoDark setFrame:CGRectMake(x, y, width, height)];
    [view addSubview:aInfoDark];
    return aInfoDark;
}

+(UIButton *)addInfoLightToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    UIButton *aInfoLight = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [aInfoLight setFrame:CGRectMake(x, y, width, height)];
    [view addSubview:aInfoLight];
    return aInfoLight;
}

+(UIButton *)addRoundedRectToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Title:(NSString *)title{
    UIButton *aRoundedRect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aRoundedRect setFrame:CGRectMake(x, y, width, height)];
    [aRoundedRect setTitle:title forState:UIControlStateNormal];
    [view addSubview:aRoundedRect];
    return aRoundedRect;
}

+(UIImageView *)addUIImageViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Imagename:(NSString *)imagename{
    UIImageView *aImageView;
    aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    aImageView.image = [UIImage imageNamed:imagename];
    [view addSubview:aImageView];
    return aImageView;
}

+(UITextField *)addUITextFieldToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Text:(NSString *)text Font:(UIFont *)font{
    UITextField *aTextField;
    aTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, y, width, height)];
    aTextField.text = text;
    aTextField.font = font;
    aTextField.keyboardType = UIKeyboardTypeDefault;
    aTextField.returnKeyType = UIReturnKeyDone;
    aTextField.textAlignment = NSTextAlignmentCenter;
    aTextField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    aTextField.borderStyle = UITextBorderStyleRoundedRect;
    //[aTextField setDelegate:(id<UITextFieldDelegate>)self];
    [view addSubview:aTextField];
    return aTextField;
}

+(UIControl *)addUIControlToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    UIControl *aControl;
    aControl = [[UIControl alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [view addSubview:aControl];
    return aControl;
}

+(UISwitch *)addUISwitchToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    UISwitch *aSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [view addSubview:aSwitch];
    return aSwitch;
}

+(UISegmentedControl *)addUISegmentedControlToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height style:(UISegmentedControlStyle)style ButtonNames:(NSArray *)buttonNames SelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    UISegmentedControl *aSegmentedControl = [[UISegmentedControl alloc]initWithItems:buttonNames];
    [aSegmentedControl setFrame:CGRectMake(x, y, width, height)];
    aSegmentedControl.segmentedControlStyle = style;
    aSegmentedControl.selectedSegmentIndex = selectedSegmentIndex;
    [view addSubview:aSegmentedControl];
    return aSegmentedControl;
}

+(UITableView *)addUITableViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height {
    UITableView *aTableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
    //[aTableView setDelegate:(id<UITableViewDelegate>)self];
    //[aTableView setDataSource:(id<UITableViewDataSource>)self];
    [view addSubview:aTableView];
    return aTableView;
}

+(UITextView *)addUITextViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height TextColor:(UIColor *)color Font:(UIFont *)font {
    UITextView *aTextView = [[UITextView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    aTextView.font = font;
    [aTextView setTextColor:color];
    aTextView.editable = NO;
    //aTextView.textAlignment = UITextAlignmentLeft;
    [view addSubview:aTextView];
    return aTextView;
}

+(UIPageControl *)addUIPageControlToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height NumberOfPages:(NSInteger)no TintColor:(UIColor *)tintColor CurrentColor:(UIColor *)currentColor{
    UIPageControl *aPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(x, y, width, height)];
    aPageControl.numberOfPages = no;
    aPageControl.currentPage = 0;
    [view addSubview:aPageControl];
    return aPageControl;
}

+(UIPickerView *)addUIPickerViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    UIPickerView *aPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [aPickerView setDelegate:(id<UIPickerViewDelegate>)self];
    [aPickerView setDataSource:(id<UIPickerViewDataSource>)self];
    [view addSubview:aPickerView];
    return aPickerView;
}


+(UISlider *)addUISliderViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height CurrentValue:(float)currentValue MinValue:(float)minValue MaxValue:(float)maxValue{
    UISlider *aSlider = [[UISlider alloc]initWithFrame:CGRectMake(x, y, width, height)];
    aSlider.value = currentValue;
    aSlider.minimumValue = minValue;
    aSlider.maximumValue = maxValue;
    [view addSubview:aSlider];
    return aSlider;
    
}

+(UIView *)addUIViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height{
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [view addSubview:aView];
    return aView;
}

/******************************************************/
#pragma mark -
#pragma mark 界面转换动画
/******************************************************/
+(id)viewTransition:(UIView *)view AddView:(UIView *)fv duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    /*
     CATransition动画使用了类型type和子类型subtype两个概念。type属性指定了过渡的种类（淡化、推挤、揭开、覆盖）。subtype设置了过渡的方向（从上、下、左、右）。另外，CATransition私有的动画类型有（立方体、吸收、翻转、波纹、翻页、反翻页、镜头开、镜头关）。
     */
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    //{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.type = type;//@"cube"; //kCATransitionMoveIn;
    //{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.subtype = subtype;//kCATransitionFromRight;
    transition.delegate = self;
    
    [fv.layer addAnimation:transition forKey:nil];
    // 要做的
    [view addSubview:fv];
    return view;
}

+(id)viewTransition:(UIView *)view RemoveView:(UIView *)fv duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    /*
     CATransition动画使用了类型type和子类型subtype两个概念。type属性指定了过渡的种类（淡化、推挤、揭开、覆盖）。subtype设置了过渡的方向（从上、下、左、右）。另外，CATransition私有的动画类型有（立方体、吸收、翻转、波纹、翻页、反翻页、镜头开、镜头关）。
     */
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    //{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.type = type;//@"cube"; //kCATransitionMoveIn;
    //{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.subtype = subtype;//kCATransitionFromRight;
    transition.delegate = self;
    
    [fv.layer addAnimation:transition forKey:nil];
    // 要做的
    [fv removeFromSuperview];
    return view;
}

+(id)setViewTransition:(UIView *)view duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    /*
     CATransition动画使用了类型type和子类型subtype两个概念。type属性指定了过渡的种类（淡化、推挤、揭开、覆盖）。subtype设置了过渡的方向（从上、下、左、右）。另外，CATransition私有的动画类型有（立方体、吸收、翻转、波纹、翻页、反翻页、镜头开、镜头关）。
     */
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    //{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.type = type;//@"cube"; //kCATransitionMoveIn;
    //{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.subtype = subtype;//kCATransitionFromRight;
    transition.delegate = self;
    
    [view.layer addAnimation:transition forKey:nil];
    return view;
}


/******************************************************/
#pragma mark -
#pragma mark 界面转换动画
/******************************************************/
+(id)AddTransitionToView:(UIView *)view duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    /*
     CATransition动画使用了类型type和子类型subtype两个概念。type属性指定了过渡的种类（淡化、推挤、揭开、覆盖）。subtype设置了过渡的方向（从上、下、左、右）。另外，CATransition私有的动画类型有（立方体、吸收、翻转、波纹、翻页、反翻页、镜头开、镜头关）。
     */
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    
    //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
    transition.subtype = subtype;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.delegate = self;
    
    [view.layer addAnimation:transition forKey:nil];
    return view;
}


/******************************************************/
#pragma mark -
#pragma mark ViewController界面转换动画
/******************************************************/
// 添加一个新界面

+(id)ViewControllerTransition:(id)se presentModalVC:(UIViewController *)vc duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    transition.type = type;//@"cube";
    //transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.subtype = subtype;//kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.delegate = self;
    
    [vc.view.layer addAnimation:transition forKey:nil];
    [se presentViewController:vc animated:NO completion:nil];
    return se;
}


/******************************************************/
#pragma mark -
#pragma mark NavigationController界面转换动画
/******************************************************/

// 添加一个新界面
+(id)NCPushViewTransition:(UINavigationController *)nc PushVC:(UIViewController *)fv duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    transition.type = type;//@"cube";
    //transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.subtype = subtype;//kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.delegate = self;
    [nc.view.layer addAnimation:transition forKey:nil];
    
    [nc pushViewController:fv animated:NO];
    return nc;
}

// 跳回Push的任意一个界面
+(id)NCPopToViewTransition:(UINavigationController *)nc atIndex:(NSUInteger)idx duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    transition.type = type;//@"cube";
    //transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.subtype = subtype;//kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.delegate = self;
    [nc.view.layer addAnimation:transition forKey:nil];
    
    [nc popToViewController:[nc.viewControllers objectAtIndex:idx] animated:NO];
    return nc;
}

// 返回前一个界面
+(id)NCPopViewTransition:(UINavigationController *)nc duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    transition.type = type;//@"cube";
    //transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.subtype = subtype;//kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.delegate = self;
    [nc.view.layer addAnimation:transition forKey:nil];
    [nc popViewControllerAnimated:NO];
    return nc;
}

+(id)NCPopToRootViewTransition:(UINavigationController *)nc duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //更多私有{立方体:@"cube"、吸收:@"suckEffect"、翻转:@"oglFlip"、波纹:@"rippleEffect"、翻页:@"pageCurl"、反翻页:@"pageUnCurl"、镜头开:@"cameraIrisHollowOpen"、镜头关:@"cameraIrisHollowClose"};
    transition.type = type;//@"cube";
    //transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    transition.subtype = subtype;//kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    transition.delegate = self;
    [nc.view.layer addAnimation:transition forKey:nil];
    [nc popToRootViewControllerAnimated:NO];
    return nc;
}

#pragma mark -
#pragma mark Saved

// 载入设备
+(NSData *)readData{
    NSData *adate = 0x00;
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:pathlist];
    BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:path];
    if (fileExists) {
        NSArray *readValue = [[NSArray alloc]initWithContentsOfFile:path];
        NSLog(@"readValue:%@",readValue);
        return [readValue objectAtIndex:0];
    }
    return adate;
}

+(BOOL)compareData:(Byte)byte{
    NSData *adata = [self readData];
    NSData *bdata = [[NSData alloc]initWithBytes:&byte length:1];
    if ([adata isEqualToData:bdata]) {
        return YES;
    }
    return NO;
}


// 添加设备
+(void)SaveData:(Byte)byte{
    NSData *adata = [[NSData alloc]initWithBytes:&byte length:1];
    NSArray *saveValue = [[NSArray alloc]initWithObjects:adata, nil];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:pathlist];
    [saveValue writeToFile:path atomically:YES];
    NSLog(@"saveValue:%@",saveValue);
}

// 添加设备
+(void)SaveArray:(NSArray *)array ToPath:(NSString *)pathString{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:pathlist];
    [array writeToFile:path atomically:YES];
    NSLog(@"array:%@",array);
}

+(NSArray *)readArrayFromPath:(NSString *)pathString{
    NSArray *array = nil;
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:pathlist];
    BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:path];
    if (fileExists) {
        NSArray *array = [[NSArray alloc]initWithContentsOfFile:path];
        NSLog(@"array:%@",array);
    }
    return array;
}



@end
