//
//  MiYiWeiBo.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MiYiWeiBoKey;
@interface MiYiWeiBo : NSObject

/**
 *  实例化
 */
+ (MiYiWeiBo *)shared;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(MiYiWeiBoKey *)account;

/**
 *  返回存储的账号信息
 */
+ (MiYiWeiBoKey *)account;


/**
 *  SDK登录
 */
-(void)weiboSdkLogin;


@end


@interface MiYiWeiBoKey : NSObject
@property (nonatomic, copy  ) NSString     *access_token;
@property (nonatomic, strong) NSDate       *expiresTime;// 账号的过期时间
// 如果服务器返回的数字很大, 建议用long long(比如主键, ID)
@property (nonatomic, assign) long long    expires_in;
@property (nonatomic, assign) long long    remind_in;
@property (nonatomic, assign) long long    uid;

@property (nonatomic, copy  ) NSString     *name;//用户昵称
@property (nonatomic, copy  ) NSString     *avatar_hd;//高清头像
@property (nonatomic, copy  ) NSString     * gender;
@end