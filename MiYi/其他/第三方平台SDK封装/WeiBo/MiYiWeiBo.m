//
//  MiYiWeiBo.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiWeiBo.h"
#import <MJExtension.h>
#define MiYiWeiBoFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MiYiWeiBo.data"]
@implementation MiYiWeiBo

+ (MiYiWeiBo *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)saveAccount:(MiYiWeiBoKey *)account
{
    // 计算账号的过期时间
    NSDate *now = [NSDate date];
    account.expiresTime = [now dateByAddingTimeInterval:account.expires_in];
    
    [NSKeyedArchiver archiveRootObject:account toFile:MiYiWeiBoFile];
}

+ (MiYiWeiBoKey *)account
{
    // 取出账号
    MiYiWeiBoKey *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MiYiWeiBoFile];
    
    // 判断账号是否过期
    NSDate *now = [NSDate date];
    NSLog(@"%lld",account.expires_in);
    if ([now compare:account.expiresTime] == NSOrderedAscending) { // 还没有过期
        return account;
    } else { // 过期
        return nil;
    }
}


-(void)weiboSdkLogin
{
//    WBAuthorizeRequest *request =[WBAuthorizeRequest request];
//    request.redirectURI=@"http://www.sina.com";
//    [WeiboSDK sendRequest:request];
}










@end


@implementation MiYiWeiBoKey
MJCodingImplementation

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end
