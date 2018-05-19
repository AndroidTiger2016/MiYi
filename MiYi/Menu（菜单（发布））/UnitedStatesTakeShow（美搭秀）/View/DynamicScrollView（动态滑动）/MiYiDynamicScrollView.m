//
//  MiYiDynamicScrollView.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/15.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiDynamicScrollView.h"
#import <MJExtension.h>
#import "MiYiOwnerModel.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+YXL.h"
#import "MiYiPhotoLibraryViewController.h"
#import "MiYiNavViewController.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface MiYiDynamicScrollView ()


@property (nonatomic ,weak) UIScrollView *scrollView;


@property (nonatomic ,assign) BOOL isClick;

@end

@implementation MiYiDynamicScrollView

static NSInteger const imageWidth = 60;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViews =[NSMutableArray array];
    }
    return self;
}

-(id)init
{
    self =[super init];
    if (self) {
        _imageViews =[NSMutableArray array];
        
    }
    return self;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView =[[UIScrollView alloc]init];
        scrollView.backgroundColor = self.backgroundColor;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView=scrollView;
    }
    return _scrollView;
}

-(void)initImageViews
{
    if (_menuSentModel.images.count!=0) {
        for (int i = 0; i < _menuSentModel.images.count; i++) {
            MiYiPostsImageSModel *postsImageSModel = [MiYiPostsImageSModel objectWithKeyValues:_menuSentModel.images[i]];
            [self createImageViews:i withImage:postsImageSModel.img_url];
        }
    }
    //设置宽度
    self.scrollView.contentSize = CGSizeMake(_menuSentModel.images.count * imageWidth +_menuSentModel.images.count*5+5 +65, 60);
    self.scrollView.frame=(CGRect){0,0,kWindowWidth,60};
    //添加图片
    MiYiImageView *addImage=[[MiYiImageView alloc]initWithFrame:(CGRect){_menuSentModel.images.count * imageWidth +_menuSentModel.images.count*5+5 ,0,60,60}];
    addImage.image=[UIImage imageNamed:@"addImage"];
    addImage.userInteractionEnabled=YES;
    [addImage addTarget:self action:@selector(addImageClick) forControlEvents:MiYiImageViewControlEventTap];
    [self.scrollView addSubview:addImage];
    _addImage=addImage;
}

- (void)createImageViews:(int)i withImage:(id )image
{
    MiYiImageView *imgView = [[MiYiImageView alloc] init];
    id classID =image;
    //判断是url和图片
    if ([classID isKindOfClass:[NSString class]]) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
    }else
    {
        imgView.image=(UIImage *)image;
        if(!_isDeleting)
        {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
            [imgView addGestureRecognizer:longPress];
        }
        
    };
    imgView.tag=i;
    imgView.frame = CGRectMake(imageWidth*i+i*5+5, 0, imageWidth, imageWidth);
    imgView.userInteractionEnabled = YES;
    imgView.layer.masksToBounds=YES;
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [imgView addTarget:self action:@selector(imgViewClick:) forControlEvents:MiYiImageViewControlEventTap];
    if (!_isMenu) {
        if(i==0)
        {
            imgView.layer.borderWidth=3;
            imgView.layer.borderColor=HEX_COLOR_THEME.CGColor;
        }
    }
    [self.scrollView addSubview:imgView];
    [self.imageViews addObject:imgView];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setHidden:YES];
    deleteButton.frame = CGRectMake(imageWidth-25, -5, 30, 30);
    [imgView addSubview:deleteButton];
}

-(void)removeUI{
    [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MiYiImageView *image =obj;
        [image removeFromSuperview];
    }];
    [self.imageViews removeAllObjects];
    [_addImage removeFromSuperview];
}

//长按调用的方法
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {//长按开始
        _isDeleting = !_isDeleting;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                imageView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
        for (UIImageView *imageView in self.imageViews) {
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (_isDeleting) {
                deleteButton.hidden = NO;
            } else {
                deleteButton.hidden = YES;
            }
        }
        
    }
    
}
//隐藏按钮
-(void)deleteHidden
{
    _isDeleting =NO;
    for (UIImageView *imageView in self.imageViews) {
        UIButton *deleteButton = (UIButton *)imageView.subviews[0];
        if (_isDeleting) {
            deleteButton.hidden = NO;
        } else {
            deleteButton.hidden = YES;
        }
    }
}

- (void)deleteAction:(UIButton *)button
{
    
    if (!_isMenu) {
        //当需要边框的时候 就必须要留一张 ，因为不需要边框的是不需要选中
        if(self.imageViews.count==1)
        {
            [MBProgressHUD showError:@"不能删除哦，最少也要留一张滴"];
            return;
        }
    }
    if (_isClick) {
        
        return;
    }
    
    _isDeleting = YES;   //正处于删除状态
    _isClick =YES;
    MiYiImageView *imageView = (MiYiImageView *)button.superview;
    __block int index = (int)[self.imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = self.scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = (int)index + 1; i < self.imageViews.count; i++) {
                MiYiImageView *otherImageView = self.imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
            _addImage.frame =(CGRect){(self.imageViews.count * imageWidth +self.imageViews.count*5+5)-65,0,60,60};
            
        } completion:^(BOOL finished) {
            _isClick =NO;
            [self.imageViews removeObject:imageView];
            [_menuSentModel.images removeObjectAtIndex:index];
            if (!_isMenu) {
                if (self.imageViews.count!=0) {
                    MiYiImageView*tagImage=nil;
                    BOOL isTag =NO;
                    for (int i =0; i<self.imageViews.count; i++) {
                        tagImage = (MiYiImageView*)self.imageViews[i];
                        if (tagImage.layer.borderWidth==3) {
                            isTag =YES;
                        }
                    }
                    if (!isTag) {
                        tagImage = (MiYiImageView*)self.imageViews[0];
                        tagImage.layer.borderColor=HEX_COLOR_THEME.CGColor;
                        tagImage.layer.borderWidth=3;
                        MiYiPostsImageSModel *postsImageSModel = _menuSentModel.images[0];
                        //删除后回调将选中给予第一张图
                        if (_imageRefreshBlock) {
                            _imageRefreshBlock([NSString stringWithFormat:@"%d",0],(UIImage *)postsImageSModel.img_url);
                        }
                        
                    }
                    
                }
            }
            if (self.imageViews.count > 2) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakScroll.contentSize = CGSizeMake((imageWidth*self.imageViews.count+self.imageViews.count*5+5)+65, self.scrollView.frame.size.height);
                }];
                
            }
        }];
    }];
}

/**
 *  图片点击选中的加上边框或切换图片
 *
 */
-(void)imgViewClick:(MiYiImageView *)img
{
    if (!_isMenu) {
        [self deleteHidden];
        MiYiImageView*tagImage=nil;
        BOOL isTag =NO;
        for (int i =0; i<self.imageViews.count; i++) {
            tagImage = (MiYiImageView*)self.imageViews[i];
            if (tagImage.layer.borderWidth==3) {
                if(img.tag ==tagImage.tag)
                {
                    isTag =YES;
                }else
                {
                    tagImage.layer.borderWidth=0;
                }
            }
        }
        if (!isTag) {
            
            int index=0;
            if([self.imageViews containsObject:img])
            {
                index= (int)[self.imageViews indexOfObject:img];
                img.layer.borderColor=HEX_COLOR_THEME.CGColor;
                img.layer.borderWidth=3;
                
                MiYiPostsImageSModel *postsImageSModel = [MiYiPostsImageSModel objectWithKeyValues:_menuSentModel.images[index]];
                id classID =postsImageSModel.img_url;
                //点击后回调将选中
                if ([classID isKindOfClass:[NSString class]]) {
                    
                    if (_imageRefreshBlock) {
                        _imageRefreshBlock([NSString stringWithFormat:@"%d",index],postsImageSModel.img_url);
                    }
                    
                }else
                {
                    if (_imageRefreshBlock) {
                        _imageRefreshBlock([NSString stringWithFormat:@"%d",index],postsImageSModel.img_url);
                    }
                }
                
            }
        }
    }
}

/**
 *  <#Description#>
 */
-(void)setMenuSentModel:(MiYiMenuSentModel *)menuSentModel
{
    if (menuSentModel ==nil) {
        menuSentModel=[[MiYiMenuSentModel alloc]init];
    }
    _menuSentModel=menuSentModel;
    [self initImageViews];
}

////添加一个新图片
- (void)addImageClick
{
    [self deleteHidden];
    if (self.imageViews.count >=9) {
        [MBProgressHUD showError:@"只能选择9张哦"];
        return;
    }
    MiYiPhotoLibraryViewController *vc =[[MiYiPhotoLibraryViewController alloc]init];
    MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
    vc.classString =[self class];
    vc.blockSelect=^(NSMutableArray *selectArray)
    {
        
        for (int i=0; i<self.imageViews.count; i++) {
            MiYiImageView *image =(MiYiImageView*)self.imageViews[i];
            [image removeFromSuperview];
        }
        
        [self.imageViews removeAllObjects];
        [_addImage removeFromSuperview];
        for (int i = 0; i < selectArray.count; i++)
        {
            ALAsset *set =selectArray[i];
            CGImageRef ref = [[set  defaultRepresentation]fullResolutionImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            MiYiPostsImageSModel  *postsImageSModel =[[MiYiPostsImageSModel alloc]init];
            postsImageSModel.img_url=img;
            [_menuSentModel.images addObject:postsImageSModel];
        }
        
        [self initImageViews];
        
        if (self.imageViews.count > 4) {
            [self.scrollView setContentOffset:CGPointMake((self.imageViews.count-4)*imageWidth, 0) animated:YES];
        }
        
        if (!_isMenu) {
            MiYiPostsImageSModel *postsImageSModel = _menuSentModel.images[0];
            if (_imageRefreshBlock) {
                _imageRefreshBlock([NSString stringWithFormat:@"%d",0],postsImageSModel.img_url);
            }
        }
        
        
    };
    vc.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    vc.maxSelectCount=9-self.imageViews.count;
    
    [self.viewController presentViewController:nav animated:YES completion:nil];
    
}

-(void)dealloc
{
    [Notification removeObserver:self];
}


@end
