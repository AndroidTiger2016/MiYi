//
//  MiYiTagEditorImageView.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/15.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTagEditorImageView.h"
#import "MiYiTagView.h"
#import "MiYiTagSearchBarVC.h"
#import "MiYiView.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "UIImage+MiYi.h"
@interface MiYiTagEditorImageView ()<UIGestureRecognizerDelegate>

@property (nonatomic ,assign) CGPoint firstClick;

@property (nonatomic ,strong) NSMutableArray *tagArray;

@property (nonatomic ,weak) UIView  *coverView;

@property (nonatomic ,weak) UIButton * brandBtn;

@property (nonatomic ,weak) UIButton * featureBtn;

@property (nonatomic ,weak) MiYiTagView *tagView;
@end

@implementation MiYiTagEditorImageView

-(instancetype)init
{
    self =[super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    _tagArray =[NSMutableArray array];
    UIImageView *previewsImage =[[UIImageView alloc]init];
    previewsImage.userInteractionEnabled=YES;
    [self addSubview:previewsImage];
    _previewsImage=previewsImage;
    UITapGestureRecognizer* imageTagTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTagTapClick:)];
    imageTagTap.numberOfTapsRequired=1;
    imageTagTap.numberOfTouchesRequired=1;
    imageTagTap.delegate = self;
    [_previewsImage addGestureRecognizer:imageTagTap];
    
}

-(void)setPostsImageSModel:(MiYiPostsImageSModel *)postsImageSModel
{
    _postsImageSModel=postsImageSModel;
    
    id classID =postsImageSModel.img_url;
    if ([classID isKindOfClass:[NSString class]]) {
        __weak MiYiTagEditorImageView *weakSelf =self;
        [_previewsImage sd_setImageWithURL:[NSURL URLWithString:postsImageSModel.img_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (weakSelf.isComputing) {
                [weakSelf imageTagFrame:YES];
            }else
            {
                [weakSelf imageTagFrame:NO];
            }
            
            for(int i =0 ; i<weakSelf.postsImageSModel.tags.count ;i++)
            {
                MiYiPostsImageTagIdsModel *model =[MiYiPostsImageTagIdsModel objectWithKeyValues:weakSelf.postsImageSModel.tags[i]];
                if (model.tag_content.length!=0) {
                    [weakSelf addtagViewimageClickinit:CGPointZero isClick:NO mode:model];
                }
            }
            
            if (cacheType == SDImageCacheTypeNone) {
                
                if (weakSelf.tableViewReloadData) {
                    weakSelf.tableViewReloadData();
                }
            }
        }];
    }else
    {
        _previewsImage.image=postsImageSModel.img_url;
        if (_isComputing) {
            [self imageTagFrame:YES];
        }else
        {
            [self imageTagFrame:NO];
        }
        
        for(int i =0 ; i<_postsImageSModel.tags.count ;i++)
        {
            MiYiPostsImageTagIdsModel *model =[MiYiPostsImageTagIdsModel objectWithKeyValues:_postsImageSModel.tags[i]];
            if (model.tag_content.length!=0) {
                [self addtagViewimageClickinit:CGPointZero isClick:NO mode:model];
            }
        }
    }
    
    if (_isEditor) {
        [self initTagUI];
    }else
    {
        _previewsImage.userInteractionEnabled=NO;
    }

    
    
}
/**
 *  初始化mbp界面
 */
-(void)initTagUI
{
    UIView *coverView =[[UIView alloc]initWithFrame:self.bounds];
    coverView.alpha=0;
    _coverView=coverView;
    
    MiYiView *mbpView =[[MiYiView alloc]initWithFrame:self.bounds];
    [mbpView addTarget:self action:@selector(mbpViewClick) forControlEvents:MiYiViewControlEventTap ];
    
    CGFloat WH =100;
    
    UIButton * featureBtn =[[UIButton alloc]initWithFrame:(CGRect){0,0,WH,WH}];
    featureBtn.center = CGPointMake(kWindowWidth/2-WH/1.3, kWindowHeight/2);
    featureBtn.backgroundColor=UIColorRGBA(0, 0, 0, 0.6);
    [featureBtn addTarget:self action:@selector(featureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [featureBtn setTitle:@"特点" forState:UIControlStateNormal];
    featureBtn.layer.cornerRadius=WH/2;
    _featureBtn =featureBtn;
    
    UIButton * brandBtn =[[UIButton alloc]initWithFrame:(CGRect){0,0,WH,WH}];
    brandBtn.center = CGPointMake(kWindowWidth/2+WH/1.3, kWindowHeight/2);
    brandBtn.backgroundColor=UIColorRGBA(0, 0, 0, 0.6);
    [brandBtn addTarget:self action:@selector(brandBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [brandBtn setTitle:@"品牌" forState:UIControlStateNormal];
    brandBtn.layer.cornerRadius=WH/2;
    _brandBtn =brandBtn;
    
    [self addSubview:coverView];
    [coverView addSubview:mbpView];
    [coverView addSubview:featureBtn];
    [coverView addSubview:brandBtn];
    
}
/**
 *  mbp界面的动画
 */
-(void)initTagUIAnimate:(BOOL)animate
{
    
    if (animate) {
        [UIView animateWithDuration:0.1 animations:^{
            _coverView.alpha=1;
            _featureBtn.transform=CGAffineTransformMakeScale(1.2, 1.2);
            _brandBtn.transform=CGAffineTransformMakeScale(1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
                _featureBtn.transform=CGAffineTransformIdentity;
                _brandBtn.transform=CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                
            }];
        }];
        
    }else
    {
        [UIView animateWithDuration:0.1 animations:^{
            _coverView.alpha=0;
            
        }completion:^(BOOL finished) {
            if (self.tagArray.count !=0) {
                MiYiTagView *tag =[self.tagArray lastObject];
                if (tag.isTagImageShow) {
                    [tag removeFromSuperview];
                    [self.tagArray removeLastObject];
                }
            }
        }];
        
    }
    
}
/**
 *  点击mbp上面其他位子消失
 */
-(void)mbpViewClick
{
    [self initTagUIAnimate:NO];
}

-(void)featureBtnClick
{
    MiYiTagSearchBarVC *vc =[[MiYiTagSearchBarVC alloc]init];
    vc.isType=NO;
    vc.block=^(NSString *text)
    {
        [self tagViewFrameText:text tagView:[self.tagArray lastObject]];
        MiYiTagView *tagView =(MiYiTagView *)[self.tagArray lastObject];
        [self tagViewPan:tagView point:tagView.center];
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
-(void)brandBtnClick
{
    MiYiTagSearchBarVC *vc =[[MiYiTagSearchBarVC alloc]init];
    vc.isType=YES;
    vc.block=^(NSString *text)
    {
        [self tagViewFrameText:text tagView:[self.tagArray lastObject]];
        MiYiTagView *tagView =(MiYiTagView *)[self.tagArray lastObject];
        [self tagViewPan:tagView point:tagView.center];
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
/**
 *  计算Frame
 *
 *  @param text     文本
 *  @param tageView 标签
 */
-(void)tagViewFrameText:(NSString *)text tagView:(MiYiTagView *)tageView
{
    MiYiTagView *tag =tageView;
    tag.isTagImageShow=NO;
    
    CGSize size =[text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
    UIImage *image =[UIImage imageNamed:@"TagTapIcon"];
    UIImage *imageTag =[UIImage imageNamed:@"textTag"];
    
    if (tag.overturn) {
        if (size.width < CGWidth(imageTag)-8) {
//            size=CGSizeMake(size.width+10, size.height);
            tag.frame=(CGRect){tag.frame.origin.x -(CGWidth(image)+3+ CGWidth(imageTag)),tag.frame.origin.y,CGWidth(image)+3+ CGWidth(imageTag),tag.frame.size.height};
            tag.waterflowImage.frame =(CGRect){tag.waterflowImage.frame.origin.x,tag.waterflowImage.frame.origin.y,CGWidth(imageTag),tag.waterflowImage.frame.size.height};
            tag.waterflowImage.labelText.frame =(CGRect){tag.waterflowImage.labelText
                .frame.origin.x,tag.waterflowImage.labelText
                .frame.origin.y,CGWidth(imageTag)-8,tag.waterflowImage.labelText.frame.size.height};
            tag.waterflowImage.image =[tag.waterflowImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 10)];
            tag.waterflowImage.labelText.textAlignment=NSTextAlignmentCenter;
            
        }else
        {
            size=CGSizeMake(size.width+10, size.height);
            CGFloat width = (size.width - ((CGWidth(tag.frame)-image.size.width)-8-3));
            tag.frame=(CGRect){tag.frame.origin.x-(tag.frame.size.width+width),tag.frame.origin.y,tag.frame.size.width+width,tag.frame.size.height};
            tag.waterflowImage.frame =(CGRect){tag.waterflowImage.frame.origin.x,tag.waterflowImage.frame.origin.y,tag.waterflowImage.frame.size.width+width,tag.waterflowImage.frame.size.height};
            tag.waterflowImage.labelText.frame =(CGRect){tag.waterflowImage.labelText
                .frame.origin.x,tag.waterflowImage.labelText
                .frame.origin.y,tag.waterflowImage.labelText
                .frame.size.width+width,tag.waterflowImage.labelText.frame.size.height};
            tag.waterflowImage.image =[tag.waterflowImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 10)];
            
            tag.waterflowImage.labelText.textAlignment=NSTextAlignmentCenter;
        }
        tag.overturn=YES;
    }else
    {
        if (size.width < CGWidth(imageTag)-8) {
            tag.frame=(CGRect){tag.frame.origin.x,tag.frame.origin.y,CGWidth(image)+3+ CGWidth(imageTag),tag.frame.size.height};
            tag.waterflowImage.frame =(CGRect){tag.waterflowImage.frame.origin.x,tag.waterflowImage.frame.origin.y,CGWidth(imageTag),tag.waterflowImage.frame.size.height};
            tag.waterflowImage.labelText.frame =(CGRect){tag.waterflowImage.labelText
                .frame.origin.x,tag.waterflowImage.labelText
                .frame.origin.y,CGWidth(imageTag)-8,tag.waterflowImage.labelText.frame.size.height};
            tag.waterflowImage.image =[tag.waterflowImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 10, 3, 3)];
            tag.waterflowImage.labelText.textAlignment=NSTextAlignmentCenter;
        }else
        {
            size=CGSizeMake(size.width+10, size.height);
            CGFloat width = (size.width - ((CGWidth(tag.frame)-image.size.width)-8-3));
            tag.frame=(CGRect){tag.frame.origin.x,tag.frame.origin.y,tag.frame.size.width+width,tag.frame.size.height};
            tag.waterflowImage.frame =(CGRect){tag.waterflowImage.frame.origin.x,tag.waterflowImage.frame.origin.y,tag.waterflowImage.frame.size.width+width,tag.waterflowImage.frame.size.height};
            tag.waterflowImage.labelText.frame =(CGRect){tag.waterflowImage.labelText
                .frame.origin.x,tag.waterflowImage.labelText
                .frame.origin.y,tag.waterflowImage.labelText
                .frame.size.width+width,tag.waterflowImage.labelText.frame.size.height};
            tag.waterflowImage.image =[tag.waterflowImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 10, 3, 3)];
            tag.waterflowImage.labelText.textAlignment=NSTextAlignmentCenter;
        }
        tag.overturn=NO;
    }
    tag.waterflowImage.labelText.text =text;
    [self initTagUIAnimate:NO];
}
/**
 *  点击图片的位子创建一个标签
 */
-(void)imageTagTapClick:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:_previewsImage];
    
    [self addtagViewimageClickinit:point isClick:YES mode:nil];
    
    [self initTagUIAnimate:YES];
}
/**
 *  初始化标签
 *
 *  @param point   是点击添加的时候  传point point中心点与点击位子差半个标签尺寸所有加了半个尺寸的长度
 不是就为 CGPointZero
 *  @param isClick 是点击添加YES   不是则NO
 *  @param model   当isClick 为NO的时候需要传入数据
 */
-(void)addtagViewimageClickinit:(CGPoint)point isClick:(BOOL)isClick mode:(MiYiPostsImageTagIdsModel *)model
{
    if (self.tagArray.count !=0) {
        MiYiTagView *tag =[self.tagArray lastObject];
        if (tag.isTagImageShow) {
            [tag removeFromSuperview];
            [self.tagArray removeLastObject];
        }
    }
    
    MiYiTagView *tagView =[[MiYiTagView alloc]init];
    
    if (isClick) {
        _firstClick =CGPointMake(point.x +tagView.frame.size.width/2, point.y);
        tagView.center=_firstClick;
        tagView.isTagImageShow=YES;
    }else
    {
        
        NSRange range = [model.tag_position rangeOfString:@","];
        CGFloat x =[[NSString stringWithFormat:@"%@",[model.tag_position substringToIndex:range.location]] floatValue]*_imageScale;
        CGFloat y =[[NSString stringWithFormat:@"%@",[model.tag_position substringFromIndex:range.location+1]]floatValue]*_imageScale;
        
        if ([model.tag_style isEqualToString:@"0"]) {
            [self tagViewFrameText:model.tag_content tagView:tagView];
            tagView.frame =(CGRect){{x,y},tagView.frame.size};
            
        }else
        {
            tagView.overturn=YES;
            [self tagViewFrameText:model.tag_content tagView:tagView];
            tagView.frame =(CGRect){{x-CGWidth(tagView.frame),y},tagView.frame.size};
            
        }
        tagView.isTagImageShow=NO;
    }
    
    
    UIPanGestureRecognizer *tagViewPan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tagViewPanClick:)];
    tagViewPan.minimumNumberOfTouches=1;
    tagViewPan.maximumNumberOfTouches=1;
    tagViewPan.delegate=self;
    [tagView addGestureRecognizer:tagViewPan];
    UITapGestureRecognizer* tagViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewTapClick:)];
    tagViewTap.numberOfTapsRequired=1;
    tagViewTap.numberOfTouchesRequired=1;
    tagViewTap.delegate = self;
    [tagView addGestureRecognizer:tagViewTap];
    UILongPressGestureRecognizer *tagViewLongPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tagViewLongPressClick:)];
    tagViewLongPress.minimumPressDuration=0.5;
    [tagView addGestureRecognizer:tagViewLongPress];
    tagViewLongPress.delegate=self;
    
    [_previewsImage addSubview:tagView];
    [self.tagArray addObject:tagView];
    _tagView=tagView;
    
}
/**
 *  标签pan手势
 */
-(void)tagViewPanClick:(UIPanGestureRecognizer *)sender
{
    _tagView =(MiYiTagView *)sender.view;
    
    CGPoint point = [sender locationInView:_previewsImage];
    
    [self tagViewPan:_tagView point:point];
    
    
}
/**
 *  标签pan手势 做了移动时候禁止移动到超出图片界边
 */
-(void)tagViewPan:(MiYiTagView *)sender point:(CGPoint)point
{
    if (CGRectGetMaxX(sender.frame)  >= CGWidth(_previewsImage.frame) ) {
        
        if ((point.x+CGWidth(sender.frame)/2) < CGWidth(_previewsImage.frame) && (point.y-CGHeight(sender.frame)/2) >0 && (point.y+CGHeight(sender.frame)/2) < CGHeight(_previewsImage.frame)) {
            
            sender.center =CGPointMake(point.x , point.y);
            
        }else if( (point.y-CGHeight(sender.frame)/2) >0 && (point.y+CGHeight(sender.frame)/2) < CGHeight(_previewsImage.frame))
        {
            sender.center =CGPointMake((CGWidth(_previewsImage.frame)-CGWidth(sender.frame)/2 ), point.y);
        }else
        {
            if (CGRectGetMaxY(sender.frame) >= CGHeight(_previewsImage.frame) ) {
                
                sender.center =CGPointMake((CGWidth(_previewsImage.frame)-CGWidth(sender.frame)/2 ), (CGHeight(_previewsImage.frame)-CGHeight(sender.frame)/2 ));
                
            }else if (CGOriginY(sender.frame)  <= 0)
            {
                
                sender.center =CGPointMake((CGWidth(_previewsImage.frame)-CGWidth(sender.frame)/2 ), CGHeight(sender.frame)/2);
            }else
            {
                sender.center =CGPointMake((CGWidth(_previewsImage.frame)-CGWidth(sender.frame)/2 ), point.y);
            }
        }
        return;
    }else if (CGOriginX(sender.frame)  <= 0)
    {
        
        if ((point.x-CGWidth(sender.frame)/2) >0 && (point.y-CGHeight(sender.frame)/2) >0 && (point.y+CGHeight(sender.frame)/2) < CGHeight(_previewsImage.frame)) {
            
            sender.center =CGPointMake(point.x , point.y);
        }else if( (point.y-CGHeight(sender.frame)/2) >0 && (point.y+CGHeight(sender.frame)/2) < CGHeight(_previewsImage.frame))
        {
            sender.center =CGPointMake((CGWidth(sender.frame)/2 ), point.y);
        }else
        {
            if (CGRectGetMaxY(sender.frame) >= CGHeight(_previewsImage.frame) ) {
                sender.center =CGPointMake((CGWidth(sender.frame)/2 ), (CGHeight(_previewsImage.frame)-CGHeight(sender.frame)/2 ));
                
            }else if (CGOriginY(sender.frame)  <= 0)
            {
                sender.center =CGPointMake((CGWidth(sender.frame)/2 ), CGHeight(sender.frame)/2);
            }else
            {
                sender.center =CGPointMake((CGWidth(sender.frame)/2 ), point.y);
            }
        }
        return;
    }else if (CGRectGetMaxY(sender.frame) >= CGHeight(_previewsImage.frame))
    {
        if ((point.y+CGHeight(sender.frame)/2) < CGHeight(_previewsImage.frame) && (point.x-CGWidth(sender.frame)/2) >0 && (point.x+CGWidth(sender.frame)/2) < CGWidth(_previewsImage.frame)) {
            sender.center =CGPointMake(point.x , point.y);
        }else if((point.x-CGWidth(sender.frame)/2) >0 &&(point.x+CGWidth(sender.frame)/2) < CGWidth(_previewsImage.frame))
        {
            sender.center =CGPointMake(point.x , (CGHeight(_previewsImage.frame)-CGHeight(sender.frame)/2 ));
        }else
        {
            if (CGRectGetMaxX(sender.frame)  >= CGWidth(_previewsImage.frame) ) {
                
                sender.center =CGPointMake((CGWidth(_previewsImage.frame)-CGWidth(sender.frame)/2 ),  (CGHeight(_previewsImage.frame)-CGHeight(sender.frame)/2 ));
                
            }else if(CGOriginX(sender.frame)  <= 0)
            {
                sender.center =CGPointMake((CGWidth(sender.frame)/2 ), (CGHeight(_previewsImage.frame)-CGHeight(sender.frame)/2));
            }else
            {
                sender.center =CGPointMake(point.x , (CGHeight(_previewsImage.frame)-CGHeight(sender.frame)/2 ));
            }
        }
        return;
        
    }else if (CGOriginY(sender.frame)  <= 0)
    {
        if ((point.y-CGHeight(sender.frame)/2) >0 && (point.x-CGWidth(sender.frame)/2) >0 && (point.x+CGWidth(sender.frame)/2) < CGWidth(_previewsImage.frame)) {
            
            sender.center =CGPointMake(point.x , point.y);
            
        }else if((point.x-CGWidth(sender.frame)/2) >0 &&(point.x+CGWidth(sender.frame)/2) < CGWidth(_previewsImage.frame))
        {
            sender.center =CGPointMake(point.x , CGHeight(sender.frame)/2 );
        }else
        {
            if (CGRectGetMaxX(sender.frame)  >= CGWidth(_previewsImage.frame) ) {
                sender.center =CGPointMake((CGWidth(_previewsImage.frame)-CGWidth(sender.frame)/2 ), CGHeight(sender.frame)/2 );
                
            }else if(CGOriginX(sender.frame)  <= 0)
            {
                sender.center =CGPointMake((CGWidth(sender.frame)/2 ),CGHeight(sender.frame)/2);
            }else
            {
                sender.center =CGPointMake(point.x , CGHeight(sender.frame)/2 );
                
            }
        }
        return;
    }else
        
        sender.center =CGPointMake(point.x , point.y);
}
/**
 *  点击标签进行翻转 当位子不够的时候就不让翻转
 */
-(void)tagViewTapClick:(UITapGestureRecognizer *)sender
{
    _tagView =(MiYiTagView *)sender.view;
    if(_tagView.overturn)
    {
        if (CGOriginX(sender.view.frame)+sender.view.frame.size.width>= CGWidth(_previewsImage.frame)) {
            return;
        }
        sender.view.frame =(CGRect){{CGOriginX(sender.view.frame)+sender.view.frame.size.width ,CGOriginY(sender.view.frame)},sender.view.frame.size};
        _tagView.overturn=NO;
    }else
    {
        if (CGOriginX(sender.view.frame)-sender.view.frame.size.width<= 0) {
            return;
        }
        sender.view.frame =(CGRect){{CGOriginX(sender.view.frame)-sender.view.frame.size.width ,CGOriginY(sender.view.frame)},sender.view.frame.size};
        _tagView.overturn=YES;
    }
}
/**
 *  标签长按手势 长按弹出menu    有编辑和删除
 */
-(void)tagViewLongPressClick:(UILongPressGestureRecognizer *)sender
{
    _tagView =(MiYiTagView *)sender.view;
    
    if (sender.state ==UIGestureRecognizerStateBegan) {
        [sender.view becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(menuItem1Pressed)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem2Pressed)];
        
        NSArray *menuItems = [NSArray arrayWithObjects:item1,item2,nil];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        [popMenu setTargetRect:sender.view.frame inView:_previewsImage];
        [popMenu setMenuVisible:YES animated:YES];
    }
    
}

//编辑
-(void)menuItem1Pressed
{
    MiYiTagSearchBarVC *vc =[[MiYiTagSearchBarVC alloc]init];
    vc.block=^(NSString *text)
    {
        [self tagViewFrameText:text tagView:_tagView];
        [self tagViewPan:_tagView point:_tagView.center];
        
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
//删除
-(void)menuItem2Pressed
{
    for (MiYiTagView *tagView in self.tagArray) {
        if ([tagView isEqual: _tagView]) {
            [self.tagArray removeObject:tagView];
            [_tagView removeFromSuperview];
            break;
        }
    }
}


-(void)removeTag
{
    for (int i=0;i< self.tagArray.count ;i++) {
        MiYiTagView *tagView =self.tagArray[i];
        
        [tagView removeFromSuperview];
    }
    [self.tagArray removeAllObjects];
    [_tagView removeFromSuperview];
    
}


/**
 *  返回这个图片所有的标签地址内容，是否翻转样式的数组   坐标为这个图片的真实坐标
 */
-(void)returnsData
{
    if(_coverView.alpha==1)
    {
        [self.tagArray removeLastObject];
    }
    _postsImageSModel.tags =[NSMutableArray array];
    for (MiYiTagView *tagView in self.tagArray) {
        MiYiPostsImageTagIdsModel *model =[[MiYiPostsImageTagIdsModel alloc]init];
        [_postsImageSModel.tags addObject:model];
        
        NSString * style =@"0";
        NSString * position =[NSString stringWithFormat:@"%f,%f",CGOriginX(tagView.frame)/_imageScale,CGOriginY(tagView.frame)/_imageScale];
        if(tagView.overturn ==YES)
        {
            style =@"1";
            position =[NSString stringWithFormat:@"%f,%f",CGRectGetMaxX(tagView.frame)/_imageScale,CGOriginY(tagView.frame)/_imageScale];
        }
        MiYiPostsImageTagIdsModel *tagModel =[_postsImageSModel.tags lastObject];
        tagModel.tag_position=position;
        tagModel.tag_style=style;
        tagModel.tag_content=tagView.waterflowImage.labelText.text;
    }
}
/**
 *  计算出这个图片的在屏幕上显示不拉伸的最好的尺寸  并取出比例值
 */
-(void)imageTagFrame:(BOOL)isComputing
{
    UIImage *image =_previewsImage.image;
    /**
     *  如果为YES  则是不计算  不计算则按照屏幕宽度来计算比例
     */
    if (isComputing) {
        _imageScale = image.size.width / image.size.height;
        _imageScale=kWindowWidth /image.size.width;
        _previewsImage.contentMode=UIViewContentModeScaleAspectFill;
        CGRect noScale = CGRectMake(0.0, 0.0, kWindowWidth, kWindowWidth );
        _previewsImage.frame=(CGRect){{0,0} ,noScale.size};
        return ;
    }
    CGFloat imageScale;
    CGRect noScale = CGRectMake(0.0, 0.0, image.size.width , image.size.height );
    if (CGWidth(noScale) <= kWindowWidth && CGHeight(noScale) <= self.frame.size.height) {
        _imageScale=1.0;
        _previewsImage.frame=(CGRect){{kWindowWidth/2 -noScale.size.width/2,self.frame.size.height /2 -noScale.size.height/2} ,noScale.size};
        return ;
    }
    
    CGRect scaled;
    
    imageScale = self.frame.size.height / image.size.height;
    scaled = CGRectMake(0.0, 0.0, image.size.width * imageScale , image.size.height * imageScale );
    if (CGWidth(scaled) <= kWindowWidth && CGHeight(scaled) <= self.frame.size.height) {
        _imageScale=imageScale;
        _previewsImage.frame=(CGRect){{kWindowWidth/2 -scaled.size.width/2,self.frame.size.height /2 -scaled.size.height/2} ,scaled.size};
        return ;
    }
    
    imageScale = kWindowWidth / image.size.width;
    scaled = CGRectMake(0.0, 0.0, image.size.width * imageScale, image.size.height * imageScale);
    _previewsImage.frame=(CGRect){{kWindowWidth/2 -scaled.size.width/2,self.frame.size.height /2 -scaled.size.height/2} ,scaled.size};
    _imageScale=imageScale;
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    
}

@end
