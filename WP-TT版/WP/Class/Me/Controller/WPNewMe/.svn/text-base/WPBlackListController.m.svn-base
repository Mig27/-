//
//  WPBlackListController.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPBlackListController.h"
#import "LinkmanCell.h"
#import "FriendManager.h"
#import "FrienDListModel.h"
#import "SetFriendCell.h"
#import "WPSelectedButton.h"
#import "CCAlertView.h"
#import "TableViewIndex.h"

#define kHeightForHeaders 20
#define kHeightForRows kHEIGHT(50)
#define kBlackListCellReuse @"BlackListCellReuse"
#define kFriendListCellReuse @"FriendListCellReuse"

@interface WPBlackListController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,FriendManagerDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (nonatomic ,strong)NSMutableArray *titleArr;
@property (nonatomic ,strong)NSMutableArray *modelArr;
//@property (nonatomic ,strong)NSMutableArray *modelArray;

@property (nonatomic ,strong) UIView  *editView;

@property (nonatomic ,strong) UIButton  *selectAllBtn;
@property (nonatomic ,strong) UIButton  *deleteBtn;
@property (nonatomic ,strong) UIButton  *countBtn;

@property (nonatomic ,strong) UIButton  *rightBtn;

@property (nonatomic ,strong) UILabel  *makeView;
@property (nonatomic ,strong) UIButton  *doneBtn;

@property (nonatomic ,assign) NSInteger  countNum;
@property (nonatomic ,assign) NSInteger  doneNum;


@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,strong)NSMutableArray *datas;

@property (nonatomic, strong) NSMutableArray *sectionTitle;

@end

@implementation WPBlackListController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self chooseActionForFriendList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    [self addButton];
}


#define IOSREQUESETADDRESS @"/ios/friend.ashx"

- (void)requestWithAction:(NSString *)action
{
    if (![action isEqualToString:@"GetFriend"]) {
        [self.dataList removeAllObjects];
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:self.pushViewData];
        self.dataList = [TableViewIndex archive:self.datas];
        self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
        for (int i = (int)self.dataList.count-1; i>=0; i--) {
            if ([self.dataList[i] count] == 0) {
                [self.sectionTitle removeObjectAtIndex:i];
                [self.dataList removeObjectAtIndex:i];
            }
        }
        [self.tableView reloadData];
    }else{
        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
        
        WPShareModel *model = [WPShareModel sharedModel];
        
        NSMutableDictionary *userInfo = model.dic;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"action"] = action;
        params[@"username"] = model.username;
        params[@"password"] = model.password;
        params[@"user_id"] = userInfo[@"userid"];
        NSLog(@"%@",action);
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            FrienDListModel *model = [FrienDListModel mj_objectWithKeyValues:json];
            [self.dataList removeAllObjects];
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:model.list];
            self.dataList = [TableViewIndex archive:self.datas];
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
    
}


-(void)freshNavi{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.makeView];
        UIButton *wan = [UIButton buttonWithType:UIButtonTypeCustom];
        [wan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        wan.titleLabel.textAlignment = NSTextAlignmentCenter;
        wan.titleLabel.font = kFONT(14);
        CGSize normalSize = [@"完成" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        wan.frame = CGRectMake(0, 0, normalSize.width, normalSize.height);
        [wan setTitle:@"完成" forState:UIControlStateNormal];
        self.doneBtn = wan;
        [wan addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        if (_countNum == 0) {
            [self.doneBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            self.doneBtn.enabled = NO;
        }else{
            [self.doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.doneBtn.enabled = YES;
        }
        UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:wan];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
        negativeSpacer.width = -12;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightItem1,rightItem];
}


- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-20, 12, 20, 20);
        makeView.hidden = YES;
//        makeView.text = @"2";
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        //        makeView.backgroundColor = [UIColor redColor];
        //        makeView.backgroundColor = RGB(10, 110, 210);
        makeView.backgroundColor = RGB(0, 172, 255);
        //        [self.view addSubview:makeView];
        self.makeView = makeView;
        
    }
    return _makeView;
}


- (void)addButton
{
//    if ([self.title isEqualToString:@"黑名单"]) {  // 现在黑名单摘出去 这样的代码耦合太高， 低耦合 高内聚完全搞反
//      
//        return;
//    }else
    if ([self.title isEqualToString:@"选择联系人"]){
        
    }else if ([self.title isEqualToString:@"移除好友"]){
        [self createEditView];
    }
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
    self.selectAllBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0);
    [self.selectAllBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [self.selectAllBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_selectAllBtn];
    [self.selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView.mas_left);
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@80);
    }];
    
    CGSize normalSize = [@"字体大小" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.enabled = NO;
    self.deleteBtn.titleLabel.font = kFONT(15);
    self.deleteBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0,kHEIGHT(10));
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right);
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize.width));
    }];
    
    //选中计数按钮
    UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countBtn = countBtn;
    self.countBtn.backgroundColor = RGB(0, 172, 255);
    self.countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.countBtn.clipsToBounds = YES;
    self.countBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.countBtn.layer.cornerRadius = 10;
    [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
    [self.editView addSubview:self.countBtn];
    self.countBtn.hidden = YES;
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteBtn.mas_left);
        make.centerY.equalTo(self.deleteBtn);
        make.width.height.equalTo(@20);
    }];
    
}

- (void)selectedAction:(UIButton *)sender
{
    if ([self.selectAllBtn.titleLabel.text isEqualToString:@"全选"]) {
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    }else{
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _countNum = 0;
            for (WPFriendModel *model in self.datas) {
                model.selected = sender.selected;
                _countNum++;
            }
    }else{
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        for (WPFriendModel *model in self.datas) {
            model.selected = sender.selected;
            _countNum--;
        }
    }
    if (_countNum<0) {
        _countNum = 0;
    }
    if (_countNum == 0) {
        self.countBtn.hidden = YES;
        self.deleteBtn.enabled = NO;
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }else{
        self.countBtn.hidden = NO;
        self.deleteBtn.enabled = YES;
        [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    }
    [self addAnimationToCountBtn];
    [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_countNum] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

-(void)addAnimationToCountBtn{
    [self.countBtn.layer removeAllAnimations];
    [self.makeView.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [self.countBtn.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
}



- (void)deleteAction:(UIButton *)sender
{
    if (_countNum == 0) {
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"" message:@"至少选择一项"];
        [alert addBtnTitle:@"确定" action:^{
        }];
        [alert showAlertWithSender:self];
    }else{
        //加上提醒
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:@"确认删除?"];
        [alert addBtnTitle:@"取消" action:^{
        }];
        [alert addBtnTitle:@"确定" action:^{
            [self delete];
        }];
        [alert showAlertWithSender:self];
    }
    
    
}




- (void)delete
{
    NSString *action = [NSString stringWithFormat:@"Add%@",self.action];
    NSString *type = @"0";// 删除 type 为0
    if ([self.title isEqualToString:@"选择联系人"]) {// 添加 type 为1
        type = @"1";
    }
    NSString *urlstr = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    NSString *friend = nil;

        for (WPFriendModel *model in self.datas) {
            if (model.selected) {
                if (!friend) {
                    friend = model.friend_id;
                }else{
                    friend = [NSString stringWithFormat:@"%@,%@",friend,model.friend_id];
                }
            }
        }
    if (!friend) {
        return;
    }
    NSDictionary *params = @{@"action":action,
                             @"friend_id":friend,
                             @"type":type,
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password};
    [WPHttpTool postWithURL:urlstr params:params success:^(id json) {
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self delete];
}

- (void)chooseActionForFriendList
{
    if ([self.title isEqualToString:@"选择联系人"]) {                     // 添加 从好友中 添加
        [self requestWithAction:@"GetFriend"];
    }else{                                                              // 移除 从已添加的好友中 移除
        [self requestWithAction:self.action];
    }
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        self.searchBar.tintColor = [UIColor lightGrayColor];
        self.searchBar.backgroundColor = WPColor(235, 235, 235);
        self.searchBar.barStyle = UIBarStyleDefault;
        self.searchBar.translucent = YES;
        self.searchBar.placeholder = @"搜索";
        self.searchBar.delegate = self;
        
        [self.searchBar sizeToFit];
    }
    return _searchBar;
}

- (void)reloadData
{
//    FriendManager *manager = [FriendManager sharedManager];
//    self.titleArr = nil;
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:[manager.list allKeys]];
//    NSArray *numbers = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
//    for (NSString *str in arr) {
//        if ([numbers containsObject:str]) {
//            [arr removeObject:str];
//        }
//    }
//
//    self.titleArr = [NSMutableArray arrayWithArray:[arr sortedArrayUsingSelector:@selector(compare:)]];
//    [self.modelArr removeAllObjects];
//    for (NSString *string in self.titleArr) {
//        [self.modelArr addObject:manager.list [string]];
//    }
//    [self.tableView reloadData];
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
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
    [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    label.text = [self.sectionTitle objectAtIndex:section];
    label.font = kFONT(12);
    return view;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SetFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.model.canSelect isEqualToString:@"1"]) {
        return;
    }
    if (cell.model.selected == YES) {
        _countNum--;
    }else{
        _countNum++;
    }
    cell.model.selected = !cell.model.selected;
    if (_countNum == 0 ) {
        _countNum = 0;
    }
    
    self.countBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)_countNum];
    if (_countNum == 0) {
        self.countBtn.hidden = YES;
        self.deleteBtn.enabled = NO;
        self.makeView.hidden = YES;
        [self.doneBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        self.doneBtn.enabled = NO;
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }else{
        self.countBtn.hidden = NO;
        self.makeView.hidden = NO;
        self.doneBtn.enabled = YES;
        [self.makeView setText:[NSString stringWithFormat:@"%ld",(long)_countNum]];
        [self.doneBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        self.deleteBtn.enabled = YES;
        [self.deleteBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    }
    // 当不是全选操作的时候  单步多次全部选中  全选变取消全选  反之亦然
    if (_countNum== self.dataList.count) {
        self.selectAllBtn.hidden = NO;
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    }else if(_countNum == 0){
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }else{
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }

    [self addAnimationToCountBtn];
    
    
    [self.tableView reloadData];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.title isEqualToString:@"黑名单"]) {
        LinkmanCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlackListCellReuse forIndexPath:indexPath];
        WPFriendModel *model = self.dataList[indexPath.section][indexPath.row];
        NSString *imageUrl = [IPADDRESS stringByAppendingString:model.avatar];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
        cell.nameLabel.text = model.nick_name;
        return cell;
    }else if ([self.title isEqualToString:@"选择联系人"]){
        for (WPFriendModel *model in self.pushViewData) {
            for (WPFriendModel *model2 in self.datas) {
                if ([model2.friend_id isEqualToString:model.friend_id]) {
                    model2.canSelect = @"1"; //不可选
                }
            }
        }
        SetFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListCellReuse forIndexPath:indexPath];
        WPFriendModel *model = self.dataList[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }else{
        SetFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListCellReuse forIndexPath:indexPath];
        WPFriendModel *model = self.dataList[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}


- (UITableView *)tableView
{
    
    if (!_tableView) {
        if ([self.title isEqualToString:@"移除好友"]){
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        }else{
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        }
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = RGB(235, 235, 235);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableHeaderView = self.searchBar;
        [self.tableView registerClass:[LinkmanCell class] forCellReuseIdentifier:kBlackListCellReuse];
        [self.tableView registerClass:[SetFriendCell class] forCellReuseIdentifier:kFriendListCellReuse];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
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
