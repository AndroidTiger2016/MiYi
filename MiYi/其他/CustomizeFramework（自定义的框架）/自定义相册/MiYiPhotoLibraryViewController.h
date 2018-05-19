//
//  MiYiPhotoLibraryViewController.h
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiBaseViewController.h"




@interface MiYiPhotoLibraryViewController : MiYiBaseViewController

//title
@property (nonatomic ,strong) NSString *stringTitle;





//判断从哪个控制器出来的
@property (nonatomic ,strong) Class classString;

//这个是
@property (nonatomic , copy) void (^blockSelect)(NSMutableArray *selectArray);

//限制选择数量
@property (nonatomic) NSInteger maxSelectCount;
@end
