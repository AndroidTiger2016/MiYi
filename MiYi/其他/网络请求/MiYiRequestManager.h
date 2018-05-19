//
//  MiYiRequestManager.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/3.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class formData;

@interface MiYiRequestManager : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)paramets success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个GET请求 带有自己api拼接
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getMiYi_APIWithURL:(NSString *)url params:(NSDictionary *)paramets success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个POST请求 带有自己api拼接
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postMiYi_APIWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  发送一个带有文件的POST请求 带有自己api拼接
 *
 *  @param url      请求路径
 *  @param params   请求参数
 *  @param formData 带有文件类型
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
+ (void)postMiYi_APIWithURL:(NSString *)url params:(NSDictionary *)params formData:(formData *)formData success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end

@interface formData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData       *data;

/**
 *  参数名
 */
@property (nonatomic, copy  ) NSString     *name;

/**
 *  文件名
 */
@property (nonatomic, copy  ) NSString     *filename;

/**
 *  文件类型 image/png
 */
@property (nonatomic, copy  ) NSString     *mimeType;
@end
