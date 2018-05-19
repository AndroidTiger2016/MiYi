//
//  MiYiPostDatailsModel.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/9.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPostDatailsModel.h"
#import "NSDate+YXL.h"
#import "MiYiPhotosView.h"
#import <CoreLocation/CoreLocation.h>
#import "MiYiUser.h"
@implementation MiYiPostDatailsModel
- (void)setTime:(NSString *)time
{
    
    // _created_at == Fri May 09 16:30:34 +0800 2014
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //2010-12-08 06:53:43
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //将NSString转换为NSDate
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[time floatValue]];
    NSDate *createdDate  = [fmt dateFromString:[fmt stringFromDate:d]];
    NSString *times;
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            _time =[NSString stringWithFormat:@"%d %@", (int)createdDate.deltaWithNow.hour,NSLocalizedString(@"小时前",nil)];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            _time =[NSString stringWithFormat:@"%d %@", (int)createdDate.deltaWithNow.minute,NSLocalizedString(@"分钟前",nil)];
        } else {
            _time = NSLocalizedString(@"刚刚",nil);
        }
    } else if (createdDate.isYesterday) { // 昨天
        fmt.dateFormat = @"HH:mm";
        times = [fmt stringFromDate:createdDate];
        times =[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"昨天",nil),times];
        _time =times;
    } else if (createdDate.isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        _time = [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        _time  =[fmt stringFromDate:createdDate];
    }
    
    
}

-(void)setLocation:(NSString *)location{
    if ([[MiYiUser shared]accountUser].location.length==0 || location.length==0) {
        _location =@" 未知";
        return;
    }
    NSRange range = [location rangeOfString:@","];
    CGFloat latitude =[[NSString stringWithFormat:@"%@",[location substringToIndex:range.location]] floatValue];
    CGFloat longitude =[[NSString stringWithFormat:@"%@",[location substringFromIndex:range.location+1]]floatValue];
    
    
    
    CGFloat userLatitude =[[NSString stringWithFormat:@"%@",[[[MiYiUser shared]accountUser].location substringToIndex:range.location]] floatValue];
    CGFloat userLongitude =[[NSString stringWithFormat:@"%@",[[[MiYiUser shared]accountUser].location substringFromIndex:range.location+1]]floatValue];
    
    CLLocation *current=[[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    CLLocation *before=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance meters=[current distanceFromLocation:before];
    NSInteger locationInt = (NSInteger )meters;
    if (locationInt >1000) {
        _location =[NSString stringWithFormat:@" %.1ldkm",locationInt/1000];
    }else if (locationInt <1000){
        _location = [NSString stringWithFormat:@" %ldm",locationInt];
    }else if (locationInt >10000){
        _location =[NSString stringWithFormat:@" %.1ldwm",locationInt/10000];
    }
    
}

-(CGFloat)cellTextHeight{
    if (_content.length==0) {
        return 0;
    }
    CGSize constrainedSize = CGSizeMake(kWindowWidth - 12, 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:11], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[_content stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (requiredHeight.size.height >6) {
        return requiredHeight.size.height-6;
    }else
        return 0;
}

@end
