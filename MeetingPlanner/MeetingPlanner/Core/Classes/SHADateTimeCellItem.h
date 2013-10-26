//
//  SHADateTimeCellItem.h
//  MeetingPlanner
//
//  Created by VT on 22/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHATimeZone.h"

@interface SHADateTimeCellItem : SHATimeZone
@property NSString* Value;
@property int DayDifference;
@property NSDate* Date;
@property NSString* Offset;

@end
