//
//  SetRingtone.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#define kMusicMode                  0
#define kRecordMode                 1

#define kCounnectSoundID            1
#define kDiscounnectSoundID         2
#define kOutrangeSoundID            3
#define kKeypressedSoundID          4

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"
#import "RecorderModel.h"
@interface SetRingtone : UIViewController  <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,RecorderModelDelegate>


@property (nonatomic, strong) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSMutableArray *setArray;

@property (nonatomic) blePeripheral *currentPeripheral;

@end

