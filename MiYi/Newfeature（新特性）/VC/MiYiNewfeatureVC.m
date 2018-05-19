
//
//  MiYiNewfeatureVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/24.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiNewfeatureVC.h"
#import "MiYiWelcome.h"
#define BANewfeatureImageCount 4
@interface MiYiNewfeatureVC ()

@end

@implementation MiYiNewfeatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *welcomeScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    welcomeScrollView.backgroundColor = [UIColor whiteColor];
    welcomeScrollView.showsHorizontalScrollIndicator = NO;
    welcomeScrollView.showsVerticalScrollIndicator = NO;
    welcomeScrollView.contentSize = CGSizeMake(kWindowWidth, kWindowHeight*BANewfeatureImageCount);
    welcomeScrollView.pagingEnabled = YES;
    NSArray *colorArray = [[NSArray alloc] initWithObjects:[UIColor yellowColor ], [UIColor redColor], [UIColor blueColor], [UIColor whiteColor], nil];
    for (int i = 0; i < BANewfeatureImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*kWindowHeight, kWindowWidth, kWindowHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = colorArray[i];
        [welcomeScrollView addSubview:imageView];
        if (i == BANewfeatureImageCount-1) {
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.frame = CGRectMake(kWindowWidth*0.22, kWindowHeight*i + kWindowHeight*0.8, 200, 40);
            start.layer.masksToBounds = YES;
            start.layer.cornerRadius = 40/2;
            //            start.layer.borderWidth = 0.5;
            [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [start setTitle:@"开启蜜意之行" forState:UIControlStateNormal];
            [start addTarget:self action:@selector(mainBtn) forControlEvents:UIControlEventTouchUpInside];
            start.backgroundColor = HEX_COLOR_THEME;
            [welcomeScrollView addSubview:start];
            
        }
    }
    [self.view addSubview:welcomeScrollView];
    // Do any additional setup after loading the view.
}

-(void)mainBtn
{
    MiYiWelcome *welcome =[[MiYiWelcome alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController=welcome;
    
}

-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
