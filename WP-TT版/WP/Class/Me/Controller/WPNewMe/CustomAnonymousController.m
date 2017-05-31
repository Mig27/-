//
//  CustomAnonymousController.m
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "CustomAnonymousController.h"
#import "NewInputView.h"
#import "AnonymousModel.h"
#import "AnonymousManager.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "SPPhotoAsset.h"
#import "WPActionSheet.h"
#import "UIImageView+WebCache.h"
#import "HJCActionSheet.h"

//#import <AudioToolbox/AudioToolbox.h>

#define kPersonal_info @"/ios/personal_info.ashx"
#define kButtonHeight 60
@interface CustomAnonymousController ()<WPActionSheet,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HJCActionSheetDelegate>
{
    BOOL photo;
}
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic ,strong)UIView *contentView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic ,strong)NSArray *placeholderArr;
@property (nonatomic ,strong)NSMutableArray *textFieldArr;
@property (nonatomic ,strong)UIImageView *imageView;
@end

@implementation CustomAnonymousController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.title = @"自定义匿名信息";
    
    [self.view addSubview:self.button];
    AnonymousModel *model = [AnonymousManager sharedManager].model;
    if (model.photo) {
        [self.view addSubview:self.imageView];
    }
    [self.view addSubview:self.contentView];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}
-(void)backToFromViewController:(UIButton *)sender;
{
    AnonymousModel *model = [AnonymousManager sharedManager].model;
    BOOL isOrNot = NO;
    if (photo) {
        isOrNot = YES;
    }
    int i = 0;
    for (UITextField * textField in self.textFieldArr) {
        if (i == 0) {
            if (![textField.text isEqualToString:model.name]) {
                isOrNot = YES;
            }
        }else if(i == 1){
            if (![textField.text isEqualToString:model.postionName]) {
                isOrNot = YES;
            };
        }
         i ++;
    }
    if (isOrNot) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 667788;
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 667788) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated: YES];
        }
    }
}
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    AnonymousModel *model = [AnonymousManager sharedManager].model;
    int i = 0;
    for (UITextField *textfield in self.textFieldArr) {
        if (i == 0) {
            model.name = textfield.text;
        }else if(i == 1){
            model.postionName = textfield.text;
        }
        i ++;
    }
    UIImage *image;
    if (!photo) {
        image = self.imageView.image;
    }else{
        image = self.button.imageView.image;
    }
    
    model.is_default = @"1";
    WPFormData *data = [[WPFormData alloc]init];
    data.data = UIImageJPEGRepresentation(image, 1);
    data.name = @"photo";
    data.filename = @"photo.png";
    data.mimeType = @"png";
    NSArray *dataArr = @[data];
    NSString *url = [IPADDRESS stringByAppendingString:kPersonal_info];
    if ([self couldCommit]) {
        return;
    }
    NSDictionary *params = @{@"action":@"SetAnonymity",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"name":model.name,
                             @"is_default":model.is_default,
                             @"postionName":model.postionName};
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:url params:params formDataArray:dataArr success:^(id json) {
        NSLog(@"%@",json[@"status"]);
        [MBProgressHUD hideHUDForView:self.view];
        if (![json[@"status"]integerValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *arr = self.navigationController.viewControllers;
                self.delegate = arr[2];
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestForData)]) {
                    [self.delegate requestForData];
                }
                
                [self.navigationController popToViewController:arr[2] animated:YES];
            });
        }
        else
        {
            [MBProgressHUD createHUD:@"操作失败!" View:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (BOOL)couldCommit
{
    AnonymousModel *model = [AnonymousManager sharedManager].model;
    if (!model.photo) {
        if (!photo) {
            [self alertViewShowWithMessage:@"请选择匿名头像"];
            return YES;
        }
    }
    int i = 0;
    for (UITextField *textfield in self.textFieldArr) {
        {
            if (textfield.text.length == 0) {
                if (i == 0) {
                    [self alertViewShowWithMessage:@"请选择匿名名称"];
                    return YES;
                }else if (i == 1){
                    [self alertViewShowWithMessage:@"请选择匿名职位"];
                    return YES;
                }
            }
            i++;
        }
    }
    return NO;
}

- (void)alertViewShowWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alert show];
}

- (UIView *)contentView
{
    if (!_contentView) {
        int i = 0;
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+kButtonHeight+kHEIGHT(10)*2, SCREEN_WIDTH, kHEIGHT(43)*3)];
        AnonymousModel *model = [AnonymousManager sharedManager].model;
        for (NSString *string in self.titleArr) {
            NewInputView *view = [[NewInputView alloc]initWithFrame:CGRectMake(0, i*kHEIGHT(43.5), SCREEN_WIDTH,kHEIGHT(43))];
            [view setTitle:string placeholder:self.placeholderArr[i]];
            if (i == 0) {
                view.textField.text = model.name;
            }
            if (i == 1) {
                view.textField.text = model.postionName;
            }
            if (i == 2) {
                view.textField.text = self.placeholderArr[i];
                view.textField.enabled = NO;
            }
            [self.contentView addSubview:view];
            [self.textFieldArr addObject:view.textField];
            i++;
        }
    }
    return _contentView;
}

- (NSMutableArray *)textFieldArr
{
    if (!_textFieldArr) {
        self.textFieldArr = [NSMutableArray array];
    }
    return _textFieldArr;
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.button setImage:[UIImage imageNamed:@"commom_tianjia"] forState:UIControlStateNormal];
        self.button.frame = CGRectMake(kHEIGHT(10), 64+kHEIGHT(10), kButtonHeight, kButtonHeight);
        self.button.layer.cornerRadius = 5;
        self.button.layer.masksToBounds = YES;
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _button;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), 64+kHEIGHT(10), kButtonHeight, kButtonHeight)];
        AnonymousModel *model = [AnonymousManager sharedManager].model;
        NSString *url = [IPADDRESS stringByAppendingString:model.photo];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        self.titleArr = @[@"匿名名称:",@"匿名职位:",@"匿名公司:"];
    }
    return _titleArr;
}

- (NSArray *)placeholderArr
{
    if (!_placeholderArr) {
        self.placeholderArr = @[@"请填写匿名名称",@"请填写匿名职位",@"匿名(系统默认)"];
    }
    return _placeholderArr;
}

- (void)buttonAction:(UIButton *)sender
{
////    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
//    actionSheet.tag = 40;
//    [actionSheet showInView:self.view];
    
    [self.view endEditing:YES];
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
    // 2.显示出来
    [sheet show];
    
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if (buttonIndex == 1) {//相册
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
        // 创建控制器
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.minCount = 1;//12-》8
        [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
        pickerVc.callBack = ^(NSArray *assets){
            for (MLSelectPhotoAssets *asset in assets) {
                UIImage * image = [asset originImage];
                [_button setImage:image forState:UIControlStateNormal];
                photo = YES;
                [self.imageView removeFromSuperview];
            }
        };
        
        
    } else if (buttonIndex == 2) {//拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
    
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if (sheet.tag == 40) {
        if (buttonIndex == 1) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        if (buttonIndex == 2) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [_button setImage:image forState:UIControlStateNormal];
    photo = YES;
    [self.imageView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
