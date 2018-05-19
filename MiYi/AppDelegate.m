//
//  AppDelegate.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "MiYiWelcome.h"
#import "MiYiNavViewController.h"
#import "UIImage+MiYi.h"
#import "MiYiUserSession.h"
#import "MiYiTabBarViewController.h"
#import "MiYiLeftSideslipUserVC.h"
#import "MiYiSideslipVC.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiUser.h"
#import "MiYiNewfeatureTool.h"

@interface AppDelegate ()
@property (nonatomic, retain) UIViewController *welcomeVC;

@end

@implementation AppDelegate

//- (void)subFilesForDir:(NSString *)dir
//{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//
//    NSArray * files = [fileManager contentsOfDirectoryAtPath:dir error:nil];
//    NSLog(@"dir %@ subfiles %@  att %@",dir, files,[fileManager attributesOfItemAtPath:dir error:nil]);
//    for (NSString * fileName in files) {
//        NSString *nDir = [dir stringByAppendingPathComponent:fileName];
//        [self subFilesForDir:nDir];
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    NSString * dir = NSHomeDirectory();
    //    [self subFilesForDir:dir];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    
    [[SDImageCache sharedImageCache]setShouldDecompressImages:NO];
    //    //微博
    //    [WeiboSDK enableDebugMode:YES];
    //    [WeiboSDK registerApp:@""];
    //    //微信
    //    [WXApi registerApp:@""];
    //
    //    [SMS_SDK registerApp:appKey withSecret:appSecret];
    
    [MiYiNewfeatureTool chooseRootController];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //    NSString *docDir = [paths objectAtIndex:0];
    //    NSLog(@"%@",docDir);
    //
    //    dispatch_async(
    //
    //                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
    //
    //                   , ^{
    //                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0];
    //
    //                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    //
    //                       NSLog(@"files :%ld",[files count]);
    //
    //                       for (NSString *p in files) {
    //                           NSError *error;
    //                           NSString *path = [cachPath stringByAppendingPathComponent:p];
    //                           long long folderSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    //                           NSLog(@"路径%@----%f",path,folderSize/(1024.0*1024.0));
    //                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    //
    //                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    //                           }
    //                       }
    //
    //                       [self  performSelectorOnMainThread:@selector(clearCacheSuccess)withObject:nil waitUntilDone:YES];
    //                   });
    //
    //
    
    
    
    
    // Override point for customization after application launch.
    return YES;
}


-(void)clearCacheSuccess
{
    
    NSLog(@"清理成功");
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    //    [imageCache clearMemory];
    //    [imageCache clearDiskOnCompletion:^{
    //        NSLog(@"imageCache清楚");
    //    }];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
