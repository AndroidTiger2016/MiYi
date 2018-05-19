//
//  MiYiCommentsPostDetailCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/21.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiCommentsPostDetailCell.h"
#import "MiYiImageView.h"
#import "MiYiPhotosView.h"
#import <UIImageView+WebCache.h>
#import "MiYiOwnerModel.h"
#import <MJExtension.h>
#import "MiYiPostsRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiUserVC.h"
#import "MiYiUserSession.h"
@interface MiYiCommentsPostDetailCell ()
{
    MiYiImageView *userImage;
    UILabel *labelUserName;
    UILabel *labelUserContent;
    MiYiPhotosView *photsView;
    UIButton *buttonLocation;
    UILabel *labelTime;
    UIButton *buttonLike;
    UIView *showView;
}
@end
@implementation MiYiCommentsPostDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier{    MiYiCommentsPostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MiYiCommentsPostDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

-(void)configCell{
    userImage = [MiYiImageView new];
    userImage.layer.cornerRadius=60/2/2;
    userImage.layer.masksToBounds=YES;
    userImage.userInteractionEnabled=YES;
    [userImage addTarget:self action:@selector(clickImageUsericon) forControlEvents:MiYiImageViewControlEventTap];
    [self.contentView addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(@28);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    labelUserName = [self getlabelUserName];
    labelUserName.text=@"昵称";
    [labelUserName sizeToFit];
    [self.contentView addSubview:labelUserName];
    [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(userImage.mas_right).offset(8);
        make.height.equalTo(@(CGHeight(labelUserName.frame)));
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    labelUserContent = [self getlabelUserContent];
    [labelUserContent sizeToFit];
    [self.contentView addSubview:labelUserContent];
    [labelUserContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelUserName.mas_bottom).offset(4);
        make.left.equalTo(userImage.mas_right).offset(8);
        make.height.greaterThanOrEqualTo(@6);
        make.width.equalTo(@((kWindowWidth-28*2-30-8)));
    }];
    
    photsView = [MiYiPhotosView new];
    [self.contentView addSubview:photsView];
    [photsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelUserContent.mas_bottom).offset(7);
        make.left.equalTo(userImage.mas_right).offset(8);
        make.width.equalTo(labelUserContent.mas_width);
        make.height.greaterThanOrEqualTo(@10);
    }];
    
    buttonLocation = [self getButtonLocation];
    [buttonLocation sizeToFit];
    [self.contentView addSubview:buttonLocation];
    [buttonLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photsView.mas_bottom).offset(10);
        make.left.equalTo(userImage.mas_right).offset(8);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonLocation.frame)));
        make.height.equalTo(@(CGHeight(buttonLocation.frame)));
    }];
    
    labelTime = [self getLabelTime];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttonLocation.mas_centerY);
        make.left.equalTo(buttonLocation.mas_right).offset(25/2);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@(CGHeight(buttonLocation.frame)));
    }];
    
    buttonLike = [self getButtonLike];
    [buttonLike setTitle:@" 0" forState:UIControlStateNormal];
    [buttonLike setTitle:@" 0" forState:UIControlStateSelected];
    [buttonLike addTarget:self action:@selector(clickButtonLike:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLike sizeToFit];
    [self.contentView addSubview:buttonLike];
    [buttonLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonLike.frame)));
        make.height.equalTo(@(CGHeight(buttonLike.frame)));
    }];
    
    showView = [UIView new];
    showView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    [self.contentView addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(@(kWindowWidth));
        make.height.equalTo(@1);
    }];
    
}

-(void)setPostDatailsModel:(MiYiPostDatailsModel *)postDatailsModel{
    
    _postDatailsModel=postDatailsModel;

    [userImage sd_setImageWithURL:[NSURL URLWithString:_postDatailsModel.owner.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    
    labelUserName.text=_postDatailsModel.owner.nickname;
    
    labelUserContent.text=_postDatailsModel.content;
    if (_postDatailsModel.images.count!=0) {
        __weak MiYiPostDatailsModel *wekaModel =postDatailsModel;
        WS(ws)
        for (int i =0; i < wekaModel.images.count; i++) {
            MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:postDatailsModel.images[i]];
            if (model.img_url==nil) {
                photsView.photos =nil;
            }else{
               
                photsView.photos =postDatailsModel.images;
                break;
            }
        }
        [photsView mas_updateConstraints:^(MASConstraintMaker *make) {
            for (int i =0; i < wekaModel.images.count; i++) {
                MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:wekaModel.images[i]];
                if (model.img_url==nil) {
//                    weakPhotsView.photos =nil;
                    make.height.greaterThanOrEqualTo(@0);
                }else{
                    CGSize size =[MiYiPhotosView photosViewSizeWithPhotosCount:ws.postDatailsModel.images.count];
                    make.height.greaterThanOrEqualTo(@(size.height));
//                    weakPhotsView.photos =ws.postDatailsModel.images;
                    break;
                }
            }
        }];
    }

    [buttonLocation setTitle:_postDatailsModel.location forState:UIControlStateNormal];

    labelTime.text=_postDatailsModel.time;
    
    if (_postDatailsModel.is_like) {
        buttonLike.selected=YES;
        [buttonLike setTitle:[NSString stringWithFormat:@" %ld",(long)postDatailsModel.like_count] forState:UIControlStateSelected];
    }else{
        buttonLike.selected=NO;
        [buttonLike setTitle:[NSString stringWithFormat:@" %ld",(long)postDatailsModel.like_count ] forState:UIControlStateNormal];
    }
}

#pragma -Mark 点击
-(void)clickButtonLike:(UIButton *)btn{
    WS(ws)
   [MiYiPostsRequest commentLike:_postDatailsModel.comment_id success:^(BOOL success) {
       if (success) {
           btn.selected=success;
           ws.postDatailsModel.like_count=ws.postDatailsModel.like_count +1;
           [btn setTitle:[NSString stringWithFormat:@" %ld",(long)ws.postDatailsModel.like_count] forState:UIControlStateSelected];
           [MBProgressHUD showSuccess:@"赞一个"];
       }else{
           btn.selected=success;
           ws.postDatailsModel.like_count=ws.postDatailsModel.like_count -1;
           [btn setTitle:[NSString stringWithFormat:@" %ld",(long)ws.postDatailsModel.like_count] forState:UIControlStateNormal];
           [MBProgressHUD showSuccess:@"取消赞"];
       }
       ws.postDatailsModel.is_like=success;
   }];
}

-(void)clickImageUsericon{
    MiYiUserVC *vc =[[MiYiUserVC alloc]init];
    vc.uid=_postDatailsModel.owner.user_id;
    if ([[MiYiUserSession shared].session.uid isEqualToString:_postDatailsModel.owner.user_id]) {
        vc.isOfOthers=NO;
    }else{
        vc.isOfOthers=YES;
    }
    if ([self.delegate respondsToSelector:@selector(pushUserVC:)]) {
        [self.delegate pushUserVC:vc];
    }
}

#pragma  -Mark 初始化
-(UILabel *)getlabelUserName{
    UILabel *label = [UILabel new];
    label.font=Font(13);
    label.textColor=UIColorFromRGB_HEX(0x3e3e3e);
    return label;
}

-(UILabel *)getlabelUserContent{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB_HEX(0x3e3e3e);
    label.font = Font(11);
    label.numberOfLines=0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

-(UILabel *)getLabelTime{
    UILabel *label = [UILabel new];
    label.font=Font(10);
    label.textColor=UIColorFromRGB_HEX(0x9b9b9b);
    return label;
}

-(UIButton *)getButtonLocation{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"home_location"] forState:UIControlStateNormal];
    return btn;
}

-(UIButton *)getButtonLike{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"praiseSelected"] forState:UIControlStateSelected];
    return btn;
}

-(void)dealloc{

}
@end
