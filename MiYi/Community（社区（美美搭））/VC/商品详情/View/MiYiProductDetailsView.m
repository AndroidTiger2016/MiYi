//
//  MiYiProductDetailsView.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiProductDetailsView.h"
#import <UIImageView+WebCache.h>
#import "MiYiProductDetailsWebView.h"
#import "MiYiWardrobeRequest.h"
#import "MBProgressHUD+YXL.h"
@interface MiYiProductDetailsView ()

/**
 *  图片
 */
@property (nonatomic ,weak) UIImageView *imageView;
/**
 *  内容
 */
@property (nonatomic ,weak) UILabel *contents;
/**
 *  价格
 */
@property (nonatomic ,weak) UILabel *money;
/**
 *  品牌
 */
@property (nonatomic ,weak) UIImageView *brandImageView;
/**
 *  购买
 */
@property (nonatomic ,weak) UIButton *purchase;
/**
 *  收藏
 */
@property (nonatomic ,weak) UIButton *praiseBtn;
/**
 *  评论
 */
@property (nonatomic ,weak) UIButton *commentBtn;


@end

@implementation MiYiProductDetailsView

-(instancetype)init
{
    self =[super init];
    if (self) {
        UIImageView *imageView =[[UIImageView alloc]init];
        _imageView=imageView;
        
        UILabel *contents =[[UILabel alloc]init];
        _contents=contents;
        
        UILabel *money=[[UILabel alloc]init];
        _money=money;
        
        UIImageView *brandImageView=[[UIImageView alloc]init];
        _brandImageView=brandImageView;
        
        UIButton *purchase=[[UIButton alloc]init];
        _purchase=purchase;
        
        UIButton *praiseBtn=[[UIButton alloc]init];
        _praiseBtn=praiseBtn;
        
        UIButton *commentBtn=[[UIButton alloc]init];
        _commentBtn=commentBtn;
        
        
        [self addSubview:imageView];
        [self addSubview:contents];
        [self addSubview:money];
        [self addSubview:brandImageView];
        [self addSubview:purchase];
        [self addSubview:praiseBtn];
        [self addSubview:commentBtn];
        
       [praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside]; 
        
    }
    return self;
}
-(void)praiseBtnClick:(UIButton *)btn
{
    
    
    if(btn.selected)
    {
        [MiYiWardrobeRequest wardrobeWatchList:_model.ID success:^(BOOL success) {
            
            if (success) {
                [MBProgressHUD showSuccess:@"取消收藏"];
                btn.selected =NO;
                _model.is_like=@"0";
                NSString *likeCount =[NSString stringWithFormat:@" %ld",(long)[_model.like_count integerValue]-1];
                _model.like_count=likeCount;
                [btn setTitle:likeCount forState:UIControlStateNormal];
                
            }else
            {
                [MBProgressHUD showError:@"貌似失败了哦~~"];
            }
            
        }];
        
    }else
    {
        [MiYiWardrobeRequest wardrobeWatchList:_model.ID success:^(BOOL success) {
            if (success) {
                [MBProgressHUD showSuccess:@"收藏成功"];
                btn.selected=YES;
                _model.is_like=@"1";
                NSString *likeCount =[NSString stringWithFormat:@" %ld",(long)[_model.like_count integerValue]+1];
                _model.like_count=likeCount;
                [btn setTitle:likeCount forState:UIControlStateSelected];
                
            }else
            {
                [MBProgressHUD showError:@"貌似失败了哦~~"];
            }
            
        }];
    }
}


-(void)setModel:(MiYiRecommendModel *)model
{
    _model=model;
    
    _imageView.frame =(CGRect){0,0,kWindowWidth,kWindowWidth};
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.path_url] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds=YES;
    
    CGRect contentRect = [_model.title boundingRectWithSize:CGSizeMake(kWindowWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(13),NSFontAttributeName, nil] context:nil];

    _contents.frame =(CGRect){{10,CGRectGetMaxY(_imageView.frame)+10},contentRect.size};
    _contents.font=Font(13);
    _contents.numberOfLines=2;
    _contents.text=_model.title;
    
    
    NSString *moneyText=nil;
    if ([_model.currency isEqualToString:@"1"]) {
        moneyText =[NSString stringWithFormat:@"￥%@",_model.price];
        
    }else if ([_model.currency isEqualToString:@"2"])
    {
        moneyText =[NSString stringWithFormat:@"$%@",_model.price];
    }
    CGSize moneySize =[moneyText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(18),NSFontAttributeName, nil]];
    _money.frame=(CGRect){{10,CGRectGetMaxY(_contents.frame)+20},moneySize};
    _money.font=Font(18);
    _money.text=moneyText;
    
    UIImage *brandImage =nil;
    if ([_model.source isEqualToString:@"1"]) {
        brandImage =[UIImage imageNamed:@"recommendJD"];
    }else if ([_model.source isEqualToString:@"2"])
    {
        brandImage =[UIImage imageNamed:@"recommendYMX"];
    }else if ([_model.source isEqualToString:@"3"])
    {
        brandImage =[UIImage imageNamed:@"recommendMLS"];
    }
    
    _brandImageView.image=brandImage;
    [_brandImageView sizeToFit];
    _brandImageView.frame=(CGRect){{CGRectGetMaxX(_money.frame) +5,CGRectGetMaxY(_money.frame)-brandImage.size.height-2},_brandImageView.frame.size};
    
    
    
    
    _purchase.frame=(CGRect){kWindowWidth -80-10, CGRectGetMaxY(_contents.frame)+20,80,30};
    _purchase.backgroundColor=HEX_COLOR_THEME;
    [_purchase setTitle:@"购买" forState:UIControlStateNormal];
    [_purchase addTarget:self action:@selector(purchaseClick) forControlEvents:UIControlEventTouchUpInside];
    _purchase.titleLabel.font=Font(16);
    _purchase.layer.masksToBounds=YES;
    _purchase.layer.cornerRadius=30/2;
    
    
    NSString *commentText =[NSString stringWithFormat:@" %ld",(long)[_model.comment_count integerValue]];
    
    [_commentBtn setTitle:commentText forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font=Font(13);
    [_commentBtn sizeToFit];
    _commentBtn.frame=(CGRect){{kWindowWidth-_commentBtn.frame.size.width-10,CGRectGetMaxY(_purchase.frame)+20},_commentBtn.frame.size};
    
    NSString *praiseText =[NSString stringWithFormat:@" %ld",(long)[_model.like_count integerValue]];
    [_praiseBtn setTitle:praiseText forState:UIControlStateNormal];
    [_praiseBtn setTitle:praiseText forState:UIControlStateSelected];
    [_praiseBtn setImage:[UIImage imageNamed:@"wardrobe"] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"wardrobe_Selected"] forState:UIControlStateSelected];
    [_praiseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _praiseBtn.titleLabel.font=Font(13);
    [_praiseBtn sizeToFit];
    _praiseBtn.frame =(CGRect){{CGOriginX(_commentBtn.frame)-CGWidth(_praiseBtn.frame)-10,CGOriginY(_commentBtn.frame)},_praiseBtn.frame.size};
    if([_model.is_like isEqualToString:@"1"])
    {
        _praiseBtn.selected=YES;
    }
    
   
}

-(void)purchaseClick
{
    MiYiProductDetailsWebView *vc =[[MiYiProductDetailsWebView alloc]init];
    vc.url=_model.from_url;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
