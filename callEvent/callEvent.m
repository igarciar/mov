//
//  callEvent.m
//  
//
//  Created by Ignacio Garcia on 13-12-6.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "callEvent.h"

@implementation callEvent{
    CTCallCenter    *center;
}

-(id)init{
    self = [super init];
    if (self) {
        // TELEFONO EVENTO
        __block callEvent *blockSelf = self;
        _callEventState = CTCallStateDisconnected;
        center                      = [[CTCallCenter alloc]init];
        center.callEventHandler     = ^(CTCall *call){
            blockSelf->_callEventState = call.callState;
        };
    }
    return self;
}
@end
