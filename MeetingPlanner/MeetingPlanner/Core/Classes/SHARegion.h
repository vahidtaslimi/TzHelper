@import Foundation;

@interface SHARegion : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSCalendar *calendar;
- (NSArray *)timeZoneWrappers;

+ (instancetype)regionNamed:(NSString *)name;
+ (instancetype)newRegionWithName:(NSString *)regionName;
- (void)addTimeZone:(NSTimeZone *)timeZone nameComponents:(NSArray *)nameComponents;
- (void)sortZones;
- (void)setDate:(NSDate *)date;

@end
