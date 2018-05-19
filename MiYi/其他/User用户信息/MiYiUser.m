//
//  MiYiUser.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/4.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUser.h"
#import <MJExtension.h>
#define MiYiUserFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MiYiUser.data"]
@implementation MiYiUser



+ (MiYiUser *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)saveAccountUser:(MiYiAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:MiYiUserFile];
}

- (MiYiAccount *)accountUser
{
    // 取出账号
    MiYiAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MiYiUserFile];
    
    return account;
    
}

+(BOOL)clearMessage
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString*lu=@"MiYiUser.data";
    NSString*lu1 = @"MiYiSession.data";
    BOOL isError ;
    
    isError =[fileManager removeItemAtPath:lu error:nil];
    if (!isError) {
        return NO;
    }
    isError =[fileManager removeItemAtPath:lu1 error:nil];
    if (!isError) {
        return NO;
    }
    
    
    return YES;
}
@end


@implementation MiYiAccount

MJCodingImplementation

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

-(void)setExp_point:(NSString *)exp_point
{
    NSInteger point =[exp_point integerValue];
    if (point <200) {
        _exp_point=@"时尚新人";
    }else if (point >=200 && point <1000)
    {
        _exp_point=@"时尚追风族";
    }else if (point >=1000 && point <2000)
    {
        _exp_point=@"时尚先锋";
    }else if (point >=2000 && point <5000)
    {
        _exp_point=@"时尚达人";
    }else if (point >=5000 && point <10000)
    {
        _exp_point=@"时尚教练";
    }else if (point >=10000 && point <20000)
    {
        _exp_point=@"时尚精灵";
    }else if (point >=20000 && point <30000)
    {
        _exp_point=@"时尚魔法师";
    }else if (point >=30000 )
    {
        _exp_point=@"时尚女王";
    }
   
}
@end
