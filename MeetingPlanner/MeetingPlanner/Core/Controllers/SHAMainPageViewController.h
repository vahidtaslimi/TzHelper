//
//  SHAMainPageViewController.h
//  MeetingPlanner
//
//  Created by VT on 24/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHAButton.h"

@interface SHAMainPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic)IBOutlet  UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *timezoneNamesContainer;
@property (retain,nonatomic) IBOutlet UIDatePicker* datePicker;


@end
