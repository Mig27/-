//
//  WPCreateGroupNoticeViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/5/11.
//  Copyright © 2016年 WP. All rights reserved.
//  公告创建和修改界面

#import "WPCreateGroupNoticeViewController.h"
#import "RSTextView.h"
#import "HJCActionSheet.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "SPPhotoAsset.h"
#import "DDGroupModule.h"
#import "MTTSessionEntity.h"
#import "SessionModule.h"
#import "MTTDatabaseUtil.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "DDMessageSendManager.h"
@interface WPCreateGroupNoticeViewController ()<UITextFieldDelegate,HJCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) RSTextView *textView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) BOOL isPhoto;

@end

@implementation WPCreateGroupNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    [self initNav];
    [self createUI];
}

- (void)initNav
{
    self.isPhoto = NO;
    self.view.backgroundColor = BackGroundColor;
    self.title = @"群公告";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
    if (_textField.text.length == 0) {
        [MBProgressHUD createHUD:@"标题不可为空！" View:self.view];
        return;
    }
    
    if (_textField.text.length < 4) {
        [MBProgressHUD createHUD:@"标题最少4个字..." View:self.view];
        return;
    }
    
    if (_textView.text.length == 0) {
        [MBProgressHUD createHUD:@"正文不可为空！" View:self.view];
        return;
    }
    
    if (_textView.text.length < 15) {
        [MBProgressHUD createHUD:@"正文最少15个字..." View:self.view];
        return;
    }
    if (!self.isPhoto) {
        [MBProgressHUD createHUD:@"请选择图片" View:self.view];
        return;
    }
    
    NSMutableArray *photoData = [NSMutableArray array];
    if (self.isPhoto) {
        UIImage *image = _photoView.image;
        WPFormData *formData = [[WPFormData alloc]init];
        formData.data = UIImageJPEGRepresentation(image, 0.5);
        formData.name = [NSString stringWithFormat:@"photoAddress"];
        formData.filename = [NSString stringWithFormat:@"photoAddress.jpg"];
        formData.mimeType = @"application/octet-stream";
        [photoData addObject:formData];
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = self.isEditing ? @"UpdateNotice" : @"AddNotice";
    params[@"group_id"] = self.infoModel.group_id;
    params[@"group_name"] = self.infoModel.group_name;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"user_id"] = kShareModel.userId;
    params[@"notice_title"] = _textField.text;
    params[@"notice_content"] = _textView.text;
    if (self.isEditing) {
        params[@"id"] = self.model.notice_id;
    }
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params formDataArray:photoData success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"status"] integerValue] == 0) {
            if (!self.isEditing) {//创建
                if (self.createSuccessBlock) {
                    self.createSuccessBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupUpdate" object:nil];
            } else {
                if (self.modifiedSuccessBlock) {
                    self.modifiedSuccessBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeUpdate" object:nil userInfo:@{@"index" : self.currentIndex}];
            }
            if (self.isEditing) {
               [self sendGroupAblumMessage:self.model.notice_id andAvatar:json[@"photo"] editOr:YES];
            }
            else
            {
              [self sendGroupAblumMessage:json[@"id"] andAvatar:json[@"photo"] editOr:NO];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}


-(void)sendGroupAblumMessage:(NSString*)ablumId andAvatar:(NSString*)avatar editOr:(BOOL)isEdit
{
    
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {
        
        
        MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        
        if (!session)
        {//不存在时要创建
            session = [[MTTSessionEntity alloc]initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
            [[SessionModule instance] addToSessionModel:session];
            [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
            }];
        }
        
        ChattingModule*mouble = [[ChattingModule alloc] init];
        mouble.MTTSessionEntity = session;
        DDMessageContentType msgContentType = DDMEssageLitteralbume;
        
        NSString * changeStr = isEdit?@"修改":@"发布";
        NSString * sessionStr = isEdit?@"修改了群公告":@"发布了群公告";
       // NSDictionary *loginDic = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
        NSDictionary * dictionary = @{@"display_type":@"13",@"content":@{@"from_type":@"0",
                                                                         @"from_title":[NSString stringWithFormat:@"%@了群公告:%@",changeStr,_textField.text],
                                                                         @"from_info":_textView.text,
                                                                         @"from_qun_id":self.infoModel.group_id,
                                                                         @"from_g_id":self.groupId,
                                                                         @"from_id":ablumId,
                                                                         @"from_avatar":avatar,
                                                                         @"session_info":sessionStr}};//usernameStr//nick_name
        
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble?self.mouble:mouble MsgType:msgContentType];
        
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            DDLog(@"消息插入DB成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDARGUMENTSUCCESS" object:message];
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        message.msgContent = contentStr;
        [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        } Error:^(NSError *error) {
        }];
    }];
}




- (void)delay
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kHEIGHT(43) + kHEIGHT(170)));
    }];
    
    UILabel *title = [UILabel new];
    title.text = @"标题 ：";
    title.font = kFONT(15);
//    title.backgroundColor = [UIColor redColor];
    [self.view addSubview:title];
//    [title sizeToFit];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kHEIGHT(10));
        make.top.equalTo(backView.mas_top);
        make.height.equalTo(@(kHEIGHT(43)));
    }];
    
    //设置label1的content hugging 为1000
    [title setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置label1的content compression 为1000
    [title setContentCompressionResistancePriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];

    _textField = [UITextField new];
    _textField.delegate = self;
    _textField.font = kFONT(15);
    UIColor *color = RGB(170, 170, 170);
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"4-18字" attributes:@{NSForegroundColorAttributeName: color}];
    _textField.tintColor = color;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right);
        make.top.equalTo(title.mas_top);
        make.right.equalTo(self.view.mas_right).offset(-kHEIGHT(10));
        make.height.equalTo(@(kHEIGHT(43)));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = RGB(226, 226, 226);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(title.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    _photoView = [UIImageView new];
    _photoView.image = [UIImage imageNamed:@"write_bounds"];
    _photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [_photoView addGestureRecognizer:tap];
    [self.view addSubview:_photoView];
    _photoView.clipsToBounds = YES;
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kHEIGHT(10));
        make.bottom.equalTo(backView.mas_bottom).offset(-kHEIGHT(10));
        make.width.height.equalTo(@((SCREEN_WIDTH - 50)/4));
    }];
    
    _deleteBtn = [UIButton new];
    [_deleteBtn setImage:[UIImage imageNamed:@"UMS_delete_image_button_normal"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoView.mas_top).offset(-5);
        make.right.equalTo(_photoView.mas_right).offset(5);
        make.width.height.equalTo(@(25));
    }];
    
    _textView = [RSTextView new];
    _textView.font = kFONT(15);
    _textView.tintColor = color;
    _textView.myPlaceholder = @"公告正文，15-500字";
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kHEIGHT(5));
        make.right.equalTo(self.view.mas_right).offset(-kHEIGHT(5));
        make.top.equalTo(title.mas_bottom).offset(kHEIGHT(5));
        make.bottom.equalTo(_photoView.mas_top).offset(-kHEIGHT(5));
    }];
    
    if (self.isEditing) {
        [self showInfo];
    }
    [self updateDelete];
}

- (void)showInfo
{
    _textField.text = self.model.notice_title;
    _textView.text = self.model.notice_content;
    if (self.model.notice_photo.length != 0) {
        NSString *url = [IPADDRESS stringByAppendingString:self.model.notice_photo];
        [_photoView sd_setImageWithURL:URLWITHSTR(url)];
        self.isPhoto = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.location>=18)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)updateDelete
{
    self.deleteBtn.hidden = !self.isPhoto;
}

- (void)deleteBtnClick
{
    _photoView.image = [UIImage imageNamed:@"write_bounds"];
    self.isPhoto = NO;
    [self updateDelete];
}

- (void)onTap
{
    self.editing = NO;
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
    // 2.显示出来
    [sheet show];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.minCount = 1;
            [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
            pickerVc.callBack = ^(NSArray *assets){
                for (MLSelectPhotoAssets *asset in assets) {
                    //                    UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                    UIImage *image = asset.originImage;
                    _photoView.image = image;
                    self.isPhoto = YES;
                    [self updateDelete];
                }
            };
            break;
            
        }
        case 2:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;
        }
    }
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
   
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //将图片保存到相册
      UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    _photoView.image = image;
    self.isPhoto = YES;
    [self updateDelete];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
