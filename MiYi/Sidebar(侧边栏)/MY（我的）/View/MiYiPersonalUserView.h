//
//  MiYiPersonalUserView.h
//  MiYi
//
//  Created by 叶星龙 on 15/10/8.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiYiUser.h"

@interface MiYiPersonalUserView : UIView

@property (nonatomic, strong) UIImageView *imageBG;

@property (nonatomic, assign)BOOL isOfOthers;

@property (nonatomic ,strong) NSString *uid;


-(void)userData:(MiYiAccount *)user;
@end
