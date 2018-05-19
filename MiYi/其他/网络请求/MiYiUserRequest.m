//
//  MiYiUserRequest.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/4.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUserRequest.h"
#import "MiYiRequestManager.h"
#import "MiYiUser.h"
#import <MJExtension.h>
#import "MiYiUserSession.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiWelcome.h"
#import "MiYiSideslipVC.h"
#import <UIKit/UIKitDefines.h>
#import "MiYiNavViewController.h"
#import "MiYiLoginVC.h"
@implementation MiYiUserRequest

/**
 {
 data =     {
 "is_new" = 0;
 session = d2b5366b996bdb7b291519cd31351c8d;
 uid = 3;
 };
 random = 17;
 ret = 0;
 time = "1442808501.691883";
 }
 */
+(void)loginWithPhoneNumber:(NSString *)phone json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random= arc4random() % 100;
    [tempDic setObject:phone forKey:@"un"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)MiYiLoginPhone] forKey:@"lm"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/register" params:tempDic success:^(id json) {
        NSNumber *ret =json[@"ret"];
        if ([ret integerValue]!=0) {
            blockJson(json);
            return ;
        }
        
        MiYiSession *session=[MiYiSession objectWithKeyValues:json[@"data"]];
        [[MiYiUserSession shared] saveSession:session];
        blockJson(json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        blockError(error);
    }];
    
}


+(void)loginWithUid:(NSString *)un thirdPartyType:(MiYiLoginType )lm json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random= arc4random() % 100;
    [tempDic setObject:un forKey:@"un"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)lm] forKey:@"lm"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/register" params:tempDic success:^(id json) {
        NSNumber *ret =json[@"ret"];
        if ([ret integerValue]!=0) {
            blockJson(json);
            return ;
        }
        MiYiSession* session=[MiYiSession objectWithKeyValues:json[@"data"]];
        [[MiYiUserSession shared] saveSession:session];
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];
}


+ (void)sessionReload:(MiYiSession *)session json:(MiYiHttpRequestBOOL)blockJson error:(MiYiHttpRequestError)blockError
{

    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random= arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:session.session forKey:@"session"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/login" params:tempDic success:^(id json) {
        
        NSNumber *ret =json[@"ret"];
        if ([ret integerValue]!=0) {
            
            if([ret integerValue] ==268435460)
            {
                BOOL isClear;
                isClear =[MiYiUser clearMessage];
                if (!isClear) {
                    [MBProgressHUD showError:@"清除账号失败"];
                }
                [MBProgressHUD showError:@"账号信息错误,请重新登录"];
                MiYiWelcome *rootViewControl = [[MiYiWelcome alloc] init];
                UIWindow *screenWindow = [[UIApplication  sharedApplication] keyWindow];
                screenWindow.rootViewController=rootViewControl;
                
            }else
            {
                [MBProgressHUD showError:@"账号被管理员锁住或者已删除"];
            }
            
            blockJson(NO);
            return ;
        }
        MiYiSession*session=[MiYiSession objectWithKeyValues:json[@"data"]];
        [[MiYiUserSession shared] saveSession:session];
        blockJson(YES);
    } failure:^(NSError *error) {
        blockError(error);
    }];
}

+ (void)userInfoId:(NSString *)userId json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random= arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:userId forKey:@"uid"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/profile" params:tempDic success:^(id json) {
        NSNumber *ret =json[@"ret"];
        if ([ret integerValue]!=0) {
            [MBProgressHUD showError:@"获取信息失败"];
            return ;
        }
        if([userId isEqualToString:[[MiYiUserSession shared]session].uid])
        {
            MiYiAccount *accountOlder=[[MiYiUser shared]accountUser];
            MiYiAccount*account=[MiYiAccount objectWithKeyValues:json[@"data"][@"user"]];
            if(accountOlder.location.length!=0)
            {
                account.location=accountOlder.location;
            }
            [[MiYiUser shared] saveAccountUser:account];
            [[MiYiSideslipVC shared].leftControl userData:account];
            blockJson(@YES);
        }else
        {
            blockJson(json);
        }
    } failure:^(NSError *error) {
        blockError(error);
    }];
}


+ (void)modifyInformationType:(MiYiUserRequest_type)type Contents:(NSString *)contents Success:(MiYiHttpRequestBOOL)success
{
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random= arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [[MiYiSideslipVC shared] presentViewController:nav animated:YES completion:nil];
        return;
    }
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    if (MiYiUserRequest_typeName ==type) {
        [tempDic setObject:contents forKey:@"nn"];
    }else if (MiYiUserRequest_typeUserIcon ==type)
    {
        [tempDic setObject:contents forKey:@"uu"];
    }else if (MiYiUserRequest_typeSex ==type)
    {
        [tempDic setObject:contents forKey:@"ug"];
    }else if (MiYiUserRequest_typeIntroduction ==type)
    {
        [tempDic setObject:contents forKey:@"us"];
    }else if (MiYiUserRequest_typeUserLocate ==type)
    {
        [tempDic setObject:contents forKey:@"ul"];
    }else if (MiYiUserRequest_typeUserStyle ==type)
    {
        [tempDic setObject:contents forKey:@"style"];
    }
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/user" params:tempDic success:^(id json) {
        
        NSNumber *ret =json[@"ret"];
        if ([ret integerValue]!=0) {
            success(NO);
        }else
        {
            success(YES);
        }
        
    } failure:^(NSError *error) {
        success(NO);
    }];
    
}


+ (void)uploadImage:(UIImage *)image blockJson:(MiYiHttpRequestJson)blockJson
{
    
    formData *form =[[formData alloc]init];
//    if (UIImagePNGRepresentation(image)) {
//        
//        form.data = UIImagePNGRepresentation(image);
//        form.mimeType =@"image/png";
//    }else {
        form.data =UIImageJPEGRepresentation(image, 0.00001);
        form.mimeType =@"image/jpeg";
//    }
    form.name =@"file";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    form.filename =[NSString stringWithFormat:@"%@.jpg",currentDateStr];
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:[MiYiUserSession shared].session.uid forKey:@"uid"];
    [tempDic setObject:@"180x180" forKey:@"thumb"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"picture_upload" params:tempDic formData:form success:^(id json) {
        
        
        NSNumber *ret =json[@"ret"];
        if ([ret integerValue]!=0) {
            blockJson(@NO);
        }else
        {
            blockJson(json);
        }
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络出现问题"];
        NSLog(@"%@",error);
    }];
}

@end
