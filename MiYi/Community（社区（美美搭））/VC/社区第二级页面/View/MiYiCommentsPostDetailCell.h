//
//  MiYiCommentsPostDetailCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/21.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiPostDatailsModel.h"
@protocol MiYiCommentsPostDetailDelegate <NSObject>

-(void)pushUserVC:(id)obj;

@end


@interface MiYiCommentsPostDetailCell : UITableViewCell

@property (nonatomic ,weak) MiYiPostDatailsModel *postDatailsModel;

@property (nonatomic ,weak) id<MiYiCommentsPostDetailDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier;
@end
