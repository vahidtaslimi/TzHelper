//
//  SHAMainPageViewController.m
//  MeetingPlanner
//
//  Created by VT on 24/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHAMainPageViewController.h"
#import "SHADetailViewController.h"
#import "SHATzListCell.h"
#import "SHADateTimeCellItem.h"
#import "SHALabelGenerator.h"
#import "SHATimeZoneWrapper.h"
#import "SHATimeZoneHelper.h"
#import "SHATimeZone.h"
#import "SHATimeZoneSelectionViewController.h"
#import "SHALocalDatabase.h"


@interface SHAMainPageViewController (){
    NSMutableArray *_objects;
    NSMutableArray *_selectedTimezones;
    NSMutableArray *_groupHeadersByDay;
    NSDate *_selectedDate;
    NSDateFormatter *_groupHeaderDateFormatter;
    NSDateFormatter *_currentDateFormatter;
    NSDateFormatter *_fullDateFormatter;
    NSString* _currentDateFormatString;
    NSDateFormatter *_dateFormatter;
}


@end

@implementation SHAMainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //   UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    // self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (SHADetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
     _currentDateFormatString = @"yyyy.MM.dd HH:mm zzz";
    
    _groupHeaderDateFormatter = [[NSDateFormatter alloc] init];
    [_groupHeaderDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [_groupHeaderDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    _currentDateFormatter=[[NSDateFormatter alloc]init];
    _currentDateFormatter.dateFormat=_currentDateFormatString;
    
    _fullDateFormatter=[[NSDateFormatter alloc]init];
    _fullDateFormatter.dateFormat=_currentDateFormatString;// @"yyyy.MM.dd";
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[NSLocale currentLocale]];
    [_dateFormatter setDateFormat:dateFormat];
    //[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    _selectedDate = [NSDate date];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TzItemCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTimezones];
    _groupHeaderDateFormatter.timeZone=[_selectedTimezones objectAtIndex:0];
    
    [self loadGroupHeaders];
    
    [self addHeaderLabels];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:500];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}
-(void)addHeaderLabels
{
    NSMutableArray* items=[[NSMutableArray alloc]init];
    SHATimeZone* item;
    for (int i=0; i<_selectedTimezones.count; i++) {
        item=[SHATimeZoneHelper Parse:[_selectedTimezones objectAtIndex:i]];
        [items addObject:item];
    }
    
    [SHALabelGenerator addHeaderLabelsToView:self.timezoneNamesContainer fromTimezones:items buttonPressAction:^(UIButton* button){
        SHAButton* sender=(SHAButton*)button;
        if(sender.timeZoneInfo.Order==0)
        {
            //return;
        }
        
        [self performSegueWithIdentifier:@"TimeZoneSelectionSegue" sender:sender];
        
        
    }];
}

-(void)handleHeaderTap:(UIButton*)sender
{
    
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];
    [self addHeaderLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)loadGroupHeaders
{
    if(!_groupHeadersByDay)
    {
        _groupHeadersByDay=[[NSMutableArray alloc]init];
    }
    
    NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
    for (int i=500; i>0; i--) {
        
        NSDateComponents *components = [gregorianCalendar components: NSUIntegerMax fromDate: _selectedDate];
        [components setDay:components.day-i];
        [components setHour: 0];
        [components setMinute: 0];
        [components setSecond: 0];
        
        NSDate *newDate = [gregorianCalendar dateFromComponents: components];
        [_groupHeadersByDay addObject:newDate];
    }
    
    NSDateComponents *components = [gregorianCalendar components: NSUIntegerMax fromDate: _selectedDate];
    [components setDay:components.day];
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    
    NSDate *newDate = [gregorianCalendar dateFromComponents: components];
    [_groupHeadersByDay addObject:newDate];
    
    for (int i=1; i<500; i++) {
        
        NSDateComponents *components = [gregorianCalendar components: NSUIntegerMax fromDate: _selectedDate];
        [components setDay:components.day+i];
        [components setHour: 0];
        [components setMinute: 0];
        [components setSecond: 0];
        
        NSDate *newDate = [gregorianCalendar dateFromComponents: components];
        [_groupHeadersByDay addObject:newDate];
    }
    //[[self dateFormatter]setTimeZone:timezoe];
}

-(void)loadTimezones
{
    _selectedTimezones=[SHALocalDatabase loadSelectedTimeZones];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupHeadersByDay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 24;// _objects.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate*  date= [_groupHeadersByDay objectAtIndex:section];
    return [_groupHeaderDateFormatter stringFromDate:date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHATzListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];//[[SHATzListCell alloc]init];
	
    static NSCalendar *gregorianCalendar = nil;
    if(gregorianCalendar==nil ){
        gregorianCalendar=[NSCalendar currentCalendar];
    }
    
    NSMutableArray* items=[[NSMutableArray alloc]init];
    SHADateTimeCellItem* item;
    NSDate* currentSectionDate=[_groupHeadersByDay objectAtIndex:indexPath.section];
    NSDateComponents *hourComponent = [[NSDateComponents alloc] init];
    hourComponent.hour = indexPath.row;
    currentSectionDate=[gregorianCalendar dateByAddingComponents:hourComponent toDate:currentSectionDate options:0];
    NSString* currentDateString=[_currentDateFormatter stringFromDate:currentSectionDate];
    
    for (int i=0; i<[_selectedTimezones count]; i++) {
        NSTimeZone* tz=[_selectedTimezones objectAtIndex:i ];
        [_dateFormatter setTimeZone:tz];
        _fullDateFormatter.timeZone=tz;
        item=[[SHADateTimeCellItem alloc]init];
        item.Value=[_dateFormatter stringFromDate:currentSectionDate];
        item.TimeZone=tz;
      
        NSString *convertedDateString=[_fullDateFormatter stringFromDate:currentSectionDate];
        item.Date= [_fullDateFormatter dateFromString:convertedDateString];
        NSLog(@"Source:   %@",currentDateString);
        NSLog(@"Target:  %@",convertedDateString);
     
        NSDateComponents *currentHeaderDateComponents = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentSectionDate];
        NSDateComponents *convertedDateComponents = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:item.Date];
        long sourceDateInt=(currentHeaderDateComponents.year*10000)+(currentHeaderDateComponents.month*100)+currentHeaderDateComponents.day;
        long convertedDateInt=(convertedDateComponents.year*10000)+(convertedDateComponents.month*100)+convertedDateComponents.day;
        
        if(sourceDateInt>convertedDateInt)
        {
            item.DayDifference=-1;
        }
        else if(sourceDateInt<convertedDateInt)
        {
            item.DayDifference=1;
        }
        else
        {
            item.DayDifference=0;
            
        }
        //daysDiffComponents = [gregorianCalendar components: NSDayCalendarUnit    fromDate: currentSectionDate toDate: item.Date options: 0];
        NSLog(@"Source Diff:  %ld",sourceDateInt);
        NSLog(@"Converted Diff:  %ld",convertedDateInt);
        [items addObject:item];
    }
    
    [cell setTimeZoneItems:items];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    else if([[segue identifier] isEqualToString:@"TimeZoneSelectionSegue"])
    {
        SHATimeZoneSelectionViewController* controller=[segue destinationViewController];
        SHAButton* button=(SHAButton*)sender;
        controller.selectedTimeZone=button.timeZoneInfo;
    }
}

@end
