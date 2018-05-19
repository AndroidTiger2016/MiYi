//
//  MiYiUserStyleCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/10/8.
//  Copyright © 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiUserStyleCell.h"
#import "MiYiLabelImageView.h"
#import "MiYiAddUserDataVC.h"
@interface MiYiUserStyleCell ()
{
    UIView *viewBG;
    UILabel *labelTitle;
    UIButton *buttonEditor;
    NSMutableArray *labelArray;
    UILabel *labelPrompt;
    
}
@end

@implementation MiYiUserStyleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString*)identifier
{
    MiYiUserStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MiYiUserStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

-(void)configCell{
    labelArray =[NSMutableArray array];
    
    viewBG = [UIView new];
    viewBG.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:viewBG];
    [viewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 4, 0));
    }];
    
    labelTitle = [self getLabelTitle];
    labelTitle.text=@"我的风格";
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.width.greaterThanOrEqualTo(@30);
        make.height.equalTo(@15);
    }];

    buttonEditor =[UIButton new];
    [buttonEditor setImage:[UIImage imageNamed:@"Personal_grayEdit"] forState:UIControlStateNormal];
    [buttonEditor sizeToFit];
    [buttonEditor addTarget:self action:@selector(clickButtonEditor:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonEditor];
    [buttonEditor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTitle);
        make.right.equalTo(@(-15));
        make.size.mas_equalTo(CGSizeMake(CGWidth(buttonEditor.frame), CGHeight(buttonEditor.frame)));
    }];

    for (int i =0; i<12; i++) {
        MiYiLabelImageView *label =[MiYiLabelImageView new];
        label.image=[UIImage imageNamed:@"Personal_grayTag"];
        [self.contentView addSubview:label];
        label.hidden=YES;
        [labelArray addObject:label];
    }
    
    labelPrompt =[UILabel new];
    labelPrompt.text=@"标注你的style,发现更美穿搭哦~";
    labelPrompt.textAlignment=NSTextAlignmentCenter;
    labelPrompt.textColor=[UIColor lightGrayColor];
    labelPrompt.font=Font(13);
    labelPrompt.hidden=YES;
    [self.contentView addSubview:labelPrompt];
    [labelPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(@13);
    }];
}

-(void)clickButtonEditor:(UIButton *)btn{
    if (_isOfOthers ==YES) {
        
    }else{
        MiYiAddUserDataVC *vc =[[MiYiAddUserDataVC alloc]init];
        vc.popBlock=^{
            if (_delegate && [_delegate respondsToSelector:@selector(stylePopBlockReloadData)]){
                [_delegate stylePopBlockReloadData];
            }
            [self.viewController.navigationController popViewControllerAnimated:YES];
        };
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }

}


-(void)setUserAccount:(MiYiAccount *)userAccount
{
    if ([_userAccount isEqual:userAccount]) {
        return;
    }
    
    
    [labelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MiYiLabelImageView *label=obj;
        label.hidden=YES;
    }];
    
    _userAccount=userAccount;
    labelPrompt.hidden=YES;
    if (_isOfOthers ==YES) {
        [buttonEditor setImage:[UIImage imageNamed:@"Personal_more"] forState:UIControlStateNormal];
        labelTitle.text=@"她的风格";
        labelPrompt.text=@"她还没有标记她的风格";
        
    }
    
    
    NSArray *array = [userAccount.style componentsSeparatedByString:@","];
    if(array.count ==0){
        labelPrompt.hidden=NO;
        return;
    }
    CGFloat X=0;
    int y =0;
    int row =0;
    for(int i=0; i<array.count;i++){
        MiYiLabelImageView *label=labelArray[i];
        label.hidden=NO;
        NSString *labelString = array[i];
        if(labelString.length ==0){
            labelPrompt.hidden=NO;
            label.hidden=YES;
            return;
        }
        label.imageLabel.text=labelString;
        CGSize size =[labelString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
        CGFloat imageWidth =0;
        if(size.width > label.image.size.width-12){
            imageWidth =size.width -(label.image.size.width-12) +1;
        }
        
        CGFloat photoX = 15+X+(i-y)*15 > kWindowWidth-30 ? 15 : 15+X+(i-y)*15+1;
        if (photoX + label.image.size.width+imageWidth > kWindowWidth-30) {
            photoX =15;
        }
        X+=(label.image.size.width+imageWidth);
        if (photoX < 16) {
            X=label.image.size.width+imageWidth;
            y =i;
            row+=1;
        }
        CGFloat photoY = row *(15+label.image.size.height);
        __block MiYiLabelImageView *blockLabel =label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelTitle.mas_bottom).offset(18+photoY);
            make.left.equalTo(@(photoX));
            make.width.equalTo(@(imageWidth +label.image.size.width));
            make.height.equalTo(@(label.image.size.height));
            blockLabel.image = [blockLabel.image stretchableImageWithLeftCapWidth:12+1 topCapHeight:12];

        }];
    }
    
    
}


+(CGFloat)styleHeight:(NSString *)string{

    CGFloat W =47;
    CGFloat H =16;

    NSArray *array = [string componentsSeparatedByString:@","];
    if(array.count ==0){
        return 2 *H +1 *15;
    }
    CGFloat X=0;
    int y =0;
    int row =0;
    for(int i=0; i<array.count;i++){
        NSString *labelString = array[i];
        CGSize size =[labelString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
        CGFloat imageWidth =0;
        if(size.width > W-12){
            imageWidth =size.width -(W-12) +1;
        }
        CGFloat photoX = 15+X+(i-y)*15 > kWindowWidth-30 ? 15 : 15+X+(i-y)*15+1;
        if (photoX + W+imageWidth > kWindowWidth-30) {
            photoX =15;
        }
        X+=(W+imageWidth);
        if (photoX < 16) {
            X=W+imageWidth;
            y =i;
            row+=1;
        }
    }
    return row *H +row *15;
}

#pragma -mark init
-(UILabel *)getLabelTitle{
    UILabel *label =[UILabel new];
    label.textColor=[UIColor blackColor];
    label.font=boldFont(15);
    return label;
}

@end
