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
float left=10;
float top=5;
float width=50;
float height=20;
float marginLeft=10;
int landscapeCount=9;
int portraitCount=5;
UIFont* font;
UIFont* headerFont;
UIFont* offsetFont;

+ (void)initialize
{
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            left=10;
            top=5;
            width=60;
            height=30;
            landscapeCount=18;
            portraitCount=10;
        }
        else
        {
            
        }

        font=[UIFont systemFontOfSize:12];
        headerFont=[UIFont systemFontOfSize:10];
        offsetFont=[UIFont systemFontOfSize:8];
    }
    
}

+(void) addValueLabelsToView:(UIView*)view fromTimezones:(NSMutableArray* )timezoneItems
{
    SHADateTimeCellItem* item;
    item=[timezoneItems objectAtIndex:0];
    UILabel* label=[self addItemLabel:view at:firstItemLeft text:item.Value];
    label.font=[UIFont boldSystemFontOfSize:14];
    
    for (int i=1; i<portraitCount; i++) {
        if([timezoneItems count]<=i)
            return;
        
        item=[timezoneItems objectAtIndex:i];
        float labelLeft= left+(i*(width+marginLeft));
        [self addItemLabel:view at:labelLeft text:item.Value];
    }
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        for (int i=portraitCount; i<landscapeCount; i++) {
            if([timezoneItems count]<=i)
                return;
            
            item=[timezoneItems objectAtIndex:i];
            float labelLeft= left+(i*(width+marginLeft));
            [self addItemLabel:view at:labelLeft text:item.Value];
        }
    }
}


+(UILabel*)addItemLabel:(UIView*)view at:(float)left text:(NSString*)text
{
    float rotation=0;//M_PI/2;
    CGRect frame=CGRectMake(left, top, width, height);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=font;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.transform = CGAffineTransformMakeRotation(rotation);//(M_PI_4);
    label.text=text;
    [view addSubview:label];
    return label;
}

+(void) addHeaderLabelsToView:(UIView*)view fromTimezones:(NSMutableArray* )timezoneItems buttonPressAction:(SHAButtonActionBlock) action
{
    //float rotation=0;//M_PI/2;
    for(UIView *subview in [view subviews]) {
        [subview removeFromSuperview];
    }
    SHATimeZone* item;
    item=[timezoneItems objectAtIndex:0];
    CGRect frame=CGRectMake(firstItemLeft, top, firstItemWidth, view.frame.size.height);
    
    //label.font=[UIFont boldSystemFontOfSize:10];
    [self addHeaderItemView:view at:frame timezone:item buttonPressAction:action atOrder:0];
    
    
    for (int i=1; i<portraitCount; i++) {
        float labelLeft= left+(i*(width+marginLeft));
        CGRect frame=CGRectMake(labelLeft, top, width, view.frame.size.height);
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
            float labelLeft= left+(i*(width+marginLeft));
            CGRect frame=CGRectMake(labelLeft, top, width, view.frame.size.height);
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
    CGRect frame=CGRectMake(0, 20, width, 20);
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
    CGRect frame=CGRectMake(0, 0, width, height);
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=headerFont;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.text=text;
    //label.backgroundColor=[UIColor blueColor];
    return label;
}

@end
