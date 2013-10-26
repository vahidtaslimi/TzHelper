//
//  SHATimeZoneSelectionViewController.h
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHATimeZone.h"

@interface SHATimeZoneSelectionViewController : UITableViewController
@property (nonatomic) NSMutableArray *sectionsArray;
@property (nonatomic) UILocalizedIndexedCollation *collation;
@property (nonatomic, copy) NSMutableArray *timeZonesArray;
@property SHATimeZone* selectedTimeZone;

- (void)configureSections;

@end
