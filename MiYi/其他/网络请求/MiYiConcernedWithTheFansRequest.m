//
//  MiYiConcernedWithTheFansRequest.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/1.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiConcernedWithTheFansRequest.h"
#import "MiYiRequestManager.h"
#import "MiYiUserSession.h"
#import "MiYiNavViewController.h"
#import "MiYiSideslipVC.h"
#import "MiYiLoginVC.h"
@implementation MiYiConcernedWithTheFansRequest


+(void)concernedWithTheFansUserUID:(NSString *)uid json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockerror
{
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [[MiYiSideslipVC shared] presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    MiYiConcernedWithTheFans_type type =MiYi_Concern;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:uid forKey:@"uid"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/friend" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockerror(error);
    }];
}


+(void)concernedWithTheFansWatchlist:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockerror
{
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [[MiYiSideslipVC shared] presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    MiYiConcernedWithTheFans_type type =MiYi_ConcernList;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:page forKey:@"page"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/friend" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockerror(error);
    }];
    
}
+(void)concernedWithTheFansFans:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockerror
{
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [[MiYiSideslipVC shared] presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    MiYiConcernedWithTheFans_type type =MiYi_Fans;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:page forKey:@"page"];
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/friend" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockerror(error);
    }];
}

@end
