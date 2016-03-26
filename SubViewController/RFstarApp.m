//
//  RFstarApp.m
//  finder
//
//  Created by David ding on 13-3-27.
//  Copyright (c) 2013年 David ding. All rights reserved.
//

#import "RFstarApp.h"

@interface RFstarApp ()

@end

@implementation RFstarApp

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
    
    [_appList setDelegate:(id<UITableViewDelegate>)self];
    [_appList setDataSource:(id<UITableViewDataSource>)self];
    [_appList reloadData];
}

- (void)viewDidUnload
{
    [self setAppList:nil];
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
if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqual:@"zh-Hans"])  {
        // 中文
        self.title = @"信弛达APP";
    }
    else{
        // English
        self.title= @"RFSTAR APP";

    }
}

//**************************************************//
#pragma
#pragma 表格处理
//**************************************************//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"bleBrowser.gif"];
            cell.textLabel.text = @"BLE Browser";
            break;
            
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"RemoteCar.gif"];
            cell.textLabel.text = @"BLE RemoteCar";
            break;
            
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"transmitMoudel.gif"];
            cell.textLabel.text = @"BLETransmit_Moudel";
            break;
            
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"simgaii.gif"];
            cell.textLabel.text = @"BLE SIMGAII";
            break;
        
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"led.gif"];
            cell.textLabel.text = @"BLELED_Controller";
            break;
            
        case 5:
            cell.imageView.image = [UIImage imageNamed:@"Telehealth.gif"];
            cell.textLabel.text = @"BLE_Telehealth";
            break;
            
        case 6:
            cell.imageView.image = [UIImage imageNamed:@"anti.gif"];
            cell.textLabel.text = @"BLE Antilost";
            break;
            
        case 7:
            cell.imageView.image = [UIImage imageNamed:@"hid.gif"];
            cell.textLabel.text = @"BLEHIDDongleController";
            break;
            
        case 8:
            cell.imageView.image = [UIImage imageNamed:@"find.gif"];
            cell.textLabel.text = @"BLE Anti-lost";
            break;
            
        default:
            break;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-browser/id581442554"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 1:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-remotecar/id578512921"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 2:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-transmit-moudel/id553433189"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 3:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-simgaii/id595925229"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 4:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-led-controller/id553431288"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 5:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-telehealth/id605284957"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 6:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-antilost/id570090361"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 7:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-hiddonglecontroller/id564111835"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        case 8:
        {
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ble-anti-lost/id553098363"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
            
        default:
        {
            NSString* urlText = [NSString stringWithFormat:@"http://www.szrfstar.com/"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
            break;
    }
}
@end
