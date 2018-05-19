//
//  MiYiOwnerModel.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MiYiOwnerModel : NSObject
/**
 *  头像
 */
@property (nonatomic ,copy) NSString *avatar;
/**
 *  经验值
 */
@property (nonatomic ,copy) NSString *exp_point;
/**
 *  昵称
 */
@property (nonatomic ,copy) NSString *nickname;
/**
 *  蜜币
 */
@property (nonatomic ,copy) NSString *reward_point;
/**
 *  简介
 */
@property (nonatomic ,copy) NSString *summary;
/**
 * 用户ID
 */
@property (nonatomic ,copy) NSString *user_id;
/**
 *  1是相互关注  0是单方面
 */
@property (nonatomic ,copy) NSString *is_mutual;
@end



@interface MiYiPostsImageSModel : NSObject
/**
 *  图片
 */
@property (nonatomic ,copy) id img_url;
/**
 *  框选的位子
 */
@property (nonatomic ,copy) NSString *bounds;
/**
 *  标签数组
 */
@property (nonatomic ,strong) NSMutableArray  *tags;
/**
 *  图片size
 */
@property (nonatomic ,copy) NSString *size;

@end


@interface MiYiPostsImageTagIdsModel : NSObject
/**
 *  坐标
 */
@property (nonatomic ,copy) NSString *tag_position;
/**
 *  内容
 */
@property (nonatomic ,copy) NSString *tag_content;
/**
 *  样式
 */
@property (nonatomic ,copy) NSString *tag_style;

@end


