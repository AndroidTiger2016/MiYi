//
//  MiYiMultiTheStyleCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MiYiCellItem;
@interface MiYiMultiTheStyleCell : UITableViewCell

@property (strong, nonatomic) MiYiCellItem    *item;
@property (nonatomic, strong) NSIndexPath     *indexPath;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
