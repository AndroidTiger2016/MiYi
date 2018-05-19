//
//  MiYiBaseCommunityCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/31.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseCommunityCell.h"
#import "MiYiTagEditorImageView.h"
#import "MiYiDynamicScrollView.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "MiYiConcernedWithTheFansRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiUserSession.h"
#import "MiYiPostsRequest.h"
#import "MiYiImageView.h"
#import "MiYiUserVC.h"
#import "MiYiUserSession.h"
@interface MiYiBaseCommunityCell ()
{
    UIView *viewBackground;
    MiYiImageView *imageUsericon;
    UILabel *labelUserName;
    UIButton *buttonUserLeve;
    UIButton *buttonUserConcern;
    MiYiTagEditorImageView *tagEditorImageView;
    MiYiDynamicScrollView *dynamicScrollView;
    UILabel *labelContents;
    UILabel *labelTime;
    UIButton *buttonLocation;
    UIButton *buttonWatchList;
    UIButton *buttonComment;
    
}

@end

@implementation MiYiBaseCommunityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }return self;
}

-(void)configCell
{
    
    viewBackground = [UIView new];
    viewBackground.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:viewBackground];
    [viewBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.width.equalTo(@(kWindowWidth));
        make.height.equalTo(@(kWindowWidth));
    }];
    
    imageUsericon = [MiYiImageView new];
    imageUsericon.userInteractionEnabled=YES;
    imageUsericon.contentMode = UIViewContentModeScaleAspectFill;
    imageUsericon.layer.masksToBounds=YES;
    imageUsericon.backgroundColor=[UIColor blackColor];
    imageUsericon.layer.cornerRadius=15;
    [imageUsericon addTarget:self action:@selector(clickImageUsericon) forControlEvents:MiYiImageViewControlEventTap];
    [self.contentView addSubview:imageUsericon];
    [imageUsericon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    labelUserName = [self getlabelUserName];
    labelUserName.text=@"昵称";
    [labelUserName sizeToFit];
    [self.contentView addSubview:labelUserName];
    [labelUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageUsericon.mas_centerY);
        make.left.equalTo(imageUsericon.mas_right).offset(10);
        make.width.greaterThanOrEqualTo(@20);
        make.height.equalTo(@13);
    }];
    
    buttonUserLeve = [self getbuttonUserLeve];
    [buttonUserLeve setTitle:@" 时尚达人" forState:UIControlStateNormal];
    [buttonUserLeve sizeToFit];
    [self.contentView addSubview:buttonUserLeve];
    [buttonUserLeve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageUsericon.mas_centerY);
        make.left.equalTo(labelUserName.mas_right).offset(13);
        make.width.greaterThanOrEqualTo(@10);
        make.height.equalTo(@(CGHeight(buttonUserLeve.frame)));
    }];
    
    buttonUserConcern = [self getbuttonUserConcern];
    [buttonUserConcern setTitle:@"关注" forState:UIControlStateNormal];
    [buttonUserConcern setTitle:@"已关注" forState:UIControlStateSelected];
    buttonUserConcern.layer.masksToBounds=YES;
    buttonUserConcern.layer.cornerRadius=11;
    buttonUserConcern.layer.borderWidth=0.5;
    buttonUserConcern.layer.borderColor=UIColorFromRGB_HEX(0x9b9b9b).CGColor;
    [buttonUserConcern addTarget:self action:@selector(clickbuttonUserConcern:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonUserConcern];
    [buttonUserConcern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageUsericon.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-23);
        make.width.equalTo(@49);
        make.height.equalTo(@22);
    }];
    
    tagEditorImageView = [self getTagEditorImageView];
    tagEditorImageView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    [self.contentView addSubview:tagEditorImageView];
    [tagEditorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageUsericon.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(6);
        make.right.equalTo(self.contentView.mas_right).offset(-6);
        make.width.equalTo(@(kWindowWidth-12));
        make.height.equalTo(@(kWindowWidth-12));
    }];
    
    dynamicScrollView = [self getDynamicScrollView];
    [self.contentView addSubview:dynamicScrollView];
    [dynamicScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagEditorImageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(13.5);
        make.right.equalTo(self.contentView.mas_right).offset(-13.5);
        make.height.equalTo(@60);
    }];
    
    labelContents = [self getlabelContents];
    labelContents.text=@"这家伙很懒，什么都没有写";
    [self.contentView addSubview:labelContents];
    [labelContents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.height.greaterThanOrEqualTo(@11);
    }];
    
    labelTime = [self getlabelTime];
    labelTime.text=@"呜~时间未知";
    [labelTime sizeToFit];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelContents.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.width.greaterThanOrEqualTo(@20);
        make.height.equalTo(@(CGHeight(labelTime.frame)));
    }];
    
    buttonLocation = [self getButtonLocation];
    [buttonLocation setTitle:@" 未知" forState:UIControlStateNormal];
    [buttonLocation sizeToFit];
    [self.contentView addSubview:buttonLocation];
    [buttonLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime.mas_centerY);
        make.left.equalTo(labelTime.mas_right).offset(14);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonLocation.frame)));
        make.height.equalTo(@(CGHeight(buttonLocation.frame)));
    }];
    
    buttonComment = [self getbuttonComment];
    [buttonComment setTitle:@" 0" forState:UIControlStateNormal];
    [buttonComment setTitle:@" 0" forState:UIControlStateSelected];
    [buttonComment sizeToFit];
    [self.contentView addSubview:buttonComment];
    [buttonComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonComment.frame)));
        make.height.equalTo(@(CGHeight(buttonComment.frame)));
    }];
    
    buttonWatchList = [self getbuttonWatchList];
    [buttonWatchList setTitle:@" 0" forState:UIControlStateNormal];
    [buttonWatchList setTitle:@" 0" forState:UIControlStateSelected];
    [buttonWatchList sizeToFit];
    [self.contentView addSubview:buttonWatchList];
    [buttonWatchList addTarget:self action:@selector(clickbuttonWatchList:) forControlEvents:UIControlEventTouchUpInside];
    [buttonWatchList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime.mas_centerY);
        make.right.equalTo(buttonComment.mas_left).offset(-17);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonWatchList.frame)));
        make.height.equalTo(@(CGHeight(buttonWatchList.frame)));
    }];
}




#pragma -Mark click

-(void)clickImageUsericon{
    MiYiUserVC *vc =[[MiYiUserVC alloc]init];
    vc.uid=_postDetailsModel.owner.user_id;
    if ([[MiYiUserSession shared].session.uid isEqualToString:_postDetailsModel.owner.user_id]) {
        vc.isOfOthers=NO;
    }else{
        vc.isOfOthers=YES;
    }
    if ([self.delegate respondsToSelector:@selector(pushUserVC:)]) {
        [self.delegate pushUserVC:vc];
    }
}

-(void)clickbuttonUserConcern:(UIButton *)btn
{
    if ([_postDetailsModel.owner.user_id isEqualToString:[MiYiUserSession shared].session.uid]) {
        [MBProgressHUD showError:@"不能自己关注自己哦"];
        return;
    }
    WS(ws);
    [MiYiConcernedWithTheFansRequest concernedWithTheFansUserUID:_postDetailsModel.owner.user_id json:^(id json) {
        NSLog(@"%@",json);
        BOOL isBOOL =[json[@"data"][@"is_follow"] boolValue];
        ws.postDetailsModel.is_following=[NSString stringWithFormat:@"%ld",(long)isBOOL];
        if (isBOOL) {
            [MBProgressHUD showSuccess:@"关注成功"];
        }else
        {
            [MBProgressHUD showSuccess:@"取消关注"];
        }
        btn.selected=isBOOL;
        NSDictionary *dic =@{@"userid":ws.postDetailsModel.owner.user_id,@"is_following":ws.postDetailsModel.is_following};
        [Notification postNotificationName:@"follow" object:dic];
        
    } error:^(NSError *error) {
        
    }];

    //    [labelContents mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(tagEditorImageView.mas_bottom).offset(10);
    //        make.left.equalTo(self.contentView.mas_left).offset(17);
    //        make.right.equalTo(self.contentView.mas_right).offset(-17);
    //        make.height.greaterThanOrEqualTo(@11);
    //    }];
    //
    //    [self setNeedsUpdateConstraints];
    //    [self updateConstraintsIfNeeded];
    //
    //    [UIView animateWithDuration:0.4 animations:^{
    //        [self layoutIfNeeded];
    //    }];
}

-(void)clickbuttonWatchList:(UIButton *)btn
{
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
        _postDetailsModel.is_like=[NSString stringWithFormat:@"%ld",(long)success];
        NSDictionary *dic =@{@"topic_id":ws.postDetailsModel.topic_id,@"is_like":ws.postDetailsModel.is_like,@"like_count":_postDetailsModel.like_count};
        NSLog(@"点击%@ -----%@",dic[@"is_like"],_postDetailsModel.is_like);
        [Notification postNotificationName:@"is_like" object:dic];
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier;
{
    MiYiBaseCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MiYiBaseCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma -Mark getInit
-(MiYiTagEditorImageView *)getTagEditorImageView{
    MiYiTagEditorImageView *image =[MiYiTagEditorImageView new];
    return image;
}
-(MiYiDynamicScrollView *)getDynamicScrollView{
    MiYiDynamicScrollView *scrollview =[[MiYiDynamicScrollView alloc]init];
    return scrollview;
}
-(UIButton *)getbuttonUserConcern{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    return btn;
}
-(UIButton *)getbuttonComment{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    return btn;
}
-(UIButton *)getbuttonUserLeve{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"Pentacle"] forState:UIControlStateNormal];
    return btn;
}
-(UIButton *)getbuttonWatchList{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"praiseSelected"] forState:UIControlStateSelected];
    return btn;
}
-(UIButton *)getButtonLocation{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:UIColorFromRGB_HEX(0x9b9b9b) forState:UIControlStateNormal];
    btn.titleLabel.font = Font(10);
    [btn setImage:[UIImage imageNamed:@"home_location"] forState:UIControlStateNormal];
    return btn;
}
-(UILabel *)getlabelUserName{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = Font(13);
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
-(UILabel *)getlabelContents{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB_HEX(0x3e3e3e);
    label.font = Font(11);
    label.numberOfLines=0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
-(UILabel *)getlabelTime{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB_HEX(0x9b9b9b);
    label.font = Font(10);
    label.numberOfLines=0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

-(void)setPostDetailsModel:(MiYiBaseCommunityModel *)postDetailsModel{
    
    _postDetailsModel=postDetailsModel;
    
    [imageUsericon sd_setImageWithURL:[NSURL URLWithString:postDetailsModel.owner.avatar] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    
    labelUserName.text=postDetailsModel.owner.nickname;
    
    [buttonUserLeve setTitle:_postDetailsModel.owner.exp_point forState:UIControlStateNormal];
    
    buttonUserConcern.selected=[_postDetailsModel.is_following boolValue];
    
    MiYiPostsImageSModel *imagesMode =[MiYiPostsImageSModel objectWithKeyValues:postDetailsModel.images[0]];
    [tagEditorImageView removeTag];
    tagEditorImageView.isComputing=YES;
    tagEditorImageView.layer.masksToBounds=YES;
    tagEditorImageView.postsImageSModel=imagesMode;
    
    labelContents.text=_postDetailsModel.content;
    
    labelTime.text=_postDetailsModel.time;
    
    [buttonLocation setTitle:[NSString stringWithFormat:@" %@",_postDetailsModel.location] forState:UIControlStateNormal];
    
    
    
    if(_isSelectImage){
        
        
        [labelContents mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dynamicScrollView.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(17);
            make.right.equalTo(self.contentView.mas_right).offset(-17);
            make.height.greaterThanOrEqualTo(@11);
        }];
        MiYiMenuSentModel *sentModel =[[MiYiMenuSentModel alloc]init];
        sentModel.images=postDetailsModel.images;
        dynamicScrollView.menuSentModel=sentModel;
        dynamicScrollView.addImage.hidden=YES;
        
        
        if (sentModel.images.count >0) {
            WS(ws)
            __weak MiYiTagEditorImageView *weakImageView =tagEditorImageView;
            dynamicScrollView.imageRefreshBlock= ^(NSString * imageIndex ,id image)
            {
                [weakImageView removeTag];
                NSString *imageString =image;
                [weakImageView.previewsImage sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakImageView imageTagFrame:YES];
                    MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:ws.postDetailsModel.images[[imageIndex intValue]]];
                    for(int i =0 ; i<model.tags.count ;i++){
                        MiYiPostsImageTagIdsModel *tagModel = [MiYiPostsImageTagIdsModel objectWithKeyValues: model.tags[i]];
                        if (tagModel.tag_content.length!=0) {
                            [weakImageView addtagViewimageClickinit:CGPointZero isClick:NO mode:tagModel];
                        }
                    }
                }];
            
            };
        }
    }else{
        [labelContents mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tagEditorImageView.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(17);
            make.right.equalTo(self.contentView.mas_right).offset(-17);
            make.height.greaterThanOrEqualTo(@11);
        }];
        /**
         *  这里是判断是否是怎么穿帖子
         */
//        if (_postDetailsModel.images.count<=1) {
//            if (_postDetailsModel.images.count!=0) {
//                MiYiPostsImageSModel *imagesModel =[MiYiPostsImageSModel objectWithKeyValues:_postDetailsModel.images[0]];
//                if ([imagesModel.img_url isKindOfClass:[NSString class]]) {
//                    if ([imagesModel.img_url isEqualToString:@""]) {
//                        [labelContents mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.top.equalTo(labelUserName.mas_bottom).offset(25);
//                            make.left.equalTo(self.contentView.mas_left).offset(17);
//                            make.right.equalTo(self.contentView.mas_right).offset(-17);
//                            make.height.greaterThanOrEqualTo(@11);
//                        }];
//                    }
//                }
//            }
//        }
    }
    
    [viewBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.width.equalTo(@(kWindowWidth));
        make.height.equalTo(self.contentView.mas_height).offset(-6);
    }];
    
    if ([_postDetailsModel.is_like boolValue]) {
        buttonWatchList.selected=[_postDetailsModel.is_like boolValue];
        [buttonWatchList setTitle:[NSString stringWithFormat:@" %ld",(long)[_postDetailsModel.like_count integerValue]] forState:UIControlStateSelected];
    }else{
        buttonWatchList.selected=[_postDetailsModel.is_like boolValue];
        [buttonWatchList setTitle:[NSString stringWithFormat:@" %ld",(long)[_postDetailsModel.like_count integerValue]] forState:UIControlStateNormal];
    }
    NSString *commentText =[NSString stringWithFormat:@" %@",_postDetailsModel.comment_count];
    [buttonComment setTitle:commentText forState:UIControlStateNormal];
    
}

@end
