//
//  WriteViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/7/10.
//  Copyright (c) 2015年 WP. All rights reserved.
//  写写、晒晒、以及提问界面

#import "WriteViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LocationViewController.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "WriteCollectionViewCell.h"
#import "MyScrollView.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "NSDate+TimeInterval.h"
#import "WPActionSheet.h"
#import "DBTakeVideoVC.h"
#import "ShareEditeCell.h"
#import "OpenViewController.h"
#import "TopicViewController.h"
#import "FDActionSheet.h"
#import "HJCActionSheet.h"
#import "IQKeyboardManager.h"
#import "HCEmojiKeyboard.h"
#import "MTTMessageEntity.h"
#import "DDGroupModule.h"
#import "MTTSessionEntity.h"
#import "SessionModule.h"
#import "ChattingModule.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "WPDDChatVideo.h"
#import "VideoBrowser.h"
#import "WPUploadShuoShuo.h"
#import "WPOpitionTableViewCell.h"
#define shuoShuoVideo @"/shuoShuoVideo"
static NSString *emoji = @"common_biaoqing";
static NSString *keyboard = @"common_jianpan";


#define WIDTH  (SCREEN_WIDTH - 50)/4


@interface WriteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,sendBackLocation,UIScrollViewDelegate,WPActionSheet,callBackVideo,takeVideoBack,UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate,HJCActionSheetDelegate,UITextViewDelegate>

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UIView *viewOne;

@property (nonatomic,weak) UIButton* buttonOne;
@property (nonatomic,weak) UIButton* buttonTwo;
@property (nonatomic,weak) UIButton* buttonThree;
@property (nonatomic,weak) UIButton* buttonFour;
@property (nonatomic,weak) UIButton* buttonFive;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,assign) BOOL isCreate;
@property (nonatomic,assign) BOOL isPublish;

@property (nonatomic,strong) UIView *viewTwo;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,strong) UIView *topicView1;   //选择话题时第一页View
@property (nonatomic,strong) UIView *topicView2;   //选择话题时第二页View

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *photoData;//照片的二进制数据
@property (nonatomic,strong) NSMutableArray *img_address;//小图片的地址
@property (nonatomic,strong) NSMutableArray *img_big;//大图片的地址

@property (nonatomic,strong) UILabel *adress;
@property (nonatomic,strong) MyScrollView *scroll;
@property (nonatomic,assign) NSInteger delectPage;

@property (nonatomic,strong) UIView *videoView;        //显示视频的view
@property (nonatomic,strong) UIImageView *videoIcon;   //视频的缩略图
@property (nonatomic,strong) UILabel *videolength;     //视频的时长
@property (nonatomic, strong) UITableView *tableView;  //列表
@property (nonatomic, strong) NSMutableArray *dataSource; //数据源
@property (nonatomic, strong) UIView *bgView;        //白色背景

@property (nonatomic,strong) NSString *is_nearby;
@property (nonatomic,strong) NSString *is_anoymous;
@property (nonatomic,strong) NSString *is_friends;
@property (nonatomic,strong) NSString *is_fans;
@property (nonatomic,strong) NSString *comment_type;
@property (nonatomic,strong) NSString *is_Look;//谁看
@property (nonatomic,strong) NSString *not_look;//不让谁看

@property (nonatomic,assign) int MAXCOUNT;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;//视频播放器
@property (nonatomic,strong) NSMutableArray *assets;    //选择本地视频的数组
@property (nonatomic,strong) NSString *videofilePath;   //录制视频的路径
@property (nonatomic,assign) BOOL isVideo_now;          // 当前是否为视频
@property (nonatomic,strong) NSString *selectTopic;     //选中的话题类型
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSIndexPath* openIndex;


@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSString *speak_adress;   //发布说说的地址

@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UIButton *faceBtn;

@property (nonatomic, strong) WPDDChatVideo* video;

@property (nonatomic, copy) NSString*categoryShuo;

@end

@implementation WriteViewController
{
    MPMoviePlayerViewController *_moviePlayerVC;//视频播放器
    BOOL _wasKeyboardManagerEnabled;
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}


- (NSString *)is_anoymous{
    if (!_is_anoymous) {
        _is_anoymous = [[NSString alloc] init];
    }
    return _is_anoymous;
}

- (NSString *)is_nearby{
    if (!_is_nearby) {
        _is_nearby = [[NSString alloc] init];
    }
    return _is_nearby;
}
- (NSString *)is_fans{
    if (!_is_fans) {
        _is_fans = [[NSString alloc] init];
    }
    return _is_fans;
}
- (NSString *)is_friends{
    if (!_is_friends) {
        _is_friends = [[NSString alloc] init];
    }
    return _is_friends;
}


#pragma mark - view life
- (void)viewDidLoad {
    [super viewDidLoad];
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.selectTopic = @"话题";
    if (self.is_dynamic) {
        self.title = @"";//职场说说
    } else {
        if (!self.title.length) {
            if (self.isOpinition) {
             self.title = @"意见与反馈";
            }
            else
            {
                self.title = @"群说说";
            }
        }
        
    }
    _titles = @[@"话题",@"职场吐槽",@"职场正能量",@"管理智慧",@"创业心得",@"领导智慧",@"职场心理学",@"求职宝典",@"情感心语",@"心灵鸡汤"];
    if (self.type == WriteTypeQuestion || self.type == WriteTypeAnswer) {
        self.MAXCOUNT = 3;
    } else {
        self.MAXCOUNT = 9;
    }
//    self.comment_type = @"1";
    self.delectPage = -1;
    self.videoType = -1;
    self.selectPicType = 1;
    self.isVideo_now = NO;
    self.view.backgroundColor = RGBColor(235, 235, 235);
    self.photos = [NSMutableArray array];
    self.photoData = [NSMutableArray array];
    self.img_address = [NSMutableArray array];
    self.img_big = [NSMutableArray array];
    
    NSString * rightStr = self.isOpinition?@"提交":@"发布";
    UIBarButtonItem * item  =    [[UIBarButtonItem alloc]initWithTitle:rightStr style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    item.tag = 0;
    self.navigationItem.rightBarButtonItem = item;
    self.buttons = [NSMutableArray array];
    self.isCreate = NO;
    self.isPublish = NO;
    
    //不是意见反馈
    if (!self.isOpinition) {
       [self initDatasource];
    }
    
   // [self initDatasource];
    [self createUI];
    
   // self.isOpinition?():[self tableView];
    [self tableView];
    
    UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    faceBtn.tag = 0;
//    faceBtn.backgroundColor = [UIColor redColor];
    [faceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    [faceBtn setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.faceBtn = faceBtn;
    
    UIButton *completBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
    completBtn.titleLabel.font = FONT(15);
    [completBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [completBtn addTarget:self action:@selector(resignKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.layer.borderColor = RGB(177, 177, 177).CGColor;
    toolView.layer.borderWidth = 0.5;
    [toolView addSubview:faceBtn];
    [toolView addSubview:completBtn];
    self.toolView = toolView;
    [self.view addSubview:self.toolView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WriteViewController class]];
    [self createEmojiView];
}


- (void)createEmojiView {
    
    _emojiKeyboard = [HCEmojiKeyboard sharedKeyboard];
    _emojiKeyboard.showAddBtn = NO;
    _emojiKeyboard.hiddenSend = YES;
    [_emojiKeyboard addBtnClicked:^{
        NSLog(@"clicked add btn");
    }];
    [_emojiKeyboard sendEmojis:^{
        //赋值
        _text.text = _text.text;
    }];
}

#pragma mark - 键盘还原
- (void)reductionKeyboard
{
    self.text.inputView = nil;
    _faceBtn.tag = 0;
    [_faceBtn setImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    [self.text reloadInputViews];

}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         CGRect newInputViewFrame = self.toolView.frame;
                         newInputViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.toolView.frame)-kbSize.height;
                         self.toolView.frame = newInputViewFrame;
                     }
                     completion:nil];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //do something
    self.toolView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 50);
}




//改变键盘状态
- (void)clickedFaceBtn:(UIButton *)button{
    if (button.tag == 1){
        self.text.inputView = nil;
        [button setImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:keyboard] forState:UIControlStateNormal];
        [_emojiKeyboard setTextInput:self.text];
    }
    [self.text reloadInputViews];
    button.tag = (button.tag+1)%2;
    [_text becomeFirstResponder];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    // 键盘 即将显示
//    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    
//    // 键盘 隐藏
//    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
//    
//}


#pragma mark - 初始化数据源
- (void)initDatasource
{
    NSArray *arr;
    if (self.is_dynamic) {
        arr = @[@{@"title" : @"所在位置",
                  @"subtitle" : @"",
                  @"image" : @"share_address"},
                @{@"title" : @"公开",
                  @"subtitle" : @"所有人可见",
                  @"image" : @"share_open"},
                @{@"title" : @"话题",
                  @"subtitle" : @"默认·职场说说",
                  @"image" : @"share_topic"}];
    } else {
        arr = @[@{@"title" : @"所在位置",
                  @"subtitle" : @"",
                  @"image" : @"share_address"}];

    }
    self.dataSource = [[NSMutableArray alloc] initWithArray:arr];
    self.photoData = [NSMutableArray array];
    self.comment_type = @"2";
    self.is_anoymous = @"0";
    self.index = 0;
}

-(void)backToFromViewController:(UIButton *)sender
{
//    [self.text resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否退出本次编辑？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alert.tag = 10;
    if (self.type == WriteTypeNormal) {
        if (self.text.text.length == 0 && self.photos.count==0 && !self.videofilePath.length) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [alert show];
        }
    } else if (self.type == WriteTypeQuestion || self.type == WriteTypeAnswer){
        if (self.text.text.length == 0 && self.assets.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [alert show];
        }
    } else {
        [alert show];
    }

}

- (void)leftBtnClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否退出本次编辑？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alert.tag = 10;
    if (self.type == WriteTypeNormal) {
        if (self.text.text.length == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [alert show];
        }
    } else if (self.type == WriteTypeQuestion || self.type == WriteTypeAnswer){
        if (self.text.text.length == 0 && self.assets.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [alert show];
        }
    } else {
        [alert show];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
//        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = [ShareEditeCell cellHeight];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpinition) {
        return 1;
    }
    else
    {
      return  self.dataSource.count;
    }
    //return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isOpinition) {
        static NSString * identifier = @"WPOpitionTableViewCell";
        WPOpitionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WPOpitionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = NO;
        return cell;
    }
    else
    {
        ShareEditeCell *cell = [ShareEditeCell cellWithTableView:tableView];
        cell.dic = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LocationViewController *location = [[LocationViewController alloc] init];
        location.delegate = self;
        location.isFromShuoShuo = YES;
        location.choiseStr = self.speak_adress;
        [self.navigationController pushViewController:location animated:YES];
    } else if (indexPath.row == 1) {
        OpenViewController *open = [[OpenViewController alloc] init];
        open.clickComplete = ^(NSDictionary*dic,NSIndexPath*index){
            NSDictionary *replacrDic =                       @{@"title" : @"公开",
                                                               @"subtitle" : dic[@"title"],
                                                               @"image" : @"share_open"};
            [self.dataSource replaceObjectAtIndex:1 withObject:replacrDic];
            if (index.section <= 3) {
              self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index.section];
            }
            else
            {
               self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index.section-1];
                if (index.section == 5) {
                    self.is_Look = dic[@"userID"];
                }
                else
                {
                 self.not_look = dic[@"userID"];
                }
            }
            self.openIndex = index;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:open animated:YES];
    } else if (indexPath.row == 2) {
        TopicViewController *topic = [[TopicViewController alloc] init];
        topic.selectIndex = self.index;
        NSDictionary * dic = self.dataSource[2];
        topic.typeName = dic[@"subtitle"];
        if ([dic[@"subtitle"] isEqualToString:@"默认·职场说说"]) {
            topic.typeName = @"职场说说";
        }
        topic.topicDidselectBlock = ^(DynamicTopicTypeModel *model, NSIndexPath *clickIndex) {
            NSDictionary *replaceDic = @{@"title" : @"话题",
                                         @"subtitle" : model.type_name,
                                         @"image" : @"share_topic"};
            [self.dataSource replaceObjectAtIndex:2 withObject:replaceDic];
            self.comment_type = model.sid;
            self.index = clickIndex.row;
            [_tableView reloadData];
            self.categoryShuo = model.type_name;
        };
        [self.navigationController pushViewController:topic animated:YES];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([[scrollView class] isEqual:[UITableView class]]) {
        [self resignKeyboard];
    }
}

- (void)createUI
{
    _scroll = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scroll.delegate = self;
//    _scroll.backgroundColor = [UIColor redColor];
    _scroll.backgroundColor = RGBColor(235, 235, 235);
    _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + WIDTH);
//  [self.view addSubview:_scroll];
    
    
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = RGB(235, 235, 235);
    
    [self.view addSubview:self.headView];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + 8);
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:self.bgView];
   
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(93), SCREEN_WIDTH, (SCREEN_WIDTH - 50)/4)];
    [self.headView addSubview:_videoView];
    _videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, (SCREEN_WIDTH - 50)/4/3*4, (SCREEN_WIDTH - 50)/4)];
    _videoIcon.backgroundColor = [UIColor grayColor];
    _videoIcon.userInteractionEnabled = YES;
    [_videoView addSubview:_videoIcon];
    
    
    _videolength = [[UILabel alloc] initWithFrame:CGRectMake(_video.playerLayer.right + 10,((SCREEN_WIDTH - 50)/4 - 16)/2, 400, 16)];//_videoIcon
    _videolength.textColor = [UIColor darkGrayColor];
    _videolength.font = [UIFont systemFontOfSize:15];
    _videolength.text = @"15'";
    [_videoView addSubview:_videolength];
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 50)/4, (SCREEN_WIDTH - 50)/4);
    [play setImage:[UIImage imageNamed:@"播放小"] forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];

    UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletBtn setImage:[UIImage imageNamed:@"UMS_delete_image_button_normal.png"] forState:UIControlStateNormal];
    deletBtn.frame = CGRectMake((SCREEN_WIDTH - 50)/4/3*4 - 11 - 6-5, -3, 22, 22);
    deletBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_videoIcon addSubview:deletBtn];
    
    _videoView.hidden = YES;
    [self createPhotoView];
//    [self updateLocation];
    
    self.text = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, kHEIGHT(93) - 5)];
//    self.text = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, kHEIGHT(93) - 5) textContainer:[[NSTextContainer alloc] initWithSize:CGSizeMake(SCREEN_WIDTH - 10, CGFLOAT_MAX)]];
    self.text.delegate = self;
    if (self.is_dynamic) {
        self.text.placeholder = @"分享您的那些新鲜事...";
    } else {
        self.text.placeholder = @"写点什么吧...";
    }
    self.text.font = kFONT(15);
    self.text.tintColor = RGB(127, 127, 127);
    
//    self.text.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.text.dataDetectorTypes = UIDataDetectorTypeAll;
    self.text.layoutManager.allowsNonContiguousLayout = NO;
    [self.headView addSubview:self.text];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bottom + 10, SCREEN_WIDTH, (kHEIGHT(43) + 0.5)*4)];
    self.bottomView.backgroundColor = RGBColor(235, 235, 235);
    [self.scroll addSubview:self.bottomView];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem * button1 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
//    [_text setInputAccessoryView:topView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
    view1.backgroundColor = [UIColor whiteColor];
    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(13, ItemHeight/2 - 8.5, 14, 17)];
    icon1.image = [UIImage imageNamed:@"地址"];
    self.adress = [[UILabel alloc] initWithFrame:CGRectMake(icon1.right + 8, ItemHeight/2 - 10, SCREEN_WIDTH - 50, 20)];
    self.adress.text = @"所在位置";
    self.adress.font = kFONT(15);
    [view1 addSubview:self.adress];
    [view1 addSubview:icon1];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, ItemHeight/2 - 10, 12, 20)];
//    image.backgroundColor = [UIColor redColor];
    image.image = [UIImage imageNamed:@"箭头"];
    [view1 addSubview:image];
    [self.bottomView addSubview:view1];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemHeight)];
    [view1 addSubview:control];
    [control addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, ItemHeightAndLine, SCREEN_WIDTH, ItemHeight)];
    view2.backgroundColor = [UIColor whiteColor];
    UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, ItemHeight/2 - 7, 14, 14)];
    icon2.image = [UIImage imageNamed:@"匿名"];
    [view2 addSubview:icon2];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(icon2.right + 8, ItemHeight/2 - 10, 100, 20)];
    label2.text = @"匿名发布";
    label2.font = kFONT(15);
    [view2 addSubview:label2];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(SCREEN_WIDTH - 34, ItemHeight/2 - 11.5, 21, 21);
    [_selectBtn setImage:[UIImage imageNamed:@"是否匿名"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"是匿名"] forState:UIControlStateSelected];
    _selectBtn.selected = NO;
    [view2 addSubview:_selectBtn];
    [self.selectBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick)];
    [view2 addGestureRecognizer:tap];
    [self.bottomView addSubview:view2];
        
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, ItemHeightAndLine*2, SCREEN_WIDTH, ItemHeight)];
    view3.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, ItemHeight/2 - 7, 14, 14)];
    icon3.image = [UIImage imageNamed:@"分享"];
    [view3 addSubview:icon3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(icon3.right + 8, ItemHeight/2 - 10, 100, 20)];
    label3.text = @"分享到";
    label3.font = kFONT(15);
    [view3 addSubview:label3];
    
    NSArray *unSelectImg = @[@"weixin",@"friend",@"qq",@"qzone",@"sina"];
    NSArray *selectImg = @[@"weixin_select",@"friend_select",@"qq_select",@"qzone_select",@"sina_select"];
    
    CGFloat x = SCREEN_WIDTH - (10+22)*5;
    CGFloat y = ItemHeight/2 - 11;
    CGFloat width = 22;
    
    for (int i = 0; i < unSelectImg.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x + i%5*(width + 10), y + i/5*(width+ 6), width, width);
        [btn setImage:[UIImage imageNamed:unSelectImg[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImg[i]] forState:UIControlStateSelected];
        btn.tag = i + 1;
        btn.selected = NO;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:btn];
        [view3 addSubview:btn];
    }
    
    [self.bottomView addSubview:view3];
    
    if (self.type == WriteTypeAnswer) {
        view3.hidden = YES;
    }
}


- (void)resignKeyboard
{
    if (self.isOpinition) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
        WPOpitionTableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
        [cell.textField resignFirstResponder];
    }
    
    [_text resignFirstResponder];
    [self reductionKeyboard];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSMutableString * changedString=[[NSMutableString alloc]initWithString:textView.text];
//    [changedString replaceCharactersInRange:range withString:text];
//    NSString *str = [changedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length!=0) {
//        self.navigationItem.rightBarButtonItem.enabled=YES;
//    }else{
//        self.navigationItem.rightBarButtonItem.enabled=NO;
//    }
//    
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView {
    [textView becomeFirstResponder];
    
    
//   NSString *feedback = textView.text;
    
//    CGRect line = [textView caretRectForPosition:
//                   
//                   textView.selectedTextRange.start];
//    
//    CGFloat overflow = line.origin.y + line.size.height
//    
//    - ( textView.contentOffset.y + textView.bounds.size.height
//       
//       - textView.contentInset.bottom - textView.contentInset.top );
//    
//    if ( overflow > 0 ) {
//        
//        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
//        
//        // Scroll caret to visible area
//        
//        CGPoint offset = textView.contentOffset;
//        
//        offset.y += overflow + 7; // leave 7 pixels margin
//        
//        // Cannot animate with setContentOffset:animated: or caret will not appear
//        
//        [UIView animateWithDuration:.2 animations:^{
//            
//            [textView setContentOffset:offset];
//            
//        }];
//        
//    }
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    //    [textView scrollRangeToVisible:NSMakeRange(0, colomNumber)];
    [textView scrollRangeToVisible:NSMakeRange(cursorPosition.y - textView.height + (SCREEN_WIDTH == 414 ? 2*normalSize.height : normalSize.height), 0)];

}
#pragma  mark视频代理
#pragma mark - DBTakeVideoVC
- (void)sendBackVideoWith:(NSArray *)array
{
    self.videoView.hidden = NO;
    self.collectionView.hidden = YES;
    [self.assets addObjectsFromArray:array];
    self.videoType = 1;
    ALAsset *asset = self.assets[0];
    _videoIcon.image = [UIImage imageWithCGImage:asset.thumbnail];
    NSString *time = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    _videolength.text = time;
    self.isVideo_now = YES;

}

- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    self.videoView.hidden = NO;
    self.collectionView.hidden = YES;
    self.videoType = 2;
    self.videofilePath = filePaht;
    UIImage *image = [[self class] getImage:self.videofilePath];
    _videoIcon.image = image;
    NSArray *time = [length componentsSeparatedByString:@"."];
    _videolength.text = [NSString stringWithFormat:@"时长：%@''",time[0]];
    self.isVideo_now = YES;
    
    

    NSURL *mergeFileURL = [NSURL fileURLWithPath:filePaht];
    _video = [WPDDChatVideo videoWithUrl:mergeFileURL];
    _video.playerLayer.frame = CGRectMake(10, 0,(SCREEN_WIDTH - 50)/4/3*4,(SCREEN_WIDTH - 50)/4);
    [_videoView.layer addSublayer:_video.playerLayer];
    
    CGRect rect = _videolength.frame;
    rect.origin.x = _video.playerLayer.right + 10;
    _videolength.frame = rect;
    
    
    UIButton * tapBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, (SCREEN_WIDTH - 50)/4/3*4, (SCREEN_WIDTH - 50)/4)];
    [tapBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [_videoView addSubview:tapBtn];
    
    
    UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletBtn setImage:[UIImage imageNamed:@"UMS_delete_image_button_normal.png"] forState:UIControlStateNormal];
    deletBtn.frame = CGRectMake((SCREEN_WIDTH - 50)/4/3*4 - 11 - 6-5+10, -3, 22, 22);//(SCREEN_WIDTH - 50)/4/3*4 - 11 - 6-5, -3, 22, 22
    deletBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deletBtn addTarget:self action:@selector(deleteVideo) forControlEvents:UIControlEventTouchUpInside];
    [_videoView addSubview:deletBtn];
    
   
    
    
    
}
- (void)deleteVideo
{
    NSLog(@"删除视频");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要删除该段视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 15;
    [alert show];
    
}
#pragma mark点击播放视频
- (void)playVideo
{
    [self resignKeyboard];
    VideoBrowser *video = [[VideoBrowser alloc] init];
    
    video.videoUrl = [NSString stringWithFormat:@"%@",[NSURL fileURLWithPath:self.videofilePath]];
    video.hideDown = YES;
//    video.user_id = self.dicInfo[@"user_id"];
//    video.img_url = self.dicInfo[@"small_photos"][0][@"small_address"];
//    video.vd_url = [NSString stringWithFormat:@"%@",[NSURL fileURLWithPath:self.videofilePath]];
    [video show];
    
    
    
//    NSLog(@"观看视频");
//    if (self.videoType == 1) {
//        ALAsset *asset = self.assets[0];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    } else {
//        NSURL *url = [NSURL fileURLWithPath:self.videofilePath];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    }
//
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];

}

- (void)onPlaybackFinished
{
    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}

//获取本地视频的缩略图
+(UIImage *)getImage:(NSString *)videoURL

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

#pragma mark 选择图片
- (void)createPhotoView
{
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    fl.minimumInteritemSpacing = 10;
    fl.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kHEIGHT(93) + 5, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20) collectionViewLayout:fl];
    _collectionView.shouldGroupAccessibilityChildren = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator=YES;
    _collectionView.showsVerticalScrollIndicator=YES;    
    [_collectionView registerNib:[UINib nibWithNibName:@"WriteCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WriteCollectionViewCellId"];
    _collectionView.backgroundColor = [UIColor clearColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        [self resignKeyboard];
//    }];
//    [_collectionView addGestureRecognizer:tap1];

    
    [self.headView addSubview:_collectionView];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WriteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WriteCollectionViewCellId" forIndexPath:indexPath];
    
    if (self.assets.count>0 && self.assets.count<self.MAXCOUNT) {
        if (indexPath.row == self.assets.count) {
            cell.imageV.image = [UIImage imageNamed:@"write_bounds"];
            cell.deleteBtn.hidden = YES;
        } else {
            MLSelectPhotoAssets *asset = self.assets[indexPath.row];
            cell.imageV.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            cell.deleteBtn.hidden = NO;
            cell.deleteBtn.tag = indexPath.row + 1;
            [cell.deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if (self.assets.count == 0) {
        cell.imageV.image = [UIImage imageNamed:@"write_bounds"];
        cell.deleteBtn.hidden = YES;
    } else if (self.assets.count == self.MAXCOUNT) {
        MLSelectPhotoAssets *asset = self.assets[indexPath.row];
        cell.imageV.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.row + 1;
        [cell.deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)deletePicture:(UIButton *)sender
{
    self.delectPage = sender.tag - 1;
    [self.assets removeObjectAtIndex:self.delectPage];
    [self.collectionView reloadData];
    [self updateLocation];
    [self judgeSelectPicType];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要删除该张图片吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 5;
//    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 5) {  //删除图片
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else if (buttonIndex == 1) {
            NSLog(@"删除");
            [self.assets removeObjectAtIndex:self.delectPage];
            [self.collectionView reloadData];
            [self updateLocation];
            [self judgeSelectPicType];
        }
    } else if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
//            [self.text becomeFirstResponder];
        } else if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];

            [self.text resignFirstResponder];
            [self performSelectorWithArgs:@selector(delat) afterDelay:0.02];
        }

    } else if (alertView.tag == 15) { //删除视频
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else {
            [self.assets removeAllObjects];
            self.videofilePath = @"";
            self.isVideo_now = NO;
            self.videoView.hidden = YES;
            self.collectionView.hidden = NO;
            self.selectPicType = 1;
            
//            [_video.playerLayer removeFromSuperlayer];
        }
    }
}

- (void)delat
{
    [self.navigationController popViewControllerAnimated:YES];

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    //最多输入4000字
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength > 4000) {
        return NO;
    }
    return YES;
    
}

#pragma mark - 当textView 进入编辑状态的时候,执行代理函数
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGSize size = [textView.text sizeWithFont:[textView font]];
    int length = size.height;
    int colomNumber = textView.contentSize.height/length;
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    [textView scrollRangeToVisible:NSMakeRange(cursorPosition.y, 0)];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assets.count < self.MAXCOUNT) {
        return self.assets.count + 1;
    } else {
        return self.assets.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 50)/4, (SCREEN_WIDTH - 50)/4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.text resignFirstResponder];
    if (self.assets.count < 9) { //相册里面没有9张图片
        if (indexPath.row == self.assets.count) {
            [self onTap];
        } else {
            MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
            browserVc.isPreView = YES;
            browserVc.needUpdataAssestBlock = ^(NSMutableArray *photos){
                [self preViewUpdataWith:photos];
            };
            browserVc.currentPage = indexPath.row;
            browserVc.photos = self.assets;
            
            //拍照
            browserVc.takePictureByCameraBlock = ^(NSUInteger clickeNum){
                NSLog(@"点击的 %lu", (unsigned long)clickeNum);
                [self takePhoto];
            };
            //从手机选择
            browserVc.takePictureByAlbumBlock = ^(NSUInteger clickeNum){
                NSLog(@"点击的 %lu", (unsigned long)clickeNum);
                [self selectPhoto];
            };
            //设为首页

            //保存图片
            browserVc.savePictureToAlbumBlock = ^(NSUInteger clickeNum){
                NSLog(@"点击的 %lu", (unsigned long)clickeNum);
                
            };
            //删除


            
            
            
            [self.navigationController pushViewController:browserVc animated:YES];
        }
    } else {                    //相册已选满，不能再选了
        MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
        browserVc.isPreView = YES;
        browserVc.needUpdataAssestBlock = ^(NSMutableArray *photos){
            [self preViewUpdataWith:photos];
        };
        browserVc.currentPage = indexPath.row;
        browserVc.photos = self.assets;
        [self.navigationController pushViewController:browserVc animated:YES];
    }
}

- (void)preViewUpdataWith:(NSMutableArray *)photos
{
    self.assets = photos;
    for (MLSelectPhotoAssets *asset in photos) {
        UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
        [_photos addObject:image];
    }
    [self.collectionView reloadData];
    [self updateLocation];
    [self judgeSelectPicType];
}

- (void)onTap{
    [self selectPicture];
}

- (void)location{
    [self.text resignFirstResponder];
    LocationViewController *location = [[LocationViewController alloc] init];
    location.delegate = self;
    [self.navigationController pushViewController:location animated:YES];
}

- (void)sendBackLocationWith:(NSString *)location
{
    if ([location isEqualToString:@"不显示位置"]) {
        location = @"所在位置";
    }
    NSDictionary *replaceDic = @{@"title" : location,
                                 @"subtitle" : @"",
                                 @"image" : @"share_address"};
    [self.dataSource replaceObjectAtIndex:0 withObject:replaceDic];
    self.speak_adress = [location isEqualToString:@"所在位置"] ? @"" : location;
    [_tableView reloadData];
}

- (void)buttonClick{
    if (self.selectBtn.isSelected == YES) {
        self.selectBtn.selected = NO;
    } else {
        self.selectBtn.selected = YES;
    }
}

- (void)shareBtnClick:(UIButton *)sender
{
    UIButton *button = self.buttons[sender.tag - 1];
    if (button.isSelected == YES) {
        button.selected = NO;
    } else {
        button.selected = YES;
    }
}

#pragma mark - publish btn click
- (void)buttonClick:(UIButton *)sender
{
    [self.text resignFirstResponder];
    
    if (self.type == WriteTypeAnswer) {
        [self answerTheQuestion];
        return;
    }
    NSMutableString * changedString=[[NSMutableString alloc]initWithString:self.text.text];
    NSString *str = [changedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length == 0 && self.assets.count == 0 && _videoView.isHidden == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲，写点什么再发呗！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!self.is_dynamic) {
        if (self.isOpinition) {
            [self uploadOpition];
        }
        else
        {
             [self publishPhotoAlum];
        }
      
        return;
    }

    if (self.isVideo_now) {
        [self publishWithVideo];
    } else {
        if (self.assets.count == 0) {
            [self publishWithOutPicture];
        } else {
            [self newPublishWithPicture];
        }
    }
    [self buttonHiden];
}
#pragma mark   提交意见
-(void)uploadOpition
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    WPOpitionTableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/personal_info.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"callback",@"content":self.text.text,@"phone":cell.textField.text.length?cell.textField.text:@""};
    
    if (self.assets.count)
    {
        for (int i = 0; i<self.assets.count; i++) {
            MLSelectPhotoAssets *asset = self.assets[i];
            if ([asset isKindOfClass:[UIImage class]]) {
                UIImage *image = [self fixOrientation:(UIImage *)asset];
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(image, 0.7);//0.5
                formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else {
                NSArray * arr = [asset.asset valueForProperty:ALAssetPropertyRepresentations] ;
                if ([arr[0] rangeOfString:@".bmp"].location !=NSNotFound) {
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    WPFormData *formData = [[WPFormData alloc]init];
                    formData.data = UIImageJPEGRepresentation(img, 1.0);//0.5
                    formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                    formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
                    formData.mimeType = @"application/octet-stream";
                    [_photoData addObject:formData];
                } else if ([arr[0] rangeOfString:@".gif"].location !=NSNotFound) {
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    WPFormData *formData = [[WPFormData alloc]init];
                    formData.data = UIImageJPEGRepresentation(img, 1.0);//0.5
                    formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                    formData.filename = [NSString stringWithFormat:@"photo%d.gif",i+1];
                    formData.mimeType = @"application/octet-stream";
                    [_photoData addObject:formData];
                } else {
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    if (!img) {
                        img = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                    }
                    WPFormData *formData = [[WPFormData alloc]init];
                    formData.data = UIImageJPEGRepresentation(img, 1.0);//0.5
                    formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                    formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
                    formData.mimeType = @"application/octet-stream";
                    [_photoData addObject:formData];
                }
            }
        }
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:urlStr params:dic formDataArray:_photoData success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if (![json[@"status"] intValue])
            {
              [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD createHUD:@"提交失败" View:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"提交失败" View:self.view];
        }];
        
        
    }
    else
    {
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if (![json[@"status"] intValue]) {
                 [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD createHUD:@"提交失败" View:self.view];
            }
         
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"提交失败" View:self.view];
        }];
    }
}
#pragma mark - 发布群说说
- (void)publishPhotoAlum
{
    //暂停播放
    [_video.player pause];
    if (!self.assets.count) {
        [MBProgressHUD createHUD:@"请添加图片" View:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    for (int i = 0; i<self.assets.count; i++) {
        MLSelectPhotoAssets *asset = self.assets[i];
        if ([asset isKindOfClass:[UIImage class]]) {
            UIImage *image = [self fixOrientation:(UIImage *)asset];
            WPFormData *formData = [[WPFormData alloc]init];
            formData.data = UIImageJPEGRepresentation(image, 0.5);
            formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
            formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
            formData.mimeType = @"application/octet-stream";
            [_photoData addObject:formData];
        } else {
            NSArray * arr = [asset.asset valueForProperty:ALAssetPropertyRepresentations] ;
            if ([arr[0] rangeOfString:@".bmp"].location !=NSNotFound) {
                NSLog(@"BMP");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
                formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
                formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else if ([arr[0] rangeOfString:@".gif"].location !=NSNotFound) {
                NSLog(@"GIF");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
                formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
                formData.filename = [NSString stringWithFormat:@"filedata_%d.gif",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else {
                NSLog(@"NOMAL");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
                formData.name = [NSString stringWithFormat:@"filedata_%d",i+1];
                formData.filename = [NSString stringWithFormat:@"filedata_%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            }
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"AddPhoto";
    params[@"user_id"] = kShareModel.userId;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"address"] = self.speak_adress;
    params[@"remark"] = self.text.text;
    params[@"group_id"] = self.group_id;
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    [WPHttpTool postWithURL:url params:params formDataArray:_photoData success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupUpdate" object:nil];
            if (self.publishSuccessBlock) {
                self.publishSuccessBlock();
            }
            //发送消息到群中
            [self sendGroupAblumMessage:json[@"albumID"] andAvatar:json[@"top1photo"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD alertView:@"发布失败" Message:json[@"info"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD alertView:@"发布失败" Message:error.localizedDescription];
    }];
}

-(void)sendGroupAblumMessage:(NSString*)ablumId andAvatar:(NSString*)avatar
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
        NSString * textStr = [NSString string];
        if (self.text.text.length) {
            textStr = self.text.text;
        }
        else
        {
          textStr = @"[图片]";
        }
        NSString * nickStr = [NSString stringWithFormat:@"%@",kShareModel.nick_name.length?kShareModel.nick_name:kShareModel.username];
        //@"from_info":[NSString stringWithFormat:@"%@：%@",nickStr,textStr],
        NSDictionary * dictionary = @{@"display_type":@"13",@"content":@{@"from_type":@"1",
                                                                         @"from_title":@"发布了群相册",
                                                                         @"from_info":[NSString stringWithFormat:@"%@",textStr],
                                                                         @"from_qun_id":self.group_id,
                                                                         @"from_g_id":self.groupId,
                                                                         @"from_id":ablumId,
                                                                         @"from_avatar":avatar,
                                                                         @"session_info":[NSString stringWithFormat:@"发布了群相册"]}};//%@:,kShareModel.nick_name
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble?self.mouble:mouble MsgType:msgContentType];
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDARGUMENTSUCCESS" object:message];
        } failure:^(NSString *errorDescripe) {
        }];
        message.msgContent = contentStr;
        [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        } Error:^(NSError *error) {
            [self.tableView reloadData];
        }];
    }];
}
- (void)answerTheQuestion
{
    if (self.text.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，写点什么再发呗！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    if (self.selectBtn.isSelected == YES) {
        self.is_anoymous = @"0";
    } else {
        self.is_anoymous = @"1";
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"answer";
    params[@"ask_id"] = self.ask_id;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"nike_name"] = userInfo[@"nick_name"];
    params[@"is_anoymous"] = self.is_anoymous;
    params[@"answer_content"] = self.text.text;
    params[@"longitude"] = [user objectForKey:@"longitude"];
    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"address"] = self.adress.text;
//    NSLog(@"**%@",params);
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/answer.ashx"];
//    NSLog(@"###%@",url);
    if (self.assets.count == 0) {
        [WPHttpTool postWithURL:url params:params success:^(id json) {
//            NSLog(@"%@===%@",json,json[@"info"]);
            if ([json[@"status"] integerValue] == 1) {
                [self.delegate refreshData];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
        }];
    } else {
        for (MLSelectPhotoAssets *asset in self.assets) {
            if ([asset isKindOfClass:[UIImage class]]) {
                UIImage *image = [self fixOrientation:(UIImage *)asset];
                NSData *data = UIImageJPEGRepresentation(image, 0.1);
                [_photoData addObject:data];
            } else {
                UIImage *img;
                CGFloat width = asset.asset.defaultRepresentation.dimensions.width;
                if (width <= 480) {
                    img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullResolutionImage];
                } else {
                    img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                }
                
                UIImage *newImage;
                if (img.size.height/img.size.width >= 3) {
                    if (img.size.width > 480) {
                        NSInteger proportion;
                        NSInteger width = (NSInteger)img.size.width;
                        if (width%480 == 0) {
                            proportion = width/480;
                        } else {
                            proportion = width/480 + 1;
                        }
                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(480, img.size.height/proportion)];
                    } else {
                        newImage = img;
                    }
                } else {
                    if (img.size.width > 1000 && img.size.height > 1000) {
                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, 1000)];
                    } else if (img.size.width <= 1000 && img.size.height > 1000) {
                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width, 1000)];
                    } else if (img.size.width > 1000 && img.size.height <= 1000) {
                        newImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(1000, img.size.height)];
                    } else {
                        newImage = img;
                    }
                }
                NSData *data = UIImageJPEGRepresentation(newImage, 0.1);
                [_photoData addObject:data];
            }
        }
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < _photoData.count; i++) {
                NSString *fileName = [NSString stringWithFormat:@"Filedata_%d.jpg",i+1];
                NSString *name = [NSString stringWithFormat:@"Filedata_%d",i+1];
                [formData appendPartWithFileData:_photoData[i] name:name fileName:fileName mimeType:@"application/octet-stream"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"status"] integerValue] == 1) {
                [self.delegate refreshData];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}


- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}
#pragma mark 发布文字
//发布写写
- (void)publishWithOutPicture{
    
    NSString * string = [self getUniqueStrByUUID];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"releaseDynamic";
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"speak_content"] = self.text.text;
    params[@"is_nearby"] = self.is_nearby;
    params[@"is_anoymous"] = self.is_anoymous;
    params[@"is_friends"] = self.is_friends;
    params[@"is_fans"] = self.is_fans;
    params[@"comment_type"] = self.comment_type;
    params[@"speak_address"] = self.speak_adress;
    params[@"guid"] = [NSString stringWithFormat:@"%@-%@",kShareModel.userId,string];
    [self.is_anoymous isEqualToString:@"4"]?(params[@"is_look"] = self.is_Look):([self.is_anoymous isEqualToString:@"5"]?(params[@"not_look"]=self.not_look):0);
    NSDictionary * upDic = [[WPUploadShuoShuo instance] upLoadText:params cate:self.categoryShuo];
    if (self.publishShuoShuoSuccess) {
        self.publishShuoShuoSuccess(upDic);
    }
    
    //保存在本地
    [self saveShuoshuo:params json:upDic and:string];
    [self.navigationController popViewControllerAnimated:YES];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        //上传成功时删除本地说说
        [self deleteShuo:json[@"guid"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadShuoSuccessAgain" object:nil];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (self.publishSuccessBlock) {
//            self.publishSuccessBlock();
//        }
//        [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error) {
        NSLog(@"error%@",error);
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:@"发布失败"];
    }];
    self.isCreate = NO;
    self.isPublish = NO;
    
}
-(void)saveShuoshuo:(NSDictionary*)params json:(NSDictionary*)upDic and:(NSString*)string
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdSHUOSHUO"];
    NSMutableArray * muarrau = [NSMutableArray array];
    [muarrau addObjectsFromArray:array];
    NSDictionary * saveDic = @{[NSString stringWithFormat:@"%@-%@",kShareModel.userId,string]:@[params,upDic]};
    [muarrau addObject:saveDic];
    array = [NSArray arrayWithArray:muarrau];
    [defaults setObject:array forKey:@"UPLOAdSHUOSHUO"];
}
-(void)deleteShuo:(NSString*)string
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdSHUOSHUO"];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    for (NSDictionary * dic  in array) {
        if (dic[string]) {
//            NSArray* array1 = dic[string];
//            NSDictionary * dicionary = array1[1];
//            NSArray * original_photos = dicionary[@"original_photos"];
//            NSString * imgCount = dicionary[@"imgCount"];
//            NSString * videoCount = dicionary[@"videoCount"];
//            if (videoCount.intValue) {//移除图片或视频数据
////                for (NSDictionary * diction in original_photos) {
////                    NSString * media_address = diction[@"media_address"];
////                    [[NSFileManager defaultManager] removeItemAtPath:media_address error:nil];
////                }
//            }
            [muarray removeObject:dic];
        }
    }
    array = [NSArray arrayWithArray:muarray];
    [defaults setObject:array forKey:@"UPLOAdSHUOSHUO"];
    
}
#pragma mark 发布图片
//发布图片
- (void)newPublishWithPicture{
    for (int i = 0; i<self.assets.count; i++) {
        MLSelectPhotoAssets *asset = self.assets[i];
        if ([asset isKindOfClass:[UIImage class]]) {
            UIImage *image = [self fixOrientation:(UIImage *)asset];
            WPFormData *formData = [[WPFormData alloc]init];
            formData.data = UIImageJPEGRepresentation(image, 0.7);//0.5
            formData.name = [NSString stringWithFormat:@"photo%d",i+1];
            formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
            formData.mimeType = @"application/octet-stream";
            [_photoData addObject:formData];
        } else {
            NSArray * arr = [asset.asset valueForProperty:ALAssetPropertyRepresentations] ;
            if ([arr[0] rangeOfString:@".bmp"].location !=NSNotFound) {
                NSLog(@"BMP");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 1.0);//0.5
                formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else if ([arr[0] rangeOfString:@".gif"].location !=NSNotFound) {
                NSLog(@"GIF");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 1.0);//0.5
                formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                formData.filename = [NSString stringWithFormat:@"photo%d.gif",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            } else {
                NSLog(@"NOMAL");
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                
                if (!img) {
                    img = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                }
//                CGFloat width = img.size.width;
                WPFormData *formData = [[WPFormData alloc]init];
                formData.data = UIImageJPEGRepresentation(img, 1.0);//0.5
                formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
                formData.mimeType = @"application/octet-stream";
                [_photoData addObject:formData];
            }
        }
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"releaseDynamic";
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"speak_content"] = self.text.text;
    params[@"is_nearby"] = self.is_nearby;
    params[@"is_anoymous"] = self.is_anoymous;
    params[@"is_friends"] = self.is_friends;
    params[@"is_fans"] = self.is_fans;
    params[@"comment_type"] = self.comment_type;
    params[@"speak_address"] = self.speak_adress;
    [self.is_anoymous isEqualToString:@"4"]?(params[@"is_look"] = self.is_Look):([self.is_anoymous isEqualToString:@"5"]?(params[@"not_look"]=self.not_look):0);
    NSString * string = [self getUniqueStrByUUID];
    params[@"guid"] = [NSString stringWithFormat:@"%@-%@",kShareModel.userId,string];
    NSDictionary * upDic = [[WPUploadShuoShuo instance] upLoadPhoto:params cate:self.categoryShuo array:self.assets];
    if (self.publishShuoShuoSuccess) {
        self.publishShuoShuoSuccess(upDic);
    }
    //保存到本地
    [self saveShuoshuo:params json:upDic and:string];
    [self.navigationController popViewControllerAnimated:YES];

    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [WPHttpTool postWithURL:url params:params formDataArray:_photoData success:^(id json) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if ([json[@"status"] integerValue] == 1) {
                //发布成功删除数据
                [self deleteShuo:json[@"guid"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadShuoSuccessAgain" object:nil];
            } else {
            }
        } failure:^(NSError *error) {
        }];
    });
//    [WPHttpTool postWithURL:url params:params formDataArray:_photoData success:^(id json) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        if ([json[@"status"] integerValue] == 1) {
//            //发布成功删除数据
//            [self deleteShuo:json[@"guid"]];
////            [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
//////            if (self.refreshData) {
//////                self.refreshData(self.selectTopic);
//////            }
////            if (self.publishSuccessBlock) {
////                self.publishSuccessBlock();
////            }
////            [self.navigationController popViewControllerAnimated:YES];
//        } else {
////            [MBProgressHUD alertView:@"发布失败" Message:json[@"info"]];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error);
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD alertView:@"发布失败" Message:error.localizedDescription];
//    }];
}

//将自动旋转的图片调成正确的位置
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}

//控制图片大小
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

#pragma mark发布说说有视频
- (void)publishWithVideo{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"releaseDynamic";
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"speak_content"] = self.text.text;
    params[@"is_nearby"] = self.is_nearby;
    params[@"is_anoymous"] = self.is_anoymous;
    params[@"is_friends"] = self.is_friends;
    params[@"is_fans"] = self.is_fans;
    params[@"comment_type"] = self.comment_type;
    params[@"speak_address"] = self.speak_adress;
    [self.is_anoymous isEqualToString:@"4"]?(params[@"is_look"] = self.is_Look):([self.is_anoymous isEqualToString:@"5"]?(params[@"not_look"]=self.not_look):0);
    

   
    NSString * string = [self getUniqueStrByUUID];
    params[@"guid"] = [NSString stringWithFormat:@"%@-%@",kShareModel.userId,string];
    NSDictionary * upDic =  [[WPUploadShuoShuo instance] upLoadVideo:params cate:self.categoryShuo string:self.videofilePath array:self.assets isor:(self.videoType == 1)?YES:NO];;
    if (self.publishShuoShuoSuccess) {
        self.publishShuoShuoSuccess(upDic);
    }
    
    //保存到本地
    [self saveShuoshuo:params json:upDic and:string];
    [self.navigationController popViewControllerAnimated:YES];
    //异步上传
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *videoData = [[NSData alloc] init];
        if (self.videoType == 1) {
            ALAsset *asset = self.assets[0];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            videoData = data;
        } else {
            
            NSData *data = [NSData dataWithContentsOfFile:self.videofilePath];
            videoData = data;
        }
        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:videoData name:@"photo1" fileName:@"photo1.mp4" mimeType:@"video/quicktime"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self deleteShuo:dict[@"guid"]];
            //发布成功若有视频则将数据保存在本地以便进入时使用
            NSString * urlStr = dict[@"Url"];
            if (urlStr.length)
            {
                urlStr = [IPADDRESS stringByAppendingString:urlStr];
                NSArray * pathArray = [urlStr componentsSeparatedByString:@"/"];
                NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
                NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
                NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
                [videoData writeToFile:fileName1 atomically:YES];
            }
//            NSArray * array = @[@{@"media_address":urlStr,@"guid":dict[@"guid"]}];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadShuoSuccessAgain" object:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    });
    
    
    
    
//    if (self.videoType == 1) {
//        ALAsset *asset = self.assets[0];
//        //将视频转换成NSData
//        ALAssetRepresentation *rep = [asset defaultRepresentation];
//        Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
//        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
//        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//        videoData = data;
//    } else {
//        
//        NSData *data = [NSData dataWithContentsOfFile:self.videofilePath];
//        videoData = data;
//    }
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    [MBProgressHUD showMessage:@"" toView:self.view];
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:videoData name:@"photo1" fileName:@"photo1.mp4" mimeType:@"video/quicktime"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////        [alert show];
////        if (self.refreshData) {
////            self.refreshData(self.selectTopic);
////        }
////        Url = "/upload/201609/30/201609301442352679.mp4\Uff01";
////        info = "\U63d0\U4ea4\U6210\U529f\Uff01";
////        status = 1;
//        //发布成功若有视频则将数据保存在本地以便进入时使用
//        NSString * urlStr = dict[@"Url"];
//        if (urlStr.length)
//        {
//            urlStr = [IPADDRESS stringByAppendingString:urlStr];
//            NSArray * pathArray = [urlStr componentsSeparatedByString:@"/"];
//            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
//            NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
//            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
//            [videoData writeToFile:fileName1 atomically:YES];
//        }
////        [MBProgressHUD createHUD:@"发布成功!" View:self.view];
//        if (self.publishSuccessBlock) {
//            self.publishSuccessBlock();
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"%@",error);
//    }];
    
    self.isCreate = NO;
    self.isPublish = NO;
}


//创建发布选择
- (void)sentView{
    self.isCreate = YES;
    
    self.topicView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemHeightAndLine*_titles.count-1)];
    self.topicView2.backgroundColor = RGB(235, 235, 235);
//    NSArray *titles = @[@"职场说说",@"职场正能量",@"职场吐槽",@"管理智慧",@"创业心得",@"职场心理学",@"情感心语",@"经营智慧",@"企业管理"];
    for (int i = 0; i < _titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ItemHeightAndLine*i, SCREEN_WIDTH, ItemHeight)];
        view.backgroundColor = [UIColor whiteColor];
//        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(0, ItemHeightAndLine*i, SCREEN_WIDTH, ItemHeight);
        button.tag = i + 1;
        [button addTarget:self action:@selector(selectTopic:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topicView2 addSubview:view];
        [_topicView2 addSubview:button];
    }
    
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, ItemHeight/2 - 10, 30, 20)];
    defaultLabel.text = @"默认";
    defaultLabel.textColor = kLightColor;
    defaultLabel.font = kFONT(12);
    [_topicView2 addSubview:defaultLabel];

    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [_backView addSubview:_topicView2];
//    _topicView2.hidden = YES;
//    [_backView addSubview:_topicView1];
//    [_backView addSubview:view];
    
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonHiden)];
    [_backView addGestureRecognizer:tap];
    
    [self.view addSubview:_backView];
    
}

- (void)topicViewClick{
    _topicView2.hidden = NO;
    _topicView1.hidden = YES;
}

- (void)selectTopic:(UIButton *)sender
{
//    NSLog(@"点击");
    if (sender.tag == 1) {
        self.comment_type = @"1";
//        NSLog(@"说说");
    } else if (sender.tag == 2) {
        self.comment_type = @"4";
//        NSLog(@"正能量");
    } else if (sender.tag == 3) {
        self.comment_type = @"3";
//        NSLog(@"吐槽");
    } else if (sender.tag == 4) {
        self.comment_type = @"6";
//        NSLog(@"智慧");
    } else if (sender.tag == 5) {
        self.comment_type = @"7";
//        NSLog(@"创业");
    } else if (sender.tag == 6) {
        self.comment_type = @"11";
//        NSLog(@"心理学");
    } else if (sender.tag == 7) {
        self.comment_type = @"5";
//        NSLog(@"情感");
    } else if (sender.tag == 8) {
//        NSLog(@"经营智慧");
        self.comment_type = @"12";
    } else if (sender.tag == 9) {
//        NSLog(@"企业管理");
        self.comment_type = @"8";
    } else if (sender.tag == 10) {
        self.comment_type = @"13";
    }
    
    if (self.selectBtn.isSelected == YES) {
        self.is_anoymous = @"0";
    } else {
        self.is_anoymous = @"1";
    }
    self.selectTopic = _titles[sender.tag - 1];
    if (self.isVideo_now) {
        [self publishWithVideo];
    } else {
        if (self.assets.count == 0) {
            [self publishWithOutPicture];
        } else {
            [self newPublishWithPicture];
        }
    }
    [self buttonHiden];
}

-(void)buttonOneClick:(UIButton*)sender
{
    if (sender.tag == 0) {
        [sender setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        sender.tag = 1;
        [self.buttonTwo setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        self.buttonTwo.tag = 1;
        self.is_nearby = @"0";
        [self.buttonThree setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        self.buttonThree.tag = 1;
        self.is_fans = @"0";
        [self.buttonFour setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        self.buttonFour.tag = 1;
        self.is_friends = @"0";
        
    } else {
        [self.buttonOne setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        sender.tag = 0;
        [self.buttonTwo setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonTwo.tag = 0;
        self.is_nearby = @"1";
        [self.buttonThree setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonThree.tag = 0;
        self.is_fans = @"1";
        [self.buttonFour setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonFour.tag = 0;
        self.is_friends = @"1";
    }
    
//    NSLog(@"is_near:%@ is_fan:%@ is_friend:%@",self.is_nearby,self.is_fans,self.is_friends);
}

-(void)buttonTwoClick:(UIButton*)sender
{
    if (sender.tag == 0) {
        self.is_nearby = @"0";
    } else {
        self.is_nearby = @"1";
    }
    [self buttonAllClick:sender];}

-(void)buttonThreeClick:(UIButton*)sender
{
    if (sender.tag == 0) {
        self.is_fans = @"0";
    } else {
        self.is_fans = @"1";
    }
    [self buttonAllClick:sender];
}

-(void)buttonFourClick:(UIButton*)sender
{
    if (sender.tag == 0) {
        self.is_friends = @"0";
    } else {
        self.is_friends = @"1";
    }   

    [self buttonAllClick:sender];
}

-(void)buttonFiveClick:(UIButton*)sender
{
    
}

-(void)buttonAllClick:(UIButton*)sender
{
    if (sender.tag == 0)
    {
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        if (self.buttonTwo.tag && self.buttonThree.tag && self.buttonFour.tag) {
            self.buttonOne.tag = 1;
            [self.buttonOne setImage:[UIImage imageNamed:@"menu_right_blue"] forState:UIControlStateNormal];
        }
    }
    else
    {
        sender.tag = 0;
        [sender setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
        self.buttonOne.tag = 0;
        [self.buttonOne setImage:[UIImage imageNamed:@"menu_right_white"] forState:UIControlStateNormal];
    }
}
-(void)buttonHiden
{
    [self.topicView1 removeFromSuperview];
    [self.topicView2 removeFromSuperview];
    [self.backView removeFromSuperview];
    self.isCreate = NO;
    self.isPublish = NO;
}

- (void)selectPicture{
    if (self.is_dynamic) {
        if (self.selectPicType == 1) {
//            HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", @"视频", nil];
            HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照",nil];
            sheet.tag = 1;
            // 2.显示出来
            [sheet show];
            
        } else if (self.selectPicType == 2) {
            HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
            sheet.tag = 2;
            // 2.显示出来
            [sheet show];
            
        }
    } else {
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
        sheet.tag = 2;
        // 2.显示出来
        [sheet show];
    }
    
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 1) {
            [self selectPhoto];
        } else if (buttonIndex == 2) {
            [self takePhoto];
        } else if (buttonIndex == 3) {
            [self takeVideo];
        }
    } else if (actionSheet.tag == 2) {
        if (buttonIndex == 1) {
            [self selectPhoto];
        } else if (buttonIndex == 2) {
            [self takePhoto];
        }
    }
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 1) {
        if (buttonIndex == 1) {
            [self selectPhoto];
        } else if (buttonIndex == 2) {
            [self takePhoto];
        } else if (buttonIndex == 3) {
            [self takeVideo];
        }
    } else if (sheet.tag == 2) {
        if (buttonIndex == 1) {
            [self selectPhoto];
        } else if (buttonIndex == 2) {
            [self takePhoto];
        }
    }
}


- (void)selectPhoto{
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = self.MAXCOUNT - self.assets.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        for (MLSelectPhotoAssets *asset in assets) {
            UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [_photos addObject:image];
        }
        [self.collectionView reloadData];
        [self updateLocation];
        [self judgeSelectPicType];
    };
}

- (void)judgeSelectPicType{
    if (self.assets.count>0) {
        self.selectPicType = 2;
    } else {
        self.selectPicType = 1;
    }
}

- (void)takePhoto{
    UIImagePickerController*picker=[[UIImagePickerController alloc]init];
    //判读相机是否可以启动
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma  mark 拍摄视频
- (void)takeVideo
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.takeVideoDelegate = self;
    [self.navigationController pushViewController:tackVedio animated:YES];
    
    
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)photoBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        NSLog(@"相册");
        [self cancelView];
        // 创建控制器
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.minCount = self.MAXCOUNT - self.assets.count;
//        [pickerVc show];
        [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
        __weak typeof(self) weakSelf = self;
        pickerVc.callBack = ^(NSArray *assets){
            [weakSelf.assets addObjectsFromArray:assets];
            for (MLSelectPhotoAssets *asset in assets) {
                UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                [_photos addObject:image];
            }
            [self.collectionView reloadData];
            [self updateLocation];
        };
        
    } else if (sender.tag == 2) {
        NSLog(@"拍拍");
        UIImagePickerController*picker=[[UIImagePickerController alloc]init];
            //判读相机是否可以启动
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            }
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];

        [self cancelView];
    } else if (sender.tag == 3) {
        NSLog(@"视频");
        [self cancelView];
    } else {
        [self cancelView];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_assets addObject:image];
    [self updateLocation];
    [self judgeSelectPicType];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//保存到系统相册
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
}
- (void)updateLocation{
    if (self.assets.count >0 && self.assets.count < 4) {
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + 8);
    } else if (self.assets.count == 0) {
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + 8);
    } else if (self.assets.count >= 4 && self.assets.count < 8) {
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + WIDTH + 10);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + WIDTH + 10 + 8);
    } else {
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + 2*WIDTH + 20);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(93) + WIDTH + 15 + 2*WIDTH + 20 + 8);
    }
//    [self.tableView reloadData];
    self.tableView.tableHeaderView = self.headView;
//    self.bottomView.frame = CGRectMake(0, self.headView.bottom + 10, SCREEN_WIDTH, SCREEN_HEIGHT);
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.text resignFirstResponder];
//}

- (void)cancelView{
    [self.viewTwo removeFromSuperview];
    [self.backView2 removeFromSuperview];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.text resignFirstResponder];
//}

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
