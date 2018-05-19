//
//  MiYiLoginVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/28.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiLoginVC.h"
#import "MiYiTabBarViewController.h"
#import "MiYiSideslipVC.h"
#import "MiYiLeftSideslipUserVC.h"
#import "UIImage+MiYi.h"
#import "MiYiTextField.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiUser.h"
#import <MJExtension.h>
#import "MiYiUserSession.h"
#import "MiYiNavViewController.h"
@interface MiYiLoginVC ()
{
    MiYiTextField *textFieldAccount;
    MiYiTextField *textFieldVerificationCode;
    UIButton *buttonAuthCode;
    UIButton *buttonLogin;
    int countSecond;
    NSTimer *countTimer;
}

@end

@implementation MiYiLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    
    countSecond=60;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(clickItem)];
    self.navigationItem.leftBarButtonItem =item;
    
    [self loginUI];
}

-(void)loginUI
{
    textFieldAccount =[self gettextFieldAccount];
    [self.view addSubview:textFieldAccount];//账号
    [textFieldAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 50));
    }];
    
    textFieldVerificationCode = [self gettextFieldVerificationCode];
    [self.view addSubview:textFieldVerificationCode];
    [textFieldVerificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldAccount.mas_bottom);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 50));
    }];
    
    buttonAuthCode = [self getButtonAuthCode];
    buttonAuthCode.layer.cornerRadius  = 30/2;
    [buttonAuthCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [buttonAuthCode addTarget:self action:@selector(clickButtonAuthCode:) forControlEvents:UIControlEventTouchDragInside];
    [buttonAuthCode sizeToFit];
    [textFieldVerificationCode addSubview:buttonAuthCode];
    [buttonAuthCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(textFieldVerificationCode.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    buttonLogin = [self getButtonLogin];
    [buttonLogin setTitle:@"登录" forState:UIControlStateNormal];
    buttonLogin.layer.cornerRadius=40/2;
    [buttonLogin addTarget:self action:@selector(clickButtonLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonLogin];
    [buttonLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldVerificationCode.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth*0.8, 40));
    }];
}

#pragma  -Mark 点击
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)clickButtonAuthCode:(UIButton *)btn{
    
    btn.enabled=NO;
    [btn setBackgroundColor:UIColorRGBA(230, 230, 230, 1)];
    [btn setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
}

-(void)count:(NSTimer *)timer{
    countSecond -- ;
    [buttonAuthCode setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    if(countSecond == 0){
        buttonAuthCode.enabled = YES;
        [timer invalidate];
        countSecond = 60;
        [buttonAuthCode setTitle:[NSString stringWithFormat:@"%@(%d)",@"重发",countSecond] forState:UIControlStateDisabled];
    }
}

- (void)clickItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickButtonLogin{
    [self.view endEditing:YES];

    if(textFieldAccount.textField.text.length<11)
    {
        [MBProgressHUD showError:@"请输入完整的手机号"];
        return;
    }
    if(![textFieldAccount isValidPhone])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [MBProgressHUD showMessage:nil];
    [MiYiUserRequest loginWithPhoneNumber:textFieldAccount.textField.text json:^(id json) {
         NSNumber *ret =json[@"ret"];
        [MBProgressHUD hideHUD];
        if ([ret integerValue]!=0) {
            [MBProgressHUD showError:@"登录失败"];
            return ;
        }
        [MBProgressHUD showSuccess:@"登录成功"];
//        NSString *newUser = json[@"data"][@"is_new"];
//
//        NSLog(@"%@", newUser);
//        if ([newUser intValue]) {
//            MiYiAddUserInfoVC *addUserInfoVC = [[MiYiAddUserInfoVC alloc] init];
//            NSArray *images = [NSArray arrayWithObjects:@"AmericaStyle", @"clearStyle", @"JSStyle", @"LeisureStyle", @"qingshuStyle", @"retoStyle", @"schoolStyle", @"sengnvStyle", @"sportStyle",nil];
//            NSArray *titles = [NSArray arrayWithObjects:@"欧美风", @"小清新", @"日韩范", @"休闲", @"轻熟", @"复古", @"学院风", @"森女系", @"运动", nil];
//
//            NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
//            for (int i = 0; i < images.count; i++) {
//                content[images[i]] = titles[i];
//            }
//
//            [addUserInfoVC setInit:@"你的日常穿着更接近那种风格呢" withImage:@"style" withContent:content withPos:1];
//            MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:addUserInfoVC];
//            [self presentViewController:nav animated:YES completion:nil];
//        }
        [MiYiUserRequest userInfoId:[[MiYiUserSession shared] session].uid json:^(id json) {
            if ([json  isEqual: @YES]) {
                if (_isWindow) {
                   [self dismissViewControllerAnimated:YES completion:^{
                       [Notification postNotificationName:MiYiHomeVCNavItemNotification object:nil];
                   }];
                }else{
                    [Notification postNotificationName:MiYiHomeVCNavItemNotification object:nil];
                    UIWindow *screenWindow = [[UIApplication  sharedApplication] keyWindow];
                    screenWindow.rootViewController=[MiYiSideslipVC shared];
                }
            }
        } error:^(NSError *error) {
            [MBProgressHUD showError:@"获取用户信息失败\n可能网络出现问题"];
        }];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"登录失败"];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

-(void)textField:(UITextField*)text imageName:(NSString *)name remindText:(NSString *)remindText{
    text.textColor = [UIColor lightGrayColor];
    text.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){0,15,60,20}];
    image.image=[UIImage imageNamed:name];
    image.contentMode =UIViewContentModeScaleAspectFit;
    text.leftView = image;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.font = Font(13);
    text.clearButtonMode = UITextFieldViewModeAlways;
    text.textAlignment = NSTextAlignmentLeft;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    text.attributedPlaceholder = [[NSAttributedString alloc] initWithString:remindText attributes:attrs];
}

#pragma  -Mark 初始化
-(MiYiTextField *)gettextFieldAccount{
    MiYiTextField *textField = [MiYiTextField new];
    textField.isNumber = YES;
    textField.isPhoneNumberWordLimit = YES;
    [self textField:textField.textField imageName:@"phoneIcon" remindText:@" 请输入手机号"];
    return textField;
}

-(MiYiTextField *)gettextFieldVerificationCode
{
    MiYiTextField *textField =[MiYiTextField new];
    textField.isNumber = YES;
    textField.isPhoneNumberWordLimit = YES;
    textField.PhoneNumberWordLimitInt = 6;
    [self textField:textField.textField imageName:@"code" remindText:@" 请输入验证码"];
    return textField;
}

-(UIButton *)getButtonAuthCode{
    UIButton *btn = [UIButton new];
    btn.backgroundColor=[UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor   = HEX_COLOR_THEME.CGColor;
    btn.layer.borderWidth   = 1;
    btn.titleLabel.font = Font(13);
    [btn setTitleColor:HEX_COLOR_THEME forState:UIControlStateNormal];
    return btn;
}

-(UIButton *)getButtonLogin{
    UIButton *btn = [UIButton new];
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = HEX_COLOR_THEME;
    return btn;
}

@end
