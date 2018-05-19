//
//  MiYiUserRequest.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/4.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MiYiSession;
typedef NS_ENUM(NSInteger, MiYiLoginType)
{
    MiYiLoginPhone,
    MiYiLoginQQ,
    MiYiLoginWeiBo,
    MiYiLoginWeChat
};

typedef NS_ENUM(NSInteger, MiYiUserRequest_type)
{
    MiYiUserRequest_typeName =1,//修改用户昵称
    MiYiUserRequest_typeUserIcon,//修改用户头像
    MiYiUserRequest_typeSex,//修改性别
    MiYiUserRequest_typeIntroduction,//修改简介
    MiYiUserRequest_typeUserLocate,//用户城市
    MiYiUserRequest_typeUserStyle//修改用户风格
    
};

typedef void (^MiYiHttpRequestBOOL)(BOOL success);

typedef void (^MiYiHttpRequestJson)(id json);

typedef void (^MiYiHttpRequestError)(NSError *error);

@interface MiYiUserRequest : NSObject

/**
 *  登录
 *
 *  @param phone 手机号
 *  @param blockJson 网络请求返回的数据
 *  @param blockError 网络请求失败信息
 */
+(void)loginWithPhoneNumber:(NSString *)phone
                       json:(MiYiHttpRequestJson)blockJson
                      error:(MiYiHttpRequestError)blockError;

/**
 *  第三方登录
 *
 *  @param un         传第三方登录返回的ID（UID或OPENID）
 *  @param lm         第三方登录类型
 *  @param blockJson 网络请求返回的数据
 *  @param blockError 网络请求失败信息
 */
+(void)loginWithUid:(NSString *)un
                thirdPartyType:(MiYiLoginType )lm
                json:(MiYiHttpRequestJson)blockJson
                error:(MiYiHttpRequestError)blockError;

/**
 *  刷新Session   每次启动App   有老session就会调用刷新
 *
 *  @param session    传入session
 *  @param blockJson
 *  @param blockError 
 */
+ (void)sessionReload:(MiYiSession *)session json:(MiYiHttpRequestBOOL)blockJson error:(MiYiHttpRequestError)blockError;

/**
 *  获取用户信息
 *
 *  @param userId 传入用户UID
 */
+ (void)userInfoId:(NSString *)userId json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;

/**
 *  修改用户信息
 *
 *  @param type     修改的类型
 *  @param contents 修改的内容
 *  @param success  修改是否成功
 */
+ (void)modifyInformationType:(MiYiUserRequest_type)type Contents:(NSString *)contents Success:(MiYiHttpRequestBOOL)success;

/**
 *  上传图片
 *
 *  @param image   上传一张图片
 *  @param success 成功返回一张图片的URL   失败则返回@NO
 */
+ (void)uploadImage:(UIImage *)image blockJson:(MiYiHttpRequestJson)blockJson;

@end
