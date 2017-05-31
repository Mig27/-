//
//  WPGroupCreateViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupCreateViewController.h"
#import "SPItemView.h"
#import "SPSelectView.h"
#import "MyScrollView.h"
#import "UIPlaceHolderTextView.h"
#import "RSTextView.h"
#import "HJCActionSheet.h"
#import "RSButtonMenu.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "SPPhotoAsset.h"
#import "DDCreateGroupAPI.h"
#import "MTTUserEntity.h"
#import "MTTGroupEntity.h"
#import "DDGroupModule.h"
#import "DDGroupModule.h"
#import "LocationViewController.h"
#import "WPGroupInformationViewController.h"
#import "MTTSessionEntity.h"
#import "DDUserModule.h"
#import "MTTUserEntity.h"
#import "MTTUtil.h"
#import "SessionModule.h"
#import "WPtextFiled.h"
#import "MTTDatabaseUtil.h"
@interface WPGroupCreateViewController ()<UITextViewDelegate,HJCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SPSelectViewDelegate,RSButtonMenuDelegate,sendBackLocation,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) WPtextFiled *textField;
@property (nonatomic, strong) UILabel *industryLabel;
@property (nonatomic, strong) UILabel *addressLabe;
@property (nonatomic, strong) RSTextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic,strong) SPSelectView *selectView;        //选择
@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *subView;
@property (nonatomic, strong) NSString *industryID;

@property (nonatomic, copy) NSString * groupId;
@property (nonatomic, copy) NSString * groupName;
@property (nonatomic, copy) NSString * groupAvatar;

@property (nonatomic, strong)UIImage * upLoadImage;

@end

@implementation WPGroupCreateViewController

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
    self.view.backgroundColor = BackGroundColor;
    self.title = @"创建群";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)createUI
{
    UIScrollView *mainScroll = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainScroll.backgroundColor = BackGroundColor;
    mainScroll.delegate = self;
    [self.view addSubview:mainScroll];
    
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    CGFloat width = (SCREEN_WIDTH - 5*kHEIGHT(10))/4;
    CGFloat y = (width - 17 - normalSize2.height - 8)/2;
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + 64, width, width)];
    iconView.backgroundColor = [UIColor whiteColor];
    iconView.clipsToBounds = YES;
    iconView.layer.cornerRadius = 5;
    [mainScroll addSubview:iconView];
    iconView.centerX = SCREEN_WIDTH/2;
    
    UIImageView *camera = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - 10, y, 20, 17)];
    camera.image = [UIImage imageNamed:@"group_camera"];
    [iconView addSubview:camera];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, camera.bottom + 8, width, normalSize2.height)];
    label.text = @"上传头像";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFONT(10);
    [iconView addSubview:label];
    
    self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame = CGRectMake(0, 0, width, width);
    [_iconBtn addTarget:self action:@selector(selectShowImage) forControlEvents:UIControlEventTouchUpInside];
    //    [_iconBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    _iconBtn.layer.cornerRadius = 5;
    _iconBtn.clipsToBounds = YES;
    [iconView addSubview:_iconBtn];
    
    CGSize normalSize = [@"群名称 :" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    UIView *item1 = [[UIView alloc] initWithFrame:CGRectMake(0, iconView.bottom + 15, SCREEN_WIDTH, kHEIGHT(43))];
    item1.backgroundColor = [UIColor whiteColor];
    [mainScroll addSubview:item1];
    UILabel *itemLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, normalSize.width, kHEIGHT(43))];
    itemLabel1.font = kFONT(15);
    itemLabel1.text = @"群名称 :";
    [item1 addSubview:itemLabel1];
    
    _textField = [[WPtextFiled alloc] initWithFrame:CGRectMake(itemLabel1.right + 6, 1, SCREEN_WIDTH - normalSize.width - 6 - 2*kHEIGHT(10), kHEIGHT(43))];
    _textField.centerY = kHEIGHT(43)/2;
    _textField.font = kFONT(15);
    UIColor *color = RGB(170, 170, 170);
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入群名称" attributes:@{NSForegroundColorAttributeName: color}];
    _textField.tintColor = color;
    [item1 addSubview:_textField];
    
    
    UIButton *item2 = [[UIButton alloc] initWithFrame:CGRectMake(0, item1.bottom + 0.5, SCREEN_WIDTH, kHEIGHT(43))];
    item2.tag = 10;
    item2.backgroundColor = [UIColor whiteColor];
    [item2 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    [item2 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:item2];
    
    UILabel *itemLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, normalSize.width, kHEIGHT(43))];
    itemLabel2.font = kFONT(15);
    itemLabel2.text = @"群行业 :";
    [item2 addSubview:itemLabel2];
    
    _industryLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemLabel2.right + 6, 0, SCREEN_WIDTH - 100, kHEIGHT(43))];
    _industryLabel.font = kFONT(15);
    _industryLabel.textColor = RGB(170, 170, 170);
    _industryLabel.text = @"请选择群行业";
    [item2 addSubview:_industryLabel];
    
    UIImageView *rightImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
    rightImageView1.frame = CGRectMake(SCREEN_WIDTH-10-8, kHEIGHT(43)/2-7, 8,14);
    [item2 addSubview:rightImageView1];
    
    UIButton *item3 = [[UIButton alloc] initWithFrame:CGRectMake(0, item2.bottom + 0.5, SCREEN_WIDTH, kHEIGHT(43))];
    item3.tag = 11;
    [item3 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    item3.backgroundColor = [UIColor whiteColor];
    [item3 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    [mainScroll addSubview:item3];
    
    UILabel *itemLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, normalSize.width, kHEIGHT(43))];
    itemLabel3.font = kFONT(15);
    itemLabel3.text = @"群地点 :";
    [item3 addSubview:itemLabel3];
    
    _addressLabe = [[UILabel alloc] initWithFrame:CGRectMake(itemLabel3.right + 6, 0, SCREEN_WIDTH - 100, kHEIGHT(43))];
    _addressLabe.font = kFONT(15);
    _addressLabe.textColor = RGB(170, 170, 170);
    _addressLabe.text = @"请选择群地点";
    [item3 addSubview:_addressLabe];
    
    UIImageView *rightImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"near_act_address"]];
    rightImageView2.frame = CGRectMake(SCREEN_WIDTH-10-12, kHEIGHT(43)/2-8, 12,16);
    [item3 addSubview:rightImageView2];
    
    CGFloat y4 = kHEIGHT(43)/2 - normalSize.height/2;
    UIView *item4 = [[UIView alloc] initWithFrame:CGRectMake(0, item3.bottom + 0.5, SCREEN_WIDTH, kHEIGHT(80))];
    item4.backgroundColor = [UIColor whiteColor];
    [mainScroll addSubview:item4];
    UILabel *itemLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), y4, normalSize.width, normalSize.height)];
    itemLabel4.font = kFONT(15);
    itemLabel4.text = @"群介绍 :";
    [item4 addSubview:itemLabel4];
    
    _textView = [[RSTextView alloc] initWithFrame:CGRectMake(itemLabel4.right + 3, y4 - 7, SCREEN_WIDTH - normalSize.width - 3 - 2*kHEIGHT(10), kHEIGHT(80) - 2*(y4 - 7))];
    //    _textView.backgroundColor = [UIColor redColor];
    _textView.font = kFONT(15);
    _textView.delegate = self;
    _textView.tintColor = color;
    _textView.myPlaceholder = @"请输入群介绍";
    [item4 addSubview:_textView];
    
}

- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        _buttonMenu1.delegate = self;
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64 , SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView1.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backView1];
        
        [_backView1 addSubview:_buttonMenu1];
        
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _subView.backgroundColor = RGBA(0, 0, 0, 0);
        //        _subView.backgroundColor = [UIColor redColor];
        [window addSubview:_subView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(hidden)];
        [_subView addGestureRecognizer:tap1];
        
        __weak typeof(self) unself = self;
        _buttonMenu1.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu1;
}

-(void)backToFromViewController:(UIButton *)sender
{
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否退出本次群组的创建？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    if (_iconBtn.imageView.image == NULL && _textField.text.length == 0 && [_industryLabel.text isEqualToString:@"请选择群行业"] && [_addressLabe.text isEqualToString:@"请选择群地点"] && _textView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBtnClick
{
    [self hidden];
    if (_iconBtn.imageView.image == NULL) {
        [MBProgressHUD createHUD:@"请上传头像" View:self.view];
        return;
    }
    if (_textField.text.length == 0) {
        [MBProgressHUD createHUD:@"请填写群名称" View:self.view];
        return;
    }
    
    if ([_industryLabel.text isEqualToString:@"请选择群行业"]) {
        [MBProgressHUD createHUD:@"请选择群行业" View:self.view];
        return;
    }
    
    if ([_addressLabe.text isEqualToString:@"请选择群地点"]) {
        [MBProgressHUD createHUD:@"请选择群地点" View:self.view];
        return;
    }
    
    if (_textView.text.length == 0) {
        [MBProgressHUD createHUD:@"请填写群介绍" View:self.view];
        return;
    }
    
    NSLog(@"complete");
    [MBProgressHUD showMessage:@"" toView:self.view];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //    NSString *place_name = [NSString stringWithFormat:@"%@",[user objectForKey:@"area"]];
    
    NSMutableArray *photoData = [NSMutableArray array];
    //    UIImage *image = _iconBtn.imageView.image;
    WPFormData *formData = [[WPFormData alloc]init];
    formData.data = UIImageJPEGRepresentation(_upLoadImage, 0.5);//image
    formData.name = [NSString stringWithFormat:@"PhotoAddress1"];
    formData.filename = [NSString stringWithFormat:@"PhotoAddress1.jpg"];
    formData.mimeType = @"application/octet-stream";
    [photoData addObject:formData];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"AddGroup";
    params[@"user_id"] = kShareModel.userId;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"group_name"] = _textField.text;
    params[@"content"] = _textView.text;
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"place_name"] = @"安徽省|合肥市|瑶海区";
    params[@"address"] = _addressLabe.text;
    params[@"Industry_id"] = _industryID;
    params[@"group_Industry"] = _industryLabel.text;
    params[@"PhotoNum"] = @"1";
    params[@"icon"] = @"1";
    NSLog(@"%@",params);
    NSLog(@"%@",photoData[0]);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    
    
    
    DDCreateGroupAPI *creatGroup = [[DDCreateGroupAPI alloc] init];
    __block NSMutableArray *userIDs = [NSMutableArray new];
    [userIDs addObject:TheRuntime.user.objID];
    NSString *groupName = _textField.text;
    NSArray *array = @[groupName,@"",userIDs];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [creatGroup requestWithObject:array Completion:^(MTTGroupEntity * response, NSError *error) {
            if (response !=nil) {
                [[DDGroupModule instance] addGroup:response];
                params[@"g_id"] = [response.objID substringFromIndex:6];
                _groupId = [NSString stringWithFormat:@"%@",[response.objID substringFromIndex:6]];
                _groupName = _textField.text;
                [WPHttpTool postWithURL:url params:params formDataArray:photoData success:^(id json) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view];
                        
                        if ([json[@"status"] integerValue] == 0) {
                            [[DDGroupModule instance] addGroup:response];
                            
                            MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:response.objID type:SessionTypeSessionTypeGroup];
                            session.avatar = TheRuntime.user.avatar;
                            session.lastMsg=@"群创建成功";
                            [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                            }];
                            [[MTTDatabaseUtil instance] updateRecentGroup:response completion:^(NSError *error) {
                            }];
                            
                            
                            NSString * avatarStr = [NSString stringWithFormat:@"%@",json[@"iconPhoto"]];
                            NSArray * avatarArray = [avatarStr componentsSeparatedByString:@","];
                            if (avatarArray.count>1)
                            {
                                _groupAvatar = [NSString stringWithFormat:@"%@",avatarArray[0]];
                                response.avatar = _groupAvatar;
                            }
                            
                            ChattingModule * mouble = [[ChattingModule alloc]init];
                            mouble.MTTSessionEntity = session;
                            NSDictionary * dictionary = @{@"display_type":@"12",
                                                          @"content":@{@"for_userid":@"",
                                                                       @"for_username":@"",
                                                                       @"note_type":@"11",
                                                                       @"create_userid":kShareModel.userId,
                                                                       @"create_username":kShareModel.nick_name,
                                                                       @"for_user_info_1":@"",
                                                                       @"for_user_info_0":@""
                                                                       }
                                                          };
                            DDMessageContentType msgContentType = DDMEssageLitteralbume;
                            NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                            NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
                            
                            [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                                DDLog(@"消息插入DB成功");
                            } failure:^(NSString *errorDescripe) {
                                DDLog(@"消息插入DB失败");
                            }];

                            
                            [MBProgressHUD createHUD:@"您的群创建成功" View:self.view];
                            [self performSelector:@selector(delay) afterDelay:0.8];
                        } else {
                            [MBProgressHUD createHUD:@"您的群创建失败" View:self.view];
                        }
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    });
                } failure:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    });
                }];
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD createHUD:@"您的群创建失败" View:self.view];
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                });
            }
        }];
    });
    
    
    
    //    [creatGroup requestWithObject:array Completion:^(MTTGroupEntity * response, NSError *error) {
    //        if (response !=nil) {
    //            [[DDGroupModule instance] addGroup:response];
    //            params[@"g_id"] = [response.objID substringFromIndex:6];
    //
    //            _groupId = [NSString stringWithFormat:@"%@",[response.objID substringFromIndex:6]];
    //            _groupName = _textField.text;
    //
    //            [WPHttpTool postWithURL:url params:params formDataArray:photoData success:^(id json) {
    //                [MBProgressHUD hideHUDForView:self.view];
    //                if ([json[@"status"] integerValue] == 0) {
    //                    [[DDGroupModule instance] addGroup:response];
    //
    //                    NSString * avatarStr = [NSString stringWithFormat:@"%@",json[@"iconPhoto"]];
    //                    NSArray * avatarArray = [avatarStr componentsSeparatedByString:@","];
    //                    if (avatarArray.count>1)
    //                    {
    //                      _groupAvatar = [NSString stringWithFormat:@"%@",avatarArray[0]];
    //                      response.avatar = _groupAvatar;
    //                    }
    //
    //                    [MBProgressHUD createHUD:@"您的群创建成功" View:self.view];
    //                    [self performSelector:@selector(delay) afterDelay:0.8];
    //                } else {
    //                    [MBProgressHUD createHUD:@"您的群创建失败" View:self.view];
    //                }
    //                self.navigationItem.rightBarButtonItem.enabled = YES;
    //            } failure:^(NSError *error) {
    //                [MBProgressHUD hideHUDForView:self.view];
    //                self.navigationItem.rightBarButtonItem.enabled = YES;
    //            }];
    //
    //        }else
    //        {
    //             [MBProgressHUD hideHUDForView:self.view animated:YES];
    //            [MBProgressHUD createHUD:@"您的群创建失败" View:self.view];
    //
    //            self.navigationItem.rightBarButtonItem.enabled = YES;
    //        }
    //
    //    }];
}

#pragma mark  创建成功
- (void)delay
{
    if (self.createSuccessBlock) {
        self.createSuccessBlock();
    }
    WPGroupInformationViewController *information = [[WPGroupInformationViewController alloc] init];
    [self.navigationController pushViewController:information animated:YES];
    
    information.titleStr = _groupName;
    information.group_id = _groupId;
    information.gtype = @"1";
    information.isFromCreat = YES;
    information.avatarStr = _groupAvatar;
    
    
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",_groupId] completion:^(MTTGroupEntity *group) {
        MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
        session.avatar = _groupAvatar;
        session.lastMsg=@"群创建成功";
        [[SessionModule instance] addToSessionModel:session];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:session];
    }];
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hidden{
    self.subView.hidden = YES;
    self.backView1.hidden = YES;
}

#pragma mark - 选择按钮点击事件
- (void)selectBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (sender.tag == 10) {
        _backView1.hidden = NO;
        _subView.hidden = NO;
        self.buttonMenu1.isGroupCreate = YES;
        [self.buttonMenu1 newSetUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}selectedIndex:-1];
    } else {
        LocationViewController *location = [[LocationViewController alloc] init];
        location.delegate = self;
        location.isFromCreatGroup = YES;
        [self.navigationController pushViewController:location animated:YES];
    }
}

- (void)selectShowImage
{
    NSLog(@"selectPic");
    [self.view endEditing:YES];
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
    // 2.显示出来
    [sheet show];
    
}

- (void)SPSelectViewDelegate:(IndustryModel *)model
{
    _industryLabel.text = model.industryName;
    _industryLabel.textColor = [UIColor blackColor];
}

- (void)RSButtonMenuDelegate:(id)model selectMenu:(RSButtonMenu *)menu selectIndex:(NSInteger)index
{
    IndustryModel *new = (IndustryModel *)model;
    _industryLabel.text = new.industryName;
    _industryID = new.industryID;
    _industryLabel.textColor = [UIColor blackColor];
    [self hidden];
}

- (void)sendBackLocationWith:(NSString *)location
{
    _addressLabe.textColor = [UIColor blackColor];
    _addressLabe.text = location;
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
                    UIImage *image = asset.thumbImage;
                    [_iconBtn setImage:image forState:UIControlStateNormal];
                    _upLoadImage = asset.originImage;
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [_iconBtn setImage:image forState:UIControlStateNormal];
    _upLoadImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    //    if (textView.text.length > BOOKMARK_WORD_LIMIT)
    //    {
    //        [MBProgressHUD createHUD:@"评论字数最多不能超过300!" View:[UIApplication sharedApplication].keyWindow];
    //        textView.text = [textView.text substringToIndex:BOOKMARK_WORD_LIMIT];
    //    }
    NSInteger value=textView.text.length;
    //高亮不进入统计 避免未输入的中文在拼音状态被统计入总长度限制
    value -= [textView textInRange:[textView markedTextRange]].length;
    if (value<=300) {
        //        NSLog(@"%@",[NSString stringWithFormat:@"%d/%d",(int)value,BOOKMARK_WORD_LIMIT]);
    } else {
        //        [MBProgressHUD createHUD:@"评论字数最多不能超过300!" View:[UIApplication sharedApplication].keyWindow];
        //截断长度限制以后的字符 避免截断字符
        NSString *tempStr = [textView.text substringWithRange:[textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 300)]];
        textView.text=tempStr;
    }
    
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    //    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    //    [textView scrollRangeToVisible:NSMakeRange(0, colomNumber)];
    [textView scrollRangeToVisible:NSMakeRange(cursorPosition.y, 0)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text,text];
    if (str.length > 300)
    {
        //        [MBProgressHUD createHUD:@"评论字数最多不能超过300!" View:[UIApplication sharedApplication].keyWindow];
        textView.text = [str substringToIndex:300];
        return NO;
    }
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:_textView]) {
        
        [self.view endEditing:YES];
        
    }
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
