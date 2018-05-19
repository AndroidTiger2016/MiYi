//
//  MiYiInformationModificationVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/10.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiInformationModificationVC.h"
#import "MiYiCellItem.h"
#import "MiYiItemGroup.h"
#import "MiYiLableItem.h"
#import "UIImage+MiYi.h"
#import "MiYiModificationNameVC.h"
#import "MiYiUser.h"
#import "MiYiModificationIntroductionVC.h"
#import "MiYiImageItem.h"
#import "MiYiUserRequest.h"
#import "MBProgressHUD+YXL.h"
#import "MiYiSideslipVC.h"
#import "MiYiUser.h"
@interface MiYiInformationModificationVC ()<UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain)  MiYiImageItem *imageItem;

@end

@implementation MiYiInformationModificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    self.edgesForExtendedLayout =UIRectEdgeAll;
    
    [self addOne];
    [self addTow];
    // Do any additional setup after loading the view.
}

-(void)addOne
{
    MiYiItemGroup *group=[self addGroup];
    
    MiYiImageItem *itemOne =[MiYiImageItem itemWithTitle:@"头像" image:[[MiYiUser shared]accountUser].avatar];
    //    __block MiYiImageItem *itemOneBlock = itemOne;
    _imageItem = itemOne;
    itemOne.operation = ^{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选取",@"拍照", nil];
        [sheet showInView:self.view];
    };
    
    
    group.items=@[itemOne];
}

-(void)addTow
{
    MiYiItemGroup *group=[self addGroup];
    
    MiYiLableItem *itemOne =[MiYiLableItem itemWithTitle:@"昵称"];
    itemOne.subtitle=[[MiYiUser shared]accountUser].nickname;
    __block MiYiLableItem *itemOneBlock=itemOne;
    itemOne.operation=^{
        MiYiModificationNameVC *vc =[[MiYiModificationNameVC alloc]init];
        vc.block=^(NSString *name){
            itemOneBlock.subtitle=name;
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    MiYiLableItem *itemTow =[MiYiLableItem itemWithTitle:@"签名"];
    itemTow.subtitle=[[MiYiUser shared]accountUser].summary;
    __block MiYiLableItem *itemTowBlock=itemTow;
    itemTow.operation=^{
        MiYiModificationIntroductionVC *vc =[[MiYiModificationIntroductionVC alloc]init];
        vc.block=^(NSString *name){
            itemTowBlock.subtitle=name;
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    MiYiLableItem *location = [MiYiLableItem itemWithTitle:@"城市"];
    location.subtitle = [[MiYiUser shared] accountUser].location;  // 经纬度还是城市位置
    
    __block MiYiLableItem *itemLocation = location;
    itemLocation.operation = ^{
        NSLog(@"修改城市暂时不写");
    };
    
    group.items=@[itemOne,itemTow, location];
}

-(void)back:(id)sender{
    _popBlock();
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _popBlock();
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _image = image;
    [MiYiUserRequest uploadImage:_image blockJson:^(id json) {
        if ([json isEqual:@NO]) {
            [MBProgressHUD showError:@"上传失败"];
            return ;
        }
        [MiYiUserRequest modifyInformationType:MiYiUserRequest_typeUserIcon Contents:json[@"data"][@"url"] Success:^(BOOL success) {
            if (success) {
                MiYiAccount *account=[[MiYiUser shared]accountUser];
                account.avatar =json[@"data"][@"url"];
                [[MiYiUser shared] saveAccountUser:account];
                [[MiYiSideslipVC shared].leftControl userData:account];
                [Notification postNotificationName:MiYiHomeVCNavItemNotification object:nil];
                _imageItem.image = json[@"data"][@"url"];
                [self.tableView reloadData];
                [MBProgressHUD showSuccess:@"修改成功"];
            }else{
                [MBProgressHUD showError:@"修改失败"];
            }
        }];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerController cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheet
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                return;
        }
    } else {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    UIImagePickerController *picture = [[UIImagePickerController alloc] init];
    picture.delegate = self;
    picture.sourceType = sourceType;
    picture.allowsEditing = YES;
    [self presentViewController:picture animated:YES completion:nil];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row==0) {
            return 80;
        }
        
    }
    return 44;
}
@end
