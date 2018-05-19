//
//  MiYiTextView.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/11.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTextView.h"

@implementation MiYiTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(id)init
{
    self =[super init];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UILabel *placeholderLabel = [self getPlaceholderLabel];
    self.placeholderLabel = placeholderLabel;
    [self addSubview:placeholderLabel];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@11);
        make.width.greaterThanOrEqualTo(@10);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}
                                        
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    if (placeholder.length) { // 需要显示
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = (self.text.length != 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UILabel *)getPlaceholderLabel{
    UILabel *label =[UILabel new];
    label.textColor = [UIColor lightGrayColor];
    label.hidden = YES;
    label.backgroundColor = [UIColor clearColor];
    label.font = Font(11);
    label.userInteractionEnabled=NO;
    return label;
}

@end
