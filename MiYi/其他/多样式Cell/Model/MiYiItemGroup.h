//
//  MiYiItemGroup.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiYiItemGroup : NSObject
@property (copy, nonatomic  ) NSString     *header;
@property (copy, nonatomic  ) NSString     *footer;
@property (strong, nonatomic) NSArray      *items;

+ (instancetype)group;
@end
