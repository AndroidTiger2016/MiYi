//
//  MiYiFansCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/16.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiOwnerModel.h"
@interface MiYiFansCell : UITableViewCell

@property (nonatomic ,strong) MiYiOwnerModel *ownerModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
