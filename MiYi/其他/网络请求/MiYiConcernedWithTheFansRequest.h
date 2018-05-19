//
//  MiYiConcernedWithTheFansRequest.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/1.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MiYiConcernedWithTheFans_type)
{
    MiYi_Concern = 1,//关注
    MiYi_ConcernList,//关注列表
    MiYi_Fans//粉丝列表
    
};

/********************************/

typedef void (^MiYiHttpRequestBOOL)(BOOL success);

typedef void (^MiYiHttpRequestJson)(id json);

typedef void (^MiYiHttpRequestError)(NSError *error);

@interface MiYiConcernedWithTheFansRequest : NSObject

/**
 *  关注某个人
 *
 *  @param uid        <#uid description#>
 *  @param blockJson  <#blockJson description#>
 *  @param blockerror <#blockerror description#>
 */
+(void)concernedWithTheFansUserUID:(NSString *)uid json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockerror;
/**
 *  关注列表  现在需求是只能查看自己的关注列表
 *
 *  @param page       <#page description#>
 *  @param blockJson  <#blockJson description#>
 *  @param blockerror <#blockerror description#>
 */
+(void)concernedWithTheFansWatchlist:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockerror;
/**
 *  粉丝列表  现在需求是只能查看自己的粉丝列表
 *
 *  @param page       <#page description#>
 *  @param blockJson  <#blockJson description#>
 *  @param blockerror <#blockerror description#>
 */
+(void)concernedWithTheFansFans:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockerror;
@end
