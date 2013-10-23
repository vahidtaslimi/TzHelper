//
//  SHATzListCell.m
//  MeetingPlanner
//
//  Created by VT on 22/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHATzListCell.h"
#import "SHADateTimeCellItem.h"

@implementation SHATzListCell
UILabel* label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setTimeZoneItems:(NSMutableArray* )timezoneItems
{
    SHADateTimeCellItem* item;
    float left=10;
    float top=5;
    float width=60;
    float height=30;
    UIFont* font=[UIFont systemFontOfSize:12];
    UIView* view=[self subviews][0];// [[UIView alloc]initWithFrame:self.frame];
    view=self.contentView;//[[UIView alloc]initWithFrame:view.frame];
    //[self.contentView addSubview:view];
    
    item=[timezoneItems objectAtIndex:0];
    CGRect frame=CGRectMake(20, top, 65, height);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=[UIFont boldSystemFontOfSize:14];
    label.text=item.Value;
    [view addSubview:label];
    
    for (int i=1; i<5; i++) {
        if([timezoneItems count]<i)
                return;
        
        item=[timezoneItems objectAtIndex:i];
        CGRect frame=CGRectMake(left+(i*width), top, width, height);
        UILabel* label=[[UILabel alloc]initWithFrame:frame];
        label.font=font;
        label.text=item.Value;
        [view addSubview:label];
    }
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        for (int i=5; i<9; i++) {
            if([timezoneItems count]<i)
                return;
            
            item=[timezoneItems objectAtIndex:i];
            CGRect frame=CGRectMake(left+(i*width), top, width, height);
            UILabel* label=[[UILabel alloc]initWithFrame:frame];
            label.font=font;
            label.text=item.Value;
            [view addSubview:label];
        }
    }
    
}

@end
