//
//  SelectImage.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "SelectImage.h"
#import "SelectImageFromImages.h"

@interface SelectImage (){
    finderAppDelegate    *blead;
    CGRect imageFrame;
}

@end

@implementation SelectImage

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
    // 使用全局全量
    blead = [[UIApplication sharedApplication]delegate];
    
    [self loadCurrentLocale];
    
    imageFrame = CGRectMake(0, 0, 96, 96);//CGRectMake(0, 0, 200, 200);
    
    nCBSelectImageFromImages
    [self CBSelectImageFromImages];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)viewDidUnload
{
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    _currentPeripheral = nil;
    [self setChooseImageView:nil];
    [self setIncludedButton:nil];
    [self setCameraButton:nil];
    [self setAkbumButton:nil];
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
//    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"]) {
//        // 中文
//        self.title = @"选择图片";
//        [_includedButton setTitle:@"从图片中选取" forState:UIControlStateNormal];
//        [_cameraButton setTitle:@"从摄像头选取" forState:UIControlStateNormal];
//        [_akbumButton setTitle:@"从相册中选取" forState:UIControlStateNormal];
//    }
//    else{
        // English
        self.title = NSLocalizedString(@"SELECT IMAGE",nil);
        [_includedButton setTitle:NSLocalizedString(@"SELECT FROM INCLUDED IMAGES",nil) forState:UIControlStateNormal];
        [_cameraButton setTitle:NSLocalizedString(@"SELECT FROM CAMERA",nil) forState:UIControlStateNormal];
        [_akbumButton setTitle:NSLocalizedString(@"SELECT FROM PHOTO ALBUM",nil) forState:UIControlStateNormal];
//    }
}

//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//

- (IBAction)backButtonEvent:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
    nSelectImage
}

- (IBAction)selectFromImagesButtonEvent:(UIButton *)sender {
    SelectImageFromImages *svc;
    if (blead.screenType == YES) {
        // 4寸
        svc = [[SelectImageFromImages alloc]initWithNibName:@"SelectImageFromImages@568" bundle:nil];
    }
    else{
        // 3.5寸
        svc = [[SelectImageFromImages alloc]initWithNibName:@"SelectImageFromImages" bundle:nil];
    }
    svc.currentPeripheral = _currentPeripheral;
    [self.navigationController pushViewController:svc animated:YES];
    //[AddObjects ViewControllerTransition:self presentModalVC:svc duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromRight];
}

- (IBAction)selectFromCameraButtonEvent:(UIButton *)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectFromPhotoButtonEvent:(UIButton *)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)setCurrentPeripheral:(blePeripheral *)CP{
    _currentPeripheral = CP;
    if (_currentPeripheral != nil) {
        [self CBSelectImageFromImages];
    }
    else{
        _chooseImageView.image = [UIImage imageNamed:@"background.png"];
    }
}

-(void)CBSelectImageFromImages{
    if (_currentPeripheral.choosePicture != nil) {
        _chooseImageView.image = _currentPeripheral.choosePicture;
    }
    else{
        _chooseImageView.image = [UIImage imageNamed:@"background.png"];
    }
}


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
    _chooseImageView.image = shrunkenImage;
    NSArray *aArray = [[NSArray alloc]initWithObjects:shrunkenImage, nil];
    NSLog(@"aArray:%@",aArray);
    
    _currentPeripheral.choosePicture = shrunkenImage;
    [picker dismissViewControllerAnimated:YES  completion:nil];
    [self CBSelectImageFromImages];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES  completion:nil];
}

#pragma mark  -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width * scale, size.height * scale), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return final;
}


- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES  completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error accessing media",nil)
                              message:NSLocalizedString(@"Device doesn’t support that media source.",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Drat!",nil)
                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
