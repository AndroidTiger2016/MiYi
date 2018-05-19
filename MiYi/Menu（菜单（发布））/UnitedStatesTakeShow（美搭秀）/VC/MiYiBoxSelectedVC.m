//
//  MiYiBoxSelectedVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/31.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//
//#define SHOW_PREVIEW YES

#import "MiYiBoxSelectedVC.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface MiYiBoxSelectedVC ()<UITableViewDelegate>


@property (nonatomic, weak) BJImageCropper *imageCropper;


@end

@implementation MiYiBoxSelectedVC


#pragma mark - View lifecycle

- (void)updateDisplay {
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@",NSStringFromCGRect(self.imageCropper.crop)]);
    if (_SHOW_PREVIEW) {
        self.preview.image = [self.imageCropper getCroppedImage];
        self.preview.frame = CGRectMake(10,10,self.imageCropper.crop.size.width * 0.2, self.imageCropper.crop.size.height * 0.2);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;
    
    CGFloat H=0;
    H =kWindowHeight-64;
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    
    BJImageCropper*imageCropper = [[BJImageCropper alloc] initWithImage:_model.img_url andMaxSize:CGSizeMake(kWindowWidth, H)];
    [self.view addSubview:imageCropper];
    imageCropper.center = CGPointMake(kWindowWidth/2, H/2);
//    imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    imageCropper.imageView.layer.shadowRadius = 3.0f;
//    imageCropper.imageView.layer.shadowOpacity = 0.8f;
//    imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    _imageCropper=imageCropper;
    [imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    if (_SHOW_PREVIEW) {
        UIImageView*preview = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,self.imageCropper.crop.size.width * 0.2, self.imageCropper.crop.size.height * 0.2)];
        preview.image = [self.imageCropper getCroppedImage];
        preview.clipsToBounds = YES;
        preview.layer.borderColor = [[UIColor whiteColor] CGColor];
        preview.layer.borderWidth = 2.0;
        preview.layer.shadowColor = [[UIColor blackColor] CGColor];
        preview.layer.shadowRadius = 3.0f;
        preview.layer.shadowOpacity = 0.8f;
        preview.layer.shadowOffset = CGSizeMake(1, 1);
        [self.view addSubview:preview];
        _preview=preview;
    }
    
    
    [self updateDisplay];
    // Do any additional setup after loading the view.
}

-(void)navItemClick
{
    
    
    NSString *string =[NSString stringWithFormat:@"%f,%f,%f,%f",CGOriginX(self.imageCropper.crop),CGOriginY(self.imageCropper.crop),CGWidth(self.imageCropper.crop),CGHeight(self.imageCropper.crop)];
    _model.bounds =string;
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [self setImageCropper:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)dealloc
{
    [self.imageCropper removeObserver:self
                           forKeyPath:@"crop"];
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
