#import "SHARegion.h"
#import "SHATimeZoneWrapper.h"


static NSMutableDictionary *regions;

@interface SHARegion ()
@property (nonatomic) NSMutableArray *mutableTimeZoneWrappers;
@end


@implementation SHARegion

/*
 Class methods to manage global regions (pun intended).
 */
+ (void)initialize {
	regions = [[NSMutableDictionary alloc] init];	
}


+ (instancetype)regionNamed:(NSString *)name {
	return regions[name];
}


+ (instancetype)newRegionWithName:(NSString *)regionName {
    // Create a new region with a given name; add it to the regions dictionary.
	SHARegion *newRegion = [[self alloc] init];
	newRegion.name = regionName;
	newRegion.mutableTimeZoneWrappers = [[NSMutableArray alloc] init];
	regions[regionName] = newRegion;
	return newRegion;
}


-(NSArray *)timeZoneWrappers {
    return _mutableTimeZoneWrappers;
}


- (void)addTimeZone:(NSTimeZone *)timeZone nameComponents:(NSArray *)nameComponents {
    // Add a time zone to the region; use nameComponents because it' expensive to compute.
	SHATimeZoneWrapper *timeZoneWrapper = [[SHATimeZoneWrapper alloc] initWithTimeZone:timeZone nameComponents:nameComponents];
	timeZoneWrapper.calendar = self.calendar;
	[self.mutableTimeZoneWrappers addObject:timeZoneWrapper];
}


- (void)sortZones {
    // Sort the zone wrappers by locale name.
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"localeName" ascending:YES comparator:^(id name1, id name2) {
        return [(NSString *)name1 localizedStandardCompare:(NSString *)name2];
    }];
    
	[self.mutableTimeZoneWrappers sortUsingDescriptors:@[nameSortDescriptor]];
}


// Sets the date for the time zones, which has the side-effect of "faulting" the wrappers (see APLTimeZoneWrapper's setDate: method)
- (void)setDate:(NSDate *)date {
	for (SHATimeZoneWrapper *wrapper in self.timeZoneWrappers) {
		wrapper.date = date;
	}
}


@end
