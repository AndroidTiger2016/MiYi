//
//  UIImageView+XXImageAnimated.h
//  XXKit
//
//  Created by Shawn on 12/6/9.
//  Copyright (c) 2015年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XXImageAnimationFade = 0,
    XXImageAnimationPageCurl,
    XXImageAnimationPageUnCurl,
    XXImageAnimationFlip,
    XXImageAnimationEffect,
    XXImageAnimationCube,
    XXImageAnimationSuckEffect
}XXImageAnimation;


@interface UIImageView (XXImageAnimated)

- (void)setImage:(UIImage *)image animated:(BOOL)animated;

- (void)setImage:(UIImage *)image animation:(XXImageAnimation)type;


//@property (nonatomic ,copy) void (^animationBlock)(NSIndexPath *indexpath);

@end
