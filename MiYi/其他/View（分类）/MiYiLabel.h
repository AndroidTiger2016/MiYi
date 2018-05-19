//
//  MiYiLabel.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MiYiLabelControlEvents) {
    MiYiLabelControlEventTap,
    MiYiLabelControlEventLongPressBegan,
    MiYiLabelControlEventLongPressEnd,
};

@interface MiYiLabel : UILabel


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(MiYiLabelControlEvents)controlEvents;
@end
