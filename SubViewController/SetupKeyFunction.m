//
//  SetupKeyFunction.m
//  finder
//
//  Created by Ignacio Garcia on 13-3-22.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "SetupKeyFunction.h"

@interface SetupKeyFunction ()
{
    NSArray             *arraySource;
    NSString            *sectionZeroStr;
    NSMutableArray      *switchArray;
    NSString            *doneStr;
}
@end

@implementation SetupKeyFunction

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
    
    switchArray = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO], nil];

    [self setCurrentPeripheral:_currentPeripheral];
 }

- (void)viewDidUnload
{
    _currentPeripheral = nil;
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
//if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] containsString:@"zh-Han"]) {
//        // 中文
//        self.title = @"设置长按键功能";
//        
//        sectionZeroStr =  @"长按键功能";
//        doneStr = @"完成";
//        arraySource = [[NSArray alloc]initWithObjects:@"未使用",@"设定距离",@"开关防丢", nil];
//    }
//    else{
        // English
        self.title =NSLocalizedString(@"SETUP KEY FUNCTION",nil);
        doneStr = NSLocalizedString(@"doneStr",nil);
        sectionZeroStr = NSLocalizedString(@"sectionZeroStr",nil);
        arraySource = [[NSArray alloc]initWithObjects:NSLocalizedString(@"DISABEL",nil),NSLocalizedString(@"SETUP DISTANCE",nil),NSLocalizedString(@"LOST ALARM ON/OFF",nil), nil];
//    }
}


-(void)setCurrentPeripheral:(blePeripheral *)CP{
    _currentPeripheral = CP;
    NSInteger count = [switchArray count];
    for (NSInteger position = 0;position<count;position++) {
        [switchArray replaceObjectAtIndex:position withObject:[NSNumber numberWithBool:NO]];
    }
    NSLog(@"消息：  %d",_currentPeripheral.holdKeyPressedFunctions );

    if (_currentPeripheral != nil) {
        
       if (_currentPeripheral.holdKeyPressedFunctions == kHoldKeySetupDistance ) {

            [switchArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
        }else if (_currentPeripheral.holdKeyPressedFunctions == kHoldKeyWorkOnOff){

             [switchArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
        }else{

             [switchArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
        }
    }
}

#pragma uitableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//反回分组的个数
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionZeroStr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arraySource.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"identifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
	}
    
    NSNumber *number = switchArray[indexPath.row];
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchview setTag:indexPath.row];
    BOOL onOrOff = [number boolValue];

    NSLog(@"switch   %@",switchArray);
    switchview.on = onOrOff;
    [switchview addTarget:self action:@selector(switchClickAtIndexPath:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchview;
    
    cell.textLabel.text = arraySource[indexPath.row];
    
    return  cell;
}


-(IBAction)switchClickAtIndexPath:(id)sender
{
    NSInteger tag = [sender tag];
    NSInteger count = switchArray.count;
    
    for (NSInteger position = 0;position<count;position++) {
        [switchArray replaceObjectAtIndex:position withObject:[NSNumber numberWithBool:NO]];
    }
     [switchArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:YES]];
    switch (tag) {
        case 0: // 按listview中的数据排列来区分的
            _currentPeripheral.holdKeyPressedFunctions = kDisabel;
            break;
        case 1:
            _currentPeripheral.holdKeyPressedFunctions = kSetupDistance;
            break;
        case 2:
            _currentPeripheral.holdKeyPressedFunctions = kWorkOnOff;
            break;
        default:
            break;
    }
    nPeripheralStateChange
    NSLog(@"arraysource count  : %lu ",(unsigned long)arraySource.count);
    [_listView reloadData];
}
@end
