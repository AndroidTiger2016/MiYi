//
//  MiYiAssetPreviewView.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiAssetPreviewView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MiYiAssetPreviewView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) NSThread * thread;

@end

@implementation MiYiAssetPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3.;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        self.imageView = imageView;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)doubleTap
{
    if (self.scrollView.zoomScale == 1.) {
        [self.scrollView setZoomScale:2. animated:YES];
    }else
        [self.scrollView setZoomScale:1. animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)reuse
{
    [self.thread cancel];
    self.thread = nil;
    self.imageView.image = nil;
    self.scrollView.zoomScale = 1.;
}

- (void)setSet:(ALAsset *)set
{
    if ([_set isEqual:set]) {
        return;
    }
    [self reuse];
    _set = set;
    NSURL * url = [[set defaultRepresentation]url];
    UIImage * tempImg = [self.cache objectForKey:url];
    if (tempImg) {
        self.imageView.image = tempImg;
    }else
    {
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(handleImage:) object:_set];
        [thread start];
        self.thread = thread;
    }
}


- (void)handleImage:(ALAsset *)set
{
    @autoreleasepool {
        ALAssetRepresentation * representation = [set defaultRepresentation];
        UIImage * image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:representation.scale orientation:(UIImageOrientation)[representation orientation]];
        [self.cache setObject:image forKey:representation.url];
        if ([self.set isEqual:set]&& [[NSThread currentThread]isCancelled] == NO) {
            [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.zoomScale = 1.;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
@end
