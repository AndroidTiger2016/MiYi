//
//  MiYiLocationCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/7.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiLocationCell.h"

@implementation MiYiLocationCell


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _celsius.textColor=UIColorRGBA(252, 150, 203, 1);
    _weatherIn.textColor=UIColorRGBA(155, 155, 155, 1);
    _theDate.textColor=_weatherIn.textColor;
    _week.textColor=_weatherIn.textColor;
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
   _theDate.text = [NSString stringWithFormat:@"%ld/%ld",(long)month,(long)day];
    _week.text=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];
    
    
}

@end
