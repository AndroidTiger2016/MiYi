//
//  MiYiUserSession.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/4.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MiYiSession;
@interface MiYiUserSession : NSObject

/**
 *  实例化
 */
+ (MiYiUserSession *)shared;
/**
 *  保存
 */
- (void)saveSession:(MiYiSession *)session;
/**
 *  取出数据
 *
 *  @return session
 */
- (MiYiSession *)session;

@end

@interface MiYiSession : NSObject
/**
 *  符
 */
@property (nonatomic ,copy) NSString *session;
/**
 *  用户ID
 */
@property (nonatomic ,copy) NSString *uid;
@end
