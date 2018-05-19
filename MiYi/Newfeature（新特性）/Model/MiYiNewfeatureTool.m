//
//  MiYiNewfeatureTool.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/24.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiNewfeatureTool.h"
#import "MiYiUser.h"
#import "MiYiUserSession.h"
#import "MiYiSideslipVC.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiUserRequest.h"
#import "MiYiNewfeatureVC.h"
@implementation MiYiNewfeatureTool
+ (void)chooseRootController
{
    NSString *key = @"CFBundleVersion";
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        
        MiYiSideslipVC *sideslip = [MiYiSideslipVC shared];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = sideslip;
        
        
        if ([[MiYiUserSession shared]session].session) {

            [MiYiUserRequest sessionReload:[[MiYiUserSession shared]session] json:^(BOOL success) {
                if (success) {
                    [MBProgressHUD showSuccess:@"刷新Session成功"];
                    [MiYiUserRequest userInfoId:[[MiYiUserSession shared] session].uid json:^(id json) {
                    } error:^(NSError *error) {
                        [MBProgressHUD showError:@"获取用户信息失败\n可能网络出现问题"];
                        
                    }];
                    
                }else
                {
                    [MiYiUser clearMessage];
                    [Notification postNotificationName:MiYiHomeVCNavItemNotification object:nil];
                    MiYiAccount*account=[[MiYiUser shared]accountUser];
                    [[MiYiSideslipVC shared].leftControl userData:account];
                    [MBProgressHUD showError:@"账号时间过期或者不是同一台设备"];
                }
                
            } error:^(NSError *error) {
                
                [MBProgressHUD showError:@"网络出现问题"];
                
            }];
    
            
            
        }
    } else {
        // 新版本
        MiYiNewfeatureVC *vc =[[MiYiNewfeatureVC alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        //         存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
}

@end
