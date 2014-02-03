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

float _firstItemWidth=50;
float _firstItemLeft=10;
float _left=10;
float _top=5;
float _width=70;
float _dayDiffWidth=20;
float _dayDiffHeight=15;
float _height=20;
float _marginLeft=5;
int _landscapeCount=8;
int _portraitCount=4;
UIFont* _font;
UIFont* _dayDiffFont;
UIFont* _headerFont;
UIFont* _offsetFont;
UIFont* _boldFont;
UIColor* _headerColor;
float _screenWidth=320;

+ (void)initialize
{
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _left=10;
            _top=5;
            _width=70;
            _height=30;
            _landscapeCount=15;
            _portraitCount=7;
            
        }
        else
        {
            
        }
        
        _headerColor=[UIColor colorWithHue:3 saturation:81 brightness:100 alpha:1];
        _font=[UIFont systemFontOfSize:17];
        _dayDiffFont=[UIFont systemFontOfSize:10];
        _headerFont=[UIFont systemFontOfSize:17];
        _offsetFont=[UIFont systemFontOfSize:10];
        _boldFont=[UIFont boldSystemFontOfSize:17];
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
    UILabel* label=[self addItemLabel:view at:_firstItemLeft text:item.value];
    //label.font=_boldFont;
    label.textColor=_headerColor;
    
    for (int i=1; i<_portraitCount; i++) {
        if([timezoneItems count]<=i)
            return;
        
        item=[timezoneItems objectAtIndex:i];
        float labelLeft= _left+(i*(_width+_marginLeft));
        NSLog(@"Left is: %f \tWidth is: %f",labelLeft, _width);
        [self addItemLabel:view at:labelLeft text:item.value];
        [self addItemDayDiffLabel:view at:labelLeft text:item.dayDifference];
    }
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        for (int i=_portraitCount; i<_landscapeCount; i++) {
            if([timezoneItems count]<=i)
                return;
            
            item=[timezoneItems objectAtIndex:i];
            float labelLeft= _left+(i*(_width+_marginLeft));
                  NSLog(@"Left is: %f \tWidth is: %f",labelLeft, _width);
            [self addItemLabel:view at:labelLeft text:item.value];
            [self addItemDayDiffLabel:view at:labelLeft text:item.dayDifference];
        }
    }
}


+(UILabel*)addItemLabel:(UIView*)view at:(float)left text:(NSString*)text
{
    float rotation=0;//M_PI/2;
    float tag=(NSInteger)((left+_top)*1000000);
    UILabel* label=(UILabel*)[view viewWithTag:tag];
    if(label==NULL)
    {
        
        CGRect frame=CGRectMake(left, _top, _width, _height);
        label=[[UILabel alloc]initWithFrame:frame];
        label.tag= tag;
        label.font=_font;
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
    float tag=(left+top)*1000;
        float plusOneTag=(left+top+20)*1000;
    UILabel* label=(UILabel*)[view viewWithTag:tag];
    UILabel* labelPlusOne=(UILabel*)[view viewWithTag:plusOneTag];
    if(label==NULL)
    {
        NSLog(@"Crating a new label");
        UILabel* label=[[UILabel alloc]init];
        CGRect frame;
        frame=CGRectMake(left, top, _dayDiffWidth, _dayDiffHeight);
        label.textColor=[UIColor redColor];
        
        label.tag=tag;
        label.frame=frame;
        label.font=_dayDiffFont;
        label.lineBreakMode=NSLineBreakByTruncatingTail;
        label.numberOfLines=1;
        [view addSubview:label];
    }
    if(labelPlusOne==NULL)
    {
        UILabel* labelPlusOne=[[UILabel alloc]init];
        CGRect frame;
        frame=CGRectMake(left+20, top, _dayDiffWidth, _dayDiffHeight);
        labelPlusOne.textColor=[UIColor colorWithRed:0 green:122/255 blue:255/255 alpha:1];
        
        labelPlusOne.tag=plusOneTag;
        labelPlusOne.frame=frame;
        labelPlusOne.font=_dayDiffFont;
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
    _firstItemWidth=[self getHeaderLabelWidthForCollection:timezoneItems inViews:view];
    _width=_firstItemWidth;
    
    CGRect frame=CGRectMake(_firstItemLeft, _top, _firstItemWidth, view.frame.size.height);
    
    //label.font=[UIFont boldSystemFontOfSize:10];
    [self addHeaderItemView:view at:frame timezone:item buttonPressAction:action atOrder:0];
    
    
    for (int i=1; i<_portraitCount; i++) {
        float labelLeft= _left+(i*(_width+_marginLeft));
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
        for (int i=_portraitCount; i<_landscapeCount; i++) {
            float labelLeft= _left+(i*(_width+_marginLeft));
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
    button.timeZoneInfo.Name=timezone.name;
    button.timeZoneInfo.TimeZone=timezone.timeZone;
    NSString* labelText=@"Select";
    NSString* offsetLabelText=@"+";
    if(timezone != NULL)
    {
        labelText=timezone.name;
        offsetLabelText=timezone.timeZone.abbreviation;
        UILabel* label=[self getHeaderLabelWithText:labelText];
        UILabel* offsetLabel=[self getHeaderOffsetLabelWithText:offsetLabelText];
        if(order==0)
        {
            offsetLabel.textColor=_headerColor;
            label.textColor=_headerColor;
            //label.font=_boldFont;
        }
        [button addSubview:offsetLabel];
        [button addSubview:label];
        //label.textColor=_headerColor;
        [view addSubview:button];
        
    }
    else
    {
        UILabel* label=[self getHeaderAddTimeZoneLabel];
        [button addSubview:label];
        [view addSubview:button];
    }
    
    return button;
}

+(UILabel*)getHeaderOffsetLabelWithText:(NSString*)text
{
    CGRect frame=CGRectMake(0, 20, _width, 20);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=_offsetFont;
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
    label.font=_headerFont;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.text=text;
    //label.backgroundColor=[UIColor blueColor];
    return label;
}

+(UILabel*)getHeaderAddTimeZoneLabel
{
    CGRect frame=CGRectMake(0, 0, _width, _height+20);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=[UIFont boldSystemFontOfSize:25];
    label.numberOfLines=1;
    label.text=@"+";
    label.textColor=[UIColor greenColor];
    return label;
}

+(float)getHeaderLabelWidthForCollection:(NSMutableArray*)items inViews:(UIView*)view
{
    CGFloat width = CGRectGetWidth(view.bounds);
    long maxItemCount=0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            width=1024;
            maxItemCount=_landscapeCount;
        }
        else
        {
            width=758;
            maxItemCount=_portraitCount;
        }
    }
    else
    {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            width=568;
            maxItemCount=_landscapeCount;
        }
        else
        {
            width=310;
            maxItemCount=_portraitCount;
        }
    }
    
    if(items.count < maxItemCount)
    {
        maxItemCount= items.count +1;
    }
    
    width=width/(maxItemCount);
    return width;
}
@end
