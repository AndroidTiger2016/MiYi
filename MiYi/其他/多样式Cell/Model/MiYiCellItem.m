//
//  MiYiCellItem.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCellItem.h"

@implementation MiYiCellItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    MiYiCellItem *item = [self item];
    item.icon = icon;
    item.title = title;
    
    return item;
}
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title color:(UIColor *)color
{
    MiYiCellItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.color = color;
    
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)imageURL
{
    MiYiCellItem *item = [self item];
    item.title = title;
    item.image = imageURL;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}

+ (instancetype)item
{
    return [[self alloc] init];
}
@end
