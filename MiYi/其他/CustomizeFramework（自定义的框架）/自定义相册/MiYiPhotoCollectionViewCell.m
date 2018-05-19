//
//  MiYiPhotoCollectionViewCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPhotoCollectionViewCell.h"

@implementation MiYiPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _maskView.backgroundColor=HEX_COLOR_THEME;
}

- (void)setPhotoSelect:(BOOL)photoSelect
{
    if (_photoSelect == photoSelect) {
        return;
    }
    _photoSelect = photoSelect;
    self.selectedView.hidden =!_photoSelect;
   
    
}
@end
