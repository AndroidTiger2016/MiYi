//
//  MiYiQQ.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiQQ.h"
#import <MJExtension.h>
#import "MiYiRequestManager.h"
#import <MJExtension.h>
#define MiYiQQFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MiYiQQ.data"]
@interface MiYiQQ ()

//@property (nonatomic ,strong)TencentOAuth *  tencentOAuth;


@end


@implementation MiYiQQ

+ (MiYiQQ *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)saveAccount:(MiYiQQKey *)account
{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYYMMdd"];
    NSString* s1 = [df stringFromDate:account.expirationDate];
    account.expiresTime = s1;
    [NSKeyedArchiver archiveRootObject:account toFile:MiYiQQFile];
}

+ (MiYiQQKey *)account
{
    // 取出账号
    
    MiYiQQKey *account = [NSKeyedUnarchiver unarchiveObjectWithFile:MiYiQQFile];
    // 判断账号是否过期
    NSDate *now = [NSDate date];
    NSDateFormatter*df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"YYYYMMdd"];
    NSString* Current = [df stringFromDate:now];
    NSString *CurrentYYYY = [Current substringToIndex:4];
    NSString *ExpiredYYYY = [account.expiresTime substringToIndex:4];
    if ([CurrentYYYY intValue]>=[ExpiredYYYY intValue]) {
        NSString *CurrentMM =[Current substringWithRange:NSMakeRange(4,2)];
        NSString *ExpiredMM =[account.expiresTime substringWithRange:NSMakeRange(4,2)];
        if([CurrentMM intValue]<[ExpiredMM intValue])
        {
            return account;
        }else if([CurrentMM intValue] ==[ExpiredMM intValue])
        {
            NSString *Currentdd =[Current substringWithRange:NSMakeRange(6,2)];
            NSString *Expireddd =[account.expiresTime substringWithRange:NSMakeRange(6,2)];
            if ([Currentdd intValue] >[Expireddd intValue]) {
                return nil;
            }else
            {
                return account;
            }
            
        }else
        {
            return nil;
        }
    }else
    {
        return nil;
    }
    
}


//-(void)qqSdkLogin
//{
//    
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"" andDelegate:self];
//    NSArray * permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t",kOPEN_PERMISSION_ADD_SHARE, nil];
//    [_tencentOAuth authorize:permissions inSafari:NO];
//    
//    
//}
//
//-(void)tencentDidLogin
//{
//    
//    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
//    {
//        
//        //        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"我在测试格子是否可以分享到QQ空间！这样我就安心"];
//        //        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
//        //        //将内容分享到qq
//        //        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//        
//        //        纯图片分享:
//        //开发者分享图片数据
//        //        NSData *imgData = [NSData dataWithContentsOfFile:@""];
//        //        //
//        //        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
//        //                                                   previewImageData:imgData
//        //                                                              title:@"title"
//        //                                                        description:@"description"];
//        //
//        //        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
//        //        //将内容分享到qq
//        //        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//        
//        //        新闻分享:
//        //分享跳转URL
//        //        NSString *url = @"http://xxx.xxx.xxx/";
//        //        //分享图预览图URL地址
//        //        NSString *previewImageUrl = @"preImageUrl.png";
//        //        QQApiNewsObject *newsObj = [QQApiNewsObject
//        //                                    objectWithURL:[NSURL URLWithString:utf8String]
//        //                                    title: @"title";
//        //                                    description:@"description";
//        //                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
//        //        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
//        //        //将内容分享到qq
//        //        //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//        //        //将内容分享到qzone
//        //        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
//        NSString *qqURL =[NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=%@&openid=%@",_tencentOAuth.accessToken,_tencentOAuth.appId,_tencentOAuth.openId];
//     
//        [MiYiRequestManager getWithURL:qqURL params:nil success:^(id json) {
//            
//            NSString * nickname =  [json valueForKey:@"nickname"];
//            NSString* figureurl_qq_2 = [json valueForKey:@"figureurl_qq_2"];
//            NSString* gender = [json valueForKey:@"gender"];
//            NSDictionary *dic =@{
//                                 
//                                 @"gender":gender,
//                                 @"nickname":nickname,
//                                 @"figureurl_qq_2":figureurl_qq_2,
//                                 @"access_token":_tencentOAuth.accessToken,
//                                 @"expirationDate":[_tencentOAuth expirationDate],
//                                 @"appId":[_tencentOAuth appId],
//                                 @"openId":[_tencentOAuth openId]
//                                 };
//            MiYiQQKey *key =[MiYiQQKey objectWithKeyValues:dic];
//            [MiYiQQ saveAccount:key];
//
//            NSLog(@"%@",json);
//        } failure:^(NSError *error) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
//                                                                message:@"您的QQ账号获取资料失败,请重新授权"
//                                                               delegate:nil
//                                                      cancelButtonTitle:nil
//                                                      otherButtonTitles:@"确定", nil];
//            [alertView show];
//            NSLog(@"%@",error);
//        }];
//   
//        
//    }
//    else
//    {
//        NSLog (@"登录不成功 没有获取accesstoken");
//    }
//    
//}
//-(void)tencentDidNotLogin:(BOOL)cancelled
//{
//    if (cancelled)
//    {
//        NSLog( @"用户取消登录");
//    }
//    else
//    {
//        NSLog(@"登录失败");
//        
//        
//    }
//}
//
//-(void)tencentDidNotNetWork
//{
//    NSLog(@"无网络连接，请设置网络");
//}
@end


@implementation MiYiQQKey

MJCodingImplementation;

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end