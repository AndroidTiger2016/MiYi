//
//  MiYiUserWardrobeCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/10/10.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiUser.h"
@interface MiYiUserWardrobeCell : UITableViewCell

@property (nonatomic ,weak) UIViewController *viewController;

@property (nonatomic, assign)BOOL isOfOthers;

@property (nonatomic ,strong) NSMutableArray *arrayWardrobe;

@property (nonatomic ,strong) MiYiAccount *userAccount;

@property (nonatomic ,strong) NSString *uid;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier;


@end
