//
//  SHAButton.h
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHATimeZone.h"
typedef void (^SHAButtonActionBlock)(UIButton*);

@interface SHAButton : UIButton
{
    SHAButtonActionBlock _actionBlock;
}

@property SHATimeZone* timeZoneInfo;


-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(SHAButtonActionBlock) action;

@end
