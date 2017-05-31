//
//  WPJobViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/7/2.
//  Copyright (c) 2015年 WP. All rights reserved.
//  工作圈第二版

#import "WPJobViewController.h"
#import "CHTumblrMenuView.h"
#import "WPWriteController.h"
#import "WriteViewController.h"
#import "WPHttpTool.h"
#import "WorkTableViewCell.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "WPDetailControllerThree.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"

#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"
#import "UIImage+MR.h"

#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "DBTakeVideoVC.h"
#import "WFPopView.h"
#import "WPButton.h"
#import "WPShareModel.h"
#import "HeadImage.h"
#import "PersonalHomepageController.h"
#import "WPJobDetailViewController.h"
#import "WPActionSheet.h"
#import "WPNicknameLabel.h"
#import "ListView.h"

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
#define DDCOMPONENT_BOTTOM          CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT), SCREEN_WIDTH, 216)
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height,SCREEN_WIDTH,self.chatInputView.frame.size.height)
#define DDINPUT_HEIGHT              self.chatInputView.frame.size.height
#define DDINPUT_TOP_FRAME           CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height - 216, SCREEN_WIDTH, self.chatInputView.frame.size.height)
#define DDUTILITY_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT)  -216, SCREEN_WIDTH, 216)
#define DDEMOTION_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) -216, SCREEN_WIDTH, 216)
#define kWorkCellId  @"WorkTableViewCell"
#define headImageName @"headImage"

@interface WPJobViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,callBackVideo,takeVideoBack,updataImage,UIAlertViewDelegate,WPActionSheet>

@property (nonatomic,strong) UIScrollView *mainScrol;
@property (nonatomic,strong) UIScrollView *bottomScroll;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIButton *button5;
@property (nonatomic,strong) UIButton *button6;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic,strong) UITableView *table5;
@property (nonatomic,strong) UITableView *table6;
@property (nonatomic,strong) UIImageView *headImageView1;
@property (nonatomic,strong) UIImageView *headImageView2;
@property (nonatomic,strong) UIImageView *headImageView3;
@property (nonatomic,strong) UIImageView *headImageView4;
@property (nonatomic,strong) UIImageView *headImageView5;
@property (nonatomic,strong) UIImageView *headImageView6;
@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *slelctPicView;
@property (nonatomic,strong) UIView *backView2;

@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *data2;
@property (nonatomic,strong) NSMutableArray *data3;
@property (nonatomic,strong) NSMutableArray *data4;
@property (nonatomic,strong) NSMutableArray *data5;
@property (nonatomic,strong) NSMutableArray *data6;
@property (nonatomic,strong) NSMutableArray *datas;  //所有的数据


@property (nonatomic,strong) NSMutableArray *goodData1;
@property (nonatomic,strong) NSMutableArray *goodData2;
@property (nonatomic,strong) NSMutableArray *goodData3;
@property (nonatomic,strong) NSMutableArray *goodData4;
@property (nonatomic,strong) NSMutableArray *goodData5;
@property (nonatomic,strong) NSMutableArray *goodData6;
@property (nonatomic,strong) NSMutableArray *goodDatas;

@property (nonatomic,strong) UIImageView *noDataView1;
@property (nonatomic,strong) UIImageView *noDataView2;
@property (nonatomic,strong) UIImageView *noDataView3;
@property (nonatomic,strong) UIImageView *noDataView4;
@property (nonatomic,strong) UIImageView *noDataView5;
@property (nonatomic,strong) UIImageView *noDataView6;

@property (nonatomic,strong) UIView *reqErrorView1;
@property (nonatomic,strong) UIView *reqErrorView2;
@property (nonatomic,strong) UIView *reqErrorView3;
@property (nonatomic,strong) UIView *reqErrorView4;
@property (nonatomic,strong) UIView *reqErrorView5;
@property (nonatomic,strong) UIView *reqErrorView6;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath; //头像点击的行数

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSArray *tables;
@property (nonatomic,assign) NSInteger isNeedDelloc;

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImagePickerController *picker2;

@property (nonatomic,strong) NSString *filePath; //音频路径
@property (nonatomic,strong) NSDictionary *backInfo;
@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数
@property (nonatomic,assign) NSInteger deletIndex;               //所要删除说说的位置
@property (nonatomic,assign) BOOL isEditeNow;                    //当前是否正在编辑状态
@property (nonatomic,assign) CGFloat headViewHeight;             //headView的高度
@property (nonatomic,assign) BOOL isMore;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSString *speak_type;               //说说的种类

- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;

@end

@implementation WPJobViewController
{
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    DDBottomShowComponent _bottomShowComponent;
    UIButton *_recordButton;
    float _inputViewY;
    NSString* _currentInputContent;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
//    NSInteger _page5;
//    NSInteger _page6;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(235, 235, 235);
    self.headViewHeight = 0.5625*SCREEN_WIDTH;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    self.currentPage = 0;
    self.isNeedDelloc = 0;
    self.selectIndex = 0;
    self.speak_type = @"9";
    self.headImage = [UIImage imageNamed:@"discover_2.jpg"];
    self.isEditeNow = NO;
    self.isMore = NO;
    self.data1 = [NSMutableArray array];
    self.data2 = [NSMutableArray array];
    self.data3 = [NSMutableArray array];
    self.data4 = [NSMutableArray array];
    
    //所有的数据
    self.datas = [[NSMutableArray alloc] initWithObjects:_data1,_data2,_data3,_data4,nil];
    self.goodData1 = [NSMutableArray array];
    self.goodData2 = [NSMutableArray array];
    self.goodData3 = [NSMutableArray array];
    self.goodData4 = [NSMutableArray array];
    self.goodDatas = [[NSMutableArray alloc] initWithObjects:_goodData1,_goodData2,_goodData3,_goodData4,nil];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程一
        [self reloadBackGroundImage];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程二
//        [self createData1];
    });

    [self createNav];
    [self createUI];
    [self createBottom];
    [self notificationCenter];
    [self initialInput];
}


- (void)createNav
{
    self.title = self.title;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
    
    if (self.reqJobType == JobTypeDynamic) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"smll_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonMenu)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"smll_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    }

}

- (void)rightBtnClick{
    NSLog(@"发布");
    WriteViewController *write = [[WriteViewController alloc] init];
    write.type = WriteTypeBask;
    write.myTitle = @"创建";
    [self.navigationController pushViewController:write animated:YES];
}

- (void)onTap
{
    NSLog(@"换头像");
    self.backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backView1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, (SCREEN_HEIGHT - 43)/2, SCREEN_WIDTH - 50, 43);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"更换背景图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(14, 10, 14, SCREEN_WIDTH - 150)];
    [self.backView1 addSubview:button];
    self.backView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [self.backView1 addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView1];
    
}

- (void)cancel
{
    [self.backView1 removeFromSuperview];
}

- (void)cancelView{
    [self.slelctPicView removeFromSuperview];
    [self.backView2 removeFromSuperview];
}

- (void)selectPicture{
    [self cancel];
    
    WPActionSheet *action = [[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"拍照"] imageNames:nil top:0];
    [action showInView:self.view];
    
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _picker2=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            _picker2.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        _picker2.delegate=self;
        _picker2.allowsEditing = YES;
        [self presentViewController:_picker2 animated:YES completion:nil];
    } else {
        _picker2=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            _picker2.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        _picker2.delegate=self;
        _picker2.allowsEditing = YES;
        
        [self presentViewController:_picker2 animated:YES completion:nil];
    }
}

- (void)photoBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        NSLog(@"相册");
        _picker2=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            _picker2.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        _picker2.delegate=self;
        _picker2.allowsEditing = YES;
        [self presentViewController:_picker2 animated:YES completion:nil];
        [self cancelView];
    } else if (sender.tag == 2) {
        NSLog(@"拍拍");
        _picker2=[[UIImagePickerController alloc]init];
        //判读相机是否可以启动
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            _picker2.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        _picker2.delegate=self;
        _picker2.allowsEditing = YES;
        
        [self presentViewController:_picker2 animated:YES completion:nil];
        [self cancelView];
    } else if (sender.tag == 3) {
        NSLog(@"视频");
    } else {
        [self cancelView];
    }
}


- (UIImageView *)headImageView1
{
    if (_headImageView1 ==nil) {
        _headImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headViewHeight)];
        NSString *str = self.backInfo[@"background"];
        if (str.length == 0) {
            _headImageView1.image = self.headImage;
        } else {
            NSString *url = [IPADDRESS stringByAppendingString:str];
//            [_headImageView1 setImageWithURL:URLWITHSTR(url) placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                _headImage = image;
//            }];
            [_headImageView1 sd_setImageWithURL:URLWITHSTR(url) placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _headImage = image;
            }];
        }
        _headImageView1.contentMode = UIViewContentModeScaleToFill;
        _headImageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_headImageView1 addGestureRecognizer:tap1];
    }
    return _headImageView1;
}

- (UIImageView *)headImageView2
{
    if (_headImageView2 ==nil) {
        _headImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.headViewHeight)];
        _headImageView2.image = self.headImage;
        _headImageView2.contentMode = UIViewContentModeScaleToFill;
        _headImageView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_headImageView2 addGestureRecognizer:tap1];
    }
    return _headImageView2;
}

- (UIImageView *)headImageView3
{
    if (_headImageView3 ==nil) {
        _headImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headViewHeight)];
        _headImageView3.image = self.headImage;
        _headImageView3.contentMode = UIViewContentModeScaleToFill;
        _headImageView3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_headImageView3 addGestureRecognizer:tap1];
    }
    return _headImageView3;
}

- (UIImageView *)headImageView4
{
    if (_headImageView4 ==nil) {
        _headImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.headViewHeight)];
        _headImageView4.image = self.headImage;
        _headImageView4.contentMode = UIViewContentModeScaleToFill;
        _headImageView4.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_headImageView4 addGestureRecognizer:tap1];
    }
    return _headImageView4;
}


- (void)clickNoDataViewWith:(UIButton *)tap
{
    if (tap.tag == 1) {
        _page1 = 1;
        _table1.hidden = YES;
        [self createData1];
    } else if (tap.tag == 2) {
        _page2 = 1;
        _table2.hidden = YES;
        [self createData2];
    } else if (tap.tag == 3) {
        _page3 = 1;
        _table3.hidden = YES;
        [self createData3];
    } else if (tap.tag == 4) {
        _page4 = 1;
        _table4.hidden = YES;
        [self createData4];
    }
}

- (UITableView *)table1
{
    if (_table1 == nil) {
        self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43) style:UITableViewStylePlain];
        self.table1.delegate = self;
        self.table1.dataSource = self;
        self.table1.backgroundColor = RGBColor(235, 235, 235);
        self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
        if (self.reqJobType == JobTypeDynamic) {
            [self headImageView1];
            self.table1.tableHeaderView = _headImageView1;
//            self.table1.tableHeaderView = imagV;
        }
        [self.mainScrol addSubview:self.table1];

//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table1;
//        header.delegate = self;
//        
////        [header beginRefreshing];
//        self.header1 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table1;
//        footer.delegate = self;
//        self.footer1 = footer;
        
        __weak __typeof(self) weakSelf = self;
        _table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page1 = 1;
            [weakSelf createData1];
        }];
        
        _table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page1++;
            [weakSelf createData1];
        }];
        
        _noDataView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        _noDataView1.image = [UIImage imageNamed:@"noDataImage"];
        _noDataView1.contentMode = UIViewContentModeScaleAspectFill;
        _noDataView1.userInteractionEnabled = YES;
        UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
        buttn.tag = 1;
        [buttn addTarget:self action:@selector(clickNoDataViewWith:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataView1 addSubview:buttn];
        _noDataView1.hidden = YES;
        [_table1 addSubview:_noDataView1];
        
        _reqErrorView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
        _reqErrorView1.backgroundColor = RGBColor(235, 235, 235);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
        button.tag = 1;
        [button addTarget:self action:@selector(requireWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reqErrorView1 addSubview:button];
        [_table1 addSubview:_reqErrorView1];
        _reqErrorView1.hidden = YES;

    }
    
    return _table1;
}


- (UITableView *)table2
{
    if (_table2 == nil) {
        self.table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43) style:UITableViewStylePlain];
        self.table2.delegate = self;
        self.table2.dataSource = self;
        self.table2.backgroundColor = RGBColor(235, 235, 235);
        self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
        if (self.reqJobType == JobTypeDynamic) {
            [self headImageView2];
            self.table2.tableHeaderView = _headImageView2;
//            self.table2.tableHeaderView = imagV;
        }
        [self.mainScrol addSubview:self.table2];
        
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table2;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header2 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table2;
//        footer.delegate = self;
//        self.footer2 = footer;
        
        __weak __typeof(self) weakSelf = self;
        _table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page2 = 1;
            [weakSelf createData2];
        }];
        
        _table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page2++;
            [weakSelf createData2];
        }];
        _noDataView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        _noDataView2.image = [UIImage imageNamed:@"noDataImage"];
        _noDataView2.contentMode = UIViewContentModeScaleAspectFill;
        _noDataView2.userInteractionEnabled = YES;
        UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
        buttn.tag = 2;
        [buttn addTarget:self action:@selector(clickNoDataViewWith:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataView2 addSubview:buttn];
        _noDataView2.hidden = YES;
        [_table2 addSubview:_noDataView2];
        
        _reqErrorView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
        _reqErrorView2.backgroundColor = RGBColor(235, 235, 235);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2;
        [button addTarget:self action:@selector(requireWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reqErrorView2 addSubview:button];
        [_table2 addSubview:_reqErrorView2];
        _reqErrorView2.hidden = YES;

    }
    return _table2;
}
- (UITableView *)table3
{
    if (_table3 == nil) {
        self.table3 = [[UITableView alloc] initWithFrame:CGRectMake(2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43) style:UITableViewStylePlain];
        self.table3.delegate = self;
        self.table3.dataSource = self;
        self.table3.backgroundColor = RGBColor(235, 235, 235);
        self.table3.separatorStyle = UITableViewCellSeparatorStyleNone;
//        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
//        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
        if (self.reqJobType == JobTypeDynamic) {
            [self headImageView3];
            self.table3.tableHeaderView = _headImageView3;
        }
        [self.mainScrol addSubview:self.table3];
        
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table3;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header3 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table3;
//        footer.delegate = self;
//        self.footer3 = footer;
        
        __weak __typeof(self) weakSelf = self;
        _table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page3 = 1;
            [weakSelf createData3];
        }];
        
        _table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page3++;
            [weakSelf createData3];
        }];

        
        _noDataView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        _noDataView3.image = [UIImage imageNamed:@"noDataImage"];
        _noDataView3.contentMode = UIViewContentModeScaleAspectFill;
        _noDataView3.userInteractionEnabled = YES;
        UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
        buttn.tag = 3;
        [buttn addTarget:self action:@selector(clickNoDataViewWith:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataView3 addSubview:buttn];
        _noDataView3.hidden = YES;

        [_table3 addSubview:_noDataView3];
        
        _reqErrorView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
        _reqErrorView3.backgroundColor = RGBColor(235, 235, 235);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 3;
        [button addTarget:self action:@selector(requireWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reqErrorView3 addSubview:button];
        _reqErrorView3.hidden = YES;
        [_table3 addSubview:_reqErrorView3];


    }
    
    return _table3;
}
- (UITableView *)table4
{
    if (_table4 == nil) {
        self.table4 = [[UITableView alloc] initWithFrame:CGRectMake(3 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43) style:UITableViewStylePlain];
        self.table4.delegate = self;
        self.table4.dataSource = self;
        self.table4.backgroundColor = RGBColor(235, 235, 235);
        self.table4.separatorStyle = UITableViewCellSeparatorStyleNone;
//        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
//        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
        if (self.reqJobType == JobTypeDynamic) {
            [self headImageView4];
            self.table4.tableHeaderView = _headImageView4;
        }
        [self.mainScrol addSubview:self.table4];
        
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table4;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header4 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table4;
//        footer.delegate = self;
//        self.footer4 = footer;
        __weak __typeof(self) weakSelf = self;
        _table4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page4 = 1;
            [weakSelf createData4];
        }];
        
        _table4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page4++;
            [weakSelf createData4];
        }];
        
        _noDataView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        _noDataView4.image = [UIImage imageNamed:@"noDataImage"];
        _noDataView4.contentMode = UIViewContentModeScaleAspectFill;
        _noDataView4.userInteractionEnabled = YES;
        UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
        buttn.tag = 4;
        [buttn addTarget:self action:@selector(clickNoDataViewWith:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataView4 addSubview:buttn];
        _noDataView4.hidden = YES;
        [_table4 addSubview:_noDataView4];
        
        _reqErrorView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
        _reqErrorView4.backgroundColor = RGBColor(235, 235, 235);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 4;
        [button addTarget:self action:@selector(requireWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reqErrorView4 addSubview:button];
        _reqErrorView4.hidden = YES;
        [_table4 addSubview:_reqErrorView4];
    }
    
    return _table4;
}
//- (UITableView *)table5
//{
//    if (_table5 == nil) {
//        self.table5 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table5.delegate = self;
//        self.table5.dataSource = self;
//        self.table5.separatorStyle = UITableViewCellSeparatorStyleNone;
////        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
////        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
//        if (self.reqJobType == JobTypeDynamic) {
//            [self headImageView5];
//            self.table5.tableHeaderView = _headImageView5;
//        }
//        [self.mainScrol addSubview:self.table5];
//        
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table5;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header5 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table5;
//        footer.delegate = self;
//        self.footer5 = footer;
//        _noDataView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
//        _noDataView5.image = [UIImage imageNamed:@"noDataImage"];
//        _noDataView5.contentMode = UIViewContentModeScaleAspectFill;
//        _noDataView5.userInteractionEnabled = YES;
//        UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
//        buttn.tag = 5;
//        [buttn addTarget:self action:@selector(clickNoDataViewWith:) forControlEvents:UIControlEventTouchUpInside];
//        [_noDataView5 addSubview:buttn];
//        _noDataView5.hidden = YES;
//        [_table5 addSubview:_noDataView5];
//        
//        _reqErrorView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
//        _reqErrorView5.backgroundColor = RGBColor(235, 235, 235);
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = 5;
//        [button addTarget:self action:@selector(requireWithBtn:) forControlEvents:UIControlEventTouchUpInside];
//        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
//        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_reqErrorView5 addSubview:button];
//        _reqErrorView5.hidden = YES;
//        [_table5 addSubview:_reqErrorView5];
//
//    }
//    
//    return _table5;
//}
//- (UITableView *)table6
//{
//    if (_table6 == nil) {
//        self.table6 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 5, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table6.delegate = self;
//        self.table6.dataSource = self;
//        self.table6.separatorStyle = UITableViewCellSeparatorStyleNone;
////        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
////        imagV.image = [UIImage imageNamed:@"discover_2.jpg"];
//        if (self.reqJobType == JobTypeDynamic) {
//            [self headImageView6];
//            self.table6.tableHeaderView = _headImageView6;
//        }
//        [self.mainScrol addSubview:self.table6];
//        
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table6;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header6 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table6;
//        footer.delegate = self;
//        self.footer6 = footer;
//        _noDataView6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
//        _noDataView6.image = [UIImage imageNamed:@"noDataImage"];
//        _noDataView6.contentMode = UIViewContentModeScaleAspectFill;
//        _noDataView6.userInteractionEnabled = YES;
//        UIButton *buttn = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
//        buttn.tag = 6;
//        [buttn addTarget:self action:@selector(clickNoDataViewWith:) forControlEvents:UIControlEventTouchUpInside];
//        [_noDataView6 addSubview:buttn];
//        _noDataView6.hidden = YES;
//        [_table6 addSubview:_noDataView6];
//        
//        _reqErrorView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
//        _reqErrorView6.backgroundColor = RGBColor(235, 235, 235);
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = 6;
//        [button addTarget:self action:@selector(requireWithBtn:) forControlEvents:UIControlEventTouchUpInside];
//        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
//        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_reqErrorView6 addSubview:button];
//        _reqErrorView6.hidden = YES;
//        [_table6 addSubview:_reqErrorView6];
//
//    }
//    
//    return _table6;
//}

- (void)requireWithBtn:(UIButton *)sender
{
    if (sender.tag == 1) {
        NSLog(@"11111");
    } else if (sender.tag == 2) {
        NSLog(@"22222");
    } else if (sender.tag == 3) {
        NSLog(@"33333");
    } else if (sender.tag == 4) {
        NSLog(@"444444");
    }
//    else if (sender.tag == 5) {
//        NSLog(@"555555");
//    } else if (sender.tag == 6) {
//        NSLog(@"666666");
//    }
}

//释放刷新控件
- (void)dealloc
{
//    [self.header1 free];
//    [self.footer1 free];
//    [self.header2 free];
//    [self.footer2 free];
//    [self.header3 free];
//    [self.footer3 free];
//    [self.header4 free];
//    [self.footer4 free];
//    [self.header5 free];
//    [self.footer5 free];
//    [self.header6 free];
//    [self.footer6 free];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dynamicJump" object:nil];
    //注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
}


- (void)reloadBackGroundImage
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSDictionary *dic = @{@"action" : @"getbg",
                          @"userid" : userInfo[@"userid"]};
    NSLog(@"%@----%@",url,dic);
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
        NSLog(@"===json: %@",json);
        self.backInfo = json;
        [self table1];
        [self createData1];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}

//附近
- (void)createData1{
    NSLog(@"界面1");
    if (_page1 == 1) {
        [_data1 removeAllObjects];
        [_goodData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"state"] = @"1";
    params[@"speak_type"] = self.speak_type;

//    NSDictionary *dic = @{@"action":@"getSpeakionList",
//                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table1.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data1 addObjectsFromArray:arr];
        [_datas replaceObjectAtIndex:0 withObject:_data1];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData1 addObject:is_good];
        }
//        [self table1];
        _reqErrorView1.hidden = YES;
//        [_reqErrorView1 removeFromSuperview];
        if (_data1.count == 0) {
            _noDataView1.hidden = NO;
            _headImageView1.userInteractionEnabled = NO;
        } else {
            _noDataView1.hidden = YES;
            _headImageView1.userInteractionEnabled = YES;
        }
        [_table1.mj_header endRefreshing];
        [_table1.mj_footer endRefreshing];
        [self.table1 reloadData];
        if (arr.count == 0) {
//            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table1.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        _reqErrorView1.hidden = NO;
        [_table1.mj_header endRefreshing];
        [_table1.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

//关注
- (void)createData2{
    NSLog(@"界面2");
    if (_page2 == 1) {
        [_data2 removeAllObjects];
        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page2];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
//    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"state"] = @"3";
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table2.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data2 addObjectsFromArray:arr];
        [_datas replaceObjectAtIndex:1 withObject:_data2];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData2 addObject:is_good];
        }
        [self table2];
        _reqErrorView2.hidden = YES;
        if (_data2.count == 0) {
            _noDataView2.hidden = NO;
            _headImageView2.userInteractionEnabled = NO;
        } else {
            _noDataView2.hidden = YES;
            _headImageView2.userInteractionEnabled = YES;
        }
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        [self.table2 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table2.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        _reqErrorView2.hidden = NO;
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

//好友
- (void)createData3{
    NSLog(@"界面3");
    if (_page3 == 1) {
        [_data3 removeAllObjects];
        [_goodData3 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page3];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
//    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"state"] = @"2";
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"###%@",json);
        _table3.hidden = NO;
        NSArray *arr = json[@"list"];
        [_data3 addObjectsFromArray:arr];
        [_datas replaceObjectAtIndex:2 withObject:_data3];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData3 addObject:is_good];
        }
        [self table3];
        _reqErrorView3.hidden = YES;
        if (_data3.count == 0) {
            _noDataView3.hidden = NO;
            _headImageView3.userInteractionEnabled = NO;
        } else {
            _noDataView3.hidden = YES;
            _headImageView3.userInteractionEnabled = YES;
        }
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        [self.table3 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table3.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        _reqErrorView3.hidden = NO;
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

//我的
- (void)createData4{
    NSLog(@"界面4");
    if (_page4 == 1) {
        [_data4 removeAllObjects];
        [_goodData4 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page4];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"user_id"] = userInfo[@"userid"];
//    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"state"] = @"4";
    params[@"speak_type"] = self.speak_type;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"###%@",json);
        _table4.hidden = NO;
        NSArray *arr = json[@"list"];
        [_data4 addObjectsFromArray:arr];
        [_datas replaceObjectAtIndex:3 withObject:_data4];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData4 addObject:is_good];
        }
        [self table4];
        _reqErrorView4.hidden = YES;
        if (_data4.count == 0) {
            _noDataView4.hidden = NO;
            _headImageView4.userInteractionEnabled = NO;
        } else {
            _noDataView4.hidden = YES;
            _headImageView4.userInteractionEnabled = YES;
        }
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        [self.table4 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table4.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        _reqErrorView4.hidden = NO;
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

//- (void)createData5{
//    NSLog(@"界面5");
//    if (_page5 == 1) {
//        [_data5 removeAllObjects];
//        [_goodData5 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page5];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//
//    params[@"user_id"] = userInfo[@"userid"];
////    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"6";
//    params[@"speak_type"] = @"1";
//    
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
////        NSLog(@"###%@",json);
//        _table5.hidden = NO;
//        NSArray *arr = json[@"list"];
//        [_data5 addObjectsFromArray:arr];
//        [_datas replaceObjectAtIndex:4 withObject:_data5];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData5 addObject:is_good];
//        }
//        [self table5];
//        _reqErrorView5.hidden = YES;
//        if (_data5.count == 0) {
//            _noDataView5.hidden = NO;
//            _headImageView5.userInteractionEnabled = NO;
//        } else {
//            _noDataView5.hidden = YES;
//            _headImageView5.userInteractionEnabled = YES;
//        }
//        [self.header5 endRefreshing];
//        [self.footer5 endRefreshing];
//        [self.table5 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
//        _reqErrorView5.hidden = NO;
//        [self.header5 endRefreshing];
//        [self.footer5 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}
//
//- (void)createData6{
//    NSLog(@"界面6");
//    if (_page6 == 1) {
//        [_data6 removeAllObjects];
//        [_goodData6 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page6];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
////    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"4";
//    params[@"speak_type"] = @"1";
//    
//    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
//    //                          @"page" : page};
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"###%@",json);
//        _table6.hidden = NO;
//        NSArray *arr = json[@"list"];
//        [_data6 addObjectsFromArray:arr];
//        [_datas replaceObjectAtIndex:5 withObject:_data6];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData6 addObject:is_good];
//        }
//        [self table6];
//        _reqErrorView6.hidden = YES;
//        if (_data6.count == 0) {
//            _headImageView6.userInteractionEnabled = NO;
//            _noDataView6.hidden = NO;
//        } else {
//            _headImageView6.userInteractionEnabled = YES;
//            _noDataView6.hidden = YES;
//        }
//        [self.header6 endRefreshing];
//        [self.footer6 endRefreshing];
//        [self.table6 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
//        _reqErrorView6.hidden = NO;
//        [self.header6 endRefreshing];
//        [self.footer6 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}

- (void)createUI
{
    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107)];
    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - 107);
    self.mainScrol.pagingEnabled = YES;
    self.mainScrol.delegate = self;
    self.mainScrol.backgroundColor = RGBColor(235, 235, 235);
//    self.mainScrol.backgroundColor = [UIColor cyanColor];
    self.mainScrol.showsHorizontalScrollIndicator = NO;
    self.mainScrol.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrol];
    for (int i = 0; i<6; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        view.image = [UIImage imageNamed:@"backgroundImage"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self.mainScrol addSubview:view];
        
//        UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104)];
//        errorView.backgroundColor = RGBColor(235, 235, 235);
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, (SCREEN_HEIGHT - 104 - 20)/2, SCREEN_WIDTH, 20);
//        [button setTitle:@"获取数据失败，请点击重试..." forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [errorView addSubview:button];
//        [view addSubview:errorView];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray *data = _datas[self.currentPage];
    return data.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = _datas[self.currentPage];
    static NSString *cellId = kWorkCellId;
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WorkTableViewCell alloc] init];
        if (self.reqJobType == JobTypeDynamic) {
            cell.cellType = CellLayoutTypeSpecial;
        } else {
            cell.cellType = CellLayoutTypeNormal;
        }
        //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
        cell.type = WorkCellTypeNormal;
    }
    cell.isDetail = NO;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (data.count != 0) {
        NSDictionary *dicInfo = data[indexPath.row];
        [cell confineCellwithData:dicInfo];
        cell.dustbinBtn.tag = indexPath.row + 1;
        [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.attentionBtn.tag = indexPath.row + 1;
        [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.functionBtn.appendIndexPath = indexPath;
        [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconBtn.appendIndexPath = indexPath;
        [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        cell.nickName.appendIndexPath = indexPath;
        [cell.nickName addGestureRecognizer:tap];

        
    }
    return cell;

}

- (void)longPressToDo:(UITapGestureRecognizer *)tap
{
    WPNicknameLabel *nickName = (WPNicknameLabel *)tap.self.view;
//    NSLog(@"********%d",nickName.appendIndexPath.row);
    nickName.backgroundColor = RGB(226, 226, 226);
    [self performSelector:@selector(delayWithObj:) withObject:nickName afterDelay:0.2];
    NSDictionary *dic = _datas[self.currentPage][nickName.appendIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)delayWithObj:(WPNicknameLabel *)nickName
{
    nickName.backgroundColor = [UIColor whiteColor];
}

- (void)checkPersonalHomePage:(WPButton *)sender
{
    [self keyBoardDismiss];
    self.iconClickIndexPath = sender.appendIndexPath;
//    NSLog(@"***%ld",self.iconClickIndexPath.row);
    NSDictionary *dic = _datas[self.currentPage][_iconClickIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)checkPersonalPage:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)replyAction:(WPButton *)sender
{
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
    }
    
    UITableView *table;
    NSMutableArray *goodData;
    if (self.currentPage == 0) {
        table = _table1;
        goodData = _goodData1;
    } else if (self.currentPage == 1) {
        table = _table2;
        goodData = _goodData2;
    } else if (self.currentPage == 2) {
        table = _table3;
        goodData = _goodData3;
    } else if (self.currentPage == 3) {
        table = _table4;
        goodData = _goodData4;
    }
//    else if (self.currentPage == 4) {
//        table = _table5;
//        goodData = _goodData5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//        goodData = _goodData6;
//    }
    CGRect rectInTableView = [table rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    //    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    BOOL isFavour;
    NSString *is_good = goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
    if ([is_good isEqualToString:@"0"]) {
        isFavour = NO;
    } else {
        isFavour = YES;
    }
    [self.operationView showAtView:table rect:targetRect isFavour:isFavour];
    
}

- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        _operationView.rightType = WFRightButtonTypePraise;
        [_operationView updateImage];
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
    UITableView *table;
    NSMutableArray *goodData;
    NSMutableArray *data;
    if (self.currentPage == 0) {
        table = _table1;
        goodData = _goodData1;
        data = _data1;
    } else if (self.currentPage == 1) {
        table = _table2;
        goodData = _goodData2;
        data = _data2;
    } else if (self.currentPage == 2) {
        table = _table3;
        goodData = _goodData3;
        data = _data3;
    } else if (self.currentPage == 3) {
        table = _table4;
        goodData = _goodData4;
        data = _data4;
    }
//    else if (self.currentPage == 4) {
//        table = _table5;
//        goodData = _goodData5;
//        data = _data5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//        goodData = _goodData6;
//        data = _data6;
//    }
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    NSString *is_good = goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
//    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[_selectedIndexPath.row]];
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
//    if ([is_good isEqualToString:@"0"]) {
//        params[@"wp_speak_click_state"] = @"0";
//    } else {
//        params[@"wp_speak_click_state"] = @"1";
//    }
    params[@"wp_speak_click_state"] = @"1";
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        if ([is_good isEqualToString:@"0"]) {
//            count ++;
//            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
//            [_datas[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
            
        } else {
//            count --;
//            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
//            [_datas[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
        }
//        cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
//        [table reloadData];
        [self updateCommentAndPraiseCount];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    
    NSLog(@"点赞");
}

- (void)updateCommentAndPraiseCount
{
    UITableView *table;
    if (self.currentPage == 0) {
        table = _table1;
    } else if (self.currentPage == 1) {
        table = _table2;
    } else if (self.currentPage == 2) {
        table = _table3;
    } else if (self.currentPage == 3) {
        table = _table4;
    }
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getsum";
    params[@"speak_trends_id"] = _datas[self.currentPage][_selectedIndexPath.row][@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    NSLog(@"######%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"*****%@",json);
        if ([json[@"state"] integerValue] == 0) {
            cell.commentLabel.text = json[@"discuss"];
            cell.praiseLabel.text = json[@"click"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.debugDescription);
    }];

}

- (void)updateCommentCount{
    NSMutableArray *data = _datas[self.currentPage];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:data[_selectedIndexPath.row]];
    NSInteger count = [dic[@"speak_trends_person"] integerValue];
    count++;
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_trends_person"];
    [data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
    UITableView *table;
    if (self.currentPage == 0) {
        table = _table1;
    } else if (self.currentPage == 1) {
        table = _table2;
    } else if (self.currentPage == 2) {
        table = _table3;
    } else if (self.currentPage == 3) {
        table = _table4;
    }
//    else if (self.currentPage == 4) {
//        table = _table5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//    }
    [table reloadData];
}

//评论
- (void)replyMessage:(WPButton *)sender{
    UITableView *table;
    NSMutableArray *goodData;
    NSMutableArray *data;
    if (self.currentPage == 0) {
        table = _table1;
        goodData = _goodData1;
        data = _data1;
    } else if (self.currentPage == 1) {
        table = _table2;
        goodData = _goodData2;
        data = _data2;
    } else if (self.currentPage == 2) {
        table = _table3;
        goodData = _goodData3;
        data = _data3;
    } else if (self.currentPage == 3) {
        table = _table4;
        goodData = _goodData4;
        data = _data4;
    }
//     else if (self.currentPage == 4) {
//        table = _table5;
//        goodData = _goodData5;
//        data = _data5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//        goodData = _goodData6;
//        data = _data6;
//    }
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    self.chatInputView.hidden = NO;
    self.isEditeNow = YES;
    [self.chatInputView.textView becomeFirstResponder];
    NSLog(@"评论");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSMutableArray *data = _datas[self.currentPage];
    if (data.count == 0) {
        return 0;
    }

    return 81;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *data = _datas[self.currentPage];
    if (data.count == 0) {
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 81)];
    headView.backgroundColor = RGB(235, 235, 235);
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = RGB(178, 178, 178);
    [headView addSubview:line1];
    NSArray *titles = @[@"全部",@"人气",@"话题",@"正能量",@"职场吐槽",@"管理智慧",@"创业心得",@"职场心理",@"情感心语"];
    NSArray *images = @[@"dynamic_all",@"dynamic_hot",@"dynamic_diary",@"dynamic_enery",@"dynamic_spit",@"dynamic_manager",@"dynamic_chuang",@"dynamic_psychic",@"dynamic_emotion"];
    ListView *list = [[ListView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 80)];
    list.titles = titles;
    list.images = images;
    list.selectIndex = self.selectIndex;
    [list makeContain];
    list.buttonClick = ^(NSInteger index,NSString *title){
//        NSLog(@"index: %d ,title: %@",index,title);
        if (self.selectIndex == index) {
            return ;
        }
        [self.mainScrol setContentOffset:CGPointMake(0, 0) animated:NO];
        self.currentPage = 0;
        self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , 40, SCREEN_WIDTH/4, 3);
//        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self refreshWith:index];
//        [self btnClickWithIndex:0];
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.selectIndex = index;

    };
    [headView addSubview:list];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80.5, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = RGB(178, 178, 178);
    [headView addSubview:line2];
    return headView;
}

- (void)refreshWith:(NSInteger)index
{
    if (index == 0) {
        self.speak_type = @"9";
    } else if (index == 1) {
        self.speak_type = @"10";
    } else if (index == 2) {
        self.speak_type = @"1";
    } else if (index == 3) {
        self.speak_type = @"3";
    } else if (index == 4) {
        self.speak_type = @"4";
    } else if (index == 5) {
        self.speak_type = @"6";
    } else if (index == 6) {
        self.speak_type = @"7";
    } else if (index == 7) {
        self.speak_type = @"5";
    } else if (index == 8) {
        self.speak_type = @"8";
    }
    
    NSLog(@"^^^^^%@",self.speak_type);
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    
//    _table1.scrollsToTop = YES;
//    _table2.scrollsToTop = YES;
//    _table3.scrollsToTop = YES;
//    _table4.scrollsToTop = YES;
    _table1.contentOffset = CGPointMake(0, 0);
    _table2.contentOffset = CGPointMake(0, 0);
    _table3.contentOffset = CGPointMake(0, 0);
    _table4.contentOffset = CGPointMake(0, 0);
    [self createData1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = _datas[self.currentPage];
    NSDictionary *dic;
    if (data.count>0) {
        dic = data[indexPath.row];
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
    
    CGFloat descriptionLabelHeight;//内容的显示高度
    if ([dic[@"speak_comment_content"] length] == 0) {
        descriptionLabelHeight = 0;
    } else {
        descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:14].height;
        if (descriptionLabelHeight > 16.702 *6) {
            descriptionLabelHeight = 16.702 *6;
            self.isMore = YES;
        } else {
            self.isMore = NO;
            descriptionLabelHeight = descriptionLabelHeight;
        }
    }
    CGFloat photosHeight;//定义照片的高度
    
//    if (self.reqJobType == JobTypeDynamic) { //职场动态
//        if (videoCount == 1) {
//            NSLog(@"controller 有视频");
//            photosHeight = 0.625*SCREEN_WIDTH;
//        } else {
//            if (count == 0) {
//                photosHeight = 0;
//            } else if (count == 1) {
//                NSString *url = [IPADDRESS stringByAppendingString:dic[@"original_photos"][0][@"media_address"]];
//                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//                CGFloat width = image.size.width;
//                CGFloat height = image.size.height;
//                if (width >height) {
//                    CGFloat scaleOne = width/200;
//                    width = 200;
//                    height = height/scaleOne;
//                } else {
//                    CGFloat scaleTwo = height/200;
//                    height = 200;
//                    width = width/scaleTwo;
//                }
//                
//                photosHeight = height;
//                
//            } else if (count == 2 || count == 3) {
//                photosHeight = 76;
//            } else if (count >= 4 && count <= 6) {
//                photosHeight = 76*2 + 3;
//            } else {
//                photosHeight = 76*3 + 6;
//            }
//        }
//    } else {  //除职场动态外的其他模块
//        if (videoCount == 1) {
//            NSLog(@"controller 有视频");
//            photosHeight = 76;
//        } else {
//            if (count == 0) {
//                photosHeight = 0;
//            } else if (count >= 1 && count <= 3) {
//                photosHeight = 76;
//            } else if (count >= 4 && count <= 6) {
//                photosHeight = 76*2 + 3;
//            } else {
//                photosHeight = 76*3 + 6;
//            }
//        }
//    }
    if (videoCount == 1) {
        NSLog(@"controller 有视频");
        photosHeight = 140;
    } else {
        if (count == 0) {
            photosHeight = 0;
        } else if (count >= 1 && count <= 3) {
            photosHeight = 76;
        } else if (count >= 4 && count <= 6) {
            photosHeight = 76*2 + 3;
        } else {
            photosHeight = 76*3 + 6;
        }
    }
    
    CGFloat cellHeight;
    if ([dic[@"address"] length] == 0) {
        if ([dic[@"original_photos"] count] == 0) {
            if (self.isMore) {
                cellHeight = 50 + 10 + descriptionLabelHeight + 10 + 25 + 26.702 + 6;
            } else {
                cellHeight = 50 + 10 + descriptionLabelHeight + 10 + 25 + 6;
            }
        } else {
            if ([dic[@"speak_comment_content"] length] == 0) {
                cellHeight = 50 + 10 + photosHeight + 10 + 25 + 6;
            } else {
                if (self.isMore) {
                    cellHeight = 50 + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + 25 + 26.702 + 6;
                } else {
                    cellHeight = 50 + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + 25 + 6;
                }
            }
        }
    } else {
        if ([dic[@"original_photos"] count] == 0) {
            if (self.isMore) {
                cellHeight = 50 + 10 + descriptionLabelHeight + 10 + 15 + 10 + 25 + 26.702 + 6;
            } else {
                cellHeight = 50 + 10 + descriptionLabelHeight + 10 + 15 + 10 + 25 + 6;
            }
        } else {
            if ([dic[@"speak_comment_content"] length] == 0) {
                cellHeight = 50 + 10 + photosHeight + 10 + 15 + 10 + 25 + 6;
            } else {
                if (self.isMore) {
                    cellHeight = 50 + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + 25 + 26.702 + 6;
                } else {
                    cellHeight = 50 + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + 25 + 6;
                }
            }
        }
    }
    
    return cellHeight;

}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-68, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

//垃圾桶点击事件
- (void)dustbinClick:(UIButton *)btn{
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[btn superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[btn superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.currentPage == 0) {
        NSIndexPath * path = [self.table1 indexPathForCell:cell];
        dic = self.data1[path.row];
    } else if (self.currentPage == 1) {
        NSIndexPath * path = [self.table2 indexPathForCell:cell];
        dic = self.data2[path.row];
    }else if (self.currentPage == 2) {
        NSIndexPath * path = [self.table3 indexPathForCell:cell];
        dic = self.data3[path.row];
    }else if (self.currentPage == 3) {
        NSIndexPath * path = [self.table4 indexPathForCell:cell];
        dic = self.data4[path.row];
    }else if (self.currentPage == 4) {
        NSIndexPath * path = [self.table5 indexPathForCell:cell];
        dic = self.data5[path.row];
    }else if (self.currentPage == 5) {
        NSIndexPath * path = [self.table6 indexPathForCell:cell];
        dic = self.data6[path.row];
    }


//    NSLog(@"####%@",url);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteDynamic";
    params[@"speakid"] = [NSString stringWithFormat:@"%@",dic[@"sid"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
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
    
    self.deletParams = params;
    self.deletIndex = btn.tag - 1;
    
//    NSLog(@"****%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条说说吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
//    [self.data1 removeObjectAtIndex:btn.tag - 1];
//    [self.table1 reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"%d",buttonIndex);
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else {
            UITableView *table;
            if (self.currentPage == 0) {
                table = _table1;
            } else if (self.currentPage == 1) {
                table = _table2;
            } else if (self.currentPage == 2) {
                table = _table3;
            } else if (self.currentPage == 3) {
                table = _table4;
            }
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
//                NSLog(@"%@---%@",json,json[@"info"]);
                if ([json[@"status"] integerValue] == 0) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    [self.datas[self.currentPage] removeObjectAtIndex:self.deletIndex];
                    [table reloadData];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];

        }
    }
}

- (void)attentionClick:(UIButton *)sender
{
    NSLog(@"关注");
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[sender superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[sender superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
    UITableView *table;
    if (self.currentPage == 0) {
        NSIndexPath * path = [self.table1 indexPathForCell:cell];
        dic = self.data1[path.row];
        table = _table1;
    } else if (self.currentPage == 1) {
        NSIndexPath * path = [self.table2 indexPathForCell:cell];
        dic = self.data2[path.row];
        table = _table2;
    }else if (self.currentPage == 2) {
        NSIndexPath * path = [self.table3 indexPathForCell:cell];
        dic = self.data3[path.row];
        table = _table3;
    }else if (self.currentPage == 3) {
        NSIndexPath * path = [self.table4 indexPathForCell:cell];
        dic = self.data4[path.row];
        table = _table4;
    }else if (self.currentPage == 4) {
        NSIndexPath * path = [self.table5 indexPathForCell:cell];
        dic = self.data5[path.row];
        table = _table5;
    }else if (self.currentPage == 5) {
        NSIndexPath * path = [self.table6 indexPathForCell:cell];
        dic = self.data6[path.row];
        table = _table6;
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;

    params[@"user_id"] = userInfo[@"userid"];
//    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = dic[@"user_id"];
    params[@"by_nick_name"] = dic[@"nick_name"];
//    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
//    if ([attention_state isEqualToString:@"2"] || [attention_state isEqualToString:@"0"]) {
//        params[@"attention_state"] = @"2";
//    } else {
//        params[@"attention_state"] = @"3";
//    }
    
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    
    NSString *nick_name = dic[@"nick_name"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@===%@",json[@"info"],json);
        if ([json[@"status"] integerValue] == 1) {
            NSMutableArray *data = _datas[self.currentPage];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dict = data[i];
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
                    [data replaceObjectAtIndex:i withObject:newDic];
                }
            }
            [table reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];

}

- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 107, SCREEN_WIDTH, 43.5)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    //    self.bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 104, SCREEN_WIDTH , 41)];
    //    self.bottomScroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, 40);
    //    //    self.bottomScroll.backgroundColor = [UIColor yellowColor];
    //    self.bottomScroll.alwaysBounceVertical = NO;
    //    self.bottomScroll.alwaysBounceHorizontal = YES;
    //    self.bottomScroll.pagingEnabled = YES;
    //    self.bottomScroll.showsHorizontalScrollIndicator = NO;
    //    self.bottomScroll.showsVerticalScrollIndicator = NO;
    //    self.bottomScroll.delegate = self;
    //    //    self.bottomScroll.layer.borderColor = RGBColor(226, 226, 226).CGColor;
    //    //    self.bottomScroll.layer.borderWidth = 1.0;
    //    [self.view addSubview:self.bottomScroll];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 107, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/4, 3)];
    self.line.backgroundColor = RGBColor(10, 110, 210);
    [backView addSubview:self.line];
    
    CGFloat linwWidth = 0.5;
    CGFloat btnWidth = (SCREEN_WIDTH - 3)/4;
    NSArray *titles = @[@"最新",@"关注",@"好友",@"我的"];
    for (int i = 0; i<[titles count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth + linwWidth)*i, 0, btnWidth, 43)];
        button.tag = i+1;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if (i != 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), 14, linwWidth, 15)];
            line.backgroundColor = RGBColor(178, 178, 178);
            [backView addSubview:line];
        }
        
        if (i == 0) {
            button.selected = YES;
            self.button1 = button;
        } else if (i == 1) {
            self.button2 = button;
        } else if (i == 2) {
            self.button3 = button;
        } else if (i == 3) {
            self.button4 = button;
        }
    }

}

//点击cell跳转到详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_operationView dismiss];
    UITableView *table;
    if (self.currentPage == 0) {
        table = _table1;
    } else if (self.currentPage == 1) {
        table = _table2;
    } else if (self.currentPage == 2) {
        table = _table3;
    } else if (self.currentPage == 3) {
        table = _table4;
    } else if (self.currentPage == 4) {
        table = _table5;
    } else if (self.currentPage == 5) {
        table = _table6;
    }
    
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
//    self.chatInputView = nil;
//    if (self.isNeedDelloc >0) {
//        [self needDealloc];
//        self.isNeedDelloc --;
//    }
    
//    WPDetailControllerThree *detail = [[WPDetailControllerThree alloc] init];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
    } else {
        WPJobDetailViewController *detail = [[WPJobDetailViewController alloc] init];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_datas[self.currentPage][indexPath.row]];
        //    detail.userInfo = dic;
        detail.info = dic;
        if (self.reqJobType == JobTypeDynamic) {
            detail.type = NewDetailTypeDynamic;
        } else if (self.reqJobType == JobTypePositiveEnergy) {
            detail.type = NewDetailTypeEnergy;
        } else if (self.reqJobType == JobTypeSpit) {
            detail.type = NewDetailTypeSpit;
        } else if (self.reqJobType == JobTypePsychology) {
            detail.type = NewDetailTypePsychology;
        } else if (self.reqJobType == JobTypeManage) {
            detail.type = NewDetailTypeManage;
        } else if (self.reqJobType == JobTypePoineering) {
            detail.type = NewDetailTypePoineering;
        } else if (self.reqJobType == JobTypeEmotion) {
            detail.type = NewDetailTypeEmotion;
        }
        detail.is_good = [_goodDatas[self.currentPage][indexPath.row] boolValue];
        [self.navigationController pushViewController:detail animated:YES];
    }
    

}

//按钮点击事件
- (void)btnClick:(UIButton *)sender
{
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
//    self.chatInputView = nil;
//    if (self.isNeedDelloc > 0) {
//        [self needDealloc];
//        self.isNeedDelloc --;
//    }
    
    self.currentPage = sender.tag - 1;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , 40, SCREEN_WIDTH/4, 3);
        }
    }];
    
    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
//    [self.mainScrol setContentOffset:CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0) animated:YES];
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData1];
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData2];
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        [self createData3];
        
    } else if (sender.tag == 4) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        [self createData4];
        
    }
    
}

- (void)keyBoardDismiss
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    self.isEditeNow = NO;
}

- (void)buttonMenu
{
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
//    CHTumblrMenuView* menuView = [[CHTumblrMenuView alloc] init];
//    [menuView addMenuItemWithTitle:@"写写"
//                           andIcon:[UIImage imageNamed:@"menu_write"]
//                  andSelectedBlock:^{ 
////                      WPWriteController* writeController = [[WPWriteController alloc] init];
////                      [self.navigationController pushViewController:writeController animated:YES];
//                      WriteViewController *write = [[WriteViewController alloc] init];
//                      write.type = WriteTypeNormal;
//                      write.myTitle = @"写写";
//                      write.comment_type = @"1";
//                      [self.navigationController pushViewController:write animated:YES];
//
//                  }];
//    [menuView addMenuItemWithTitle:@"晒晒"
//                           andIcon:[UIImage imageNamed:@"menu_picture"]
//                  andSelectedBlock:^{
//                      NSLog(@"Photo menu_picture");
//                      MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
//                      // 默认显示相册里面的内容SavePhotos
//                      pickerVc.status = PickerViewShowStatusCameraRoll;
//                      pickerVc.minCount = 9;
////                      [pickerVc show];
//                      [self presentViewController:pickerVc animated:YES completion:NULL];
//                      __weak typeof(self) weakSelf = self;
//                      pickerVc.callBack = ^(NSArray *assets){
//                          WriteViewController *write = [[WriteViewController alloc] init];
//                          write.type = WriteTypeBask;
//                          write.myTitle = @"晒晒";
//                          [write.assets addObjectsFromArray:assets];
//                          write.comment_type = @"1";
//                          [weakSelf.navigationController pushViewController:write animated:YES];
//                      };
//
//                  }];
//    [menuView addMenuItemWithTitle:@"拍拍"
//                           andIcon:[UIImage imageNamed:@"menu_photo"]
//                  andSelectedBlock:^{
//                      NSLog(@"Quote menu_photo");
//                      self.picker=[[UIImagePickerController alloc]init];
//                      //判读相机是否可以启动
//                      if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
//                          _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//                      }
//                      _picker.delegate=self;
//                      [self presentViewController:_picker animated:YES completion:nil];
//                      
//                  }];
//    [menuView addMenuItemWithTitle:@"视频"
//                           andIcon:[UIImage imageNamed:@"menu_vedio"]
//                  andSelectedBlock:^{
//                      NSLog(@"Link menu_vedio");
//                      DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
//                      tackVedio.delegate = self;
//                      tackVedio.takeVideoDelegate = self;
//                      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//                      [self.navigationController presentViewController:nav animated:YES completion:nil];
//                      
//                  }];
//    [menuView addMenuItemWithTitle:@"模板"
//                           andIcon:[UIImage imageNamed:@"menu_template"]
//                  andSelectedBlock:^{
//                      NSLog(@"Chat menu_template");
//                      
//                  }];
//    [menuView addMenuItemWithTitle:@"更多"
//                           andIcon:[UIImage imageNamed:@"menu_more"]
//                  andSelectedBlock:^{
//                      NSLog(@"Video menu_more");
//                      
//                  }];
//    
//    [menuView show];
    WriteViewController *write = [[WriteViewController alloc] init];
    write.refreshData = ^(NSString *topic){
        NSMutableArray *data = _datas[_currentPage];
        [data removeAllObjects];
        if (_currentPage == 0) {
            _page1 = 1;
            [self createData1];
        } else if (_currentPage == 1) {
            _page2 = 1;
            [self createData2];
        } else if (_currentPage == 2) {
            _page3 = 1;
            [self createData3];
        } else if (_currentPage == 3) {
            _page4 = 1;
            [self createData4];
        }
    };
    write.myTitle = @"创建";
//    write.comment_type = @"1";
    write.is_dynamic = YES;
    [self.navigationController pushViewController:write animated:YES];
}

- (void)sendBackVideoWith:(NSArray *)array{
//    WriteViewController *write = [[WriteViewController alloc] init];
//    write.type = WriteTypeVedio;
//    write.myTitle = @"视频";
//    [write.assets addObjectsFromArray:array];
//    write.comment_type = @"1";
//    write.videoType = 1;
//    [self.navigationController pushViewController:write animated:YES];
}

- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
//    NSLog(@"******%@",filePaht);
//    WriteViewController *write = [[WriteViewController alloc] init];
//    write.type = WriteTypeVedio;
//    write.myTitle = @"视频";
//    write.videofilePath = filePaht;
//    write.videoLength = length;
//    write.comment_type = @"1";
//    write.videoType = 2;
//    [self.navigationController pushViewController:write animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSMutableArray *images = [NSMutableArray arrayWithObjects:image, nil];
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    if ([picker isEqual:_picker]) {
        WriteViewController *write = [[WriteViewController alloc] init];
        write.type = WriteTypeBask;
        write.myTitle = @"拍拍";
        //    [write.assets addObjectsFromArray:images];
//        [write.assets addObject:image];
//        write.comment_type = @"1";
        [self.navigationController pushViewController:write animated:YES];
    } else if ([picker isEqual:_picker2]) {
        UIImage* image2=[info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *newImage = [[self class] scaleImage:image2 toWidth:SCREEN_WIDTH toHeight:self.headViewHeight];
        NSLog(@"%f----%f",newImage.size.width,newImage.size.height);
        _headImage = newImage;
        [self updateHeadImageWith:newImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)updateHeadImageWith:(UIImage *)headImage{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    HeadImage *head = [[HeadImage alloc] init];
//    head.headImage = headImage;
//    [user setObject:head forKey:@"headImage"];
    [[self class] saveImage:headImage withName:headImageName];
//    WPShareModel *model = [WPShareModel sharedModel];
//    model.headImage = headImage;
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
        NSLog(@"*****%@",dict);
        if ([dict[@"status"] integerValue] == 1) {
            _headImageView1.image = _headImage;
            _headImageView2.image = _headImage;
            _headImageView3.image = _headImage;
            _headImageView4.image = _headImage;
            _headImageView5.image = _headImage;
            _headImageView6.image = _headImage;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}

- (void)updateImageWith:(UIImage *)image
{
    _headImageView1.image = image;
    _headImageView2.image = image;
    _headImageView3.image = image;
    _headImageView4.image = image;
    _headImageView5.image = image;
    _headImageView6.image = image;

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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"点击");
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_operationView dismiss];
    UITableView *table;
    if (self.currentPage == 0) {
        table = _table1;
    } else if (self.currentPage == 1) {
        table = _table2;
    } else if (self.currentPage == 2) {
        table = _table3;
    } else if (self.currentPage == 3) {
        table = _table4;
    } else if (self.currentPage == 4) {
        table = _table5;
    } else if (self.currentPage == 5) {
        table = _table6;
    }
    
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
//    self.chatInputView = nil;
//    if (self.isNeedDelloc > 0) {
//        [self needDealloc];
//        self.isNeedDelloc --;
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    if ([scrollView isEqual:self.mainScrol]) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
//        NSLog(@"*****%d",index);
        [self btnClickWithIndex:index];
    }
    
}

- (void)btnClickWithIndex:(NSInteger)index
{
    self.currentPage = index;
        [UIView animateWithDuration:0.3 animations:^{
    if (self.currentPage == 3) {
        self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
    } else {
        self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , 40, SCREEN_WIDTH/4, 3);
    }
        }];
    
    if (index == 0) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData1];
    } else if (index == 1) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData2];
        
    } else if (index == 2) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        [self createData3];
        
    } else if (index == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        [self createData4];
        
    }
    
}

#pragma mark - 关于键盘的输入以及语音

//- (void)commentWithInfo:(NSDictionary *)dic{
//    NSLog(@"我是谁");
//    [self chatInputView];
//    //    self.chatInputView.hidden = NO;
//    [self.chatInputView.textView becomeFirstResponder];
//}

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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkPersonalPage:)
//                                                 name:@"dynamicJump"
//                                               object:nil];
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
//        [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak WPJobViewController* weakSelf = self;
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

//- (JSMessageInputView *)chatInputView{
//    if (_chatInputView == nil) {
//        NSLog(@"创建");
//        CGRect inputFrame = CGRectMake(0, SCREEN_HEIGHT - 44.0f - 64.f,SCREEN_WIDTH,44.0f);
//        self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
//        [self.chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
//        [self.view addSubview:self.chatInputView];
//        [self.chatInputView.emotionbutton addTarget:self
//                                             action:@selector(showEmotions:)
//                                   forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.chatInputView.showUtilitysbutton addTarget:self
//                                                  action:@selector(showUtilitys:)
//                                        forControlEvents:UIControlEventTouchDown];
//        
//        [self.chatInputView.voiceButton addTarget:self
//                                           action:@selector(p_clickThRecordButton:)
//                                 forControlEvents:UIControlEventTouchUpInside];
//        [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
//        _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
//        [_recordingView setHidden:YES];
//        [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
//        [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//        //        self.chatInputView.hidden = YES;
//        
//    }
//    return _chatInputView;
//}

//评论
- (void)commentClick:(UIButton *)sender
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"*****%@",self.chatInputView.textView.text);
    NSMutableArray *data = _datas[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = data[_selectedIndexPath.row];
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
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            [self updateCommentCount];
            [self updateCommentAndPraiseCount];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
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
//    NSMutableArray *data = _datas[self.currentPage];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *dic = data[_selectedIndexPath.row];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = dic[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
////    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"by_nick_name"] = dic[@"nick_name"];
////    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    params[@"speak_reply"] = @"0";
//    NSData *audioData = [NSData dataWithContentsOfFile:file];
////    NSLog(@"****%@",params);
////    NSLog(@"===%@",audioData);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
////    NSLog(@"####%@",url);
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:audioData name:@"speak_comment_content" fileName:@"speak_comment_content.mp3" mimeType:@"audio/mpeg3"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*****%@",dict[@"info"]);
//        if ([dict[@"status"] integerValue] == 1) {
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////            [alert show];
////            [self updateCommentCount];
//            [self updateCommentAndPraiseCount];
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    [self.chatInputView willBeginInput];
//    _chatInputView.hidden = YES;
//    self.isEditeNow = NO;
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
    NSMutableArray *data = _datas[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = data[_selectedIndexPath.row];
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
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            [self updateCommentCount];
            [self updateCommentAndPraiseCount];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    [self keyBoardDismiss];
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
