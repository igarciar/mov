//
//  Setting.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-15.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <Social/Social.h>
//#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "Setting.h"
#import "finderAppDelegate.h"
#import "introduce.h"

@interface Setting (){
    finderAppDelegate       *blead;
    NSString                *postText;
    NSString                *sociaText;
    NSString                *sharedStr;
    NSString                *aboutStr;
    NSString                *operateStr;
    NSArray                 *imageShareArray;
}

@end

@implementation Setting

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

    imageShareArray =[ [NSArray alloc]initWithObjects:@"twitter",@"facebook",@"weibo",@"weibo", nil];
    // 设置本地语音界面
    [self loadCurrentLocale];
 
    // 使用全局变量
    blead = [[UIApplication sharedApplication]delegate];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
}
- (void)viewDidUnload
{
 
    [self setListView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//**************************************************//
#pragma
#pragma 本地语言
//**************************************************//
-(void)loadCurrentLocale{
//    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"])  {
//        // 中文
//        self.title = @"软件信息";
//        sharedStr = @"发布";
//        aboutStr =@"关于";
//        operateStr = @"操作说明";
//        self.sharArray = [NSArray arrayWithObjects:@"发布到Twintter",@"发布到Facebook",@"发布到新浪微博",operateStr, nil];
//        self.aboutArray = [NSArray arrayWithObjects:@"公司网站",@"联系开发者",@"更多BLE软件", nil];
//        sociaText = @"我现在使用的这个防丢器软件很有意思，推荐你也可以试一下！";
//   
//    }
//    else{
        // English
    self.title = NSLocalizedString(@"SetupTitle", nil);
    sharedStr = NSLocalizedString(@"sharedStr", nil);
    aboutStr = NSLocalizedString(@"aboutStr", nil);
    operateStr = NSLocalizedString(@"operateStr", nil);
    self.sharArray = [NSArray arrayWithObjects:NSLocalizedString(@"SHARE TO TWITTER", nil),NSLocalizedString(@"SHARE TO FACEBOOK", nil),NSLocalizedString(@"SHARE TO WEIBO", nil),operateStr, nil];
    self.aboutArray = [NSArray arrayWithObjects:NSLocalizedString(@"COMPANY WEB", nil) ,NSLocalizedString(@"CONTACT US", nil),NSLocalizedString(@"MORE APP ABOUT BLE", nil) , nil];
    sociaText = NSLocalizedString(@"sociaText", nil);
//    }
}

//**************************************************//
#pragma
#pragma 按键功能
//**************************************************//
- (IBAction)informationButtonEvent:(UIButton *)sender {
    //blead.bfvc.HiddentabBar = YES;
    NSLog(@"info button");
    
}
//*********跳转
-(void)informationFuctionView
{
    UIViewController *controller;
    if (blead.screenType == YES) {         // 4寸
        controller = [[introduce alloc]initWithNibName:@"introduce40" bundle:nil];
    }
    else{        // 3.5寸
        
        controller = [[introduce alloc]initWithNibName:@"introduce35" bundle:nil];
    }
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void) displayText:(NSString *) sOutput {
    NSLog(@"out : %@",sOutput);
}

//the delegate 委托系统处理
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送邮件");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送邮件");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送出错: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    }

-(void)postMessageForServiceType:(NSString*)inServiceType {
    SLComposeViewController* socialController = [SLComposeViewController composeViewControllerForServiceType:inServiceType];
    
    if ( nil != socialController ) {
        [socialController setInitialText:sociaText];
        
        [socialController addImage:[UIImage imageNamed:@"bolso_amarillo.png"]];
        

       // NSURL *socialURL = [[NSURL alloc]initFileURLWithPath:@"https://itunes.apple.com/us/app/fu-kang-fang-diu-qi/id704210894"];
       // [socialController addURL:socialURL];

        [self presentViewController:socialController animated:YES  completion:nil] ;
    }
}


#pragma UItableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//反回分组的个数
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return sharedStr;
    }else if(section == 1){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        return  [NSString stringWithFormat:@"%@  V%@",aboutStr,[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }
    return self.title;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return _sharArray.count;
    }else if(section == 1){
        return  _aboutArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *identifier = @"CustomIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton;
    if(indexPath.section == 0)
    {
        UIImage *image = [UIImage imageNamed:imageShareArray[indexPath.row]];
        [cell.imageView setImage:image];
        cell.textLabel.text = _sharArray[indexPath.row];
    }else if(indexPath.section == 1){
        cell.textLabel.text = _aboutArray[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"listview did selected ");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {  //分享
        switch (indexPath.row) {
                case 0:
                    [self postMessageForServiceType:SLServiceTypeTwitter];;
                    break;
                case 1:
                    [self postMessageForServiceType:SLServiceTypeFacebook];
                    break;
                case 2:
                    [self postMessageForServiceType:SLServiceTypeSinaWeibo];
                    break;
          //  case 3:
          //      [self informationFuctionView];
          //      break;
                default:
                    break;
        }
    }else if(indexPath.section == 1){  //关于
        switch (indexPath.row) {
            case 0:
                [self openWeb];
                break;
            case 1:
                [self contactDeveloper];
                break;
            default:
                break;
        }
    }
}

-(void) openWeb
{
    // 按键打开网站
    NSString* urlText = [NSString stringWithFormat:@"http://www.szIgnacio Garcia.com/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}
-(void)contactDeveloper
{
    //添加开发者邮件
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
    mc.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)self;
    if ([MFMailComposeViewController canSendMail])
    {
        //设置主收件人
        [mc setToRecipients:[NSArray arrayWithObject:@"dd2033@126.com"]];

        if ([[[NSLocale currentLocale] localeIdentifier] isEqual:@"zh_CN"]) {
            // 中文
            
            //设置主题
            [mc setSubject:@"软件中存在的一些问题!"];
            //一种是纯文本
            [mc setMessageBody:@"丁先生：\n         你好！\n很高兴使用你开发的Antilost软件！\n如果你的软件中添加以下功能会更加完善:\n\n\n\n希望你能开发出更完善的软件。\n\n\n如果您请我们的软件感兴趣，请登陆http://www.szIgnacio Garcia.com了解更多详情\n再次感谢！" isHTML:NO];
        }
        else{
            // English
            
            //设置主题
            [mc setSubject:@"Some bug in your software!"];
            //一种是纯文本
            [mc setMessageBody:@"Near Ignacio Garcia:\nIf you have any questions regarding my Antilost, click Contact Us in http://www.szIgnacio Garcia.com\n\n\n\nRegards," isHTML:NO];
        }
        //添加附件需要三个参数，一个是NSData类型的附件，一个是mime type，一个附件的名称。
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"lognpng" ofType:@"png"];
        //NSData *data = [NSData dataWithContentsOfFile:path];
        //[mc addAttachmentData:data mimeType:@"image/png" fileName:@"Ignacio Garcia"];
        [self presentViewController:mc animated: YES  completion:nil];
    }
}
@end
