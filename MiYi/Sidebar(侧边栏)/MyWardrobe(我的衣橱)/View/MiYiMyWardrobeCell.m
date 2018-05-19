//
//  MiYiMyWardrobeCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/13.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMyWardrobeCell.h"
#import "MiYiRecommendImageView.h"

@interface MiYiMyWardrobeCell ()

@property (nonatomic ,weak) MiYiRecommendImageView *recommendImage;
@end

@implementation MiYiMyWardrobeCell


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        MiYiRecommendImageView *recommendImage=[[MiYiRecommendImageView alloc]init];
        [self addSubview:recommendImage];
        _recommendImage=recommendImage;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(MiYiRecommendModel *)model
{
    _model=model;
    
    _recommendImage.frame=self.bounds;
    _recommendImage.model=_model;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    
}
@end
