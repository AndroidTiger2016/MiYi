//
//  MiYiPhotoLibraryHeader.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPhotoLibraryHeader.h"
#import "UIImage+MiYi.h"

@interface MiYiPhotoLibraryHeader ()

@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UIImageView * arrowImageView;
@property (nonatomic, strong) UIImageView * themeMaskView;

@end

@implementation MiYiPhotoLibraryHeader

- (void)_setDefaultPhotoLibraryHeader
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    WS(ws);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker * make)
     {
         make.center.equalTo(ws);
         make.size.mas_equalTo(titleLabel.frame.size);
     }];
    
    UIImageView * arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropDown"]];
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker * make)
     {
         make.centerY.equalTo(ws);
         make.size.mas_equalTo(arrowImageView.frame.size);
         make.left.equalTo(titleLabel.mas_right).mas_equalTo(5);
     }];
    
    UIImageView * maskView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:maskView];
    maskView.image = nil;
    maskView.layer.cornerRadius = 5;
    maskView.layer.masksToBounds = YES;
    maskView.highlightedImage = [UIImage createImageWithColor:[UIColor redColor]];
    [self addSubview:maskView];
    self.themeMaskView = maskView;
    [maskView mas_makeConstraints:^(MASConstraintMaker * make)
     {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
     }];
    
    [self addTarget:self action:@selector(touchUpAction) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setDefaultPhotoLibraryHeader];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setDefaultPhotoLibraryHeader];
    }
    return self;
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (_on == on) {
        return;
    }
    _on = on;
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
    }
    if (_on) {
        self.arrowImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 * 2);
        //        self.themeMaskView.highlighted = YES;
    }else
    {
        self.arrowImageView.transform = CGAffineTransformIdentity;
        //        self.themeMaskView.highlighted = NO;
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)touchUpAction
{
    [self setOn:!_on animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    self.titleLabel.text = _title;
    [self.titleLabel sizeToFit];
    CGSize size = self.titleLabel.frame.size;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker * make)
     {
         make.size.mas_equalTo(size);
     }];
}

@end
