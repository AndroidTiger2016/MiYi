//
//  MiYiRecommendModel.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiYiRecommendModel : NSObject
/**
 *  评论
 */
@property (nonatomic ,copy) NSString *comment_count;//
/**
 *  收藏
 */
@property (nonatomic ,copy) NSString *like_count;
/**
 *  是否收藏 0未收藏    1收藏
 */
@property (nonatomic ,copy) NSString *is_like;
/**
 *  1  人民币   2  美元
 */
@property (nonatomic ,copy) NSString *currency;//
/**
 *  购买的链接
 */
@property (nonatomic ,copy) NSString *from_url;//购买的链接
/**
 *  id
 */
@property (nonatomic ,copy) NSString *ID;//id
/**
 *  显示图片
 */
@property (nonatomic ,copy) NSString *path_url;//显示图片
/**
 *  价格
 */
@property (nonatomic ,copy) NSString *price;//价格
/**
 *  京东 1  亚马逊2   美丽说3  未知-1 来源
 */
@property (nonatomic ,copy) NSString *source;// 京东 1  亚马逊2   美丽说3  未知-1 来源
/**
 *  标题
 */
@property (nonatomic ,copy) NSString *title;//标题

/*
 recommend =         (
 
 {
 
 "comment_count" = 0; //评论
 
 currency = 1; 1  人民币   2  美元
 
 "from_url" = "http://item.jd.com/1257684042.html?bdkhd_source=bdkhd1";  //购买链接
 
 id = 77; //
 
 "path_url" = "http://img12.360buyimg.com/n0/jfs/t226/196/595303426/350208/9a3532f/53edd00aNb96f52f1.jpg"; //显示图片
 
 price = 79; //价格
 
 "seed_score" = "0.890528";
 
 source = 1; // 京东 1  亚马逊2   美丽说3  未知-1
 
 title = "\U82b1\U56fe+\U79cb\U88c5\U65b0\U6b3e\U4e2d\U8001\U5e74\U5973\U88c5\U5988\U5988\U88c5\U4fee\U8eab\U5706\U9886\U7ad6\U6761\U7eb9\U5047\U4e24\U4ef6\U957f\U8896T\U6064+\U84dd\U8272+XXL+\U5efa\U8bae115-125\U65a4";
 
 }
 
 */
@end
