//
//  WPGroupInfoEditingViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupInfoEditingViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import <BlocksKit+UIKit.h>
#import "WPHttpTool.h"
#import "WPActionSheet.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MyScrollView.h"
#import "RSTextView.h"
#import "RSButtonMenu.h"

#import "MLSelectPhotoAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "UIButton+WebCache.h"
#import "SPPhotoAsset.h"
#import "LocationViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "ChattingModule.h"
#import "DDMessageSendManager.h"
#import "GroupInformationModel.h"
#import "HJCActionSheet.h"
#import "SessionModule.h"
#import "DDGroupModule.h"
#import "MTTSessionEntity.h"
#import "MTTDatabaseUtil.h"

#import "WPtextFiled.h"
@interface WPGroupInfoEditingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLPhotoBrowserViewControllerDelegate,MLPhotoBrowserViewControllerDataSource,HJCActionSheetDelegate,RSButtonMenuDelegate,sendBackLocation,UIAlertViewDelegate>

@property (strong, nonatomic) UIButton *addButton;
@property (nonatomic, strong) MyScrollView *mainScroll;
@property (nonatomic, strong) UIView *bottomView; /**< 底部的view */
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *industryLabel;
@property (nonatomic, strong) UILabel *addressLabe;
@property (nonatomic, strong) RSTextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *subView;
@property (nonatomic, strong) NSString *industryID;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, assign) BOOL canClick;


@property (nonatomic, assign) BOOL isImageChanged;

@end

@implementation WPGroupInfoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用滑动手势
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    [self initNav];
    _newPhotolist = [NSMutableArray array];
    self.canClick = NO;
    _mainScroll = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainScroll.backgroundColor = BackGroundColor;
    [self.view addSubview:_mainScroll];

    self.photoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
//    _photoScroll.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:self.photoScroll];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    _titleLabel.text = @"封面";
    _titleLabel.font = kFONT(10);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];

    [_mainScroll addSubview:_titleLabel];

    [self startLoadData];
    [_mainScroll addSubview:self.bottomView];
}

- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"群编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}
-(void)backToFromViewController:(UIButton *)sender
{
    if (_isImageChanged || (![_textField.text isEqualToString:self.model.group_name]) || (![_textView.text isEqualToString:self.model.group_cont]) || (![_industryLabel.text isEqualToString:self.model.group_Industry]) || (![_addressLabe.text isEqualToString:self.model.add_addressDesc])) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否退出编辑?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
    
    }
}
- (void)rightBtnClick
{
    self.editing = NO;

    if (_textField.text.length == 0) {
        [MBProgressHUD createHUD:@"请填写群名称" View:self.view];
        return;
    }
    
    if (_textView.text.length == 0) {
        [MBProgressHUD createHUD:@"请填写群介绍" View:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 进入子线程处理数据 防止出现问题导致 进程假死
        NSMutableArray *photoData = [NSMutableArray array];
        
        for (int i = 0; i < _newPhotolist.count; i++) {
            WPFormData *formDatas = [[WPFormData alloc]init];
            if ([_newPhotolist[i] isKindOfClass:[SPPhotoAsset class]]) {
                formDatas.data = UIImageJPEGRepresentation([_newPhotolist[i] originImage], 0.5);
            }
            if ([_newPhotolist[i] isKindOfClass:[UIImage class]]) {
                formDatas.data = UIImageJPEGRepresentation(_newPhotolist[i], 0.5);
            }
            if ([_newPhotolist[i] isKindOfClass:[iconListModel class]]) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] original_path]]];
                formDatas.data = [NSData dataWithContentsOfURL:url];
            }
            formDatas.name = [NSString stringWithFormat:@"PhotoAddress%d",i];
            formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
            formDatas.mimeType = @"image/png";
            [photoData addObject:formDatas];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"UpdateGroup";
        params[@"id"] = self.model.group_id;
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
        params[@"PhotoNum"] = @(_newPhotolist.count);
        params[@"icon"] = @"1";
        params[@"is_modifypic"] = @"1";
//        NSLog(@"%@",params);
        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
        [WPHttpTool postWithURL:url params:params formDataArray:photoData success:^(id json) {
                NSLog(@"%@---%@",json,json[@"info"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([json[@"status"] integerValue] == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupUpdate" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDataUpdate" object:nil];
                if (self.editingSuccess) {
                    self.editingSuccess();
                }
                [self updataGroup:_textField.text andAvatar:json[@"group_icon"]];
                [MBProgressHUD showSuccess:@"编辑成功" toView:self.view];
                [self performSelector:@selector(delay) afterDelay:0.3];
                
                //修改成功时向群中发条消息
                [self sendMessageChangeSuccess:[NSString stringWithFormat:@"group_%@",self.groupId] andName:_textField.text];
            } else {
                [MBProgressHUD showError:@"编辑失败" toView:self.view];
//                [MBProgressHUD createHUD:@"您的群编辑失败" View:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"编辑失败" toView:self.view];
        }];
//    });

}
-(void)sendMessageChangeSuccess:(NSString*)groupId andName:(NSString*)groupName

{
    MTTSessionEntity * session = [[SessionModule instance] getSessionById:groupId];
    if (!session) {
        session = [[MTTSessionEntity alloc]initWithSessionID:groupId type:SessionTypeSessionTypeGroup];
    }
    
    ChattingModule*mouble = [[ChattingModule alloc] init];
    mouble.MTTSessionEntity = session;
    DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
    
    NSDictionary * dictionary = @{@"display_type":@"12",
                                  @"content":@{@"for_userid":@"",
                                               @"for_username":groupName,
                                               @"create_userid":kShareModel.userId,
                                               @"note_type":@"10",
                                               @"create_username":kShareModel.nick_name,
                                               @"for_user_info_1":@"",
                                               @"for_user_info_0":@""
                                               }
                                  };
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
            if (self.groupSession) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeGroupSuccessMY" object:nil userInfo:@{@"session":self.groupSession,@"message":message}];
            }

    } Error:^(NSError *error) {
    }];
}
-(void)updataGroup:(NSString*)name andAvatar:(NSString*)avatar
{
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",_groupId]  completion:^(MTTGroupEntity *group) {
     MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        group.name = name;
        session.name = name;
        session.avatar = avatar;
        [[DDGroupModule instance] addGroup:group];
        [[SessionModule instance] addToSessionModel:session];
        [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
        }];
        [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
        }];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEGROUPINFOSUCCESS" object:name];
    }];
}
- (void)delay
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 加载数据
- (void)startLoadData
{
    [_newPhotolist addObjectsFromArray:self.arr];
    [self updatephotoScroll];

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        // block会在子线程中执行
        //        NSLog(@"%@", [NSThread currentThread]);
        [_newPhotolist removeAllObjects];
        for (iconListModel *model in self.arr) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:model.original_path]]]];
            [_newPhotolist addObject:image];
        }
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_sync(queue, ^{
            // block一定会在主线程执行
            NSLog(@"%@", [NSThread currentThread]);
            self.canClick = YES;
            [self updatephotoScroll];
        });
    });
    
}

#pragma mark 添加图片、视频按钮
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_addButton setImage:[UIImage imageNamed:@"tianjiazhaop"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScroll addSubview:_addButton];
        
        CGFloat width = (SCREEN_WIDTH - 5*kHEIGHT(10))/4;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        imageV.image = [UIImage imageNamed:@"groupInfo_add"];
        [_addButton addSubview:imageV];
    }
    return _addButton;
}

#pragma mark 更新图片
- (void)updatephotoScroll
{
    
    for (UIView *view in self.photoScroll.subviews) {
        [view removeFromSuperview];
    }
    NSInteger count = _newPhotolist.count;
    CGFloat width = (SCREEN_WIDTH - 5*kHEIGHT(10))/4;
    CGFloat y = 15;
    CGFloat line = kHEIGHT(10);
    CGFloat x;
    if (count == 1) {
        x = width + 2*kHEIGHT(10);
    } else if (count == 2) {
        x = (SCREEN_WIDTH - width)/2 - width - kHEIGHT(10);
    } else {
        x = kHEIGHT(10);
    }

    
    _titleLabel.frame = CGRectMake(x, 64 + 15 + width - kHEIGHT(16), width, kHEIGHT(16));

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_titleLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _titleLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _titleLabel.layer.mask = maskLayer;
    
    for (int i=0; i< _newPhotolist.count; i++)
    {
        
        UIButton *dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dragBtn.frame = CGRectMake(x + (width + line)*(i%4), y + (width + line)*(i/4), width, width);
        dragBtn.userInteractionEnabled = self.canClick;
        dragBtn.clipsToBounds = YES;
        dragBtn.layer.cornerRadius = 5;
        
        if ([_newPhotolist[i] isKindOfClass:[SPPhotoAsset class]])
        {
            [dragBtn setImage:[_newPhotolist[i] thumbImage] forState:UIControlStateNormal];
        } else if ([_newPhotolist[i] isKindOfClass:[iconListModel class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] thumb_path]]];
//            [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            [dragBtn sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        else
        {
//            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] thumb_path]]];
//            [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            [dragBtn setImage:_newPhotolist[i] forState:UIControlStateNormal];
        }
        
        dragBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        dragBtn.tag = 100 + i;
        
        [dragBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScroll addSubview:dragBtn];
        
        // 长按，拖动手势
            UILongPressGestureRecognizer * panTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
            panTap.minimumPressDuration = 0.2;
            [dragBtn addGestureRecognizer:panTap];
            
    }
    
        if (_newPhotolist.count < 8) {
            
            self.addButton.frame = CGRectMake(x + (width + line)*(_newPhotolist.count%4), y + (width + line)*(_newPhotolist.count/4), width, width);

            [self.photoScroll addSubview:self.addButton];
        }
    
        if (_newPhotolist.count >= 4 && _newPhotolist.count <= 8) {
            _photoScroll.height = 2*width + 30 + kHEIGHT(10);
        }else{
            _photoScroll.height = width + 30;
        }
    _bottomView.top = _photoScroll.bottom;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.photoScroll.bottom, SCREEN_WIDTH, kHEIGHT(43)*3 + kHEIGHT(80) + 2)];
        
        CGSize normalSize = [@"群名称 :" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
        
        
        UIView *item1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
        item1.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:item1];
        UILabel *itemLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, normalSize.width, kHEIGHT(43))];
        itemLabel1.font = kFONT(15);
        itemLabel1.text = @"群名称 :";
        [item1 addSubview:itemLabel1];
        
        _textField = [[WPtextFiled alloc] initWithFrame:CGRectMake(itemLabel1.right + 6, 0, SCREEN_WIDTH - normalSize.width - 6 - 2*kHEIGHT(10), kHEIGHT(43))];
        _textField.centerY = kHEIGHT(43)/2;
        _textField.font = kFONT(15);
        UIColor *color = RGB(170, 170, 170);
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入群名称" attributes:@{NSForegroundColorAttributeName: color}];
        _textField.tintColor = color;
        [item1 addSubview:_textField];
        _textField.text = self.model.group_name;
        NSArray * array = [self.model.group_name componentsSeparatedByString:@","];
        if (array.count>3) {
            _textField.text = [NSString stringWithFormat:@"%@,%@,%@等",array[0],array[1],array[2]];
        }
        
        
        UIButton *item2 = [[UIButton alloc] initWithFrame:CGRectMake(0, item1.bottom + 0.5, SCREEN_WIDTH, kHEIGHT(43))];
        item2.tag = 10;
        item2.backgroundColor = [UIColor whiteColor];
        [item2 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [item2 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:item2];
        
        UILabel *itemLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, normalSize.width, kHEIGHT(43))];
        itemLabel2.font = kFONT(15);
        itemLabel2.text = @"群行业 :";
        [item2 addSubview:itemLabel2];
        
        _industryLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemLabel2.right + 6, 0, SCREEN_WIDTH - 100, kHEIGHT(43))];
        _industryLabel.font = kFONT(15);
        _industryLabel.text = self.model.group_Industry;
        [item2 addSubview:_industryLabel];
        
        UIImageView *rightImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        rightImageView1.frame = CGRectMake(SCREEN_WIDTH-10-8, kHEIGHT(43)/2-7, 8,14);
        [item2 addSubview:rightImageView1];
        
        UIButton *item3 = [[UIButton alloc] initWithFrame:CGRectMake(0, item2.bottom + 0.5, SCREEN_WIDTH, kHEIGHT(43))];
        item3.tag = 11;
        [item3 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        item3.backgroundColor = [UIColor whiteColor];
        [item3 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [_bottomView addSubview:item3];
        
        UILabel *itemLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, normalSize.width, kHEIGHT(43))];
        itemLabel3.font = kFONT(15);
        itemLabel3.text = @"群地点 :";
        [item3 addSubview:itemLabel3];
        
        _addressLabe = [[UILabel alloc] initWithFrame:CGRectMake(itemLabel3.right + 6, 0, SCREEN_WIDTH - 100, kHEIGHT(43))];
        _addressLabe.font = kFONT(15);
        _addressLabe.text = self.model.add_addressDesc;
        [item3 addSubview:_addressLabe];
        
        UIImageView *rightImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"near_act_address"]];
        rightImageView2.frame = CGRectMake(SCREEN_WIDTH-10-12, kHEIGHT(43)/2-8, 12,16);
        [item3 addSubview:rightImageView2];
        
        CGFloat y4 = kHEIGHT(43)/2 - normalSize.height/2;
        UIView *item4 = [[UIView alloc] initWithFrame:CGRectMake(0, item3.bottom + 0.5, SCREEN_WIDTH, kHEIGHT(80))];
        item4.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:item4];
        UILabel *itemLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), y4, normalSize.width, normalSize.height)];
        itemLabel4.font = kFONT(15);
        itemLabel4.text = @"群介绍 :";
        [item4 addSubview:itemLabel4];
        
        _textView = [[RSTextView alloc] initWithFrame:CGRectMake(itemLabel4.right + 3, y4 - 7, SCREEN_WIDTH - normalSize.width - 3 - 2*kHEIGHT(10), kHEIGHT(80) - 2*(y4 - 7))];
        _textView.font = kFONT(15);
        _textView.delegate = self;
        _textView.tintColor = color;
        _textView.myPlaceholder = @"请输入群介绍";
        [item4 addSubview:_textView];
        _textView.text = self.model.group_cont;
    }
    return _bottomView;
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

- (void)hidden{
    self.backView1.hidden = YES;
    _subView.hidden = YES;
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


- (void)onTap
{
    [self.view endEditing:YES];
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
    // 2.显示出来
    [sheet show];

}


- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        [self fromCamera];
    }
    if (buttonIndex == 1) {
        [self fromAlbums];
    }
}

- (void)fromCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
//        asset.image = image;
        _isImageChanged = YES;
        [_newPhotolist addObject:image];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        for (UIView *btn in self.photoScroll.subviews) {
            [btn removeFromSuperview];
        }
        [self updatephotoScroll];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 8 - _newPhotolist.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        _isImageChanged = YES;
        [_newPhotolist addObjectsFromArray:photos];
        [self updatephotoScroll];
    };
}

- (void)onBtnClick:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-100 inSection:0];
//    // 图片游览器
//    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//    // 缩放动画
//    photoBrowser.status = UIViewAnimationAnimationStatusFade;
//    // 可以删除
//    photoBrowser.editing = YES;
//    photoBrowser.isGroup = YES;
//    // 数据源/delegate
//    photoBrowser.delegate = self;
//    photoBrowser.dataSource = self;
//    // 当前选中的值
//    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//    // 展示控制器
//    [photoBrowser showPickerVc:self];
    MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
    browserVc.isPreView = YES;
    browserVc.comeType = MLSelectPhotoBroswerComeTypeGroup;
    browserVc.needUpdataAssestBlock = ^(NSMutableArray *photos){
        _newPhotolist = photos;
        [self updatephotoScroll];
    };
    browserVc.currentPage = indexPath.row;
    browserVc.photos = _newPhotolist;
    [self.navigationController pushViewController:browserVc animated:YES];

}

//#pragma <MLPhotoBrowerDelegate>
//#pragma mark - <MLPhotoBrowserViewControllerDataSource>
//- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
//    return _newPhotolist.count;
//}
//
//#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
//- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
//    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
//    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
//    if ([_newPhotolist[indexPath.row] isKindOfClass:[SPPhotoAsset class]]) {
//        photo.photoObj = [[_newPhotolist objectAtIndex:indexPath.row] originImage];
//    }else{
//        photo.photoObj = [IPADDRESS stringByAppendingString:[_newPhotolist[indexPath.row] original_path]];
//    }
//    // 缩略图
//    UIButton *btn = (UIButton *)[self.photoScroll viewWithTag:indexPath.row+100];
//    photo.toView = btn.imageView;
//    //    photo.thumbImage = btn.imageView.image;
//    return photo;
//}
//
//#pragma mark - <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *photo = _newPhotolist[indexPath.row];
//    [_newPhotolist removeObjectAtIndex:indexPath.row];
//    [_newPhotolist insertObject:photo atIndex:0];
//    [self updatephotoScroll];
//}
//
//#pragma mark - <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
//    [_newPhotolist removeObjectAtIndex:indexPath.row];
//    [self updatephotoScroll];
//}

- (void)handlePanGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self dragTileBegan:recognizer];
            [self startShake:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self dragTileMoved:recognizer];
            break;//开始时忘记加break，一直执行结束方法
        }
        case UIGestureRecognizerStateEnded:
        {
            [self dragTileEnded:recognizer];
            [self stopShake:recognizer.view];
            break;
        }
        default:
            break;
    }
}

- (void)dragTileBegan:(UIGestureRecognizer *)recognizer
{
    //把要移动的视图放在顶层
    [self.photoScroll bringSubviewToFront:recognizer.view];
    
    _dragFromPoint = recognizer.view.center;
}

#pragma mark - 拖动晃动
- (void)startShake:(UIView* )imageV
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}

- (void)dragTileMoved:(UIGestureRecognizer *)recognizer
{
    CGPoint locationPoint = [recognizer locationInView:self.photoScroll];
    recognizer.view.center = locationPoint;
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIImageView *)recognizer.view];
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIView *)tileView
{
    for (UIButton *item in self.photoScroll.subviews)
    {
        //移动到另一个按钮的区域，判断需要移动按钮的位置
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView )
        {
            
            //开始的位置
            NSInteger fromIndex = tileView.tag - 100;
            //需要移动到的位置
            NSInteger toIndex = (item.tag - 100)>0?(item.tag - 100):0;
            NSLog(@"从位置%d移动到位置%d",(int)fromIndex, (int)toIndex);
            [self dragMoveFromIndex:fromIndex ToIndex:toIndex withView:tileView];
        }
    }
//    [self.photoScroll bringSubviewToFront:_titleLabel];
}

- (void)dragMoveFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex withView:(UIView *)tileView
{
    //局部变量是不能在闭包中发生改变的，所以需要把_dragFromPoint，_dragToPoint定义成全局变量
    __block NSMutableArray * bnewAlbumlist = _newPhotolist;
    __block UIScrollView * bphotoScrol = self.photoScroll;
    NSDictionary * moveDict = [bnewAlbumlist objectAtIndex:fromIndex];
    [bnewAlbumlist removeObjectAtIndex:fromIndex];
    [bnewAlbumlist insertObject:moveDict atIndex:toIndex];
    //向前移动
    if (fromIndex > toIndex)
    {
        //把移动相册的上一个相册移动到记录的移动相册的位置，并把上一相册的位置记为新的_dragFromPoint，并把view的tag值+1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            
            for (int i = (int)fromIndex - 1; i >= toIndex; i--)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag ++;
            }
            tileView.tag = 100 + toIndex;
        }];
    }
    //向后移动
    else
    {
        //把移动相册的下一个相册移动到记录的移动相册的位置，并把下一相册的位置记为新的_dragFromPoint，并把view的tag值-1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = (int)fromIndex + 1; i <= toIndex; i++)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag --;
            }
            tileView.tag = 100 + toIndex;
        }];
    }
}
- (void)dragTileEnded:(UIGestureRecognizer *)recognizer
{
    //    [UIView animateWithDuration:0.2f animations:^{
    //        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        recognizer.view.alpha = 1.f;
    //    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    _isDragTileContainedInOtherTile = NO;
    //    NSLog(@"*******%@",_newPhotolist);
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
