//
//  MiYiPhotosView.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/9.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPhotosView.h"
#import <UIImageView+WebCache.h>
#import "MiYiOwnerModel.h"
#import <MJExtension.h>
@implementation MiYiPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化9个子控件
        for (int i = 0; i<9; i++) {
            UIImageView *photoView = [[UIImageView alloc] init];
            photoView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
            photoView.userInteractionEnabled = YES;
            photoView.tag = i;
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
//            photoView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
//            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
            [self addSubview:photoView];
        }
    }
    return self;
}


- (void)setPhotos:(NSArray *)photos{
    
    _photos = photos;
    for (int i = 0; i<self.subviews.count; i++) {
        UIImageView *photoView = self.subviews[i];
        if (i < photos.count) {
            photoView.hidden = NO;
            MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:photos[i]];
            if (model.img_url==nil) {
                return;
            }
            [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@180x180.jpg",[model.img_url substringToIndex:[model.img_url length]-4]]] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
            int maxColumns = (photos.count == 4) ? 2 : 3;
            int col = i % maxColumns;
            int row = i / maxColumns;
            CGFloat photoX = col * (70 + 10);
            CGFloat photoY = row * (70 + 10);
            photoView.frame = CGRectMake(photoX, photoY, 70, 70);
            
        } else { // 隐藏imageView
            photoView.hidden = YES;
        }
    }
}
+ (CGSize)photosViewSizeWithPhotosCount:(NSInteger)count
{
    // 一行最多有3列
    NSInteger maxColumns = (count == 4) ? 2 : 3;
    
    //  总行数
    NSInteger rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * 70 + (rows - 1) * 10;
    // 总列数
    NSInteger cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * 70 + (cols - 1) * 10;
    
    return CGSizeMake(photosW, photosH);

}


@end
