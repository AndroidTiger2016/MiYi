//
//  MiYiCamera.h
//  Camera
//
//  Created by 叶星龙 on 15/7/20.
//  Copyright (c) 2015年 叶星龙. All rights reserved.
//

#import "MiYiBaseViewController.h"
@class MiYiCamera;

@protocol MiYiCameraDelegate <NSObject>

- (void)cameraImage:(UIImage *)image;

@end

@interface MiYiCamera : MiYiBaseViewController


@property (nonatomic, weak) id<MiYiCameraDelegate>delegate;
@end
