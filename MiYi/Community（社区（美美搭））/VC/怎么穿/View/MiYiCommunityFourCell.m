//
//  MiYiCommunityFourCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/7.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCommunityFourCell.h"
#import "MiYiBaseCommunityModel.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "MiYiPostsRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiPostsRequest.h"
@interface MiYiCommunityFourCell ()
{
    UIImageView *imageConcern;
    UILabel *labelConcern;
    UILabel *labelTime;
    UIButton *buttonComment;
    UIButton *buttonPraise;
}
@end

@implementation MiYiCommunityFourCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MiYiCommunityFourCell";
    MiYiCommunityFourCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MiYiCommunityFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

-(void)configCell{
    imageConcern = [self getImageConcern];
    [self.contentView addSubview:imageConcern];
    [imageConcern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(25/2));
        make.left.equalTo(@(25/2));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    labelConcern = [self getLabelConcern];
    [self.contentView addSubview:labelConcern];
    [labelConcern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(25/2));
        make.left.equalTo(imageConcern.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(kWindowWidth-60-25-10));
        make.height.equalTo(@13);
    }];
    
    labelTime = [self getLabelTime];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-(25/2));
        make.left.equalTo(imageConcern.mas_right).offset(10);
        make.width.greaterThanOrEqualTo(@50);
        make.height.equalTo(@12);
    }];
    
    buttonComment = [self getButtonComment];
    [buttonComment setTitle:@" 0" forState:UIControlStateNormal];
    [buttonComment sizeToFit];
    [self.contentView addSubview:buttonComment];
    [buttonComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonComment.frame)));
        make.height.equalTo(@(CGHeight(buttonComment.frame)));
    }];
    
    buttonPraise = [self getButtonPraise];
    [buttonPraise setTitle:@" 0" forState:UIControlStateNormal];
    [buttonPraise setTitle:@" 0" forState:UIControlStateSelected];
    [buttonPraise sizeToFit];
    [self.contentView addSubview:buttonPraise];
    [buttonPraise addTarget:self action:@selector(clickButtonPraise:) forControlEvents:UIControlEventTouchUpInside];
    [buttonPraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime.mas_centerY);
        make.right.equalTo(buttonComment.mas_left).offset(-17);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonPraise.frame)));
        make.height.equalTo(@(CGHeight(buttonPraise.frame)));
    }];

}

-(void)clickButtonPraise:(UIButton *)btn{
    WS(ws)
    [MiYiPostsRequest likeTopic_id:_postDetailsModel.topic_id success:^(BOOL success) {
        if (success) {
            btn.selected=success;
            _postDetailsModel.like_count=[NSString stringWithFormat:@"%ld",(long)([_postDetailsModel.like_count integerValue] +1)];
            [btn setTitle:[NSString stringWithFormat:@" %ld",(long)[_postDetailsModel.like_count integerValue]] forState:UIControlStateSelected];
            [MBProgressHUD showSuccess:@"收藏成功"];
        }else{
            btn.selected=success;
            _postDetailsModel.like_count=[NSString stringWithFormat:@"%ld",(long)([_postDetailsModel.like_count integerValue] -1)];
            [btn setTitle:[NSString stringWithFormat:@" %ld",(long)[_postDetailsModel.like_count integerValue]] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"取消成功"];
        }
        NSDictionary *dic =@{@"topic_id":ws.postDetailsModel.topic_id,@"is_like":ws.postDetailsModel.is_like};
        [Notification postNotificationName:@"is_like" object:dic];
        _postDetailsModel.is_like=[NSString stringWithFormat:@"%ld",(long)success];
    }];

}

-(void)setPostDetailsModel:(MiYiBaseCommunityModel *)postDetailsModel{
    _postDetailsModel =postDetailsModel;
    
    MiYiPostsImageSModel *mode =[MiYiPostsImageSModel objectWithKeyValues:_postDetailsModel.images[0]];
    [imageConcern sd_setImageWithURL:[NSURL URLWithString:mode.img_url] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    
    labelConcern.text=_postDetailsModel.content;
    
    if ([_postDetailsModel.is_like boolValue]) {
        buttonPraise.selected=YES;
        [buttonPraise setTitle:[NSString stringWithFormat:@" %ld",(long)[_postDetailsModel.like_count integerValue]] forState:UIControlStateSelected];
    }else{
        buttonPraise.selected=NO;
        [buttonPraise setTitle:[NSString stringWithFormat:@" %ld",(long)[_postDetailsModel.like_count integerValue]] forState:UIControlStateNormal];
    }
    NSString *commentText =[NSString stringWithFormat:@" %@",_postDetailsModel.comment_count];
    [buttonComment setTitle:commentText forState:UIControlStateNormal];
    
    labelTime.text=_postDetailsModel.time;
    
    
    
}

-(UIImageView *)getImageConcern{
    UIImageView *image =[UIImageView new];
    image.layer.masksToBounds=YES;
    image.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    return image;
}
-(UILabel *)getLabelConcern{
    UILabel *label = [UILabel new];
    label.font=Font(12);
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}
-(UILabel *)getLabelTime{
    UILabel *label = [UILabel new];
    label.font=Font(10);
    label.textColor=[UIColor lightGrayColor];
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}
-(UIButton *)getButtonComment{
    UIButton *btn = [UIButton new];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    return btn;
}
-(UIButton *)getButtonPraise{
    UIButton *btn =[UIButton new];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"praiseSelected"] forState:UIControlStateSelected];
    return btn;
}
@end
