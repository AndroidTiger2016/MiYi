//
//  MiYiUser.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/4.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MiYiAccount;
@interface MiYiUser : NSObject

/**
 *  实例化
 */
+ (MiYiUser *)shared;
/**
 *  保存
 */
- (void)saveAccountUser:(MiYiAccount *)accountUser;
/**
 *  取出数据
 *
 *  @return account                                   
 */
- (MiYiAccount *)accountUser;

/**
 *  删除所有的用户信息
 *
 *  @return 返回YES是删除成功  返回NO是某个信息删除失败
 */
+(BOOL)clearMessage;


@end

@interface MiYiAccount : NSObject

/**
 *  用户状态
 */
@property (nonatomic ,copy) NSString              *available;
/**
 *  用户头像URL
 */
@property (nonatomic ,copy) NSString              *avatar;
/**
 *  用户的收藏数量
 */
@property (nonatomic ,copy) NSString              *collect;
/**
 *  用户的经验值
 */
@property (nonatomic ,copy) NSString              *exp_point;
/**
 *  注册时间
 */
@property (nonatomic ,copy) NSString              *first_login;
/**
 *  关注
 */
@property (nonatomic ,copy) NSString              *follower;
/**
 *  用户关注人
 */
@property (nonatomic ,copy) NSString              *following;
/**
 *  性别
 */
@property (nonatomic ,copy) NSString              *gender;
/**
 *  最后登录时间
 */
@property (nonatomic ,copy) NSString              *last_login;
/**
 *  位置
 */
@property (nonatomic ,copy) NSString              *location;
/**
 *  名称
 */
@property (nonatomic ,copy) NSString              *nickname;
/**
 *  蜜糖  货币
 */
@property (nonatomic ,copy) NSString              *reward_point;
/**
 *  个人签名
 */
@property (nonatomic ,copy) NSString              *summary;
/**
 *  帖子数
 */
@property (nonatomic ,copy) NSString              *topic;
/**
 *  风格
 */
@property (nonatomic ,copy) NSString              *style;
@end
