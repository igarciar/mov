//
//  AddObjects.h
//  HIDDongle
//
//  Created by Ignacio Garcia on 12-11-8.
//
//
#define DurationTime 0.7f
#define ComData 0xD1
#define pathlist @"HIDFristWorkData.plist"
#define arrayString @"HIDSavedKeyList.plist"
#define durationTime        0.3f

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface AddObjects : NSObject


+(UILabel *)addUILabelToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Text:(NSString *)text;

+(UIButton *)addUIButtonToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Imagename:(NSString *)imagename Title:(NSString *)title;

+(UIButton *)addInfoDarkToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(UIButton *)addInfoLightToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(UIButton *)addRoundedRectToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Title:(NSString *)title;

+(UIImageView *)addUIImageViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Imagename:(NSString *)imagename;

+(UITextField *)addUITextFieldToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height Text:(NSString *)text Font:(UIFont *)font;

+(UIControl *)addUIControlToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(UISwitch *)addUISwitchToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(UISegmentedControl *)addUISegmentedControlToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height style:(UISegmentedControlStyle)style ButtonNames:(NSArray *)buttonNames SelectedSegmentIndex:(NSInteger)selectedSegmentIndex;

+(UITableView *)addUITableViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(UITextView *)addUITextViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height TextColor:(UIColor *)color Font:(UIFont *)font;

+(UIPageControl *)addUIPageControlToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height NumberOfPages:(NSInteger)no TintColor:(UIColor *)tintColor CurrentColor:(UIColor *)currentColor;

+(UIPickerView *)addUIPickerViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(UISlider *)addUISliderViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height CurrentValue:(float)currentValue MinValue:(float)minValue MaxValue:(float)maxValue;

+(UIView *)addUIViewToShowview:(UIView *)view X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

+(id)viewTransition:(UIView *)view AddView:(UIView *)fv duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)viewTransition:(UIView *)view RemoveView:(UIView *)fv duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)setViewTransition:(UIView *)view duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)AddTransitionToView:(UIView *)view duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)ViewControllerTransition:(id)se presentModalVC:(UIViewController *)vc duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;
#pragma mark -
#pragma mark 界面转换动画

+(id)NCPushViewTransition:(UINavigationController *)nc PushVC:(UIViewController *)fv duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)NCPopToViewTransition:(UINavigationController *)nc atIndex:(NSUInteger)idx duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)NCPopViewTransition:(UINavigationController *)nc duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

+(id)NCPopToRootViewTransition:(UINavigationController *)nc duration:(NSTimeInterval)duration withTyte:(NSString *)type andSubtype:(NSString *)subtype;

#pragma mark -
#pragma mark Saved
+(BOOL)compareData:(Byte)byte;
+(void)SaveData:(Byte)byte;

@end
