//
//  MiYiWaterflowLayout.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/22.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MiYiWaterflowLayout;

@protocol MiYiWaterflowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(MiYiWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end
@interface MiYiWaterflowLayout : UICollectionViewFlowLayout
/** 每一列之间的间距 默认3*/
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 默认3*/
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 默认3*/
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<MiYiWaterflowLayoutDelegate> MiYidelegate;

@end
