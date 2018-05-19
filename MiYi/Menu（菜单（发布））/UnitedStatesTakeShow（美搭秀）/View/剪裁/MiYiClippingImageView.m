//
//  MiYiClippingImageView.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/31.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiClippingImageView.h"


@interface MiYiClippingImageView ()

@property (nonatomic ,strong) NSMutableArray *clippingArray;

@end


@implementation MiYiClippingImageView

-(NSMutableArray *)clippingArray
{
    if (_clippingArray) {
        _clippingArray =[NSMutableArray array];
    }
    return _clippingArray;
}


-(id)initWithFrame:(CGRect)frame imageModel:(MiYiMenuSentModel *)model afterTrimming:(afterTrimmingBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        for(int i=0; i<model.images.count ;i++)
        {
//            MiYiPostsImageSModel *imagesModel = model.images[i];
//            UIImage *image =imagesModel.img_url;
//            NSData *data = nil;
//            if (UIImagePNGRepresentation(image))
//            {
//                
//            }
            
    
        }
        
        
    }
    return self;
}

@end
