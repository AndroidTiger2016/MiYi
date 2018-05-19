//
//  MiYiPostDatailsModel.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/9.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiYiOwnerModel.h"
@interface MiYiPostDatailsModel : NSObject

@property (nonatomic ,copy) NSString *comment_id;

@property (nonatomic ,copy) NSString *content;

@property (nonatomic ,strong) NSArray *images;

@property (nonatomic ,copy) NSString *location;

@property (nonatomic ,strong)MiYiOwnerModel *owner;

@property (nonatomic ,copy) NSString *time;
/**
 *  内容文本动态高度
 */
@property(nonatomic,readonly)CGFloat cellTextHeight;

@property (nonatomic ,assign) NSInteger like_count;

@property (nonatomic ,assign) BOOL is_like;

/*{
    data =     {
        comment =         (
                           {
                               available = 0;
                               "comment_id" = 115;
                               content = "\U8fd9\U6b3e\U5f88\U50cf,\U4e5f\U5f88\U597d\U770b";
                               images =                 (
                                                         {
                                                             bounds = "";
                                                             "img_url" = "http://img11.360buyimg.com/n0/jfs/t151/47/1710020495/273307/983c965f/53b65927N66613329.jpg";
                                                             tags =                         (
                                                                                             {
                                                                                             }
                                                                                             );
                                                         }
                                                         );
                               "is_like" = 0;
                               location = "";
                               owner =                 {
                                   avatar = "http://f.hiphotos.baidu.com/image/pic/item/3b87e950352ac65c353065dbfef2b21193138a64.jpg";
                                   "exp_point" = 0;
                                   nickname = Iris;
                                   "reward_point" = 0;
                                   summary = "";
                                   "user_id" = 29;
                               };
                               time = "1442541480.04";
                               "topic_id" = 287;
                           }
                           );
    };
    random = 39;
    ret = 0;
    time = "1442929978.707624";
}*/
@end
