//
//  WPPhoneBookSettingSwitchController.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈设置
//

#import "WPPhoneBookSettingSwitchController.h"
#import "WPDontSeeWorkShopHttp.h"
#import "WPDonLetHeSeeWorkShopHttp.h"
#import "WPDragIntoBlackListCell.h"
#import "WPPhonebookSwitchCell.h"

@interface WPPhoneBookSettingSwitchController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) WPGetFriendInfoResult *result;

@end

@implementation WPPhoneBookSettingSwitchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSettingInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话题设置";
    [self initNav];
    [self loadTableView];
  
    
}

#pragma mark - 数据相关
-(void)dontSeeHisWorkShop:(id)sender{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPDontSeeWorkShopParam *param = [[WPDontSeeWorkShopParam alloc] init];
    param.action = @"AddDontSeeCircleToHe";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    UISwitch* control = (UISwitch*)sender;

    if (control.isOn == YES) {
        param.type = @"1";
    }else{
        param.type = @"0";
        
    }
    param.friend_id = self.friendID;
    
    
    [WPDontSeeWorkShopHttp WPDontSeeWorkShopHttpWithParam:param success:^(WPDontSeeWorkShopResult *result) {
        if (result.status.intValue == 0) {
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

-(void)dontLetHeSee:(id)sender{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPDonLetHeSeeWorkShopParam *param = [[WPDonLetHeSeeWorkShopParam alloc] init];
    param.action = @"AddDontSeeCircleFromHe";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    
    UISwitch* control = (UISwitch*)sender;
    if (control.isOn == YES)
    {
        param.type = @"1";
    }else{
        param.type = @"0";
    }
   
    param.friend_id = self.friendID;
    
    
    [WPDonLetHeSeeWorkShopHttp WPDonLetHeSeeWorkShopHttpWithParam:param success:^(WPDonLetHeSeeWorkShopResult *result) {
        if (result.status.intValue == 0) {

        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 好友类别
-(void)loadTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}


#pragma mark - 数据源,代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    return view;
}

/**
 *  每一行显示怎样的cell
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            WPPhonebookSwitchCell *cell= [WPPhonebookSwitchCell cellWithTableView:tableView];
            cell.titleLbl.text = @"不让他(她)看我的话题";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self.result.is_fcircle isEqualToString:@"1"]) {
                [cell.switchView setOn:YES];
            }else{
                [cell.switchView setOn:NO];
            }
            [cell.switchView addTarget: self action:@selector(dontLetHeSee:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }else{
            WPPhonebookSwitchCell *cell= [WPPhonebookSwitchCell cellWithTableView:tableView];
            cell.titleLbl.text = @"不看他(她)的话题";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self.result.is_circle isEqualToString:@"1"]) {
                [cell.switchView setOn:YES];
            }else{
                [cell.switchView setOn:NO];
            }
            [cell.switchView addTarget:self action:@selector(dontSeeHisWorkShop:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark - 数据相关
-(void)getSettingInfo{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendInfoParam *param = [[WPGetFriendInfoParam alloc] init];
    param.action = @"userinfo";
    param.friend_id = self.friendID;
    param.user_id = userInfo[@"userid"];
    
    [WPGetFriendInfoHttp WPGetFriendInfoHttpWithParam:param success:^(WPGetFriendInfoResult *result) {
        self.result = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
}




@end
