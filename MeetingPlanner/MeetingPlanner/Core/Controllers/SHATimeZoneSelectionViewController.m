//
//  SHATimeZoneSelectionViewController.m
//  MeetingPlanner
//
//  Created by VT on 26/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHATimeZoneSelectionViewController.h"
#import "SHATimeZoneWrapper.h"
#import "SHATimeZoneSeletctionCell.h"
#import "SHALocalDatabase.h"

@interface SHATimeZoneSelectionViewController ()

@end

@implementation SHATimeZoneSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
	NSMutableArray *timeZones = [[NSMutableArray alloc] initWithCapacity:[timeZoneNames count]];
    
	for (NSString *timeZoneName in timeZoneNames) {
        
		NSArray *nameComponents = [timeZoneName componentsSeparatedByString:@"/"];
		// For this example, the time zone itself isn't needed.
		SHATimeZoneWrapper *timeZoneWrapper = [[SHATimeZoneWrapper alloc] initWithTimeZone:nil nameComponents:nameComponents];
        timeZoneWrapper.timeZone=[NSTimeZone timeZoneWithName:timeZoneName];
		[timeZones addObject:timeZoneWrapper];
	}
    
	self.timeZonesArray = timeZones;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=self.selectedTimeZone.Name;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    return [[self.collation sectionTitles] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// The number of time zones in the section is the count of the array associated with the section in the sections array.
	NSArray *timeZonesInSection = (self.sectionsArray)[section];
    
    return [timeZonesInSection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"timeZoneSelectionCell";
    SHATimeZoneSeletctionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	// Get the time zone from the array associated with the section index in the sections array.
	NSArray *timeZonesInSection = (self.sectionsArray)[indexPath.section];
    
	// Configure the cell with the time zone's name.
	SHATimeZoneWrapper *timeZone = timeZonesInSection[indexPath.row];
    cell.titleLabel.text = timeZone.localeName;
    cell.offsetLabel.text=timeZone.timeZone.abbreviation;
    cell.regionLabel.text=timeZone.region;
    return cell;
}


/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.collation sectionTitles][section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.collation sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.collation sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *timeZonesInSection = (self.sectionsArray)[indexPath.section];
	SHATimeZoneWrapper *timeZone = timeZonesInSection[indexPath.row];
    [SHALocalDatabase updateSelectedTimeZonesAtIndex:self.selectedTimeZone.Order withValue:timeZone.timeZone];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Set the data array and configure the section data

/*
 Configuring the sections is a little fiddly, and it's not directly relevant to understanding how sectioned table views themselves work, so there's no need to work though these methods if you don't want to.
 */

- (void)setTimeZonesArray:(NSMutableArray *)newDataArray {
    
	if (newDataArray != _timeZonesArray) {
		_timeZonesArray = [newDataArray mutableCopy];
        if (_timeZonesArray == nil) {
            self.sectionsArray = nil;
        }
        else {
            [self configureSections];
        }
	}
}


- (void)configureSections {
    
	// Get the current collation and keep a reference to it.
	self.collation = [UILocalizedIndexedCollation currentCollation];
    
	NSInteger index, sectionTitlesCount = [[self.collation sectionTitles] count];
    
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
	// Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
	}
    
	// Segregate the time zones into the appropriate arrays.
	for (SHATimeZoneWrapper *timeZone in self.timeZonesArray) {
        
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [self.collation sectionForObject:timeZone collationStringSelector:@selector(localeName)];
        
		// Get the array for the section.
		NSMutableArray *sectionTimeZones = newSectionsArray[sectionNumber];
        
		//  Add the time zone to the section.
		[sectionTimeZones addObject:timeZone];
	}
    
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
        
		NSMutableArray *timeZonesArrayForSection = newSectionsArray[index];
        
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedTimeZonesArrayForSection = [self.collation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(localeName)];
        
		// Replace the existing array with the sorted array.
		newSectionsArray[index] = sortedTimeZonesArrayForSection;
	}
    
	self.sectionsArray = newSectionsArray;
}



@end
