//
//  MiYiMenuSentModel.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/29.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiYiOwnerModel.h"


@interface MiYiMenuSentModel : NSObject<NSCopying>

@property (nonatomic ,copy) NSString *content;

@property (nonatomic ,strong) NSMutableArray *images;

@property (nonatomic ,copy) NSString *location;

@end
