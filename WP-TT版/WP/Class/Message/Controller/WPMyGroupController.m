//
//  WPMyGroupController.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMyGroupController.h"
#import "WPGroupCreateViewController.h"
#import "MCSearchViewController.h"
#import "WPDynamicGroupViewController.h"
#import "WPGoupListModel.h"
#import "WPPhoneBookGetGroupListHttp.h"
#import "WPPhoneBookGroupCell.h"
#import "MTTSessionEntity.h"
#import "MTTDatabaseUtil.h"
#import "ChattingMainViewController.h"
#import "SessionModule.h"
#import "DDGroupModule.h"
#import "WPAllSearchController.h"
#import "DDMessageSendManager.h"
@interface WPMyGroupController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MCSearchViewControllerDelegate,UISearchBarDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) WPPhoneBookGetGroupListResult *dataSource;

@property (nonatomic,strong)MCSearchViewController *searchViewController;
@property (nonatomic,weak)UITextField *searchViw;
@property (nonatomic,weak)UIView *searchBar;

@property (nonatomic,strong)NSMutableArray *searchData; //搜索过的数据

@property (nonatomic,assign,getter=isSearching)BOOL searching;

@property (nonatomic, strong)NSIndexPath*choiseIndex;
@property (nonatomic, strong)ChattingModule*mouble;
@property (nonatomic, copy)NSString * userId;
@property (nonatomic, strong)UISearchBar*searchBar1;
@end

@implementation WPMyGroupController
-(ChattingModule*)mouble
{
    if (!_mouble)
    {
        _mouble = [[ChattingModule alloc]init];
    }
    return _mouble;
}
- (MCSearchViewController *)searchViewController
{
    if (_searchViewController == nil) {
        _searchViewController = [[MCSearchViewController alloc] init];
        _searchViewController.delegate = self;
        
        //设置搜索控制器
        __weak WPMyGroupController *weakSelf = self;
        __weak MCSearchViewController *weakSearch = _searchViewController;
        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPPhoneBookGroupCell *cell = [WPPhoneBookGroupCell cellWithTableView:weakSelf.tableView];
            WPPhoneBookGroupModel *model = weakSearch.resultSource[indexPath.row];
            cell.model = model;
            return cell;
        }];
        //设置搜索cell的高度
        [_searchViewController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return kHEIGHT(50);
        }];
        ///设置选中cell后的操作
        
        [_searchViewController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPPhoneBookGroupModel *model = weakSearch.resultSource[indexPath.row];
            if (!model) {
                return;
            }
            
//            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.districtModel.caName,@"districtName",model.raName ,@"communityName",model.raid,@"raid",nil];
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"YPSelectRegionNotification" object:nil userInfo:dict];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            for (UIViewController *temp in weakSelf.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[YPAddAddressController class]]||[temp isKindOfClass:[YPEditAddressController class]]) {
//                    weakSelf.navigationController.navigationBar.hidden=YES;
//                    [weakSelf.navigationController popToViewController:temp animated:YES];
//                }
//            }
//            
        }];
        
    }
    
    return _searchViewController;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requireGroupData];
}

-(NSArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的群组";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];
    [self setupTableView];
//    [self setupSearchBar];
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UISearchBar *)searchBar1{
    if (!_searchBar1) {
        _searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar1.tintColor = [UIColor lightGrayColor];
        _searchBar1.backgroundColor = WPColor(235, 235, 235);
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    return NO;
}
#pragma mark - 请求组数据
- (void)requireGroupData{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPPhoneBookGetGroupListParam *param = [[WPPhoneBookGetGroupListParam alloc] init];
    param.action = @"GetGroup";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
   
    [WPPhoneBookGetGroupListHttp wPPhoneBookGetGroupListHttpWithParam:param success:^(WPPhoneBookGetGroupListResult *result) {
//        NSLog(@"%@---%@",result.myjoin,result.mycreated);
        if (result.status.intValue == 0) {
            self.dataSource = result;
            [self.tableView reloadData];
        }else{
//            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
       [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
}



- (void)initNav{
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
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backItem;
    if (!self.isCreateChat) {
        if (!self.fromChatNotCreat) {
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createGroup)];
        }
    }
}
-(void)createGroup{
    WPGroupCreateViewController *createGroup = [[WPGroupCreateViewController alloc] init];
    [self.navigationController pushViewController:createGroup animated:YES];
}
//-(void)backToFromVC{
//    [self.navigationController popViewControllerAnimated:YES];
//}




#pragma mark 懒加载

//- (MCSearchViewController *)searchViewController
//{
//    if (_searchViewController == nil) {
//        _searchViewController = [[MCSearchViewController alloc] init];
//        //        _searchViewController.navigationController.navigationBar.barTintColor = [UIColor redColor];
//        //         _searchViewController.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//        //        _searchViewController.cancelColor = [UIColor redColor];
//        _searchViewController.delegate = self;
//        
//        //设置搜索控制器
//        __weak YPRegionCommunityController *weakSelf = self;
//        __weak MCSearchViewController *weakSearch = _searchViewController;
//        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//            YPCommunityModel *model = weakSearch.resultSource[indexPath.row];
//            [cell.textLabel setText:model.raName];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//        }];
//        //设置搜索cell的高度
//        [_searchViewController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
//            return 45;
//        }];
//        ///设置选中cell后的操作
//        
//        [_searchViewController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
//            
//            YPCommunityModel *model = weakSearch.resultSource[indexPath.row];
//            if (!model) {
//                return;
//            }
//            
//            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.districtModel.caName,@"districtName",model.raName ,@"communityName",model.raid,@"raid",nil];
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"YPSelectRegionNotification" object:nil userInfo:dict];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            for (UIViewController *temp in weakSelf.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[YPAddAddressController class]]||[temp isKindOfClass:[YPEditAddressController class]]) {
//                    weakSelf.navigationController.navigationBar.hidden=YES;
//                    [weakSelf.navigationController popToViewController:temp animated:YES];
//                }
//            }
//            
//        }];
//        
//    }
//    
//    return _searchViewController;
//    
//}
//
//
//-(NSArray *)communityList{
//    if (_communityList == nil) {
//        _communityList = [NSMutableArray array];
//    }
//    return _communityList;
//}


#pragma mark - 数据相关
//-(void)getAllCommunity{
//    YPGetAllCommunityInDistrictParam  *param = [[YPGetAllCommunityInDistrictParam alloc] init];
//    param.serviceCode = @"700007";
//    param.sessionId=CONF_GET(YP_SessionId);
//    param.isEncrypt = @"0";
//    param.caid = self.districtModel.caid;
//    
//    [YPGetAllCommunityInDistrictHttp getAllCommunityInDistrictHttppWithParam:param success:^(YPGetAllCommunityInDistrictResult *result) {
//        if (result.code.intValue == 0) {
//            [self.communityList addObjectsFromArray:result.areaList];
//        }else{
//            [SVProgressHUD showInfoWithStatus:result.msg];
//        }
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不给力!"];
//        [self.tableView reloadData];
//    }];
//    
//}
//


#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.tableView.tableHeaderView = self.searchBar1;
    
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    
    
}

-(void)setupSearchBar{
    
//    UIView *searchBar = [[UIView alloc] init];
//    searchBar.backgroundColor =  RGBCOLOR(245, 245, 245);
//    [self.view addSubview:searchBar];
//    self.searchBar = searchBar;
//    
//    searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
//    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = RGBCOLOR(240, 240, 240);
//    [self.searchBar addSubview:lineView];
//    
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn.backgroundColor = [UIColor whiteColor];
//    
//    
//    UIImage *yuyinImage = [UIImage imageNamed:@"MCSearch"];
//    [searchBtn setImage:yuyinImage forState:UIControlStateNormal];
//    [searchBtn setImage:yuyinImage forState:UIControlStateSelected];
//    [searchBtn setImage:yuyinImage forState:UIControlStateHighlighted];
//    //top left bottom right
//    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
//    
//    NSString *soundButtonTitle = @"搜索";
//    [searchBtn setTitle:soundButtonTitle forState:UIControlStateNormal];
//    [searchBtn setTitle:soundButtonTitle forState:UIControlStateSelected];
//    [searchBtn setTitle:soundButtonTitle forState:UIControlStateHighlighted];
//    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
//    [searchBtn setTitleColor:RGBCOLOR(184, 184, 187) forState:UIControlStateNormal];
//    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    
//    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)]; //4个参数是上边界，左边界，下边界，右边界。
//    
//    searchBtn.frame = CGRectMake(0, 0, 200, 30);
//    [searchBtn.layer setMasksToBounds:YES];
//    [searchBtn.layer setCornerRadius:5.0];
//    //设置矩形四个圆角半径
//    [searchBtn.layer setBorderWidth:0.2];
//    //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
//    [searchBtn.layer setBorderColor:colorref];
//    [searchBtn addTarget:self action:@selector(didClicekedReturnWithKey:) forControlEvents:UIControlEventTouchUpInside];
//    [self.searchBar addSubview:searchBtn];
//    
//    
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.searchBar);
//        make.height.mas_equalTo(@1);
//        make.top.right.equalTo(self.searchBar);
//    }];
//    
//    
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView.mas_bottom).with.offset(5);
//        make.left.equalTo(self.searchBar).with.offset(10);
//        make.right.equalTo(self.searchBar).with.offset(-10);
//        make.height.mas_equalTo(@30);
//    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
        if (self.moreTranitArray.count)
        {
            NSMutableArray * mesageArray = [NSMutableArray array];
            for (NSDictionary * dic  in self.moreTranitArray)
            {
                [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",_userId] completion:^(MTTGroupEntity *group) {
                    MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
                    session.lastMsg=@" ";
                    self.mouble.MTTSessionEntity = session;
                    self.tranmitStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                   NSString * contentType = [NSString stringWithFormat:@"%@",dic[@"contentType"]];
                    
                    DDMessageContentType msgContentType;
                    switch (contentType.intValue) {
                        case 0:
                            self.display_type = @"1";
                            msgContentType = DDMessageTypeText;
                            break;
                        case 1:
                            self.display_type = @"2";
                            msgContentType = DDMessageTypeImage;
                            break;
                        case 2:
                            self.display_type = @"3";
                            msgContentType = DDMessageTypeVoice;
                            break;
                        case 3:
                            self.display_type = @"";
                            msgContentType = DDMEssageEmotion;
                            break;
                        case 4:
                            self.display_type = @"6";
                            msgContentType = DDMEssagePersonalaCard;
                            break;
                        case 5:
                            self.display_type = @"8";
                            msgContentType = DDMEssageMyApply;
                            break;
                        case 6:
                            self.display_type = @"9";
                            msgContentType = DDMEssageMyWant;
                            break;
                        case 7:
                            self.display_type = @"10";
                            msgContentType = DDMEssageMuchMyWantAndApply;
                            break;
                        case 8:
                            self.display_type = @"11";
                            msgContentType = DDMEssageSHuoShuo;
                            break;
                        case 9:
                            self.display_type = @"7";
                            msgContentType = DDMEssageLitterVideo;
                            break;
                        default:
                            break;
                            
                    }
                    NSString * contentStr = [self getStringFromDic:self.tranmitStr];
                    MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble MsgType:msgContentType];
                    
//                    if ([message.toUserID isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:message];
//                    }
                    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                        DDLog(@"消息插入DB成功");
                    } failure:^(NSString *errorDescripe) {
                        DDLog(@"消息插入DB失败");
                    }];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
                    message.msgContent = contentStr;
                    [self sendMessage:self.tranmitStr messageEntity:message];
                }];
            }
            
//                MTTMessageEntity * message = mesageArray[0];
//                if ([message.toUserID isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:mesageArray];
//                }
        }
        else
        {
            [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",_userId] completion:^(MTTGroupEntity *group) {
                MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
                session.lastMsg=@" ";
                self.mouble.MTTSessionEntity = session;
                
                DDMessageContentType msgContentType;
                switch (self.display_type.intValue) {
                    case 1:
                        msgContentType = DDMessageTypeText;
                        break;
                    case 2:
                        msgContentType = DDMessageTypeImage;
                        break;
                    case 3:
                        msgContentType = DDMessageTypeVoice;
                        break;
                    case 6:
                        msgContentType = DDMEssagePersonalaCard;
                        break;
                    case 7:
                        msgContentType = DDMEssageLitterVideo;
                        break;
                    case 8:
                        msgContentType = DDMEssageMyApply;
                        break;
                    case 9:
                        msgContentType = DDMEssageMyWant;
                        break;
                    case 10:
                        msgContentType = DDMEssageMuchMyWantAndApply;
                        break;
                    case 11:
                        msgContentType = DDMEssageSHuoShuo;
                        break;
                    default:
                        break;
                }
                
                NSString * contentStr = [self getStringFromDic:self.tranmitStr];
                
                MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble MsgType:msgContentType];
                
                if ([message.toUserID isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:message];
                }
                [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                    DDLog(@"消息插入DB成功");
                } failure:^(NSString *errorDescripe) {
                    DDLog(@"消息插入DB失败");
                }];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
                //将字符串消息转换成字典
                //        NSString * contentStr = [self getStringFromDic:[NSString stringWithFormat:@"%@",message.msgContent]];
                message.msgContent = contentStr;
                [self sendMessage:self.tranmitStr messageEntity:message];
            }];

        }
        NSArray * viewArray = self.navigationController.viewControllers;
        [self.navigationController popToViewController:viewArray[viewArray.count-4] animated:YES];
    }
//    NSArray * viewArray = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:viewArray[viewArray.count-4] animated:YES];
}
-(void)sendMessage:(NSString *)msg messageEntity:(MTTMessageEntity *)message
{
    BOOL isGroup = [self.mouble.MTTSessionEntity isGroup];
    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:self.mouble.MTTSessionEntity  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToPersonSuccess" object:nil]; 
            
        });
    } Error:^(NSError *error) {
        [self.tableView reloadData];
    }];
}



-(NSString *)getStringFromDic:(NSString*)contentStr
{
    NSDictionary  * dictionary = [NSDictionary dictionary];
    if ([self.display_type isEqualToString:@"6"]||[self.display_type isEqualToString:@"8"]||[self.display_type isEqualToString:@"9"]||[self.display_type isEqualToString:@"11"]||[self.display_type isEqualToString:@"10"])
    {
        NSData * data = [self.tranmitStr dataUsingEncoding:NSUTF8StringEncoding];
        dictionary = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    NSDictionary * dic = @{@"display_type":self.display_type,@"content":dictionary.count?dictionary:contentStr};
    NSError * erreo = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&erreo];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long index = indexPath.section;
    switch (index) {
        case 0:{
            if (self.isFromTrnmit)
            {
              WPPhoneBookGroupCell *cell = [WPPhoneBookGroupCell cellWithTableView:self.tableView];
                cell.sumBtn.hidden = YES;
              return cell;
            }
            else
            {
              WPPhoneBookGroupCell *cell = [WPPhoneBookGroupCell cellWithTableView:self.tableView];
              WPPhoneBookGroupModel *model = [[WPPhoneBookGroupModel alloc] init];
              model.group_name = @"职场群组";
              model.group_icon = [UIImage imageNamed:@"wdqz_zhichangqunzu"];
              cell.model = model;
              cell.sumBtn.hidden = YES;
              if (self.isCreateChat) {
                cell.hidden = YES;
             }
                return cell;
            }
            
            break;
        }
        case 1:{
            WPPhoneBookGroupCell *cell = [WPPhoneBookGroupCell cellWithTableView:self.tableView];
            NSArray *modelArr = self.dataSource.mycreated.count == 0 ? self.dataSource.myjoin :
            self.dataSource.mycreated;
            WPPhoneBookGroupModel *model = modelArr[indexPath.row];
            cell.model = model;
            cell.sumBtn.hidden = NO;
            return cell;
            break;
        }

        case 2:{
            WPPhoneBookGroupCell *cell = [WPPhoneBookGroupCell cellWithTableView:self.tableView];
            NSArray *modelArr = self.dataSource.myjoin;
            WPPhoneBookGroupModel *model = modelArr[indexPath.row];
            cell.model = model;
            cell.sumBtn.hidden = NO;
            return cell;
            break;
        }
            
        default:
            return nil;
            break;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isFromTrnmit)
    {
        _choiseIndex = indexPath;
        NSString * nsmaStr = [NSString string];
        long index = indexPath.section;
        switch (index) {
            case 1:
            {
                NSArray *modelArr = self.dataSource.mycreated.count == 0 ? self.dataSource.myjoin :
                self.dataSource.mycreated;
                WPPhoneBookGroupModel *model = modelArr[indexPath.row];
                nsmaStr = model.group_name;
                _userId = model.g_id;
            }
                break;
            case 2:
            {
                NSArray *modelArr = self.dataSource.myjoin;
                WPPhoneBookGroupModel *model = modelArr[indexPath.row];
                nsmaStr = model.group_name;
                _userId = model.g_id;
            }
                break;
            default:
                break;
        }
        NSString * nickNaem = [NSString stringWithFormat:@"%@",nsmaStr];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定发送给%@",nickNaem] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
      
    switch (indexPath.section) {
        case 0:{
            WPDynamicGroupViewController *DynamicGroup = [[WPDynamicGroupViewController alloc] init];
            [self.navigationController pushViewController:DynamicGroup animated:YES];
            break;
        }
        case 1:{
            NSArray *modelArr = self.dataSource.mycreated.count == 0 ? self.dataSource.myjoin :
            self.dataSource.mycreated;
            WPPhoneBookGroupModel *model = modelArr[indexPath.row];
//            NSLog(@"group_%@",model.g_id);
//            MTTGroupEntity *group1 = [[DDGroupModule instance] getGroupByGId:[@"group_" stringByAppendingString:model.g_id]];
//            NSLog(@"###%@",group1);
            
            [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",model.g_id] completion:^(MTTGroupEntity *group) {
                MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
                session.lastMsg=@" ";
//                [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
//                    
//                }];
//                [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
//    
//                }];
                [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
                //                    [[ChattingMainViewController shareInstance].module.showingMessages removeAllObjects];
                [ChattingMainViewController shareInstance].title=group.name;
                [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
//                [[SessionModule instance] addToSessionModel:session];
//                if ([SessionModule instance].delegate && [[SessionModule instance].delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
//                    [[SessionModule instance].delegate sessionUpdate:session Action:ADD];
//                }
            }];
            
            break;
        }
        case 2:{
            NSArray *modelArr = self.dataSource.myjoin;
            WPPhoneBookGroupModel *model = modelArr[indexPath.row];
            [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",model.g_id] completion:^(MTTGroupEntity *group) {
                MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
                [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
                [ChattingMainViewController shareInstance].title=group.name;
                [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
            }];

            break;
        }
        default:
            break;
    }

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.dataSource.mycreated.count == 0 ? self.dataSource.mycreated.count : self.dataSource.mycreated.count;
//            return self.dataSource.mycreated.count == 0 ? self.dataSource.myjoin.count : self.dataSource.mycreated.count;
            break;
        case 2:
            return self.dataSource.myjoin.count;
            break;
            
        default:
            return 0;
            break;
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
        if (self.dataSource.mycreated.count == 0&& self.dataSource.myjoin.count == 0) {
            return 1;
        }else if(self.dataSource.mycreated.count != 0&& self.dataSource.myjoin.count != 0){
            return 3;
        }else if (self.dataSource.mycreated.count == 0 && self.dataSource.myjoin.count != 0){
            return 3;//2
        }else if (self.dataSource.mycreated.count != 0 && self.dataSource.myjoin.count == 0){
            return 3;//2
        }else{
            return 1;
        }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.isCreateChat || self.isFromTrnmit) {
            return 0;
        } else {
            return kHEIGHT(50);
        }
    }
    return kHEIGHT(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(20))];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, kHEIGHT(20))];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:kHEIGHT(10)]];
        [view addSubview:label];
        label.text = @"我创建的群";
        label.textColor = RGB(127, 127, 127);
        label.font = kFONT(12);
        return view;
    }else if(section == 2 ){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(20))];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, kHEIGHT(20))];
//        label.opaque = NO;
//        label.backgroundColor = [UIColor redColor];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:kHEIGHT(10)]];
        [view addSubview:label];
        label.text = @"我加入的群";
        label.textColor = RGB(127, 127, 127);
        label.font = kFONT(12);
        return view;
    }else{
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(20))];
//        view.backgroundColor = RGB(235, 235, 235);
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH, kHEIGHT(20))];
////        label.opaque = NO;
//        label.backgroundColor = [UIColor redColor];
//        [label setFont:[UIFont systemFontOfSize:kHEIGHT(10)]];
//        [view addSubview:label];
//        
//        
//        switch (section) {
//            case 0:
//                label.text = @"";
//                break;
//            case 1:
//                label.text =  self.dataSource.mycreated.count !=0 ? @"我创建的群" : @"我加入的群";
//                break;
//            case 2:
//                label.text =  @"我加入的群";
//                break;
//                
//            default:
//                label.text =  @"";
//                break;
//        }
//        
//        
//        label.textColor = RGB(127, 127, 127);
//        label.font = kFONT(12);
        return nil;

    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0.1;
//    }
//    if (section == 1 && self.dataSource.myjoin.count == 0) {
//        return 0;
//    }else if(section == 2 && self.dataSource.mycreated.count == 0){
//        return 0;
//    }
    
    
    
    if (section == 0) {
        return 0.1;
    }
    
    
    if (section == 1 && self.dataSource.mycreated.count == 0) {
        return 0;
    }else if(section == 2 && self.dataSource.myjoin.count == 0){
        return 0;
    }
    
    return kHEIGHT(20);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将分割线拉伸到屏幕的宽度
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark 搜索的代理
 - (void)didClicekedReturnWithKey:(NSString *)key
{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    //展示搜索控制器
    [self.searchViewController.resultSource removeAllObjects];
    [self.searchViewController.tableView reloadData];
    self.searchViewController.searchView.text = nil;
    [self.searchViewController.searchView becomeFirstResponder];
    self.searchViewController.cancelColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:self.searchViewController animated:YES];
    
}
//点击取消按钮
- (void)searchViewController:(MCSearchViewController *)searchViewController didClickedSearchCancelButton:(UIButton *)button
{
    self.navigationController.navigationBarHidden = NO;
    self.searching = NO;
}

//点击搜索按钮
- (void)searchViewController:(MCSearchViewController *)searchViewController didClickedSearchReturnWithKey:(NSString *)key
{
    self.searching = YES;
    // 直接拿到key来遍历
    for (int i = 0;i < self.dataSource.myjoin.count; i ++) {
        NSString * str = [self.dataSource.myjoin[i] group_name];
        if([str rangeOfString:key].location !=NSNotFound){
            [self.searchViewController.resultSource removeAllObjects];
            [self.searchViewController.resultSource addObject:self.dataSource.myjoin[i]];
            [self.searchViewController.tableView reloadData];
        }else{
        }
    }
    for (int i = 0;i < self.dataSource.mycreated.count; i ++) {
        NSString * str = [self.dataSource.mycreated[i] group_name];
        if([str rangeOfString:key].location !=NSNotFound){
            [self.searchViewController.resultSource removeAllObjects];
            [self.searchViewController.resultSource addObject:self.dataSource.mycreated[i]];
            [self.searchViewController.tableView reloadData];
        }else{
        }
    }
    
    
}



@end
