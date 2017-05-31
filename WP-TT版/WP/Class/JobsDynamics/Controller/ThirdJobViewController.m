//
//  ThirdJobViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/1/20.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈第五版

#import "ThirdJobViewController.h"
#import "Masonry.h"
#import "WPSelectButton.h"
#import "RSButtonMenu.h"
#import "WorkTableViewCell.h"
#import "ShareDetailController.h"

#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"

#import "WriteViewController.h"
#import "IQKeyboardManager.h"
#import "ShareEditeViewController.h"
#import "NewDetailViewController.h"
#import "NewHomePageViewController.h"

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

@interface ThirdJobViewController ()<UITableViewDataSource,UITableViewDelegate,RSButtonMenuDelegate>

@property (nonatomic, strong) UIView *headView;       /**< 筛选框 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;
@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) RSButtonMenu *buttonMenu2;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,assign) NSUInteger index1;
@property (nonatomic,assign) NSUInteger index2;
@property (nonatomic,strong) NSString *speak_type; //说说类型
@property (nonatomic,strong) NSString *state;      //说说的状态
@property (nonatomic,assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,assign) BOOL isMore;            //是否有显示更多
@property (nonatomic,assign) BOOL isEditeNow;            //是否有显示更多
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) NSMutableArray *buttons;
@property (assign, nonatomic) CGFloat historyY;

@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数
@property (nonatomic,assign) NSInteger deletIndex;               //所要删除说说的位置


- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;

@end

@implementation ThirdJobViewController
{
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    DDBottomShowComponent _bottomShowComponent;
    UIButton *_recordButton;
    float _inputViewY;
    NSString* _currentInputContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.index1 = 0;
    self.index2 = 0;
    self.page = 1;
    self.state = @"1";
    self.speak_type = @"0";
    self.isMore = NO;
    self.dataSource = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    [self initNav];
    [self headView];
    [self.tableView.mj_header beginRefreshing];
//    [self tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToShareDetailNotification:) name:@"shareJump" object:nil];
    [self notificationCenter];
    [self initialInput];
    
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ThirdJobViewController class]];
    //[[IQKeyboardManager sharedManager] disableInViewControllerClass:[ThirdJobViewController class]];
}

- (void)jumpToShareDetailNotification:(NSNotification *)notification
{
//    NSLog(@"%@",notification.userInfo[@"url"]);
    ShareDetailController *detail = [[ShareDetailController alloc] init];
    detail.url = notification.userInfo[@"url"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareJump" object:nil];

}

- (void)initNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"smll_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
    WriteViewController *write = [[WriteViewController alloc] init];
    write.is_dynamic = YES;
    [self.navigationController pushViewController:write animated:YES];
}

- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [UIView new];
//        _headView.layer.borderColor = RGB(178, 178, 178).CGColor;
//        _headView.layer.borderWidth = 0.5;
        _headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(kHEIGHT(32)));
        }];
        
        UIView *ledgement = [UIView new];
        ledgement.backgroundColor = RGB(178, 178, 178);
        [_headView addSubview:ledgement];
        [ledgement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom).offset(-0.5);
            make.left.right.equalTo(_headView);
            make.height.equalTo(@(0.5));
        }];
        
        CGFloat width = SCREEN_WIDTH/2;
        NSArray *titles = @[@"最新",@"全部"];
        for (int i=0; i<titles.count; i++) {
            WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, 0, width, kHEIGHT(32))];
            //        btn.title.text = titles[i];
            [btn setLabelText:titles[i]];
            btn.image.image = [UIImage imageNamed:@"arrow_down"];
            
            [_headView addSubview:btn];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width*i, 0, width, kHEIGHT(32));
            button.tag = 10 + i;
            [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:button];
            [_headView addSubview:button];
            
            btn.isSelected = button.isSelected;
            if (i != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, (kHEIGHT(32) - 15)/2, 0.5, 15)];
                line.backgroundColor = RGB(226, 226, 226);
                [_headView addSubview:line];
            }
            
            if (i==0) {
                self.button5 = btn;
            } else if (i==1) {
                self.button6 = btn;
            }
        }

    }
    
    return _headView;
}

#pragma 筛选框按钮点击事件
- (void)selectBtnClick:(UIButton *)sender
{
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    NSArray *type = @[@"全部话题",@"人气排行",@"话题",@"匿名吐槽",@"职场八卦",@"上班族",@"正能量",@"心理学",@"工作狂",@"创业心得",@"老板心得",@"管理智慧",@"求职宝典",@"找工作",@"交友",@"在路上",@"早安心语",@"情感心语"];
    NSArray *time = @[@"最新动态",@"好友圈动态",@"陌生人动态",@"我的动态"];
    for (int i = 0; i<type.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = type[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [typeArr addObject:model];
    }
    
    for (int i = 0; i<time.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = time[i];
        model.industryID = [NSString stringWithFormat:@"%d",i + 1];
        [timeArr addObject:model];
    }
    
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    if (sender.tag == 10) {
        if (!sender.isSelected) {
            [self.buttonMenu1 setLocalType:timeArr andSelectIndex:self.index1];
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
            [self.buttonMenu2 setNewLocalData:typeArr andSelectIndex:self.index2];
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.dataSource removeAllObjects];
//                [self.goodData1 removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
//                for (NSDictionary *dic in datas) {
//                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//                    [_goodData1 addObject:is_good];
//                }
                [_tableView reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_tableView.mj_header endRefreshing];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
//                    for (NSDictionary *dic in datas) {
//                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//                        [_goodData1 addObject:is_good];
//                    }
                }
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
                _page--;
            }];
            [_tableView.mj_footer endRefreshing];
        }];

    }
    
    return _tableView;
}

#pragma mark - 封装网络请求
- (void)requestWithPageIndex:(NSInteger)page andIsNear:(BOOL)isNear Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    if ([self.state isEqualToString:@"1"]) {
//    params[@"longitude"] = [user objectForKey:@"longitude"];
//    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"***%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}

- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
//        _backView1 = [UIView new];
//        _backView1.backgroundColor = RGBA(0, 0, 0, 0.5);
//        _backView1.backgroundColor = [UIColor redColor];
//        [_backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headView.mas_bottom);
//            make.left.right.bottom.equalTo(self.view);
//        }];
//        _buttonMenu1 = [RSButtonMenu new];
        _buttonMenu1.delegate = self;
//        _buttonMenu1.backgroundColor = [UIColor cyanColor];
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:_backView1];
        [_backView1 addSubview:_buttonMenu1];
//        [_buttonMenu1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headView.mas_bottom);
//            make.left.right.bottom.equalTo(self.view);
////            make.bottom.equalTo(self.view.mas_bottom);
//        }];
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
//        _backView2 = [UIView new];
//        _backView2.backgroundColor = RGBA(0, 0, 0, 0.5);
        //        _backView1.backgroundColor = [UIColor redColor];
//        [_backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headView.mas_bottom);
//            make.left.right.bottom.equalTo(self.view);
//        }];
//        _buttonMenu2 = [RSButtonMenu new];
        _buttonMenu2.delegate = self;
        //        _buttonMenu1.backgroundColor = [UIColor cyanColor];
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:_backView2];
        [_backView2 addSubview:_buttonMenu2];
//        [_buttonMenu2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headView.mas_bottom);
//            make.left.right.bottom.equalTo(self.view);
//            //            make.bottom.equalTo(self.view.mas_bottom);
//        }];
        __weak typeof(self) unself = self;
        _buttonMenu2.touchHide = ^(){
                        [unself hidden];
        };
        
    }
    return _buttonMenu2;
}


- (void)RSButtonMenuDelegate:(IndustryModel *)model selectMenu:(RSButtonMenu *)menu
{
    if ([menu isEqual:_buttonMenu1]) {
        [self.button5 setLabelText:[model.industryName substringToIndex:model.industryName.length - 2]];
        self.state = model.industryID;
        self.index1 = model.industryID.integerValue - 1;
    } else {
        [self.button6 setLabelText:model.industryName];
        self.speak_type = model.industryID;
        self.index2 = model.industryID.integerValue;
        if ([model.industryID isEqualToString:@"0"]) {
            [self.button6 setLabelText:@"全部"];
        }
    }
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    [self hidden];
}

- (void)delay
{
//    for (NSMutableArray *data in self.dataSources) {
//        [data removeAllObjects];
//    }
    [self.tableView.mj_header beginRefreshing];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 20;
   return  self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WorkTableViewCell alloc] init];
        //        if (self.reqJobType == JobTypeDynamic) {
        //            cell.cellType = CellLayoutTypeSpecial;
        //        } else {
        //            cell.cellType = CellLayoutTypeNormal;
        //        }
        //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
        cell.type = WorkCellTypeNormal;
    }
    cell.isDetail = NO;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSDictionary *dicInfo = _dataSource[indexPath.row];
    [cell confineCellwithData:dicInfo];
    cell.indexPath = indexPath;
    cell.praiseActionBlock = ^(NSIndexPath *index){
        [self addLinkWithIndex:index];
    };
    cell.commentActionBlock = ^(NSIndexPath *index){
        self.selectedIndexPath = index;
        self.chatInputView.hidden = NO;
        self.isEditeNow = YES;
        [self.chatInputView.textView becomeFirstResponder];
    };
    cell.deleteActionBlock = ^(NSIndexPath *index){
        [self dustbinClickWithIndexPath:index];
    };
    cell.shareActionBlock = ^(NSIndexPath *index){
        [self shareDynamicWithIndex:index];
    };
    cell.checkActionBlock = ^(NSIndexPath *index){
        [self checkHomePageWith:index];
    };
//        cell.dustbinBtn.tag = indexPath.row + 1;
//        [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.attentionBtn.tag = indexPath.row + 1;
//        [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.functionBtn.appendIndexPath = indexPath;
//        [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
//        cell.iconBtn.appendIndexPath = indexPath;
//        [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        cell.nickName.appendIndexPath = indexPath;
//        [cell.nickName addGestureRecognizer:tap];
//    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 查看个人主页
- (void)checkHomePageWith:(NSIndexPath *)indexPath
{
    NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
    homepage.info = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark - 分享
- (void)shareDynamicWithIndex:(NSIndexPath *)index
{
    ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
    share.shareInfo = self.dataSource[index.row];
    [self.navigationController pushViewController:share animated:YES];
}

#pragma mark - 点赞
- (void)addLinkWithIndex:(NSIndexPath *)indexPath
{
//    NSLog(@"***%ld",(long)indexPath.row);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[indexPath.row]];
//    NSLog(@"%@",dic);
    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//    NSLog(@"####%@",is_good);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = dic[@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
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
//        if ([is_good isEqualToString:@"0"]) {
//            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
//        } else {
//            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
//        }
        [self updateCommentAndPraiseCountWithIndex:indexPath isPraise:YES];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];

    
}

#pragma mark - 删除
- (void)dustbinClickWithIndexPath:(NSIndexPath *)index{
    [self keyBoardDismiss];
//    WorkTableViewCell *cell;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        cell = (WorkTableViewCell *)[[btn superview] superview];
//    } else {
//        cell = (WorkTableViewCell *)[[[btn superview] superview] superview];
//    }
    NSDictionary *dic = [NSDictionary dictionary];
//    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSource[index.row];
    
    
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
    self.deletIndex = index.row;
    
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
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
                //                NSLog(@"%@---%@",json,json[@"info"]);
                if ([json[@"status"] integerValue] == 0) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    [self.dataSource removeObjectAtIndex:self.deletIndex];
                    [self.tableView reloadData];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];
            
        }
    }
}


#pragma mark - 更新评论和赞的数量
- (void)updateCommentAndPraiseCountWithIndex:(NSIndexPath *)index isPraise:(BOOL)isPraise
{
//    UITableView *table = self.tableViews[self.currentPage];
//    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getsum";
    params[@"speak_trends_id"] = self.dataSource[index.row][@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    NSLog(@"######%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"*****%@",json);
        if ([json[@"state"] integerValue] == 0) {
//            cell.commentLabel.text = json[@"discuss"];
//            cell.praiseLabel.text = json[@"click"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [dic setObject:json[@"discuss"] forKey:@"speak_trends_person"];
            [dic setObject:json[@"click"] forKey:@"speak_praise_count"];
            if (isPraise) {
                if ([is_good isEqualToString:@"0"]) {
                    [dic setObject:@"1" forKey:@"is_good"];
                } else {
                    [dic setObject:@"0" forKey:@"is_good"];
                }
            }
            [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.description);
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
    
    NSInteger count = [dic[@"imgCount"] integerValue];
    NSInteger videoCount = [dic[@"videoCount"] integerValue];
    
    NSString *description = dic[@"speak_comment_content"];
    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    NSString *speak_comment_state = dic[@"speak_comment_state"];
    NSString *lastDestription = [NSString stringWithFormat:@"%@ : %@",speak_comment_state,description3];
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
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
    
    if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) {
        photosHeight = kHEIGHT(43);
    } else if ([shareType isEqualToString:@"1"]) {
        photosHeight = [ShareDynamic calculateHeightWithInfo:dic[@"shareMsg"]];
    }else {
        CGFloat photoWidth;
        CGFloat videoWidth;
        photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
        videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
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
    }
    
    
    CGFloat cellHeight;
    
    if ([dic[@"address"] length] == 0) { //有地址
        
        if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
            if (self.isMore) {
                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
            } else {
                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
            }
        } else { //不是简历，求职
            if ([dic[@"original_photos"] count] == 0) {
                if (self.isMore) {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
                } else {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                }
            } else {
                if (self.isMore) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
                } else {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                }
            }
            
        }
        
        
    } else { //没地址
        
        if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
            if (self.isMore) {
                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
            } else {
                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
            }
        } else {
            if ([dic[@"original_photos"] count] == 0) {
                if (self.isMore) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
                } else {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                }
            } else {
                if (self.isMore) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
                } else {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                }
            }
        }
        
        
    }

    
    return cellHeight;
    
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

- (void)keyBoardDismiss
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    self.isEditeNow = NO;
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
//    NSLog(@"%f",self.chatInputView.frame.origin.y);
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

#pragma mark - 键盘、表情、录音

#pragma mark 初始化键盘
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
    __weak ThirdJobViewController* weakSelf = self;
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
//    NSMutableArray *data = _dataSources[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = self.dataSource[_selectedIndexPath.row];
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
            [self updateCommentAndPraiseCountWithIndex:_selectedIndexPath isPraise:NO];
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
//        self.ddUtility.delegate = self;
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


#pragma mark 录音，音频聊天
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
////    NSString *file = [RecorderManager sharedManager].fileAdress;
////    NSLog(@"#####%@",file);
//    [_chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//    _chatInputView.voiceButton.tag = DDVoiceInput;
//    
////    NSMutableArray *data = _dataSources[self.currentPage];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *dic = self.dataSource[_selectedIndexPath.row];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = dic[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    //    params[@"nick_name"] = myDic[@"nick_name"];
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
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //            [alert show];
//            //            [self updateCommentCount];
//            [self updateCommentAndPraiseCountWithIndex:_selectedIndexPath isPraise:NO];
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
#pragma mark KeyBoardNotification
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
#pragma mark Text view delegatef

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
//    NSMutableArray *data = _dataSources[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = self.dataSource[_selectedIndexPath.row];
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
            [self updateCommentAndPraiseCountWithIndex:_selectedIndexPath isPraise:NO];
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
#pragma mark KVO
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


#pragma mark  UIGestureRecognizerDelegate
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self keyBoardDismiss];
}


//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if (_historyY<targetContentOffset->y){
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//    
//    else if(_historyY>targetContentOffset->y){
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//    _historyY = targetContentOffset->y;
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
