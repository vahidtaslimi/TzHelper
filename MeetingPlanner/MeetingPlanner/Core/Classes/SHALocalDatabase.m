//
//  SHALocalDatabase.m
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHALocalDatabase.h"

@implementation SHALocalDatabase

NSMutableArray* _selectedTimezones;

+ (void)initialize
{
    if (self) {

    }
    
}

+(NSMutableArray*)loadSelectedTimeZones
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *fileAndPath = [self dataFilePath];
    NSMutableArray* _selectedTimezonesNames;
    if (![fileMan fileExistsAtPath:fileAndPath])
    {
        _selectedTimezonesNames=[[NSMutableArray alloc]initWithCapacity:10];
        [_selectedTimezonesNames addObject:[NSTimeZone defaultTimeZone].name];
        [_selectedTimezonesNames addObject:@"Australia/Perth"] ;
        [_selectedTimezonesNames  addObject:@"Asia/Tehran"] ;
        [_selectedTimezonesNames addObject:@"Europe/Amsterdam"] ;
       /* [_selectedTimezonesNames addObject:@"GMT"];
        [_selectedTimezonesNames addObject:@"America/Los_Angeles"] ;
        [_selectedTimezonesNames addObject:@"Asia/Damascus"] ;
        [_selectedTimezonesNames addObject:@"Asia/Phnom_Penh"] ;
        [_selectedTimezonesNames addObject:@"Atlantic/Azores"];
        [_selectedTimezonesNames addObject:@"Europe/Moscow"];
        [_selectedTimezonesNames addObject:@"Europe/Paris"] ;
        */
        BOOL success =[_selectedTimezonesNames writeToFile:fileAndPath atomically:YES];
     }
    else
    {
        _selectedTimezonesNames=[[NSMutableArray alloc]initWithContentsOfFile:fileAndPath];
    }
    
    _selectedTimezones=[[NSMutableArray alloc]init];
    for (int i=0; i<_selectedTimezonesNames.count; i++) {
        NSTimeZone* tz=[NSTimeZone timeZoneWithName:[_selectedTimezonesNames objectAtIndex:i]];
        [_selectedTimezones addObject:tz];
    }
            return _selectedTimezones;
}

+(void)updateSelectedTimeZonesAtIndex:(int)index withValue:(NSTimeZone*)timeZone
{
    if(index>_selectedTimezones.count)
    {
        return;
    }
    if(timeZone==NULL)
    {
     [_selectedTimezones removeObjectAtIndex:index];
    }
    else
    {
      NSTimeZone* tz=  [_selectedTimezones objectAtIndex:index];
        tz=timeZone;
    }
    NSString *fileAndPath = [self dataFilePath];
    NSMutableArray* _selectedTimezonesNames=[[NSMutableArray alloc]init];
 
    for (int i=0; i<_selectedTimezones.count; i++) {
        NSTimeZone* timezone=[_selectedTimezones objectAtIndex:i];
        [_selectedTimezonesNames addObject:timezone.name];
    }
    
       BOOL success = [_selectedTimezonesNames writeToFile:fileAndPath atomically:YES];
}

+(void)saveSelectedTimeZones:(NSMutableArray*)selectedTimeZones
{
    NSString *fileAndPath = [self dataFilePath];
    [selectedTimeZones writeToFile:fileAndPath atomically:YES];
}

+ (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"SelectedTimeZones.plist"];
}

@end
