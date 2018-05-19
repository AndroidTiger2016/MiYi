//
//  MiYiPersonalUserView.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/8.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPersonalUserView.h"
#import "UIImage+MiYi.h"
#import <UIImageView+WebCache.h>
#import "UIColor+RandomColor.h"
#import "MiYiConcernedWithTheFansRequest.h"
#import "MBProgressHUD+YXL.h"
@interface MiYiPersonalUserView ()
{
    UIView *viewImageUserBackground;
    UIImageView *imageUser;
    UILabel *labelName;
    UIButton *buttonRating;
    UIButton *buttonCandy;
    UILabel *labelSummary;
    NSMutableArray *buttonArray;
    UIView *viewOfOthers;
    UIButton *buttonConcern;
    UIButton *buttonInfo;

}
@end

@implementation MiYiPersonalUserView

-(id)init{
    self =[super init];
    if (self) {
        [self initUI];
    }
    return self;
}



-(void)initUI{
    
    
    _imageBG =[UIImageView new];
    _imageBG.image=[UIImage imageNamed:@"Personal_bg"];
    [self addSubview:_imageBG];
    [_imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 4, 0));
    }];
    
    
    
    CGFloat viewWH =70;
    viewImageUserBackground = [self getViewImageUserBackground];
    [UIImage hexagonPathWidth:viewWH+7.5 view:viewImageUserBackground];
    [self addSubview:viewImageUserBackground];
    [viewImageUserBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(64+8));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewWH+7.5, viewWH+7.5));
    }];
    
    imageUser = [self getImageUser];
    [UIImage hexagonPathWidth:viewWH+1.5 view:imageUser];
    imageUser.image=[UIImage imageNamed:@"userpLaceholderImage"];
    [viewImageUserBackground addSubview:imageUser];
    [imageUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewImageUserBackground);
        make.size.mas_equalTo(CGSizeMake(viewWH+1.5, viewWH+1.5));
    }];
    
    labelName = [self getLabelName];
    [self addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewImageUserBackground.mas_bottom).offset(15);
        make.centerX.equalTo(viewImageUserBackground);
        make.height.equalTo(@16);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    buttonRating = [self getButtonRating];
    [buttonRating sizeToFit];
    [self addSubview:buttonRating];
    [buttonRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelName.mas_bottom).offset(15);
        make.right.equalTo(viewImageUserBackground.mas_centerX);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonRating.frame)));
        make.height.equalTo(@(CGHeight(buttonRating.frame)));
    }];
    
    buttonCandy = [self getButtonCandy];
    [buttonCandy sizeToFit];
    [self addSubview:buttonCandy];
    [buttonCandy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttonRating);
        make.left.equalTo(viewImageUserBackground.mas_right);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonCandy.frame)));
        make.height.equalTo(@(CGHeight(buttonCandy.frame)));
    }];

    labelSummary = [self getLabelSummary];
    [self addSubview:labelSummary];
    [labelSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonRating.mas_bottom).offset(15);
        make.centerX.equalTo(viewImageUserBackground);
        make.width.greaterThanOrEqualTo(@30);
        make.height.equalTo(@13);
    }];
    
    buttonArray =[NSMutableArray array];
    for (int i=0; i<3; i++) {
        UIButton * btn =[self getButtonArray];
        btn.tag=i;
        [self addSubview:btn];
        [buttonArray addObject:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelSummary.mas_bottom).offset(4);
            make.left.equalTo(@(i*(kWindowWidth/3)));
            make.width.mas_equalTo(self).dividedBy(3);
            make.height.equalTo(@35);
        }];
    }
    
    viewOfOthers =[self getViewOfOthers];
    viewOfOthers.hidden=YES;
    [self addSubview:viewOfOthers];
    [viewOfOthers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelSummary.mas_bottom).offset(8+35);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 75/2));
    }];
    
    buttonConcern =[self getButtonConcern];
    [buttonConcern sizeToFit];
    [buttonConcern addTarget:self action:@selector(clickButtonConcern:) forControlEvents:UIControlEventTouchUpInside];
    [viewOfOthers addSubview:buttonConcern];
    [buttonConcern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOfOthers.mas_centerX);
        make.centerY.equalTo(viewOfOthers.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/4, CGHeight(buttonConcern.frame)));
    }];
    
    UIView *viewErectShow =[UIView new];
    viewErectShow.backgroundColor=[UIColor whiteColor];
    [viewOfOthers addSubview:viewErectShow];
    [viewErectShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewOfOthers);
        make.size.mas_equalTo(CGSizeMake(1, 75/2-10));
    }];
    
    buttonInfo = [self getButtonInfo];
    [buttonInfo sizeToFit];
    [buttonInfo addTarget:self action:@selector(clickButtonInfo:) forControlEvents:UIControlEventTouchUpInside];
    [viewOfOthers addSubview:buttonInfo];
    [buttonInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOfOthers.mas_centerX);
        make.centerY.equalTo(viewOfOthers.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth/4, CGHeight(buttonInfo.frame)));
    }];
    

    
}

#pragma -mark 赋值
-(void)userData:(MiYiAccount *)user{
    

    
    [imageUser sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    
    labelName.text=user.nickname;
    
    NSString *ratingText =[NSString stringWithFormat:@" %@",user.exp_point ? user.exp_point :@"时尚新手"];
    [buttonRating setTitle:ratingText forState:UIControlStateNormal];
    
    NSString *candyText =[NSString stringWithFormat:@" %ld",[user.reward_point integerValue]];
    [buttonCandy setTitle:candyText forState:UIControlStateNormal];
    
    if (user.summary.length==0) {
        if (_isOfOthers==YES) {
            labelSummary.text=@"她还没有书写个人签名";
        }else{
            labelSummary.text=@"快来书写你的个人签名吧";
        }
        
    }else
    labelSummary.text=user.summary;
    
    NSArray *buttonTitleArray =@[@"关注",@"粉丝",@"发布"];
    NSArray *buttonTextArray =@[user.following,user.follower,user.topic];
    for (int i=0; i<buttonArray.count; i++) {
        UIButton *btn =buttonArray[i];
        NSString *btnTitle =[NSString stringWithFormat:@"%@ %ld",buttonTitleArray[i],[buttonTextArray[i] integerValue]];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
    }
 
}

-(void)setIsOfOthers:(BOOL)isOfOthers{
    _isOfOthers=isOfOthers;
    if (isOfOthers==YES) {
        viewOfOthers.hidden=NO;
    }else{
        viewOfOthers.hidden=YES;
    }
}

#pragma -mark click
-(void)clickBtn:(UIButton *)btn{
    
}

-(void)clickButtonConcern:(UIButton *)btn{
    [MiYiConcernedWithTheFansRequest concernedWithTheFansUserUID:_uid json:^(id json) {
        BOOL isBOOL =[json[@"data"][@"is_follow"] boolValue];
        if (isBOOL) {
            [MBProgressHUD showSuccess:@"关注成功"];
        }else
        {
            [MBProgressHUD showSuccess:@"取消关注"];
        }
        btn.selected=isBOOL;
        NSDictionary *dic =@{@"userid":_uid,@"is_following":[NSString stringWithFormat:@"%ld",(long)isBOOL]};
        [Notification postNotificationName:@"follow" object:dic];
    } error:^(NSError *error) {
        
    }];
}

-(void)clickButtonInfo:(UIButton *)btn{
    
}

#pragma -mark init

-(UIView *)getViewImageUserBackground{
    UIView *view =[UIView new];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

-(UIView *)getViewOfOthers{
    UIView *view =[UIView new];
    view.backgroundColor=UIColorRGBA(255, 255, 255, 0.3);
    return view;
}

-(UIImageView *)getImageUser{
    UIImageView *image =[UIImageView new];
    image.contentMode=UIViewContentModeScaleAspectFill;
    return image;
}

-(UILabel *)getLabelName{
    UILabel *label =[UILabel new];
    label.font=boldFont(34/2);
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    return label;
}

-(UILabel *)getLabelSummary{
    UILabel *label =[UILabel new];
    label.font=Font(26/2);
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

-(UIButton *)getButtonRating{
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"Personal_Star"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(12);
    return btn;
}

-(UIButton *)getButtonCandy{
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"Personal_praise"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(12);
    return btn;
}

-(UIButton *)getButtonArray{
    UIButton *btn = [UIButton new];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(15);
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UIButton *)getButtonConcern{
    UIButton *btn =[UIButton new];
    [btn setImage:[UIImage imageNamed:@"Personal_follow"] forState:UIControlStateNormal];
    [btn setTitle:@" 关注" forState:UIControlStateNormal];
    [btn setTitle:@" 已关注" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(15);
    return btn;
}

-(UIButton *)getButtonInfo{
    UIButton *btn =[UIButton new];
    [btn setImage:[UIImage imageNamed:@"Personal_mail"] forState:UIControlStateNormal];
    [btn setTitle:@" 私信" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(15);
    return btn;
}
@end
