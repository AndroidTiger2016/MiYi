//
//  MiYiWardrobeRequest.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/12.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, request_type)
{
    MiYiWardrobeWatchList=1,//收藏
    MiYiWardrobeList,//衣橱列表
    MiYiWardrobeComments//评论
};


typedef void (^MiYiHttpRequestBOOL)(BOOL success);

typedef void (^MiYiHttpRequestJson)(id json);

typedef void (^MiYiHttpRequestError)(NSError *error);

@interface MiYiWardrobeRequest : NSObject

/**
 *  商品衣橱收藏
 *
 *  @param wardrobeID
 *  @param success
 */
+(void)wardrobeWatchList:(NSString *)wardrobeID  success:(MiYiHttpRequestBOOL)success;
/**
 *  衣橱列表
 *
 *  @param ownerID 用户ID
 *  @param page    page
 *  @param json    json description
 *  @param error   error description
 */
+(void)wardrobeList:(NSString *)ownerID  page:(NSString *)page blockJson:(MiYiHttpRequestJson)json blockError:(MiYiHttpRequestError)error;
/**
 *  商品评论发送
 *
 *  @param data
 *  @param goods_id
 *  @param success
 */
+(void)wardrobeCommentData:(id)data goods_id:(NSString *)goods_id success:(MiYiHttpRequestBOOL)success;
@end
