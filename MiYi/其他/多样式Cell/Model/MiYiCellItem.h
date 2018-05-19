//
//  MiYiCellItem.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^MiYiItemOperation)();


@interface MiYiCellItem : NSObject

@property (nonatomic, copy) NSString          *icon;
@property (nonatomic, copy) NSString          *title;
@property (nonatomic, copy) NSString          *subtitle;
@property (nonatomic, copy) UIColor           *color;
@property (nonatomic, copy) NSString          *image;
@property (nonatomic, copy) NSString          *detailText;


@property (nonatomic, copy) MiYiItemOperation operation;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title color:(UIColor *)color;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)imageURL;

+ (instancetype)item;
@end
