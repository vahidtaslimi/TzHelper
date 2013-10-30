//
//  SHATimeZoneSelectionViewController.h
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHATimeZone.h"

@interface SHATimeZoneSelectionViewController : UITableViewController<UISearchBarDelegate>
@property (nonatomic) NSMutableArray *sectionsArray;
@property (nonatomic) UILocalizedIndexedCollation *collation;
@property (nonatomic, copy) NSMutableArray *timeZonesArray;
@property (nonatomic, copy) NSMutableArray *searchResultTimeZonesArray;
@property SHATimeZone* selectedTimeZone;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
- (IBAction)deleteButtonAction:(id)sender;

- (void)configureSectionsForTimeZoneArray:(NSMutableArray*)tzArray ;

@end
