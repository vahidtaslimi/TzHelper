//
//  SHATimeZoneHelper.h
//  MeetingPlanner
//
//  Created by VT on 24/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHADateTimeCellItem.h"

@interface SHATimeZoneHelper : NSObject
+(SHADateTimeCellItem*) Parse:(NSTimeZone*)timeZone;

@end
