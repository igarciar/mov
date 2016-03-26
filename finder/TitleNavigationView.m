//
//  TitleNavigationView.m
//  finder
//  自定义导航条
//  Created by rfstar on 13-7-8.
//  Copyright (c) 2013年 David ding. All rights reserved.
//

#import "TitleNavigationView.h"

@implementation TitleNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TitleNavigationView" owner:self options:nil];
        self = array[0];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
