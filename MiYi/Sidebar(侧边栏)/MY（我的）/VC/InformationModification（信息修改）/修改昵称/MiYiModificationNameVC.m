//
//  MiYiModificationNameVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiModificationNameVC.h"
#import "MiYiTextField.h"
#import "MiYiUser.h"
#import "MiYiLabel.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiSideslipVC.h"
@interface MiYiModificationNameVC ()
{
    MiYiTextField *textFieldName;
    UIButton *buttonOk;
}

@end

@implementation MiYiModificationNameVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    
    textFieldName =[self getTextFieldName];
    [self.view addSubview:textFieldName];
    [textFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 49));
    }];
    
    buttonOk =[self getButtonOk];
    [buttonOk addTarget:self action:@selector(clickButtonOk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOk];
    [buttonOk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldName.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 49));
    }];
    
    
    // Do any additional setup after loading the view.
}

-(void)clickButtonOk{
    [MiYiUserRequest modifyInformationType:MiYiUserRequest_typeName Contents:textFieldName.textField.text Success:^(BOOL success) {
        if (success) {
            MiYiAccount*account=[[MiYiUser shared]accountUser];
            account.nickname=textFieldName.textField.text;
            [[MiYiUser shared] saveAccountUser:account];
            [[MiYiSideslipVC shared].leftControl userData:account];
            _block(textFieldName.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"修改失败"];
        }
    }];
}


-(MiYiTextField *)getTextFieldName{
    MiYiTextField *field =[MiYiTextField new];
    field.textField.text=[[MiYiUser shared]accountUser].nickname;
    field.textField.textAlignment=NSTextAlignmentCenter;
    field.isSpecialCharacters=YES;
    field.isWordLimit=YES;
    field.backgroundColor=[UIColor whiteColor];
    return field;
}

-(UIButton *)getButtonOk{
    UIButton *btn =[UIButton new];
    [btn setTitle:@"确定修改" forState:UIControlStateNormal];
    btn.backgroundColor=HEX_COLOR_THEME;
    return btn;
}
@end
