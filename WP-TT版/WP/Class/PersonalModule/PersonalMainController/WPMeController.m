

#import "WPMeController.h"
#import "WPInfoController.h"
#import "WPPhotoWallController.h"
#import "WPOtherController.h"
#import "MRCommonGroup.h"
#import "MRCommonArrowItem.h"
#import "MRCommonCell.h"
#import "PersonalView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "DiscoverCell.h"
#import "DetailsViewController.h"
#import "WPMeRecruitController.h"
#import "WPMeInterviewController.h"
#import "WPMeActivityController.h"
#import "PersonalFriendViewController.h"
#import "WPTipModel.h"
#import "CollectViewController.h"

#import "WPSetViewController.h"
#import "NewHomePageViewController.h"

@interface WPMeController () <UpdateInfoDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) PersonalView *personalView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *iconAndTitle;
@property (nonatomic, strong) PersonalModel *selfModel;

@end

@implementation WPMeController



- (void)viewDidLoad {
    [super viewDidLoad];
    //设置头UIView
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人";
    [self.view addSubview:self.tableView];
    [self startRequest];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;

    _iconAndTitle = @[
                      @[
//  @{@"image" : @"me_wodeqianbao",
//                          @"title" : @"我的钱包"
//                          },
                        @{@"image" : @"me_gerenriji",
                          @"title" : @"回忆录"
                          }],
                      @[@{@"image" : @"me_wodeqiuzhi",
                          @"title" : @"我的求职",
                          @"applyCount":@""
                          //                          },
                          //                        @{@"image" : @"me_wodehuodong",
                          //                          @"title" : @"我的活动"
                          },
                        @{@"image" : @"me_wodezhaopin",
                          @"title" : @"我的招聘",
                          @"inviteCount":@""
                          }
                        ],
                      @[@{@"image" : @"me_shoucang",
                          @"title" : @"收藏"
                          }],
                      @[@{@"image" : @"me_shezhi",
                          @"title" : @"设置"
                          }],
                      @[]
                      ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWeiPinNumber) name:@"setWeiPinNumberSuccessed" object:nil];
    
    //点击退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess) name:@"LOGINOUTSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
}
-(void)messageTip
{
    WPTipModel *model = [WPTipModel sharedManager];
    _iconAndTitle = @[
                      @[
                          //  @{@"image" : @"me_wodeqianbao",
                          //                          @"title" : @"我的钱包"
                          //                          },
                          @{@"image" : @"me_gerenriji",
                            @"title" : @"回忆录"
                            }],
                      @[@{@"image" : @"me_wodeqiuzhi",
                          @"title" : @"我的求职",
                          @"applyCount":model.re_UnReadCount
                          //                          },
                          //                        @{@"image" : @"me_wodehuodong",
                          //                          @"title" : @"我的活动"
                          },
                        @{@"image" : @"me_wodezhaopin",
                          @"title" : @"我的招聘",
                          @"inviteCount":model.job_UnReadCount
                          }
                        ],
                      @[@{@"image" : @"me_shoucang",
                          @"title" : @"收藏"
                          }],
                      @[@{@"image" : @"me_shezhi",
                          @"title" : @"设置"
                          }],
                      @[]
                      ];
    
    [self.tableView reloadData];
}
-(void)loginOutSuccess
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
 
}
-(void)receiveWeiPinNumber
{
    [self startRequest];
}
#pragma  mark 请求个人信息
-(void)startRequest
{
    //[MBProgressHUD showMessage:@"" toView:self.view];
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *dic = @{@"action":@"userinfo",@"username":model.username,@"password":model.password,@"user_id":model.userId};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.personalView.model = [PersonalModel mj_objectWithKeyValues:json];
        self.selfModel = [PersonalModel mj_objectWithKeyValues:json];
        [self.personalView reloadData];
        
    } failure:^(NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
         [self.personalView reloadData];
    }];
}

-(PersonalView *)personalView
{
    if (!_personalView) {
        
        _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,15+kHEIGHT(72))];
        _personalView.isAllowEdit = YES;
        _personalView.hidePosition = YES;
        _personalView.backgroundColor = RGB(235, 235, 235);
        self.tableView.tableHeaderView = _personalView;
        __weak typeof(self) unself = self;
        //编辑
        _personalView.editPersonalInfo = ^(){
            DetailsViewController *detail = [[DetailsViewController alloc] init];
            detail.userID = kShareModel.userId;
            detail.isMySelf = YES;
            detail.upDataInfo = ^(){
                [unself startRequest];
            };
            [unself.navigationController pushViewController:detail animated:YES];
//            WPInfoController *info = [[WPInfoController alloc]init];
//            info.title = @"个人资料";
//            info.delegate = unself;
//            [unself.navigationController pushViewController:info animated:YES];
        };
        //用户关系
        WS(ws);
        _personalView.personalConenction = ^(NSInteger number){
            PersonalFriendViewController *personal = [[PersonalFriendViewController alloc]init];
            personal.type = number;
            personal.friend_id = kShareModel.userId;
            personal.friendRefreshBlock = ^(){
                [ws startRequest];
            };
            [unself.navigationController pushViewController:personal animated:YES];
        };
    }
    
    return _personalView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.personalView;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.showsVerticalScrollIndicator = NO;
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
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

-(void)UpdateInfoDelegate
{
    [self startRequest];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _iconAndTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_iconAndTitle[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DiscoverCell";
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:self options:nil][0];
        cell = [[DiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *info = _iconAndTitle[indexPath.section][indexPath.row];
    cell.icon.image = [UIImage imageNamed:info[@"image"]];
    cell.title.text = info[@"title"];
    if (indexPath.section == 1 && indexPath.row == 0) {//设置投递面试的个数
        cell.applyCount = info[@"applyCount"];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {//设置投递招聘的个数
        cell.inviteCount = info[@"inviteCount"];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            NSLog(@"我的钱包");
//        }else if (indexPath.row == 1){
            NSLog(@"回忆录");
            NewHomePageViewController *homePage = [[NewHomePageViewController alloc] init];
            homePage.info = @{@"user_id" : kShareModel.userId,
                              @"nick_name" : self.selfModel.nicknameStr};
            [self.navigationController pushViewController:homePage animated:YES];
//        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {  // 推出 我的求职 页面
            WPMeInterviewController *interview = [[WPMeInterviewController alloc]init];
            [self.navigationController pushViewController:interview animated:YES];
        }
        if (indexPath.row == 1) {  // 推出 我的招聘 页面
            
            WPMeRecruitController *recruit = [[WPMeRecruitController alloc]init];
            [self.navigationController pushViewController:recruit animated:YES];
        }
//        if (indexPath.row == 2) {
//            WPMeActivityController *activity = [[WPMeActivityController alloc]init];
//            [self.navigationController pushViewController:activity animated:YES];
//        }
    }
    if (indexPath.section == 2) {  // 推出 我的收藏 页面
        CollectViewController *VC = [[CollectViewController alloc]init];
        VC.title = @"收藏";
        VC.isCheck = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.section == 3) {  // 推出设置页面
        WPSetViewController *setVC = [[WPSetViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self performSelector:@selector(unselectCell:) withObject:nil afterDelay:0.5];
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
