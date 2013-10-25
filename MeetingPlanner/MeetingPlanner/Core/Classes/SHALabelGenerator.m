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
    UILabel* offsetLabel;
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

+(void) addHeaderLabelsToView:(UIView*)view fromTimezones:(NSMutableArray* )timezoneItems
{
    //float rotation=0;//M_PI/2;
    SHADateTimeCellItem* item;
    item=[timezoneItems objectAtIndex:0];
    CGRect frame=CGRectMake(firstItemLeft, top, firstItemWidth, height);
    UILabel* label=[self getHeaderLabel:view at:frame text:item.Name];
    label.font=[UIFont boldSystemFontOfSize:10];
    [self addOffsetLabelToView:view at:firstItemLeft text:item.Offset];

    
    for (int i=1; i<portraitCount; i++) {
        if([timezoneItems count]<=i)
            return;
        
        item=[timezoneItems objectAtIndex:i];
        float labelLeft= left+(i*(width+marginLeft));
        CGRect frame=CGRectMake(labelLeft, top, width, height);
        label=[self getHeaderLabel:view at:frame text:item.Name];
        [self addOffsetLabelToView:view at:labelLeft text:item.Offset];

    }
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        for (int i=portraitCount; i<landscapeCount; i++) {
            if([timezoneItems count]<=i)
                return;
            
            item=[timezoneItems objectAtIndex:i];
            float labelLeft= left+(i*(width+marginLeft));
            CGRect frame=CGRectMake(labelLeft, top, width, height);
            label=[self getHeaderLabel:view at:frame text:item.Name];
                    [self addOffsetLabelToView:view at:labelLeft text:item.Offset];
        }
    }
}

+(UILabel*)addOffsetLabelToView:(UIView*)view at:(float)left text:(NSString*)text
{
    CGRect frame=CGRectMake(left, 25, width, 15);
    float rotation=0;//M_PI/2;
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=offsetFont;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.transform = CGAffineTransformMakeRotation(rotation);//(M_PI_4);
    label.text=text;
    [view addSubview:label];
    return label;
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

+(UILabel*)getHeaderLabel:(UIView*)view at:(CGRect)frame text:(NSString*)text
{
    float rotation=0;//M_PI/2;
    UILabel* label=[[UILabel alloc]initWithFrame:frame];
    label.font=headerFont;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.numberOfLines=1;
    label.transform = CGAffineTransformMakeRotation(rotation);//(M_PI_4);
    label.text=text;
    [view addSubview:label];
    return label;
}
@end
