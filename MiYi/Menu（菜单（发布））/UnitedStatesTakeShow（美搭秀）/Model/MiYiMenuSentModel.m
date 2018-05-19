//
//  MiYiMenuSentModel.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/29.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMenuSentModel.h"


@implementation MiYiMenuSentModel

-(id)copyWithZone:(NSZone *)zone{
    MiYiMenuSentModel *model = [MiYiMenuSentModel allocWithZone:zone];
    //各种属性赋值操作
    model.content =[self.content copy];
    
    for (int i=0; i<self.images.count; i++) {
        MiYiPostsImageSModel *mode1 =self.images[i];
        [model.images addObject:[mode1 copy]];
        
    }
    
    
    
    model.location =[self.location copy];
    return model;
}

-(NSMutableArray *)images{
    if(!_images )
    {
        _images =[NSMutableArray array];
    }
        return _images;
}

@end
