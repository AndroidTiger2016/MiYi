//
//  MiYiTextView.h
//  MiYi
//
//  Created by 叶星龙 on 15/8/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiYiTextView : UITextView
@property (nonatomic, weak) UILabel *placeholderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
- (void)textDidChange;
@end
