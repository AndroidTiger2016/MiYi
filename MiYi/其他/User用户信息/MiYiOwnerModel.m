//
//  MiYiOwnerModel.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/20.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiOwnerModel.h"

@implementation MiYiOwnerModel
-(void)setExp_point:(NSString *)exp_point
{
    NSInteger point =[exp_point integerValue];
    if (point <200) {
        _exp_point=@"时尚新人";
    }else if (point >=200 && point <1000)
    {
        _exp_point=@"时尚追风族";
    }else if (point >=1000 && point <2000)
    {
        _exp_point=@"时尚先锋";
    }else if (point >=2000 && point <5000)
    {
        _exp_point=@"时尚达人";
    }else if (point >=5000 && point <10000)
    {
        _exp_point=@"时尚教练";
    }else if (point >=10000 && point <20000)
    {
        _exp_point=@"时尚精灵";
    }else if (point >=20000 && point <30000)
    {
        _exp_point=@"时尚魔法师";
    }else if (point >=30000 )
    {
        _exp_point=@"时尚女王";
    }
    
}

@end

@implementation MiYiPostsImageSModel

-(id)copyWithZone:(NSZone *)zone{
    MiYiPostsImageSModel *model = [MiYiPostsImageSModel allocWithZone:zone];
    model.tags =[NSMutableArray array];

    //各种属性赋值操作
    model.img_url =[self.img_url copy];
    model.tags =[self.tags copy];
    model.bounds =[self.bounds copy];
    return model;
}

-(NSMutableArray *)tag_ids
{
    if (!_tags) {
        _tags =[NSMutableArray array];
    }
    return _tags;
}
@end

@implementation MiYiPostsImageTagIdsModel
-(id)copyWithZone:(NSZone *)zone{
    MiYiPostsImageTagIdsModel *model = [MiYiPostsImageTagIdsModel allocWithZone:zone];
    
    //各种属性赋值操作
    model.tag_content =[self.tag_content copy];
    model.tag_position =[self.tag_position copy];
    model.tag_style =[self.tag_style copy];
    return model;
}

@end