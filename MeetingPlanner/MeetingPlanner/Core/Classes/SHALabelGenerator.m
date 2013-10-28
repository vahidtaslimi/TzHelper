//
//  SHALabelGenerator.m
//  MeetingPlanner
//
//  Created by VT on 24/10/13.
//  Copyright (c) 2013 Shaghayegh. All rights reserved.
//

#import "SHALabelGenerator.h"
#import "SHADateTimeCellItem.h"

@implementation SHALabelGenerator

float firstItemWidth=50;
float firstItemLeft=10;
float _left=10;
float _top=5;
float _width=50;
float dayDiffWidth=20;
float dayDiffHeight=15;
float _height=20;
float marginLeft=10;
int landscapeCount=9;
int portraitCount=5;
UIFont* font;
UIFont* dayDiffFont;
UIFont* headerFont;
UIFont* offsetFont;

+ (void)initialize
{
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _left=10;
            _top=5;
            _width=60;
            _height=30;
            landscapeCount=18;
            portraitCount=10;
        }
        else
        {
            
        }
        
        font=[UIFont systemFontOfSize:12];
        dayDiffFont=[UIFont systemFontOfSize:8];
        headerFont=[UIFont systemFontOfSize:10];
        offsetFont=[UIFont systemFontOfSize:8];
    }
    
}

+(void) addValueLabelsToView:(UIView*)view fromTimezones:(NSMutableArray* )timezoneItems
{
   /* for(UIView *subview in [view subviews]) {
        [subview removeFromSuperview];
    }
    */
    
    SHADateTimeCellItem* item;
    item=[timezoneItems objectAtIndex:0];
    UILabel* label=[self addItemLabel:view at:firstItemLeft text:item.Value];
    label.font=[UIFont boldSystemFontOfSize:14];
    
    for (int i=1; i<portraitCount; i++) {
        if([timezoneItems count]<=i)
            return;
        
        item=[timezoneItems objectAtIndex:i];
        float labelLeft= _left+(i*(_width+marginLeft));
        [self addItemLabel:view at:labelLeft text:item.Value];
        [self addItemDayDiffLabel:view at:labelLeft text:item.DayDifference];
    }
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        for (int i=portraitCount; i<landscapeCount; i++) {
            if([timezoneItems count]<=i)
                return;
            
            item=[timezoneItems objectAtIndex:i];
            float labelLeft= _left+(i*(_width+marginLeft));
            [self addItemLabel:view at:labelLeft text:item.Value];
            [self addItemDayDiffLabel:view at:labelLeft text:item.DayDifference];
        }
    }
}


+(UILabel*)addItemLabel:(UIView*)view at:(float)left text:(NSString*)text
{
    float rotation=0;//M_PI/2;
    UILabel* label=(UILabel*)[view viewWithTag:left+_top];
    if(label==NULL)
    {
        
        CGRect frame=CGRectMake(left, _top, _width, _height);
        label=[[UILabel alloc]initWithFrame:frame];
        label.tag=left+_top;
        label.font=font;
        label.lineBreakMode=NSLineBreakByTruncatingTail;
        label.numberOfLines=1;
        label.transform = CGAffineTransformMakeRotation(rotation);//(M_PI_4);
        [view addSubview:label];
    }
      label.text=text;
    return label;
}
+(void)addItemDayDiffLabel:(UIView*)view at:(float)left text:(int)dayDiff
{
    int top=_top+_height;
    UILabel* label=(UILabel*)[view viewWithTag:left+top];
    UILabel* labelPlusOne=(UILabel*)[view viewWithTag:left+top+20];
    if(label==NULL)
    {
       NSLog(@"Crating a new label");
        UILabel* label=[[UILabel alloc]init];
        CGRect frame;
        frame=CGRectMake(left, top, dayDiffWidth, dayDiffHeight);
        label.textColor=[UIColor redColor];

        label.tag=left+top;
       label.frame=frame;
        label.font=dayDiffFont;
        label.lineBreakMode=NSLineBreakByTruncatingTail;
        label.numberOfLines=1;
        [view addSubview:label];
    }
    if(labelPlusOne==NULL)
    {
        UILabel* labelPlusOne=[[UILabel alloc]init];
        CGRect frame;
        frame=CGRectMake(left+20, top, dayDiffWidth, dayDiffHeight);
        labelPlusOne.textColor=[UIColor blueColor];

        labelPlusOne.tag=left+top+20;
        labelPlusOne.frame=frame;
        labelPlusOne.font=dayDiffFont;
        labelPlusOne.lineBreakMode=NSLineBreakByTruncatingTail;
        labelPlusOne.numberOfLines=1;
        [view addSubview:labelPlusOne];
    }
    
    if(dayDiff==0)
    {
        labelPlusOne.text=@"";
        label.text=@"";
        labelPlusOne.hidden=true;
        label.hidden=true;
    }
    else if(dayDiff>0)
    {
        labelPlusOne.text=[NSString stringWithFormat:@"+%d",dayDiff];
        label.text=@"";
        labelPlusOne.hidden=false;
        label.hidden=true;
    }
    else
    {
        labelPlusOne.text=@"";
        label.text=[NSString stringWithFormat:@"%d",dayDiff];
        labelPlusOne.hidden=true;
        label.hidden=false;
    }
}

+(void) addHeaderLabelsToView:(UIView*)view fromTimezones:(NSMutableArray* )timezoneItems buttonPressAction:(SHAButtonActionBlock) action
{
    //float rotation=0;//M_PI/2;
    for(UIView *subview in [view subviews]) {
        [subview removeFromSuperview];
    }
    SHATimeZone* item;
    item=[timezoneItems objectAtIndex:0];
    CGRect frame=CGRectMake(firstItemLeft, _top, firstItemWidth, view.frame.size.height);
    
    //label.font=[UIFont boldSystemFontOfSize:10];
    [self addHeaderItemView:view at:frame timezone:item buttonPressAction:action atOrder:0];
    
    
    for (int i=1; i<portraitCount; i++) {
        float labelLeft= _left+(i*(_width+marginLeft));
        CGRect frame=CGRectMake(labelLeft, _top, _width, view.frame.size.height);
        if([timezoneItems count]<=i)
        {
            [self addHeaderItemView:view at:frame timezone:NULL buttonPressAction:action atOrder:i];
        }
        else
        {
            item=[timezoneItems objectAtIndex:i];
            [self addHeaderItemView:view at:frame timezone:item buttonPressAction:action atOrder:i];
        }
    }
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        for (int i=portraitCount; i<landscapeCount; i++) {
            float labelLeft= _left+(i*(_width+marginLeft));
            CGRect frame=CGRectMake(labelLeft, _top, _width, view.frame.size.height);
            if([timezoneItems count]<=i)
            {
                [self addHeaderItemView:view at:frame timezone:NULL buttonPressAction:action atOrder:i];
            }
            else
            {
                item=[timezoneItems objectAtIndex:i];
                [self addHeaderItemView:view at:frame timezone:item buttonPressAction:action atOrder:i];
            }
        }
    }
}

+(UIButton*)addHeaderItemView:(UIView*)view  at:(CGRect)frame timezone:(SHATimeZone*)timezone buttonPressAction:(SHAButtonActionBlock) action atOrder:(int)order
{
    //CGRect offsetFrame=CGRectMake(0, 25, width, 15);
    //float rotation=0;//M_PI/2;
    SHAButton* button=[[SHAButton alloc]initWithFrame:frame];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:action];
    button.timeZoneInfo.Order=order;
    button.timeZoneInfo.Name=timezone.Name;
    button.timeZoneInfo.TimeZone=timezone.TimeZone;
    NSString* labelText=@"Select";
    NSString* offsetLabelText=@"+";
    if(timezone != NULL)
    {
        labelText=timezone.Name;
        offsetLabelText=timezone.TimeZone.abbreviation;
    }
    
    UILabel* label=[self getHeaderLabelWithText:labelText];
    
    UILabel* offsetLabel=[self getHeaderOffsetLabelWithText:offsetLabelText];
    [button addSubview:offsetLabel];
    [button addSubview:label];
    [view addSubview:button];
    //button.backgroundColor=[UIColor redColor];
    return button;
}

+(UILabel*)getHeaderOffsetLabelWithText:(NSString*)text
{
    CGRect frame=CGRectMake(0, 20, _width, 20);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=offsetFont;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.text=text;
    //label.backgroundColor=[UIColor yellowColor];
    return label;
}
+(UILabel*)getHeaderLabelWithText:(NSString*)text
{
    CGRect frame=CGRectMake(0, 0, _width, _height);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=headerFont;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.text=text;
    //label.backgroundColor=[UIColor blueColor];
    return label;
}

@end
