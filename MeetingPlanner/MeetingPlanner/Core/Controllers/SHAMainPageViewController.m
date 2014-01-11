//
//  SHAMainPageViewController.m
//  MeetingPlanner
//
//  Created by VT on 24/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHAMainPageViewController.h"
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
    NSCalendar *_gregorianCalendar;
    UIColor* _headerBackgroundColor;
    UIColor* _headerFontColor;
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
       //self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headerBackgroundColor=[UIColor colorWithHue:0 saturation:0 brightness:0.97 alpha:1];
    _headerFontColor=[UIColor colorWithHue:3 saturation:81 brightness:100 alpha:1];
        _gregorianCalendar=[NSCalendar currentCalendar];
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
    _selectedDate = [NSDate date];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TzItemCell"];
    self.timezoneNamesContainer.backgroundColor=_headerBackgroundColor;
    self.view.backgroundColor=_headerBackgroundColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadAndDisplayTimes];
   [super viewWillAppear:animated];
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


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate*  date= [_groupHeadersByDay objectAtIndex:section];
    NSString *string =[_groupHeaderDateFormatter stringFromDate:date];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    headerView.backgroundColor=_headerBackgroundColor;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, button.frame.size.width,20)];
    label.text=string;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=_headerFontColor;
    [button addSubview:label];
    [button addTarget: self action: @selector(headerTapped:) forControlEvents: UIControlEventTouchUpInside];
    [headerView addSubview:button];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHATzListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];//[[SHATzListCell alloc]init];
	    
    NSMutableArray* items=[[NSMutableArray alloc]init];
    SHADateTimeCellItem* item;
    NSDate* currentSectionDate=[_groupHeadersByDay objectAtIndex:indexPath.section];
    NSDateComponents *hourComponent = [[NSDateComponents alloc] init];
    hourComponent.hour = indexPath.row;
    currentSectionDate=[_gregorianCalendar dateByAddingComponents:hourComponent toDate:currentSectionDate options:0];
    
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents;
    NSInteger currentDateDayOfWeek, convertedDateDayOfWeek;
    
    for (int i=0; i<[_selectedTimezones count]; i++) {
        NSTimeZone* tz=[_selectedTimezones objectAtIndex:i ];
        [_dateFormatter setTimeZone:tz];
        item=[[SHADateTimeCellItem alloc]init];
        item.value=[_dateFormatter stringFromDate:currentSectionDate];
        item.TimeZone=tz;
      
        
		// Set the calendar's time zone to the default time zone.
		[calendar setTimeZone:[_selectedTimezones objectAtIndex:0]];
		dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:currentSectionDate];
		currentDateDayOfWeek = [dateComponents weekday];
		
		[calendar setTimeZone:tz];
		dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:currentSectionDate];
		convertedDateDayOfWeek = [dateComponents weekday];
		
		NSRange dayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
		NSInteger maxDay = NSMaxRange(dayRange) - 1;
		
		if (currentDateDayOfWeek == convertedDateDayOfWeek) {
			 item.DayDifference=0;
		}
        else {
			if ((convertedDateDayOfWeek - currentDateDayOfWeek) > 0) {
                  item.DayDifference=1;
			} else {
                item.DayDifference=-1;
			}
			// Special cases for days at the end of the week
			if ((currentDateDayOfWeek == maxDay) && (convertedDateDayOfWeek == 1)) {
                  item.DayDifference=1;
			}
			if ((currentDateDayOfWeek == 1) && (convertedDateDayOfWeek == maxDay)) {
                item.DayDifference=-1;
			}
		}

        [items addObject:item];
    }
    

    [cell setTimeZoneItems:items];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return false;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
       // NSDate *object = _objects[indexPath.row];
    }
}

#pragma mark - Seaue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"TimeZoneSelectionSegue"])
    {
        SHATimeZoneSelectionViewController* controller=[segue destinationViewController];
        SHAButton* button=(SHAButton*)sender;
        controller.selectedTimeZone=button.timeZoneInfo;
    }
}

#pragma mark - Private Methods
-(void) loadAndDisplayTimes
{
    [self loadTimezones];
    _groupHeaderDateFormatter.timeZone=[_selectedTimezones objectAtIndex:0];
    
    [self loadGroupHeaders];
    
    [self addHeaderLabels];
    [self.tableView reloadData];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone=[_selectedTimezones objectAtIndex:0];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:_selectedDate];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:components.hour inSection:365];
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
-(void)loadGroupHeaders
{
    _groupHeadersByDay=[[NSMutableArray alloc]init];
    
    NSCalendar *gregorianCalendar = [NSCalendar currentCalendar];
    gregorianCalendar.timeZone=_selectedTimezones[0];
    NSDateComponents * dateComponents = [gregorianCalendar
                                         components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                         fromDate:_selectedDate];
    
    // Create a date object repersenting the start of today.
    dateComponents.hour=0;
    dateComponents.minute=0;
    dateComponents.hour=0;
    
    _selectedDate = [gregorianCalendar dateFromComponents:dateComponents];
    
    for (int i=365; i>0; i--) {
        
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
    
    for (int i=1; i<365; i++) {
        
        NSDateComponents *components = [gregorianCalendar components: NSUIntegerMax fromDate: _selectedDate];
        [components setDay:components.day+i];
        [components setHour: 0];
        [components setMinute: 0];
        [components setSecond: 0];
        
        NSDate *newDate = [gregorianCalendar dateFromComponents: components];
        [_groupHeadersByDay addObject:newDate];
    }
}

-(void)loadTimezones
{
    _selectedTimezones=[SHALocalDatabase loadSelectedTimeZones];
}

- (void) headerTapped: (UIButton*) sender
{
    [self showPicker];
}


- (void)showPicker
{
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds] ;
    darkView.alpha = 0;
    darkView.backgroundColor=_headerBackgroundColor;
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)] ;
    datePicker.tag = 10;
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.7;
    [UIView commitAnimations];
}

- (void)changeDate:(UIDatePicker *)sender {
    _selectedDate=sender.date;
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    [self loadAndDisplayTimes];
}

- (IBAction)todayButton:(id)sender {
    _selectedDate = [NSDate date];
       [self loadAndDisplayTimes];
}
@end
