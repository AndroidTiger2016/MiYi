//
//  MiYiArrowItem.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCellItem.h"
#import <UIKit/UIKit.h>

@interface MiYiArrowItem : MiYiCellItem

@property (assign, nonatomic) Class        destVcClass;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title color:(UIColor *)color destVcClass:(Class)destVcClass;

@end
