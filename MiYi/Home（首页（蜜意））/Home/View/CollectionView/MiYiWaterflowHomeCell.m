//
//  MiYiWaterflowHomeCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/25.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiWaterflowHomeCell.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+XXImageAnimated.h"
#import <MJExtension.h>
#import "MiYiOwnerModel.h"
#import "MiYiPostsRequest.h"
#import "MBProgressHUD+YXL.h"
@interface MiYiWaterflowHomeCell ()
{
    UIImageView *imageContent;
    UIButton *buttonLike;
    UIImageView *imageUserImage;
    UILabel *labelUserName;
    UIButton *buttonLocation;
    UILabel *labelContent;
    UILabel *labelTag;
    
}
@property (nonatomic ,strong) NSMutableArray *labelArray;
@end

@implementation MiYiWaterflowHomeCell
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    
    self.backgroundColor=[UIColor whiteColor];
    _labelArray =[NSMutableArray array];
    float itemWidth = (kWindowWidth-3) / 2;
    
    imageContent = [UIImageView new];
    imageContent.userInteractionEnabled=YES;
    imageContent.layer.masksToBounds=YES;
    imageContent.contentMode=UIViewContentModeScaleAspectFit;
    imageContent.backgroundColor=UIColorRGBA(155, 155, 155, 1);
    [self addSubview:imageContent];
    [imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(itemWidth));
    }];
    
    UIView *viewShow =[UIView new];
    viewShow.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    [self addSubview:viewShow];
    [viewShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageContent.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    
    buttonLike = [self getButtonLike];
    [buttonLike addTarget:self action:@selector(clickButtonLike:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLike sizeToFit];
    [imageContent addSubview:buttonLike];
    [buttonLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageContent.mas_right).offset(-(16/2));
        make.bottom.equalTo(imageContent.mas_bottom).offset(-(16/2));
        make.size.mas_equalTo(CGSizeMake(CGWidth(buttonLike.frame), CGHeight(buttonLike.frame)));
    }];
    
    imageUserImage = [self getImageUserImage];
    imageUserImage.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    imageUserImage.layer.cornerRadius=54/2/2;
    [self addSubview:imageUserImage];
    [imageUserImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageContent.mas_bottom).offset(16/2);
        make.left.equalTo(@16);
        make.size.mas_equalTo(CGSizeMake(54/2, 54/2));
    }];
    
    labelUserName = [self getLabelUserName];
    [self addSubview:labelUserName];
    [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageUserImage);
        make.left.equalTo(imageUserImage.mas_right).offset(16/2);
        make.width.greaterThanOrEqualTo(@40);
        make.height.equalTo(@10);
    }];
    
    buttonLocation = [self getButtonLocation];
    [buttonLocation setTitle:@" 未知" forState:UIControlStateNormal];
    [buttonLocation sizeToFit];
    [self addSubview:buttonLocation];
    [buttonLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelUserName);
        make.right.equalTo(self.mas_right).offset(-(16/2));
        make.width.greaterThanOrEqualTo(@30);
        make.height.equalTo(@(CGHeight(buttonLocation.frame)));
    }];
    
    labelContent = [self getLabelContent];
    [self addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonLocation.mas_bottom).offset(5);
        make.left.equalTo(imageUserImage.mas_right).offset(16/2);
        make.right.equalTo(self.mas_right).offset(-(16/2));
        make.height.equalTo(@10);
    }];
    
    
    for (int i=0; i<3; i++) {
        labelTag = [self getLabelTag];
        labelTag.hidden=YES;
        [self addSubview:labelTag];
        [labelTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageUserImage.mas_bottom).offset(18/2);
            make.left.equalTo(@((16/2)+(i>0?(i>1?8:4):0)+(((kWindowWidth-3)/2-24)/3)*i));
            make.width.equalTo(@(((kWindowWidth-3)/2-24)/3));
            make.height.equalTo(@15);
        }];
        [_labelArray addObject:labelTag];
    }
}

#pragma -Mark 数据

-(void)setHomeModel:(MiYiBaseCommunityModel *)homeModel{
    if ([_homeModel isEqual:homeModel]) {
        return;
    }
    _homeModel =homeModel;

    for (int i=0; i<3; i++) {
        UILabel *label =_labelArray[i];
        label.hidden=YES;
        label.text=@"";
    }
    
    
    [buttonLocation setTitle:[NSString stringWithFormat:@" %@",_homeModel.location] forState:UIControlStateNormal];
    __weak UIImageView *weakImageContent =imageContent;
    MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:_homeModel.images[0]];
    if (model.img_url!=nil) {
        float itemWidth = (kWindowWidth-3) / 2;
        NSRange range = [model.size rangeOfString:@","];
        CGFloat imageH =[[NSString stringWithFormat:@"%@",[model.size substringFromIndex:range.location+1]] floatValue];
        CGFloat imageW =[[NSString stringWithFormat:@"%@",[model.size substringToIndex:range.location]] floatValue];
        CGFloat ratio =imageW /imageH;
        CGFloat H =itemWidth/ratio;

        [imageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(H));
        }];
        [imageContent sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType == SDImageCacheTypeNone) {
                [weakImageContent setImage:image animated:YES];
            }else{
                weakImageContent.image=image;
            };
        }];
    }
    
    labelUserName.text=_homeModel.owner.nickname;
    
    [imageUserImage sd_setImageWithURL:[NSURL URLWithString:_homeModel.owner.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    
    if (_homeModel.content.length==0) {
        labelContent.text=@"这家伙好懒,什么都不写";
    }else
    labelContent.text =_homeModel.content;
    
    buttonLike.selected=[_homeModel.is_like boolValue];
    
    MiYiPostsImageSModel *imageSModel = [MiYiPostsImageSModel objectWithKeyValues:_homeModel.images[0]];
   
    for (int i=0; i < imageSModel.tags.count ; i++) {
        if (i>2) {
            return;
        }
        MiYiPostsImageTagIdsModel *tagModel =[MiYiPostsImageTagIdsModel objectWithKeyValues:imageSModel.tags[i]];
        if (tagModel.tag_content.length==0) {
            break;
        }
        
        UILabel *label = _labelArray[i];
        label.hidden=NO;
        label.text=tagModel.tag_content;
    }
}

#pragma -Mark 点击

-(void)clickButtonLike:(UIButton *)btn{
    WS(ws)
    [MiYiPostsRequest likeTopic_id:_homeModel.topic_id success:^(BOOL success) {
        if (success) {
            btn.selected=success;
            ws.homeModel.like_count=[NSString stringWithFormat:@"%ld",(long)([ws.homeModel.like_count integerValue] +1)];
            [MBProgressHUD showSuccess:@"收藏成功"];
        }else{
            btn.selected=success;
            ws.homeModel.like_count=[NSString stringWithFormat:@"%ld",(long)([ws.homeModel.like_count integerValue] -1)];
            [MBProgressHUD showSuccess:@"取消成功"];
        }
        ws.homeModel.is_like=[NSString stringWithFormat:@"%ld",(long)success];
        NSDictionary *dic =@{@"topic_id":ws.homeModel.topic_id,@"is_like":ws.homeModel.is_like,@"like_count":ws.homeModel.like_count};
        [Notification postNotificationName:@"is_like" object:dic];
    }];
}

#pragma -Mark 初始化

-(UIButton *)getButtonLike{
    UIButton *btn =[UIButton new];
    btn.backgroundColor=[UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"home_praise"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"home_praiseSelected"] forState:UIControlStateSelected];
    return btn;
}

-(UIButton *)getButtonLocation{
    UIButton *btn =[UIButton new];
    btn.titleLabel.font=Font(10);
    [btn setTitleColor:UIColorRGBA(155, 155, 155, 1) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"home_location"] forState:UIControlStateNormal];
    return btn;
}

-(UIImageView *)getImageUserImage{
    UIImageView *image =[UIImageView new];
    image.layer.masksToBounds=YES;
    return image;
}

-(UILabel *)getLabelUserName{
    UILabel *label =[UILabel new];
    label.font=Font(10);
    label.textColor=UIColorRGBA(155, 155, 155, 1);
    return label;
}

-(UILabel *)getLabelContent{
    UILabel *label =[UILabel new];
    label.font=Font(10);
    label.textColor=UIColorRGBA(62, 62, 62, 1);
    return label;
}

-(UILabel *)getLabelTag{
    UILabel *label =[UILabel new];
    label.font=Font(8);
    label.textColor=UIColorRGBA(155, 155, 155, 1);
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=3;
    label.layer.borderWidth=0.5;
    label.layer.borderColor=UIColorRGBA(155, 155, 155, 1).CGColor;
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}
@end
