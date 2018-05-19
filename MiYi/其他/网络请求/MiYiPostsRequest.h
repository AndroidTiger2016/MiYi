//
//  MiYiPostsRequest.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/13.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  获取
 */
/********************************/
typedef NS_ENUM(NSInteger, MiYiRequest_type)
{
   MiYiRequest_TopicList = 5,//获取主题列表
   MiYiRequest_FavoriteTopics,//获取收藏主题
   MiYiRelease_Topic,//获取单个主题
   MiYiRelease_GetReviews//获取评论
    

};

typedef NS_ENUM(NSInteger, MiYiTopic_type)
{
    MiYiTopic_SHW,//美搭秀
    MiYiTopic_FND,//求同款
    MiYiTopic_MTH,//求搭配
    MiYiTopic_FAQ//怎么穿

};
/********************************/


/**
 *  发布
 */
/********************************/

typedef NS_ENUM(NSInteger, MiYiReleaseTopic_type)
{
    MiYi_SHW,//美搭秀
    MiYi_FND,//求同款
    MiYi_MTH,//求搭配
    MiYi_FAQ//怎么穿

};

typedef NS_ENUM(NSInteger, MiYiRelease_type)
{
    MiYi_Release = 1,//发布
    MiYi_Like,//收藏
    MiYi_Comment,//评论
    MiYi_CommentLike=10
    

};
/********************************/

typedef void (^MiYiHttpRequestBOOL)(BOOL success);

typedef void (^MiYiHttpRequestJson)(id json);

typedef void (^MiYiHttpRequestError)(NSError *error);

@interface MiYiPostsRequest : NSObject

/**
 *  首页的帖子获取
 *
 *  @param page
 *  @param blockJson
 *  @param blockError
 */
+(void)topicListTopicHomePage:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;

/**
 *  获取社区帖子列表
 *
 *  @param topic_type 获取的帖子类型
 *  @param page       页数
 *  @param blockJson
 *  @param blockError
 */
+(void)topicListTopic:(MiYiTopic_type)topic_type topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;

/**
 *  获取个人发布所有帖子
 *
 *  @param uid        用户的ID
 *  @param page       page
 *  @param blockJson
 *  @param blockError
 */
+(void)topicListUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;

/**
 *  获取个人收藏 = 赞列表帖子
 *
 *  @param uid        用户UID
 *  @param page       页数
 *  @param blockJson
 *  @param blockError
 */
+(void)favoriteTopicsTopicUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;
/**
 *  获取帖子评论
 *
 *  @param uid        帖子id
 *  @param page       页数
 *  @param blockJson
 *  @param blockError
 */
+(void)getReviewsTopicUserUid:(NSString *)uid topic_page:(NSString *)page json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;

/**
 *  发布帖子
 *
 *  @param data      发布帖子转json格式 注：(如果同级当中没有数据必须给空字符串或数组)
 *  @param topicType 发帖的类型
 *  @param success   发帖YES成功
 */
+(void)releaseData:(id)data topicType:(MiYiReleaseTopic_type)topicType success:(MiYiHttpRequestBOOL)success;
/**
 *  收藏 = 赞
 *
 *  @param topic_id 帖子
 *  @param success
 */
+(void)likeTopic_id:(NSString *)topic_id success:(MiYiHttpRequestBOOL)success;
/**
 *  评论赞
 *
 *  @param comment_id 评论ID
 *  @param success
 */
+(void)commentLike:(NSString *)comment_id success:(MiYiHttpRequestBOOL)success;
/**
 *  评论
 *
 *  @param data      和发布帖子转json格式一样 注：(如果同级当中没有数据必须给空字符串或数组)
 *  @param topic_id 帖子ID
 *  @param success
 */
+(void)commentData:(id)data topic_id:(NSString *)topic_id success:(MiYiHttpRequestBOOL)success;

/**
 *  衣服推荐列表
 *
 *  @param recommend_listID 帖子ID
 *  @param blockJson        <#blockJson description#>
 *  @param blockError       <#blockError description#>
 */
+(void)recommend:(NSString *)recommend_listID json:(MiYiHttpRequestJson)blockJson error:(MiYiHttpRequestError)blockError;

+(NSString *)topic_Type_String:(NSString *)topic_Type_String;



/*社区的帖子
 {
 data =     {
 forum =         (
 {
 available = 0;
 "comment_count" = 1;
 content = "";
 images =                 (
 {
 bounds = "125.000000,125.000000,750.000000,750.000000";
 "img_url" = "http://www.miyifashion.com/user_upload/3/dfa92b52b885d1863c32ce31ed58b30620150918182345s.jpg";
 tags =                         (
 {
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
 recommend = "130,131,33674,132,133,85947,85948,134,135,85949,85950,137,85951,85952,85953,138,139,85954";
 time = "1442571825.42";
 "topic_id" = 290;
 "topic_type" = FND;
 },
 );
 };
 random = 80;
 ret = 0;
 time = "1442736890.233748";
 }
 */



/*首页的帖子
 {
 data =     {
 home =         (
 {
 available = 0;
 "comment_count" = 0;
 content = "";
 images =                 (
 {
 bounds = "72.625000,91.000000,435.750000,546.000000";
 "img_url" = "http://www.miyifashion.com/user_upload/1/18c9d8eed5db3ba1a17d03b34f63d3eb.jpg";
 size = "581.000000,728.000000";
 tags =                         (
 {
 "tag_content" = 2B;
 "tag_position" = "330.443750,348.113281";
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
 avatar = "";
 "exp_point" = 0;
 nickname = 1;
 "reward_point" = 0;
 summary = "";
 "user_id" = 1;
 };
 recommend = "";
 time = "1443150167.62";
 "topic_id" = 24;
 "topic_type" = FND;
 }
 );
 };
 random = 15;
 ret = 0;
 time = "1443150341.037";
 }
 */
@end
