//
//  MiYiQQ.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MiYiQQKey;
@interface MiYiQQ : NSObject

/**
 *  实例化
 */
+ (MiYiQQ *)shared;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(MiYiQQKey *)account;

/**
 *  返回存储的账号信息
 */
+ (MiYiQQKey *)account;


/**
 *  SDK登录
 */
//-(void)qqSdkLogin;

@end

@interface MiYiQQKey : NSObject

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, strong) NSString *expiresTime; // 账号的过期时间

@property (nonatomic, assign) NSDate * expirationDate;
@property (nonatomic, assign) NSString* appId;
@property (nonatomic, assign) NSString* openId;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *figureurl_qq_2;
@property (nonatomic, copy) NSString *gender;


@end