//
//  MiYiFansCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/16.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiFansCell.h"
#import <UIImageView+WebCache.h>
#import "MiYiConcernedWithTheFansRequest.h"
#import "MBProgressHUD+YXL.h"
@interface MiYiFansCell ()

@property (nonatomic ,weak) UIImageView *userImage;

@property (nonatomic ,weak) UILabel *userName;

@property (nonatomic ,weak) UIButton *exp_point;

@property (nonatomic ,weak) UILabel *summary;

@property (nonatomic ,weak) UIButton *concern;
@end
@implementation MiYiFansCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *userImage =[[UIImageView alloc]init];
        _userImage=userImage;
        UILabel *userName =[[UILabel alloc]init];
        _userName=userName;
        UIButton *exp_point =[[UIButton alloc]init];
        _exp_point=exp_point;
        UILabel *summary =[[UILabel alloc]init];
        _summary=summary;
        UIButton *concern =[[UIButton alloc]init];
        _concern=concern;
        
        [self.contentView addSubview:userImage];
        [self.contentView addSubview:userName];
        [self.contentView addSubview:exp_point];
        [self.contentView addSubview:summary];
        [self.contentView addSubview:concern];
   
        
        [_concern addTarget:self action:@selector(concernClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)concernClick:(UIButton *)btn
{
    
    [MiYiConcernedWithTheFansRequest concernedWithTheFansUserUID:_ownerModel.user_id json:^(id json) {
        NSNumber *ret  = json[@"ret"];
        if ([ret integerValue]!=0) {
            return ;
        }
        BOOL isBOOL =[json[@"data"][@"is_mutual"] boolValue];
        if (!isBOOL) {
            [_concern setImage:[UIImage imageNamed:@"addConcern"] forState:UIControlStateNormal];
            _ownerModel.is_mutual=@"0";
            _concern.selected=NO;
            [MBProgressHUD showSuccess:@"取消了互相关注"];
        }else
        {
            _ownerModel.is_mutual=@"1";
            [_concern setImage:[UIImage imageNamed:@"mutualConcern"] forState:UIControlStateSelected];
             _concern.selected=YES;
            [MBProgressHUD showSuccess:@"成功互相关注"];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)setOwnerModel:(MiYiOwnerModel *)ownerModel
{
    _ownerModel=ownerModel;
    [self dataInit];
    
}

-(void)dataInit
{
    [_userImage sd_setImageWithURL:[NSURL URLWithString:_ownerModel.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    _userImage.frame  =(CGRect){15,5,40,40};
    _userImage.layer.masksToBounds=YES;
    _userImage.layer.cornerRadius=40/2;
    
    _userName.text=_ownerModel.nickname;
    _userName.font=Font(13);
    CGSize userNameSzie =[_ownerModel.nickname sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(13),NSFontAttributeName, nil]];
    _userName.frame=(CGRect){{CGRectGetMaxX(_userImage.frame)+10,CGOriginY(_userImage.frame)},userNameSzie};
    
    //    Pentacle
    NSString *exp_pointText =[NSString stringWithFormat:@" %@",_ownerModel.exp_point];
    [_exp_point setTitle:exp_pointText forState:UIControlStateNormal];
    [_exp_point setImage:[UIImage imageNamed:@"Pentacle"] forState:UIControlStateNormal];
    _exp_point.titleLabel.font=Font(10);
    [_exp_point sizeToFit];
    [_exp_point setTitleColor:UIColorFromRGB_HEX(0X9B9B9B) forState:UIControlStateNormal];
    _exp_point.frame =(CGRect){{CGRectGetMaxX(_userName.frame)+10,CGOriginY(_userName.frame)+(CGHeight(_userName.frame)/2-_exp_point.frame.size.height/2)},_exp_point.frame.size};
    
    _summary.text=_ownerModel.summary;
    _summary.font=Font(13);
    _summary.textColor=UIColorFromRGB_HEX(0X9B9B9B);
    [_summary sizeToFit];
    _summary.frame=(CGRect){{CGRectGetMaxX(_userImage.frame)+10,CGRectGetMaxY(_userImage.frame)/2},_summary.frame.size};
    
//    addConcern@2x
//    mutualConcern@2x
    if ([_ownerModel.is_mutual isEqualToString:@"1"]) {
        [_concern setImage:[UIImage imageNamed:@"mutualConcern"] forState:UIControlStateSelected];
        _concern.selected=YES;
    }else
    {
        [_concern setImage:[UIImage imageNamed:@"addConcern"] forState:UIControlStateNormal];
        _concern.selected=NO;
    }
    _concern.layer.masksToBounds=YES;
    _concern.layer.cornerRadius=3;
    _concern.layer.borderWidth=0.5;
    _concern.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _concern.frame =(CGRect){kWindowWidth-15-50,50/2-30/2,50,30};
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"MiYiFansCell";
    MiYiFansCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MiYiFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
    
}

@end
