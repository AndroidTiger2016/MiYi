//
//  MiYiLabelImageView.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/9.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiLabelImageView.h"

@implementation MiYiLabelImageView

-(id)init{
    self =[super init];
    if (self) {
        _imageLabel =[UILabel new];
        _imageLabel.font=Font(11);
        _imageLabel.textAlignment=NSTextAlignmentCenter;
        _imageLabel.textColor=[UIColor lightGrayColor];
        [self addSubview:_imageLabel];
        [_imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 4, 0, -4));
        }];
    }
    return self;
}

@end
