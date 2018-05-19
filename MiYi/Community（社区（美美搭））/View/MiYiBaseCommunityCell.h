//
//  MiYiBaseCommunityCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/31.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiBaseCommunityModel.h"

@protocol MiYiBaseCommunityDelegate <NSObject>

-(void)pushUserVC:(id)obj;

@end

@interface MiYiBaseCommunityCell : UITableViewCell
@property (nonatomic ,strong) MiYiBaseCommunityModel *postDetailsModel;
/**
 *  是否显示选择图片切换控件 MiYiDynamicScrollView 默认NO
 */
@property (nonatomic ,assign) BOOL isSelectImage;

@property (nonatomic ,weak) UIViewController *viewController;

@property (nonatomic ,weak) id<MiYiBaseCommunityDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier;
@end
