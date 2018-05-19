//
//  AwesomeMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenuItem.h"

@protocol AwesomeMenuDelegate;


@interface AwesomeMenu : UIView <AwesomeMenuItemDelegate>
{
    AwesomeMenuItem *_startButton;

}
@property (nonatomic, copy) NSArray *menusArray;
@property (nonatomic, getter = isExpanding) BOOL expanding;
@property (nonatomic, weak) id<AwesomeMenuDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *highlightedContentImage;

@property (nonatomic, assign) CGFloat nearRadius;//设置“添加”按钮和菜单项之间的距离
@property (nonatomic, assign) CGFloat endRadius;//调整反弹的动画：
@property (nonatomic, assign) CGFloat farRadius;//调整反弹的动画：
@property (nonatomic, assign) CGPoint startPoint;//    定位的“添加”按钮的中心
@property (nonatomic, assign) CGFloat timeOffset;//每个弹出时间间隔
@property (nonatomic, assign) CGFloat rotateAngle;//设置旋转角度
@property (nonatomic, assign) CGFloat menuWholeAngle;//设置整个菜单角度
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat closeRotation;
@property (nonatomic, assign) CGFloat animationDuration;//弹出动画时间
@property (nonatomic, assign) BOOL    rotateAddButton;

- (id)initWithFrame:(CGRect)frame startItem:(AwesomeMenuItem*)startItem optionMenus:(NSArray *)aMenusArray;

- (void)AwesomeMenuItemTouchesEnd:(AwesomeMenuItem *)item;

@end

@protocol AwesomeMenuDelegate <NSObject>
@optional
/**
 *  选择
 *  @param idx  点选的哪个
 */
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx;
/**
 *  消失完毕
 */
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu;
/**
 *  显示完毕
 */
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu;
/**
 *  即将显示
 */
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu;
/**
 *  即将消失
 */
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu;
@end