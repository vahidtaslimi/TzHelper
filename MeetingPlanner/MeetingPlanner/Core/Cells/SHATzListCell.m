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
    float left=20;
    float top=5;
    float width=65;
    float height=30;
    UIFont* font=[UIFont systemFontOfSize:12];
    UIView* view=[self subviews][0];// [[UIView alloc]initWithFrame:self.frame];
    view=[[UIView alloc]initWithFrame:view.frame];
    [self addSubview:view];
    
    item=[timezoneItems objectAtIndex:0];
    CGRect frame=CGRectMake(left, top, width, height);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=[UIFont systemFontOfSize:14];
    label.text=item.Value;
    [view addSubview:label];
    
    
}

@end
