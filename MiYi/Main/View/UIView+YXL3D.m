//
//  UIView+YXL3D.m
//  Plague
//
//  Created by Yexinglong on 15/1/8.
//  Copyright (c) 2015年 Yexinglong. All rights reserved.
//

#import "UIView+YXL3D.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (YXL3D)
- (void)setYRotation:(CGFloat)degrees anchorPoint:(CGPoint)point perspectiveCoeficient:(CGFloat)m34 scale:(float)scale Zposition:(float)z
{
    CATransform3D transfrom = CATransform3DMakeScale(scale, scale, 1.);
    transfrom.m34 = 1.0 / m34;
//    NSLog(@"%f",degrees);
    
    CGFloat radiants = degrees / 360.0 * 2 * M_PI;
    transfrom = CATransform3DRotate(transfrom, radiants, 0, 1.f, 0.0f);
    
    CALayer *layer = self.layer;
    layer.zPosition = z;
    layer.anchorPoint = point;
    layer.transform = transfrom;
//    layer.masksToBounds=YES;
}

- (void)setYRotation:(CGFloat)degrees
{
    
   
}

- (void)setProgess:(float)progress degrees:(float)degrees Zposition:(float)z
{
    
    
     [self setYRotation:degrees anchorPoint:CGPointMake(0.5, 0.5) perspectiveCoeficient:800 scale:progress Zposition:z];
}

@end
