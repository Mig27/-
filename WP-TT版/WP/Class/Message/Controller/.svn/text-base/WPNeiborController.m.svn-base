////
////  WPNeiborController.m
////  WP
////
////  Created by CC on 16/6/7.
////  Copyright © 2016年 WP. All rights reserved.
////
//
//#import "WPNeiborController.h"
//#import "PersonalInfoViewController.h"
//#import "WPNearByPersonCell.h"
//#import "WPGetNearbyPersonDataHttp.h"
//#import "WPSelectButton.h"
//
//@interface WPNeiborController ()<UITableViewDelegate,UITableViewDataSource>
//
//@property (nonnull,strong) UITableView *tableView;
//@property (nonatomic,strong) NSMutableArray *dataSource;
//@property (nonatomic,assign) NSUInteger page;
//@property (nonatomic,strong) UIView *headView;
//@property (nonatomic,strong) NSMutableArray *buttons;
//
///**附近，行业 */
//@property (nonatomic,strong) WPSelectButton *button5;
//@property (nonatomic,strong) WPSelectButton *button6;
//
//
//@end
//
//@implementation WPNeiborController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"附近人脉";
//    self.view.backgroundColor = RGB(178, 178, 178);
//    [self initNav];
//    [self.view addSubview:self.headView];
//    [self.tableView.mj_header beginRefreshing];
//    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}
//
//#pragma mark 数据相关
//- (void)loadDataWithPage:(NSInteger)page
//{
//    
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    WPGetNearbyPersonDataParam *param = [[WPGetNearbyPersonDataParam alloc] init];
//    param.action = @"SearchNearByUser";
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *longitude = [user objectForKey:@"longitude"];
//    NSString *latitude = [user objectForKey:@"latitude"];
//    param.latitude = latitude;
//    param.longitude = longitude;
//    param.page = [NSString stringWithFormat:@"%ld",(long)page];
//    param.userId = userInfo[@"userid"];
////    param.position = self.paramModel.positionID;
////    param.sex = self.paramModel.sex;
//    
//    [WPGetNearbyPersonDataHttp WPGetNearbyPersonDataHttpWithParam:param success:^(WPGetNearbyPersonDataResult *result) {
//        if (result.status.intValue == 1) {
//            if (_page == 1) {
//                [self.dataSource removeAllObjects];
//                [self.dataSource addObjectsFromArray:result.list];
//                [self.tableView reloadData];
//            }else{
//                if (!result.list.count) { //如果刷新的这一页没有数据
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                    _page -- ;
//                }
//                [self.dataSource addObjectsFromArray:result.list];
//                [self.tableView reloadData];
//            }
//        }else{
//            _page--;
//            [MBProgressHUD showError:result.info];
//        }
//        
//    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"网络不给力哦"];
//    }];
//    
//    
//}
//
//#pragma mark -  初始化UI
//- (void)initNav{
//    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 50, 22);
//    [back addTarget:self action:@selector(backToFromVC) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
//    imageV.image = [UIImage imageNamed:@"fanhui"];
//    [back addSubview:imageV];
//    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
//    title.text = @"返回";
//    title.font = kFONT(14);
//    [back addSubview:title];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backItem;
//    
//}
//
//-(void)backToFromVC{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//
//#pragma mark tableView
//- (UITableView *)tableView
//{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.rowHeight = [WPNearByPersonCell rowHeight];
//        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headView.mas_bottom);
//            make.left.right.bottom.equalTo(self.view);
//        }];
//        
//        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        
//        __weak typeof(self) unself = self;
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [unself.tableView.mj_footer resetNoMoreData];
//            _page = 1;
//            [unself loadDataWithPage:_page];
//            [_tableView.mj_header endRefreshing];
//        }];
//        
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            _page++;
//            [unself loadDataWithPage:_page];
//            [_tableView.mj_footer endRefreshing];
//        }];
//        
//    }
//    
//    return _tableView;
//}
//
//
//#pragma mark - 下拉菜单 headerView
//- (UIView *)headView{
//    if (!_headView) {
//        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(32))];
//        _headView.backgroundColor = [UIColor whiteColor];
//        
//        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = RGB(226, 226, 226);
//        [_headView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(_headView);
//            make.bottom.equalTo(_headView.mas_bottom);
//            make.height.equalTo(@0.5);
//        }];
//        CGFloat width = SCREEN_WIDTH/2;
//        NSMutableArray* arrayButtonName = [NSMutableArray arrayWithArray:@[@"全部", @"职位"]];
//        for (int i = 0; i < arrayButtonName.count; ++i) {
//            
//            //这里只是自定义的view
//            WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, 0, width, kHEIGHT(32))];
//            [btn setLabelText:arrayButtonName[i]];
//            btn.image.image = [UIImage imageNamed:@"arrow_down"];
//            [_headView addSubview:btn];
//            
//            //这里是当i=1的时候  中间有条分割线
//            if (i != 0) {
//                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i,(kHEIGHT(32) - 15)/2, 0.5, 15)];
//                line.backgroundColor = RGB(226, 226, 226);
//                [_headView addSubview:line];
//            }
//            
//            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//            
//            [button setFrame:CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, kHEIGHT(32))];
//            
//            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [button setTag:10+i];
//            [_buttons addObject:button];
//            [_headView addSubview:button];
//            
//            btn.isSelected = button.isSelected;
//            
//            //让两个按钮等价
//            if (i==0) {
//                self.button5 = btn;
//            } else if (i==1) {
//                self.button6 = btn;
//            }
//            
//        }
//    }
//    
//    return _headView;
//}
//
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    WPNearByPersonCell *cell = [WPNearByPersonCell cellWithTableView:tableView];
//    cell.model = self.dataSource[indexPath.row];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
//    personInfo.friendID = [self.dataSource[indexPath.row] user_id];
//    if ([[self.dataSource[indexPath.row] is_friend] isEqualToString:@"0"]) {  // 0陌生人 1好友
//        personInfo.newType = NewRelationshipTypeStranger;
//    }else{
//        personInfo.newType = NewRelationshipTypeFriend;
//    }
//    personInfo.comeFromVc = @"附近的人脉";
//    personInfo.ccindex = indexPath;
//    [self.navigationController pushViewController:personInfo animated:YES];
//    
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //将分割线拉伸到屏幕的宽度
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//- (void)buttonClick:(UIButton*)sender/**< 选中的分类 */
//{
//    sender.selected = !sender.selected;
//    switch (sender.tag-10) {
//        case 0:
//            self.button5.selected = sender.selected;
//            if(sender.selected == YES){
//                self.button6.selected = NO;
//            }
//            break;
//        case 1:/**< 职位 */
//            self.button6.selected = sender.selected;
//            if(sender.selected == YES){
//                self.button5.selected = NO;
//            }
//            break;
//    }
//    
//    //先判断按钮是选中状态
//    if(sender.selected){
//        //找到被选中的按钮
//        if(_selectedButton == sender){
//            UIView *view1 = [WINDOW viewWithTag:1000];
//            _selectedButton = nil;
//            view1.hidden = YES;
//            [self.city remove];
//        }else{
//            _selectedButton.selected = !_selectedButton.selected;
//            self.selectedButton = sender;
//            UIView *view1 = [WINDOW viewWithTag:1000];
//            view1.hidden = NO;
//            _categoryCount = sender.tag;
//            
//            NSMutableArray *timeArr = [NSMutableArray array];
//            
//            //左边菜单选项
//            NSArray *sexArr = @[@"全部",@"只看男士",@"只看女士"];
//            
//            //实例化模型  IndustryModel
//            for (int i = 0; i<sexArr.count; i++) {
//                IndustryModel *model = [[IndustryModel alloc]init];
//                model.industryName = sexArr[i];
//                model.industryID = [NSString stringWithFormat:@"%d",i + 1];
//                [timeArr addObject:model];
//            }
//            switch (sender.tag-10) {
//                case 0:
//                    self.city.isArea = YES;
//                    self.city.isIndusty = NO;
//                    [self.city setLocalData:timeArr selectedIndex:self.index1];
//                    break;
//                case 1:/**< 职位 */
//                    self.city.isArea = NO;
//                    self.city.isIndusty = NO;
//                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getNearPosition",@"fatherid":@"0"} selectedIndex:_positionSelectedNumber];
//                    break;
//            }
//        }
//    }else{
//        UIView *view1 = [WINDOW viewWithTag:1000];
//        _selectedButton = nil;
//        view1.hidden = YES;
//        [self.city remove];
//    }
//}
//
//
//
//-(NSMutableArray *)dataSource{
//    if (_dataSource == nil) {
//        _dataSource = [NSMutableArray array];
//    }
//    return  _dataSource;
//}
//
//
//
//@end
