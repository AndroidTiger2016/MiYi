//
//  MiYiRecommendClothesView.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/9.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiRecommendClothesView.h"
#import "MiYiOwnerModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "MiYiRecommendImageView.h"
#import "MiYiProductDetailsVC.h"
@interface MiYiRecommendClothesView ()
{
    NSMutableArray *imageArray;
    NSMutableArray *labelArray;
    int groupInt;
    UIView *viewTop;
    UIButton *buttonReplaced;
    UIButton *buttonTitle;
    MiYiRecommendImageView *photoView;
}


@end

@implementation MiYiRecommendClothesView


-(id)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

-(void)configView{
    groupInt =0;
    imageArray =[NSMutableArray array];
    labelArray =[NSMutableArray array];
    
    viewTop =[UIView new];
    viewTop.backgroundColor=[UIColor whiteColor];
    [self addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 44));
    }];
    
    buttonReplaced =[self getButtonReplaced];
    [buttonReplaced addTarget:self action:@selector(clickButtonReplaced) forControlEvents:UIControlEventTouchUpInside];
    [buttonReplaced sizeToFit];
    [viewTop addSubview:buttonReplaced];
    [buttonReplaced mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewTop.mas_centerY);
        make.right.equalTo(viewTop.mas_right).offset(-27);
        make.size.mas_equalTo(CGSizeMake(CGWidth(buttonReplaced.frame), CGHeight(buttonReplaced.frame)));
    }];
    
    buttonTitle = [self getButtonTitle];
    [buttonTitle sizeToFit];
    [viewTop addSubview:buttonTitle];
    [buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewTop.mas_centerY);
        make.left.equalTo(@15);
        make.width.greaterThanOrEqualTo(@(CGWidth(buttonTitle.frame)));
        make.height.equalTo(@(CGHeight(buttonTitle.frame)));
    }];
    
    for (int i = 0; i<6; i++) {
        photoView = [self getPhotoView];
        photoView.tag = i;
        photoView.hidden=YES;
        [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
        [self addSubview:photoView];
        [imageArray addObject:photoView];
        int maxColumns = 3;
        int col = i % maxColumns;
        int row = i / maxColumns;
        CGFloat photoX = col * ((kWindowWidth-40)/3 + 10)+10;
        CGFloat photoY = row * ((kWindowWidth-40)/3 + 10)+44;
        [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(photoX);
            make.top.equalTo(self.mas_top).offset(photoY);
            make.size.mas_equalTo(CGSizeMake((kWindowWidth-40)/3, (kWindowWidth-40)/3));
        }];
    }

}
+ (CGSize)photosViewSizeWithPhotosCount:(NSInteger)count
{
    int maxColumns = 3;
    //  总行数
    NSInteger rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * ((kWindowWidth-40)/3 + 10) + (rows - 1) * 10;
    // 总列数
    NSInteger cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * ((kWindowWidth-40)/3 + 10) + (cols - 1) * 10;
    
    return CGSizeMake(photosW, photosH);
    
}
#pragma -Mark 点击
-(void)clickButtonReplaced{
    for (int i = 0; i <6; i++) {
        photoView = imageArray[i];
        if (i+groupInt < _photos.count) {
            photoView.hidden = NO;
            MiYiRecommendModel *model =_photos[i+groupInt];
            photoView.model=model;
        } else { // 隐藏imageView
            photoView.hidden = YES;
        }
    }
    if (groupInt >= _photos.count){
        groupInt=0;
    }else if (groupInt +6 <_photos.count){
        groupInt+=6;
    }else if (groupInt +6 >=_photos.count){
        groupInt=0;
    }
}

#pragma  -Mark set
-(void)setPhotos:(NSArray *)photos
{
    _photos=photos;
    [buttonTitle setTitle:@" 同款推荐" forState:UIControlStateNormal];
    [self clickButtonReplaced];
}

-(void)photoTap:(UITapGestureRecognizer *)tap
{
    photoView =(MiYiRecommendImageView *)tap.view;
    MiYiProductDetailsVC *vc =[[MiYiProductDetailsVC alloc]init];
    vc.model=photoView.model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(MiYiRecommendImageView *)getPhotoView{
    MiYiRecommendImageView *image =[MiYiRecommendImageView new];
    image.userInteractionEnabled = YES;
    image.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    return image;
}

-(UIButton *)getButtonReplaced{
    UIButton *btn =[UIButton new];
    [btn setImage:[UIImage imageNamed:@"RefreshBtn"] forState:UIControlStateNormal];
    return btn;
}

-(UIButton *)getButtonTitle{
    UIButton *btn =[[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"Recommend"] forState:UIControlStateNormal];
    btn.titleLabel.font=Font(14);
    [btn setTitle:@" 同款推荐" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return btn;
}
@end
