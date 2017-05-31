//
//  WPJobDetailViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/8/20.
//  Copyright (c) 2015年 WP. All rights reserved.
// 工作圈详情

#import "WPJobDetailViewController.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"
#import "AFHTTPRequestOperationManager.h"

#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "WorkTableViewCell.h"
#import "WPButton.h"
#import "CommentCell.h"

#import "UIButton+WebCache.h"
#import "WPTapGesture.h"
#import "PraiseCell.h"
#import "WFPopView.h"
#import "WPActionSheet.h"
#import "PersonalHomepageController.h"
#import "WPNicknameLabel.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"
#import "ReportViewController.h"

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
@interface WPJobDetailViewController ()<UITableViewDataSource,UITableViewDelegate,refreshData,jumpToPersonalPage,WPActionSheet>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *praiseData;
@property (nonatomic,strong) NSMutableArray *commentData;
@property (nonatomic,assign) BOOL isPraise;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
//@property (nonatomic,strong) NSIndexPath *iconClickIndexPath;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, strong) UIView *functionBackView;
@property (nonatomic, assign) BOOL isCreate;         //是否已创建
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) UIButton *praiseButton; //下面的点赞按钮
@property (nonatomic,strong) NSString *by_reply_nickName;  //键盘的placehoder
@property (nonatomic,strong) NSString *by_reply_sid; //被评论人的信息
@property (nonatomic,strong) NSString *discuss_id;   //评论的ID
@property (nonatomic,assign) BOOL isTopic;         //是否是动态
@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数

- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;
@end

@implementation WPJobDetailViewController
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
    NSLog(@"^^^^^^^%@",self.info);
    self.by_reply_nickName = self.info[@"nick_name"];
    self.by_reply_sid = self.info[@"user_id"];
    self.discuss_id = self.info[@"sid"];
    self.commentData = [NSMutableArray array];
    self.praiseData = [NSMutableArray array];
    self.isPraise = NO;
    self.isTopic = NO;
    self.isCreate = NO;
//    self.info = [NSMutableDictionary dictionary];
    [self createNav];
    [self reloadData];
    [self createBottomView];
    [self notificationCenter];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPJobDetailViewController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[WPJobDetailViewController class]];
}

- (void)createNav
{
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(selectPicture)];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            _page1 = 1;
            [_commentData removeAllObjects];
            [weakSelf reloadData];
        }];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self.view addSubview:_tableView];
        [self initialInput];
    }
    
    return _tableView;
}


#pragma rightBarbutton
- (void)selectPicture{
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    WPActionSheet *action = [[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"收藏",@"举报"] imageNames:@[@"collection",@"report"] top:64];
    [action showInView:self.view];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {       //收藏
        [self collect];
    } else if (buttonIndex == 2) {//举报
        [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
    } else if (buttonIndex == 3) {//分享
        
    }
    
    
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@",json);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error);
//    }];

}

- (void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = self.info[@"sid"];
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];

}

- (void)collect{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSDictionary *params = @{@"action" : @"collect",
                             @"username" : model.username,
                             @"password" : model.password,
                             @"user_id" : userInfo[@"userid"],
                             @"speak_trends_id" : self.info[@"sid"]};
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@---%@",json,json[@"info"]);
        [[[UIAlertView alloc] initWithTitle:json[@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)photoBtnClick:(UIButton *)sender
{
    
    [self cancelView];
    self.isCreate = NO;
    if (sender.tag == 4) {
        return;
    }
    //    if (sender.tag == 1) {
    //        NSLog(@"收藏");
    //    } else if (sender.tag == 2) {
    //        NSLog(@"举报");
    //    } else if (sender.tag == 3) {
    //        NSLog(@"分享");
    //    } else {
    //        [self cancelView];
    //    }
}

- (void)cancelView{
    [self.functionView removeFromSuperview];
    [self.functionBackView removeFromSuperview];
    self.isCreate = NO;
}

- (void)reloadData
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSLog(@"###%@",self.info);
    params[@"action"] = @"speakinfo";
    params[@"speak_id"] = self.info[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    NSLog(@"******%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        self.praiseData = json[@"UserList"];
        NSArray *arr = json[@"discusslist"];
        [_commentData addObjectsFromArray:arr];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:json[@"speakinfo"][0]];
        self.info = dic;
        [self tableView];
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
        [_tableView.mj_header endRefreshing];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.isPraise) {
        return self.commentData.count + 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        if (!self.isPraise) {
            return [self.commentData[section - 1][@"slist"] count];
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"workcellId";
        WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WorkTableViewCell alloc] init];
            cell.delegate2 = self;
            if (self.type == NewDetailTypeDynamic) {
                cell.cellType = CellLayoutTypeSpecial;
            } else {
                cell.cellType = CellLayoutTypeNormal;
            }
            //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
            cell.type = WorkCellTypeSpecial;
        }
        cell.isDetail = YES;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.is_praise = self.isPraise;
        [cell confineCellwithData:self.info];
        cell.functionBtn.appendIndexPath = indexPath;
        [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.dustbinBtn addTarget:self action:@selector(dustbinClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.attentionBtn addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.iconBtn addTarget:self action:@selector(checkHeadPersonalHomePage) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        cell.nickName.appendIndexPath = indexPath;
        [cell.nickName addGestureRecognizer:tap];
        return cell;

    } else {
        if (!self.isPraise) { // 显示评论的cell
            static NSString *cellId = @"commentCellId";
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.delegate = self;
            NSDictionary *dic = _commentData[indexPath.section - 1][@"slist"][indexPath.row];
            [cell confignDataWith:dic];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            return cell;
        } else {      //显示赞的cell
            static NSString *cellID = @"cellID";
            PraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[PraiseCell alloc] init];
            }
            [cell confignCellWith:_praiseData];
            for (UIButton *btn in cell.buttons) {
                [btn addTarget:self action:@selector(checkPraiseHomePage:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.selectionStyle = UITableViewCellAccessoryNone;
            return cell;

        }
    }
}

- (void)jumpToPersonalPageWith:(NSString *)use_id andNickName:(NSString *)nickName
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = nickName;
    NSLog(@"%@====%@",usersid,use_id);
    if ([usersid isEqualToString:use_id]) {
        personal.is_myself = YES;
//        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = use_id;
    [self.navigationController pushViewController:personal animated:YES];

}

- (void)longPressToDo:(UITapGestureRecognizer *)tap
{
    WPNicknameLabel *nickName = (WPNicknameLabel *)tap.self.view;
    //    NSLog(@"********%d",nickName.appendIndexPath.row);
    nickName.backgroundColor = RGB(226, 226, 226);
    [self performSelector:@selector(delayWithObj:) withObject:nickName afterDelay:0.2];
//    NSDictionary *dic = _datas[self.currentPage][nickName.appendIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",self.info[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = self.info[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
//        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)delayWithObj:(WPNicknameLabel *)nickName
{
    nickName.backgroundColor = [UIColor whiteColor];
}

- (void)checkHeadPersonalHomePage
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",self.info[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = self.info[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        //        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
    
}

- (void)checkCommentPersonHomePage:(UIButton *)sender
{
    NSDictionary *dic = _commentData[sender.tag - 1];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        //        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
    
}

- (void)checkPraiseHomePage:(UIButton *)sender
{
    NSDictionary *dic = self.praiseData[sender.tag - 1];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        //        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    [self.navigationController pushViewController:personal animated:YES];
    
}

//垃圾桶点击事件
- (void)dustbinClick{
    NSLog(@"删除");
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteDynamic";
    params[@"speakid"] = [NSString stringWithFormat:@"%@",self.info[@"sid"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    
    NSInteger count = [self.info[@"original_photos"] count];
    if (count > 0) {
        NSArray *arr = self.info[@"original_photos"];
        NSMutableArray *adress = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *str = dic[@"media_address"];
            [adress addObject:str];
        }
        NSString *img_address = [adress componentsJoinedByString:@"|"];
        params[@"img_address"] = img_address;
        
    }
    NSLog(@"****%@",params);
    self.deletParams = params;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条说说吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@----%@",json[@"info"],json);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
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
                    if (self.deletComplete) {
                        self.deletComplete();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];
            
        }
    }
}


- (void)attentionClick{
    NSLog(@"关注");
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = self.info[@"user_id"];
    params[@"by_nick_name"] = self.info[@"nick_name"];
    //    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
    //    if ([attention_state isEqualToString:@"2"] || [attention_state isEqualToString:@"0"]) {
    //        params[@"attention_state"] = @"2";
    //    } else {
    //        params[@"attention_state"] = @"3";
    //    }
    
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    
    //    NSString *nick_name = self.userInfo[@"nick_name"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@===%@",json[@"info"],json);
        if ([json[@"status"] integerValue] == 1) {
            NSString *attention = [NSString stringWithFormat:@"%@",self.info[@"attention_state"]];
            if ([attention isEqualToString:@"0"]) {
                [self.info setObject:@"1" forKey:@"attention_state"];
            } else if([attention isEqualToString:@"1"]){
                [self.info setObject:@"0" forKey:@"attention_state"];
            } else if ([attention isEqualToString:@"2"]) {
                [self.info setObject:@"3" forKey:@"attention_state"];
            } else if ([attention isEqualToString:@"3"]) {
                [self.info setObject:@"2" forKey:@"attention_state"];
            }
            
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}


- (void)refreshDataWith:(NSString *)statue
{
    if ([statue isEqualToString:@"1"]) {
        self.isPraise = NO;
        [_tableView reloadData];
    } else {
        self.isPraise = YES;
        [_tableView reloadData];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.isPraise) {
        if (section == 0) {
            return 0.01;
        } else if(section == _commentData.count){
            return 0.01;
        } else {
            return 0.01;
        }
    } else {
        if (section == 1) {
            return 0.01;
        } else {
            return 0.01;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.5;
    } else {
        if (!self.isPraise) {
            NSDictionary *dic = _commentData[section - 1];
            CGSize size = [dic[@"speak_comment_content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(30) - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil].size;
            if ([dic[@"slist"] count] == 0) {
                return 10 + 15 + kHEIGHT(3) + 12 + 6 + size.height + 10 + 0.05;
            } else {
                return 10 + 15 + kHEIGHT(3) + 12 + 6 + size.height + 8 + 0.05;
            }
        } else {
            return 0.01;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSInteger count = [self.info[@"imgCount"] integerValue];
        NSInteger videoCount = [self.info[@"videoCount"] integerValue];
        
        NSString *description = self.info[@"speak_comment_content"];
        //    NSArray *descrip1 = [description componentsSeparatedByString:@"#"];
        //    NSString *description1 = [descrip1 componentsJoinedByString:@"\""];
        NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        
        NSString *speak_comment_state = self.info[@"speak_comment_state"];
        NSString *lastDestription = [NSString stringWithFormat:@"#%@ %@",speak_comment_state,description3];
        CGSize normalSize = [@"我草泥马" sizeWithFont:kFONT(14)];
        CGFloat descriptionLabelHeight;//内容的显示高度
        if ([self.info[@"speak_comment_content"] length] == 0) {
            descriptionLabelHeight = normalSize.height;
        } else {
            CGSize size = [lastDestription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size;
            
            descriptionLabelHeight = size.height;
            //                if (descriptionLabelHeight > 16.702 *6) {
            //                    descriptionLabelHeight = 16.702 *6;
            //                } else {
            //                    descriptionLabelHeight = descriptionLabelHeight;
            //                }
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
        if ([self.info[@"address"] length] == 0) {
            if ([self.info[@"original_photos"] count] == 0) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + kHEIGHT(25) + 6;
            } else {
//                if ([self.info[@"speak_comment_content"] length] == 0) {
//                cellHeight = 10 + kHEIGHT(37) + 10 + photosHeight + 10 + kHEIGHT(25) + 6;
//                } else {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + kHEIGHT(25) + 6;
//                }
            }
        } else {
            if ([self.info[@"original_photos"] count] == 0) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + 15 + 10 + kHEIGHT(25) + 6;
            } else {
//                if ([self.info[@"speak_comment_content"] length] == 0) {
//                cellHeight = 10 + kHEIGHT(37) + 10 + photosHeight + 10 + 15 + 10 + kHEIGHT(25) + 6;
//                } else {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + kHEIGHT(25) + 6;
//                }
            }
        }
        return cellHeight;

    } else {
        if (!self.isPraise) {
            NSDictionary *dic = _commentData[indexPath.section -1][@"slist"][indexPath.row];
            CGFloat height;
            if ([dic[@"by_nick_name"] length] == 0) {
                NSString *str = [NSString stringWithFormat:@"%@ : %@",dic[@"nick_name"],dic[@"speak_comment_content"]];
                CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                height = size.height;
                
            } else {
                NSString *str = [NSString stringWithFormat:@"%@ 回复 %@ : %@",dic[@"nick_name"],dic[@"by_nick_name"],dic[@"speak_comment_content"]];
                CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kHEIGHT(30) - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil].size;
                height = size.height;
            }
            
            return height + 8;
        } else {
            if (_praiseData.count == 0) {
                return 0;
            } else {
                CGFloat width = (SCREEN_WIDTH - 70)/6;
                return (_praiseData.count/6 + 1)*(width + 10 + 21) + 10;
            }
        }
        

        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGBColor(226, 226, 226);
        return line;
    } else {
        if (!self.isPraise) {
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = RGBColor(226, 226, 226);
            [headView addSubview:line];
            headView.userInteractionEnabled = YES;
            NSDictionary *dic = _commentData[section - 1];
            UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            iconBtn.frame = CGRectMake(15, 10, kHEIGHT(30), kHEIGHT(30));
            iconBtn.tag = section;
            NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
            [iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            iconBtn.layer.cornerRadius = 5;
            iconBtn.clipsToBounds = YES;
            [iconBtn addTarget:self action:@selector(checkCommentPersonHomePage:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:iconBtn];
            
            UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(iconBtn.right + 15, 10, SCREEN_WIDTH - 120, 15)];
            nickName.font = kFONT(12);
            nickName.text = dic[@"nick_name"];
            [headView addSubview:nickName];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconBtn.right + 15, nickName.bottom + kHEIGHT(3), SCREEN_WIDTH - 120, 12)];
            timeLabel.font = kFONT(10);
            timeLabel.textColor = RGBColor(153, 153, 153);
            timeLabel.text = dic[@"speak_add_time"];
            [headView addSubview:timeLabel];
            
            UIButton *reply = [UIButton buttonWithType:UIButtonTypeCustom];
            [reply setImage:[UIImage imageNamed:@"detail_reply"] forState:UIControlStateNormal];
            reply.tag = section;
            [reply setTitle:@" 回复" forState:UIControlStateNormal];
            [reply setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [reply addTarget:self action:@selector(replyBtnClickWith:) forControlEvents:UIControlEventTouchUpInside];
            if (SCREEN_WIDTH == 320) {
                reply.frame = CGRectMake(SCREEN_WIDTH - 50, 10, 40, 15);

            } else {
                reply.frame = CGRectMake(SCREEN_WIDTH - 60, 10, 50, 15);
            }
            reply.titleLabel.font = kFONT(12);
            [headView addSubview:reply];
            
            UILabel *descriptinLabel = [[UILabel alloc] init];
            descriptinLabel.text = dic[@"speak_comment_content"];
            descriptinLabel.numberOfLines = 0;
            descriptinLabel.font = kFONT(12);
            CGSize size = [dic[@"speak_comment_content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(30) - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil].size;
            descriptinLabel.frame = CGRectMake(iconBtn.right + 15, timeLabel.bottom + 6, SCREEN_WIDTH - kHEIGHT(30) - 40, size.height);
            [headView addSubview:descriptinLabel];
            
            return headView;
        } else {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = RGBColor(226, 226, 226);
            return line;
        }
    }
}

- (void)replyAction:(WPButton *)sender
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
    }
    
    CGRect rectInTableView = [_tableView rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    BOOL isFavour;
    NSString *is_good = [NSString stringWithFormat:@"%@",self.info[@"is_good"]];
    NSLog(@"====%@",is_good);
    if ([is_good isEqualToString:@"0"]) {
        isFavour = NO;
    } else {
        isFavour = YES;
    }
    [self.operationView showAtView:_tableView rect:targetRect isFavour:self.is_good];
    
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
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    WorkTableViewCell *cell = (WorkTableViewCell *)[_tableView cellForRowAtIndexPath:index];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = self.info[@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
    params[@"is_type"] = @"1";
    params[@"wp_speak_click_type"] = @"1";
    params[@"odd_domand_id"] = @"0";
    if (!self.is_good) {
        params[@"wp_speak_click_state"] = @"0";
    } else {
        params[@"wp_speak_click_state"] = @"1";
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@ == %@",json[@"info"],json);
        if ([json[@"is_state"] integerValue] == 1) {
            [self refreshData];
            if (!self.is_good) {
                count ++;
            } else {
                count --;
            }
            cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            self.is_good = !self.is_good;
            [self.info setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [self.praiseButton setTitle:self.is_good ? @"  已赞" : @"  赞" forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}

- (void)replyMessage:(WPButton *)sender
{
    NSLog(@"评论");
    [self answerTheQuestion];
}

- (void)answerTheQuestion
{
    self.isTopic = YES;
    self.by_reply_nickName = self.info[@"nick_name"];
    self.by_reply_sid = self.info[@"user_id"];
    self.discuss_id = self.info[@"sid"];
    self.chatInputView.hidden = NO;
    self.chatInputView.textView.placeholder = [NSString stringWithFormat:@"回复:%@",self.by_reply_nickName];
    [self.chatInputView.textView becomeFirstResponder];
    
}

#pragma jumpToPersonalPage delegate
- (void)commentTopicWith:(NSDictionary *)topicInfo
{
    self.isTopic = NO;
    self.by_reply_nickName = topicInfo[@"nick_name"];
    self.by_reply_sid = topicInfo[@"user_id"];
    self.discuss_id = topicInfo[@"father_id"];
    self.chatInputView.hidden = NO;
    self.chatInputView.textView.placeholder = [NSString stringWithFormat:@"回复:%@",self.by_reply_nickName];
    [self.chatInputView.textView becomeFirstResponder];
    
}

#pragma mark 点击分区的头的评论
- (void)replyBtnClickWith:(UIButton *)sender
{
    NSLog(@"第%d分区被点击",sender.tag);
    NSDictionary *dic = _commentData[sender.tag - 1];
    self.discuss_id = dic[@"id"];
    self.by_reply_nickName = dic[@"nick_name"];
    self.by_reply_sid = dic[@"user_id"];
    self.isTopic = NO;
    self.chatInputView.hidden = NO;
    self.chatInputView.textView.placeholder = [NSString stringWithFormat:@"回复:%@",self.by_reply_nickName];
    [self.chatInputView.textView becomeFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"===%d----%d====",indexPath.section,indexPath.row);
    [_operationView dismiss];
    [self keyBoardDismiss];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.isPraise) {
        if (section == _commentData.count) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            label.backgroundColor = RGBColor(226, 226, 226);
            return label;
        } else {
            return nil;
        }
    } else {
        if (section == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            label.backgroundColor = RGBColor(226, 226, 226);
            return label;
        } else {
            return nil;
        }
    }
}

#pragma mark-设置cell的分割线的偏移量
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



- (void)createBottomView
{
        NSArray *titles =  @[@"  评论",@"  赞"];
        NSArray *images = @[@"detail_comment",@"detail_praise"];
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH/2*i, SCREEN_HEIGHT - BOTTOMHEIGHT, SCREEN_WIDTH/2, BOTTOMHEIGHT);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if (i == 1) {
            [button setTitle:self.is_good ? @"  已赞" : @"  赞" forState:UIControlStateNormal];
            self.praiseButton = button;
        }
        [button setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i + 1;
        [button addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_normal.jpg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_highted.jpg"] forState:UIControlStateHighlighted];
        [self.view addSubview:button];
    }
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - BOTTOMHEIGHT, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT  - BOTTOMHEIGHT/2 - 7.5, 0.5, 15)];
    line2.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line2];
}

- (void)functionBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"评论");
        [self answerTheQuestion];
//        self.chatInputView.hidden = NO;
//            self.chatInputView.textView.placeholder = @"回复:为情所伤";
//        [self.chatInputView.textView becomeFirstResponder];
    } else {
        NSLog(@"赞");
        [self addLike];
    }
}

- (void)keyBoardDismiss
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_operationView dismiss];
    [self keyBoardDismiss];
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
    
}

- (void)initialInput
{
    CGRect inputFrame = CGRectMake(0, SCREEN_HEIGHT - 108,SCREEN_WIDTH,44.0f);
    self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
    [self.view addSubview:self.chatInputView];
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
    __weak WPJobDetailViewController* weakSelf = self;
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
    [_recordingView setHidden:NO];
    [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [self.view addSubview:_recordingView];
//    [self.view bringSubviewToFront:_recordingView];
    [self.view bringSubviewToFront:self.chatInputView];
    self.chatInputView.hidden = YES;
}

- (void)normalReplyWithTopic
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"*****%@",self.chatInputView.textView.text);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = self.info[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    params[@"nick_name"] = myDic[@"nick_name"];
    NSLog(@"****%@",self.by_reply_nickName);
    params[@"by_nick_name"] = self.by_reply_nickName;
    params[@"by_user_id"] = self.by_reply_sid;
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    if (self.isTopic) {
        params[@"speak_reply"] = @"0";
    } else {
        params[@"speak_reply"] = @"1";
    }
    params[@"disuss_id"] = self.discuss_id;
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            [self refreshData];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];

}

- (void)refreshData{
    [self.praiseData removeAllObjects];
    [self.commentData removeAllObjects];
    [self reloadData];
}

//评论
- (void)commentClick:(UIButton *)sender
{
    [self normalReplyWithTopic];
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
        [self.view bringSubviewToFront:_recordingView];
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
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = self.info[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"by_nick_name"] = self.by_reply_nickName;
//    params[@"by_user_id"] = self.by_reply_sid;
//    //    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    if (self.isTopic) {
//        params[@"speak_reply"] = @"0";
//    } else {
//        params[@"speak_reply"] = @"1";
//    }
//    params[@"disuss_id"] = self.discuss_id;
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
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////            [alert show];
//            [self refreshData];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    [self.chatInputView willBeginInput];
//    _chatInputView.hidden = YES;
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
    [self normalReplyWithTopic];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = self.info[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    //    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"by_nick_name"] = self.info[@"nick_name"];
//    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    params[@"speak_reply"] = @"0";
//    NSLog(@"****%@",params);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"####%@",url);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@",json);
//        if ([json[@"status"] integerValue] == 1) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
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
