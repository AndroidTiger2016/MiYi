//
//  MiYiPhotoLibraryHeader.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiYiPhotoLibraryHeader : UIControl
@property (nonatomic, strong) NSString * title;

@property (nonatomic, getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
