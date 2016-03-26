//
//  callEvent.h
// 
//
//  Created by Ignacio Garcia on 13-12-6.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface callEvent : NSObject
@property(strong,nonatomic) NSString   *callEventState;
@end
