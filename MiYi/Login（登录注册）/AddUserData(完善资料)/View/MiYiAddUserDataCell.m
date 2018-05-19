//
//  MiYiAddUserDataCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/12.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiAddUserDataCell.h"

@interface MiYiAddUserDataCell ()
{
    UIView *viewSelected;
}
@end

@implementation MiYiAddUserDataCell
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    _imageContents = [UIImageView new];
    _imageContents.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageContents];
    [_imageContents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
    
    _labelTitle = [self getLabelTitle];
    [self.contentView addSubview:_labelTitle];
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageContents.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@30);
        make.height.equalTo(@15);
    }];
    
    viewSelected = [UIView new];
    viewSelected.hidden=YES;
    viewSelected.backgroundColor=UIColorRGBA(0, 0, 0, 0.3);
    [self.contentView addSubview:viewSelected];
    [viewSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
    
    UIImageView *imageSelected =[UIImageView new];
    imageSelected.image=[UIImage imageNamed:@"choose"];
    [viewSelected addSubview:imageSelected];
    [imageSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@3);
        make.right.equalTo(@(-3));
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    
}

- (void)setPhotoSelect:(BOOL)photoSelect
{
    if (_photoSelect == photoSelect) {
        return;
    }
    _photoSelect = photoSelect;
    viewSelected.hidden =!_photoSelect;
}





-(UILabel *)getLabelTitle{
    UILabel *label =[UILabel new];
    label.font=Font(15);
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor darkGrayColor];
    return label;
}
@end
