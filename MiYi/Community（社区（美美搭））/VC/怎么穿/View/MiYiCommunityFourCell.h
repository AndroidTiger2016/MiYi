//
//  MiYiCommunityFourCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/7.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MiYiBaseCommunityModel;
@interface MiYiCommunityFourCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic ,strong) MiYiBaseCommunityModel *postDetailsModel;

@end
