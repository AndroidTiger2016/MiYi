//
//  MiYiBaseCommunityModel.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/31.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiYiOwnerModel.h"
@interface MiYiBaseCommunityModel : NSObject
/**
 *  是否违规
 */
@property (nonatomic ,copy) NSString *available;
/**
 *  用户信息
 */
@property (nonatomic ,strong) MiYiOwnerModel *owner;
/**
 *  1 已经关注  0没有关注
 */
@property (nonatomic ,copy) NSString *is_following;
/**
 *  衣服描述
 */
@property (nonatomic ,copy) NSString *content;
/**
 *  时间
 */
@property (nonatomic ,copy) NSString *time;
/**
 *  定位
 */
@property (nonatomic ,copy) NSString *location;
/**
 *  赞 数
 */
@property (nonatomic ,copy) NSString *like_count;
/**
 *  评论个数
 */
@property (nonatomic ,copy) NSString *comment_count;
/**
 *  图片数组 MiYiPostsImageSModel
 */
@property (nonatomic ,strong) NSMutableArray *images;
/**
 *  帖子ID
 */
@property (nonatomic ,copy) NSString *topic_id;
/**
 *  1 已赞  0未赞
 */
@property (nonatomic ,copy) NSString *is_like;
/**
 *  推荐
 */
@property (nonatomic ,copy ) NSString *recommend;
/**
 *  帖子类型
 */
@property (nonatomic ,copy) NSString *topic_type;
/**
 *  文本高度
 */
@property(nonatomic,readonly)CGFloat cellTextHeight;


/*{
 data =     {
 forum =         (
 {
 available = 0;
 "comment_count" = 1;
 content = "";
 images =                 (
 {
 bounds = "";
 "img_url" = "http://www.miyifashion.com/user_upload/3/dfa92b52b885d1863c32ce31ed58b30620150918113922d.jpg";
 tags =                         (
 {
 "tag_content" = "\U5373\U4f7f";
 "tag_position" = "482.031250,571.093750";
 "tag_style" = 0;
 }
 );
 }
 );
 "is_following" = 0;
 "is_like" = 0;
 "like_count" = 0;
 location = "";
 owner =                 {
 avatar = "http://www.miyifashion.com/user_upload/3/727dabb0a554ab1aa5f6990c1b07653220150828171718a.jpg";
 "exp_point" = 0;
 nickname = "\U9f99\U9f99";
 "reward_point" = 0;
 summary = "";
 "user_id" = 3;
 };
 recommend = "25239,25240,25241,5,25242,57,124,18,3,25243,25244,16,4,1,60,20,59,25245";
 time = "1442547562.42";
 "topic_id" = 289;
 }
 random = 55;
 ret = 0;
 time = "1442917709.497151";
 }
 */
@end
