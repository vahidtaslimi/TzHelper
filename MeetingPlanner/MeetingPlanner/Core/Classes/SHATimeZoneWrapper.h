

@import Foundation;

@interface SHATimeZoneWrapper : NSObject

@property (nonatomic) NSString *localeName;
@property (nonatomic) NSTimeZone *timeZone;
@property (nonatomic) NSString *region;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSCalendar *calendar;

@property (readonly, nonatomic) NSString *whichDay;
@property (readonly, nonatomic) NSString *abbreviation;
@property (readonly, nonatomic) NSString *gmtOffset;
@property (readonly, nonatomic) UIImage *image;

- (instancetype)initWithTimeZone:(NSTimeZone *)aTimeZone nameComponents:(NSArray *)nameComponents;

@end
