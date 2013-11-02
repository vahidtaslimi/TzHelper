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
        [_selectedTimezonesNames addObject:@"Europe/London"] ;
        [_selectedTimezonesNames  addObject:@"Asia/Tokyo"] ;
        /* [_selectedTimezonesNames addObject:@"Europe/Amsterdam"] ;
        [_selectedTimezonesNames addObject:@"GMT"];
         [_selectedTimezonesNames addObject:@"America/Los_Angeles"] ;
         [_selectedTimezonesNames addObject:@"Asia/Damascus"] ;
         [_selectedTimezonesNames addObject:@"Asia/Phnom_Penh"] ;
         [_selectedTimezonesNames addObject:@"Atlantic/Azores"];
         [_selectedTimezonesNames addObject:@"Europe/Moscow"];
         [_selectedTimezonesNames addObject:@"Europe/Paris"] ;
         */
        [_selectedTimezonesNames writeToFile:fileAndPath atomically:YES];
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
    if(index>_selectedTimezones.count && timeZone == NULL)
    {
        return;
    }
    if(timeZone==NULL)
    {
        id tz=  [_selectedTimezones objectAtIndex:index];
        [_selectedTimezones removeObject:tz];
    }
    else
    {
        if(index<_selectedTimezones.count)
        {
            [_selectedTimezones removeObjectAtIndex:index];
        }
        else if(index>_selectedTimezones.count)
        {
            index=_selectedTimezones.count;
        }
        
        [_selectedTimezones insertObject:timeZone atIndex:index];
    }
    
    NSString *fileAndPath = [self dataFilePath];
    NSMutableArray* _selectedTimezonesNames=[[NSMutableArray alloc]init];
    
    for (int i=0; i<_selectedTimezones.count; i++) {
        NSTimeZone* timezone=[_selectedTimezones objectAtIndex:i];
        [_selectedTimezonesNames addObject:timezone.name];
    }
    
    [_selectedTimezonesNames writeToFile:fileAndPath atomically:YES];
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
