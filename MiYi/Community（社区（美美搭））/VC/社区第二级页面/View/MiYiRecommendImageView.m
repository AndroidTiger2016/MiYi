//
//  MiYiRecommendImageView.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiRecommendImageView.h"
#import <UIImageView+WebCache.h>

@interface MiYiRecommendImageView ()
{
    UIView *viewBelow;
    UILabel *labelMoney;
    UIImageView *imageViewBrand;
}

@end

@implementation MiYiRecommendImageView

-(instancetype)init
{
    self =[super init];
    if (self) {
        viewBelow = [self getViewBelow];
        [self addSubview:viewBelow];
        [viewBelow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@20);
        }];
        
        labelMoney = [self getLabelMoney];
        [viewBelow addSubview:labelMoney];
        [labelMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewBelow);
            make.left.equalTo(@5);
            make.width.greaterThanOrEqualTo(@30);
            make.height.equalTo(@20);
        }];
        
        imageViewBrand = [UIImageView new];
        imageViewBrand.image =[UIImage imageNamed:@"Unknown"];
        [imageViewBrand sizeToFit];
        [viewBelow addSubview:imageViewBrand];
        [imageViewBrand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewBelow);
            make.right.equalTo(viewBelow.mas_right).offset(-5);
            make.size.mas_equalTo(imageViewBrand.image.size);
        }];
        
    }
    return self;
}


-(void)setModel:(MiYiRecommendModel *)model{
    _model =model;
    
    [self initUI];
}

-(void)initUI{
    [self sd_setImageWithURL:[NSURL URLWithString:_model.path_url] placeholderImage:nil];

    NSString *moneyText=nil;
    if ([_model.currency isEqualToString:@"1"]) {
        moneyText =[NSString stringWithFormat:@"￥%@",_model.price];
        
    }else if ([_model.currency isEqualToString:@"2"])
    {
        moneyText =[NSString stringWithFormat:@"$%@",_model.price];
    }
    labelMoney.text=moneyText;
    
    UIImage *brandImage =nil;
    if ([_model.source isEqualToString:@"1"]) {
        brandImage =[UIImage imageNamed:@"recommendJD"];
    }else if ([_model.source isEqualToString:@"2"])
    {
        brandImage =[UIImage imageNamed:@"recommendYMX"];
    }else if ([_model.source isEqualToString:@"3"])
    {
        brandImage =[UIImage imageNamed:@"recommendMLS"];
    }else if ([_model.source isEqualToString:@"-1"])
    {
        brandImage =[UIImage imageNamed:@"Unknown"];
    }
    imageViewBrand.image=brandImage;
}

-(UIView *)getViewBelow{
    UIView *view = [UIView new];
    view.backgroundColor=UIColorRGBA(255, 255, 255, 0.7);
    return view;
}
-(UILabel *)getLabelMoney{
    UILabel *label =[UILabel new];
    label.font=Font(11);
    label.textAlignment=NSTextAlignmentLeft;
    label.textColor=[UIColor blackColor];
    return label;
}
@end
