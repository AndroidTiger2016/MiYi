//
//  MiYiWeChat.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MiYiWeChatKey;
@interface MiYiWeChat : NSObject

/**
 *  实例化
 */
+ (MiYiWeChat *)shared;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(MiYiWeChatKey *)account;

/**
 *  返回存储的账号信息
 */
+ (MiYiWeChatKey *)account;


/**
 *  SDK登录
 */
-(void)wechatSdkLogin;

@end

@interface MiYiWeChatKey : NSObject

@end