//
//  MiYiLocationCell.h
//  MiYi
//
//  Created by 叶星龙 on 15/9/7.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiYiLocationCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *celsius;
@property (weak, nonatomic) IBOutlet UILabel *weatherIn;
@property (weak, nonatomic) IBOutlet UILabel *theDate;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitylndlcator;

@end
