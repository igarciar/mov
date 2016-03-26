//
//  introduce.m
//  LEDcontrol
//
//  Created by Ignacio Garcia on 13-5-23.
//
//

#import "introduce.h"
#import "AddObjects.h"

@interface introduce (){
    UIImageView     *imageView01;
    UIImageView     *imageView02;
    UIImageView     *imageView03;
    UIImageView     *imageView04;
    UIImageView     *imageView05;
    
    NSString        *imageString1;
    NSString        *imageString2;
    NSString        *imageString3;
    NSString        *imageString4;
    NSString        *imageString5;
}

@end

@implementation introduce

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置本地语音界面
    [self loadCurrentLocale];
    
    // 初始化类
    [self setShowView];
    self.pageControl.currentPage = 0;
    [_introuduceView addSubview:imageView01];
    
    // 手滑事件初始化
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    CGRect frame=_introuduceView.frame;
    CGRect frame2=self.pageControl.frame;
    _introuduceView.frame=CGRectMake(frame.origin.x,frame.origin.y+64,frame.size.width,frame.size.height);
    self.pageControl.frame=CGRectMake(frame2.origin.x,frame2.origin.y+64,frame2.size.width,frame2.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPageControl:nil];
    [self setIntrouduceView:nil];
    [super viewDidUnload];
}

//**************************************************//
#pragma
#pragma 本地语言
//**************************************************//
-(void)loadCurrentLocale{
//  if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"]) {
//      // 中文
//      self.title = @"操作说明";
//      imageString1 = @"introduce1_CN.png";
//      imageString2 = @"introduce2_CN.png";
//      imageString3 = @"introduce3_CN.png";
//      imageString4 = @"introduce4_CN.png";
//      imageString5 = @"introduce5_CN.png";
//    }
//    else{
        // English
        self.title  = NSLocalizedString(@"INTRODUCE", nil);
        imageString1 = @"introduce1_EN.png";
        imageString2 = @"introduce2_EN.png";
        imageString3 = @"introduce3_EN.png";
        imageString4 = @"introduce4_EN.png";
        imageString5 = @"introduce5_EN.png";
//    }
}

//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//
- (IBAction)pageControlValueChangedEvent:(UIPageControl *)sender {
    static NSUInteger currentPageBack = 0;
    if (sender.currentPage > currentPageBack) {
        currentPageBack = sender.currentPage;
        [self pageControllerUp];
    }
    else if (sender.currentPage < currentPageBack) {
        currentPageBack = sender.currentPage;
        [self pageControllerDown];
    }
}

- (IBAction)backButtonEvent:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Swipe Gesture Recognizer
/****************************************************************************/
/*                      Swipe Gesture Recognizer							*/
/****************************************************************************/
// 手滑事件处理
- (void)swipeRecognizer:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft ) {
        if (self.pageControl.currentPage>=MAXPAGE) {
            self.pageControl.currentPage = MAXPAGE;
        }
        else{
            self.pageControl.currentPage++;
            [self pageControllerUp];
        }
        NSLog(@"Left");
    }
    else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight ) {
        if (self.pageControl.currentPage==0) {
            self.pageControl.currentPage = 0;
        }
        else{
            self.pageControl.currentPage--;
            [self pageControllerDown];
        }
        NSLog(@"Right");
    }
}

#pragma mark -
#pragma mark 页面变化函数函数
/****************************************************************************/
/*                      页面变化函数函数                                       */
/****************************************************************************/
-(void)pageControllerUp{
    [AddObjects setViewTransition:_introuduceView duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromRight];
    switch (self.pageControl.currentPage) {
        case 0:
            [_introuduceView addSubview:imageView01];
            break;
            
        case 1:
            [_introuduceView addSubview:imageView02];
            break;
            
        case 2:
            [_introuduceView addSubview:imageView03];
            break;
            
        case 3:
            [_introuduceView addSubview:imageView04];
            break;
            
        case 4:
            [_introuduceView addSubview:imageView05];
            break;
            
        default:
            break;
    }
}

-(void)pageControllerDown{
    [AddObjects setViewTransition:_introuduceView duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromLeft];
    switch (self.pageControl.currentPage) {
        case 0:
            [_introuduceView addSubview:imageView01];
            break;
            
        case 1:
            [_introuduceView addSubview:imageView02];
            break;
            
        case 2:
            [_introuduceView addSubview:imageView03];
            break;
            
        case 3:
            [_introuduceView addSubview:imageView04];
            break;
            
        case 4:
            [_introuduceView addSubview:imageView05];
            break;
            
        default:
            break;
    }
}

/****************************************************************************/
/*                      页面设置函数                                          */
/****************************************************************************/
-(void)setShowView{
    imageView01 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.introuduceView.frame.size.width, self.introuduceView.frame.size.height)];
    imageView02 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.introuduceView.frame.size.width, self.introuduceView.frame.size.height)];
    imageView03 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.introuduceView.frame.size.width, self.introuduceView.frame.size.height)];
    imageView04 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.introuduceView.frame.size.width, self.introuduceView.frame.size.height)];
    imageView05 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.introuduceView.frame.size.width, self.introuduceView.frame.size.height)];
    
    
    imageView01.image = [UIImage imageNamed:imageString1];
    imageView02.image = [UIImage imageNamed:imageString2];
    imageView03.image = [UIImage imageNamed:imageString3];
    imageView04.image = [UIImage imageNamed:imageString4];
    imageView05.image = [UIImage imageNamed:imageString5];
}

@end
