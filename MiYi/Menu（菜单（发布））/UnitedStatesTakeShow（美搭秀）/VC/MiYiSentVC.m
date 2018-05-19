//
//  MiYiSentVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/28.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiSentVC.h"
#import "MiYiPostsRequest.h"
#import "MiYiUserRequest.h"
#import <MJExtension.h>
#import "MBProgressHUD+YXL.h"
#import "MiYiTextView.h"
#import "MiYiDynamicScrollView.h"
#import "MiYiNavViewController.h"
#import "MiYiLoginVC.h"
#import "MiYiUserSession.h"
#import "AJLocationManager.h"
#import "MiYiUser.h"
@interface MiYiSentVC ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UIView *viewBG;
    MiYiTextView *textViewSent;
    UILabel *labelStatus;
    MiYiDynamicScrollView *dynamicScrollView;
    UIView *locationBG;
    UILabel *labelLocationTitle;
    UISwitch *switchLocation;
    NSString *stringLocationCorrrdinate;
    UIActivityIndicatorView *activityIndlcator;
    BOOL switchBOOL;
}

@property (nonatomic ,assign) NSInteger arrayCount;

@property (nonatomic ,strong) MiYiMenuSentModel *modelCopy;



@end

@implementation MiYiSentVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    _arrayCount = 0;
    
    [self initUI];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;
    
}

-(void)back:(id)sender
{
    _dynamicRefreshBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI
{
    viewBG = [self getViewBG];
    [self.view addSubview:viewBG];
    [viewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@230);
    }];
    
    
    textViewSent = [self getTextViewSent];
    [viewBG addSubview:textViewSent];
    [textViewSent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@150);
    }];
    
    labelStatus = [self getLabelStatus];
    [textViewSent addSubview:labelStatus];
    [labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.bottom.equalTo(textViewSent.mas_bottom).offset(-12);
        make.height.equalTo(@11);
        make.width.greaterThanOrEqualTo(@30);
    }];
    

    dynamicScrollView = [MiYiDynamicScrollView new];
    dynamicScrollView.menuSentModel=_model;
    dynamicScrollView.viewController=self;
    dynamicScrollView.addImage.hidden=YES;
    [viewBG addSubview:dynamicScrollView];
    [dynamicScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textViewSent.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@60);
    }];
   
    
    locationBG = [UIView new];
    locationBG.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:locationBG];
    [locationBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBG.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    labelLocationTitle = [self getLabelLocationTitle];
    [locationBG addSubview:labelLocationTitle];
    [labelLocationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationBG);
        make.left.equalTo(@15);
        make.height.equalTo(@15);
        make.width.greaterThanOrEqualTo(@50);
    }];
    
    switchLocation = [self getSwitchLocation];
    [switchLocation addTarget:self action:@selector(clickSwitchLocation:) forControlEvents:UIControlEventValueChanged];
    [locationBG addSubview:switchLocation];
    [switchLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationBG);
        make.right.equalTo(@(-15));
        make.width.greaterThanOrEqualTo(@51);
        make.height.greaterThanOrEqualTo(@31);
    }];
    
    activityIndlcator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndlcator.hidden=YES;
    [locationBG addSubview:activityIndlcator];
    [activityIndlcator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationBG);
        make.right.equalTo(switchLocation.mas_left);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
 
    
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied != status || kCLAuthorizationStatusRestricted != status){
        switchLocation.on=YES;
        switchBOOL=YES;
        [self location:switchLocation];
    }
}

-(void)clickSwitchLocation:(UISwitch *)sw{
    [self location:sw];
}
-(void)location:(UISwitch *)sw{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                      message:@"您的定位没有打开哦！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        sw.on=NO;
    }else{
        if (sw.on) {
            sw.on=YES;
            activityIndlcator.hidden=NO;
            switchBOOL=YES;
            [activityIndlcator startAnimating];
            [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                activityIndlcator.hidden=YES;
                [activityIndlcator stopAnimating];
                MiYiAccount *account=[[MiYiUser shared]accountUser];
                account.location =[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
                [[MiYiUser shared] saveAccountUser:account];
                stringLocationCorrrdinate=account.location;
            }error:^(NSError *error) {
                activityIndlcator.hidden=YES;
                [activityIndlcator stopAnimating];
                sw.on=NO;
                switchBOOL=NO;
            }];
            
        }else{
            activityIndlcator.hidden=YES;
            sw.on=NO;
            switchBOOL=NO;
        }
    }

}

-(void)navItemClick
{
    if (switchBOOL) {
        if (stringLocationCorrrdinate.length==0) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                          message:@"还没有定位好,您确定就这样发出去吗?"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
    }
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [MBProgressHUD showMessage:@"正在发送中..."];
    _arrayCount=0;
    _modelCopy=[_model copy];
    MiYiPostsImageSModel *model =_modelCopy.images[_arrayCount];
    [self uploadImage:model];
}

-(void)uploadImage:(MiYiPostsImageSModel *)imagesModelCount
{
    __weak MiYiSentVC *weakSelf =self;
    [MiYiUserRequest uploadImage:imagesModelCount.img_url blockJson:^(id json) {
        if ([json isEqual:@NO]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"上传失败"];
            return ;
        }
        NSString *url =json[@"data"][@"url"];
        UIImage *image =imagesModelCount.img_url;
        imagesModelCount.size=[NSString stringWithFormat:@"%f,%f",CGWidth(image),CGHeight(image)];
        imagesModelCount.img_url =url;
        [weakSelf dataProcessing];
    }];
}

-(void)dataProcessing
{
    ++_arrayCount;
    if (_arrayCount <= _modelCopy.images.count-1) {
        MiYiPostsImageSModel *model =_modelCopy.images[_arrayCount];
        [self uploadImage:model];
    }else
    {
        for (int i=0; i<_modelCopy.images.count; i++) {
            MiYiPostsImageSModel *imagemodel =_modelCopy.images[i];
            
            if (!imagemodel.img_url) {
                imagemodel.img_url=@"";
            }
            if (!imagemodel.bounds) {
                imagemodel.bounds=@"";
            }
            if (!imagemodel.tags) {
                imagemodel.tags=[NSMutableArray array];
            }
        }
        
        if (switchLocation.on) {
          _modelCopy.location=stringLocationCorrrdinate;
        }else{
            _modelCopy.location=@"";
        }
        
        if (textViewSent.text.length ==0) {
            _modelCopy.content =@"";
        }else
        {
            _modelCopy.content =textViewSent.text;
        }
        
        
        NSMutableDictionary * dic =[_modelCopy keyValues];
        
        NSString *data = [dic JSONString];
        NSInteger type =0;
        if ([self.title isEqualToString: @"怎么穿"]) {
            type =MiYi_FAQ;
            
        }else if ([self.title isEqualToString:@"求同款"])
        {
            type =MiYi_FND;
        }else if ([self.title isEqualToString:@"求搭配"])
        {
            type =MiYi_MTH;
        }else
        {
            type =MiYi_SHW;
        }
        [MBProgressHUD hideHUD];
        
        
        [MiYiPostsRequest releaseData:data topicType:type success:^(BOOL success) {
            if (success) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showSuccess:@"发布成功"];
            }else
            {
                
                [MBProgressHUD showError:@"发布失败"];
            }
        }];
    }
}

-(CGSize )TextSize:(NSString *)text Font:(int )font label:(UILabel *)label
{
    UIFont *labelfont=[UIFont systemFontOfSize:font];
    CGSize TextSize = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:labelfont,NSFontAttributeName,nil]];
    label.font =labelfont;
    label.text =text;
    return TextSize;
}

#pragma -mark 代理

- (void)textViewDidChange:(UITextView *)textView{
    NSInteger number = [textView.text length];
    if (number > 140) {
        textView.text = [textView.text substringToIndex:140];
        _modelCopy.content =textView.text;
    }
    labelStatus.text = [NSString stringWithFormat:@"%li/140",(long)[textView.text length]];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        NSLog(@"取消");
        switchBOOL=switchLocation.on;
    }else{
        NSLog(@"确定");
        switchBOOL=NO;
        [self navItemClick];
    }
}

-(UIView *)getViewBG{
    UIView *view =[UIView new];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

-(MiYiTextView *)getTextViewSent{
    MiYiTextView *textView =[MiYiTextView new];
    textView.delegate=self;
    textView.scrollEnabled=YES;
    textView.placeholder = @"请在此处输入内容...";
    textView.font=[UIFont systemFontOfSize:15];
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.returnKeyType=UIReturnKeyDone;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    if (_model.content!=0) {
        textView.text=_model.content;
        [textView textDidChange];
    }
    return textView;
}

-(UILabel *)getLabelStatus{
    UILabel *label =[UILabel new];
    label.text=@"0/140";
    label.font=Font(11);
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment =NSTextAlignmentCenter;
    return label;
}

-(UILabel *)getLabelLocationTitle{
    UILabel *label =[UILabel new];
    label.text=@"显示我的位置";
    label.font=boldFont(15);
    label.textColor = [UIColor blackColor];
    label.textAlignment =NSTextAlignmentCenter;
    return label;
}

-(UISwitch *)getSwitchLocation{
    UISwitch *sw = [UISwitch new];
    sw.tintColor=HEX_COLOR_THEME;
    sw.onTintColor=HEX_COLOR_THEME;
    return sw;
}
@end
