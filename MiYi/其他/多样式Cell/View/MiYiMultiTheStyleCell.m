//
//  MiYiMultiTheStyleCell.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiMultiTheStyleCell.h"
#import "MiYiCellItem.h"
#import "MiYiItemGroup.h"
#import "MiYiArrowItem.h"
#import "MiYiLableItem.h"
#import "MiYiSwitchItem.h"
#import "MiYiImageItem.h"
#import "UIImage+MiYi.h"
#import <UIImageView+WebCache.h>
@interface MiYiMultiTheStyleCell()
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *arrowView;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch    *switchView;

@property (nonatomic, weak  ) UITableView *tableView;

@property (nonatomic, weak  ) UIImageView *bgView;
@property (nonatomic, weak  ) UIImageView *selectedBgView;

@property (strong, nonatomic) UILabel     *subtitle;
@end

@implementation MiYiMultiTheStyleCell
- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(tapSwitchView:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ArrowIcon"]];
    }
    return _arrowView;
}
- (UILabel *)subtitle
{
    if (_subtitle == nil) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.font = [UIFont systemFontOfSize:15];
        _subtitle.textColor=self.item.color;
        _subtitle.textAlignment=NSTextAlignmentRight;
        _subtitle.text=self.item.subtitle;
    }
    return _subtitle;
}

- (IBAction)tapSwitchView:(UISwitch *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.switchView.isOn forKey:self.item.title];
    [defaults synchronize];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    MiYiMultiTheStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MiYiMultiTheStyleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 标题
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        // 创建背景
        UIImageView *bgView = [[UIImageView alloc] init];
        self.backgroundView = bgView;
        self.bgView = bgView;
        self.bgView.image = [UIImage createImageWithColor:[UIColor whiteColor]];

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    
    
    
    [super setFrame:frame];
}

- (void)setItem:(MiYiCellItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的控件
    [self setupRightView];
}



/**
 *  设置数据
 */
- (void)setupData
{
  
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
 
    self.textLabel.text = self.item.title;
    
    if (self.item.detailText) {
        
        self.detailTextLabel.text = self.item.detailText;
    }

}

/**
 *  设置右边的控件
 */
- (void)setupRightView
{
    if ([self.item isKindOfClass:[MiYiSwitchItem class]])
    {
        // 右边是开关
        self.switchView.onTintColor= HEX_COLOR_THEME;
        self.accessoryView = self.switchView;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:self.item.title];
    }
    
    else if ([self.item isKindOfClass:[MiYiArrowItem class]])
    { // 右边是箭头
        if (self.item.subtitle) {
            _subtitle.text=self.item.subtitle;
            _subtitle.textColor=self.item.color;
            CGSize subtitleSize =[self.subtitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName, nil]];
            
            _subtitle.frame=(CGRect){{0,0},subtitleSize};
            self.accessoryView =self.subtitle;
        }else
            self.accessoryView = self.arrowView;
    }else if ([self.item isKindOfClass:[MiYiLableItem class]])
    {
        _subtitle.text=self.item.subtitle;
        _subtitle.textColor=self.item.color;
        CGSize subtitleSize =[self.subtitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName, nil]];
        if(subtitleSize.width>kWindowWidth/2)
        {
            subtitleSize.width=kWindowWidth/2;
        }
        UIView *accessoryView =[[UIView alloc]init];
        accessoryView.frame =(CGRect){0,0,subtitleSize.width+self.arrowView.image.size.width,15};
        _subtitle.frame=(CGRect){{0,0},subtitleSize};
        
        _arrowView.frame=(CGRect){{CGRectGetMaxX(_subtitle.frame),4},_arrowView.image.size};
        [accessoryView addSubview:_subtitle];
        [accessoryView addSubview:_arrowView];
        self.accessoryView =accessoryView;
        
    }else if ([self.item isKindOfClass:[MiYiImageItem class]])
    {
        UIView *accessoryView =[[UIView alloc]init];
        accessoryView.frame =(CGRect){0,0,65+self.arrowView.image.size.width,60};
        UIImageView *imageIcon =[[UIImageView alloc]initWithFrame:(CGRect){0,0,60,60}];
        [imageIcon sd_setImageWithURL:[NSURL URLWithString:self.item.image] placeholderImage:[UIImage imageNamed:@"userpLaceholderImage"]];
        imageIcon.contentMode=UIViewContentModeScaleAspectFill;
        imageIcon.layer.masksToBounds=YES;
        imageIcon.layer.cornerRadius=30;
        [accessoryView addSubview:imageIcon];
        
        _arrowView.frame=(CGRect){{CGRectGetMaxX(imageIcon.frame)+5,60/2-_arrowView.image.size.height/2},_arrowView.image.size};
        [accessoryView addSubview:_arrowView];
        self.accessoryView =accessoryView;
        
    }
    else { // 右边没有东西
        self.accessoryView = nil;
    }
}
@end
