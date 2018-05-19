//
//  MiYiWardrobeRequest.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/12.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiWardrobeRequest.h"
#import "MiYiRequestManager.h"
#import "MiYiLoginVC.h"
#import "MiYiNavViewController.h"
#import "MiYiSideslipVC.h"
#import "MiYiUserSession.h"

@implementation MiYiWardrobeRequest

+(void)wardrobeWatchList:(NSString *)wardrobeID  success:(MiYiHttpRequestBOOL)success
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
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)MiYiWardrobeWatchList] forKey:@"request_type"];
    [tempDic setObject:wardrobeID forKey:@"goods_id"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/wardrobe" params:tempDic success:^(id json) {
        NSLog(@"json%@",json);
        NSNumber *ret  = json[@"ret"];
        if ([ret integerValue]!=0) {
            success(NO);
            return ;
        }
        success(YES);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        success(NO);
    }];


}

+(void)wardrobeList:(NSString *)ownerID  page:(NSString *)page blockJson:(MiYiHttpRequestJson)blockJson blockError:(MiYiHttpRequestError)blockError
{
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)MiYiWardrobeList] forKey:@"request_type"];
    [tempDic setObject:ownerID forKey:@"owner"];
    [tempDic setObject:page forKey:@"page"];

    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/wardrobe" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];

    
    
    
}


+(void)wardrobeCommentData:(id)data goods_id:(NSString *)goods_id success:(MiYiHttpRequestBOOL)success
{
    
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [[MiYiSideslipVC shared] presentViewController:nav animated:YES completion:nil];
        return;
    }
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random = arc4random() % 100;
    [tempDic setValue:goods_id forKey:@"goods_id"];
    [tempDic setValue:data forKey:@"data"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)MiYiWardrobeComments]forKey:@"request_type"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/wardrobe" params:tempDic success:^(id json) {
        NSLog(@"json%@",json);
        NSNumber *ret  = json[@"ret"];
        if ([ret integerValue]!=0) {
            success(NO);
            return ;
        }
        success(YES);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        success(NO);
    }];
}

@end
