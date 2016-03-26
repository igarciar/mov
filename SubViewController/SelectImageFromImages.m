//
//  SelectImageFromImages.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "SelectImageFromImages.h"

@interface SelectImageFromImages ()

@end

@implementation SelectImageFromImages
@synthesize currentPeripheral;

#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

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
    [self loadCurrentLocale];
}

- (void)viewDidUnload
{
    //currentPeripheral = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//**************************************************//
#pragma
#pragma 本地语言
//**************************************************//
-(void)loadCurrentLocale{
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"]) {
        // 中文
        self.title = @"选择图片";
    }
    else{
        // English
        self.title = @"SELECT IMAGE";
    }
}

- (IBAction)selectedPhotoButtonEvent:(UIButton *)sender {
    // 更换连接键图片
    NSArray *PictureNameStringArray = [[NSArray alloc]initWithObjects:@"logo.png", @"Trolley.png", @"briefcase.png", @"backpack.png", @"Bag.png", @"suitcase.png", @"purse.png", @"keys.png", @"dog.png", @"cat.png", @"baby.png", @"boy.png", @"girl.png", nil];
    NSString *pnString = [PictureNameStringArray objectAtIndex:[sender tag]];
    currentPeripheral.choosePicture = [UIImage imageNamed:pnString];
    [self.navigationController popViewControllerAnimated:YES];
    nSelectImageFromImages
}
@end
