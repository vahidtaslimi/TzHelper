//
//  SHALocalDatabase.h
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHALocalDatabase : NSObject
+(NSMutableArray*)loadSelectedTimeZones;
+(void)updateSelectedTimeZonesAtIndex:(int)index withValue:(NSTimeZone*)timeZone;

@end
