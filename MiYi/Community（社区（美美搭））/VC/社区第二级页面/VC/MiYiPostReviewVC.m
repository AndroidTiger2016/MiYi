//
//  MiYiPostReviewVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/9/18.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiPostReviewVC.h"
#import "MiYiCommentsPostDetailCell.h"
#import <MJExtension.h>
#import "MiYiPhotosView.h"
#import "MiYiTextField.h"
#import "MiYiDynamicScrollView.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiPostsRequest.h"
#import "MiYiNavViewController.h"
#import "MiYiLoginVC.h"
#import "MiYiUserSession.h"
#import <MJRefresh.h>
#import "MiYiPostsRequest.h"

@interface MiYiPostReviewVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MiYiTextField *textFieldReview;
    UIView *textFieldView;
    UIButton *buttonAddAlbum;
    MiYiDynamicScrollView *scrollView;
    NSInteger dataCount;
    MiYiMenuSentModel *sentModel;
    NSString *showMessageText;
    MBProgressHUD *hud;
    
}
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,assign) NSInteger page;

@end


@implementation MiYiPostReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table =[self getTableView];
    _tableView=table;
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    
    textFieldView =[UIView new];
    textFieldView.backgroundColor=UIColorRGBA(244, 244, 244, 1);
    [self.view addSubview:textFieldView];
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 49));
    }];
    
    textFieldReview =[self getTextFieldReview];
    [textFieldView addSubview:textFieldReview];
    [textFieldReview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textFieldView);
        make.left.equalTo(@5);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth*0.8, 30));
        
    }];
    
    buttonAddAlbum =[self getButtonAddAlbum];
    [buttonAddAlbum sizeToFit];
    [buttonAddAlbum addTarget:self action:@selector(clickButtonAddAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [textFieldView addSubview:buttonAddAlbum];
    [buttonAddAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textFieldView);
        make.right.equalTo(textFieldView.mas_right).offset(-15);
        make.size.mas_equalTo(buttonAddAlbum.frame.size);
    }];
    
    
    scrollView =[self getScrollView];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textFieldView.mas_top);
        make.left.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth, 60));
    }];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    

    _tableView.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _tableView.footer.automaticallyHidden=YES;
    
}

#pragma -Mark 监听

-(void)headerRefresh{
    WS(ws)
    [MiYiPostsRequest getReviewsTopicUserUid:_model.topic_id topic_page:[NSString stringWithFormat:@"1"] json:^(id json) {
        _page=1;
        NSArray *modelArray =[MiYiPostDatailsModel objectArrayWithKeyValuesArray:json[@"data"][@"comment"]];
        if (modelArray.count ==0) {
            return ;
        }
        NSMutableArray *array =[NSMutableArray array];
        [ws traverseData:array newData:modelArray olderData:ws.dataArray];
        [ws.dataArray addObjectsFromArray:array];
        [ws.tableView reloadData];
    } error:^(NSError *error) {
    }];
}

-(void)footerRefresh{
        WS(ws)
        [MiYiPostsRequest getReviewsTopicUserUid:_model.topic_id topic_page:[NSString stringWithFormat:@"%ld",(long)_page] json:^(id json) {
            NSArray *modelArray =[MiYiPostDatailsModel objectArrayWithKeyValuesArray:json[@"data"][@"comment"]];
            if (modelArray.count ==0) {
                return ;
            }
            NSMutableArray *array =[NSMutableArray array];
            [ws traverseData:array newData:modelArray olderData:ws.dataArray];
            [ws.dataArray addObjectsFromArray:array];
            [ws.tableView reloadData];
            [ws.tableView.footer endRefreshing];
            ++_page;
        } error:^(NSError *error) {
        }];
}

/**
 *  筛选相同数据
 *
 *  @param array        新数组用于保存筛选后的数据
 *  @param newDataArray 准备筛选的新数据
 *  @param olderData    旧数据
 */
-(void)traverseData:(NSMutableArray *)array newData:(NSArray *)newDataArray olderData:(NSMutableArray *)olderData{
    NSMutableArray *theProvisional = [NSMutableArray array];
    [theProvisional addObjectsFromArray:newDataArray];
    if(olderData.count){
        for (int a = 0; a < theProvisional.count; a++){
            MiYiPostDatailsModel *model = theProvisional[a];
            for (int p = 0; p < olderData.count; p++){
                MiYiPostDatailsModel *st = olderData[p];
                if ([model.comment_id  isEqualToString:st.comment_id]) {
                    [self.dataArray removeObject:st];
                }
            }
        }
        [array addObjectsFromArray:theProvisional];
    }else{
        [array addObjectsFromArray:theProvisional];
    }
}

#pragma -Mark 点击

-(void)clickButtonAddAlbum:(UIButton *)btn{
    if (btn.selected) {
        scrollView.alpha=0;
        btn.selected=NO;
    }else{
        scrollView.alpha=1;
        btn.selected=YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MiYiCommentsPostDetailCell*cell =[MiYiCommentsPostDetailCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"%@",[self class]]];
    cell.postDatailsModel=self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiYiPostDatailsModel *postDatails = self.dataArray[indexPath.row];
    
    for (int i =0; i < postDatails.images.count; i++) {
        MiYiPostsImageSModel *model =[MiYiPostsImageSModel objectWithKeyValues:postDatails.images[i]];
        if (model.img_url==nil) {
            return 73+postDatails.cellTextHeight;
        }
    }
    CGSize size =[MiYiPhotosView photosViewSizeWithPhotosCount:postDatails.images.count];
    return 73+postDatails.cellTextHeight+size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma -Mark 发送评论
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length==0 && scrollView.menuSentModel.images.count==0){
        [MBProgressHUD showError:@"不能为空"];
        return [textField resignFirstResponder];
    }
    if ([MiYiUserSession shared].session ==nil) {
        MiYiLoginVC *vc =[[MiYiLoginVC alloc]init];
        MiYiNavViewController *nav =[[MiYiNavViewController alloc]initWithRootViewController:vc];
        vc.isWindow=YES;
        [self presentViewController:nav animated:YES completion:nil];
        return [textField resignFirstResponder];
    }

    
    if (scrollView.menuSentModel.images.count==0) {
        [MBProgressHUD showMessage:@"正在发送中"];
        sentModel =[[MiYiMenuSentModel alloc]init];
        [self dataProcessing];
        return [textField resignFirstResponder];
    }
    sentModel =[scrollView.menuSentModel copy];
    dataCount=0;
    MiYiPostsImageSModel *model =sentModel.images[dataCount];
    
    UIView * view = [[UIApplication sharedApplication].windows lastObject];
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;
    hud.labelText =[NSString stringWithFormat:@"%ld/%ld",dataCount+1,sentModel.images.count];
    hud.removeFromSuperViewOnHide = YES;
    [self uploadImage:model];
    return [textField resignFirstResponder];
}

-(void)uploadImage:(MiYiPostsImageSModel *)imagesModelCount{
    WS(ws)
    hud.labelText=[NSString stringWithFormat:@"%ld/%ld",dataCount+1,sentModel.images.count];
    [MiYiUserRequest uploadImage:imagesModelCount.img_url blockJson:^(id json) {
        if ([json isEqual:@NO]) {
            [MBProgressHUD showError:@"上传失败"];
            return ;
        }
        NSString *url =json[@"data"][@"url"];
        UIImage *image =imagesModelCount.img_url;
        imagesModelCount.size=[NSString stringWithFormat:@"%f,%f",CGWidth(image),CGHeight(image)];
        imagesModelCount.img_url =url;
        [ws imageDataProcessing];

    }];
}
-(void)imageDataProcessing
{
    ++dataCount;
    if (dataCount <= sentModel.images.count-1) {
        MiYiPostsImageSModel *model =sentModel.images[dataCount];
        [self uploadImage:model];
    }else{
        for (int i=0; i<sentModel.images.count; i++) {
            MiYiPostsImageSModel *imagemodel =sentModel.images[i];
            if (!imagemodel.img_url) {
                imagemodel.img_url=@"";
            }
            if (!imagemodel.bounds) {
                imagemodel.bounds=@"";
            }
            if (!imagemodel.tags) {
                imagemodel.tags=[NSMutableArray array];
            }
        }

        sentModel.location=@"";
        if (textFieldReview.textField.text.length ==0) {
            sentModel.content =@"";
        }else{
            sentModel.content =textFieldReview.textField.text;
        }

        NSMutableDictionary * dic =[sentModel keyValues];
        NSString *data = [dic JSONString];
        WS(ws)
        [MiYiPostsRequest  commentData:data topic_id:_model.topic_id  success:^(BOOL success){
            [hud hide:YES];
            if (success) {
                [ws headerRefresh];
                _model.comment_count=[NSString stringWithFormat:@"%ld",(long)[_model.comment_count integerValue]+1];
                textFieldReview.textField.text=@"";
                [scrollView removeUI];
                scrollView.menuSentModel=nil;
                [MBProgressHUD showSuccess:@"评论成功"];
            }else{
                [MBProgressHUD showError:@"评论失败"];
            }
        }];
    }
}

-(void)dataProcessing
{
    sentModel.images=[NSMutableArray array];
    sentModel.location=@"";
    if (textFieldReview.textField.text.length ==0) {
        sentModel.content =@"";
    }else{
        sentModel.content =textFieldReview.textField.text;
    }
    NSMutableDictionary * dic =[sentModel keyValues];
    NSString *data = [dic JSONString];
    WS(ws)
    [MiYiPostsRequest  commentData:data topic_id:_model.topic_id success:^(BOOL success) {
        [MBProgressHUD hideHUD];
        if (success) {
            [ws headerRefresh];
            _model.comment_count=[NSString stringWithFormat:@"%ld",(long)[_model.comment_count integerValue]+1];
            textFieldReview.textField.text=@"";
            [scrollView removeUI];
            scrollView.menuSentModel=nil;
            [MBProgressHUD showSuccess:@"评论成功"];
        }else{
            [MBProgressHUD showError:@"评论失败"];
        }
    }];
}



#pragma -Mark  NSNotification

- (void)keyboardShow:(NSNotification *)notification {
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        scrollView.transform = CGAffineTransformMakeTranslation(0, -CGHeight(keyboardF));
        textFieldView.transform = CGAffineTransformMakeTranslation(0, -CGHeight(keyboardF));
    }];
}

- (void)keyboardHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        scrollView.transform = CGAffineTransformIdentity;
        textFieldView.transform = CGAffineTransformIdentity;
    }];
}

#pragma  -Mark pop 回调

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_popBlock) {
        _popBlock();
    }
}
#pragma -Mark 初始化

-(UITableView *)getTableView{
    UITableView *table =[UITableView new];
    table.dataSource=self;
    table.delegate=self;
    table.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    table.tableFooterView=[[UIView alloc]init];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return table;
}

-(MiYiTextField *)getTextFieldReview{
    MiYiTextField *field =[MiYiTextField new];
    field.backgroundColor=[UIColor whiteColor];
    field.layer.borderColor=[UIColor lightGrayColor].CGColor;
    field.layer.borderWidth=1;
    field.layer.masksToBounds=YES;
    field.layer.cornerRadius=15;
    field.textField.delegate=self;
    field.textField.returnKeyType=UIReturnKeySend;
    field.textField.textColor = [UIColor lightGrayColor];
    field.textField.font = Font(11);
    field.textField.clearButtonMode = UITextFieldViewModeAlways;
    field.textField.textAlignment = NSTextAlignmentLeft;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    field.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"快来说两句吧" attributes:attrs];
    UIView *image = [[UIView alloc] initWithFrame:(CGRect){0,15,10,5}];
    field.textField.leftView = image;
    field.textField.leftViewMode = UITextFieldViewModeAlways;
    return field;
}

-(UIButton *)getButtonAddAlbum{
    UIButton *btn =[UIButton new];
    [btn setImage:[UIImage imageNamed:@"AddAlbum"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Keyboard"] forState:UIControlStateSelected];
    return btn;
}

-(MiYiDynamicScrollView *)getScrollView{
    MiYiDynamicScrollView *scroll=[MiYiDynamicScrollView new];
    scroll.viewController=self;
    scroll.isMenu=YES;
    scroll.menuSentModel=nil;
    scroll.alpha=0;
    scroll.backgroundColor=[UIColor whiteColor];
    return scroll;
}
@end
