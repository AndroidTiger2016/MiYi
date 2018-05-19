//
//  MiYiUserStyleCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/10/8.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiUser.h"

@protocol MiYiUserStyleCellDelegate <NSObject>

-(void)stylePopBlockReloadData;

@end

@interface MiYiUserStyleCell : UITableViewCell

@property (nonatomic, assign)BOOL isOfOthers;

@property (nonatomic ,weak) UIViewController *viewController;

@property (nonatomic ,strong) MiYiAccount *userAccount;

@property (nonatomic ,weak) id <MiYiUserStyleCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier;

+(CGFloat)styleHeight:(NSString *)string;
@end
