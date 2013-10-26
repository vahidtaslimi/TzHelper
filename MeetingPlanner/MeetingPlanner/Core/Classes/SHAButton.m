//
//  SHAButton.m
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHAButton.h"



@implementation SHAButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeZoneInfo=[[SHATimeZone alloc]init];
    }
    return self;
}



-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(SHAButtonActionBlock) action
{
    _actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _actionBlock(sender);
}

-(void) dealloc{
    //Block_release(_actionBlock);
   // [super dealloc];
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
