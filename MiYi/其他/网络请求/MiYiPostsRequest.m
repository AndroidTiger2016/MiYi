//
//  MiYiPostsRequest.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/13.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPostsRequest.h"
#import "MiYiRequestManager.h"
#import "MiYiUserSession.h"
#import "MiYiNavViewController.h"
#import "MiYiSideslipVC.h"
#import "MiYiLoginVC.h"
#import "MBProgressHUD+YXL.h"
@interface MiYiPostsRequest ()

@property (nonatomic ,assign) NSString *topic_Type_String;

@end

@implementation MiYiPostsRequest


+(NSString *)topic_Type_String:(NSString *)topic_Type_String
{
    
    if([topic_Type_String integerValue] ==MiYiTopic_SHW)
    {
        return  @"SHW";
    }else if ([topic_Type_String integerValue] ==MiYiTopic_FND)
    {
        return  @"FND";
    }else if ([topic_Type_String integerValue] ==MiYiTopic_MTH)
    {
        return  @"MTH";
    }else if ([topic_Type_String integerValue] ==MiYiTopic_FAQ)
    {
        return  @"FAQ";
    }
    return @"";
}

+(void)topicListTopicHomePage:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:page forKey:@"page"];
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/home" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];
    
}



+(void)requestType:(MiYiRequest_type)type topic:(MiYiTopic_type)topic_type topicUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    if (MiYiRequest_TopicList ==type) {
        [tempDic setObject:@"0" forKey:@"to"];
        NSString * topic_type_string =[self topic_Type_String:[NSString stringWithFormat:@"%ld",(long)topic_type]];
        [tempDic setObject:topic_type_string forKey:@"tt"];
        [tempDic setObject:page forKey:@"tp"];
    }else if(MiYiRequest_FavoriteTopics ==type)
    {
        [tempDic setObject:uid forKey:@"to"];
        [tempDic setObject:page forKey:@"tp"];
    }else if (MiYiRelease_GetReviews ==type)
    {
        [tempDic setObject:uid forKey:@"topic_id"];
        [tempDic setObject:page forKey:@"page"];
    }
    
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];
    
    
    
}

+(void)topicListTopic:(MiYiTopic_type)topic_type topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    MiYiRequest_type type =MiYiRequest_TopicList;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:@"0" forKey:@"to"];
    NSString * topic_type_string =[self topic_Type_String:[NSString stringWithFormat:@"%ld",(long)topic_type]];
    [tempDic setObject:topic_type_string forKey:@"tt"];
    [tempDic setObject:page forKey:@"tp"];
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];   
}


+(void)topicListUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    MiYiRequest_type type =MiYiRequest_TopicList;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:uid forKey:@"to"];
    [tempDic setObject:@"" forKey:@"tt"];
    [tempDic setObject:page forKey:@"tp"];
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];
}

+(void)favoriteTopicsTopicUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    MiYiRequest_type type =MiYiRequest_FavoriteTopics;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:uid forKey:@"to"];
    [tempDic setObject:page forKey:@"tp"];
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];
}


+(void)getReviewsTopicUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random                    = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    MiYiRequest_type type =MiYiRelease_GetReviews;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"request_type"];
    [tempDic setObject:uid forKey:@"topic_id"];
    [tempDic setObject:page forKey:@"page"];
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        blockJson(json);
    } failure:^(NSError *error) {
        blockError(error);
    }];

}




+(void)releaseData:(id)data topicType:(MiYiReleaseTopic_type)topicType success:(MiYiHttpRequestBOOL)success
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random = arc4random() % 100;
    
    NSString * topic_type_string =[self topic_Type_String:[NSString stringWithFormat:@"%ld",(long)topicType]];
    [tempDic setObject:topic_type_string forKey:@"topic_type"];
    
    [tempDic setValue:data forKey:@"data"];
    
    MiYiRelease_type type =MiYi_Release;
    
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type]forKey:@"request_type"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
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


+(void)likeTopic_id:(NSString *)topic_id success:(MiYiHttpRequestBOOL)success
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
    [tempDic setValue:topic_id forKey:@"topic_id"];
    MiYiRelease_type type =MiYi_Like;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type]forKey:@"request_type"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        NSLog(@"json%@",json);
        NSNumber *ret  = json[@"ret"];
        BOOL is_like =[json[@"data"][@"is_like"] boolValue];
        if ([ret integerValue]!=0) {
            [MBProgressHUD showError:@"操作失败"];
            return ;
        }
        success(is_like);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"操作失败"];
    }];
    
}

+(void)commentLike:(NSString *)comment_id success:(MiYiHttpRequestBOOL)success
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
    [tempDic setValue:comment_id forKey:@"comment_id"];
    MiYiRelease_type type =MiYi_CommentLike;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type]forKey:@"request_type"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        NSLog(@"json%@",json);
        NSNumber *ret  = json[@"ret"];
        BOOL is_like =[json[@"data"][@"is_like"] boolValue];
        if ([ret integerValue]!=0) {
            [MBProgressHUD showError:@"操作失败"];
            return ;
        }
        success(is_like);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"操作失败"];
    }];
}


+(void)commentData:(id)data topic_id:(NSString *)topic_id success:(MiYiHttpRequestBOOL)success
{
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random = arc4random() % 100;
    [tempDic setValue:topic_id forKey:@"topic_id"];
    [tempDic setValue:data forKey:@"data"];
    MiYiRelease_type type =MiYi_Comment;
    [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)type]forKey:@"request_type"];
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
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

+(void)recommend:(NSString *)recommend_listID json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    int random = arc4random() % 100;
    [tempDic setObject:[NSString stringWithFormat:@"%d",random] forKey:@"random"];
    [tempDic setObject:recommend_listID forKey:@"recommend_list"];
    [tempDic setObject:@"9" forKey:@"request_type"];
    if ([MiYiUserSession shared].session !=nil) {
        [tempDic setObject:[MiYiUserSession shared].session.session forKey:@"session"];
    }
    
    [MiYiRequestManager postMiYi_APIWithURL:@"miyi_api/topic" params:tempDic success:^(id json) {
        NSLog(@"json%@",json);
        NSNumber *ret  = json[@"ret"];
        if ([ret integerValue]!=0) {
            return ;
        }
        blockJson(json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
