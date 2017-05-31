//
//  PersonalInfoViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/12/31.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "MessagePersonalModel.h"
#import "FirstMessagePersonalCell.h"
#import "SecondMessagePersonalCell.h"
#import "ThirdMessagePersonalCell.h"
#import "PersonalFriendViewController.h"
#import "PersonalHomepageController.h"
//#import "XHDemoWeChatMessageTableViewController.h"
#import "SPAlert.h"
#import "NearPersonalController.h"
#import "DetailsViewController.h"
#import "WPMessageController.h"
#import "WPMainController.h"
#import "WPPhoneBookFriendSettingController.h"
#import "WPFriendListByCategoryController.h"
#import "WPStrangerSettingController.h"
#import "WPAddNewFriendValidateController.h"
#import "CollectViewController.h"
#import "WPDragIntoBlackListHttp.h"
#import "WPGetFriendInfoHttp.h"
#import "ReportViewController.h"
#import "WPReplyValidateMsgCell.h"
#import "WPReplyValidateMsgHttp.h"
#import "WPUpdateFriendStatusHttp.h"
#import "CCAlertView.h"
#import "WPPersonInfoFremarkSettedCell.h"
#import "NewHomePageViewController.h"
#import "WPPersonalSetBlackListController.h"
#import "WPAddNewFriendHttp.h"
#import "WPIsFriendJusticeHttp.h"
#import "ChattingMainViewController.h"
#import "MTTSessionEntity.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "WPBlackNameModel.h"
#import "MTTUserEntity.h"
#import "DDUserModule.h"
#import "MTTMessageEntity.h"
#import "MTTDatabaseUtil.h"
#import "WPSetMessageType.h"
@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *titlesOther;
@property (nonatomic, strong) MessagePersonalModel *personalModel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *attentionBtn;

@property (nonatomic, strong) WPGetFriendInfoResult *result;

@property (nonatomic, strong) UIButton *blackListBtn;
@property (nonatomic, assign) BOOL isSendMessageOrNot;//是否需要发消息


@end

@implementation PersonalInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getSettingInfo];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.title.length) {
       self.title = @"个人资料";
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    self.icons = @[@"personal_apply",@"personal_invite",@"personal_activity"];
    
    if ([self.friendID isEqualToString:kShareModel.userId]) {
        self.titles = @[@"我的求职",@"我的招聘"];
    }
    else
    {
      self.titles = @[@"他的求职",@"他的招聘"];
    }
    
    //self.titles = @[@"他的求职",@"他的招聘"];
    if ([self.friendID isEqualToString:kShareModel.userId]) {
        self.titlesOther = @[@"我的求职",@"我的招聘"];
    }
    else
    {
      self.titlesOther = @[@"她的求职",@"她的招聘"];
    }
    
    [self requestData];
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:DDNotificationReceiveMessage object:nil];
}
//在当前界面收到发送来的接受消息时刷新数据
-(void)receiveMessage:(NSNotification *)notice{
    MTTMessageEntity * message = notice.object;
    if ([message.senderId isEqualToString:[NSString stringWithFormat:@"user_%@",self.friendID]])
    {
        if (message.msgContentType == DDMEssageAcceptApply) {
            self.newType = NewRelationshipTypeFriend;
            [self.tableView reloadData];
            if (self.acceptFriends) {
                self.acceptFriends(self.ccindex);
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    if ([self.friendID isEqualToString:kShareModel.userId]||self.newType == NewRelationshipTypeAccept) {//这里判断是不是自己点击查看自己的资料|| 接受的情况也是隐藏
        
    }else{
        if (self.isFromChat)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(clickSendeCard:)];
        }
        else
        {
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
        }
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    }
}
#pragma mark  点击发送名片
-(void)clickSendeCard:(UIButton*)sender
{
//MessagePersonalModel
    NSDictionary *dic = @{@"nick_name":self.personalModel.nick_name,
                          @"avatar":self.personalModel.avatar,
                          @"wp_id":self.personalModel.wp_id,
                          @"user_id":self.personalModel.uid,
                          @"to_name":@"",
                          @"from_name":@"",
                          @"company":self.personalModel.company.length?self.personalModel.company:@"",
                          @"position":self.personalModel.position.length?self.personalModel.position:@""};
    
    NSArray * array = @[dic];
    [[ChattingMainViewController shareInstance] sendePersonalCard:array];
    NSArray * viewArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:viewArray[viewArray.count-3] animated:YES];
    
}
-(void)backToFromVC{
    if (self.skipType) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[WPFriendListByCategoryController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestData
{
   
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"userinfo";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"friend_id"] = self.friendID;
    NSLog(@"<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"***%@",json);
        
       
        
        MessagePersonalModel *model = [MessagePersonalModel mj_objectWithKeyValues:json];
        self.personalModel = model;
        [self.tableView reloadData];
        if (!json) {
            [[MTTDatabaseUtil instance] getOneLinkMan:self.friendID success:^(NSArray *array) {
                if (array.count) {
                    NSDictionary * dic = array[0];
                    MessagePersonalModel * model1 = [[MessagePersonalModel alloc]init];
                    model1.avatar = dic[@"avatar"];
                    model1.position = dic[@"position"];
                    model1.company = dic[@"company"];
                    model1.nick_name = dic[@"nick_name"];
                    model1.fremark = dic[@"post_remark"];
                    model1.uid = dic[@"friend_id"];
                    self.personalModel = model1;
                    [self.tableView reloadData];
                }
            }];
        }
        
        
        
       
        //判断和本地是否一样
    [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%@",model.uid] Block:^(MTTUserEntity *user) {
        if (!user) {//本地不存在时直接保存
            
            MTTUserEntity * use = [[MTTUserEntity alloc]initWithUserID:self.personalModel.uid name:self.personalModel.className nick:self.personalModel.nick_name avatar:self.personalModel.avatar userRole:0 userUpdated:0];
            
            [[DDUserModule shareInstance] addMaintanceUser:use];
            [[MTTDatabaseUtil instance] insertAllUser:@[use] completion:^(NSError *error) {
                
            }];
            return ;
        }
            if (![user.nick isEqualToString:model.nick_name] || ![user.avatar isEqualToString:model.avatar]) {
                user.nick = model.nick_name;
                user.avatar = model.avatar;
                 [[DDUserModule shareInstance] addMaintanceUser:user];
                [[MTTDatabaseUtil instance] insertAllUser:@[user] completion:^(NSError *error) {
                }];
            }
        }];
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getOneLinkMan:self.friendID success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = array[0];
                MessagePersonalModel * model1 = [[MessagePersonalModel alloc]init];
                model1.avatar = dic[@"avatar"];
                model1.position = dic[@"position"];
                model1.company = dic[@"company"];
                model1.nick_name = dic[@"nick_name"];
                model1.fremark = dic[@"post_remark"];
                model1.uid = dic[@"friend_id"];
                self.personalModel = model1;
                [self.tableView reloadData];
            }
        }];
    }];

}

#pragma mark - 数据相关
-(void)replyValidateMsgWithContent:(NSString *)content{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPReplyValidateMsgParam *param = [[WPReplyValidateMsgParam alloc] init];
    param.action = @"Reply";
    param.friend_id = self.friendID;
    param.user_id = userInfo[@"userid"];
    param.username = model.username;
    param.password = model.password;
   
    if (content.length > 30) {
         NSString *newCon = [content substringToIndex:30];
         param.v_content  = [NSString stringWithFormat:@"%@...",newCon];
    }else{
        param.v_content = content;
    }

    
    [WPReplyValidateMsgHttp WPReplyValidateMsgHttpWithParam:param success:^(WPReplyValidateMsgResult *result) {
        if (result.status.intValue == 0) {
            [self getSettingInfo];
            
            //推送消息
            WPSetMessageType * type = [[WPSetMessageType alloc]init];
            [type sendNotificationMessage:kShareModel.nick_name user:self.friendID];
            
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD createHUD:@"网络不给力,请稍后再试" View:self.view];
    }];
    
    
}



-(void)getSettingInfo{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendInfoParam *param = [[WPGetFriendInfoParam alloc] init];
    param.action = @"userinfo";
    param.friend_id = self.friendID;
    param.user_id = userInfo[@"userid"];
    if ([self.comeFromVc isEqualToString:@"黑名单"]) {
        param.indexPage = @"1";
    }
    [WPGetFriendInfoHttp WPGetFriendInfoHttpWithParam:param success:^(WPGetFriendInfoResult *result) {
        self.result = result;
        [self.tableView reloadData];
        if ([self.comeFromVc isEqualToString:@"添加手机好友"]) {
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.result.uid,@"UserId",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onlyShowOneTimeWaitValidate" object:self userInfo:dict];
        }
    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"网络不给力,请稍后再试"];
        [MBProgressHUD createHUD:@"网络不给力,请稍后再试" View:self.view];
    }];
}

-(void)isFriend{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSDictionary * dic = @{@"action":@"AddFriend",
                           @"user_id":userInfo[@"userid"],
                           @"username":model.username,
                           @"password":model.password,
                           @"fuser_id":self.friendID,
                           @"post_remark":@"",
                           @"belongGroup":@"",
                           @"is_fcircle":@"Flase",
                           @"is_fjob":@"Flase",
                           @"is_fresume":@"Flase",
                           @"exec":@"1"};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/friend.ashx",IPADDRESS];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * is_shield = [NSString stringWithFormat:@"%@",json[@"is_shield"]];
    if (is_shield.intValue)//被加入黑名单
    {
        [MBProgressHUD hideHUDForView:self.view];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"对方拒绝接收你的消息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }
    else
    {
        NSString * is_friend = json[@"is_friend"];
        if (is_friend.intValue)//在对方好友列表里面，添加成功
        {
            if (self.addFriendsSuccess) {
                self.addFriendsSuccess(self.ccindex);
            }
            self.newType = NewRelationshipTypeFriend;
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"添加成功" View:self.view];
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ccindex,@"ccindex",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopNoGoToTop" object:self userInfo:dict];
            //发送消息告诉对方直接添加成功，对方从删除记录中移除
            WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
            [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.personalModel.uid] and:@"3"];
        }
        else//不在对方好友列表里面
        {
            NSString * moshi = json[@"moshi"];
            if (moshi.intValue)//求职招聘模式
            {
                self.newType = NewRelationshipTypeFriend;
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD createHUD:@"添加成功" View:self.view];
                
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ccindex,@"ccindex",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopNoGoToTop" object:self userInfo:dict];
                //发送消息告诉对方直接添加成功，对方从删除记录中移除
                WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
                [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.personalModel.uid] and:@"3"];
                //发送消息提示已添加为好友
                [self sendeMessageToOther:self.personalModel.uid andUser:self.personalModel.nick_name];
            }
             else//正常模式
            {
                [MBProgressHUD hideHUDForView:self.view];
                WPAddNewFriendValidateController *addValidate = [[WPAddNewFriendValidateController alloc] init];
                addValidate.fuser_id = self.personalModel.uid;
                addValidate.name = self.personalModel.nick_name;
                addValidate.friend_mobile = self.personalModel.mobile;
                if ([self.comeFromVc isEqualToString:@"新的好友"])
                {
                    addValidate.needPassIsShow = YES;
                }
                [self.navigationController pushViewController:addValidate animated:YES];
            }
         }
      }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

-(void)isYnaZhengOrNotfriend:(NSString*)friendId success:(void(^)(NSDictionary*))Success
{
    NSDictionary *dic = @{@"action":@"FriendValidate",
                          @"user_id":kShareModel.userId,
                          @"friend_id":friendId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/personal_info_new.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        Success(json);
    } failure:^(NSError *error) {
        Success(nil);
    }];
}


- (void)createBottom
{
    NSArray *titles = @[@"  聊聊",@"  关注",@"  收藏"];
    NSArray *images = @[@"personal_chat",@"personal_attention",@"personal_collect"];
    CGFloat width = SCREEN_WIDTH/3;
    CGFloat y = SCREEN_HEIGHT - kHEIGHT(43);
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, y, width, BOTTOMHEIGHT);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i + 10;
        [button addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_normal.jpg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_highted.jpg"] forState:UIControlStateHighlighted];
        [self.view addSubview:button];
        
        NSString *attStr = [[NSString alloc] init];
        NSString *attImg = [[NSString alloc] init];
        NSString *collectStr = [[NSString alloc] init];
        NSString *collectImg = [[NSString alloc] init];
        
        if ([self.personalModel.isattention isEqualToString:@"0"]) {
            attStr = @" 关注";
            attImg = @"personal_attention";
        } else if ([self.personalModel.isattention isEqualToString:@"1"]) {
            attStr = @" 已关注";
            attImg = @"personal_attentioned";
        } else if ([self.personalModel.isattention isEqualToString:@"2"]) {
            attStr = @" 好友";
            attImg = @"personal_friend";
        }
        
        if ([self.personalModel.isCollection isEqualToString:@"0"]) {
            collectStr = @" 收藏";
            collectImg = @"personal_collect";
        } else if ([self.personalModel.isCollection isEqualToString:@"1"]) {
            collectStr = @" 已收藏";
            collectImg = @"personal_collected";
        }
        
        if (i == 1) {
            self.attentionBtn = button;
//            NSLog(@"%@---%@",attStr,attImg);
            [self.attentionBtn setTitle:attStr forState:UIControlStateNormal];
            [self.attentionBtn setImage:[UIImage imageNamed:attImg] forState:UIControlStateNormal];
        } else if (i == 2) {
            self.collectBtn = button;
            [self.collectBtn setTitle:collectStr forState:UIControlStateNormal];
            [self.collectBtn setImage:[UIImage imageNamed:collectImg] forState:UIControlStateNormal];
        }
        
        if (i != 0) {
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(width*i, (kHEIGHT(43) - 15)/2 + y, 0.5, 15)];
            line2.backgroundColor = RGBColor(178, 178, 178);
            [self.view addSubview:line2];
        }
    }
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, y - 0.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line1];
    
}

#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    self.tableView.tableFooterView.userInteractionEnabled = YES;
    
    
}


//- (UITableView *)tableView{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        
//        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([self.comeFromVc isEqualToString:@"自己判断"]) {
        if ([self.result.fstate isEqualToString:@"0"]) {
            self.newType = NewRelationshipTypeFriend;
        }else{
            self.newType = NewRelationshipTypeStranger;
        }
    }

    if (section == 2) {
        // 判断查看的是否是自己资料， 如果是自己的资料，只显示发消息
        if ([self.friendID isEqualToString:kShareModel.userId]) {
            UIView *footerView = [[UIView alloc] init];
            UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMsg setTitle:@"发消息" forState:UIControlStateNormal];
            sendMsg.titleLabel.font = kFONT(15);
            [sendMsg setBackgroundColor:RGB(0, 172, 255)];
            [sendMsg.layer setMasksToBounds:YES];
            [sendMsg.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [sendMsg setBackgroundImage:[UIImage imageWithColor:RGB(0,147,217)] forState:UIControlStateHighlighted];
            [sendMsg addTarget:self action:@selector(chatting) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:sendMsg];
            
            [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(footerView.mas_top).with.offset(20);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];

            footerView.backgroundColor = [UIColor clearColor];
            return footerView;
        }else if(self.newType == NewRelationshipTypeWaitConfirm){  //等待验证
            UIView *footerView = [[UIView alloc] init];
            UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMsg setTitle:@"添加好友" forState:UIControlStateNormal];
            sendMsg.titleLabel.font = kFONT(15);
            [sendMsg setBackgroundColor:RGB(0, 172, 255)];
            [sendMsg.layer setMasksToBounds:YES];
            [sendMsg.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [sendMsg setBackgroundImage:[UIImage imageWithColor:RGB(0,147,217)] forState:UIControlStateHighlighted];
            [sendMsg addTarget:self action:@selector(addNewFriend) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:sendMsg];
            
            [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(footerView.mas_top).with.offset(20);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            UIButton *videoChat = [UIButton buttonWithType:UIButtonTypeCustom];
            [videoChat setTitle:@"收藏" forState:UIControlStateNormal];
            videoChat.titleLabel.font = kFONT(15);
            [videoChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [videoChat setBackgroundColor:[UIColor whiteColor]];
            [videoChat setBackgroundImage:[UIImage imageWithColor:RGB(226,226,226)] forState:UIControlStateHighlighted];
            [videoChat.layer setMasksToBounds:YES];
            [videoChat.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [videoChat addTarget:self action:@selector(storeUp) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:videoChat];
            
            [videoChat mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(sendMsg.mas_bottom).with.offset(15);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            footerView.backgroundColor = [UIColor clearColor];
            return footerView;
        }else if(self.newType == NewRelationshipTypeStranger){
            UIView *footerView = [[UIView alloc] init];
            UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMsg setTitle:@"添加好友" forState:UIControlStateNormal];
            sendMsg.titleLabel.font = kFONT(15);
            [sendMsg setBackgroundColor:RGB(0, 172, 255)];
            [sendMsg.layer setMasksToBounds:YES];
            [sendMsg.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [sendMsg setBackgroundImage:[UIImage imageWithColor:RGB(0,147,217)] forState:UIControlStateHighlighted];
            [sendMsg addTarget:self action:@selector(addNewFriend) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:sendMsg];
            
            [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(footerView.mas_top).with.offset(20);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            UIButton *videoChat = [UIButton buttonWithType:UIButtonTypeCustom];
            [videoChat setTitle:@"收藏" forState:UIControlStateNormal];
            videoChat.titleLabel.font = kFONT(15);
            [videoChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [videoChat setBackgroundColor:[UIColor whiteColor]];
            [videoChat setBackgroundImage:[UIImage imageWithColor:RGB(226,226,226)] forState:UIControlStateHighlighted];
            [videoChat.layer setMasksToBounds:YES];
            [videoChat addTarget:self action:@selector(storeUp) forControlEvents:UIControlEventTouchUpInside];
            [videoChat.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [footerView addSubview:videoChat];
            
            [videoChat mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(sendMsg.mas_bottom).with.offset(15);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            footerView.backgroundColor = [UIColor clearColor];
            return footerView;
            

        
        }else if(self.newType == NewRelationshipTypeAccept){  // 别人加我接受的情况
            UIView *footerView = [[UIView alloc] init];
            UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMsg setTitle:@"通过验证" forState:UIControlStateNormal];
            sendMsg.titleLabel.font = kFONT(15);
            [sendMsg setBackgroundColor:RGB(0, 172, 255)];
            [sendMsg.layer setMasksToBounds:YES];
            [sendMsg.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [sendMsg setBackgroundImage:[UIImage imageWithColor:RGB(0,147,217)] forState:UIControlStateHighlighted];
            [sendMsg addTarget:self action:@selector(passedValidate) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:sendMsg];
            
            [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(footerView.mas_top).with.offset(20);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            UIButton *videoChat = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([self.result.is_shield isEqualToString:@"0"]) {
                [videoChat setTitle:@"加入黑名单" forState:UIControlStateNormal];
            }else{
                [videoChat setTitle:@"移出黑名单" forState:UIControlStateNormal];
            }
            videoChat.titleLabel.font = kFONT(15);
            [videoChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [videoChat setBackgroundColor:[UIColor whiteColor]];
            [videoChat setBackgroundImage:[UIImage imageWithColor:RGB(226,226,226)] forState:UIControlStateHighlighted];
            [videoChat.layer setMasksToBounds:YES];
            [videoChat addTarget:self action:@selector(blackListBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [videoChat.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            self.blackListBtn = videoChat;
            [footerView addSubview:videoChat];
            
            [videoChat mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sendMsg.mas_bottom).with.offset(15);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(10));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            UIButton *jubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
            jubaoBtn.titleLabel.font = kFONT(15);
            [jubaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [jubaoBtn setBackgroundColor:[UIColor whiteColor]];
            [jubaoBtn setBackgroundImage:[UIImage imageWithColor:RGB(226,226,226)] forState:UIControlStateHighlighted];
            [jubaoBtn.layer setMasksToBounds:YES];
            [jubaoBtn addTarget:self action:@selector(jubaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [jubaoBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [footerView addSubview:jubaoBtn];
            
            [jubaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sendMsg.mas_bottom).with.offset(15);
                make.left.equalTo(videoChat.mas_right).with.offset(kHEIGHT(10));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(10));
                make.height.equalTo(@(kHEIGHT(38)));
                make.width.equalTo(videoChat);
            }];
            

            
            footerView.backgroundColor = [UIColor clearColor];
            return footerView;
            
            
            
        }else{
            NSLog(@"%u",self.newType);
            UIView *footerView = [[UIView alloc] init];
            UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendMsg setTitle:@"发消息" forState:UIControlStateNormal];
            sendMsg.titleLabel.font = kFONT(15);
            [sendMsg setBackgroundColor:RGB(0, 172, 255)];
            [sendMsg.layer setMasksToBounds:YES];
            [sendMsg.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
            [sendMsg setBackgroundImage:[UIImage imageWithColor:RGB(0,147,217)] forState:UIControlStateHighlighted];
            [sendMsg addTarget:self action:@selector(chatting) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:sendMsg];
            
            [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView.mas_centerX);
                make.top.equalTo(footerView.mas_top).with.offset(20);
                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
                make.height.equalTo(@(kHEIGHT(38)));
            }];
            
            UIButton *videoChat = [UIButton buttonWithType:UIButtonTypeCustom];
            [videoChat setTitle:@"视频聊天" forState:UIControlStateNormal];
            videoChat.titleLabel.font = kFONT(15);
            [videoChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [videoChat setBackgroundColor:[UIColor whiteColor]];
            [videoChat setBackgroundImage:[UIImage imageWithColor:RGB(226,226,226)] forState:UIControlStateHighlighted];
            [videoChat.layer setMasksToBounds:YES];
            [videoChat.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//            [footerView addSubview:videoChat];
//            [videoChat mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(footerView.mas_centerX);
//                make.top.equalTo(sendMsg.mas_bottom).with.offset(15);
//                make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
//                make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
//                make.height.equalTo(@(kHEIGHT(38)));
//            }];
            
            footerView.backgroundColor = [UIColor clearColor];
            return footerView;

        }
         
       
    }
    return nil;
}


- (UIView *)footerView
{
    if (_footerView == nil) {
        NSArray *arr = @[@"好友",@"关注",@"粉丝"];
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
        _footerView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i<3; i++) {
            
            if (i!=0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*i,kHEIGHT(43)/2 - 7.5, 0.5,15)];
                line.backgroundColor = RGB(226, 226, 226);
                [_footerView addSubview:line];
            }
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, kHEIGHT(43))];
            button.tag = i + 1;
            [button addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"videoPlaceImage"] forState:UIControlStateHighlighted];
            [_footerView addSubview:button];
            
            CGSize normalSize = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:GetFont(15)}];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHEIGHT(43)/2 - normalSize.height/2, SCREEN_WIDTH/3, normalSize.height)];
            titleLabel.font = kFONT(15);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:titleLabel];
            
            if (i == 0) {
                titleLabel.text = [NSString stringWithFormat:@"%@ ：%@",arr[i],self.personalModel.friends];
            } else if (i == 1) {
                titleLabel.text = [NSString stringWithFormat:@"%@ ：%@",arr[i],self.personalModel.attention];
            } else {
                titleLabel.text = [NSString stringWithFormat:@"%@ ：%@",arr[i],self.personalModel.fans];
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(43) - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_footerView addSubview:line];
    }
    return _footerView;
}

#pragma mark - 右按钮点击事件
- (void)rightBtnClick
{
    if (self.newType == NewRelationshipTypeStranger || self.newType == NewRelationshipTypeWaitConfirm ) {
        WPStrangerSettingController *strangerSet = [[WPStrangerSettingController alloc] init];
        strangerSet.friendId = self.friendID;
        if ([self.comeFromVc isEqualToString:@"黑名单"])
        {
            strangerSet.isFromBlackList = YES;
        }
        strangerSet.pushToBlack= ^(){
            if (self.pushFromBlack) {
                self.pushFromBlack();
            }
        };
        [self.navigationController pushViewController:strangerSet animated:YES];
    }else{
        WPPhoneBookFriendSettingController *friendSetting = [[WPPhoneBookFriendSettingController alloc] init];
        friendSetting.friendID = self.friendID;
        friendSetting.newType = self.newType;
        friendSetting.comeFromVc = self.comeFromVc;
        friendSetting.ccindex = self.ccindex;
        friendSetting.personalModel = self.personalinfoModel;
        friendSetting.refreshData= ^(NSIndexPath*index){
            if (self.refresh)
            {
                self.refresh(self.ccindex);
            }
        };
        [self.navigationController pushViewController:friendSetting animated:YES];
    }
}

#pragma mark - 好友、关注、粉丝
- (void)checkClick:(UIButton *)sender
{
    PersonalFriendViewController *personalFriend = [[PersonalFriendViewController alloc] init];
    personalFriend.friend_id = self.friendID;
    personalFriend.friendRefreshBlock = ^(){
//        [self requestData];
    };
    if (sender.tag == 1) {
//        NSLog(@"好友");
        personalFriend.type = PersonalViewControllerTypeFriend;
    } else if (sender.tag == 2) {
//        NSLog(@"关注");
        personalFriend.type = PersonalViewControllerTypeAttention;
    } else if (sender.tag == 3) {
//        NSLog(@"粉丝");
        personalFriend.type = PersonalViewControllerTypeFans;
    }
    [self.navigationController pushViewController:personalFriend animated:YES];
}

#pragma mark 点击底部的收藏
- (void)functionBtnClick:(UIButton *)sender
{
    if (sender.tag == 10) {
//        NSLog(@"聊聊");
        [self chatting];
    } else if (sender.tag == 11) {
        NSString *title = [sender titleForState:UIControlStateNormal];
        if ([title isEqualToString:@" 关注"]) {
            [self attention];
        } else {
            [SPAlert alertControllerWithTitle:@"提示"
                                      message:@"是否取消关注？"
                              superController:self
                            cancelButtonTitle:@"否" cancelAction:^{
                            
            }
                           defaultButtonTitle:@"是"
                                defaultAction:^{
                                    [self attention];
            }];
        }
    } else if (sender.tag == 12) {
//        NSLog(@"收藏");
        [self collection];
    }
}

#pragma mark - 聊聊

- (void)chatting
{
    MTTSessionEntity* session = [[MTTSessionEntity alloc] initWithSessionID:[@"user_" stringByAppendingString:self.friendID] type:SessionTypeSessionTypeSingle];
    [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
    if ([[self.navigationController viewControllers] containsObject:[ChattingMainViewController shareInstance]]) {
        [ChattingMainViewController shareInstance].isFromPersonal = YES;
        [self.navigationController popToViewController:[ChattingMainViewController shareInstance] animated:YES];
    }else
    {
//        [ChattingMainViewController shareInstance].isFromPersonal = YES;
        [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
    }
}

#pragma mark - 关注
- (void)attention
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = self.friendID;
    params[@"by_nick_name"] = self.personalModel.nick_name;
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@---%@",json,json[@"info"]);
        NSString *attStr = [[NSString alloc] init];
        NSString *attImg = [[NSString alloc] init];
        NSString *status = [NSString stringWithFormat:@"%@",json[@"status"]];
        if ([status isEqualToString:@"0"]) {
            attStr = @" 关注";
            attImg = @"personal_attention";
        } else if ([status isEqualToString:@"1"]) {
            attStr = @" 已关注";
            attImg = @"personal_attentioned";
        } else if ([status isEqualToString:@"2"]) {
            attStr = @" 好友";
            attImg = @"personal_friend";
        }
        [self.attentionBtn setTitle:attStr forState:UIControlStateNormal];
        [self.attentionBtn setImage:[UIImage imageNamed:attImg] forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 收藏

- (void)collection
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/user_collection.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"collection";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"friend_id"] = self.friendID;
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@---%@",json,json[@"info"]);
        NSString *collectStr = [[NSString alloc] init];
        NSString *collectImg = [[NSString alloc] init];
        NSString *status = [NSString stringWithFormat:@"%@",json[@"status"]];
        if ([status isEqualToString:@"0"]) {
            collectStr = @" 收藏";
            collectImg = @"personal_collect";
        } else if ([status isEqualToString:@"1"]) {
            collectStr = @" 已收藏";
            collectImg = @"personal_collected";
        }
        [self.collectBtn setTitle:collectStr forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:collectImg] forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];

}

-(void)addSpecialFriend{  // 之前是好友  现在是单方面删除
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPAddNewFriendParam *param = [[WPAddNewFriendParam alloc] init];
    param.action = @"AddFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.fuser_id = self.personalModel.uid;
    param.friend_mobile = self.personalModel.mobile;
    
    param.is_fjob = @"false";
    param.is_fcircle = @"false";
    param.is_fresume = @"false";
    param.belongGroup = @"";
    if ([self.comeFromVc isEqualToString:@"新的好友"]) {
        param.is_show = @"0";
    }
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WPAddNewFriendHttp WPAddNewFriendHttpWithParam:param success:^(WPAddNewFriendResult *result) {
        if (result.status.intValue == 0) {
            [MBProgressHUD hideHUDForView:self.view];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ccindex,@"ccindex",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopNoGoToTop" object:self userInfo:dict];
            //发送消息告诉对方直接添加成功，对方从删除记录中移除
            WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
            [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.personalModel.uid] and:@"3"];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:result.info View:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD createHUD:@"网络不给力,请稍后再试" View:self.view];
        //[MBProgressHUD showError:@"网络不给力,请稍后再试"];
    }];

}
-(void)sendeMessageToOther:(NSString*)friendId andUser:(NSString*)userName
{

    MTTSessionEntity* session = [[MTTSessionEntity alloc]initWithSessionID:[@"user_" stringByAppendingString:friendId] SessionName:userName type:SessionTypeSessionTypeSingle];
    
    ChattingModule * mouble = [[ChattingModule alloc]init];
    mouble.MTTSessionEntity = session;
    
    NSDictionary * dic = @{@"display_type":@"14",
                           @"content":@{@"from_name":[NSString stringWithFormat:@"%@",kShareModel.nick_name],
                                        @"from_id":kShareModel.userId,
                                        @"to_id":[NSString stringWithFormat:@"%@",friendId],
                                        @"from_type":@"1"}
                           };
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
    NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:mouble MsgType:DDMEssageAcceptApply];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    message.msgContent = cardStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
        });
    } Error:^(NSError *error) {
    }];
}
#pragma mark - 添加好友
-(void)addNewFriend{
    //将好友信息添加到本地
    [[DDUserModule shareInstance] addNewFriend:self.personalModel.mobile];
    //判断好友
    [self isFriend];
}

#pragma mark - 收藏操作
-(void)storeUp{
    CollectViewController *collection = [[CollectViewController alloc] init];
    collection.collect_class = @"8";
    collection.user_id = self.friendID;
    collection.titles = self.personalModel.nick_name;
    collection.wpNumber = [NSString stringWithFormat:@"%@",self.personalModel.wp_id];
    [self.navigationController pushViewController:collection animated:YES];
}
-(void)anotsendeMessageToOther:(NSString*)friendId andUser:(NSString*)userName
{
    //self.isSendMessageOrNot = NO;
    MTTSessionEntity* session = [[MTTSessionEntity alloc]initWithSessionID:[@"user_" stringByAppendingString:friendId] SessionName:userName type:SessionTypeSessionTypeSingle];
    
    ChattingModule * mouble = [[ChattingModule alloc]init];
    mouble.MTTSessionEntity = session;
    
    NSDictionary * dic = @{@"display_type":@"14",
                           @"content":@{@"from_name":userName,
                                        @"from_id":[NSString stringWithFormat:@"%@",kShareModel.userId],
                                        @"to_id":[NSString stringWithFormat:@"%@",friendId],
                                        @"from_type":@"0"}
                           };
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
    NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:mouble MsgType:DDMEssageAcceptApply];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    message.msgContent = cardStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
        });
    } Error:^(NSError *error) {
    }];
}
#pragma mark - 通过验证
-(void)passedValidate{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPUpdateFriendStatusparam *param = [[WPUpdateFriendStatusparam alloc] init];
    param.action = @"Verification";
    param.friend_id = self.friendID;
    param.user_id = userInfo[@"userid"];
    param.VerState = @"0";
    param.username = model.username;
    param.password = model.password;
    
    [WPUpdateFriendStatusHttp WPUpdateFriendStatusHttpWithParam:param success:^(WPUpdateFriendStatusResult *result) {
        if (result.status.intValue == 0) {
            [MBProgressHUD createHUD:@"添加成功" View:self.view];
            self.newType = NewRelationshipTypeFriend;
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
            //从本地移除添加的黑名单
            WPBlackNameModel * model1 = [[WPBlackNameModel alloc]init];
            model1.userId = [NSString stringWithFormat:@"user_%@",self.friendID];
            [[MTTDatabaseUtil instance] removeFromBlackName:@[model1] completion:^(BOOL success) {
            }];
            //发送消息，从对方的数据库中删除黑名单
            WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
            [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"3"];
//              [self sendeMessageToOther:self.friendID andUser:nil];
            [self anotsendeMessageToOther:self.friendID andUser:self.personalModel.nick_name];
            
            if (self.acceptFriends) {
                self.acceptFriends(self.ccindex);
            }
            
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
        
    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"网络不给力,请稍后再试"];
        [MBProgressHUD createHUD:@"网络不给力,请稍后再试" View:self.view];
    }];

}

#pragma mark - 举报 加入黑名单请求
-(void)jubaoBtnClick{
    ReportViewController *jubao = [[ReportViewController alloc] init];
    jubao.speak_trends_id = self.friendID;
    [self.navigationController pushViewController:jubao animated:YES];
}

-(void)blackListBtnClick{
   if([self.blackListBtn.titleLabel.text isEqualToString:@"加入黑名单"]){//加入黑名单
        // 更新界面
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"" message:@"确认将该好友加入黑名单？"];
        [alert addBtnTitle:@"取消" action:^{
           return ;
        }];
        [alert addBtnTitle:@"确定" action:^{
            WPShareModel *model = [WPShareModel sharedModel];
            NSMutableDictionary *userInfo = model.dic;
            WPDragIntoBlackListParam *param = [[WPDragIntoBlackListParam alloc] init];
            param.action = @"AddBlack";
            param.username = model.username;
            param.password = model.password;
            param.user_id = userInfo[@"userid"];
            param.friend_id = self.friendID;
            
            [WPDragIntoBlackListHttp WPDragIntoBlackListHttpWithParam:param success:^(WPDragIntoBlackListResult *result) {
                if (result.status.intValue == 1) {
                    //发送消息已被加入黑名单
                    [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"0"];
                    // 不要提醒
                    if ([self.blackListBtn.titleLabel.text isEqualToString:@"移出黑名单"]) {
                        [self.blackListBtn setTitle:@"加入黑名单" forState:UIControlStateNormal];
                    }else if([self.blackListBtn.titleLabel.text isEqualToString:@"加入黑名单"]){
                        [self.blackListBtn setTitle:@"移出黑名单" forState:UIControlStateNormal];
                    }
                }else{
                    [MBProgressHUD showError:result.info];
                }
            } failure:^(NSError *error) {
//                [MBProgressHUD showError:@"网络不给力,请稍后再试"];
                [MBProgressHUD createHUD:@"网络不给力,请稍后再试" View:self.view];
            }];
        }];
        [alert showAlertWithSender:self];
        
   }else{//移除黑名单
       WPShareModel *model = [WPShareModel sharedModel];
       NSMutableDictionary *userInfo = model.dic;
       WPDragIntoBlackListParam *param = [[WPDragIntoBlackListParam alloc] init];
       param.action = @"ReBlack";
       param.username = model.username;
       param.password = model.password;
       param.user_id = userInfo[@"userid"];
       param.friend_id = self.friendID;
       [WPDragIntoBlackListHttp WPDragIntoBlackListHttpWithParam:param success:^(WPDragIntoBlackListResult *result) {
           if (result.status.intValue == 1) {
               //发送消息已被移除黑名单
               [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"1"];
               // 不要提醒
               if ([self.blackListBtn.titleLabel.text isEqualToString:@"移出黑名单"]) {
                   [self.blackListBtn setTitle:@"加入黑名单" forState:UIControlStateNormal];
               }else if([self.blackListBtn.titleLabel.text isEqualToString:@"加入黑名单"]){
                   [self.blackListBtn setTitle:@"移出黑名单" forState:UIControlStateNormal];
               }
           }else{
               [MBProgressHUD showError:result.info];
           }
       } failure:^(NSError *error) {
//           [MBProgressHUD showError:@"网络不给力,请稍后再试"];
           [MBProgressHUD createHUD:@"网络不给力,请稍后再试" View:self.view];
       }];

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

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.FriendVC isEqualToString:@"1"]) {  //表示是在新的好友页面
        if (self.newType == NewRelationshipTypeAccept || self.newType == NewRelationshipTypeWaitConfirm) {
            if (section == 0) {
                return 2;
            } else if (section == 1) {
                return 1;
            } else {
                return 2;
            }

        }else{
            if (section == 0) {
                return 1;
            } else if (section == 1) {
                return 1;
            } else {
                return 2;
            }
        }
    }else{
        if (section == 0 ) {//&& [self.FriendVC isEqualToString:@"1"]
            return 1;
        } else if (section == 1) {
            return 1;
        } else {
            return 2;
        }
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ((self.newType == NewRelationshipTypeAccept ||self.newType == NewRelationshipTypeWaitConfirm)) { // 现在只有新的好友页面进入 需要显示回复消息之类的；
            if (indexPath.row == 0) {
                FirstMessagePersonalCell *cell = [FirstMessagePersonalCell cellWithTableView:tableView];
                if (self.personalModel) {
                    cell.model = self.personalModel;
                }
                return cell;
            }else{//回复消息
                WPReplyValidateMsgCell *cell = [WPReplyValidateMsgCell cellWithTableView:tableView];
                cell.replyBlock = ^(NSString *replytext){
                    if (replytext.length == 0||replytext == nil) {
                        [MBProgressHUD createHUD:@"回复消息不能为空" View:self.view];
                        return;
                    }else{//发送消息
                        replytext = [replytext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSString * replay = [replytext stringByReplacingOccurrencesOfString:@" " withString:@""];
                        [self replyValidateMsgWithContent:replay];
                    }
                };
                cell.msgArray = self.result.replyList;
                return cell;
            }
            
        }else{
            if (self.personalModel.fremark.length >0) {
                WPPersonInfoFremarkSettedCell *cell = [[WPPersonInfoFremarkSettedCell alloc] init];
                if (self.personalModel) {
                    cell.model = self.personalModel;
                }
                return cell;
            }else{
                FirstMessagePersonalCell *cell = [FirstMessagePersonalCell cellWithTableView:tableView];
                if (self.personalModel) {
                    cell.model = self.personalModel;
                }
                return cell;
            }
        }
    } else if (indexPath.section == 1) {
        SecondMessagePersonalCell *cell = [SecondMessagePersonalCell cellWithTableView:tableView];
        cell.model = self.personalModel;
        return cell;
    } else {
        ThirdMessagePersonalCell *cell = [ThirdMessagePersonalCell cellWithTableView:tableView];
        NSArray *titles = [self.personalModel.sex isEqualToString:@"男"] ? self.titles:self.titlesOther;
        cell.iconImage.image = [UIImage imageNamed:self.icons[indexPath.row]];
        cell.titleLabel.text = titles[indexPath.row];
        if (indexPath.row == 0) {
            cell.numberLabel.text = self.personalModel.iresume;
        } else if (indexPath.row == 1) {
            cell.numberLabel.text = self.personalModel.inviteJob;
        } else {
            cell.numberLabel.text = self.personalModel.Game;
        }
        return cell;
    }
}

-(CGFloat)computeHeight{
    CGFloat height;
    for (int i = 0; i <self.result.replyList.count;i++) {
        
        NSString * textArray = [[self.result.replyList objectAtIndex:i] v_content];
        NSDictionary *attribute = @{NSFontAttributeName: kFONT(12)};
        // 这个减去20  因为文本距离两边都是10
        CGSize textSize1 = [textArray boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width-kHEIGHT(20), self.tableView.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        height += textSize1.height;
        height += 10;  //cell的间距是10

    }
    NSLog(@"height%f",height);
    return height+50+16; //  50 是footer  16 是顶部
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.newType == NewRelationshipTypeAccept ||self.newType == NewRelationshipTypeWaitConfirm) {
            if (indexPath.row == 0) {
                return kHEIGHT(72);
            }else{
                if (self.result.replyList == nil || self.result.replyList.count == 0) {
                    return 0;
                }
              
                //这里需要计算   
                return [self computeHeight];
            }
        }else{
            return kHEIGHT(72);
        }
       
    } else if (indexPath.section == 1) {
        return kHEIGHT(72);
    } else {
        return kHEIGHT(43);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 200;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    return 0.1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"个人资料");
        DetailsViewController *detail = [[DetailsViewController alloc] init];
        detail.userID = self.friendID;
        [self.navigationController pushViewController:detail animated:YES];
    } else if (indexPath.section == 1) {
//        WPShareModel *model = [WPShareModel sharedModel];
//        PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
//        personal.str = self.personalModel.nick_name;
//        personal.sid = self.friendID;
//        [self.navigationController pushViewController:personal animated:YES];
        
        NewHomePageViewController *homePage = [[NewHomePageViewController alloc] init];
        homePage.info = @{@"user_id" : self.friendID,
                          @"nick_name" : self.personalModel.nick_name};
        [self.navigationController pushViewController:homePage animated:YES];
        
    } else if (indexPath.section == 2) {
        NearPersonalController *near = [[NearPersonalController alloc] init];
        near.isFromPersonalInfo = YES;
        if (indexPath.row == 0) {
            near.type = WPNearPersonalTypeInterview;
        } else if (indexPath.row == 1) {
            near.type = WPNearPersonalTypeRecruit;
        } else if (indexPath.row == 2) {
            near.type = WPNearPersonalTypeActivity;
        }
        near.userId = self.personalModel.uid;
        near.nick_name = self.personalModel.nick_name;
        near.newType = self.newType;
        if (indexPath.row == 0) {
            near.isRecruit = NO;
        }
        else
        {
            near.isRecruit = YES;
        }
        [self.navigationController pushViewController:near animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
