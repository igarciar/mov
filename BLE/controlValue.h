//
//  controlValue.h
//  finder
//
//  Created by Ignacio Garcia on 13-7-12.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface controlValue : NSObject
// 控制属性
@property(nonatomic)            BOOL                    AntilostPoweOn;
@property(nonatomic)            BOOL                    EnabelAntilostWork;
@property(readwrite)            Byte                    alarmSoundState;
@property(readwrite)            Byte                    connectionInterval;
@end
