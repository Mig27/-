//
//  PersonalHomepageController.m
//  WP
//
//  Created by 沈亮亮 on 15/7/30.
//  Copyright (c) 2015年 WP. All rights reserved.
//  工作圈个人主页界面

#import "PersonalHomepageController.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "MJRefresh.h"
#import "WorkTableViewCell.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "WPDetailControllerThree.h"
#import "WFPopView.h"
#import "WPButton.h"
#import "UIImageView+WebCache.h"
#import "WPOtherController.h"
#import "IQKeyboardManager.h"
#import "WPSelectButton.h"
#import "RSButtonMenu.h"
#import "WPDataView.h"

typedef NS_ENUM(NSUInteger, DDBottomShowComponent)
{
    DDInputViewUp                       = 1,
    DDShowKeyboard                      = 1 << 1,
    DDShowEmotion                       = 1 << 2,
    DDShowUtility                       = 1 << 3
};

typedef NS_ENUM(NSUInteger, DDBottomHiddComponent)
{
    DDInputViewDown                     = 14,
    DDHideKeyboard                      = 13,
    DDHideEmotion                       = 11,
    DDHideUtility                       = 7
};
//

typedef NS_ENUM(NSUInteger, DDInputType)
{
    DDVoiceInput,
    DDTextInput
};

typedef NS_ENUM(NSUInteger, PanelStatus)
{
    VoiceStatus,
    TextInputStatus,
    EmotionStatus,
    ImageStatus
};
#define NAVBAR_HEIGHT 64.f
#define DDCOMPONENT_BOTTOM          CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) + NAVBAR_HEIGHT, SCREEN_WIDTH, 216)
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height + NAVBAR_HEIGHT,SCREEN_WIDTH,self.chatInputView.frame.size.height)
#define DDINPUT_HEIGHT              self.chatInputView.frame.size.height
#define DDINPUT_TOP_FRAME           CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height + NAVBAR_HEIGHT - 216, SCREEN_WIDTH, self.chatInputView.frame.size.height)
#define DDUTILITY_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) + NAVBAR_HEIGHT -216, SCREEN_WIDTH, 216)
#define DDEMOTION_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) + NAVBAR_HEIGHT-216, SCREEN_WIDTH, 216)


#define SHAREMAGIN 16
#define SHAREPICWIDTH 44
#define SHARESCROLLHEIGHT 80
#define kWorkCellId  @"WorkTableViewCell"
#define headImageName @"headImage"

@interface PersonalHomepageController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSButtonMenuDelegate>

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *goodData;
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,weak) MJRefreshFooterView *footer;
//@property (nonatomic,weak) MJRefreshHeaderView *header;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath; //头像点击的行数
@property (nonatomic,strong) UIView *slelctPicView;
@property (nonatomic,strong) NSDictionary *backInfo;
@property (nonatomic,assign) BOOL isMore;

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;
@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) RSButtonMenu *buttonMenu2;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;
//@property (nonatomic,strong) NSString *speak_type; //说说类型
@property (nonatomic,strong) NSString *state;      //说说的状态
@property (nonatomic,strong) NSString *time;       //开始时间
@property (nonatomic,strong) NSString *endDate;    //截止时间
@property (nonatomic,strong) WPDataView *dateView1;
@property (nonatomic,strong) WPDataView *dateView2;

@end

@implementation PersonalHomepageController
{
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    DDBottomShowComponent _bottomShowComponent;
    UIButton *_recordButton;
    float _inputViewY;
    NSString* _currentInputContent;
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _buttons = [NSMutableArray array];
    self.headImage = [UIImage imageNamed:@"discover_2.jpg"];
    _page = 1;
    self.speak_type = @"9";
    self.time = @"0";
    self.endDate = @"0";
    self.data = [NSMutableArray array];
    self.goodData = [NSMutableArray array];
//    [self tableView];
    [self initNav];
    [self reloadData];
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//        // 并行执行的线程一
//        [self reloadBackGroundImage];
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//        // 并行执行的线程二
////        [self reloadData];
//    });
    [self notificationCenter];
    [self initialInput];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[PersonalHomepageController class]];
    [self createHeader];
    
}

- (void)initNav
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    if ([usersid isEqualToString:self.sid]) {
        self.title = @"工作日记";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];

    } else {
        self.title = self.str;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    }

}

- (void)onTap
{
    NSLog(@"换头像");
//    self.backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.backView1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(25, (SCREEN_HEIGHT - 43)/2, SCREEN_WIDTH - 50, 43);
//    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:@"更换相册封面" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"click"] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
//    button.layer.cornerRadius = 5;
//    button.clipsToBounds = YES;
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    button.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(14, 10, 14, SCREEN_WIDTH - 150)];
//    [self.backView1 addSubview:button];
//    self.backView1.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
//    [self.backView1 addGestureRecognizer:tap];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.backView1];
    
}

- (void)cancel
{
//    [self.backView1 removeFromSuperview];
}

- (void)cancelView{
//    [self.slelctPicView removeFromSuperview];
//    [self.backView2 removeFromSuperview];
}

- (void)selectPicture{
//    [self cancel];
//    self.slelctPicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 - 44)];
//    self.slelctPicView.backgroundColor = RGBColor(235, 235, 235);
//    NSArray *titles = @[@"从相册选择",@"拍一拍"];
//    for (int i = 0; i<titles.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 44*i, SCREEN_WIDTH, 43);
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        button.backgroundColor = [UIColor whiteColor];
//        [button setTitle:titles[i] forState:UIControlStateNormal];
//        button.tag = i + 1;
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.slelctPicView addSubview:button];
//    }
//    
//    UIButton *buttonSix = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonSix.frame = CGRectMake(0, 44*2 + 6, self.view.bounds.size.width, 43);
//    [buttonSix setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
//    //    [buttonSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [buttonSix setBackgroundColor:[UIColor whiteColor]];
//    buttonSix.tag = 4;
//    [buttonSix setImageEdgeInsets:UIEdgeInsetsMake(5, (SCREEN_WIDTH - 33)/2, 5, (SCREEN_WIDTH - 33)/2)];
//    [buttonSix addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.slelctPicView addSubview:buttonSix];
//    
//    self.backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.backView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.backView2 addSubview:self.slelctPicView];
//    self.backView2.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
//    [self.backView2 addGestureRecognizer:tap];
//    
//    [self.view addSubview:self.backView2];
}

- (void)photoBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        NSLog(@"相册");
       UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.delegate=self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
        [self cancelView];
    } else if (sender.tag == 2) {
        NSLog(@"拍拍");
       UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        picker.delegate=self;
        picker.allowsEditing = YES;
//        picker.allowsImageEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        [self cancelView];
    } else if (sender.tag == 3) {
        NSLog(@"视频");
    } else {
        [self cancelView];
    }
}

- (UIImageView *)headImageView
{
    if (_headImageView ==nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.75*SCREEN_WIDTH-64)];
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:headImageName];
//        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        
//        if (self.is_myself) {     //是自己的个人资料，从本地调背景
//            if (savedImage == NULL) {
//                _headImageView.image = self.headImage;
//            } else {
//                _headImageView.image = savedImage;
//            }
//            _headImageView.contentMode = UIViewContentModeScaleToFill;
//            _headImageView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
//            [_headImageView addGestureRecognizer:tap1];
//        } else {                 //不是的话则从网络接口请求
//            NSString *str = self.backInfo[@"background"];
//            if (str.length == 0) {
//                _headImageView.image = self.headImage;
//            } else {
//                NSString *url = [IPADDRESS stringByAppendingString:str];
//                [_headImageView setImageWithURL:URLWITHSTR(url) placeholderImage:_headImage];
//            }
//        }
        
        if (self.is_myself) {
            _headImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
            [_headImageView addGestureRecognizer:tap1];

        }
        NSString *str = self.backInfo[@"background"];
        if (str.length == 0) {
            _headImageView.image = self.headImage;
        } else {
            NSString *url = [IPADDRESS stringByAppendingString:str];
            [_headImageView sd_setImageWithURL:URLWITHSTR(url) placeholderImage:_headImage];
        }

        
    }
    return _headImageView;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
        UIImage* image2=[info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *newImage = [[self class] scaleImage:image2 toWidth:SCREEN_WIDTH toHeight:0.75*SCREEN_WIDTH - 64];
        NSLog(@"%f----%f",newImage.size.width,newImage.size.height);
        _headImage = newImage;
        [self updateHeadImageWith:newImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)updateHeadImageWith:(UIImage *)headImage{
//    [[self class] saveImage:headImage withName:headImageName];
    //将图片上传到服务器
    NSData *data = UIImageJPEGRepresentation(_headImage, 1.0);
    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"zonebg";
    //    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"background" fileName:@"background.png" mimeType:@"application/octet-stream"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"status"] integerValue] == 1) {
            _headImageView.image = _headImage;
            if (self.is_myself) {
                [self.delegate updateImageWith:_headImage];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error);
    }];
}

+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:YES];
}

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
    int width=0;
    int height=0;
    int x=0;
    int y=0;
    
    if (image.size.width<toWidth)
    {
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }
    else if (image.size.height<toHeight)
    {
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }
    else if (image.size.width>toWidth)
    {
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }
    else if (image.size.height>toHeight)
    {
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }
    else
    {
        height = toHeight;
        width = toWidth;
    }
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return subImage;
}

//保存到系统相册
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
}



//#warning 右按钮点击事件
- (void)rightBtnClick{
    NSLog(@"点击");
}

- (void)createHeader
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(32))];
    [self.view addSubview:headView];
    headView.layer.borderWidth = 0.5;
    headView.layer.borderColor = RGB(178, 178, 178).CGColor;
    
    CGFloat width = SCREEN_WIDTH/2;
    NSArray *titles = @[@"全部分类",@"全部时间"];
    for (int i=0; i<titles.count; i++) {
        WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, 0, width, kHEIGHT(32))];
        //        btn.title.text = titles[i];
        [btn setLabelText:titles[i]];
        btn.image.image = [UIImage imageNamed:@"arrow_down"];
        
        [headView addSubview:btn];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, 0, width, kHEIGHT(32));
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        [headView addSubview:button];
        
        btn.isSelected = button.isSelected;
        if (i != 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, (kHEIGHT(32) - 15)/2, 0.5, 15)];
            line.backgroundColor = RGB(226, 226, 226);
            [headView addSubview:line];
        }
        
        if (i==0) {
            self.button5 = btn;
        } else if (i==1) {
            self.button6 = btn;
        }
    }

}

- (void)selectBtnClick:(UIButton *)sender
{
    [_dateView1 hide];
    [_dateView2 hide];
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    NSArray *type = @[@"全部",@"人气",@"话题",@"职场吐槽",@"职场正能量",@"管理智慧",@"创业心得",@"领导智慧",@"职场心理学",@"求职宝典",@"情感心语",@"心灵鸡汤"];
    NSArray *time = @[@"全部",@"昨天",@"前天",@"选择时间"];
    for (int i = 0; i<type.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = type[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [typeArr addObject:model];
    }
    
    for (int i = 0; i<time.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = time[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [timeArr addObject:model];
    }
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    if (sender.tag == 10) {
        if (!sender.isSelected) {
            [self.buttonMenu1 setLocalData:typeArr];
            self.button5.selected = YES;
            _backView1.hidden = NO;
        } else {
            _backView1.hidden = YES;
            self.button5.selected = NO;
        }
        self.button6.selected = NO;
    } else if(sender.tag == 11){
        self.button5.selected = NO;
        if (!sender.isSelected) {
            NSString *selectTime;
            if (self.time.length <5) {
                selectTime = @"";
            } else {
                selectTime = [NSString stringWithFormat:@"%@ 至 %@",_time,_endDate];
            }
            [self.buttonMenu2 setLocalTime:timeArr andSelectTime:selectTime];
            self.button6.selected = YES;
            _backView2.hidden = NO;
        } else {
            _backView2.hidden = YES;
            self.button6.selected = NO;
        }
    }
    for (int i = 0; i<_buttons.count; i++) {
        UIButton *btn = _buttons[i];
        if (i == sender.tag - 10) {
            btn.selected = !btn.selected;
        } else {
            btn.selected = NO;
        }
    }
    
}

- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
        _buttonMenu1.delegate = self;
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        //        _backView1.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.view addSubview:_backView1];
        [_backView1 addSubview:_buttonMenu1];
        __weak typeof(self) unself = self;
        _buttonMenu1.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu1;
}

- (RSButtonMenu *)buttonMenu2
{
    if (!_buttonMenu2) {
        _buttonMenu2 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
        _buttonMenu2.delegate = self;
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        //        _backView1.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.view addSubview:_backView2];
        [_backView2 addSubview:_buttonMenu2];
        __weak typeof(self) unself = self;
        _buttonMenu2.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu2;
}

- (WPDataView *)dateView1
{
    if (!_dateView1) {
        _dateView1 = [[WPDataView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 30, SCREEN_WIDTH, 216 + 30)];
        [_dateView1 resetTitle:@"开始时间"];
        __weak typeof(self) weakSelf = self;
        _dateView1.getDateBlock = ^(NSString *dateStr){
            NSLog(@"%@",dateStr);
            weakSelf.time = dateStr;
            [weakSelf performSelector:@selector(createDateView2) withObject:nil afterDelay:0.1];
        };
    }
    return _dateView1;
}

- (void)createDateView2
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self dateView2];
    self.dateView2.isNeedSecond = NO;
    [self.dateView2 showInView:window];
}

- (WPDataView *)dateView2
{
    if (!_dateView2) {
        _dateView2 = [[WPDataView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 30, SCREEN_WIDTH, 216 + 30)];
        [_dateView2 resetTitle:@"结束时间"];
        __weak typeof(self) weakSelf = self;
        _dateView2.getDateBlock = ^(NSString *dateStr){
            NSLog(@"%@",dateStr);
            weakSelf.endDate = dateStr;
//            [weakSelf refreshIsNeedEmpty:YES];
        };
    }
    return _dateView2;
}

- (void)RSButtonMenuDelegate:(IndustryModel *)model selectMenu:(RSButtonMenu *)menu
{
    if ([menu isEqual:_buttonMenu1]) {
        if (![model.industryName isEqualToString:@"全部"]) {
            //            self.button5.title.text = model.industryName;
            [self.button5 setLabelText:model.industryName];
        } else {
            //            self.button5.title.text = @"全部分类";
            [self.button5 setLabelText:@"全部分类"];
        }
        
        if ([model.industryName isEqualToString:@"话题"]) {
            self.speak_type = @"1";
        } else if ([model.industryName isEqualToString:@"职场问答"]) {
            self.speak_type = @"2";
        } else if ([model.industryName isEqualToString:@"职场正能量"]) {
            self.speak_type = @"3";
        } else if ([model.industryName isEqualToString:@"职场吐槽"]) {
            self.speak_type = @"4";
        } else if ([model.industryName isEqualToString:@"职场心理学"]) {
            self.speak_type = @"5";
        } else if ([model.industryName isEqualToString:@"管理智慧"]) {
            self.speak_type = @"6";
        } else if ([model.industryName isEqualToString:@"创业心得"]) {
            self.speak_type = @"7";
        } else if ([model.industryName isEqualToString:@"情感心语"]) {
            self.speak_type = @"8";
        } else if ([model.industryName isEqualToString:@"领导智慧"]) {
            self.speak_type = @"11";
        } else if ([model.industryName isEqualToString:@"求职宝典"]) {
            self.speak_type = @"12";
        } else if ([model.industryName isEqualToString:@"心灵鸡汤"]) {
            self.speak_type = @"13";
        } else if ([model.industryName isEqualToString:@"全部"]) {
            self.speak_type = @"9";
        }else if ([model.industryName isEqualToString:@"人气"]) {
            self.speak_type = @"10";
        }
        [self refreshIsNeedEmpty:YES];
        [self hidden];
    } else {
        if (![model.industryName isEqualToString:@"全部"]) {
            if ([model.industryName isEqualToString:@"选择时间"]) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [self dateView1];
                _dateView1.isNeedSecond = NO;
                [_dateView1 showInView:window];
                [self.button6 setLabelText:model.industryName];
            } else {
                //                self.button6.title.text = model.industryName;
                [self.button6 setLabelText:model.industryName];
            }
        } else {
            //            self.button6.title.text = @"全部时间";
            [self.button6 setLabelText:@"全部时间"];
        }
        
        if ([model.industryName isEqualToString:@"全部"]) {
            self.time = @"0";
            self.endDate = @"0";
            [self refreshIsNeedEmpty:YES];
        } else if ([model.industryName isEqualToString:@"昨天"]) {
            self.time = @"1";
            self.endDate = @"0";
            [self refreshIsNeedEmpty:YES];
        } else if ([model.industryName isEqualToString:@"前天"]) {
            self.time = @"2";
            self.endDate = @"0";
            [self refreshIsNeedEmpty:YES];
        } else {
            
        }
        [self hidden];
    }
}

- (void)hidden{
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    self.button5.selected = NO;
    self.button6.selected = NO;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
}

- (void)refreshIsNeedEmpty:(BOOL)isEmpty{
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}

- (void)delay
{
    [_data removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
    
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = RGB(235, 235, 235);
//        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
//        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
        [self headImageView];
//        _tableView.tableHeaderView = _headImageView;
        [self.view addSubview:_tableView];
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.tableView;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.tableView;
//        footer.delegate = self;
//        self.footer = footer;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [weakSelf reloadData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [weakSelf reloadData];
        }];


    }
    
    return _tableView;
}

//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == _header) {
//        _page = 1;
//        [self reloadData];
//    } else {
//        _page ++;
//        [self reloadData];
//    }
//}

- (void)reloadBackGroundImage
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSDictionary *dic = @{@"action" : @"getbg",
                          @"userid" : self.sid};
    NSLog(@"%@----%@",url,dic);
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
        NSLog(@"===json: %@",json);
        self.backInfo = json;
        [self tableView];
        [self reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}

- (void)reloadData
{
    if (_page == 1) {
        [_data removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"user_id"] = self.sid;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
//    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"state"] = @"4";
    params[@"speak_type"] = self.speak_type;
    params[@"time"] = self.time;
    params[@"enddate"] = self.endDate;
    
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//                NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData addObject:is_good];
        }
//        [self tableView];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"暂无最新数据" ifNecessaryForRowCount:self.data.count];
    return _data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = kWorkCellId;
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WorkTableViewCell alloc] init];
        cell.cellType = CellLayoutTypeSpecial;
        //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (_data.count != 0) {
        NSDictionary *dicInfo = _data[indexPath.row];
//        NSLog(@"<<<<>>>>>%@",dicInfo);
        [cell confineCellwithData:dicInfo];
        cell.dustbinBtn.tag = indexPath.row + 1;
        [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.attentionBtn.tag = indexPath.row + 1;
        [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.functionBtn.appendIndexPath = indexPath;
        [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
//        cell.iconControl.appendIndexPath = indexPath;
        [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
}

- (void)checkPersonalHomePage{
    WPOtherController *other = [[WPOtherController alloc] init];
    other.lookUserId = self.sid;
    [self.navigationController pushViewController:other animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *data = _dataSources[self.currentPage];
    NSDictionary *dic;
    if (_data.count>0) {
        dic = _data[indexPath.row];
    }
    NSInteger count = [dic[@"imgCount"] integerValue];
    NSInteger videoCount = [dic[@"videoCount"] integerValue];
    
    NSString *description = dic[@"speak_comment_content"];
    //    NSArray *descrip1 = [description componentsSeparatedByString:@"#"];
    //    NSString *description1 = [descrip1 componentsJoinedByString:@"\""];
    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    
    NSString *speak_comment_state = dic[@"speak_comment_state"];
    NSString *lastDestription = [NSString stringWithFormat:@"#%@ %@",speak_comment_state,description3];
    CGSize normalSize = [@"我草泥马" sizeWithFont:kFONT(14)];
    CGFloat descriptionLabelHeight;//内容的显示高度
    if ([dic[@"speak_comment_content"] length] == 0) {
        descriptionLabelHeight = normalSize.height;
    } else {
        descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
        if (descriptionLabelHeight > normalSize.height *6) {
            descriptionLabelHeight = normalSize.height *6;
            self.isMore = YES;
        } else {
            self.isMore = NO;
            descriptionLabelHeight = descriptionLabelHeight;
        }
    }
    CGFloat photosHeight;//定义照片的高度
    CGFloat photoWidth;
    CGFloat videoWidth;
    if (SCREEN_WIDTH == 320) {
        photoWidth = 74;
        videoWidth = 140;
    } else if (SCREEN_WIDTH == 375) {
        photoWidth = 79;
        videoWidth = 164;
    } else {
        photoWidth = 86;
        videoWidth = 172;
    }
    if (videoCount == 1) {
        NSLog(@"controller 有视频");
        photosHeight = videoWidth;
    } else {
        if (count == 0) {
            photosHeight = 0;
        } else if (count >= 1 && count <= 3) {
            photosHeight = photoWidth;
        } else if (count >= 4 && count <= 6) {
            photosHeight = photoWidth*2 + 3;
        } else {
            photosHeight = photoWidth*3 + 6;
        }
    }
    
    CGFloat cellHeight;
    if ([dic[@"address"] length] == 0) {
        if ([dic[@"original_photos"] count] == 0) {
            if (self.isMore) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
            } else {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + kHEIGHT(25) + 6;
            }
        } else {
            if ([dic[@"speak_comment_content"] length] == 0) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + kHEIGHT(25) + 6;
            } else {
                if (self.isMore) {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
                } else {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + kHEIGHT(25) + 6;
                }
            }
        }
    } else {
        if ([dic[@"original_photos"] count] == 0) {
            if (self.isMore) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + 15 + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
            } else {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + 15 + 10 + kHEIGHT(25) + 6;
            }
        } else {
            if ([dic[@"speak_comment_content"] length] == 0) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + 15 + 10 + kHEIGHT(25) + 6;
            } else {
                if (self.isMore) {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
                } else {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + kHEIGHT(25) + 6;
                }
            }
        }
    }
    
    return cellHeight;
    
}


//点击cell跳转到详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_operationView dismiss];
    WorkTableViewCell *cell = (WorkTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc >0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
    WPDetailControllerThree *detail = [[WPDetailControllerThree alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_data[indexPath.row]];
    detail.userInfo = dic;
    detail.is_good = [_goodData[indexPath.row] boolValue];
    [self.navigationController pushViewController:detail animated:YES];
    
}



#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-68, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

//垃圾桶点击事件
- (void)dustbinClick:(UIButton *)btn{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[btn superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[btn superview] superview] superview];
    }
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    NSDictionary *dic = _data[path.row];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteDynamic";
    params[@"speakid"] = [NSString stringWithFormat:@"%@",dic[@"sid"]];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
//    params[@"nick_name"] = userInfo[@"nick_name"];
    
    NSInteger count = [dic[@"original_photos"] count];
    if (count > 0) {
        NSArray *arr = dic[@"original_photos"];
        NSMutableArray *adress = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *str = dic[@"media_address"];
            [adress addObject:str];
        }
        NSString *img_address = [adress componentsJoinedByString:@"|"];
        params[@"img_address"] = img_address;
        
    }
    
    NSLog(@"****%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json[@"info"]);
        [MBProgressHUD showSuccess:@"删除成功"];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"删除失败"];
    }];
    
    [self.data removeObjectAtIndex:btn.tag - 1];
    [self.tableView reloadData];
}


- (void)attentionClick:(UIButton *)sender
{
    NSLog(@"关注");
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[sender superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[sender superview] superview] superview];
    }
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    NSDictionary *dic = _data[path.row];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
//    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = dic[@"user_id"];
    params[@"by_nick_name"] = dic[@"nick_name"];
//    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
//    if ([attention_state isEqualToString:@"2"]) {
//        params[@"attention_state"] = @"2";
//    } else {
//        params[@"attention_state"] = @"3";
//    }
    
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    
    NSString *nick_name = dic[@"nick_name"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json[@"info"]);
        if ([json[@"status"] integerValue] == 1) {
            for (int i=0; i<_data.count; i++) {
                NSDictionary *dict = _data[i];
                NSString *nick = dict[@"nick_name"];
                NSString *attention = [NSString stringWithFormat:@"%@",dict[@"attention_state"]];
                if ([nick isEqualToString:nick_name]) {
                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    if ([attention isEqualToString:@"0"]) {
                        [newDic setObject:@"1" forKey:@"attention_state"];
                    } else if([attention isEqualToString:@"1"]){
                        [newDic setObject:@"0" forKey:@"attention_state"];
                    } else if ([attention isEqualToString:@"2"]) {
                        [newDic setObject:@"3" forKey:@"attention_state"];
                    } else if ([attention isEqualToString:@"3"]) {
                        [newDic setObject:@"2" forKey:@"attention_state"];
                    }
                    [_data replaceObjectAtIndex:i withObject:newDic];
                }
            }
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}


- (void)replyAction:(WPButton *)sender
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
    }
    
    CGRect rectInTableView = [_tableView rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    //    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    BOOL isFavour;
    NSString *is_good = _goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
    if ([is_good isEqualToString:@"0"]) {
        isFavour = NO;
    } else {
        isFavour = YES;
    }
    [self.operationView showAtView:_tableView rect:targetRect isFavour:isFavour];
    
}

- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        _operationView.rightType = WFRightButtonTypePraise;
        __weak __typeof(self)weakSelf = self;
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    [weakSelf addLike];
                    break;
                case WFOperationTypeReply:
                    [weakSelf replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

//点赞
- (void)addLike{
    WorkTableViewCell *cell = (WorkTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    NSString *is_good = _goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_data[_selectedIndexPath.row]];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = dic[@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
//    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
    params[@"is_type"] = @"1";
    params[@"wp_speak_click_type"] = @"1";
    params[@"odd_domand_id"] = @"0";
    if ([is_good isEqualToString:@"0"]) {
        params[@"wp_speak_click_state"] = @"0";
    } else {
        params[@"wp_speak_click_state"] = @"1";
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        if ([is_good isEqualToString:@"0"]) {
            count ++;
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [_goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
            [_data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
            
        } else {
            count --;
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [_goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
            [_data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
        }
        cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    
    NSLog(@"点赞");
}

- (void)updateCommentCount{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_data[_selectedIndexPath.row]];
    NSInteger count = [dic[@"speak_trends_person"] integerValue];
    count++;
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_trends_person"];
    [_data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
    [_tableView reloadData];
}

//评论
- (void)replyMessage:(WPButton *)sender{
    WorkTableViewCell *cell = (WorkTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    self.chatInputView.hidden = NO;
    [self.chatInputView.textView becomeFirstResponder];
    NSLog(@"评论");
}

#pragma  mark - PrivateAPI
- (void)p_hideBottomComponent
{
    _bottomShowComponent = _bottomShowComponent * 0;
    [self.chatInputView.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.ddUtility.view.frame = DDCOMPONENT_BOTTOM;
        self.emotions.view.frame = DDCOMPONENT_BOTTOM;
        self.chatInputView.frame = DDINPUT_BOTTOM_FRAME;
    }];
    NSLog(@"%f",self.chatInputView.frame.origin.y);
    [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}

//注册观察中心
-(void)notificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)initialInput
{
    CGRect inputFrame = CGRectMake(0, SCREEN_HEIGHT - 108,SCREEN_WIDTH,44.0f);
    self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
    [self.view addSubview:self.chatInputView];
    [self.view bringSubviewToFront:self.chatInputView];
    [self.chatInputView.emotionbutton addTarget:self
                                         action:@selector(showEmotions:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatInputView.showUtilitysbutton addTarget:self
                                              action:@selector(showUtilitys:)
                                    forControlEvents:UIControlEventTouchDown];
    
    [self.chatInputView.voiceButton addTarget:self
                                       action:@selector(p_clickThRecordButton:)
                             forControlEvents:UIControlEventTouchUpInside];
//    [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak PersonalHomepageController* weakSelf = self;
    _touchDownGestureRecognizer.touchDown = ^{
        [weakSelf p_record:nil];
    };
    
    _touchDownGestureRecognizer.moveInside = ^{
        [weakSelf p_endCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.moveOutside = ^{
        [weakSelf p_willCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
        if (inside)
        {
            [weakSelf p_sendRecord:nil];
        }
        else
        {
            [weakSelf p_cancelRecord:nil];
        }
    };
    [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
    _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
    [_recordingView setHidden:YES];
    [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.chatInputView.hidden = YES;
}

//评论
- (void)commentClick:(UIButton *)sender
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"*****%@",self.chatInputView.textView.text);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = _data[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = dic[@"sid"];
    params[@"user_id"] = myDic[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
//    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = dic[@"nick_name"];
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    params[@"speak_reply"] = @"0";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self updateCommentCount];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
}

- (void)showEmotions:(UIButton *)sender
{
    NSLog(@"表情");
    if (self.chatInputView.emotionbutton.isSelected == NO) {
        self.chatInputView.emotionbutton.selected = YES;
        [_recordButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
        _recordButton.tag = DDVoiceInput;
        [self.chatInputView willBeginInput];
        if ([_currentInputContent length] > 0)
        {
            [self.chatInputView.textView setText:_currentInputContent];
        }
        
        if (self.emotions == nil) {
            self.emotions = [EmotionsViewController new];
            [self.emotions.view setBackgroundColor:[UIColor darkGrayColor]];
            self.emotions.view.frame=DDCOMPONENT_BOTTOM;
            self.emotions.delegate = self;
            [self.view addSubview:self.emotions.view];
        }
        if (_bottomShowComponent & DDShowKeyboard)
        {
            //显示的是键盘,这是需要隐藏键盘，显示表情，不需要动画
            _bottomShowComponent = (_bottomShowComponent & 0) | DDShowEmotion;
            [self.chatInputView.textView resignFirstResponder];
            [self.emotions.view setFrame:DDEMOTION_FRAME];
            [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        }
        else if (_bottomShowComponent & DDShowEmotion)
        {
            //表情面板本来就是显示的,这时需要隐藏所有底部界面
            [self.chatInputView.textView resignFirstResponder];
            _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
        }
        //    else if (_bottomShowComponent & DDShowUtility)
        //    {
        //        //显示的是插件，这时需要隐藏插件，显示表情
        //        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        //        [self.emotions.view setFrame:DDEMOTION_FRAME];
        //        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
        //    }
        else
        {
            //这是什么都没有显示，需用动画显示表情
            _bottomShowComponent = _bottomShowComponent | DDShowEmotion;
            [UIView animateWithDuration:0.25 animations:^{
                [self.emotions.view setFrame:DDEMOTION_FRAME];
                [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
            }];
            [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
        }
        [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
        self.chatInputView.voiceButton.tag = DDVoiceInput;
    } else {
        self.chatInputView.emotionbutton.selected = NO;
        [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
        self.chatInputView.voiceButton.tag = DDVoiceInput;
        //        [self.chatInputView willBeginInput];
        [self.chatInputView.textView becomeFirstResponder];
    }
    
}

- (void)showUtilitys:(UIButton *)sender
{
    [_recordButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
    _recordButton.tag = DDVoiceInput;
    [self.chatInputView willBeginInput];
    if ([_currentInputContent length] > 0)
    {
        [self.chatInputView.textView setText:_currentInputContent];
    }
    
    if (self.ddUtility == nil)
    {
        self.ddUtility = [ChatUtilityViewController new];
        self.ddUtility.delegate = self;
        [self addChildViewController:self.ddUtility];
        self.ddUtility.view.frame=CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width , 280);
        [self.view addSubview:self.ddUtility.view];
    }
    
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示插件，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowUtility;
        [self.chatInputView.textView resignFirstResponder];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //插件面板本来就是显示的,这时需要隐藏所有底部界面
        //        [self p_hideBottomComponent];
        [self.chatInputView.textView becomeFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideUtility;
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情，这时需要隐藏表情，显示插件
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideEmotion) | DDShowUtility;
    }
    else
    {
        //这是什么都没有显示，需用动画显示插件
        _bottomShowComponent = _bottomShowComponent | DDShowUtility;
        [UIView animateWithDuration:0.25 animations:^{
            [self.ddUtility.view setFrame:DDUTILITY_FRAME];
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    
}

- (void)p_clickThRecordButton:(UIButton *)button
{
    switch (button.tag) {
        case DDVoiceInput:
            //开始录音
            [self p_hideBottomComponent];
            [button setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
            button.tag = DDTextInput;
            [self.chatInputView willBeginRecord];
            [self.chatInputView.textView resignFirstResponder];
            _currentInputContent = self.chatInputView.textView.text;
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:nil];
            }
            break;
        case DDTextInput:
            //开始输入文字
            [button setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
            button.tag = DDVoiceInput;
            [self.chatInputView willBeginInput];
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:_currentInputContent];
            }
            [self.chatInputView.textView becomeFirstResponder];
            break;
    }
    
}

- (void)p_record:(UIButton*)button
{
    [self.chatInputView.recordButton setHighlighted:YES];
    if (![[self.view subviews] containsObject:_recordingView])
    {
        [self.view addSubview:_recordingView];
    }
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
    [[RecorderManager sharedManager] setDelegate:self];
    [[RecorderManager sharedManager] startRecording];
    NSLog(@"record");
}
- (void)p_endCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
}
- (void)p_willCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowCancelSendState];
    NSLog(@"will cancel record");
}
//发送语音
- (void)p_sendRecord:(UIButton*)button
{
//    [self.chatInputView.recordButton setHighlighted:NO];
//    [[RecorderManager sharedManager] stopRecording];
//    NSLog(@"send record");
//    NSString *file = [RecorderManager sharedManager].fileAdress;
//    NSLog(@"#####%@",file);
//    [_chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//    _chatInputView.voiceButton.tag = DDVoiceInput;
//    
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *dic = _data[_selectedIndexPath.row];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = dic[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
////    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"by_nick_name"] = dic[@"nick_name"];
//    //    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    params[@"speak_reply"] = @"0";
//    NSData *audioData = [NSData dataWithContentsOfFile:file];
//    //    NSLog(@"****%@",params);
//    //    NSLog(@"===%@",audioData);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    //    NSLog(@"####%@",url);
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:audioData name:@"speak_comment_content" fileName:@"speak_comment_content.mp3" mimeType:@"audio/mpeg3"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*****%@",dict[@"info"]);
//        if ([dict[@"status"] integerValue] == 1) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            [self updateCommentCount];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    [self.chatInputView willBeginInput];
//    _chatInputView.hidden = YES;
    //    _chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
}
- (void)p_cancelRecord:(UIButton*)button
{
    [self.chatInputView.recordButton setHighlighted:NO];
    [_recordingView setHidden:YES];
    [[RecorderManager sharedManager] cancelRecording];
    NSLog(@"cancel record");
}
#pragma mark - KeyBoardNotification
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    _bottomShowComponent = _bottomShowComponent | DDShowKeyboard;
    //什么都没有显示
    [UIView animateWithDuration:0.25 animations:^{
        [self.chatInputView setFrame:CGRectMake(0, keyboardRect.origin.y - DDINPUT_HEIGHT, self.view.frame.size.width, DDINPUT_HEIGHT)];
    }];
    [self setValue:@(keyboardRect.origin.y - DDINPUT_HEIGHT) forKeyPath:@"_inputViewY"];
    
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    _bottomShowComponent = _bottomShowComponent & DDHideKeyboard;
    if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    else
    {
        [self p_hideBottomComponent];
    }
}
#pragma mark - Text view delegatef

- (void)viewheightChanged:(float)height
{
    [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}
- (void)textViewEnterSend
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //发送消息
    NSString* text = [self.chatInputView.textView text];
    
    NSString* parten = @"\\s";
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* checkoutText = [reg stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
    if ([checkoutText length] == 0)
    {
        return;
    }
    NSLog(@"发送消息：%@",self.chatInputView.textView.text);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = _data[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = dic[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
//    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = dic[@"nick_name"];
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    params[@"speak_reply"] = @"0";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self updateCommentCount];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_inputViewY"])
    {
        //            [self p_unableLoadFunction];
        [UIView animateWithDuration:0.25 animations:^{
            if (_bottomShowComponent & DDShowEmotion)
            {
                CGRect frame = self.emotions.view.frame;
                frame.origin.y = self.chatInputView.bottom;
                self.emotions.view.frame = frame;
            }
            if (_bottomShowComponent & DDShowUtility)
            {
                CGRect frame = self.ddUtility.view.frame;
                frame.origin.y = self.chatInputView.bottom;
                self.ddUtility.view.frame = frame;
            }
            
        } completion:^(BOOL finished) {
            //                [self p_enableLoadFunction];
        }];
    }
    
}
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender
{
    if (_bottomShowComponent)
    {
        [self p_hideBottomComponent];
    }
}

#pragma mark - EmotionsViewController Delegate
- (void)emotionViewClickSendButton
{
    [self textViewEnterSend];
}
-(void)insertEmojiFace:(NSString *)string
{
    NSMutableString* content = [NSMutableString stringWithString:self.chatInputView.textView.text];
    [content appendString:string];
    [self.chatInputView.textView setText:content];
}
-(void)deleteEmojiFace
{
    EmotionsModule* emotionModule = [EmotionsModule shareInstance];
    NSString* toDeleteString = nil;
    if (self.chatInputView.textView.text.length == 0)
    {
        return;
    }
    if (self.chatInputView.textView.text.length == 1)
    {
        self.chatInputView.textView.text = @"";
    }
    else
    {
        toDeleteString = [self.chatInputView.textView.text substringFromIndex:self.chatInputView.textView.text.length - 1];
        int length = [emotionModule.emotionLength[toDeleteString] intValue];
        if (length == 0)
        {
            toDeleteString = [self.chatInputView.textView.text substringFromIndex:self.chatInputView.textView.text.length - 2];
            length = [emotionModule.emotionLength[toDeleteString] intValue];
        }
        length = length == 0 ? 1 : length;
        self.chatInputView.textView.text = [self.chatInputView.textView.text substringToIndex:self.chatInputView.textView.text.length - length];
    }
    
}
#pragma Recording Delegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    NSMutableData* muData = [[NSMutableData alloc] init];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    int length = [RecorderManager sharedManager].recordedTimeInterval;
    if (length < 1 )
    {
        NSLog(@"录音时间太短");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recordingView setHidden:NO];
            [_recordingView setRecordingState:DDShowRecordTimeTooShort];
        });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recordingView setHidden:YES];
        });
    }
    int8_t ch[4];
    for(int32_t i = 0;i<4;i++){
        ch[i] = ((length >> ((3 - i)*8)) & 0x0ff);
    }
    [muData appendBytes:ch length:4];
    [muData appendData:data];
    /**
     *  muData ->  voice data
     *
     *  length  ->  voice Length
     */
    
}
- (void)recordingTimeout
{
    
}
/**
 *  录音机停止采集声音
 */
- (void)recordingStopped
{
    
}
- (void)recordingFailed:(NSString *)failureInfoString
{
    
}
- (void)levelMeterChanged:(float)levelMeter
{
    [_recordingView setVolume:levelMeter];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(DDINPUT_BOTTOM_FRAME, location))
    {
        return NO;
    }
    return YES;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([gestureRecognizer.view isEqual:_tableView])
//    {
//        return YES;
//    }
//    return NO;
//}
#pragma mark -
- (void)playingStoped
{
    
}

- (void)dealloc
{
//    [self.header free];
//    [self.footer free];
    
    //注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_operationView dismiss];
    WorkTableViewCell *cell = (WorkTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
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
