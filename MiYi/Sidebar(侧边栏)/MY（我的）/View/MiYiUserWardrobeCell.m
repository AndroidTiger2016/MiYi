//
//  MiYiUserWardrobeCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/10.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUserWardrobeCell.h"
#import <UIImageView+WebCache.h>
#import "MiYiRecommendModel.h"
#import "MiYiImageView.h"
#import "MiYiProductDetailsVC.h"
#import "MiYiMyWardrobeVC.h"
@interface MiYiUserWardrobeCell ()
{
    UIView *viewBG;
    UILabel *labelTitle;
    UIButton *buttonPush;
    UIView *imageWardrobeBG;
    NSMutableArray *arrayImage;
    UILabel *labelPrompt;
}

@end

@implementation MiYiUserWardrobeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier
{
    MiYiUserWardrobeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MiYiUserWardrobeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    labelTitle.text=@"我的衣橱";
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
    
    imageWardrobeBG =[UIView new];
    [self.contentView addSubview:imageWardrobeBG];
    [imageWardrobeBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTitle.mas_bottom).offset(15);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@((kWindowWidth-30-20)/3));
    }];
    
    arrayImage =[NSMutableArray array];
    for(int i =0 ; i< 3; i++){
        MiYiImageView *image =[MiYiImageView new];
        image.hidden=YES;
        image.tag=i;
        image.userInteractionEnabled=YES;
        image.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
        [image addTarget:self action:@selector(clickImage:) forControlEvents:MiYiImageViewControlEventTap];
        [imageWardrobeBG addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(i*(kWindowWidth-30)/3));
            make.width.equalTo(imageWardrobeBG).dividedBy(3).offset(-10);
            make.height.equalTo(@((kWindowWidth-30-20)/3));
        }];
        [arrayImage addObject:image];
    }
   
    
    labelPrompt =[UILabel new];
    labelPrompt.text=@"衣橱里缺少的可不只是一件衣服哦";
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
    
}

#pragma -mark click

-(void)clickImage:(MiYiImageView *)image{
    MiYiProductDetailsVC *vc =[[MiYiProductDetailsVC alloc]init];
    vc.model=_arrayWardrobe[image.tag];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)clickButtonPush:(UIButton *)btn{
    MiYiMyWardrobeVC *vc =[[MiYiMyWardrobeVC alloc]init];
    if (_isOfOthers==YES) {
        vc.title=@"他的衣橱";
    }else{
        vc.title=@"我的衣橱";
    }
    vc.uid =_uid;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)setArrayWardrobe:(NSMutableArray *)arrayWardrobe
{
    _arrayWardrobe=arrayWardrobe;
    labelPrompt.hidden=YES;
    
    if (_isOfOthers==YES) {
        labelTitle.text=@"她的衣橱";
        labelPrompt.text=@"这个人很懒,暂时没有收藏任何衣服";
    }
    NSInteger countArray =arrayWardrobe.count;
    if (arrayWardrobe.count>3) {
        countArray=3;
    }
    if (countArray ==0) {
        labelPrompt.hidden=NO;
        return;
    }
    for (int i = 0; i <countArray; i++) {
        MiYiRecommendModel *model =arrayWardrobe[i];
        UIImageView *image = arrayImage[i];
        image.hidden=NO;
        [image sd_setImageWithURL:[NSURL URLWithString:model.path_url] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    }
}

#pragma -mark init
-(UILabel *)getLabelTitle{
    UILabel *label =[UILabel new];
    label.textColor=[UIColor blackColor];
    label.font=boldFont(15);
    return label;
}


@end
