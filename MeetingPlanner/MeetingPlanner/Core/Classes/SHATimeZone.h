//
//  SHATimeZone.h
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHATimeZone : NSObject
@property NSString* RegionName;
@property NSString* Name;
@property NSTimeZone* TimeZone;
@property int Order;
@end
