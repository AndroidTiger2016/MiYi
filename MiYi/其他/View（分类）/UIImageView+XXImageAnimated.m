//
//  UIImageView+XXImageAnimated.h
//  XXKit
//
//  Created by Shawn on 12/6/9.
//  Copyright (c) 2015年 Shawn. All rights reserved.
//

#import "UIImageView+XXImageAnimated.h"
#import <objc/runtime.h>
@interface UIImageView ()

//@property (nonatomic ,strong) NSIndexPath *indexpath;

@end

@implementation UIImageView (XXImageAnimated)


//-(void)setAnimationBlock:(void (^)(NSIndexPath *))animationBlock
//{
//    objc_setAssociatedObject(self, @selector(animationBlock), animationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//-(void (^)(NSIndexPath *))animationBlock
//{
//    return objc_getAssociatedObject(self, @selector(animationBlock));
//}
//
//- (void)setIndexpath:(NSIndexPath *)indexpath
//{
//    objc_setAssociatedObject(self, @selector(indexpath), indexpath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSIndexPath *)indexpath
//{
//    return objc_getAssociatedObject(self, @selector(indexpath));
//}


- (void)setImage:(UIImage *)image animation:(XXImageAnimation)type
{
//    if ([image isEqual:self.image]) {
//        return;
//    }
    
    [self setImage:image];
    CATransition *animation = [CATransition animation];
    animation.delegate=self;
    [animation setDuration:0.45];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    switch (type) {
            case XXImageAnimationFade:
            [animation setType:@"fade"];
            break;
        case XXImageAnimationEffect:
            [animation setType:@"rippleEffect"];
            break;
        case XXImageAnimationFlip:
            [animation setType:@"oglFlip"];
            break;
        case XXImageAnimationPageCurl:
            [animation setType:@"pageCurl"];
            break;
        case XXImageAnimationPageUnCurl:
            [animation setType:@"pageUnCurl"];
            break;
        case XXImageAnimationCube:
            [animation setType:@"cube"];
            break;
        case XXImageAnimationSuckEffect:
            [animation setType:@"suckEffect"];
            break;
        default:
            break;
    }
    [animation setSubtype: kCATransitionFromBottom];
    [self.layer addAnimation:animation forKey:@"setImage"];
}

- (void)setImage:(UIImage *)image animated:(BOOL)animated
{
    if (animated && image != nil) {
        [self setImage:image animation:XXImageAnimationFade];
        
    }else
        self.image = image;
}


@end
