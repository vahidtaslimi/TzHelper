//
//  SHATzListCell.m
//  MeetingPlanner
//
//  Created by VT on 22/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHATzListCell.h"
#import "SHADateTimeCellItem.h"
#import "SHALabelGenerator.h"

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
   UIView* view=self.contentView;
    [SHALabelGenerator addValueLabelsToView:view fromTimezones:timezoneItems];
    
}

@end
