//
//  WPNearbyPeopleController.m
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNearbyPeopleController.h"
#import "WPSelectButton.h"
#import "RSButtonMenu.h"
#import "JobGroupModel.h"
#import "WPGroupCell.h"

#import "WPAllSearchController.h"
#import "WPGroupInformationViewController.h"
#import "WPGetNearbyPersonDataHttp.h"
#import "WPNearByPersonCell.h"
#import "CCMenu.h"
#import "WPGetNewPositionResult.h"
#import "WPNewPositionModel.h"
#import "WPMenuButton.h"
#import "PersonalInfoViewController.h"
#import "WPGetFriendInfoHttp.h"
#import "WPFriendSettingController.h"
@interface WPNearbyPeopleController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CCMenuDelegate>{

    

}

@property (nonatomic, assign) NSInteger categoryCount; /**< 分类标志位 */

@property (strong, nonatomic) CCIndexPath *positionSelectedNumber;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic,strong) NSMutableArray *buttons;

/**附近，行业 */
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;

@property (nonatomic,strong) CCMenu *city;  //点击按钮弹出的tableview

@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;

@property (nonatomic,assign) NSUInteger index1;

@property (nonatomic,assign) NSUInteger index2;

@property (nonatomic, strong) WPNewPositionModel *paramModel;/**< 请求数据类型Model */

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataSource2;

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *industryId;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,assign) NSUInteger page;

@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, assign)BOOL isNear;

@end

@implementation WPNearbyPeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = NO;
    self.title = @"附近的人脉";
    _categoryCount = 0;
    
    _positionSelectedNumber = [[CCIndexPath alloc]init];
    _positionSelectedNumber.section = -1;
    _positionSelectedNumber.row = -1;
   
    self.view.backgroundColor = RGB(178, 178, 178);
    [self initDataSource];
    [self initNav];
    [self.view addSubview:self.headView];
    [self.tableView.mj_header beginRefreshing];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PopNoGoToTop:) name:@"PopNoGoToTop" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];

}
#pragma mark点击设置
-(void)clickRight
{
    WPFriendSettingController *friendVC = [[WPFriendSettingController alloc]init];
    friendVC.nearPerson = YES;
    friendVC.isShowNear = self.isNear;
    friendVC.setNear = ^(BOOL isOrNot){
        self.isNear = isOrNot;
    };
    [self.navigationController pushViewController:friendVC animated:YES];
}
-(void)PopNoGoToTop:(NSNotification *)noti{
    //刷新指定的一行，这样就不会回到顶部
//    NSIndexPath *ccindex = noti.userInfo[@"ccindex"];
//    [self.tableView.mj_header beginRefreshing];
    [self loadDataWithPage:1];
//    [self.tableView scrollToRowAtIndexPath:ccindex
//atScrollPosition:UITableViewScrollPositionBottom
//animated:true];
}

#pragma mark -  初始化UI
- (void)initNav{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromVC) forControlEvents:UIControlEventTouchUpInside];
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

-(void)backToFromVC{
    [self.city removeFromSuperview];
    UIView *view = [WINDOW viewWithTag:1000];
    [view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化数据源
- (void)initDataSource
{
    self.buttons = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.dataSource2 = [NSMutableArray array];
    self.index2 = 0;
    self.index1 = 0;
    self.action = @"is_near";
    self.industryId = @"1";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"groupDataUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopNoGoToTop" object:nil];
}



#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [WPNearByPersonCell rowHeight];
        [self.view addSubview:_tableView];
//      _tableView.backgroundColor = [UIColor redColor];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself loadDataWithPage:_page];
            [_tableView.mj_header endRefreshing];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself loadDataWithPage:_page];
            [_tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        WPNearByPersonCell *cell = [WPNearByPersonCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
    personInfo.friendID = [self.dataSource[indexPath.row] user_id];
    if ([[self.dataSource[indexPath.row] is_friend] isEqualToString:@"0"]) {  // 0陌生人 1好友
        personInfo.newType = NewRelationshipTypeStranger;
    }else{
        personInfo.newType = NewRelationshipTypeFriend;
    }
    personInfo.comeFromVc = @"附近的人脉";
    personInfo.ccindex = indexPath;
    [self.navigationController pushViewController:personInfo animated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将分割线拉伸到屏幕的宽度
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}


#pragma mark - 下拉菜单 headerView
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(32))];//BOTTOMINHEADVIEWHEIGHT
        _headView.backgroundColor = [UIColor whiteColor];
            
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGB(226, 226, 226);
        [_headView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_headView);
            make.bottom.equalTo(_headView.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        CGFloat width = SCREEN_WIDTH/2;
        NSMutableArray* arrayButtonName = [NSMutableArray arrayWithArray:@[@"全部", @"职位"]];
        for (int i = 0; i < arrayButtonName.count; ++i) {
             //这里只是自定义的view
            WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, 0, width, kHEIGHT(32))];
            [btn setLabelText:arrayButtonName[i]];
            btn.image.image = [UIImage imageNamed:@"arrow_down"];
            [_headView addSubview:btn];
            
            //这里是当i=1的时候  中间有条分割线
            if (i != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i,(kHEIGHT(32) - 15)/2, 0.5, 15)];
                line.backgroundColor = RGB(226, 226, 226);
                [_headView addSubview:line];
            }
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
          
            [button setFrame:CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, kHEIGHT(32))];

            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:10+i];
            [_buttons addObject:button];
            [_headView addSubview:button];
            
            btn.isSelected = button.isSelected;
            
            //让两个按钮等价
            if (i==0) {
                self.button5 = btn;
            } else if (i==1) {
                self.button6 = btn;
            }

        }
    }
    
    return _headView;
}

- (CCMenu *)city
{
    if (!_city) {
        
        _city = [[CCMenu alloc] initWithFrame:CGRectMake(0, 64+kHEIGHT(32), SCREEN_WIDTH, SCREEN_HEIGHT-64-kHEIGHT(32))];
        _city.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_city];
        //顶部view 点击是收起菜单栏
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        subView1.tag = 1000;
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:subView1];
        
        //block实现 ，调用不是在这里 类似于代理
        WS(ws);
        _city.touchHide =^(){
            [ws touchHide:nil];
        };
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [subView1 addGestureRecognizer:tap1];
    }
    return _city;
}
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:1000];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
}

- (void)buttonClick:(UIButton*)sender/**< 选中的分类 */
{
    sender.selected = !sender.selected;
    switch (sender.tag-10) {
        case 0:
            self.button5.selected = sender.selected;
            if(sender.selected == YES){
                self.button6.selected = NO;
            }
            break;
        case 1:/**< 职位 */
            self.button6.selected = sender.selected;
            if(sender.selected == YES){
                self.button5.selected = NO;
            }
            break;
    }
    //先判断按钮是选中状态
    if(sender.selected){
        //找到被选中的按钮
        if(_selectedButton == sender){
            UIView *view1 = [WINDOW viewWithTag:1000];
            _selectedButton = nil;
            view1.hidden = YES;
            [self.city remove];
        }else{
            _selectedButton.selected = !_selectedButton.selected;
            self.selectedButton = sender;
            UIView *view1 = [WINDOW viewWithTag:1000];
            view1.hidden = NO;
            _categoryCount = sender.tag;
            
            NSMutableArray *timeArr = [NSMutableArray array];
        
            //左边菜单选项
            NSArray *sexArr = @[@"全部",@"只看男士",@"只看女士"];
        
            //实例化模型  IndustryModel
            for (int i = 0; i<sexArr.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = sexArr[i];
                model.industryID = [NSString stringWithFormat:@"%d",i + 1];
                [timeArr addObject:model];
            }
            switch (sender.tag-10) {
                case 0:
                    self.city.isArea = YES;
                    self.city.isIndusty = NO;
                    [self.city setLocalData:timeArr selectedIndex:self.index1];
                    break;
                case 1:/**< 职位 */
                    self.city.isArea = NO;
                    self.city.isIndusty = NO;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getNearPosition",@"fatherid":@"0"} selectedIndex:_positionSelectedNumber];  // 这里传递的只是点击 section 0 ->  主要是row
                    break;
            }
        }
    }else{
        UIView *view1 = [WINDOW viewWithTag:1000];
        _selectedButton = nil;
        view1.hidden = YES;
        [self.city remove];
    }
}

#pragma mark - UISelectCity
-(void)CCMenuDelegate:(IndustryModel *)model   ///这个model 里面包含了职位id
{
    UIView *view1 = [WINDOW viewWithTag:1000];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
    if (_categoryCount-10 != 9) {
        if (_categoryCount - 10 == 0) {
            self.index1 = model.section;
            self.button5.selected = NO;
            [self.button5 setLabelText:model.industryName];
        }else{
            //我们要在这里加上一个判断
            self.button6.selected = NO;
            if ([model.industryID isEqualToString:@"0"]) { // 接下来就是选择table2 全部 应该做处理
                [self.button6 setLabelText:@"职位"];
            }else{
                [self.button6 setLabelText:model.industryName];
            }
        }
    }
    
    switch (_categoryCount-10) {
        case 0:
            if ([model.industryID isEqualToString:@"1"]) {
                self.paramModel.sex = @"全部";
            }else if ([model.industryID isEqualToString:@"2"]){
                self.paramModel.sex = @"男";
            }else{
                self.paramModel.sex = @"女";
            }
            break;
        case 1:
            self.paramModel.positionID = model.industryID;
            _positionSelectedNumber.section = model.section;  //这里我们可以默认section 都是为0  因为只有一组 section--》first
            _positionSelectedNumber.row = model.row;        //row---->second
            break;
    }

    [self loadDataWithPage:1];
//  [self.tableView.mj_header beginRefreshing];
}


- (WPNewPositionModel *)paramModel{
    if (!_paramModel) {
        _paramModel = [[WPNewPositionModel alloc] init];
        _paramModel.positionID = @"0";  //代表全部
        _paramModel.sex = @"全部";
        _paramModel.fatherID = @"1";
        _paramModel.industryName = @"1";
    }
    return _paramModel;
}


- (void)loadDataWithPage:(NSInteger)page
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetNearbyPersonDataParam *param = [[WPGetNearbyPersonDataParam alloc] init];
    param.action = @"SearchNearByUser";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [user objectForKey:@"longitude"];
    NSString *latitude = [user objectForKey:@"latitude"];
    param.latitude = latitude;
    param.longitude = longitude;
    param.page = [NSString stringWithFormat:@"%ld",(long)page];
    param.userId = userInfo[@"userid"];
    param.position = self.paramModel.positionID;
    param.sex = self.paramModel.sex;
    if (!self.isFirst) {
        self.isFirst = YES;
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }
    
    [WPGetNearbyPersonDataHttp WPGetNearbyPersonDataHttpWithParam:param success:^(WPGetNearbyPersonDataResult *result) {
        [MBProgressHUD hideHUDForView:self.view];
        if (result.status.intValue == 1) {
            self.isNear = [result.is_near isEqualToString:@"True"];
            if (_page == 1) {
                [self.tableView.mj_header endRefreshing];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:result.list];
                [self.tableView reloadData];
            }else{
                if (!result.list.count) { //如果刷新的这一页没有数据
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    _page -- ;
                }
                [self.dataSource addObjectsFromArray:result.list];
                [self.tableView reloadData];
            }
        }else{
            _page--;
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}



- (void)delay
{
    [self.tableView.mj_header beginRefreshing];
}




@end
