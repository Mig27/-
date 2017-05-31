//
//  WPPersonalSetBlackListController.m
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonalSetBlackListController.h"
#import "LinkmanCell.h"
#import "FriendManager.h"
#import "FrienDListModel.h"
#import "PersonalInfoViewController.h"
#import "WPBlackLIstCell.h"
#import "WPBlackListDeleteWithBatchHttp.h"
#import "CCAlertView.h"
#import "TableViewIndex.h"
#import "WPReblackHttp.h"
#import "WPBlackNameModel.h"
#import "MTTDatabaseUtil.h"
#import "MTTSessionEntity.h"
#import "ChattingModule.h"
#import "DDMessageSendManager.h"
#import "MTTMessageEntity.h"
#define kHeightForHeaders 20
#define kHeightForRows kHEIGHT(50)
#define kBlackListCellReuse @"BlackListCellReuse"
#define kFriendListCellReuse @"FriendListCellReuse"


@interface WPPersonalSetBlackListController ()<UITableViewDelegate,UITableViewDataSource,FriendManagerDelegate,WPBlackLIstCellDelegate,UISearchBarDelegate>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *searchBar;
@property (nonatomic ,strong)NSMutableArray *titleArr;
@property (nonatomic ,strong)NSMutableArray *modelArr;
@property (nonatomic ,strong)NSMutableArray *idArr;


@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,strong)NSMutableArray *datas;

@property (nonatomic ,assign) BOOL isEditStatus;
@property (nonatomic ,strong) UIView *editView;
@property (nonatomic ,strong) UIButton *deleteBtn;
@property (nonatomic ,strong) UIButton *selectAllBtn;
@property (nonatomic ,strong) UIButton *countBtn;
@property (nonatomic ,copy) NSString *Ids;  //要删除id

@property (nonatomic, strong) NSMutableArray *sectionTitle;

@property (nonatomic ,assign) NSUInteger countNum;

@property (nonatomic ,strong) UILabel *countLabel;
@property (nonatomic, strong) UISearchBar * searchBar1;
@end

@implementation WPPersonalSetBlackListController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestWithAction:@"Blacklist"];
}

- (UISearchBar *)searchBar1{
    if (!_searchBar1) {
        _searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar1.tintColor = [UIColor lightGrayColor];
        _searchBar1.backgroundColor = RGB(247, 247, 247);
        _searchBar1.barStyle     = UIBarStyleDefault;
        _searchBar1.translucent  = YES;
        _searchBar1.placeholder = @"搜索";
        _searchBar1.delegate = self;
        
        [_searchBar1 sizeToFit];
        
        for (UIView *view in _searchBar1.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _searchBar1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    [self requestWithAction:@"Blacklist"];
    [self initNav];
    [self setupTableView];
//    [self setupSearchBar];
    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
}



#define IOSREQUESETADDRESS @"/ios/friend.ashx"

- (void)requestWithAction:(NSString *)action
{
    NSDictionary *params = @{@"action":action,
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password};
    NSString *url = [IPADDRESS stringByAppendingString:IOSREQUESETADDRESS];
    NSLog(@"%@",action);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        FrienDListModel *model = [FrienDListModel mj_objectWithKeyValues:json];
        [self.dataList removeAllObjects];
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:model.list];
//        self.dataList = [TableViewIndex archive:self.datas];
        self.dataList = [TableViewIndex transfer:self.datas];
        self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
        for (int i = (int)self.dataList.count-1; i>=0; i--) {
            if ([self.dataList[i] count] == 0) {
                [self.sectionTitle removeObjectAtIndex:i];
                [self.dataList removeObjectAtIndex:i];
            }
        }
        [self.tableView reloadData];
        [self freshNavi];
    } failure:^(NSError *error) {
        
    }];
}


-(void)freshNavi{
    if (self.datas.count == 0|| self.datas == nil) {
        
        NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
        itemAttrs[NSFontAttributeName] = kFONT(14);
        itemAttrs[NSForegroundColorAttributeName] = RGB(127, 127, 127);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self  action:@selector(rightBarButtonItemAction)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
    }
}


#pragma mark -  initNav
- (void)initNav{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;

    
}


-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return _modelArr;
}


-(NSMutableArray *)idArr{
    if (_idArr == nil) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

- (void)backToFromViewController:(UIButton *)sender
{
    if (self.isEditStatus == YES) {
        [self getBackToEdit];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)getBackToEdit{
    self.isEditStatus = NO;
    [self initNav];
    self.selectAllBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    self.countBtn.hidden = YES;
    self.deleteBtn.enabled = NO;
    [self.editView removeFromSuperview];
    _countNum = 0;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.tableView reloadData];
    [self freshNavi];
    for (int i = 0; i<self.modelArr.count; i++) {
        for (int j = 0; j<[self.modelArr[i] count]; j++) {
            NSArray *arr = self.modelArr[i];
            WPFriendModel *model = arr[j];
            if(model.selected == YES){
                model.selected = NO;
            }
        }
        if (_countNum == 0) {
            _countNum = 0;
        }else{
            _countNum --;
        }
    }
    [self.tableView reloadData];
}

-(void)rightBarButtonItemAction{

    self.isEditStatus = YES;
    self.navigationItem.rightBarButtonItem.title = @"";
    [self createEditView];
    self.countBtn.hidden = YES;
    for (WPFriendModel *model in self.datas) {
        model.selected = NO;
    }
    _countNum = 0;
    [self.tableView reloadData];
    
}






-(void)createEditView{
        self.editView = [[UIView alloc] init];
        self.editView.backgroundColor = [UIColor redColor];
        self.editView.layer.borderWidth = 0.5;
        self.editView.backgroundColor = [UIColor whiteColor];
        self.editView.layer.borderColor = RGBColor(178, 178, 178).CGColor;
        [self.view addSubview:_editView];
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.equalTo(@49);
        }];
    
    self.selectAllBtn = [[UIButton alloc] init];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    self.selectAllBtn.titleLabel.font = kFONT(15);
//    self.selectAllBtn.hidden = YES;
    self.selectAllBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -kHEIGHT(10), 0, 0);
    self.selectAllBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.selectAllBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [self.selectAllBtn addTarget:self action:@selector(selectAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:self.selectAllBtn];
    [self.selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView.mas_left);
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@80);
    }];
    
    
    
    CGSize normalSize = [@"字体" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = kFONT(15);
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize.width+10));
    }];

    
        //选中计数按钮
        UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.countBtn = countBtn;
        self.countBtn.backgroundColor = RGB(0, 172, 255);
        self.countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.countBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.countBtn.clipsToBounds = YES;
        self.countBtn.layer.cornerRadius = 10;
        [self.countBtn setTitle:[NSString stringWithFormat:@"%lu",_countNum] forState:UIControlStateNormal];
        [self.editView addSubview:self.countBtn];
        [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deleteBtn.mas_left).with.offset(-3);
            make.centerY.equalTo(self.deleteBtn);
            make.width.height.equalTo(@20);
        }];

}

-(void)selectAllBtnClick{
    //全选之前先置为0
    if ([self.selectAllBtn.titleLabel.text isEqualToString:@"全选"]) {
        _countNum = 0;
        for (int i = 0; i<self.dataList.count; i++) {
            for (int j = 0; j<[self.dataList[i] count]; j++) {
                NSArray *arr = self.dataList[i];
                WPFriendModel *model = arr[j];
                model.selected = YES;
                [self.idArr addObject:model.friend_id];
                 _countNum++;
            }
        }
        self.countBtn.hidden = NO;
        [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [self addAnimationToCountBtn];
        [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else{
        for (int i = 0; i<self.dataList.count; i++) {
            for (int j = 0; j<[self.dataList[i] count]; j++) {
                NSArray *arr = self.dataList[i];
                WPFriendModel *model = arr[j];
                if(model.selected == YES){
                    model.selected = NO;
                }
                if (_countNum == 0) {
                    _countNum = 0;
                }else{
                    _countNum --;
                }
            }
        }
        self.countBtn.hidden = YES;
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
//        [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
    
    
    
}


-(void)addAnimationToCountBtn{
    [self.countBtn.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [self.countBtn.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];

}

-(void)deleteBtnClick{
    if (_countNum == 0) {//elf.idArr.count == 0||self.idArr ==nil
        return;
    }else{
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:@"确认移出黑名单？"];
        [alert addBtnTitle:@"取消" action:^{
            return ;
        }];
        [alert addBtnTitle:@"确定" action:^{
            NSString *ids =@"";
            if (self.idArr.count > 1) {
                for (NSString *str in self.idArr) {
                    ids = [NSString stringWithFormat:@"%@,%@",ids,str];
                }
                ids = [ids substringFromIndex:1];
            }else{
                ids = self.idArr[0];
            }
            
            [self deletePersonInBlackList:ids];
        }];
        [alert showAlertWithSender:self];
    }
    
}


- (void)didSelectWPBlackLIstCell:(WPBlackLIstCell *)cell{
    
    if (cell.model.selected == YES) {
        _countNum++;
        [self.idArr addObject:cell.model.friend_id];
    }else{
        _countNum--;
        [self.idArr removeObject:cell.model.friend_id];
    }
    NSLog(@"333333333333333   %lu",_countNum);
    
    [self addAnimationToCountBtn];
    if (_countNum ==0 ) {
        self.countBtn.hidden = YES;
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }else{
        self.countBtn.hidden = NO;
        self.countBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)_countNum];
        [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    }
}


-(void)deletePersonInBlackList:(NSString *)Ids{
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPBlackListDeleteWithBatchParam *param = [[WPBlackListDeleteWithBatchParam alloc] init];
    param.action = @"batchReBlack";
    param.friend_id = Ids;
    param.user_id = userInfo[@"userid"];
    param.username = model.username;
    param.password = model.password;
    
    [WPBlackListDeleteWithBatchHttp WPBlackListDeleteWithBatchHttpWithParam:param success:^(WPBlackListDeleteWithBatchResult *result) {
        if (result.status.intValue == 1) {
        
            //从数据库中移除
            NSArray * array = [Ids componentsSeparatedByString:@","];
            NSMutableArray * muarray = [NSMutableArray array];
            for (NSString * idStr in array) {
                WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
                model.userId = [NSString stringWithFormat:@"user_%@",idStr];
                [muarray addObject:model];
            }
            [[MTTDatabaseUtil instance] removeFromBlackName:muarray completion:^(BOOL success) {
            }];
            
             //移出黑名单发送消息
            [self sendMessageToAllPeople:array];
            
            [self requestWithAction:@"Blacklist"];
            [self getBackToEdit];
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
            [self getBackToEdit];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}
#pragma mark 点击移除是发送消息
-(void)sendMessageToAllPeople:(NSArray*)array
{
    for (NSString*userId in array) {
        [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",userId] and:@"1"];
    }
}
-(void)sendeMessageAboutRemove:(NSString*)sendUser and:(NSString*)type
{
    MTTSessionEntity * session = [[MTTSessionEntity alloc]initWithSessionID:sendUser type:SessionTypeSessionTypeSingle];
    ChattingModule*mouble = [[ChattingModule alloc] init];
    mouble.MTTSessionEntity = session;
    DDMessageContentType msgContentType = DDMEssageDeleteOrBlackName;
    NSDictionary * dictionary = @{@"display_type":@"17",
                                  @"content":@{@"friend_id":kShareModel.userId,
                                               @"friend_type":type
                                               }
                                  };
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
    message.msgContent = contentStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
    } Error:^(NSError *error) {
    }];
}
#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(235, 235, 235);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[WPBlackLIstCell class] forCellReuseIdentifier:kBlackListCellReuse];
    
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    
//    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    self.searchBar.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = self.searchBar1;
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(40, 0, 0, 0));
//    }];
    
    
    
    
    
}

#pragma mark - 设置SearchBa
-(void)setupSearchBar{
    
    UIView *searchBar = [[UIView alloc] init];
    searchBar.backgroundColor =  RGBCOLOR(245, 245, 245);
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBCOLOR(240, 240, 240);
    [self.searchBar addSubview:lineView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor whiteColor];
    
    
    UIImage *yuyinImage = [UIImage imageNamed:@"MCSearch"];
    [searchBtn setImage:yuyinImage forState:UIControlStateNormal];
    [searchBtn setImage:yuyinImage forState:UIControlStateSelected];
    [searchBtn setImage:yuyinImage forState:UIControlStateHighlighted];
    //top left bottom right
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    
    NSString *soundButtonTitle = @"搜索";
    [searchBtn setTitle:soundButtonTitle forState:UIControlStateNormal];
    [searchBtn setTitle:soundButtonTitle forState:UIControlStateSelected];
    [searchBtn setTitle:soundButtonTitle forState:UIControlStateHighlighted];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    [searchBtn setTitleColor:RGBCOLOR(184, 184, 187) forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)]; //4个参数是上边界，左边界，下边界，右边界。
    
    searchBtn.frame = CGRectMake(0, 0, 200, 30);
    [searchBtn.layer setMasksToBounds:YES];
    [searchBtn.layer setCornerRadius:5.0];
    //设置矩形四个圆角半径
    [searchBtn.layer setBorderWidth:0.2];
    //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
    [searchBtn.layer setBorderColor:colorref];
    
//    [searchBtn addTarget:self action:@selector(didClicekedReturnWithKey:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.searchBar addSubview:searchBtn];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBar);
        make.height.mas_equalTo(@1);
        make.top.right.equalTo(self.searchBar);
    }];
    
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).with.offset(5);
        make.left.equalTo(self.searchBar).with.offset(10);
        make.right.equalTo(self.searchBar).with.offset(-10);
        make.height.mas_equalTo(@30);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaders;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForRows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPFriendModel *model = self.dataList[indexPath.section][indexPath.row];
    if (self.isEditStatus == YES) { //编辑状态点击没有跳转
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@""]) {
            WPBlackLIstCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.model.selected = !cell.model.selected;
            cell.button.selected = cell.model.selected;
            
            //编辑状态下面还要对title进行处理self.dataList[indexPath.section][indexPath.row];
            if (cell.model.selected == YES) {
                _countNum ++;
                [self.idArr addObject:model.friend_id];
            }else{
                [self.idArr removeObject:model.friend_id];
                _countNum --;
            }
            if (_countNum == 0) {
                self.deleteBtn.enabled = NO;
                self.countBtn.hidden = YES;
                [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            }else{
                self.deleteBtn.enabled = YES;
                self.countBtn.hidden = NO;
                [self.countBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_countNum] forState:UIControlStateNormal];
                [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
            }
            
            NSInteger dataCount = 0;
            for (NSArray *arr in self.dataList) {
                dataCount += arr.count;
            }
            
            // 当不是全选操作的时候  单步多次全部选中  全选变取消全选  反之亦然
            if (_countNum== dataCount) {
                self.selectAllBtn.hidden = NO;
                [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else if(_countNum == 0){
                [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }else{
                [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            [self addAnimationToCountBtn];
            
        }

//        return;
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        personInfo.friendID = model.friend_id;
        NSString *add_fuser_state =  model.add_fuser_state;
        if ([add_fuser_state isEqualToString:@"0"] ){// 现在是非0  都是陌生人 就只有好友 陌生人区别了
            personInfo.newType = NewRelationshipTypeFriend;
        }else{
            personInfo.newType = NewRelationshipTypeStranger;
        }
        personInfo.comeFromVc = @"黑名单";
        personInfo.pushFromBlack = ^(){// 刷新数据
        [self requestWithAction:@"Blacklist"];
         
        };
        [self.navigationController pushViewController:personInfo animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPFriendModel *model =  self.dataList[indexPath.section][indexPath.row];
    WPBlackLIstCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlackListCellReuse forIndexPath:indexPath];
    cell.model = model;
    cell.delegate = self;
    cell.isSeleted = model.selected;
    cell.isEditStatue = self.isEditStatus;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return nil;
    }else{
        return [self.sectionTitle objectAtIndex:section];
    }
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.dataList.count == 0) {
        return nil;
    }
    return self.sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = RGB(235, 235, 235);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 20)];
    [view addSubview:label];
    [label setTextColor:[UIColor grayColor]];
//    [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    [label setBackgroundColor:RGB(235, 235, 235)];
    label.text = [self.sectionTitle objectAtIndex:section];
    label.font = kFONT(12);
    return view;
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




@end
