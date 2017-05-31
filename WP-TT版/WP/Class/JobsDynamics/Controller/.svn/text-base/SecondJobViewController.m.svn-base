//
//  SecondJobViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/11/4.
//  Copyright © 2015年 WP. All rights reserved.
//  工作圈第四版

#import "SecondJobViewController.h"
#import "UISelectMenu.h"
#import "IndustryModel.h"

#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "MJRefresh.h"
#import "WPDataView.h"
#import "WPSelectButton.h"
#import "RSButtonMenu.h"
#import "WorkTableViewCell.h"
#import "WFPopView.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"

#import "WriteViewController.h"
#import "WPJobDetailViewController.h"
#import "PersonalHomepageController.h"
#import "IQKeyboardManager.h"

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

@interface SecondJobViewController ()<UIScrollViewDelegate,RSButtonMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIScrollView *mainScrol;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;

@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) RSButtonMenu *buttonMenu2;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;

@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) NSInteger currentPage;//当前是第几页
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSString *speak_type; //说说类型
@property (nonatomic,strong) NSString *state;      //说说的状态
@property (nonatomic,strong) NSString *time;       //开始时间
@property (nonatomic,strong) NSString *endDate;    //截止时间
@property (nonatomic,strong) WPDataView *dateView1;
@property (nonatomic,strong) WPDataView *dateView2;

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic,strong) NSMutableArray *tableViews; //用来存放所有的tableView;

@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *data2;
@property (nonatomic,strong) NSMutableArray *data3;
@property (nonatomic,strong) NSMutableArray *data4;
@property (nonatomic,strong) NSMutableArray *dataSources;  //用来存放所有的数据源

@property (nonatomic,strong) NSMutableArray *goodData1;
@property (nonatomic,strong) NSMutableArray *goodData2;
@property (nonatomic,strong) NSMutableArray *goodData3;
@property (nonatomic,strong) NSMutableArray *goodData4;
@property (nonatomic,strong) NSMutableArray *goodDatas;   //用来存放所以的是否已赞

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath; //头像点击的行数

@property (nonatomic,assign) BOOL isMore;            //是否有显示更多
@property (nonatomic,assign) BOOL isEditeNow;        //当前是否处于正在编辑状态
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

@implementation SecondJobViewController
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _buttons = [NSMutableArray array];
    self.isMore = NO;
    self.isEditeNow = NO;
    [self initNav];
    [self createHeader];
    [self initDatasources];
    [self createBottom];
    [self.table1.mj_header beginRefreshing];
    
    [self notificationCenter];
    [self initialInput];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[SecondJobViewController class]];
    //[[IQKeyboardManager sharedManager] disableInViewControllerClass:[SecondJobViewController class]];
}

- (void)initNav{
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    //    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"smll_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)initDatasources
{
    self.currentPage = 0;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    self.state = @"1";
    self.speak_type = @"9";
    self.time = @"0";
    self.endDate = @"0";
    self.data1 = [NSMutableArray array];
    self.data2 = [NSMutableArray array];
    self.data3 = [NSMutableArray array];
    self.data4 = [NSMutableArray array];
    _goodData1 = [NSMutableArray array];
    _goodData2 = [NSMutableArray array];
    _goodData3 = [NSMutableArray array];
    _goodData4 = [NSMutableArray array];
    
    self.dataSources = [[NSMutableArray alloc] initWithObjects:self.data1,self.data2,self.data3,self.data4, nil];
    self.tableViews = [[NSMutableArray alloc] initWithObjects:self.table1,self.table2,self.table3,self.table4, nil];
    self.goodDatas = [NSMutableArray arrayWithObjects:_goodData1,_goodData2,_goodData3,_goodData4, nil];
//    self.states = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
}


#pragma mark - 右按钮点击事件
- (void)rightBtnClick
{
    [self hidden];
    [_dateView1 hide];
    [_dateView2 hide];
    WriteViewController *write = [[WriteViewController alloc] init];
    write.myTitle = @"创建";
    //    write.comment_type = @"1";
    write.is_dynamic = YES;
    write.refreshData = ^(NSString *topic){
        [self updateBottomBtn];
        [self refreshIsNeedEmpty:YES];
    };
    [self.navigationController pushViewController:write animated:YES];

}

//底部按钮移到最新
- (void)updateBottomBtn
{
    //    if (self.isBottomClick) {
    //        [self.dataSources[self.lastPage] removeAllObjects];
    //    }
    self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*0 , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
    self.button1.selected = YES;
    self.button2.selected = NO;
    self.button3.selected = NO;
    self.button4.selected = NO;
    self.state = @"1";
    self.speak_type = @"9";
    self.time = @"0";
    self.endDate = @"0";
    [self.button6 setLabelText:@"全部时间"];
    [self.button5 setLabelText:@"全部分类"];

}


- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
        _buttonMenu1.delegate = self;
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32), SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
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
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32), SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
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
            [weakSelf refreshIsNeedEmpty:YES];
        };
    }
    return _dateView2;
}

- (UITableView *)table1
{
    if (_table1 == nil) {
        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kHEIGHT(32) - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
        _table1.delegate = self;
        _table1.dataSource = self;
        _table1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table1.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table1];
        __weak typeof(self) unself = self;
        self.table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table1.mj_footer resetNoMoreData];
            _page1 = 1;
            [unself requestWithPageIndex:_page1 andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.data1 removeAllObjects];
                [self.goodData1 removeAllObjects];
                [self.data1 addObjectsFromArray:datas];
                for (NSDictionary *dic in datas) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData1 addObject:is_good];
                }
                [_table1 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table1.mj_header endRefreshing];
        }];
        
        self.table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page1++;
            [unself requestWithPageIndex:_page1 andIsNear:YES Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table1.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data1 addObjectsFromArray:datas];
                    for (NSDictionary *dic in datas) {
                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                        [_goodData1 addObject:is_good];
                    }
                }
                [unself.table1 reloadData];
            } Error:^(NSError *error) {
                _page1--;
            }];
            [_table1.mj_footer endRefreshing];
        }];
        
    }
    return _table1;
}

- (UITableView *)table2
{
    if (_table2 == nil) {
        _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kHEIGHT(32) - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
        _table2.delegate = self;
        _table2.dataSource = self;
        _table2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table2.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table2];
        __weak typeof(self) unself = self;
        self.table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table2.mj_footer resetNoMoreData];
            _page2 = 1;
            [unself requestWithPageIndex:_page2 andIsNear:NO Success:^(NSArray *datas, int more) {
                [self.data2 removeAllObjects];
                [self.goodData2 removeAllObjects];
                [self.data2 addObjectsFromArray:datas];
                for (NSDictionary *dic in datas) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData2 addObject:is_good];
                }
                [_table2 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table2.mj_header endRefreshing];
        }];
        
        self.table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page2++;
            [unself requestWithPageIndex:_page2 andIsNear:NO Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table2.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data2 addObjectsFromArray:datas];
                    for (NSDictionary *dic in datas) {
                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                        [_goodData2 addObject:is_good];
                    }
                }
                [unself.table2 reloadData];
            } Error:^(NSError *error) {
                _page2--;
            }];
            [_table2.mj_footer endRefreshing];
        }];
        
    }
    return _table2;
}

- (UITableView *)table3
{
    if (_table3 == nil) {
        _table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kHEIGHT(32) - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
        _table3.delegate = self;
        _table3.dataSource = self;
        _table3.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table3.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table3];
        __weak typeof(self) unself = self;
        self.table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table3.mj_footer resetNoMoreData];
            _page3 = 1;
            [unself requestWithPageIndex:_page3 andIsNear:NO Success:^(NSArray *datas, int more) {
                [self.data3 removeAllObjects];
                [self.goodData3 removeAllObjects];
                [self.data3 addObjectsFromArray:datas];
                for (NSDictionary *dic in datas) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData3 addObject:is_good];
                }
                [_table3 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table3.mj_header endRefreshing];
        }];
        
        self.table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page3++;
            [unself requestWithPageIndex:_page3 andIsNear:NO Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table3.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data3 addObjectsFromArray:datas];
                    for (NSDictionary *dic in datas) {
                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                        [_goodData3 addObject:is_good];
                    }
                }
                [unself.table3 reloadData];
            } Error:^(NSError *error) {
                _page3--;
            }];
            [_table3.mj_footer endRefreshing];
        }];
        
    }
    return _table3;
}

- (UITableView *)table4
{
    if (_table4 == nil) {
        _table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kHEIGHT(32) - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
        _table4.delegate = self;
        _table4.dataSource = self;
        _table4.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table4.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table4];
        __weak typeof(self) unself = self;
        self.table4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table4.mj_footer resetNoMoreData];
            _page4 = 1;
            [unself requestWithPageIndex:_page4 andIsNear:NO Success:^(NSArray *datas, int more) {
                [self.data4 removeAllObjects];
                [self.goodData4 removeAllObjects];
                [self.data4 addObjectsFromArray:datas];
                for (NSDictionary *dic in datas) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData4 addObject:is_good];
                }
                [_table4 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table4.mj_header endRefreshing];
        }];
        
        self.table4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page4++;
            [unself requestWithPageIndex:_page4 andIsNear:NO Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table4.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data4 addObjectsFromArray:datas];
                    for (NSDictionary *dic in datas) {
                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                        [_goodData4 addObject:is_good];
                    }
                }
                [unself.table4 reloadData];
            } Error:^(NSError *error) {
                _page4--;
            }];
            [_table4.mj_footer endRefreshing];
        }];
        
    }
    return _table4;
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
    params[@"time"] = self.time;
    params[@"enddate"] = self.endDate;
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}

#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources[self.currentPage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *data = _dataSources[self.currentPage];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = _dataSources[self.currentPage];
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
    NSDictionary *dictionary = @{@"我草泥马":kFONT(14)};
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:dictionary];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_operationView dismiss];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
    } else {
        WPJobDetailViewController *detail = [[WPJobDetailViewController alloc] init];
        self.deletIndex = indexPath.row;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_dataSources[self.currentPage][indexPath.row]];
        //    detail.userInfo = dic;
        detail.info = dic;
        detail.is_good = [_goodDatas[self.currentPage][indexPath.row] boolValue];
        detail.deletComplete = ^(){
            [self.dataSources[self.currentPage] removeObjectAtIndex:self.deletIndex];
            [self.tableViews[self.currentPage] reloadData]; 
        };
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}


#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (void)createHeader
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(32))];
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
    
    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - kHEIGHT(32) - 64 - BOTTOMHEIGHT)];
    //    self.mainScrol.backgroundColor = [UIColor cyanColor];
    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - kHEIGHT(32) - 64 - BOTTOMHEIGHT);
    self.mainScrol.pagingEnabled = YES;
    self.mainScrol.delegate = self;
    //    self.mainScrol.backgroundColor = RGBColor(235, 235, 235);
    //    self.mainScrol.backgroundColor = [UIColor whiteColor];
    self.mainScrol.showsHorizontalScrollIndicator = NO;
    self.mainScrol.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrol];
    for (int i = 0; i<4; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 100, SCREEN_WIDTH, 20)];
        title.text = [NSString stringWithFormat:@"第%d页",i+1];
        title.textAlignment = NSTextAlignmentCenter;
        [self.mainScrol addSubview:title];
    }
}

#pragma mark - 进入个人主页

- (void)longPressToDo:(UITapGestureRecognizer *)tap
{
    WPNicknameLabel *nickName = (WPNicknameLabel *)tap.self.view;
    //    NSLog(@"********%d",nickName.appendIndexPath.row);
    nickName.backgroundColor = RGB(226, 226, 226);
    [self performSelector:@selector(delayWithObj:) withObject:nickName afterDelay:0.2];
    NSDictionary *dic = _dataSources[self.currentPage][nickName.appendIndexPath.row];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
//    NSLog(@"%@====%@",usersid,sid);
//    if ([usersid isEqualToString:sid]) {
//        personal.is_myself = YES;
//        //        personal.delegate = self;
//    } else {
//        personal.is_myself = NO;
//    }
    personal.sid = sid;
//    personal.speak_type = self.speak_type;
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
    NSDictionary *dic = _dataSources[self.currentPage][_iconClickIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    //    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        //        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
//    personal.speak_type = self.speak_type;
    [self.navigationController pushViewController:personal animated:YES];
}


#pragma mark - 点赞和评论

- (void)replyAction:(WPButton *)sender
{
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
    }
    
    UITableView *table = self.tableViews[self.currentPage];
    NSMutableArray *goodData = self.goodDatas[self.currentPage];
    CGRect rectInTableView = [table rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y + 2;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    BOOL isFavour;
    NSString *is_good = goodData[_selectedIndexPath.row];
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

- (void)addLike
{
    UITableView *table = self.tableViews[self.currentPage];
    NSMutableArray *goodData = self.goodDatas[self.currentPage];
    NSMutableArray *data = self.dataSources[self.currentPage];
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    NSString *is_good = goodData[_selectedIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[_selectedIndexPath.row]];
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
        
        if ([is_good isEqualToString:@"0"]) {
            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
        } else {
            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
        }
        [self updateCommentAndPraiseCount];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
}

- (void)replyMessage:(WPButton *)sender
{
    self.chatInputView.hidden = NO;
    self.isEditeNow = YES;
    [self.chatInputView.textView becomeFirstResponder];
}

//更新点赞和评论的数据
- (void)updateCommentAndPraiseCount
{
    UITableView *table = self.tableViews[self.currentPage];
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getsum";
    params[@"speak_trends_id"] = _dataSources[self.currentPage][_selectedIndexPath.row][@"sid"];
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
        NSLog(@"error%@",error.description);
    }];
    
}

#pragma mark - 删除和关注

//删除
- (void)dustbinClick:(UIButton *)btn{
    [self keyBoardDismiss];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[btn superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[btn superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSources[self.currentPage][path.row];
    
    
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
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
                //                NSLog(@"%@---%@",json,json[@"info"]);
                if ([json[@"status"] integerValue] == 0) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    [self.dataSources[self.currentPage] removeObjectAtIndex:self.deletIndex];
                    [self.tableViews[self.currentPage] reloadData];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];
            
        }
    }
}

//关注
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
    
    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSources[self.currentPage][path.row];
    
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
    
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    
    NSString *nick_name = dic[@"user_id"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@===%@",json[@"info"],json);
        if ([json[@"status"] integerValue] == 1) {
            NSMutableArray *data = _dataSources[self.currentPage];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dict = data[i];
                NSString *nick = dict[@"user_id"];
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
            [self.tableViews[self.currentPage] reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
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

- (void)keyBoardDismiss
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    self.isEditeNow = NO;
    [_dateView1 hide];
    [_dateView2 hide];
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

#pragma mark - 底部按钮的创建
- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainScrol.bottom, SCREEN_WIDTH, BOTTOMHEIGHT + 0.5)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3)];
    self.line.backgroundColor = RGBColor(10, 110, 210);
    [backView addSubview:self.line];
    
    CGFloat linwWidth = 0.5;
    CGFloat btnWidth = (SCREEN_WIDTH - 3)/4;
    NSArray *titles = @[@"最新",@"关注",@"好友",@"我的"];
    for (int i = 0; i<[titles count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth + linwWidth)*i, 0, btnWidth, BOTTOMHEIGHT)];
        button.tag = i+1;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if (i != 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), (BOTTOMHEIGHT - 15)/2, linwWidth, 15)];
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

//按钮点击事件
- (void)btnClick:(UIButton *)sender
{
//    [self keyBoardDismiss];
    
    self.currentPage = sender.tag - 1;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
        }
    }];
    
    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.state = @"1";
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.state = @"3";
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        self.state = @"2";
    } else if (sender.tag == 4) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        self.state = @"4";
    }
    [self refreshIsNeedEmpty:NO];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    if ([scrollView isEqual:self.mainScrol]) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self btnClickWithIndex:index];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_dateView1 hide];
    [_dateView2 hide];
    [_operationView dismiss];
    [self keyBoardDismiss];
}

- (void)btnClickWithIndex:(NSInteger)index
{
    self.currentPage = index;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
        }
    }];
    
    if (index == 0) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.state = @"1";
    } else if (index == 1) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.state = @"3";
        
    } else if (index == 2) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        self.state = @"2";
        
    } else if (index == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        self.state = @"4";
        
    }
    [self refreshIsNeedEmpty:NO];
}

- (void)refreshIsNeedEmpty:(BOOL)isEmpty{
    if (isEmpty) {
        [self.tableViews[self.currentPage] setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    } else {
        if ([self.dataSources[self.currentPage] count] == 0) {
            [[self.tableViews[self.currentPage] mj_header] beginRefreshing];
        }
    }
}

- (void)delay
{
    for (NSMutableArray *data in self.dataSources) {
        [data removeAllObjects];
    }
    [[self.tableViews[self.currentPage] mj_header] beginRefreshing];
    
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
//    [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak SecondJobViewController* weakSelf = self;
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
    NSMutableArray *data = _dataSources[self.currentPage];
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
//    NSMutableArray *data = _dataSources[self.currentPage];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *dic = data[_selectedIndexPath.row];
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
//            [self updateCommentAndPraiseCount];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    [self.chatInputView willBeginInput];
//    _chatInputView.hidden = YES;
//    self.isEditeNow = NO;
//    //    _chatInputView = nil;
//    //    if (self.isNeedDelloc > 0) {
//    //        [self needDealloc];
//    //        self.isNeedDelloc --;
//    //    }
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
    NSMutableArray *data = _dataSources[self.currentPage];
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

- (void)dealloc
{
    //注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
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
