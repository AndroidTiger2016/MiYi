//
//  MiYIUserModel.h
//  MiYi
//
//  Created by huangzheng on 9/6/15.
//  Copyright (c) 2015 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiYiUserInfoModel : NSObject
/**
 *  头像
 */
@property (nonatomic ,copy) NSString *avatar;
/**
 *  经验值
 */
@property (nonatomic ,copy) NSString *exp_point;
/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *nickname;
/**
 *  蜜币
 */
@property (nonatomic ,copy) NSString *reward_point;
/**
 *  简介
 */
@property (nonatomic ,copy) NSString *summary;
/**
 * 用户ID
 */
@property (nonatomic ,copy) NSString *user_id;

/**
 *  关注
 */
@property (nonatomic, copy) NSString *following;

/**
 *  粉丝
 */
@property (nonatomic, copy) NSString *follower;

/**
 *  发布
 */
@property (nonatomic, copy) NSString *deliver;

/**
 *  风格
 */
@property (nonatomic, copy) NSArray *styles;

/**
 *  动态
 */
@property (nonatomic, copy) NSArray *trends;

/**
 *  衣橱
 */
@property (nonatomic, copy) NSArray *wardrobe;
 

@end
