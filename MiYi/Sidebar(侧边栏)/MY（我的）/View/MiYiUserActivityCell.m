//
//  MiYiUserActivityCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/8.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUserActivityCell.h"
#import <UIImageView+WebCache.h>
#import "MiYiOwnerModel.h"
#import <MJExtension.h>
#import "MiYiCommunityPostDetailsVC.h"
#import "MiYiMyReleaseVC.h"
@interface MiYiUserActivityCell ()
{
    UIView *viewBG;
    UILabel *labelTitle;
    UIButton *buttonPush;
    UIImageView *imageActivity;
    UILabel *labelActivityTitle;
    UILabel *labelTime;
    UILabel *labelPrompt;
    UIButton *buttonClickPush;
}

@end

@implementation MiYiUserActivityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier
{
    MiYiUserActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MiYiUserActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

-(void)configCell{
    
    viewBG = [UIView new];
    viewBG.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:viewBG];
    [viewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 4, 0));
    }];
    
    labelTitle = [self getLabelTitle];
    labelTitle.text=@"我的动态";
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.width.greaterThanOrEqualTo(@30);
        make.height.equalTo(@15);
    }];
    
    buttonPush =[UIButton new];
    [buttonPush setImage:[UIImage imageNamed:@"Personal_more"] forState:UIControlStateNormal];
    [buttonPush sizeToFit];
    [buttonPush addTarget:self action:@selector(clickButtonPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonPush];
    [buttonPush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTitle);
        make.right.equalTo(@(-15));
        make.size.mas_equalTo(CGSizeMake(CGWidth(buttonPush.frame), CGHeight(buttonPush.frame)));
    }];
    
    imageActivity =[UIImageView new];
    imageActivity.contentMode=UIViewContentModeScaleAspectFill;
    imageActivity.layer.masksToBounds=YES;
    [self.contentView addSubview:imageActivity];
    [imageActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(15);
        make.left.equalTo(labelTitle);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    labelActivityTitle = [self getLabelActivityTitle];
    [self.contentView addSubview:labelActivityTitle];
    [labelActivityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageActivity);
        make.left.equalTo(imageActivity.mas_right).offset(8);
        make.right.equalTo(@(-8));
        make.height.greaterThanOrEqualTo(@12);
    }];
    
    labelTime =[self getLabelTime];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageActivity);
        make.left.equalTo(labelActivityTitle);
        make.height.equalTo(@10);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    labelPrompt =[UILabel new];
    labelPrompt.text=@"好凄凉啊姑娘,快去发表动态玩玩吧~";
    labelPrompt.textAlignment=NSTextAlignmentCenter;
    labelPrompt.textColor=[UIColor lightGrayColor];
    labelPrompt.font=Font(13);
    labelPrompt.hidden=YES;
    [self.contentView addSubview:labelPrompt];
    [labelPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(@13);
    }];
    
    buttonClickPush = [self getButtonClickPush];
    buttonClickPush.hidden=YES;
    [buttonClickPush addTarget:self action:@selector(clickButtonClickPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonClickPush];
    [buttonClickPush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageActivity);
        make.left.equalTo(imageActivity);
        make.height.equalTo(imageActivity.mas_height);
        make.width.equalTo(@(kWindowWidth-30));
    }];
    
}

#pragma -mark click

-(void)clickButtonPush:(UIButton *)btn{
    
    MiYiMyReleaseVC * vc = [[MiYiMyReleaseVC alloc]init];
    if (_isOfOthers==YES) {
        vc.title=@"他的动态";
    }else{
       vc.title=@"我的动态";
    }
    vc.viewController=self.viewController;
    vc.uid=_activityModel.owner.user_id;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)clickButtonClickPush:(UIButton *)btn{
    MiYiCommunityPostDetailsVC *vc =[[MiYiCommunityPostDetailsVC alloc]init];
    vc.model=_activityModel;
    vc.isSelectImage=YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)setActivityModel:(MiYiBaseCommunityModel *)activityModel{
    _activityModel=activityModel;
    if (_isOfOthers==YES) {
        labelTitle.text=@"她的动态";
        labelPrompt.text=@"这个人很懒,暂时没有发表任何动态";
    }
    labelPrompt.hidden=YES;
    if (activityModel==nil) {
        labelPrompt.hidden=NO;
        buttonClickPush.hidden=YES;
        return;
    }
    
    buttonClickPush.hidden=NO;
    
    MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:activityModel.images[0]];
    NSString *url =model.img_url;
    [imageActivity sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@180x180.jpg",[url substringToIndex:[url length]-4]]] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    
    if (activityModel.content.length==0) {
        labelActivityTitle.text=@"这家伙好懒,什么都没写";
    }else
    labelActivityTitle.text=activityModel.content;
    
    labelTime.text=activityModel.time;
    
    
    
}


#pragma -mark init
-(UILabel *)getLabelTitle{
    UILabel *label =[UILabel new];
    label.textColor=[UIColor blackColor];
    label.font=boldFont(15);
    return label;
}

-(UILabel *)getLabelActivityTitle{
    UILabel *label =[UILabel new];
    label.textColor=[UIColor blackColor];
    label.font=Font(12);
    label.numberOfLines=2;
    return label;
}

-(UILabel *)getLabelTime{
    UILabel *label =[UILabel new];
    label.textColor=[UIColor lightGrayColor];
    label.font=Font(10);
    return label;
}

-(UIButton *)getButtonClickPush{
    UIButton *btn =[UIButton new];
    return btn;
}

@end
