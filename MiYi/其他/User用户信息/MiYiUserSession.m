//
//  MiYiUserSession.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/4.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUserSession.h"
#import <objc/runtime.h>
#import <MJExtension.h>
#import "MiYiLoginVC.h"
#import "MiYiSideslipVC.h"
#import "MiYiNavViewController.h"
#define MiYiSessionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MiYiSession.data"]

@implementation MiYiUserSession

+ (MiYiUserSession *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)saveSession:(MiYiSession *)session
{
    [NSKeyedArchiver archiveRootObject:session toFile:MiYiSessionFile];
}

- (MiYiSession *)session
{
    // 取出账号
    MiYiSession *session = [NSKeyedUnarchiver unarchiveObjectWithFile:MiYiSessionFile];
    if (session==nil) {
        
        return nil;
    }
    return session;
    
}


@end


@implementation MiYiSession

MJCodingImplementation

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end