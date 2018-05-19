//
//  MiYiModificationIntroductionVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiModificationIntroductionVC.h"
#import "MiYiTextView.h"
#import "MiYiUser.h"
#import "MiYiLabel.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiSideslipVC.h"

@interface MiYiModificationIntroductionVC ()<UITextViewDelegate>
{
    MiYiTextView *textViewIntroduction;
    UILabel *statusLabel;
    UIButton *buttonOk;
}
@end

@implementation MiYiModificationIntroductionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    self.edgesForExtendedLayout =UIRectEdgeAll;
    
    textViewIntroduction =[self getTextView];
    [self.view addSubview:textViewIntroduction];
    [textViewIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 200));
    }];
    
    statusLabel =[self getStatusLabel];
    [self.view addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.bottom.equalTo(textViewIntroduction.mas_bottom).offset(-12);
        make.height.equalTo(@11);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    
  
    buttonOk =[self getButtonOk];
    [buttonOk addTarget:self action:@selector(clickButtonOk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOk];
    [buttonOk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textViewIntroduction.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 49));
    }];
    
    // Do any additional setup after loading the view.
}

-(void)clickButtonOk
{
   
    [MiYiUserRequest modifyInformationType:MiYiUserRequest_typeIntroduction Contents:textViewIntroduction.text Success:^(BOOL success) {
        if (success) {
            MiYiAccount*account=[[MiYiUser shared]accountUser];
            account.summary=textViewIntroduction.text;
            [[MiYiUser shared] saveAccountUser:account];
            [[MiYiSideslipVC shared].leftControl userData:account];
            _block(textViewIntroduction.text);
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [MBProgressHUD showError:@"修改失败"];
        }
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    NSInteger number = [textView.text length];
    if (number > 60) {
        textView.text = [textView.text substringToIndex:60];
    }
    statusLabel.text = [NSString stringWithFormat:@"%li/60",(long)[textView.text length]];
    
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




-(MiYiTextView *)getTextView{
    MiYiTextView *textView =[MiYiTextView new];
    textView.delegate=self;
    textView.scrollEnabled=NO;
    textView.contentOffset=CGPointMake(kWindowWidth/2,textView.center.y-32);
    textView.font = Font(15);
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.returnKeyType=UIReturnKeyDone;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textView.placeholder = @"您有什么需求可以写在这里哦";
    if ([[MiYiUser shared]accountUser].summary!=0) {
        textView.text=[[MiYiUser shared]accountUser].summary;
        [textView textDidChange];
    }
    return textView;
}

-(UILabel *)getStatusLabel{
    UILabel *label =[[UILabel alloc]init];
    label.text=@"0/60";
    label.font=Font(11);
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment =NSTextAlignmentCenter;
    return label;
}

-(UIButton *)getButtonOk{
    UIButton *btn =[UIButton new];
    [btn setTitle:@"确定修改" forState:UIControlStateNormal];
    btn.backgroundColor=HEX_COLOR_THEME;
    return btn;
}
@end
