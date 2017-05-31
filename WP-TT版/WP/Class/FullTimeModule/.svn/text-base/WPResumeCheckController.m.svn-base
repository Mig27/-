//
//  WPResumeController.m
//  WP
//
//  Created by CBCCBC on 15/11/30.
//  Copyright © 2015年 WP. All rights reserved.
// 

#import "WPResumeCheckController.h"
#import "SPButton.h"
#import "SPLabel.h"
#import "WPResumeCheckModel.h"
#import "WPResumeCheckApplyModel.h"
#import "UIImageView+WebCache.h"
#import "WPResumeCheckApplyCell.h"
#import "WPRecruitApplyChooseModel.h"
#import "WPRecruitApplyChooseController.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPResumeMessageModel.h"
#import "WPInterviewApplyChooseController.h"
#import "WPInterviewApplyController.h"
#import "WPCommonCommentHeadCell.h"
#import "WPCommonCommentBodyCell.h"
#import "WPInterviewResumeController.h"
#import "WPOtherResumeController.h"
#import "WPRecentLinkManController.h"
#import "YYShareManager.h"
#import "RecentPersonController.h"
#import "WPSendToFriends.h"
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"
#import "IQKeyboardManager.h"
#import "NearPersonalController.h"
#import "WPResumeCheckHeaderView.h"
#import "ShareEditeViewController.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "NearInterViewController.h"
#import "HCInputBar.h"
#import "ThirdJobViewController_New.h"
#import "UIMessageInputView.h"
#import "HJCActionSheet.h"
#import "PersonalInfoViewController.h"
#import "WPMySecurities.h"
#import "WPTitleView.h"
@class RecordingView;
@interface WPResumeCheckController () <UITableViewDelegate,UITableViewDataSource,WPRecruitApplyDelegate,WPInterviewApplyDelegate,JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate,HJCActionSheetDelegate>
{
   
    RecordingView* _recordingView;
    NSInteger currentIndex;
    NSInteger deleteInter;//要删除的选项
    NSInteger shareAndBrowse;//分享和浏览选中的项
    WPCommonCommentHeadCell * currentCell;//长按时选中的cell
    BOOL scrollerToBottom;//写完留言后要滚动到底部
    NSInteger firstShareCount;//第一次进入时分享的数量
    NSInteger deleteChoise;//要删除的位置
}
@property (nonatomic, strong) WPTitleView * titleView;
@property (strong, nonatomic) WPResumeCheckHeaderView *headView;
//@property (strong, nonatomic) TouchScrollView *bodyView;
@property (strong, nonatomic) UIView *bottomApplyView;
@property (strong, nonatomic) UIView *bottomMessageView;
@property (strong, nonatomic) UIView *bottomGlanceView;

//@property (strong, nonatomic) TouchTableView *applyTableView;
@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) TouchTableView *glanceTableView;

@property (strong, nonatomic) NSMutableArray *browseArray;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *shareArray;

@property (assign, nonatomic) NSInteger browsePage;
@property (assign, nonatomic) NSInteger messagePage;
@property (assign, nonatomic) NSInteger sharePage;



@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property(nonatomic,strong)HCInputBar *inputBar;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, assign)BOOL isGlance;
@property (nonatomic, assign)BOOL isShare;
@property (nonatomic, assign)BOOL isMessage;
@property(nonatomic,copy)NSString *subId;

@end

@implementation WPResumeCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    deleteInter= -1;
    _browsePage = 1;
    _messagePage = 1;
    _sharePage = 1;
    _currentType = WPResumeCheckMessageType;
    _replyCommentId = @"";
    _replyUserId = @"";
    
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"留言";
    self.navigationItem.titleView = self.titleView;
    
    
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self.view addSubview:self.inputBar];
    self.view.backgroundColor = RGB(235, 235, 235);
   
//    __weak typeof(self) weakSelf = self;
    [_inputBar showInputViewContents:^(NSString *contents) {
#pragma mark 在这里获取发送的内容
        NSString * string = [NSString stringWithFormat:@"%@",contents];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!string.length) {
            [MBProgressHUD createHUD:@"请输入内容" View:self.view];
            return ;
        }
        
        self.inputBar.placeHolder = @"请输入留言";
//        if (self.replayName.length) {
//            self.inputBar.placeHolder = [NSString stringWithFormat:@"回复：%@",self.replayName];
//        }
        [self replayMessage:contents];
        
    }];
    
    [self requestResumeInfo];
//    [self requsetForReloadData];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPResumeCheckController class]];
//    [self.view addSubview:self.bottomMessageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    //成功发送给好友
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendApplyToFriendSuccess:)
                                                 name:@"sendApplyToFriendSuccess"
                                               object:nil];
}
-(void)sendApplyToFriendSuccess:(NSNotification*)noti
{
    [self requestResumeInfo];
}
-(WPResumeCheckMessageModel*)backMessageDic:(NSDictionary*)dic commentId:(NSString*)commentID
{
    
    NSDictionary *loginDic = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
    
    NSDictionary * dictionary = [NSDictionary new];
    dictionary = @{@"ReplayCommentList":@[],@"add_time":@"1分钟前",@"avatar":loginDic[@"list"][0][@"avatar"],
                   @"comment_content":dic[@"commentContent"],@"comment_id":commentID,@"company":loginDic[@"list"][0][@"company"],
                   @"created_user_id":kShareModel.userId,@"position":loginDic[@"list"][0][@"position"],
                   @"to_avatar":@"",@"to_nick_name":self.replayName.length?self.replayName:@"",@"to_user_id":self.replyUserId,
                   @"to_user_name":self.replayName.length?self.replayName:@"",@"user_name":kShareModel.nick_name,@"username":kShareModel.username};
    WPResumeCheckMessageModel *model = [WPResumeCheckMessageModel mj_objectWithKeyValues:dictionary];
    return model;
}
#pragma mark 点击提交留言
-(void)replayMessage:(NSString*)contents
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSDictionary *params = @{@"action":_isRecruit?@"AddCommentForJob":@"AddCommentForResume",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             _isRecruit?@"job_id":@"resume_id":_resumeId,
                             @"commentContent":contents,
                             @"Replay_commentID":[NSString stringWithFormat:@"%@",_replyCommentId],
                             @"replay_user_id":[NSString stringWithFormat:@"%@",_replyUserId]
                             };//@"user_id" : kShareModel.userId
    [WPHttpTool postWithURL:str params:params success:^(id json) {
       
        [_inputBar resignFirstResponder];
        _currentType = WPResumeCheckMessageType;
        UIButton * firstBtn = (UIButton*)[self.headView viewWithTag:1];
        UIButton * secondBtn = (UIButton*)[self.headView viewWithTag:2];
        UIButton * thirdBtn = (UIButton*)[self.headView viewWithTag:3];
        firstBtn.selected = NO;
        secondBtn.selected = NO;
        thirdBtn.selected = YES;
        self.headView.sportLine.frame = CGRectMake(thirdBtn.left, thirdBtn.bottom-2, SCREEN_WIDTH/3, 2);
        if ([json[@"status"] isEqualToString:@"0"]) {
            WPResumeCheckMessageModel * dictionary= [self backMessageDic:params commentId:json[@"comment_id"]];
            [self.messageArray addObject:dictionary];
            [_tableView reloadData];
            NSIndexPath * path = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            UIButton * button = (UIButton*)[self.headView viewWithTag:3];
            [button setTitle:[NSString stringWithFormat:@"留言   %lu",(unsigned long)self.messageArray.count] forState:UIControlStateNormal];
            _replyUserId = @"";
            _replyCommentId = @"";
            _replayName = @"";
//            [self requestMessageList:1 success:^(NSArray *datas, int more) {
//                [self.messageArray removeAllObjects];
//                [self.messageArray addObjectsFromArray:datas];
//               
//                [_tableView reloadData];
//                NSIndexPath * path = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
//                [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                
//                UIButton * button = (UIButton*)[self.headView viewWithTag:3];
//                [button setTitle:[NSString stringWithFormat:@"留言   %lu",(unsigned long)self.messageArray.count] forState:UIControlStateNormal];
//                _replyUserId = @"";
//                _replyCommentId = @"";
//            } error:^(NSError *error) {
//            }]; 
        }
    } failure:^(NSError *error) {
        [SPAlert alertControllerWithTitle:@"提示" message:error.localizedDescription superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }];
  
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 键盘 即将显示
    if (_myMsgInputView) {
        [_myMsgInputView prepareToShow];
    }
//    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 键盘 隐藏
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}
- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        if (self.replayName.length) {
            _inputBar.placeHolder = [NSString stringWithFormat:@"回复:%@",self.replayName];
        }
        else
        {
           _inputBar.placeHolder = @"请输入留言";
        }
       
    }
    return _inputBar;
}


-(void)requstModel:(void(^)(id))Success
{
    NSDictionary * dic = nil;
    NSString * urlStr = nil;
    if (self.isRecruit)//招聘
    {
        dic = @{@"action":@"GetJobDraftInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":self.resumeId};
        urlStr = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
    }
    else
    {
        dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":self.resumeId};
        urlStr = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
    }
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (self.isRecruit)//招聘
        {
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.logo = json[@"photoList"][0][@"original_path"];
            model.enterpriseName = json[@"enterprise_name"];
            model.resumeId = self.resumeId;
            model.resume_user_id = json[@"user_id"];
            model.jobPositon = json[@"jobPositon"];
            model.enterprise_properties = json[@"enterprise_properties"];
            model.enterprise_brief = json[@"enterprise_properties"];
            model.enterprise_scale = json[@"enterprise_scale"];
            model.enterprise_address = json[@"enterprise_address"];
            model.dataIndustry = json[@"dataIndustry"];
            
            NSArray *epRemarkList = json[@"epRemarkList"];
            if (epRemarkList.count) {
                model.enterprise_brief = epRemarkList[0][@"txtcontent"];
            }
            
            self.model = model;
        }
        else
        {
            NSArray * jaonArray = json[@"PhotoList"];
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.resumeId = self.resumeId;
            model.avatar = jaonArray.count?jaonArray[0][@"original_path"]:@"";//json[@"PhotoList"][0][@"original_path"]
            model.HopePosition = json[@"Hope_Position"];
            model.name = json[@"name"];
            model.sex = json[@"sex"];
            model.education = json[@"education"];
            model.WorkTim = json[@"WorkTime"];
            model.resume_user_id = json[@"resume_user_id"];
            model.lightspot = json[@"lightspot"];
            self.model = model;
        }
        Success(json);
    } failure:^(NSError *error) {
    }];
}
#pragma mark 分享成功时请求数据
-(void)shareSuccess
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.isRecruit == 0?@"oneshareresume":@"onesharejob"),
                             (self.isRecruit == 0?@"resumeid":@"jobid"):self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
    } failure:^(NSError *error) {
    }];
}
#pragma mark 点击右侧进行分享
- (void)rightBtnClick
{
    [self.view endEditing:YES];
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.isRecruit == 0?@"oneshareresume2":@"onesharejob2"),
                             (self.isRecruit == 0?@"resumeid":@"jobid"):self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        if([json[@"status"] isEqualToString:@"1"]){
                [self requstModel:^(id string) {
                   [self shareWithUrlStr:json[@"url"]];
                }];
           
//            [self shareWithUrlStr:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
//    NSString * urlStr;
//    if (self.isRecruit == 0) {
//        urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_resume_info.aspx?resume_id=%@",IPADDRESS,self.resumeId];
//    }
//    else
//    {
//      urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_EnterpriseRecruit.aspx?recruit_id=%@",IPADDRESS,self.resumeId];
//    }
//    
//    [YYShareManager newShareWithTitle:@"这是title" url:urlStr action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends)
//        {
//            //NSLog(@"分享到微聘好友");
//            RecentPersonController *recent = [[RecentPersonController alloc]init];
//            recent.shareArray = @[self.model];
//            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:recent];
//            [self presentViewController:navc animated:YES completion:nil];
//        }
//        if (type == YYShareManagerTypeWorkLines) {
//            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
//            NSString *jobids;
//            NSString *share_title;
//            NSString *name;
//            NSString *sex;
//            NSString *birthday;
//            NSString *education;
//            NSString *workTime;
//            NSMutableArray *jobPhoto = [NSMutableArray array];
//            int i = 0;
//            if(self.isRecruit == WPMainPositionTypeRecruit){
//                    if (jobids.length == 0) {
//                        jobids = _model.resumeId;
//                    }else{
//                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
//                    }
//                    share_title = [@"招聘:" stringByAppendingString:_model.jobPositon];
//                    if (!_model.avatar) {
//                        _model.avatar = @"";
//                    }
//                    [jobPhoto addObject:@{@"small_address":_model.logo}];
//                    name = _model.enterpriseName;
//                    
//                    i ++;
//                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
//                                                                                           @"jobids":jobids,
//                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
//                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
//                                                                                                         @"share_title":share_title,
//                                                                                                         @"name":name}}];
//                
//                share.shareInfo = dic;
//            }else{
//                    if (jobids.length == 0) {
//                        jobids = _model.resumeId;
//                    }else{
//                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
//                    }
//                    share_title = [NSString stringWithFormat:@"求职:%@",_model.HopePosition];
//                    if (!_model.avatar) {
//                        _model.avatar = @"";
//                    }
//                    [jobPhoto addObject:@{@"small_address":_model.avatar}];
//                    name = _model.name;
//                    sex = _model.sex;
//                    birthday = _model.birthday;
//                    education = _model.education;
//                    workTime = _model.WorkTim;
//                    i ++;
////                }
//                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
//                                                                                           @"jobids":jobids,
//                                                                                           @"share":[NSString stringWithFormat:@"%d",2],
//                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
//                                                                                                         @"share_title":share_title,
//                                                                                                         @"name":name,
//                                                                                                         @"sex":sex,
//                                                                                                         @"birthday":birthday,
//                                                                                                         @"education":education,
//                                                                                                         @"WorkTime":workTime}}];
//                
//                share.shareInfo = dic;
//            }
//            share.shareSuccessedBlock = ^(id json){
////                [self hidden];
//                [MBProgressHUD createHUD:@"分享成功" View:self.view];
//                [self.headView.shareBtn setTitle:[NSString stringWithFormat:@"分享   %ld",++firstShareCount] forState:UIControlStateNormal];
//                [self requestApplyList:1 success:^(NSArray *datas, int more) {
//                    [self.shareArray removeAllObjects];
//                    [self.shareArray addObjectsFromArray:datas];
//                    if (currentType == WPResumeCheckShareType) {
//                        [_tableView reloadData];
//                    }
//                } error:^(NSError *error) {
//                    
//                }];
//            };
//            [self.navigationController pushViewController:share animated:YES];
//        }
//        if (type == YYShareManagerTypeCollect) {//点击进行收藏
//            [self performSelector:@selector(collection) withObject:nil afterDelay:0.2];
//        }
//        if (type == YYShareManagerTypeReport) {//点击进行举报
//            [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
//        }
//    } status:^(UMSResponseCode status) {
//        if (status == UMSResponseCodeSuccess) {
//        [self.headView.shareBtn setTitle:[NSString stringWithFormat:@"分享   %ld",++firstShareCount] forState:UIControlStateNormal];
//            [self requestApplyList:1 success:^(NSArray *datas, int more) {
//                [self.shareArray removeAllObjects];
//                [self.shareArray addObjectsFromArray:datas];
//                if (currentType == WPResumeCheckShareType) {
//                    [_tableView reloadData];
//                }
//            } error:^(NSError *error) {
//                
//            }];
////            if (currentType == WPResumeCheckShareType) {
////                [self requsetForReloadData];
////            }
//
//        }
//    }];
}
-(void)shareWithUrlStr:(NSString*)urlString
{
    urlString = [IPADDRESS stringByAppendingString:urlString];
    WPSendToFriends *toFriends = [[WPSendToFriends alloc]init];
    toFriends.model = self.model;
    toFriends.isRecuilist = self.isRecruit ;
    NSString * title = [toFriends shareDetailFromZhaopinOrQiuZhiandImage:(!self.isRecruit)?self.model.avatar:self.model.logo];
    [YYShareManager newShareWithTitle:title url:urlString action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            //NSLog(@"分享到微聘好友");
            [toFriends sendeToWeiPinFriends:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.toUserId = toUserId;
                linkMan.transStr = messageContent;
                linkMan.display_type = display_type;
                linkMan.shuoID = self.resumeId;
                linkMan.isFromApplyInvite = YES;
                linkMan.isRecruit = self.isRecruit;
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
        }
        if (type == YYShareManagerTypeWorkLines) {
            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
            NSString *jobids;
            NSString *share_title;
            NSString *name;
            NSString *sex;
            NSString *birthday;
            NSString *education;
            NSString *workTime;
            NSMutableArray *jobPhoto = [NSMutableArray array];
            int i = 0;
            if(self.isRecruit == WPMainPositionTypeRecruit){
                if (jobids.length == 0) {
                    jobids = _model.resumeId;
                }else{
                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
                }
//                share_title = [@"招聘:" stringByAppendingString:_model.jobPositon];
                share_title = [NSString stringWithFormat:@"招聘:%@",_model.jobPositon];
                if (!_model.avatar) {
                    _model.avatar = @"";
                }
                [jobPhoto addObject:@{@"small_address":_model.logo}];
                name = _model.enterpriseName;
                
                i ++;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name}}];
                
                share.shareInfo = dic;
            }else{
                if (jobids.length == 0) {
                    jobids = _model.resumeId;
                }else{
                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
                }
                share_title = [NSString stringWithFormat:@"求职:%@",_model.HopePosition];
                if (!_model.avatar) {
                    _model.avatar = @"";
                }
                [jobPhoto addObject:@{@"small_address":_model.avatar}];
                name = _model.name;
                sex = _model.sex;
                birthday = _model.birthday.length?_model.birthday:@"";
                education = _model.education;
                workTime = _model.WorkTim;
                i ++;
                //                }
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",2],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name,
                                                                                                         @"sex":sex,
                                                                                                         @"birthday":birthday,
                                                                                                         @"education":education,
                                                                                                         @"WorkTime":workTime}}];
                
                share.shareInfo = dic;
            }
            share.shareSuccessedBlock = ^(id json){
                //                [self hidden];
                [MBProgressHUD createHUD:@"分享成功" View:self.view];
                [self.headView.shareBtn setTitle:[NSString stringWithFormat:@"分享   %ld",++firstShareCount] forState:UIControlStateNormal];
                [self requestApplyList:1 success:^(NSArray *datas, int more) {
                    [self.shareArray removeAllObjects];
                    [self.shareArray addObjectsFromArray:datas];
                    if (_currentType == WPResumeCheckShareType) {
                        [_tableView reloadData];
                    }
                } error:^(NSError *error) {
                }];
                [self shareSuccess];
            };
            [self.navigationController pushViewController:share animated:YES];
        }
        if (type == YYShareManagerTypeCollect) {//点击进行收藏
            [self performSelector:@selector(collection) withObject:nil afterDelay:0.2];
        }
        if (type == YYShareManagerTypeReport) {//点击进行举报
            [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
        }
    } status:^(UMSocialShareResponse* status) {
        if (status) {
            [self.headView.shareBtn setTitle:[NSString stringWithFormat:@"分享   %ld",++firstShareCount] forState:UIControlStateNormal];
            [self requestApplyList:1 success:^(NSArray *datas, int more) {
                [self.shareArray removeAllObjects];
                [self.shareArray addObjectsFromArray:datas];
                if (_currentType == WPResumeCheckShareType) {
                    [_tableView reloadData];
                }
            } error:^(NSError *error) {
                
            }];
        }
    }];
}
#pragma mark 点击举报
-(void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
    //    report.speak_trends_id = self.info[@"sid"];
    report.speak_trends_id = self.subId;
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
}

#pragma  mark 点击收藏
- (void)collection
{
    CollectViewController *VC = [[CollectViewController alloc]init];
    if (_isRecruit) {
        VC.titles = self.model.jobPositon;
        VC.companys = self.model.enterpriseName;
        VC.jobid = self.model.resumeId;
        VC.collect_class = @"5";
        VC.user_id = self.model.userId;
        VC.img_url = self.model.logo;
    }else{
        VC.titles = self.model.HopePosition;
        VC.companys = [NSString stringWithFormat:@"%@ %@ %@ %@",self.model.name,self.model.sex,self.model.education,self.model.WorkTim];
        VC.jobid = self.model.resumeId;
        VC.collect_class = @"6";
        VC.user_id = self.model.userId;
        VC.img_url = self.model.avatar;
    }
    
    VC.collectSuccessBlock = ^(){
        [MBProgressHUD showSuccess:@"收藏成功"];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (NSMutableArray *)browseArray{
    if (!_browseArray) {
        self.browseArray = [[NSMutableArray alloc]init];
    }
    return _browseArray;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
}

- (NSMutableArray *)shareArray{
    if (!_shareArray) {
        self.shareArray = [[NSMutableArray alloc]init];
    }
    return _shareArray;
}

#pragma mark - Init
#pragma mark 创建浏览，分享，留言
- (WPResumeCheckHeaderView *)headView
{
    if (!_headView) {
        self.headView = [[WPResumeCheckHeaderView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(99)+8)];
        [self.headView addTarget:self action:@selector(changeCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headView.contentButton addTarget:self action:@selector(goToResumeAgain) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headView;
}
//-(void)goToResumeAgain
//{
//    NearInterViewController * near = [[NearInterViewController alloc]init];
//}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = RGB(226, 226, 226);
        _tableView.tableFooterView = [[UIView alloc]init];
//        _tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.tableHeaderView = self.headView;
        WS(ws);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requsetForReloadData];
            [ws.tableView.mj_header endRefreshing];
        }];
        
//        [_tableView.mj_header beginRefreshing];
        
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            currentIndex = [ws choosePage];
//            currentIndex ++ ;
//            [ws requestList:currentIndex success:^(NSArray * datas , int more) {
//                [ws resetPage];
//                if (!more) {
//                    [ws.tableView.mj_footer endRefreshingWithNoMoreData];
//                }else{
//                    [ws.messageArray addObjectsFromArray:datas];
//                    [ws.tableView reloadData];
//                }
//            }];
//            [ws.tableView.mj_footer endRefreshing];
//        }];
    }
    return _tableView;
}
#pragma mark点击留言，浏览，分享是请求数据
- (void)requsetForReloadData
{
    
//    [self.tableView.mj_header beginRefreshing];
    [self.titleView.activity startAnimating];
    [self requestList:1 success:^(NSArray *datas , int more) {
        [self.titleView.activity stopAnimating];
        [self tableViewReloadDataWithData:datas];
    }];
}

- (NSInteger)choosePage
{
    switch (_currentType) {
        case WPResumeCheckBrowseType:
            return _browsePage;
            break;
        case WPResumeCheckShareType:
            return _sharePage;
            break;
        case WPResumeCheckMessageType:
            return _messagePage;
            break;
        default:
            break;
    }
    return 1;
}

- (void)resetPage
{
    switch (_currentType) {
        case WPResumeCheckBrowseType:
            _browsePage = currentIndex;
            break;
        case WPResumeCheckShareType:
            _sharePage = currentIndex;
            break;
        case WPResumeCheckMessageType:
            _messagePage = currentIndex;
            break;
        default:
            break;
    }
}
#pragma mark 更新数据
- (void)tableViewReloadDataWithData:(NSArray *)datas
{
    [self.tableView.mj_footer resetNoMoreData];
    switch (_currentType) {
        case WPResumeCheckBrowseType:
        {
            [self.browseArray removeAllObjects];
            [self.browseArray addObjectsFromArray:datas];
            [self.headView.browseBtn setTitle:[NSString stringWithFormat:@"浏览   %lu",(unsigned long)self.browseArray.count] forState:UIControlStateNormal];
        }
            break;
        case WPResumeCheckShareType:
        {
            [self.shareArray removeAllObjects];
            [self.shareArray addObjectsFromArray:datas];
            firstShareCount = self.shareArray.count;
            [self.headView.shareBtn setTitle:[NSString stringWithFormat:@"分享   %lu",(unsigned long)self.shareArray.count] forState:UIControlStateNormal];
        }
            break;
        case WPResumeCheckMessageType:
        {
            [self.messageArray removeAllObjects];
            [self.messageArray addObjectsFromArray:datas];
            [self.headView.messageBtn setTitle:[NSString stringWithFormat:@"留言   %lu",(unsigned long)self.messageArray.count] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
   
    
    [self.tableView reloadData];
    if (scrollerToBottom) {
        if (_currentType == WPResumeCheckMessageType) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            scrollerToBottom = NO;
        }
    }
    
    if (_isFromMianShiMessage) {
        if (_currentType == WPResumeCheckMessageType) {
            _isFromMianShiMessage = NO;
            NSIndexPath * indexpath = [[NSIndexPath alloc]init];
            for (int i = 0 ; i < self.messageArray.count; i++) {
                WPResumeCheckMessageModel * model = self.messageArray[i];
                if ([model.commentId isEqualToString:self.scrollerID]) {
                    indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                }
            }
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}
#pragma mark 底部
- (UIView *)bottomMessageView{
    if (!_bottomMessageView) {
        _bottomMessageView = [[UIView alloc]init];
        _bottomMessageView.backgroundColor = [UIColor whiteColor];
        
        self.bottomMessageView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
//        [_bottomMessageView addSubview:self.chatInputView];
//        
//        self.chatInputView.frame = self.bottomMessageView.bounds;
//        [_bottomMessageView addSubview:self.chatBar];
//        self.chatBar.frame = self.bottomMessageView.bounds;
    }
    return _bottomMessageView;
}

- (UIView *)bottomGlanceView{
    if (!_bottomGlanceView) {
        _bottomGlanceView = [[UIView alloc]init];
        _bottomGlanceView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_bottomGlanceView];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomGlanceView addSubview:line];
        _bottomGlanceView.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"分享" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(SCREEN_WIDTH, 49)] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomGlanceView addSubview:button];
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchDown];
        button.frame = self.bottomGlanceView.bounds;
    }
    return _bottomGlanceView;
}
#pragma mark 聊天输出窗口
- (JSMessageInputView *)chatInputView{
    if (!_chatInputView) {
//        CGRect inputFrame = CGRectMake(0, 0,SCREEN_WIDTH,49.0f);
        _chatInputView = [[JSMessageInputView alloc] initWithFrame:CGRectZero delegate:self];
        [_chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
//        [self.view addSubview:_chatInputView];
//        [self.view bringSubviewToFront:_chatInputView];
        [_chatInputView.emotionbutton addTarget:self
                                             action:@selector(showEmotions:)
                                   forControlEvents:UIControlEventTouchUpInside];
        
        [_chatInputView.showUtilitysbutton addTarget:self
                                                  action:@selector(showUtilitys:)
                                        forControlEvents:UIControlEventTouchDown];
        
        [_chatInputView.voiceButton addTarget:self
                                           action:@selector(p_clickThRecordButton:)
                                 forControlEvents:UIControlEventTouchUpInside];
//        [_chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//        [self.view bringSubviewToFront:self.chatInputView];
//        _chatInputView.hidden = NO;
    }
    return _chatInputView;
}

#pragma mark - 点击头部
- (void)goToResumeAgain{
    WPOtherResumeController *resume = [[WPOtherResumeController alloc]init];
    resume.subId = self.resumeId;
    resume.userId = self.userId;
    resume.resumeID = self.resumeId;
    resume.isRecuilist = self.isRecruit;

    resume.isFromShuoShuo = self.isFromShuoShuo;
    
    NSString *interviewStr = nil;
    NSString *recruitStr  = nil;
    if (self.isFromShuoShuo) {
//        isVisible
        interviewStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@&isVisible=1",IPADDRESS,self.resumeId,kShareModel.userId];
        recruitStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@&isVisible=1",IPADDRESS,self.resumeId,kShareModel.userId];
    }
    else
    {
        interviewStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@&isVisible=1",IPADDRESS,self.resumeId,kShareModel.userId];
        recruitStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@&isVisible=1",IPADDRESS,self.resumeId,kShareModel.userId];
    }
//    NSString *interviewStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,self.resumeId,kShareModel.userId];//self.userId
//    
//    NSString *recruitStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,self.resumeId,kShareModel.userId];//self.userId
    resume.urlStr = _isRecruit?recruitStr:interviewStr;
    [self.navigationController pushViewController:resume animated:YES];
}
#pragma mark 点击浏览，分享，留言
- (void)changeCategoryAction:(UIButton *)sender{
    
//    [self.inputBar.inputView resignFirstResponder];
    [self hideKeyBoard];
    
    _currentType = sender.tag;
    
    [self.tableView reloadData];
    
    if (_currentType == WPResumeCheckMessageType) {//点击留言
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    }
    else if (_currentType == WPResumeCheckShareType){//点击分享
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    }else{//点击浏览

        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    }
    switch (_currentType) {
        case WPResumeCheckMessageType:
        {
            if (_isMessage) {
            }
            else
            {
                _isMessage = YES;
                if (self.messageArray.count) {
                    
                }
                else
                {
                   [self requsetForReloadData];
                }
            }
        }
            break;
        case WPResumeCheckShareType:
            if (_isShare) {
                
            }
            else
            {
                _isShare = YES;
                if (self.shareArray.count) {
                    
                }
                else
                {
                  [self requsetForReloadData];
                }
                
            }
            break;
        case WPResumeCheckBrowseType:
            if (_isGlance) {
            }
            else
            {
                _isGlance = YES;
                if (self.browseArray.count) {
                    
                }
                else
                {
                  [self requsetForReloadData];
                }
                
            }
            break;
        default:
            break;
    }
    
   
}

- (void)removeBottomViews
{
    if (self.bottomMessageView.superview) {
        [self.bottomMessageView removeFromSuperview];
    }
    if (self.bottomGlanceView.superview) {
        [self.bottomGlanceView removeFromSuperview];
    }
}

- (void)applyAction:(UIButton *)sender{
    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
    
    if ([button.contentLabel.text isEqualToString:(_isRecruit?@"申请职位":@"抢人")]) {
        //            WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
        //            apply.delegate = self;
        //            apply.sid = self.subId;
        //            [self.navigationController pushViewController:apply animated:YES];
        _isRecruit?[self requestRecruitGetApplyCondition]:[self requestInterviewGetApplyCondition];
    }
    if ([button.contentLabel.text isEqualToString:(_isRecruit?@"已申请":@"已抢")]) {
        
        [SPAlert alertControllerWithTitle:@"提示" message:@"是否取消？" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            NSString *str = [IPADDRESS stringByAppendingString:(_isRecruit?@"/ios/invitejob.ashx":@"/ios/resume_new.ashx")];
            WPShareModel *model = [WPShareModel sharedModel];
            NSDictionary *params = @{@"action":@"CancelSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],(_isRecruit?@"job_id":@"resume_id"):self.resumeId};
            [WPHttpTool postWithURL:str params:params success:^(id json) {
                //            NSLog(@"%@",describe(json));
                if (![json[@"status"] integerValue]) {
                    button.contentLabel.text = (_isRecruit?@"申请职位":@"抢人");
                }else{
                    [MBProgressHUD showError:@"取消报名失败" toView:self.view];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
        }];
    }
    if ([button.contentLabel.text isEqualToString:@"已通过"]) {
        NSLog(@"已通过");
    }

}

//评论
- (void)commentClick:(UIButton *)sender
{
    [self.chatInputView.textView resignFirstResponder];
    if (self.chatInputView.textView.text.length == 0) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"输入内容不能为空哦~" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        return;
    }
    [self replyCommontWithModel];

}

- (void)normalReplyWithTopic
{
//    if (self.chatInputView.textView.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    NSLog(@"*****%@",self.chatInputView.textView.text);
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = self.info[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    params[@"nick_name"] = myDic[@"nick_name"];
//    NSLog(@"****%@",self.by_reply_nickName);
//    params[@"by_nick_name"] = self.by_reply_nickName;
//    params[@"by_user_id"] = self.by_reply_sid;
//    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    if (self.isTopic) {
//        params[@"speak_reply"] = @"0";
//    } else {
//        params[@"speak_reply"] = @"1";
//    }
//    params[@"disuss_id"] = self.discuss_id;
//    NSLog(@"****%@",params);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"####%@",url);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@",json);
//        if ([json[@"status"] integerValue] == 1) {
//            [self refreshData];
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //            [alert show];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
    
}
#pragma mark 点击表情
- (void)showEmotions:(UIButton *)sender
{
//    NSLog(@"表情");
//    if (self.chatInputView.emotionbutton.isSelected == NO) {
//        self.chatInputView.emotionbutton.selected = YES;
//        [_recordButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//        _recordButton.tag = DDVoiceInput;
//        [self.chatInputView willBeginInput];
//        if ([_currentInputContent length] > 0)
//        {
//            [self.chatInputView.textView setText:_currentInputContent];
//        }
//        
//        if (self.emotions == nil) {
//            self.emotions = [EmotionsViewController new];
//            [self.emotions.view setBackgroundColor:[UIColor darkGrayColor]];
//            self.emotions.view.frame=DDCOMPONENT_BOTTOM;
//            self.emotions.delegate = self;
//            [self.view addSubview:self.emotions.view];
//        }
//        if (_bottomShowComponent & DDShowKeyboard)
//        {
//            //显示的是键盘,这是需要隐藏键盘，显示表情，不需要动画
//            _bottomShowComponent = (_bottomShowComponent & 0) | DDShowEmotion;
//            [self.chatInputView.textView resignFirstResponder];
//            [self.emotions.view setFrame:DDEMOTION_FRAME];
//            [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
//        }
//        else if (_bottomShowComponent & DDShowEmotion)
//        {
//            //表情面板本来就是显示的,这时需要隐藏所有底部界面
//            [self.chatInputView.textView resignFirstResponder];
//            _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
//        }
//        //    else if (_bottomShowComponent & DDShowUtility)
//        //    {
//        //        //显示的是插件，这时需要隐藏插件，显示表情
//        //        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
//        //        [self.emotions.view setFrame:DDEMOTION_FRAME];
//        //        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
//        //    }
//        else
//        {
//            //这是什么都没有显示，需用动画显示表情
//            _bottomShowComponent = _bottomShowComponent | DDShowEmotion;
//            [UIView animateWithDuration:0.25 animations:^{
//                [self.emotions.view setFrame:DDEMOTION_FRAME];
//                [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
//            }];
//            [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
//        }
//        [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//        self.chatInputView.voiceButton.tag = DDVoiceInput;
//    } else {
//        self.chatInputView.emotionbutton.selected = NO;
//        [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//        self.chatInputView.voiceButton.tag = DDVoiceInput;
//        //        [self.chatInputView willBeginInput];
//        [self.chatInputView.textView becomeFirstResponder];
//    }
}

- (void)showUtilitys:(UIButton *)sender
{
//    [_recordButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//    _recordButton.tag = DDVoiceInput;
//    [self.chatInputView willBeginInput];
//    if ([_currentInputContent length] > 0)
//    {
//        [self.chatInputView.textView setText:_currentInputContent];
//    }
//    
//    if (self.ddUtility == nil)
//    {
//        self.ddUtility = [ChatUtilityViewController new];
//        self.ddUtility.delegate = self;
//        [self addChildViewController:self.ddUtility];
//        self.ddUtility.view.frame=CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width , 280);
//        [self.view addSubview:self.ddUtility.view];
//    }
//    
//    if (_bottomShowComponent & DDShowKeyboard)
//    {
//        //显示的是键盘,这是需要隐藏键盘，显示插件，不需要动画
//        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowUtility;
//        [self.chatInputView.textView resignFirstResponder];
//        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
//        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
//    }
//    else if (_bottomShowComponent & DDShowUtility)
//    {
//        //插件面板本来就是显示的,这时需要隐藏所有底部界面
//        //        [self p_hideBottomComponent];
//        [self.chatInputView.textView becomeFirstResponder];
//        _bottomShowComponent = _bottomShowComponent & DDHideUtility;
//    }
//    else if (_bottomShowComponent & DDShowEmotion)
//    {
//        //显示的是表情，这时需要隐藏表情，显示插件
//        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
//        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
//        _bottomShowComponent = (_bottomShowComponent & DDHideEmotion) | DDShowUtility;
//    }
//    else
//    {
//        //这是什么都没有显示，需用动画显示插件
//        _bottomShowComponent = _bottomShowComponent | DDShowUtility;
//        [UIView animateWithDuration:0.25 animations:^{
//            [self.ddUtility.view setFrame:DDUTILITY_FRAME];
//            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
//        }];
//        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
//        
//    }
}
#pragma mark 点击语音
- (void)p_clickThRecordButton:(UIButton *)button
{
//    switch (button.tag) {
//        case DDVoiceInput:
//            //开始录音
//            [self p_hideBottomComponent];
//            [button setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
//            button.tag = DDTextInput;
//            [self.chatInputView willBeginRecord];
//            [self.chatInputView.textView resignFirstResponder];
//            _currentInputContent = self.chatInputView.textView.text;
//            if ([_currentInputContent length] > 0)
//            {
//                [self.chatInputView.textView setText:nil];
//            }
//            break;
//        case DDTextInput:
//            //开始输入文字
//            [button setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//            button.tag = DDVoiceInput;
//            [self.chatInputView willBeginInput];
//            if ([_currentInputContent length] > 0)
//            {
//                [self.chatInputView.textView setText:_currentInputContent];
//            }
//            [self.chatInputView.textView becomeFirstResponder];
//            break;
//    }
}

#pragma mark 当键盘要弹起时
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
//    [self.chatInputView willBeginInput];
//    [self.bottomMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-keyboardRect.size.height);
//    }];
    [UIView animateWithDuration:.5 animations:^{
//        self.bottomMessageView.frame = CGRectMake(0, SCREEN_HEIGHT-49-keyboardRect.size.height, SCREEN_WIDTH, 49);
//        [self.view layoutIfNeeded];
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-keyboardRect.size.height);
    }];
}


#pragma mark 当键盘要收起时
- (void)keyboardWillHide:(NSNotification *)aNotification{

//    self.bottomMessageView.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
}

#pragma mark - 第一次进入时请求数据
- (void)requestResumeInfo{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":(_isRecruit?@"GetJobInfoMgr":@"GetResumeInfoMgr"),@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":self.userId,(_isRecruit?@"job_id":@"resume_id"):_resumeId};//kShareModel.dic[@"userid"]
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        self.tableView.hidden = NO;
        NearPersonalModel *model = [NearPersonalModel mj_objectWithKeyValues:json];
        [self updateResumeInfo:model];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark 点击分享是请求的数据
- (void)requestApplyList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetShare",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.dic[@"userid"],@"page":@(page),_isRecruit?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        for (ApplyCompanyList * modelList in model.list) {
            modelList.addTime = modelList.time;
        }
        
        dealsSuccess(model.list,(int)model.list.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestList:(NSInteger)page success:(void (^)(NSArray * datas, int more))dealsSuccess
{
    if (_currentType == WPResumeCheckMessageType) {
        [self requestMessageList:page success:^(NSArray *datas, int more) {
            dealsSuccess(datas , more);
        } error:^(NSError *error) {
            [self resetCurrentIndex];
        }];
    }else if (_currentType == WPResumeCheckShareType){
        [self requestApplyList:page success:^(NSArray *datas, int more) {
            dealsSuccess(datas , more);
        } error:^(NSError *error) {
            [self resetCurrentIndex];
        }];
    }else if (_currentType == WPResumeCheckBrowseType){
        [self requestCommitList:page success:^(NSArray *datas, int more) {
            dealsSuccess(datas , more);
        } error:^(NSError *error) {
            [self resetCurrentIndex];
        }];
    }else{
        return;
    }
}

- (void)resetCurrentIndex
{
    currentIndex -- ;
    [self resetPage];
}
#pragma mark 点击留言时请求数据
- (void)requestMessageList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":(_isRecruit?@"GetJobComment":@"GetResumeComment"),@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.dic[@"userid"],@"page":@(page),_isRecruit?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeMessageModel *model = [WPResumeMessageModel mj_objectWithKeyValues:json];
        
//        UIButton * button = (UIButton*)[self.headView viewWithTag:3];
//        [button setTitle:[NSString stringWithFormat:@"留言   %d",(int)model.CommentList.count] forState:UIControlStateNormal];
        
        dealsSuccess(model.CommentList,(int)model.CommentList.count);
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark 点击浏览时请求数据
- (void)requestCommitList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetBrowseList",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.dic[@"userid"],@"page":@(page),_isRecruit?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        dealsSuccess(model.browseList,(int)model.browseList.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestRecruitGetApplyCondition{
    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    apply.delegate = self;
    apply.sid = self.resumeId;
    [self.navigationController pushViewController:apply animated:YES];
    
    //NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    //WPShareModel *model = [WPShareModel sharedModel];
    //NSDictionary *params = @{@"action":@"ClickSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"jobId":self.resumeId};
    //[MBProgressHUD showMessage:@"" toView:self.view];
    //[WPHttpTool postWithURL:str params:params success:^(id json) {
        //[MBProgressHUD hideHUDForView:self.view];
        //if ([json[@"status"] isEqualToString:@"0"]) {
            //WPRecruitApplyChooseModel *model = [WPRecruitApplyChooseModel objectWithKeyValues:json];
            //if (model.resumeList.count) {
                //WPRecruitApplyChooseController *choose = [[WPRecruitApplyChooseController alloc]init];
                //choose.sid = self.resumeId;
                //[self.navigationController pushViewController:choose animated:YES];
            //}else{
                //WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
                //apply.delegate = self;
                //apply.sid = self.resumeId;
                //[self.navigationController pushViewController:apply animated:YES];
            //}
        //}else{
            //[MBProgressHUD showError:@"服务器连接失败" toView:self.view];
        //}
    //} failure:^(NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view];
        //NSLog(@"%@",error.localizedDescription);
    //}];
}

- (void)requestInterviewGetApplyCondition{
    WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
    apply.delegate = self;
    apply.sid = self.resumeId;
    [self.navigationController pushViewController:apply animated:YES];
    
    //NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    //WPShareModel *model = [WPShareModel sharedModel];
    //NSDictionary *params = @{@"action":@"ClickSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"resume_id":self.resumeId,@"ep_id":@""};
    //[MBProgressHUD showMessage:@"" toView:self.view];
    //[WPHttpTool postWithURL:str params:params success:^(id json) {
        //[MBProgressHUD hideHUDForView:self.view];
        //if ([json[@"status"] isEqualToString:@"0"]) {
            //WPInterviewApplyChooseModel *model = [WPInterviewApplyChooseModel objectWithKeyValues:json];
            //if (model.jobList.count) {
                //WPInterviewApplyChooseController *choose = [[WPInterviewApplyChooseController alloc]init];
                //choose.sid = self.resumeId;
                //[self.navigationController pushViewController:choose animated:YES];
            //}else{
                //WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
                //apply.delegate = self;
                //apply.sid = self.resumeId;
                //[self.navigationController pushViewController:apply animated:YES];
            //}
        //}else{
            //[MBProgressHUD showError:@"服务器连接失败" toView:self.view];
        //}
    //} failure:^(NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view];
        //NSLog(@"%@",error.localizedDescription);
    //}];
}

- (void)replyCommontWithModel{
//    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
//    NSDictionary *params = @{@"action":_isRecruit?@"AddCommentForJob":@"AddCommentForResume",
//                             @"username":kShareModel.username,
//                             @"password":kShareModel.password,
//                             @"user_id":kShareModel.dic[@"userid"],
//                             _isRecruit?@"job_id":@"resume_id":_resumeId,
//                             @"commentContent":self.chatInputView.textView.text,
//                             @"Replay_commentID":_replyCommentId,
//                             @"replay_user_id":_replyUserId,
//                             @"user_id" : kShareModel.userId};
//    [WPHttpTool postWithURL:str params:params success:^(id json) {
//        //[SPAlert alertControllerWithTitle:@"提示" message:json[@"info"] superController:self cancelButtonTitle:@"确认" cancelAction:nil];
//        [self.chatInputView.textView resignFirstResponder];
//        if ([json[@"status"] isEqualToString:@"0"]) {
//            self.chatInputView.textView.text = nil;
//            self.chatInputView.textView.placeholder = @"评论";
//            [self.chatInputView.textView resignFirstResponder];
//            [self.tableView.mj_header beginRefreshing];
//        }
//    } failure:^(NSError *error) {
//        [SPAlert alertControllerWithTitle:@"提示" message:error.localizedDescription superController:self cancelButtonTitle:@"确认" cancelAction:nil];
//    }];
}
#pragma  mark -- 更新head的数据
- (void)updateResumeInfo:(NearPersonalModel *)model{
    if (model.list.count == 0) {
        return;
    }
    NearPersonalListModel *listModel = model.list[0];
    self.headView.isRecruit = _isRecruit;
    self.headView.model = listModel;
    NSString * comcount = [NSString stringWithFormat:@"%@",listModel.comcount];
    NSString * shareCount = [NSString stringWithFormat:@"%@",listModel.shareCount];
    firstShareCount = shareCount.integerValue;
//    NSString * ranking = [NSString stringWithFormat:@"%@",listModel.ranking];
    UIButton * button = (UIButton*)[self.headView viewWithTag:1];
    UIButton * button1 = (UIButton*)[self.headView viewWithTag:2];
    UIButton * button2 = (UIButton*)[self.headView viewWithTag:3];
//    if (comcount.intValue > 0) {
        _currentType = WPResumeCheckMessageType;
        
        button.selected = NO;
        button1.selected = NO;
        button2.selected = YES;
        self.headView.sportLine.frame = CGRectMake(button2.left, button2.bottom-2, SCREEN_WIDTH/3, 2);
//    }
//    else
//    {
//        if (shareCount.intValue > 0) {
//            _currentType = WPResumeCheckShareType;
//            button.selected = NO;
//            button1.selected = YES;
//            button2.selected = NO;
//             self.headView.sportLine.frame = CGRectMake(button1.left, button1.bottom-2, SCREEN_WIDTH/3, 2);
//        }
//        else
//        {
//            _currentType = WPResumeCheckBrowseType;
//            button.selected = YES;
//            button1.selected = NO;
//            button2.selected = NO;
//             self.headView.sportLine.frame = CGRectMake(button.left, button.bottom-2, SCREEN_WIDTH/3, 2);
//        }
//    }
    [self requsetForReloadData];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentType == WPResumeCheckBrowseType) {
//        [self.tableView tableViewDisplayWitMsg:@"暂无浏览信息" ifNecessaryForRowCount:self.browseArray.count];
        return self.browseArray.count;
    }else if (_currentType == WPResumeCheckShareType){
//        [self.tableView tableViewDisplayWitMsg:@"暂无分享信息" ifNecessaryForRowCount:self.shareArray.count];
        return self.shareArray.count;
    }else{
//        [self.tableView tableViewDisplayWitMsg:@"暂无留言信息" ifNecessaryForRowCount:self.messageArray.count];
        return self.messageArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentType == WPResumeCheckMessageType) {//在留言界面
        static NSString *cellId = @"WPCommonCommentHeadCell";
        WPCommonCommentHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WPCommonCommentHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.tag = indexPath.row;
        cell .model = self.messageArray[indexPath.row];
        cell.ReplyBlock = ^(NSInteger number){
        };
        cell.UserInfoBlock = ^(NSString *userid, NSString *userName){//调到个人资料界面
            [self requireDataWithAciont:userid];
        };
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPresSCell:)];
        longPress.minimumPressDuration = 0.5;
        [cell addGestureRecognizer:longPress];
        
        if (indexPath.row == self.messageArray.count-1) {//在最后一个cell上添加下划线
//            WPResumeCheckMessageModel* model1 = self.messageArray[indexPath.row];
//            CGFloat height;
//            NSString * to_user_id = [NSString stringWithFormat:@"%@",model1.to_user_id];
//            if (to_user_id.intValue == 0) {
//                height  = [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"%@",model1.commentContent]];
//            }
//            else
//            {
//              height  = [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"回复 %@ ：%@",model1.to_user_name,model1.commentContent]];
//            }
//            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0,height-0.5, SCREEN_WIDTH, 0.5)];
//            line.backgroundColor = RGBColor(226, 226, 226);
//            [cell.contentView addSubview:line];
        }
        
        //第一个cell时隐藏线条
        
        return cell;
    }else{
        static NSString *cellId = @"WPResumeCheckApplyCell";
        WPResumeCheckApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WPResumeCheckApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (_currentType == WPResumeCheckShareType) {
            cell.listModel = self.shareArray[indexPath.row];
        }
        if (_currentType == WPResumeCheckBrowseType) {
            cell.listModel = self.browseArray[indexPath.row];
        }
        
//        if (indexPath.row == 0) {
//            cell.line.hidden = YES;
//        }
//        UILabel* lineLa = [[UILabel alloc] initWithFrame:CGRectMake(0,kHEIGHT(50)-0.5, SCREEN_WIDTH, 0.5)];
//        lineLa.backgroundColor = RGBColor(226, 226, 226);
//        //        _line.tag = 1000;
//        [cell.contentView addSubview:lineLa];

        return cell;
    }
}
#pragma mark 长按手势
-(void)longPresSCell:(UILongPressGestureRecognizer *)longGesture
{
    if ([longGesture state]==UIGestureRecognizerStateBegan) {
        currentCell  = (WPCommonCommentHeadCell*)longGesture.view;
        currentCell.selected = YES;
        [currentCell becomeFirstResponder];
        //    NSIndexPath * indexpath = [self.tableView indexPathForCell:currentCell];
        UIMenuController * menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        UIMenuItem * menuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(clickCopy:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem, nil]];
        [menuController setTargetRect:currentCell.frame inView:currentCell.superview];
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)WillHideMenu:(id)obje
{
    currentCell.selected = NO;
}
-(void)clickCopy:(id)objc
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSIndexPath * indexpath = [self.tableView indexPathForCell:currentCell];
    WPResumeCheckMessageModel * model = self.messageArray[indexpath.row];
    
    [pasteboard setString:[NSString stringWithFormat:@"%@",model.commentContent]];
}
#pragma mark 获取好友信息
- (void)requireDataWithAciont:(NSString*)userId
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"GetFriend";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSDictionary * dic = (NSDictionary*)json;
        NSArray * list = dic[@"list"];
        BOOL isOrNot = NO;
           PersonalInfoViewController * person = [[PersonalInfoViewController alloc]init];
        if (list.count)
        {
            for (NSDictionary* dictory in list) {
                NSString * friend_id = [NSString stringWithFormat:@"%@",dictory[@"friend_id"]];
                if ([friend_id isEqualToString:userId]) {
                    isOrNot = YES;
                }
                else
                {}
            }
            if (isOrNot) {
                person.newType = NewRelationshipTypeFriend;
            }
            else
            {
                person.newType = NewRelationshipTypeStranger;
             }
        }
        else//通讯录中没有好友跳到添加页面
        {
            
            person.newType = NewRelationshipTypeStranger;
        }
        person.friendID = [NSString stringWithFormat:@"%@",userId];
        [self.navigationController pushViewController:person animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentType == WPResumeCheckMessageType) {
        WPResumeCheckMessageModel *model = self.messageArray[indexPath.row];
        NSString * to_user_id = [NSString stringWithFormat:@"%@",model.to_user_id];
        if (to_user_id.intValue != 0) {
            
            NSString * commentContent = model.commentContent;
            commentContent = [WPMySecurities textFromBase64String:commentContent];
            commentContent = [WPMySecurities textFromEmojiString:commentContent];
            return [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"回复 %@ ：%@",model.to_nick_name,commentContent]];//[WPMySecurities textFromEmojiString:model.commentContent]
        }
        else
        {
            NSString * commentContent = model.commentContent;
            commentContent = [WPMySecurities textFromBase64String:commentContent];
            commentContent = [WPMySecurities textFromEmojiString:commentContent];
            
         return [WPCommonCommentHeadCell cellHeight:commentContent];//[NSString stringWithFormat:@"%@",[WPMySecurities textFromEmojiString:model.commentContent]]
        }
        
    }
    return kHEIGHT(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.inputBar.inputView resignFirstResponder];
//    self.inputBar.placeHolder = @"请输入留言";
    [self hideKeyBoard];
}
-(void)hideKeyBoard
{
    [_inputBar.inputView resignFirstResponder];
    _inputBar.keyboardTypeBtn.tag = 0;
    _inputBar.inputView.inputView = nil;
    [_inputBar.keyboardTypeBtn setImage:[UIImage imageNamed:@"common_biaoqing"] forState:UIControlStateNormal];
    _inputBar.placeHolder = @"请输入留言";
    [_inputBar.inputView reloadInputViews];
    _inputBar.inputView.text = @"";
    [_inputBar layout];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentType == WPResumeCheckMessageType) {//点击留言
        WPResumeCheckMessageModel *model = self.messageArray[indexPath.row];
        NSString * userID = [NSString stringWithFormat:@"%@",model.createdUserId];
        if ([userID isEqualToString:kShareModel.userId]) {//点击自己的评论
//            [self.inputBar.inputView resignFirstResponder];
            [UIView animateWithDuration:0.5 animations:^{
//                [self.inputBar.inputView resignFirstResponder];
                [self hideKeyBoard];
            } completion:^(BOOL finished) {
                deleteInter = indexPath.row;
                HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"删除", nil];
                [sheet show];
            }];
        }
        else//点击别人的评论
        {
            [self.inputBar.inputView becomeFirstResponder];
            _replyCommentId = model.commentId;
            _replyUserId = model.createdUserId;
            self.inputBar.placeHolder = [NSString stringWithFormat:@"回复:%@",model.userName];
            self.replayName = model.userName;
            [self.inputBar becomeFirstResponder];
        }
    }
    else
    {
        ApplyCompanyList *model;
        if (_currentType == WPResumeCheckShareType) {
            model = self.shareArray[indexPath.row];
            if ([model.is_an isEqualToString:@"0"]) {
                return;
            }
        }
        else
        {
            model = self.browseArray[indexPath.row];
        }
        [self requireDataWithAciont:[NSString stringWithFormat:@"%@",model.userId]];
    }
}

#pragma mark 进行删除操作
-(void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)//删除操作
    {
       
        deleteInter = -1;
    }
    else
    {
          [self deleteMyMessage:nil];
        
       
    }
}
-(void)deleteMyMessage:(NSString *)string
{
    
    NSString * urlStr = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPResumeCheckMessageModel *model = self.messageArray[deleteInter];
    NSDictionary * dic = @{@"action":_isRecruit?@"DelCommentForJob":@"DelCommentForResume",
                           @"username":kShareModel.username,
                           @"password":kShareModel.password,
                           @"user_id":kShareModel.userId,
                           @"comment_id":[NSString stringWithFormat:@"%@",model.commentId]};
    
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * statue = [NSString stringWithFormat:@"%@",json[@"status"]];
        if ([statue isEqualToString:@"0"]) {
//            [self.tableView.mj_header beginRefreshing];
            [self.messageArray removeObjectAtIndex:deleteInter];
            deleteInter = -1;
            [_tableView reloadData];
            
            UIButton * button = (UIButton*)[self.headView viewWithTag:3];
            [button setTitle:[NSString stringWithFormat:@"留言   %lu",self.messageArray.count] forState:UIControlStateNormal];
            if (self.messageArray.count == 0) {
                _isMessage = YES;
            }
        }
        else
        {
          
        }
    } failure:^(NSError *error) {
       
    }];

}
#pragma mark - ScrollView
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
////    if (scrollView == self.bodyView) {
////        UIButton *sender = UIButton.new;
////        for (int i = WPResumeCheckUserInfoTypeApplyTitle; i<=WPResumeCheckUserInfoTypeGlanceTitle; i++) {
////            UIButton *button = (UIButton *)[self.view viewWithTag:i];
////            button.selected = NO;
////        }
////        if (targetContentOffset->x == 0) {
////            UIButton *button = (UIButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyTitle];
////            button.selected = YES;
////            if (self.bottomGlanceView.superview){
////                [self.bottomGlanceView removeFromSuperview];
////            }
////            sender = button;
////        }
////        if (targetContentOffset->x == SCREEN_WIDTH) {
////            UIButton *button = (UIButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeMessageTitle];
////            button.selected = YES;
////            [self.view addSubview:self.bottomGlanceView];
////            sender = button;
////        }
////        if (targetContentOffset->x == SCREEN_WIDTH*2) {
////            UIButton *button = (UIButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeGlanceTitle];
////            button.selected = YES;
////            if (self.bottomGlanceView.superview){
////                [self.bottomGlanceView removeFromSuperview];
////            }
////            sender = button;
////        }
////        [self showOrHideBottomView:sender];
////        
////        (targetContentOffset->x == 0?[self.view bringSubviewToFront:self.bottomApplyView]:(targetContentOffset->x == SCREEN_WIDTH?[self.view bringSubviewToFront:self.bottomMessageView]:0));
////        
////        UILabel *indicater = (UILabel *)[self.view viewWithTag:WPResumeCheckUserInfoTypeIndicater];
////        [indicater mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.left.equalTo(sender.mas_left);
////            make.width.equalTo(sender.mas_width);
////            make.bottom.equalTo(sender.mas_bottom);
////            make.height.equalTo(@(2));
////        }];
//
////    }
//    [self.chatInputView.textView resignFirstResponder];
//    
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.chatInputView.textView resignFirstResponder];
//    if (self.bottomMessageView.superview) {
//        self.chatInputView.frame = self.bottomMessageView.bounds;
//    }
//}

//- (void)showOrHideBottomView:(UIButton *)sender{
//    if (sender.tag == WPResumeCheckUserInfoTypeGlanceTitle) {
//        self.bottomApplyView.hidden = NO;
//        self.bottomMessageView.hidden = NO;
//    }else{
//        self.bottomApplyView.hidden = NO;
//        self.bottomMessageView.hidden = YES;
//    }
//}

#pragma mark - Delegate 刷新报名状态
- (void)refreshApplyState{
    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
    button.contentLabel.text = (_isRecruit?@"已申请":@"已抢");
}

- (void)recruitApplyDelegate{
    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
    button.contentLabel.text = (_isRecruit?@"已申请":@"已抢");
}

- (void)interviewApplyDelegate{
    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
    button.contentLabel.text = (_isRecruit?@"已申请":@"已抢");
}

#pragma mark - 输入框Delegate
- (void)viewheightChanged:(float)height{
//    [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}
- (void)textViewEnterSend{
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
    [self replyCommontWithModel];
}

#pragma mark - 分享
- (void)shareAction:(UIButton *)sender{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":@"oneshareresume2",
                             @"resumeid":self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        if([json[@"status"] isEqualToString:@"1"]){
            [self requstModel:^(id string) {
              [self shareSingleWithUrl:json[@"url"]];
            }];
//            [self shareSingleWithUrl:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)shareSingleWithUrl:(NSString *)url{
    url = [IPADDRESS stringByAppendingString:url];
    WPSendToFriends *toFriends = [[WPSendToFriends alloc]init];
    toFriends.model = self.model;
    toFriends.isRecuilist = self.isRecruit;
    NSString * title = [toFriends shareDetailFromZhaopinOrQiuZhiandImage:(!self.isRecruit)?self.model.avatar:self.model.logo];
    
    [YYShareManager shareWithTitle:title url:[IPADDRESS stringByAppendingString:url] action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends) {
            [toFriends sendeToWeiPinFriends:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.toUserId = toUserId;
                linkMan.transStr = messageContent;
                linkMan.display_type = display_type;
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
        }
        if (type == YYShareManagerTypeWorkLines) {
            
        }
    } status:^(UMSocialShareResponse* status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
    }];
}

#pragma mark - Delegate 留言
- (void)jumpToPersonalPageWith:(NSString *)use_id andNickName:(NSString *)nickName{
    
}

- (void)commentTopicWith:(NSDictionary *)topicInfo{
    
}

@end
