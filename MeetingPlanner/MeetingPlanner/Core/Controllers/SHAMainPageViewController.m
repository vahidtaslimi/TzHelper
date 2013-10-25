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

@interface SHAMainPageViewController (){
    NSMutableArray *_objects;
    NSMutableArray *_selectedTimezones;
    NSMutableArray *_groupHeadersByDay;
     NSDate *_selectedDate;
}

@property (nonatomic) NSDateFormatter *dateFormatter;
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
     _selectedDate = [NSDate date];
    [self loadTimezones];
    [self loadGroupHeaders];
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TzItemCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addHeaderLabels];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:500];
    [self.tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
}
-(void)addHeaderLabels
{
    NSMutableArray* items=[[NSMutableArray alloc]init];
    SHADateTimeCellItem* item;
    for (int i=0; i<_selectedTimezones.count; i++) {
        item=[SHATimeZoneHelper Parse:[_selectedTimezones objectAtIndex:i]];
        [items addObject:item];
    }
     [SHALabelGenerator addHeaderLabelsToView:self.timezoneNamesContainer fromTimezones:items];
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
    
    [_groupHeadersByDay addObject:_selectedDate];
    
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
    if(!_selectedTimezones)
    {
        _selectedTimezones=[[NSMutableArray alloc]initWithCapacity:10];
    }
    
    [_selectedTimezones insertObject:[NSTimeZone defaultTimeZone] atIndex:0];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Australia/Perth"] atIndex:1];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Asia/Tehran"] atIndex:2];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Europe/Amsterdam"] atIndex:3];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"GMT"] atIndex:4];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"] atIndex:5];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Asia/Damascus"] atIndex:6];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Asia/Phnom_Penh"] atIndex:7];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Atlantic/Azores"] atIndex:8];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Europe/Moscow"] atIndex:9];
    [_selectedTimezones insertObject:[NSTimeZone timeZoneWithName:@"Europe/Paris"] atIndex:10];
    //[[self dateFormatter]setTimeZone:timezoe];
}

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        // NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"h:mm a" options:0 locale:[NSLocale currentLocale]];
        //[_dateFormatter setDateFormat:dateFormat];
        [_dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return _dateFormatter;
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
    return [self.dateFormatter stringFromDate:date];
    //return [NSString stringWithFormat:@"%@",date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHATzListCell *cell =[[SHATzListCell alloc]init];// [tableView dequeueReusableCellWithIdentifier:@"TzItemCell" forIndexPath:indexPath];
    
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[NSLocale currentLocale]];
		[dateFormatter setDateFormat:dateFormat];
	}
    static NSCalendar *gregorianCalendar = nil;
    if(gregorianCalendar==nil ){
        gregorianCalendar=[NSCalendar currentCalendar];
    }
    
    NSMutableArray* items=[[NSMutableArray alloc]init];
    SHADateTimeCellItem* item;
    NSDate* date=[_groupHeadersByDay objectAtIndex:indexPath.section];
    
    NSDateComponents *hourComponent = [[NSDateComponents alloc] init];
    hourComponent.hour = indexPath.row;
    date=[gregorianCalendar dateByAddingComponents:hourComponent toDate:date options:0];
    
    for (int i=0; i<[_selectedTimezones count]; i++) {
        [dateFormatter setTimeZone:[_selectedTimezones objectAtIndex:i ]];
        item=[[SHADateTimeCellItem alloc]init];
        item.Value=[dateFormatter stringFromDate:date];
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
}

@end
