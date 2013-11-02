//
//  SHATimeZoneHelper.m
//  MeetingPlanner
//
//  Created by VT on 24/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHATimeZoneHelper.h"
#import "SHATimeZoneWrapper.h"
#import "SHARegion.h"
#import "SHADateTimeCellItem.h"

@interface SHATimeZoneHelper ()
@property (nonatomic) NSCalendar *calendar;

@end

@implementation SHATimeZoneHelper

+(SHADateTimeCellItem*) Parse:(NSTimeZone*)timeZone
{
    SHADateTimeCellItem* item=[[SHADateTimeCellItem alloc]init];
    NSArray *components = [timeZone.name componentsSeparatedByString:@"/"];
   item.RegionName = [components objectAtIndex:0];

    if ([components count] == 2) {
        item.Name = [components objectAtIndex:1];
    }
    else if ([components count] == 3) {
        item.Name = [NSString stringWithFormat:@"%@ (%@)", [components objectAtIndex:2], [components objectAtIndex:1]];
    }
    
    item.name= [item.name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    item.TimeZone=timeZone;
    
    if([item isKindOfClass:[SHADateTimeCellItem class]])
    {
        item.Offset=timeZone.abbreviation;
    }
    
    return item;
}

- (NSArray *)displayList {
	/*
	 Return an array of Region objects.
	 Each object represents a geographical region.  Each region contains time zones.
	 Much of the information required to display a time zone is expensive to compute, so rather than using NSTimeZone objects directly use wrapper objects that calculate the required derived values on demand and cache the results.
	 */
	NSArray *knownTimeZoneNames = [NSTimeZone knownTimeZoneNames];
    
	NSMutableArray *regions = [NSMutableArray array];
    
	for (NSString *timeZoneName in knownTimeZoneNames) {
        
		NSArray *components = [timeZoneName componentsSeparatedByString:@"/"];
		NSString *regionName = [components objectAtIndex:0];
        
		SHARegion *region = [SHARegion regionNamed:regionName];
		if (region == nil) {
			region = [SHARegion newRegionWithName:regionName];
			region.calendar = [self calendar];
			[regions addObject:region];
		}
        
		NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:timeZoneName];
		[region addTimeZone:timeZone nameComponents:components];
	}
    
	NSDate *date = [NSDate date];
	// Now sort the time zones by name
	for (SHARegion *region in regions) {
		[region sortZones];
		[region setDate:date];
	}
	// Sort the regions
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[regions sortUsingDescriptors:@[sortDescriptor]];
    
	return regions;
}


- (NSCalendar *)calendar {
	if (_calendar == nil) {
		_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	}
	return _calendar;
}
@end
