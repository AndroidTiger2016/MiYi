//
//  MiYiWeChat.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiWeChat.h"
#import <MJExtension.h>

#define MiYiWeChatFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MiYiWeChat.data"]
@implementation MiYiWeChat

+ (MiYiWeChat *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)saveAccount:(MiYiWeChatKey *)account
{
    // 计算账号的过期时间
    [NSKeyedArchiver archiveRootObject:account toFile:MiYiWeChatFile];
}

+ (MiYiWeChatKey *)account
{
    // 取出账号
#warning 微信第三方登录需要计算过期时间
    MiYiWeChatKey *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MiYiWeChatFile];
    
  
        return account;

}

-(void)wechatSdkLogin
{
    
}

@end


@implementation MiYiWeChatKey
MJCodingImplementation

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end