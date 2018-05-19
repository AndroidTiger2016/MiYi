//
//  MiYiPhotoGroupListView.m
//  MiYi
//
//  Created by 叶星龙 on 15/7/23.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPhotoGroupListView.h"
#import "MiYiAssetManager.h"
#import "View+MASAdditions.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface MiYiPhotoGroupListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView * tableView;

@end
@implementation MiYiPhotoGroupListView

+ (instancetype)showToView:(UIView *)view block:(MiYiPhotoGroupListSelectBlock)block
{
    MiYiPhotoGroupListView * listView = [[MiYiPhotoGroupListView alloc]initWithFrame:view.bounds];
    [view addSubview:listView];
    [listView show];
    listView.block = block;
    return listView;
}


- (void)_setDefaultPhotoGroupListView
{
    self.backgroundColor = [UIColor clearColor];
    UIView * gesView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:gesView];
    [gesView mas_makeConstraints:^(MASConstraintMaker * make)
     {
         make.edges.mas_equalTo(UIEdgeInsetsZero);
     }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [gesView addGestureRecognizer:tap];
    
    float height = self.bounds.size.height * 0.6;
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -height, self.bounds.size.width, height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView = tableView;
    UIView * footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = footView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker * make)
     {
         make.top.mas_equalTo(-height);
         make.left.mas_equalTo(0);
         make.right.mas_equalTo(0);
         make.height.mas_equalTo(height);
     }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setDefaultPhotoGroupListView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setDefaultPhotoGroupListView];
    }
    return self;
}

- (void)dismiss
{
    if (self.block) {
        self.block (nil);
    }
    [self _dismiss];
}

- (void)_dismiss
{
    CGRect frame = self.tableView.frame;
    frame.origin.y = -frame.size.height;
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.tableView.frame = frame;
         self.backgroundColor = [UIColor clearColor];
     }completion:^(BOOL finish)
     {
         [self removeFromSuperview];
         self.block = nil;
     }];
}

- (void)show
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker * make)
     {
         make.top.mas_equalTo(0);
     }];
    CGRect frame = self.tableView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.tableView.frame = frame;
         self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.3];
     }];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MiYiAssetManager shareAssetManager]groupList]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    MiYiGroupAsset * group = [[MiYiAssetManager shareAssetManager]groupList][indexPath.row];
    cell.textLabel.text = [[group.group valueForProperty:ALAssetsGroupPropertyName] stringByAppendingFormat:@" (%@)",[NSNumber numberWithInteger:[group.group numberOfAssets]]];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.imageView.image = [UIImage imageWithCGImage:group.group.posterImage];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiGroupAsset * group = [[MiYiAssetManager shareAssetManager]groupList][indexPath.row];
    if (self.block) {
        self.block (group);
    }
    [self dismiss];
}


@end
