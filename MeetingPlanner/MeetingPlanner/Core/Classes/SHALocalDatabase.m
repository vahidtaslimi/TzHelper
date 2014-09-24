//
//  SHALocalDatabase.m
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHALocalDatabase.h"
#import "SHADatabaseStorageHelper.h"
#import "SHACity.h"

@implementation SHALocalDatabase

NSMutableArray* _selectedCities;
SHADatabaseStorageHelper* _dbHelper;

+ (void)initialize
{
    if (self) {
       _dbHelper = [[SHADatabaseStorageHelper alloc]init];
    }
    
}

+(NSMutableArray*)loadSelectedTimeZones
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *fileAndPath = [self dataFilePath];
   
    NSMutableArray* cities = [_dbHelper getCities];
    _selectedCities=[[NSMutableArray alloc]init];
    
    if (![fileMan fileExistsAtPath:fileAndPath])
    {
        NSString* localTimeZoneName=[NSTimeZone defaultTimeZone].name;
            SHACity* city;
        for (SHACity* c in cities) {
            NSLog(@"%@",c.timeZoneName);
            if([c.timeZoneName isEqualToString:localTimeZoneName])
            {
                city = c;
                break;
            }
        }
        
        [_selectedCities addObject:city];
        
        city = [[SHACity alloc]init];
        city.cityId = @"149";
        city.name =@"London";
        city.timeZoneName = @"Europe/London";
        [_selectedCities addObject:city];

        city = [[SHACity alloc]init];
        city.cityId = @"295";
        city.name =@"Tokyo";
        city.timeZoneName = @"Asia/Tokyo";
        [_selectedCities addObject:city];

        /*
        [_selectedTimezonesNames addObject:[NSTimeZone defaultTimeZone].name];
        [_selectedTimezonesNames addObject:@"Europe/London"] ;
        [_selectedTimezonesNames  addObject:@"Asia/Tokyo"] ;
        [_selectedTimezonesNames addObject:@"Europe/Amsterdam"] ;
        [_selectedTimezonesNames addObject:@"GMT"];
         [_selectedTimezonesNames addObject:@"America/Los_Angeles"] ;
         [_selectedTimezonesNames addObject:@"Asia/Damascus"] ;
         [_selectedTimezonesNames addObject:@"Asia/Phnom_Penh"] ;
         [_selectedTimezonesNames addObject:@"Atlantic/Azores"];
         [_selectedTimezonesNames addObject:@"Europe/Moscow"];
         [_selectedTimezonesNames addObject:@"Europe/Paris"] ;
         */
        NSMutableArray* cityIds =[[NSMutableArray alloc]init];
        for (SHACity* c in _selectedCities) {
            [cityIds addObject:c.cityId];
        }
        
        for (SHACity* c in _selectedCities) {
            c.timeZone = [NSTimeZone timeZoneWithName:c.timeZoneName];
        }
        
        [cityIds writeToFile:fileAndPath atomically:YES];
    }
    else
    {
         NSMutableArray* cityIds =[[NSMutableArray alloc]initWithContentsOfFile:fileAndPath];
        for (NSString* cityId in cityIds) {
            for (SHACity* c in cities) {
                if([c.cityId isEqualToString:cityId])
                {
                    [_selectedCities addObject:c];
                }
            }
        }
    }

    return _selectedCities;
}

+(void)updateSelectedTimeZonesAtIndex:(int)index withValue:(NSString*)timeZone
{
    if(index>_selectedCities.count && timeZone == NULL)
    {
        return;
    }
 
    NSMutableArray* cityIds =[[NSMutableArray alloc]init];
    for (SHACity* city in _selectedCities) {
                      [cityIds addObject:city.cityId];
    }
    
    if(timeZone==NULL)
    {
        id tz=  [cityIds objectAtIndex:index];
        [cityIds removeObject:tz];
    }
    else
    {
        if(index<cityIds.count)
        {
            [cityIds removeObjectAtIndex:index];
        }
        else if(index>cityIds.count)
        {
            index = cityIds.count;
        }
        
        [cityIds insertObject:timeZone atIndex:index];
    }
    
    NSString *fileAndPath = [self dataFilePath];
    [cityIds writeToFile:fileAndPath atomically:YES];
    
    /*
    NSMutableArray* _selectedTimezonesNames=[[NSMutableArray alloc]init];
    
    for (int i=0; i<_selectedCities.count; i++) {
        NSTimeZone* timezone=[_selectedCities objectAtIndex:i];
        [_selectedTimezonesNames addObject:timezone.name];
    }
    
    [_selectedTimezonesNames writeToFile:fileAndPath atomically:YES];
     */
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
