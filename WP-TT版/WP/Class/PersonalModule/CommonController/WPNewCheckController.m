//
//  WPNewCheckController.m
//  WP
//
//  Created by CBCCBC on 16/2/2.
//  Copyright © 2016年 WP. All rights reserved.
// 工作圈查看个人主页

#import "WPNewCheckController.h"
#import "SPButton1.h"
#import "MTTDatabaseUtil.h"
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "ChatUtilityViewController.h"
#import "RecorderManager.h"
#import "WPInterviewApplyController.h"
#import "NearPersonalController.h"
#import "WPRecruitApplyController.h"
#import "WPResumeCheckApplyModel.h"
#import "WPResumeMessageModel.h"
#import "WPRecentLinkManController.h"
#import "WPResumeCheckController.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"
#import "WPRecruitDraftEditController.h"
#import "WPInterviewDraftEditController.h"
#import "WPInterviewDraftController.h"
#import "WPResumeCheckApplyCell.h"
#import "WPCommonCommentBodyCell.h"
#import "WPCommonCommentHeadCell.h"
#import "YYShareManager.h"
#import "RecentPersonController.h"
#import "PersonalInfoViewController.h"
#import "NearInterViewController.h"
#import "WPNewShareModel.h"
#import "WPInfoListController.h"
#import "WPSendToFriends.h"
#import "PersonalInfoViewController.h"
#import "UIMessageInputView.h"
#import "WPRefraeshController.h"
#import "ShareEditeViewController.h"
#import "HCInputBar.h"
#import "ReportViewController.h"
#import "HJCActionSheet.h"
#import "WPMySecurities.h"
#import "WPTitleView.h"
#import "WPBadgeButton.h"
#import "WPSysNotificationViewController.h"
@interface WPNewCheckController ()
<
UITableViewDelegate,
UITableViewDataSource,
JSMessageInputViewDelegate,
WPRecruitApplyDelegate,
WPInterviewApplyDelegate,
UIMessageInputViewDelegate,
UIGestureRecognizerDelegate,
HJCActionSheetDelegate
>
{
    BOOL isShow;
    WPCommonCommentHeadCell *currentCell;
    BOOL messageChange;
    NSInteger deleteInter;//删除的row
    NSInteger firstShareCount;//第一次请求时分享的数据个数
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableHeaderView;

@property (strong, nonatomic) UIView *bottomApplyView;
@property (strong, nonatomic) UIView *bottomMessageView;
@property (strong, nonatomic) UIView *bottomGlanceView;

@property (strong, nonatomic) NSMutableArray *applyArray;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *glanceArray;
@property (strong, nonatomic) NSMutableArray *shareArray;

@property (assign, nonatomic) NSInteger applyPage;
@property (assign, nonatomic) NSInteger messagePage;
@property (assign, nonatomic) NSInteger sharePage;
@property (assign, nonatomic) NSInteger glancePage;

@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property (nonatomic ,strong)NSString *messageText;

@property (nonatomic, strong) WPBadgeButton *badgBtn;//小红点
@property (nonatomic, strong) WPBadgeButton *badgBtn1;

//@property (assign, nonatomic) NSInteger selectedButtonTag;

@property (copy, nonatomic) NSString *browseCount;
@property (copy, nonatomic) NSString *shareCount;
@property (copy, nonatomic) NSString *messageCount;
@property (copy, nonatomic) NSString *applyCount;
@property (strong,nonatomic)HCInputBar *inputBar;
@property (assign,nonatomic)BOOL reloadShare;
@property (assign,nonatomic)BOOL reloadGlance;
@property (assign,nonatomic)BOOL reloadMessage;
@property (nonatomic, strong) WPTitleView * titleView;

//@property (assign, nonatomic) CGFloat glancePosition;
//@property (assign, nonatomic) CGFloat sharePosition;
//@property (assign, nonatomic) CGFloat messagePosition;
//@property (assign, nonatomic) CGFloat applyPosition;

//@property (assign, nonatomic) BOOL glancePositionState;
//@property (assign, nonatomic) BOOL sharePositionState;
//@property (assign, nonatomic) BOOL messagePositionState;
//@property (assign, nonatomic) BOOL applyPositionState;

@end

@implementation WPNewCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"查看";
    self.navigationItem.titleView = self.titleView;
    
//    self.title = @"查看";
//    self.view.backgroundColor = RGB(235, 235, 235);
    self.view.backgroundColor = [UIColor whiteColor];
    _applyPage = 1;
    _messagePage = 1;
    _glancePage = 1;
    _sharePage = 1;
    
    //_glancePosition = 0.0;
    //_sharePosition = 0.0;
    //_messagePosition = 0.0;
    //_applyPosition = 0.0;
    //_selectedButtonTag = 233+self.listType;
    
    if (!_replyCommentId.length) {
         _replyCommentId = @"";
    }
    if (!_replyUserId.length) {
         _replyUserId = @"";
    }
   
    _browseCount = @"浏览 0";
    _shareCount = @"分享 0";
    _messageCount = @"留言 0";
    _applyCount = self.type == WPMainPositionTypeRecruit?@"抢 0":@"申请 0";
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.hidden = YES;
    [self bottomApplyView];
//    [self bottomMessageView];
//    [self bottomGlanceView];
    [self.view addSubview:self.inputBar];
    if (_isFromMianShiMessage) {
        if (self.replayPerson.length) {
            self.inputBar.placeHolder = [NSString stringWithFormat:@"回复:%@",self.replayPerson];
        }
    }
    [_inputBar showInputViewContents:^(NSString *contents) {
#pragma mark 在这里获取发送的内容
        NSString * string = [NSString stringWithFormat:@"%@",contents];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!string.length) {
            [MBProgressHUD createHUD:@"请输入内容" View:self.view];
            return ;
        }
        self.inputBar.placeHolder = @"请输入留言";
        [self.inputBar.inputView resignFirstResponder];
        [self replayMessage:contents];
    }];
    [self requestResumeInfo];
    self.bottomMessageView.hidden = (self.listType == WPNewCheckListTypeMessage)?NO:YES;
    self.bottomApplyView.hidden = (self.listType == WPNewCheckListTypeApply)?NO:YES;
    self.bottomGlanceView.hidden = (self.listType == WPNewCheckListTypeShare)?NO:YES;
    
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        (self.listType == WPNewCheckListTypeBrowse)?make.bottom.equalTo(self.view):make.bottom.equalTo(self.view).offset(-49);
//    }];
//    
    //[[IQKeyboardManager sharedManager] disableInViewControllerClass:[WPNewCheckController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPNewCheckController class]];
    
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
    //在刷新界面上架成功时要刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUpSuccess)
                                                 name:@"DEFRESHUPSUCCESS"
                                               object:nil];
    
    //修改成功后查看界面刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(refreshData)
                                                 name:@"REFRESHCHECKDATA"
                                               object:nil];
    //企业投递删除成功更新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"deleteNumberOfCompany" object:nil];
//    [self requestApplyList:1 success:^(NSArray *datas, int more) {
//        [self.applyArray addObjectsFromArray:datas];
//    } error:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//    
//    [self requestCommitList:1 success:^(NSArray *datas, int more) {
//        [self.glanceArray addObjectsFromArray:datas];
//    } error:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//    
//    [self requestMessageList:1 success:^(NSArray *datas, int more) {
//        [self.messageArray removeAllObjects];
//        
//        [self.messageArray addObjectsFromArray:datas];
//    } error:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//    
//    [self requestShareList:1 success:^(NSArray *datas, int more) {
//        [self.shareArray addObjectsFromArray:datas];
//    } error:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    
//    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
//    _myMsgInputView.isAlwaysShow = YES;
//    _myMsgInputView.delegate = self;
    [self initNavc];
}
-(void)refreshUpSuccess
{
// [self.tableView.mj_header beginRefreshing];
    [self replaceRefresh];
    UIButton * button = (UIButton*)[self.tableHeaderView viewWithTag:23];
    SPButton1 * button1 = (SPButton1*)button;
    button1.selected = NO;
    button1.contentLabel.text = @"已上架";
}
-(void)refreshData
{
    [self requestResumeInfo];
}
#pragma mark 发送留言
-(void)replayMessage:(NSString*)content
{
    
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeRecruit)?@"AddCommentForJob":@"AddCommentForResume",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             (self.type == WPMainPositionTypeRecruit)?@"job_id":@"resume_id":_resumeId,
                             @"commentContent":content,
                             @"Replay_commentID":_replyCommentId,
                             @"replay_user_id":_replyUserId};
    _replyUserId = @"";
    _replyCommentId = @"";
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        
        if ([json[@"status"] isEqualToString:@"0"]) {
            self.listType = WPNewCheckListTypeMessage;
            UIButton * button = (UIButton*)[self.view viewWithTag:233];
            UIButton * button1 = (UIButton*)[self.view viewWithTag:234];
            UIButton * button2 = (UIButton*)[self.view viewWithTag:235];
            button.selected = NO;
            button1.selected = NO;
            button2.selected = YES;
            UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
            blueLine.left = self.listType*SCREEN_WIDTH/3;
            
//            [self.tableView.mj_header beginRefreshing];
            [self requestMessageList:1 success:^(NSArray *datas, int more) {
//                 messageChange = YES;
                [self.messageArray removeAllObjects];
                [self.messageArray addObjectsFromArray:datas];
                UIButton *messageBtn = (UIButton *)[self.view viewWithTag:235];
                [messageBtn setTitle:[NSString stringWithFormat:@"留言  %lu",(unsigned long)self.messageArray.count] forState:UIControlStateNormal];
                [_tableView reloadData];
                NSIndexPath * indesPath = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indesPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } error:^(NSError *error) {
                
            }];
           
//            [self.tableView scrollToRow:self.messageArray.count-1 inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
    } failure:^(NSError *error) {
        [SPAlert alertControllerWithTitle:@"提示" message:error.localizedDescription superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }];
}
- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        _inputBar.placeHolder = @"请输入留言";
    }
    return _inputBar;
}
#pragma mark 点击分享
-(void)initNavc
{
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

-(void)requstModel:(void(^)(id))Success
{
    NSDictionary * dic = nil;
    NSString * urlStr = nil;
    if (self.isRecuilist)//招聘
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
        if (self.isRecuilist)//招聘
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
-(void)shareSuccess
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeInterView?@"oneshareresume":@"onesharejob"),
                             (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
    } failure:^(NSError *error) {
    }];
}
-(void)rightBtnClick
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeInterView?@"oneshareresume2":@"onesharejob2"),
                             (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        if([json[@"status"] isEqualToString:@"1"]){
            
            [self requstModel:^(id string) {
              [self shareWitnUrlStr:json[@"url"]];
            }];
//            [self shareWitnUrlStr:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
    
//    NSString * urlStr;
//    if (self.isRecuilist == 0) {
//        urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_resume_info.aspx?resume_id=%@",IPADDRESS,_model.resumeId];
//    }
//    else
//    {
//        urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_EnterpriseRecruit.aspx?recruit_id=%@",IPADDRESS,_model.resumeId];
//    }
//    [YYShareManager newShareWithTitle:@"这是title" url:urlStr action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends)
//        {
//            //            NSLog(@"分享到微聘好友");
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
//            if(self.isRecuilist == WPMainPositionTypeRecruit){
//                if (jobids.length == 0) {
//                    jobids = _model.resumeId;
//                }else{
//                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
//                }
//                share_title = [@"招聘:" stringByAppendingString:_model.jobPositon];
//                if (!_model.avatar) {
//                    _model.avatar = @"";
//                }
//                [jobPhoto addObject:@{@"small_address":_model.logo}];
//                name = _model.enterpriseName;
//                
//                i ++;
//                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
//                                                                                           @"jobids":jobids,
//                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
//                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
//                                                                                                         @"share_title":share_title,
//                                                                                                         @"name":name}}];
//                
//                share.shareInfo = dic;
//            }else{
//                if (jobids.length == 0) {
//                    jobids = _model.resumeId;
//                }else{
//                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
//                }
////                share_title = [@"求职:" stringByAppendingString:_model.HopePosition];
//                share_title = [NSString stringWithFormat:@"求职:%@",_model.HopePosition];
//                if (!_model.avatar) {
//                    _model.avatar = @"";
//                }
//                [jobPhoto addObject:@{@"small_address":_model.avatar}];
//                name = _model.name;
//                sex = _model.sex;
//                birthday = _model.birthday;
//                education = _model.education;
//                workTime = _model.WorkTim;
//                i ++;
//                //                }
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
//                //                [self hidden];
//                [MBProgressHUD createHUD:@"分享成功" View:self.view];
//                
//                UIButton * shareBtn = (UIButton*)[self.view viewWithTag:234];
//                  [shareBtn setTitle:[NSString stringWithFormat:@"分享  %ld",(long)(++firstShareCount)] forState:UIControlStateNormal];
//                [self requestShareList:1 success:^(NSArray *datas, int more) {
//                    [self.shareArray removeAllObjects];
//                    [self.shareArray addObjectsFromArray:datas];
//                    if (self.listType == WPNewCheckListTypeShare) {
//                        [_tableView reloadData];
//                    }
//                } error:^(NSError *error) {
//                    
//                }];
////                if (self.listType == WPNewCheckListTypeShare) {
////                    [self.tableView.mj_header beginRefreshing];
////                }
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
//            UIButton * shareBtn = (UIButton*)[self.view viewWithTag:234];
//            [shareBtn setTitle:[NSString stringWithFormat:@"分享  %ld",(long)(++firstShareCount)] forState:UIControlStateNormal];
//            [self requestShareList:1 success:^(NSArray *datas, int more) {
//                [self.shareArray removeAllObjects];
//                [self.shareArray addObjectsFromArray:datas];
//                if (self.listType == WPNewCheckListTypeShare) {
//                    [self.tableView reloadData];
//                }
//            } error:^(NSError *error) {
//                
//            }];
////            if (self.listType == WPNewCheckListTypeShare) {
////                [self.tableView.mj_header beginRefreshing];
////            }
//        }
//    }];
}
-(void)shareWitnUrlStr:(NSString*)urlString
{
    urlString = [IPADDRESS stringByAppendingString:urlString];
    WPSendToFriends *toFriends = [[WPSendToFriends alloc]init];
    toFriends.model = self.model;
    toFriends.isRecuilist = (self.type != WPMainPositionTypeInterView);
    NSString * title = [toFriends shareDetailFromZhaopinOrQiuZhiandImage:((self.type == WPMainPositionTypeInterView)?self.model.avatar:self.model.logo)];
    [YYShareManager newShareWithTitle:title url:urlString action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
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
            if(self.isRecuilist == WPMainPositionTypeRecruit){
                if (jobids.length == 0) {
                    jobids = _model.resumeId;
                }else{
                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
                }
                share_title = [@"招聘:" stringByAppendingString:_model.jobPositon];
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
                //                share_title = [@"求职:" stringByAppendingString:_model.HopePosition];
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
                
                UIButton * shareBtn = (UIButton*)[self.view viewWithTag:234];
                [shareBtn setTitle:[NSString stringWithFormat:@"分享  %ld",(long)(++firstShareCount)] forState:UIControlStateNormal];
                [self requestShareList:1 success:^(NSArray *datas, int more) {
                    [self.shareArray removeAllObjects];
                    [self.shareArray addObjectsFromArray:datas];
                    if (self.listType == WPNewCheckListTypeShare) {
                        [_tableView reloadData];
                    }
                } error:^(NSError *error) {
                    
                }];
                [self shareSuccess];
                //                if (self.listType == WPNewCheckListTypeShare) {
                //                    [self.tableView.mj_header beginRefreshing];
                //                }
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
            UIButton * shareBtn = (UIButton*)[self.view viewWithTag:234];
            [shareBtn setTitle:[NSString stringWithFormat:@"分享  %ld",(long)(++firstShareCount)] forState:UIControlStateNormal];
            [self requestShareList:1 success:^(NSArray *datas, int more) {
                [self.shareArray removeAllObjects];
                [self.shareArray addObjectsFromArray:datas];
                if (self.listType == WPNewCheckListTypeShare) {
                    [self.tableView reloadData];
                     UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
                    if (self.shareArray.count)
                    {
                        label.hidden = YES;
                    }
                    else
                    {
                        label.hidden = NO;
                    }
                }
            } error:^(NSError *error) {
                
            }];
            //            if (self.listType == WPNewCheckListTypeShare) {
            //                [self.tableView.mj_header beginRefreshing];
            //            }
        }
    }];

}
-(void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
    //    report.speak_trends_id = self.info[@"sid"];
    report.speak_trends_id = self.subId;
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
}
- (NSMutableArray *)applyArray{
    if (!_applyArray) {
        _applyArray = [[NSMutableArray alloc]init];
    }
    return _applyArray;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
}

- (NSMutableArray *)glanceArray{
    if (!_glanceArray) {
        _glanceArray = [[NSMutableArray alloc]init];
    }
    return _glanceArray;
}

- (NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [[NSMutableArray alloc]init];
    }
    return _shareArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tableFooterView = [[UIView alloc]init];
//            tableView.backgroundColor = RGB(235, 235, 235);
            tableView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:tableView];// make.top.equalTo(button.mas_bottom).offset(-0.5);
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.offset(64);
                make.bottom.equalTo(self.view).offset(-50);
//                make.bottom.offset(-50);
//                make.bottom.equalTo(self.view).offset(-50);
            }];
            tableView;
        });
        WS(ws);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (ws.listType == WPNewCheckListTypeBrowse) {
                _glancePage = 1;
                [ws requestCommitList:_glancePage success:^(NSArray *datas, int more) {
                    [_tableView.mj_footer resetNoMoreData];
                    [ws.glanceArray removeAllObjects];
                    [ws.glanceArray addObjectsFromArray:datas];
                     UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
                    label.hidden = ws.glanceArray.count;
                    [ws.tableView reloadData];
                    UIButton * button = (UIButton*)[self.view viewWithTag:233];
                    [button setTitle:[NSString stringWithFormat:@"浏览  %lu",(unsigned long)ws.glanceArray.count] forState:UIControlStateNormal];
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                    
                }];
                [_tableView.mj_header endRefreshing];
            }
            if (ws.listType == WPNewCheckListTypeShare) {
                _sharePage = 1;
                [ws requestShareList:_sharePage success:^(NSArray *datas, int more) {
                    [_tableView.mj_footer resetNoMoreData];
                    [ws.shareArray removeAllObjects];
                    [ws.shareArray addObjectsFromArray:datas];
                    UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
                    label.hidden = ws.shareArray.count;
                    [_tableView reloadData];
                    firstShareCount = self.shareArray.count;
                    UIButton * button = (UIButton*)[self.view viewWithTag:234];
                    [button setTitle:[NSString stringWithFormat:@"分享  %lu",(unsigned long)ws.shareArray.count] forState:UIControlStateNormal];
                    if (_isFromMianShiMessage) {
                        _isFromMianShiMessage = NO;
                        NSIndexPath * indexpath = [[NSIndexPath alloc]init];
                        for (int i = 0 ; i < self.shareArray.count; i++) {
                            ApplyCompanyList * model = self.shareArray[i];
                            if ([model.shareId isEqualToString:self.scrollerID]) {
                                indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                            }
                        }
                        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                [_tableView.mj_header endRefreshing];
            }
            if (ws.listType == WPNewCheckListTypeMessage) {
                _messagePage = 1;
                [ws requestMessageList:_messagePage success:^(NSArray *datas, int more) {
                    [_tableView.mj_footer resetNoMoreData];
                    [ws.messageArray removeAllObjects];
                    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:datas];
                    [ws.messageArray addObjectsFromArray:array];
                    UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
                    label.hidden = ws.messageArray.count;
                    [ws.tableView reloadData];
                    UIButton * button = (UIButton*)[self.view viewWithTag:235];
                    [button setTitle:[NSString stringWithFormat:@"留言  %lu",(unsigned long)ws.messageArray.count] forState:UIControlStateNormal];
                    if (_isFromMianShiMessage) {
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
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                [_tableView.mj_header endRefreshing];
            }
            if (ws.listType == WPNewCheckListTypeApply) {
                _applyPage = 1;
                [ws requestApplyList:_applyPage success:^(NSArray *datas, int more) {
                    [_tableView.mj_footer resetNoMoreData];
                    [ws.applyArray removeAllObjects];
                    [ws.applyArray addObjectsFromArray:datas];
                    [ws.tableView reloadData];
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                [_tableView.mj_header endRefreshing];
                
            }
            
        }];
        
//        [_tableView.mj_header beginRefreshing];
        [self replaceRefresh];
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if (ws.listType == WPNewCheckListTypeBrowse) {
//                _glancePage ++;
//                [ws requestCommitList:_glancePage success:^(NSArray *datas, int more) {
//                    if (more == 0) {
//                        //[_tableView.mj_footer noticeNoMoreData];
//                    }else{
//                        [ws.glanceArray addObjectsFromArray:datas];
//                        [ws.tableView reloadData];
//                        UIButton * button = (UIButton*)[self.view viewWithTag:233];
//                        [button setTitle:[NSString stringWithFormat:@"浏览  %lu",(unsigned long)ws.glanceArray.count] forState:UIControlStateNormal];
//                    }
//                } error:^(NSError *error) {
//                    NSLog(@"%@",error.localizedDescription);
//                }];
//                [_tableView.mj_footer endRefreshing];
//            }
//            
//            if (ws.listType == WPNewCheckListTypeShare) {
//                _sharePage ++;
//                [ws requestShareList:_sharePage success:^(NSArray *datas, int more) {
//                    if (more) {
//                        
//                    }else{
//                        [ws.shareArray addObjectsFromArray:datas];
//                        [ws.tableView reloadData];
//                        UIButton * button = (UIButton*)[self.view viewWithTag:234];
//                        [button setTitle:[NSString stringWithFormat:@"分享  %lu",(unsigned long)ws.shareArray.count] forState:UIControlStateNormal];
//                    }
//                } error:^(NSError *error) {
//                    NSLog(@"%@",error.localizedDescription);
//                }];
//                
//                [_tableView.mj_footer endRefreshing];
//            }
//            if (ws.listType == WPNewCheckListTypeMessage) {
//                _messagePage ++;
//                [ws requestMessageList:_messagePage success:^(NSArray *datas, int more) {
//                    if (more == 0) {
//                        //[_tableView.mj_footer noticeNoMoreData];
//                    }else{
//                        [ws.messageArray addObjectsFromArray:datas];
//                        [ws.tableView reloadData];
//                        UIButton * button = (UIButton*)[self.view viewWithTag:235];
//                        [button setTitle:[NSString stringWithFormat:@"留言  %lu",(unsigned long)ws.messageArray.count] forState:UIControlStateNormal];
//                    }
//                } error:^(NSError *error) {
//                    NSLog(@"%@",error.localizedDescription);
//                }];
//                [_tableView.mj_footer endRefreshing];
//            }
//            if (ws.listType == WPNewCheckListTypeApply) {
//                _applyPage ++;
//                [ws requestApplyList:_applyPage success:^(NSArray *datas, int more) {
//                    if (more == 0) {
//                        //[_tableView.mj_footer noticeNoMoreData];
//                    }else{
//                        [ws.applyArray addObjectsFromArray:datas];
//                        [ws.tableView reloadData];
//                    }
//                } error:^(NSError *error) {
//                    NSLog(@"%@",error.localizedDescription);
//                }];
//                [_tableView.mj_footer endRefreshing];
//            }
//        }];
        
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

- (void)tapAction:(UITapGestureRecognizer *)tap
{

//    [self.myMsgInputView isAndResignFirstResponder];
}

- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView =({
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
            view.backgroundColor = [UIColor whiteColor];
            
            view;
        });
        
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        [self.tableHeaderView addGestureRecognizer:tap];
        //添加第一行下的点击事件
        UIButton * headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn addTarget:self action:@selector(clickHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:headBtn];
        [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kHEIGHT(43)+kHEIGHT(10)));
            make.left.equalTo(_tableHeaderView);
            make.top.equalTo(_tableHeaderView);
        }];
        
        
        UIImageView *headImageView = [UIImageView new];
        headImageView.image = [UIImage imageNamed:@"head_default"];
        headImageView.layer.cornerRadius = 5;
        headImageView.clipsToBounds = YES;
        headImageView.tag = WPResumeCheckUserInfoTypeIcon;
        [_tableHeaderView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
            make.left.offset(kHEIGHT(10));
            make.top.offset(kHEIGHT(10));
        }];
        
        //时间
        UILabel *timeLabel = [UILabel new];
        timeLabel.text = @"";
        timeLabel.font = kFONT(10);
        timeLabel.textColor = RGB(127, 127, 127);
        timeLabel.tag = WPResumeCheckUserInfoTypeTime;
        [_tableHeaderView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableHeaderView.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        //标题
        UILabel *titleLabel =  [UILabel new];
        titleLabel.text = @"";
        titleLabel.tag = WPResumeCheckUserInfoTypeTitle;
        titleLabel.font = kFONT(15);
        [_tableHeaderView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.lessThanOrEqualTo(headImageView.mas_right).offset(10);
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.top.equalTo(headImageView);
            make.right.equalTo(_tableHeaderView.mas_right).offset(-60);
           // make.right.lessThanOrEqualTo(timeLabel.mas_left).offset(0);
            //make.right.equalTo(timeLabel.mas_left).offset(0);
            make.height.equalTo(headImageView).multipliedBy(2/4.0);
            //make.width.mas_equalTo(100);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
        }];
        
        UILabel *detailLabel = [UILabel new];
        detailLabel.text = @"";
        detailLabel.font = kFONT(12);
        detailLabel.textColor = RGB(127, 127, 127);
        detailLabel.tag = WPResumeCheckUserInfoTypeContent;
        [_tableHeaderView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom);
            make.bottom.equalTo(headImageView);
            make.right.equalTo(_tableHeaderView);
        }];
        
        UILabel *fline = [UILabel new];
        fline.backgroundColor = RGB(226, 226, 226);
        [_tableHeaderView addSubview:fline];
        [fline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-kHEIGHT(10));
            make.top.equalTo(headImageView.mas_bottom);//.offset(kHEIGHT(10)-0.5);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(titleLabel);
        }];
        
        UIButton *fbutton = [UIButton new];
        fbutton.backgroundColor = [UIColor whiteColor];
        [_tableHeaderView addSubview:fbutton];
        fbutton.tag = 9;
        [fbutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        [fbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(_tableHeaderView);
            make.top.equalTo(fline.mas_bottom);
            make.height.mas_equalTo(43);
        }];
        
        UILabel *company = [UILabel new];
        company.text = self.isRecuilist?@"求职申请":@"企业投递";
        company.font = kFONT(12);
        [fbutton addSubview:company];
        [company mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(fbutton);
            make.left.equalTo(titleLabel);
        }];
        
        CGSize size = [@"企业投递" getSizeWithFont:FUCKFONT(12) Height:43];
        
        self.badgBtn = [[WPBadgeButton alloc]init];
        [fbutton addSubview:self.badgBtn];
        [self.badgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(company.mas_left).offset(size.width+6);
            make.centerY.equalTo(company);
        }];
        
        
        UIImageView *cimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        [fbutton addSubview:cimageView];
        [cimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 14));
            make.right.offset(-kHEIGHT(10));
            make.centerY.equalTo(fbutton);
        }];
    
        //企业投递消息
        UILabel *number = [UILabel new];
        number.font = kFONT(12);
        number.textColor = RGB(180, 180, 180);
        [fbutton addSubview:number];
        number.tag = 1001;
        [number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(company);
            make.right.equalTo(cimageView.mas_left).offset(-8);
        }];
        
        UILabel *line = [UILabel new];
        line.backgroundColor = RGB(226, 226, 226);
        [_tableHeaderView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-kHEIGHT(10));
            make.top.equalTo(company.mas_bottom);//.offset(kHEIGHT(10)-0.5);
            make.height.mas_equalTo(0.5);
            make.left.equalTo(titleLabel);
        }];
        
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor whiteColor];
        [_tableHeaderView addSubview:button];
        button.tag = 10;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(_tableHeaderView);
            make.top.equalTo(line.mas_bottom);
            make.height.mas_equalTo(43);
        }];
        
        UILabel *sysMessage = [UILabel new];
        sysMessage.text = @"系统消息";
        sysMessage.font = kFONT(12);
        [button addSubview:sysMessage];
        [sysMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(button);
            make.left.equalTo(titleLabel);
        }];

        self.badgBtn1 = [[WPBadgeButton alloc]init];
        [button addSubview:self.badgBtn1];
        [self.badgBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(sysMessage.mas_left).offset(size.width+6);
            make.centerY.equalTo(sysMessage);
        }];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        [button addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 14));
            make.right.offset(-kHEIGHT(10));
            make.centerY.equalTo(button);
        }];
        
        
        
        //系统消息
        UILabel *number1 = [UILabel new];
        number1.font = kFONT(12);
        number1.textColor = RGB(180, 180, 180);
        [button addSubview:number1];
        number1.tag = 1002;
        [number1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(sysMessage);
            make.right.equalTo(imageView.mas_left).offset(-8);
        }];
        
        
        UILabel *line1 = [UILabel new];
        line1.backgroundColor = RGB(226, 226, 226);
        [_tableHeaderView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-kHEIGHT(10));
            make.top.equalTo(button.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(1);
            make.left.equalTo(sysMessage);
        }];
        
        CGFloat top = kHEIGHT(43)+kHEIGHT(10)+43+43+1;
        CGFloat x = kHEIGHT(63);
        CGFloat width = (SCREEN_WIDTH - x)/4;
        
        SPButton1 *delButton = [[SPButton1 alloc]initWithFrame:CGRectMake( x-2, top, width, kHEIGHT(36)) title:@"删除" ImageName:@"quanzhi_shanchu" Target:self Action:@selector(operationClick:)];
        [delButton setContentLabelSize:@"删除" font:FUCKFONT(12)];
        delButton.tag = 20;
        //        [delButton setContentAlignment:SPButtonContentAlignmentLeft];
        [_tableHeaderView addSubview:delButton];
        
        SPButton1 *editButton = [[SPButton1 alloc]initWithFrame:CGRectMake(delButton.right, top, width, kHEIGHT(36)) title:@"修改" ImageName:@"quanzhi_xiugai" Target:self Action:@selector(operationClick:)];
        [editButton setContentLabelSize:@"修改" font:FUCKFONT(12)];
        editButton.tag = 21;
        //        [editButton setContentAlignment:SPButtonContentAlignmentLeft];
        [_tableHeaderView addSubview:editButton];
        
        SPButton1 *refButton = [[SPButton1 alloc]initWithFrame:CGRectMake(editButton.right, top, width, kHEIGHT(36)) title:@"刷新" ImageName:@"quanzhi_shuaxin" Target:self Action:@selector(operationClick:)];
        [refButton setContentLabelSize:@"刷新" font:FUCKFONT(12)];
        refButton.tag = 22;
        //        [refButton setContentAlignment:SPButtonContentAlignmentLeft];
        [_tableHeaderView addSubview:refButton];
        
        SPButton1 *downButton = [[SPButton1 alloc]initWithFrame:CGRectMake(refButton.right, top, width, kHEIGHT(36)) title:@"已上架" ImageName:@"quanzhi_yixiajiapr" Target:self Action:@selector(operationClick:)];
        [downButton setContentLabelSize:@"已上架" font:FUCKFONT(12)];
        downButton.contentLabel.textColor = RGB(0, 172, 255);
        downButton.tag = 23;
        downButton.selected = NO;
        //        [downButton setContentAlignment:SPButtonContentAlignmentLeft];
        [_tableHeaderView addSubview:downButton];
        
        //SPButton1 *upButton = [[SPButton1 alloc]initWithFrame:CGRectMake(downButton.right, top, SCREEN_WIDTH/5, kHEIGHT(36)) title:@"推广" ImageName:@"tuiguang" Target:self Action:@selector(operationClick:)];
        //[upButton setContentLabelSize:@"推广" font:FUCKFONT(12)];
        //upButton.tag = 24;
        //[_tableHeaderView addSubview:upButton];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, downButton.bottom, SCREEN_WIDTH, 8)];
        label.backgroundColor = RGB(235, 235, 235);
        [_tableHeaderView addSubview:label];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom, SCREEN_WIDTH, kHEIGHT(36))];
        view.backgroundColor = RGB(235, 235, 235);
        [_tableHeaderView addSubview:view];
        
        NSArray *titles = @[_browseCount,_shareCount,_messageCount,_applyCount];
        
        UIView *lastView = nil;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton new];
            button.tag = 233+i;
            button.titleLabel.font = kFONT(12);
            button.selected = (self.listType == i)?YES:NO;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
            [button setTitleColor:RGB(90,110,150) forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(viewForHeaderInSectionActions:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view);
                make.left.equalTo((lastView?lastView.mas_right:view.mas_left));
                make.width.equalTo(view).dividedBy(3);
                make.bottom.equalTo(view);
            }];
            
            lastView = button;
        }
        
        UILabel *blueLine = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, view.height-2, SCREEN_WIDTH/3, 2)];
        blueLine.backgroundColor = RGB(90,110,150);
        blueLine.tag = 2333;
        [view addSubview:blueLine];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height-0.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = RGB(226, 226, 226);
        line2.tag = 2334;
        [view addSubview:line2];
        
        _tableHeaderView.height = view.bottom;
        
    }
    return _tableHeaderView;
}
#pragma mark 点击第一行
-(void)clickHeadBtn:(UIButton*)sender
{
    WS(ws);
    if (self.type == WPMainPositionTypeRecruit) {
        [self requestCompanyInfo:self.resumeId success:^(WPRecruitDraftInfoModel *model) {
            NSString *  Require = model.Require;
           Require = [WPMySecurities textFromBase64String:Require];
            Require = [WPMySecurities textFromEmojiString:Require];
            model.Require = Require;
            
            
            NSString * string = model.enterpriseBrief;
            string = [WPMySecurities textFromBase64String:string];
            string = [WPMySecurities textFromEmojiString:string];
            model.enterpriseBrief = string;
            
            
            WPRecruitDraftEditController *edit = [[WPRecruitDraftEditController alloc]init];
            edit.type = WPInterviewEditTypeInfo;
            edit.Infomodel = model;
            //edit.listFix = self.listFix;
            [ws.navigationController pushViewController:edit animated:YES];
        }];
    }else{
        [self getInterviewResumeDraftDetail:self.resumeId success:^(WPInterviewDraftInfoModel *model) {
            
            NSString * lightspotList = model.lightspotList;
            lightspotList = [WPMySecurities textFromBase64String:lightspotList];
            lightspotList = [WPMySecurities textFromEmojiString:lightspotList];
            model.lightspotList = lightspotList;
            
            NSArray * workArray = model.workList;
            for (Worklist* list in workArray) {
                NSArray * expList = list.expList;
                for (WPRemarkModel * model in expList) {
                    NSString * txtcontent = model.txtcontent;
                    txtcontent = [WPMySecurities textFromBase64String:txtcontent];
                    txtcontent = [WPMySecurities textFromEmojiString:txtcontent];
                    model.txtcontent = txtcontent;
                }
            }
            
            NSArray * eeduArray = model.educationList;
            for (Educationlist* list in eeduArray) {
                NSArray * expList = list.expList;
                for (WPRemarkModel * model in expList) {
                    NSString * txtcontent = model.txtcontent;
                    txtcontent = [WPMySecurities textFromBase64String:txtcontent];
                    txtcontent = [WPMySecurities textFromEmojiString:txtcontent];
                    model.txtcontent = txtcontent;
                }
            }
            
            
            WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
            edit.type = WPInterviewEditTypeInfo;
            edit.draftInfoModel = model;
            edit.lightspot = model.lightspotList;
            edit.listFix = self.listFix;
            [ws.navigationController pushViewController:edit animated:YES];
        }];
    }

}
- (UIView *)bottomApplyView{
    if (!_bottomApplyView) {
        _bottomApplyView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomApplyView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomApplyView];
        
        NSString *title = nil;
        
        title = (self.type == WPMainPositionTypeRecruit?@"申请":@"抢人");
        
        SPButton *button = [[SPButton alloc]initWithFrame:_bottomApplyView.bounds title:title ImageName:@"baoming_gray" Target:self Action:@selector(applyAction:)];
        button.tag = WPResumeCheckUserInfoTypeApplyAction;
        [button setContentLabelSize:title font:15];
        [_bottomApplyView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [_bottomApplyView addSubview:line];
    }
    return _bottomApplyView;
}

- (UIView *)bottomMessageView{
//    if (!_bottomMessageView) {
//        _bottomMessageView = [[UIView alloc]init];
//        _bottomMessageView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_bottomMessageView];
//        [_bottomMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.width.bottom.equalTo(self.view);
//            make.height.equalTo(@49);
//        }];
//    }
    return nil;
}

- (UIView *)bottomGlanceView{
//    if (!_bottomGlanceView) {
//        _bottomGlanceView = [[UIView alloc]init];
//        _bottomGlanceView.backgroundColor = [UIColor lightGrayColor];
//        [self.view addSubview:_bottomGlanceView];
//        [_bottomGlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.width.bottom.equalTo(self.view);
//            make.height.equalTo(@49);
//        }];
//        
//        SPButton *button = [[SPButton alloc]initWithFrame:_bottomApplyView.bounds title:@"分享" ImageName:@"baoming_gray" Target:self Action:@selector(shareAction:)];
//        //button.tag = WPResumeCheckUserInfoTypeApplyAction;
//        [button setContentLabelSize:@"分享" font:15];
//        [_bottomGlanceView addSubview:button];
//        
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(226, 226, 226);
//        [_bottomGlanceView addSubview:line];
//    }
    return nil;
}

#pragma mark - actions
- (void)applyAction:(UIButton *)sender{
    
    self.type == WPMainPositionTypeRecruit?[self requestRecruitGetApplyCondition]:[self requestInterviewGetApplyCondition];
}

//- (void)shareAction:(UIButton *)sender{
//    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
//    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeInterView?@"oneshareresume":@"onesharejob"),
//                             (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):self.resumeId,
//                             @"user_id":kShareModel.userId,
//                             };
//    
//    [WPHttpTool postWithURL:str params:params success:^(id json) {
//        
//        if([json[@"status"] isEqualToString:@"1"]){
//            [self shareSingleWithUrl:json[@"url"]];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//}
#pragma mark 删除修改刷新上下架
- (void)operationClick:(UIButton *)sender{
    switch (sender.tag-20) {
        case 0:
            [self deleteInterview];//删除
            break;
        case 1:
            NSLog(@"编辑");
            [self editInterview];//修改
            break;
        case 2:
            NSLog(@"刷新");
            [self refreshInterview];//刷新
            break;
        case 3:
            NSLog(@"下架");
            [self shelfInterview];//上下架
            break;
        case 4:
            NSLog(@"推广");
            [self ExtensionInterview];
            break;
        default:
            break;
    }
}

//评论
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text
{
    if (text.length == 0) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"输入内容不能为空哦~" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        return;
    }else{
        self.messageText = text;
        NSString* parten = @"\\s";
        NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
        NSString* checkoutText = [reg stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
        if ([checkoutText length] == 0)
        {
            return;
        }
        NSLog(@"发送消息：%@",text);
        [self replyCommontWithModel];
    }

    [self.myMsgInputView isAndResignFirstResponder];
}

- (void)showEmotions:(UIButton *)sender
{
    
}

- (void)showUtilitys:(UIButton *)sender
{
    
}

- (void)p_clickThRecordButton:(UIButton *)button
{
    
}

//监测键盘弹起收起
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [self.bottomMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardRect.size.height);
    }];
    [UIView animateWithDuration:.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [self.bottomMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [UIView animateWithDuration:.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 分享
- (void)shareSingleWithUrl:(NSString *)url{
    
//    [YYShareManager shareWithTitle:@"这是title" url:[IPADDRESS stringByAppendingString:url] action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends) {
//            RecentPersonController *recent = [[RecentPersonController alloc]init];
//            //recent.shareArray = @[self.selectedModel];
//            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:recent];
//            [self presentViewController:navc animated:YES completion:nil];
//        }
//        if (type == YYShareManagerTypeWorkLines) {
//            
//        }
//    } status:^(UMSResponseCode status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
//    }];
}

#pragma mark - Network
- (void)requestResumeInfo{
    NSString *str = [IPADDRESS stringByAppendingString:self.type == WPMainPositionTypeRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeRecruit?@"GetJobInfoMgr":@"GetResumeInfoMgr"),
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             (self.type == WPMainPositionTypeRecruit?@"job_id":@"resume_id"):_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        self.tableView.hidden = NO;
        NearPersonalModel *model = [NearPersonalModel mj_objectWithKeyValues:json];
        [self updateResumeInfo:model];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD createHUD:@"网络错误,请稍后重试" View:self.view];
    }];
}

- (void)requestApplyList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:(self.type == WPMainPositionTypeRecruit)?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetSignList",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],@"page":@(page),
                             (self.type == WPMainPositionTypeRecruit)?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        dealsSuccess(model.signList,(int)model.signList.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark 请求留言的数据
- (void)requestMessageList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:(self.type == WPMainPositionTypeRecruit)?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":((self.type == WPMainPositionTypeRecruit)?@"GetJobComment":@"GetResumeComment"),
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             @"page":@(page),
                             (self.type == WPMainPositionTypeRecruit)?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeMessageModel *model = [WPResumeMessageModel mj_objectWithKeyValues:json];
        dealsSuccess(model.CommentList,(int)model.CommentList.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark 请求浏览的数据
- (void)requestCommitList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
   
    [self.titleView.activity startAnimating];
    NSString *str = [IPADDRESS stringByAppendingString:(self.type == WPMainPositionTypeRecruit)?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetBrowseList",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             @"page":@(page),
                             (self.type == WPMainPositionTypeRecruit)?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        [self.titleView.activity stopAnimating];
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        dealsSuccess(model.browseList,(int)model.browseList.count);
    } failure:^(NSError *error) {
        [self.titleView.activity stopAnimating];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark 请求分享的数据
- (void)requestShareList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:(self.type == WPMainPositionTypeRecruit)?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetShare",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             @"page":@(page),
                             (self.type == WPMainPositionTypeRecruit)?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        for (ApplyCompanyList *modelList in model.list) {
            modelList.addTime = modelList.time;
        }
        dealsSuccess(model.list,(int)model.list.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestRecruitGetApplyCondition{
    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    apply.delegate = self;
    apply.sid = self.resumeId;
    [self.navigationController pushViewController:apply animated:YES];
}


- (void)requestInterviewGetApplyCondition{
    WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
    apply.delegate = self;
    apply.sid = self.resumeId;
    [self.navigationController pushViewController:apply animated:YES];
}

- (void)replyCommontWithModel{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeRecruit)?@"AddCommentForJob":@"AddCommentForResume",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             (self.type == WPMainPositionTypeRecruit)?@"job_id":@"resume_id":_resumeId,
                             @"commentContent":self.messageText,
                             @"Replay_commentID":_replyCommentId,
                             @"replay_user_id":_replyUserId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        
        if ([json[@"status"] isEqualToString:@"0"]) {
            
//            [self.tableView.mj_header beginRefreshing];
            [self replaceRefresh];
        }
    } failure:^(NSError *error) {
        [SPAlert alertControllerWithTitle:@"提示" message:error.localizedDescription superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }];
}

-(void)replaceRefresh
{
    if (self.listType == WPNewCheckListTypeBrowse) {
        _glancePage = 1;
        [self.titleView.activity startAnimating];
        [self requestCommitList:_glancePage success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [self.glanceArray removeAllObjects];
            [self.glanceArray addObjectsFromArray:datas];
            UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
            label.hidden = self.glanceArray.count;
            [self.tableView reloadData];
            UIButton * button = (UIButton*)[self.view viewWithTag:233];
            [button setTitle:[NSString stringWithFormat:@"浏览  %lu",(unsigned long)self.glanceArray.count] forState:UIControlStateNormal];
        } error:^(NSError *error) {
            
            [self.titleView.activity stopAnimating];
           
            
        }];
    }
    
    if (self.listType == WPNewCheckListTypeShare) {
        _sharePage = 1;
        [self.titleView.activity startAnimating];
        [self requestShareList:_sharePage success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [self.shareArray removeAllObjects];
            [self.shareArray addObjectsFromArray:datas];
            UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
            label.hidden = self.shareArray.count;
            [_tableView reloadData];
            firstShareCount = self.shareArray.count;
            UIButton * button = (UIButton*)[self.view viewWithTag:234];
            [button setTitle:[NSString stringWithFormat:@"分享  %lu",(unsigned long)self.shareArray.count] forState:UIControlStateNormal];
            if (_isFromMianShiMessage) {
                _isFromMianShiMessage = NO;
                NSIndexPath * indexpath = [[NSIndexPath alloc]init];
                for (int i = 0 ; i < self.shareArray.count; i++) {
                    ApplyCompanyList * model = self.shareArray[i];
                    if ([model.shareId isEqualToString:self.scrollerID]) {
                        indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                    }
                }
                [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        } error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
           
        }];
    }
    
    if (self.listType == WPNewCheckListTypeMessage) {
        _messagePage = 1;
        [self.titleView.activity startAnimating];
        [self requestMessageList:_messagePage success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [self.messageArray removeAllObjects];
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:datas];
            [self.messageArray addObjectsFromArray:array];
            UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
            label.hidden = self.messageArray.count;
            [self.tableView reloadData];
            UIButton * button = (UIButton*)[self.view viewWithTag:235];
            [button setTitle:[NSString stringWithFormat:@"留言  %lu",(unsigned long)self.messageArray.count] forState:UIControlStateNormal];
            if (_isFromMianShiMessage) {
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
        } error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
       
        }];
    }
    if (self.listType == WPNewCheckListTypeApply) {
        _applyPage = 1;
        [self.titleView.activity startAnimating];
        [self requestApplyList:_applyPage success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [self.applyArray removeAllObjects];
            [self.applyArray addObjectsFromArray:datas];
            [self.tableView reloadData];
        } error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
          
        }];
    }
}

#pragma mark 更新浏览，分享，留言的数据
- (void)updateResumeInfo:(NearPersonalModel *)model{
    if (!model.list.count) {
        return;
    }
    
    NearPersonalListModel *listModel = model.list[0];
    if (listModel.avatar) {
        UIImageView *iconImageView = (UIImageView *)[_tableHeaderView  viewWithTag:WPResumeCheckUserInfoTypeIcon];
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    }
    
    UILabel *timeLabel = (UILabel *)[_tableHeaderView viewWithTag:WPResumeCheckUserInfoTypeTime];//self.view
    timeLabel.text = listModel.updateTime;
    
    UILabel *titleLabel = (UILabel *)[_tableHeaderView viewWithTag:WPResumeCheckUserInfoTypeTitle];//self.view
    titleLabel.text = listModel.position;
    
    UILabel *contentLabel = (UILabel *)[_tableHeaderView viewWithTag:WPResumeCheckUserInfoTypeContent];//self.view
    contentLabel.text = (self.type == WPMainPositionTypeRecruit)?listModel.enterprise_name:[NSString stringWithFormat:@"%@ %@ %@ %@ %@",listModel.nike_name,listModel.sex,listModel.age,listModel.education,listModel.worktime];
    
    
    //企业投递
    UILabel *number = (UILabel *)[_tableHeaderView viewWithTag:1001];//self.view
    if ([listModel.signUp isEqualToString:@"0"]) {
        number.text = @"0";
    }
    else
    {
      number.text = listModel.signUp;
    }
    self.badgBtn.badgeValue = listModel.signCount;
    self.badgBtn.hidden = !listModel.signCount.intValue;
    
    
    //系统消息
    UILabel * number1  = (UILabel*)[_tableHeaderView viewWithTag:1002];
    if ([listModel.sys_count isEqualToString:@"0"]) {
        number1.text = @"0";
    }
    else
    {
        number1.text = listModel.sys_count;
    }
    self.badgBtn1.badgeValue = listModel.sys_message;
    self.badgBtn1.hidden = !listModel.sys_message.intValue;
    
    //上下架
    UIButton *button = (UIButton *)[self.tableHeaderView viewWithTag:23];
    SPButton1* button1 = (SPButton1*)button;
    if (listModel.shelvesDown.intValue) {
        button1.selected = YES;
        button1.contentLabel.textColor = [UIColor blackColor];
        button1.contentLabel.text = @"已下架";
        button1.mageView.image = [UIImage imageNamed:@"quanzhi_yishangjia"];
    }
    else
    {
        button1.selected = NO;
        button1.contentLabel.text = @"已上架";
        button1.mageView.image = [UIImage imageNamed:@"quanzhi_yixiajiapr"];
        button1.contentLabel.textColor = RGB(0, 172, 255);
    }
    //自动刷新
    UIButton * freshBbtn = (UIButton*)[self.tableHeaderView viewWithTag:22];
    SPButton1*freshBtn1 = (SPButton1*)freshBbtn;
    if (listModel.is_auto.intValue) {//自动
        freshBtn1.contentLabel.text = @"自动";
        freshBtn1.contentLabel.textColor = RGB(0, 172, 255);
        freshBtn1.mageView.image = [UIImage imageNamed:@"quanzhi_shuaxinpr"];
    }
    else
    {
        freshBtn1.contentLabel.text = @"刷新";
        freshBtn1.contentLabel.textColor = RGB(0, 0, 0);
        freshBtn1.mageView.image = [UIImage imageNamed:@"quanzhi_shuaxin"];
    }
    
    
    _applyCount = [NSString stringWithFormat:@"分享  %@",listModel.shareCount];
    UIButton *applyBtn = (UIButton *)[self.view viewWithTag:234];
    [applyBtn setTitle:[NSString stringWithFormat:@"分享  %@",listModel.shareCount] forState:UIControlStateNormal];
    firstShareCount = listModel.shareCount.integerValue;
    
    
    _messageCount = [NSString stringWithFormat:@"留言  %@",listModel.comcount];
    UIButton *messageBtn = (UIButton *)[self.view viewWithTag:235];
    [messageBtn setTitle:[NSString stringWithFormat:@"留言  %@",listModel.comcount] forState:UIControlStateNormal];
    
    _browseCount = [NSString stringWithFormat:@"浏览  %@",listModel.pageView];
    UIButton *glanceBtn = (UIButton *)[self.view viewWithTag:233];
    [glanceBtn setTitle:[NSString stringWithFormat:@"浏览  %@",listModel.pageView] forState:UIControlStateNormal];
    
    NSString * messageCount = [NSString stringWithFormat:@"%@",listModel.comcount];
    NSString * shareCount = [NSString stringWithFormat:@"%@",listModel.shareCount];
//    NSString * pageCount = [NSString stringWithFormat:@"%@",listModel.pageView];
    
    
    UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
//    blueLine.left = self.listType*SCREEN_WIDTH/3;
    if (_isFromMianShiMessage) {
        switch (self.listType) {
            case 1://分享
            {
                [self requestShareList:1 success:^(NSArray *datas, int more) {
                    [self.shareArray addObjectsFromArray:datas];
                    firstShareCount = self.shareArray.count;
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                
                messageBtn.selected = NO;
                applyBtn.selected = YES;
                glanceBtn.selected = NO;
                blueLine.left = self.listType*SCREEN_WIDTH/3;
            }
                break;
            case 2:
            {
                [self requestMessageList:1 success:^(NSArray *datas, int more) {
                    [self.messageArray removeAllObjects];
                    
                    [self.messageArray addObjectsFromArray:datas];
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                messageBtn.selected = YES;
                applyBtn.selected = NO;
                glanceBtn.selected = NO;
                blueLine.left = self.listType*SCREEN_WIDTH/3;
            }
                break;
            default:
                break;
        }
    }
    else
    {
       // if (messageCount.intValue >0) {
            self.listType = WPNewCheckListTypeMessage;
            [self requestMessageList:1 success:^(NSArray *datas, int more) {
                [self.messageArray removeAllObjects];
                [self.messageArray addObjectsFromArray:datas];
                [self.tableView reloadData];
            } error:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
            messageBtn.selected = YES;
            applyBtn.selected = NO;
            glanceBtn.selected = NO;
            blueLine.left = self.listType*SCREEN_WIDTH/3;
         /*
        }
        else
        {
        
            if (shareCount.intValue > 0) {
                self.listType = WPNewCheckListTypeShare;
                [self requestShareList:1 success:^(NSArray *datas, int more) {
                    [self.shareArray addObjectsFromArray:datas];
                    firstShareCount = self.shareArray.count;
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                
                messageBtn.selected = NO;
                applyBtn.selected = YES;
                glanceBtn.selected = NO;
                blueLine.left = self.listType*SCREEN_WIDTH/3;
            }
            else
            {
                self.listType = WPNewCheckListTypeBrowse;
                [self requestCommitList:1 success:^(NSArray *datas, int more) {
                    [self.glanceArray addObjectsFromArray:datas];
                } error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);//
                }];
                messageBtn.selected = NO;
                applyBtn.selected = NO;
                glanceBtn.selected = YES;
                blueLine.left = self.listType*SCREEN_WIDTH/3;
            }
        }
          */
    }
}

- (void)getInterviewResumeDraftDetail:(NSString *)resumeId success:(void (^)(WPInterviewDraftInfoModel *model))success{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"resume_id":resumeId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPInterviewDraftInfoModel *model = [WPInterviewDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestCompanyInfo:(NSString *)jobId success:(void (^)(WPRecruitDraftInfoModel *model))success{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetJobDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"job_id":jobId};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPRecruitDraftInfoModel *model = [WPRecruitDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

//删除数据库的缓存数据
- (void)deleteRecruitOrJobReleaseFromFMDBWithResumeID:(NSString *)resumeId{
    if (self.type == WPMainPositionTypeInterView){  //求职(简历)
       [[MTTDatabaseUtil instance] deleteMyApply:resumeId];
    }else if (self.type == WPMainPositionTypeRecruit){ //招聘
        [[MTTDatabaseUtil instance]  deleteMyInvite:resumeId];
    }
}

#pragma mark - 删除简历
- (void)deleteInterview{
    
    [SPAlert alertControllerWithTitle:nil message:@"确认删除" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
        WPShareModel *shareModel = [WPShareModel sharedModel];
        NSString *action = (self.type == WPMainPositionTypeRecruit?@"DelRecruit":@"DelJobRelease");
        NSString *sid = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
        NSDictionary *params = @{@"action":action,
                                 @"username":shareModel.username,
                                 @"password":shareModel.password,
                                 @"user_id":shareModel.dic[@"userid"],
                                 sid:self.resumeId};
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            if ([json[@"status"] integerValue]) {
//                [self.tableView.mj_header beginRefreshing];
                [self replaceRefresh];
                //删除本地的是数据缓存
                [self deleteRecruitOrJobReleaseFromFMDBWithResumeID:self.resumeId];
                [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delegateResumeSuccess" object:nil];
                if (self.isFromQiuzhi)
                {
                    if (self.deleteSucvcess) {
                        self.deleteSucvcess(self.choiseIndex);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteApplySuccess" object:nil];
                }
                else
                {
                    NSArray * viewArray = self.navigationController.viewControllers;
                    [self.navigationController popToViewController:viewArray[1] animated:YES];
                }
//                NSArray * viewArray = self.navigationController.viewControllers;
//                [self.navigationController popToViewController:viewArray[1] animated:YES];
            }else{
                [MBProgressHUD showError:@"删除失败" toView:self.view];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }];
}
#pragma mark 修改简历
- (void)editInterview{
    WS(ws);
    if (self.type == WPMainPositionTypeRecruit) {
        [self requestCompanyInfo:self.resumeId success:^(WPRecruitDraftInfoModel *model) {
            WPRecruitDraftEditController *edit = [[WPRecruitDraftEditController alloc]init];
            edit.type = WPRecuitEditTypeEdit;
            
            NSString * string = [WPMySecurities textFromBase64String:model.enterpriseBrief];
            string = [WPMySecurities textFromEmojiString:string];
            if (string.length) {
                model.enterpriseBrief = string;
            }
            
            NSString * string1 = [WPMySecurities textFromBase64String:model.Require];
            string1 = [WPMySecurities textFromEmojiString:string1];
            if (string1.length) {
                model.Require = string1;
            }
            edit.Infomodel = model;
            edit.guid = model.guid_0;
//            edit.listFix = self.listFix;
            [ws.navigationController pushViewController:edit animated:YES];
        }];
    }else{//修改面试
        [self getInterviewResumeDraftDetail:self.resumeId success:^(WPInterviewDraftInfoModel *model) {
            WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
//            UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController:edit];
            edit.type = WPInterviewEditTypeEdit;
            edit.draftInfoModel = model;
            edit.listFix = self.listFix;
            [ws.navigationController pushViewController:edit animated:YES];
        }];
    }
}

#pragma mark 刷新简历
- (void)refreshInterview{
    
    WPRefraeshController *VC = [[WPRefraeshController alloc]init];
    UIButton * button = (UIButton*)[self.tableHeaderView viewWithTag:23];
    NSString *action = (self.type == WPMainPositionTypeRecruit?@"ShelfRecruit":@"ShelfJobRelease");
    NSString *resume = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
    VC.action = action;
    VC.resume = resume;
    VC.resumeId = self.resumeId;
    if (button.selected) {
        VC.isOrNot = YES;
    }
    else
    {
        VC.isOrNot = NO;
    }
    VC.job_id = self.resumeId;
    if (self.type == WPMainPositionTypeInterView) { // 面试  求职
        VC.type = @"2";
    }else{                                          // 招聘
        VC.type = @"1";
    }
    VC.setRefresh = ^(BOOL isOrNot){//设置回调
        UIButton * freshBbtn = (UIButton*)[self.tableHeaderView viewWithTag:22];
        SPButton1*freshBtn1 = (SPButton1*)freshBbtn;
        if (isOrNot) {//自动
            freshBtn1.contentLabel.text = @"自动";
            freshBtn1.contentLabel.textColor = RGB(0, 172, 255);
            freshBtn1.mageView.image = [UIImage imageNamed:@"quanzhi_shuaxinpr"];
        }
        else
        {
            freshBtn1.contentLabel.text = @"刷新";
            freshBtn1.contentLabel.textColor = RGB(0, 0, 0);
            freshBtn1.mageView.image = [UIImage imageNamed:@"quanzhi_shuaxin"];
        }
    };
    [self.navigationController pushViewController:VC animated:YES];

    /*
     NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
     WPShareModel *shareModel = [WPShareModel sharedModel];
     
     NSString *action = (self.type == WPMainPositionTypeRecruit?@"RefreshRecruit":@"RefreshJobRelease");
     NSString *resumeId = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
     
     NSDictionary *params = @{@"action":action,
     @"username":shareModel.username,
     @"password":shareModel.password,
     @"user_id":shareModel.dic[@"userid"],
     resumeId:self.resumeId};
     [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
     if ([json[@"status"] integerValue]) {
     [self.tableView.mj_header beginRefreshing];
     [MBProgressHUD showSuccess:@"刷新成功" toView:self.view];
     }else{
     [MBProgressHUD showError:@"删除失败" toView:self.view];
     }
     } failure:^(NSError *error) {
     NSLog(@"%@",error.localizedDescription);
     }];
     */
}
#pragma mark 进行上下架操作
- (void)shelfInterview{
    UIButton *button = (UIButton *)[self.tableHeaderView viewWithTag:23];
    NSString * upDownStr ;
    if (button.selected) {
        upDownStr = @"确认上架";
    }
    else
    {
      upDownStr = @"确认下架";
    }
    [SPAlert alertControllerWithTitle:nil message:upDownStr superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
        WPShareModel *shareModel = [WPShareModel sharedModel];
        
        NSString *action = (self.type == WPMainPositionTypeRecruit?@"ShelfRecruit":@"ShelfJobRelease");
        NSString *resumeId = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
        
        NSDictionary *params = @{@"action":action,
                                 @"username":shareModel.username,
                                 @"password":shareModel.password,
                                 @"user_id":shareModel.dic[@"userid"],
                                 resumeId:self.resumeId};
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            UIButton *button = (UIButton *)[self.tableHeaderView viewWithTag:23];
            SPButton1* button1 = (SPButton1*)button;
            if ([json[@"status"] integerValue]) {
                NSLog(@"%@",describe(json));
//                [self.tableView.mj_header beginRefreshing];
                [self replaceRefresh];
                
                if (button1.selected) {
                    button1.selected = NO;
                    [MBProgressHUD showSuccess:@"上架成功" toView:self.view];
                    button1.contentLabel.text = @"已上架";
                    button1.mageView.image = [UIImage imageNamed:@"quanzhi_yixiajiapr"];
                    button1.contentLabel.textColor = RGB(0, 172,255);
                }
                else
                {
                    button1.selected = YES;
                    [MBProgressHUD showSuccess:@"下架成功" toView:self.view];
                    button1.contentLabel.text = @"已下架";
                    button1.mageView.image = [UIImage imageNamed:@"quanzhi_yishangjia"];
                    button1.contentLabel.textColor = RGB(0, 0, 0);
                }
                if (self.upAndDownSuccess) {
                    self.upAndDownSuccess();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delegateResumeSuccess" object:nil];
                
            }else{
                if (button1.selected) {
                        [MBProgressHUD showError:@"上架失败" toView:self.view];
                }
                else
                {
                      [MBProgressHUD showError:@"下架失败" toView:self.view];
                }
            
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];

    
    }];
    
    
    
//    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
//    WPShareModel *shareModel = [WPShareModel sharedModel];
//    
//    NSString *action = (self.type == WPMainPositionTypeRecruit?@"ShelfRecruit":@"ShelfJobRelease");
//    NSString *resumeId = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
//    
//    NSDictionary *params = @{@"action":action,
//                             @"username":shareModel.username,
//                             @"password":shareModel.password,
//                             @"user_id":shareModel.dic[@"userid"],
//                             resumeId:self.resumeId};
//    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
//        if ([json[@"status"] integerValue]) {
//            NSLog(@"%@",describe(json));
//            [self.tableView.mj_header beginRefreshing];
//            UIButton *button = (UIButton *)[self.tableHeaderView viewWithTag:23];
//            SPButton1* button1 = (SPButton1*)button;
//            if (button1.selected) {
//                button1.selected = NO;
//                [MBProgressHUD showSuccess:@"上架成功" toView:self.view];
//                button1.contentLabel.text = @"已上架";
//                button1.imageView.image = [UIImage imageNamed:@"shangjia"];
////                [button setTitle:@"已上架" forState:UIControlStateNormal];
//            }
//            else
//            {
//                button1.selected = YES;
//                [MBProgressHUD showSuccess:@"下架成功" toView:self.view];
//                button1.contentLabel.text = @"已下架";
//                button1.imageView.image = [UIImage imageNamed:@"xiajia"];
//            }
//            
//        }else{
//            [MBProgressHUD showError:@"删除失败" toView:self.view];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
}

- (void)ExtensionInterview{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    
    NSString *action = (self.type == WPMainPositionTypeRecruit?@"ExtensionRecruit":@"ExtensionJobRelease");
    NSString *resumeId = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
    
    NSDictionary *params = @{@"action":action,
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             resumeId:self.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            NSLog(@"%@",describe(json));
//            [self.tableView.mj_header beginRefreshing];
            [self replaceRefresh];
            [MBProgressHUD showSuccess:@"推广成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


#pragma mark - tableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.listType == WPNewCheckListTypeBrowse) {
        count = self.glanceArray.count;
    }
    if (self.listType == WPNewCheckListTypeShare) {
        count = self.shareArray.count;
    }
    if (self.listType == WPNewCheckListTypeMessage) {
        //        if (section == self.messageArray.count-1) {
        //            return 14;
        //        }else{
        count = [self.messageArray count];
        
        //        }
    }
    //    if (self.listType == WPNewCheckListTypeApply) {
    //        count = self.applyArray.count;
    //        if (count < 8) {
    //            count = 8;
    //        }
    //    }
    
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == WPNewCheckListTypeBrowse|self.listType == WPNewCheckListTypeShare) {//|self.listType == WPNewCheckListTypeApply
        return kHEIGHT(45);
    }
    if (self.listType == WPNewCheckListTypeMessage) {
        WPResumeCheckMessageModel *model = self.messageArray[indexPath.row];
        NSString * to_user_id = [NSString stringWithFormat:@"%@",model.to_user_id];
        NSString * contentStr = [WPMySecurities textFromBase64String:model.commentContent];
        contentStr = [WPMySecurities textFromEmojiString:contentStr];

        contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (to_user_id.intValue != 0) {
            
            
            
            return [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"回复 %@ ：%@",model.to_nick_name,contentStr]];//[WPMySecurities textFromEmojiString:model.commentContent]
        }
        else
        {
            return [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"%@",contentStr]];//[WPMySecurities textFromEmojiString:model.commentContent]
        }
    }
    
//    if (currentType == WPResumeCheckMessageType) {
//        WPResumeCheckMessageModel *model = self.messageArray[indexPath.row];
//        NSString * to_user_id = [NSString stringWithFormat:@"%@",model.to_user_id];
//        if (to_user_id.intValue != 0) {
//            return [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"回复 %@ ：%@",model.to_user_name,model.commentContent]];
//        }
//        else
//        {
//            return [WPCommonCommentHeadCell cellHeight:[NSString stringWithFormat:@"%@",model.commentContent]];
//        }
//        
//    }
    
    
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.listType == WPNewCheckListTypeBrowse|self.listType == WPNewCheckListTypeApply|self.listType == WPNewCheckListTypeShare) {
        static NSString *cellId = @"WPResumeCheckApplyCell";
        WPResumeCheckApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WPResumeCheckApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (self.listType == WPNewCheckListTypeBrowse) {
            if (self.glanceArray.count == 0 || indexPath.row >= self.glanceArray.count) {
                static NSString *cellId = @"UITableViewCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                tableView.separatorColor = [UIColor whiteColor];
                return cell;
            }
            tableView.separatorColor = RGB(226, 226, 226);
            cell.listModel = self.glanceArray[indexPath.row];
        }
        if (self.listType == WPNewCheckListTypeShare) {
            if (self.shareArray.count == 0||indexPath.row >= self.shareArray.count) {
                static NSString *cellId = @"UITableViewCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableView.separatorColor = [UIColor whiteColor];
                return cell;
            }
            tableView.separatorColor = RGB(226, 226, 226);
            cell.listModel = self.shareArray[indexPath.row];
        }
        
        return cell;
    }
    if (self.listType == WPNewCheckListTypeMessage) {
//  FIXME: 此处有崩溃,self.messageArray数组越界
        static NSString *cellId = @"WPCommonCommentHeadCell";
        WPCommonCommentHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WPCommonCommentHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.tag = indexPath.row;
        cell.backgroundColor = [UIColor whiteColor];
        cell.model = self.messageArray[indexPath.row];
        cell.ReplyBlock = ^(NSInteger number){
            WPResumeCheckMessageModel *model = self.messageArray[number];
            _replyCommentId = model.commentId;
            _replyUserId = model.createdUserId;
            self.inputBar.placeHolder = [NSString stringWithFormat:@"回复:%@",model.userName];
            [self.inputBar.inputView becomeFirstResponder];
//            self.myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复:%@",model.userName];
//            [self.myMsgInputView notAndBecomeFirstResponder];
        };
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
//        longpress.delegate = self;
        longpress.minimumPressDuration = 0.5;
        [cell addGestureRecognizer:longpress];
        
//        WS(ws);
        cell.UserInfoBlock = ^(NSString *userid, NSString *userName){
            [self requireDataWithAciont:userid];
//            PersonalInfoViewController *VC = [[PersonalInfoViewController alloc]init];
//            VC.friendID = userid;
//            [self.navigationController pushViewController:VC animated:YES];
        };
        return cell;
        
    }
    return nil;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCell= (WPCommonCommentHeadCell *)recognizer.view;
        currentCell.selected = YES;
        [currentCell becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO];
         UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(menuAction:)];
        [menu setMenuItems:@[item]];
        [menu setTargetRect:currentCell.frame inView:currentCell.superview];
//        [menu setTargetRect:[self.tableView rectForRowAtIndexPath:indexPath] inView:self.tableView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        
        [menu setMenuVisible:YES animated:YES];
    }
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)menuAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSIndexPath * indexpath = [self.tableView indexPathForCell:currentCell];
    WPResumeCheckMessageModel * model = self.messageArray[indexpath.row];
    
    [pasteboard setString:[NSString stringWithFormat:@"%@",model.commentContent]];
}

-(void)WillHideMenu:(id)sender
{
    currentCell.selected = NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(menuAction:) ){
        return YES;
    }
    return NO;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.listType == WPNewCheckListTypeBrowse) {
        ApplyCompanyList *list = self.glanceArray[indexPath.row];
        [self requireDataWithAciont:[NSString stringWithFormat:@"%@",list.userId]];
//        PersonalInfoViewController *pers = [[PersonalInfoViewController alloc]init];
//        pers.friendID = list.userId;
//        [self.navigationController pushViewController:pers animated:YES];
        
    }
    if (self.listType == WPNewCheckListTypeMessage) {
        WPResumeCheckMessageModel *model = self.messageArray[indexPath.row];
        NSString * userID = [NSString stringWithFormat:@"%@",model.createdUserId];
        if ([userID isEqualToString:kShareModel.userId]) {//点击自己的评论
            //            [self.inputBar.inputView resignFirstResponder];
            [UIView animateWithDuration:0.5 animations:^{
                [self.inputBar.inputView resignFirstResponder];
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
            [self.inputBar.inputView becomeFirstResponder];
        }
//        WPResumeCheckMessageModel *model = self.messageArray[indexPath.section];
//        if (indexPath.row < [[self.messageArray[indexPath.section] ReplayCommentList] count]) {
//            WPResumeCheckReplayCommentListModel *modelList = [self.messageArray[indexPath.section] ReplayCommentList][indexPath.row];
//            _replyCommentId = model.commentId;
//            _replyUserId = model.createdUserId;
//
//            self.myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复:%@",modelList.replayUserName];
//
//        }
    }
    if (self.listType == WPNewCheckListTypeApply) {
        
        if (indexPath.row < self.applyArray.count) {
            ApplyCompanyList *list = self.applyArray[indexPath.row];
            NearInterViewController *interView = [[NearInterViewController alloc]init];
            interView.isRecuilist = NO;
            [self.navigationController pushViewController:interView animated:YES];
            
            interView.subId = list.resumeId;
            interView.userId = list.userId;
            WPShareModel *shareModel = [WPShareModel sharedModel];
            interView.isSelf = [list.userId isEqualToString:shareModel.dic[@"userid"]];
            if (self.type == WPMainPositionTypeRecruit) {
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,list.resumeId,kShareModel.userId];
            }else{
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,list.resumeId,kShareModel.userId];
            }
        }
    }
    if (self.listType == WPNewCheckListTypeShare) {
        PersonalInfoViewController *VC = [[PersonalInfoViewController alloc]init];
        ApplyCompanyList *list = self.shareArray[indexPath.row];
        VC.friendID = list.userId;
        if (![list.is_an isEqualToString:@"0"]) {
          [self.navigationController pushViewController:VC animated:YES];
        }

    }
}

#pragma mark 删除自己的留言操作
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
    NSDictionary * dic = @{@"action":self.type?@"DelCommentForJob":@"DelCommentForResume",
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
            UIButton * button = (UIButton*)[self.view viewWithTag:235];
            [button setTitle:[NSString stringWithFormat:@"留言  %lu",(unsigned long)self.messageArray.count] forState:UIControlStateNormal];
            
            if (self.messageArray.count == 0) {
                _reloadMessage = YES;
            }
            
        }
        else
        {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
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
#pragma mark 点击浏览，分享，留言233 234 235
- (void)viewForHeaderInSectionActions:(UIButton *)sender{
    _replyCommentId = @"";
    _replyUserId = @"";
    
    
     UILabel * label = (UILabel*)[_tableHeaderView viewWithTag:2334];
    self.listType = sender.tag-233;
//    [self.tableView.mj_header beginRefreshing];
    if (sender.tag == 233) {
        if (_reloadGlance) {
            
        }
        else
        {
            _reloadGlance= YES;
            if (self.glanceArray.count) {
                
            }
            else
            {
//              [self.tableView.mj_header beginRefreshing];
                [self replaceRefresh];
            }
          
        }
        
        if (self.glanceArray.count) {
            label.hidden = YES;
        }
        else
        {
            label.hidden = NO;
        }
    }
    
    if (sender.tag == 234) {
        if (_reloadShare) {
            
        }
        else
        {
            _reloadShare = YES;
            if (self.shareArray.count) {
                
            }
            else
            {
//              [self.tableView.mj_header beginRefreshing];
                [self replaceRefresh];
            }
        }
        if (self.shareArray.count) {
            label.hidden = YES;
        }
        else
        {
            label.hidden = NO;
        }
    }
    
    if (sender.tag == 235) {
        if (_reloadMessage) {
            
        }
        else
        {
            if (self.messageArray.count) {
                
            }
            else
            {
//              [self.tableView.mj_header beginRefreshing];
                [self replaceRefresh];
            }
            _reloadMessage = YES;
        }
        if (self.messageArray.count) {
            label.hidden = YES;
        }
        else
        {
            label.hidden = NO;
        }
    }
    
    [self.tableView reloadData];
   
    
    
    
    //_selectedButtonTag = sender.tag;
    
    [self.inputBar.inputView resignFirstResponder];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:233+i];
        button.selected = button.tag == sender.tag?YES:NO;
    }
    
    UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
    blueLine.left = self.listType*SCREEN_WIDTH/3;

//    if (sender.tag == 235) {
//        if (_myMsgInputView) {
//            [_myMsgInputView prepareToShow];
//            isShow = YES;
//        }
//    }else{
//        if (_myMsgInputView) {
//            [_myMsgInputView prepareToDismiss];
//            isShow = NO;
//        }
//    }
//    self.bottomGlanceView.hidden = (sender.tag == 234)?NO:YES;
    
}

//#pragma mark - scrollView Delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//[self.chatInputView.textView resignFirstResponder];

//if (scrollView.contentOffset.y >= 167) {
//if (self.listType == WPNewCheckListTypeBrowse) {
//_glancePosition = scrollView.contentOffset.y;
//}
//if (self.listType == WPNewCheckListTypeShare) {
//_sharePosition = scrollView.contentOffset.y;
//}
//if (self.listType == WPNewCheckListTypeMessage) {
//_messagePosition = scrollView.contentOffset.y;
//}
//if (self.listType == WPNewCheckListTypeApply) {
//_applyPosition = scrollView.contentOffset.y;
//}

//_glancePosition = _glancePosition>167?167:_glancePosition;
//_sharePosition = _sharePosition<167?167:_sharePosition;
//_messagePosition = _messagePosition<167?167:_messagePosition;
//_applyPosition = _applyPosition<167?167:_applyPosition;

//}else{
//_glancePosition = scrollView.contentOffset.y;
//_sharePosition = scrollView.contentOffset.y;
//_messagePosition = scrollView.contentOffset.y;
//_applyPosition = scrollView.contentOffset.y;
//}
//}

#pragma mark 点击企业投递和系统消息,个人申请
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 9) {//点击企业投递
        WPInfoListController *InfoVC = [[WPInfoListController alloc]init];
        InfoVC.isResume = self.isRecuilist?NO:YES;
        InfoVC.title = self.isRecuilist?@"求职申请":@"企业投递";
        InfoVC.Id = self.resumeId;
        InfoVC.isRecurit = self.isRecuilist;
       // UILabel * number1  = (UILabel*)[_tableHeaderView viewWithTag:1001];
       // number1.text = @"0";
        self.badgBtn.badgeValue = @"0";
        self.badgBtn.hidden = YES;
        InfoVC.clickCompany = ^(){
            if (self.companyClick) {
                self.companyClick();
            }
        };

        [self.navigationController pushViewController:InfoVC animated:YES];
    }else if (sender.tag == 10){//系统消息
        WPSysNotificationViewController * sys = [[WPSysNotificationViewController alloc]init];
        sys.type = self.type;
        sys.jobID = self.resumeId;
        sys.requstSuccess = ^(){
           // UILabel * number1  = (UILabel*)[_tableHeaderView viewWithTag:1002];
          //  number1.text = @"0";
            self.badgBtn1.badgeValue = @"0";
            self.badgBtn1.hidden = YES;
            if (self.clickSuccess) {
                self.clickSuccess(self.choiseIndex);
            }
        };
        [self.navigationController pushViewController:sys animated:YES];
    }
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    if (isShow) {
////        if (_myMsgInputView) {
////            [_myMsgInputView prepareToShow];
////        }
////    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//        [self.chatInputView.textView resignFirstResponder];
    [self.inputBar.inputView resignFirstResponder];
}

#pragma mark - Delegate 刷新报名状态
//- (void)refreshApplyState{
//    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
//    button.contentLabel.text = (self.type == WPMainPositionTypeRecruit?@"已申请":@"已抢");
//}
//
//- (void)recruitApplyDelegate{
//    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
//    button.contentLabel.text = (self.type == WPMainPositionTypeRecruit?@"已申请":@"已抢");
//}
//
//- (void)interviewApplyDelegate{
//    SPButton *button = (SPButton *)[self.view viewWithTag:WPResumeCheckUserInfoTypeApplyAction];
//    button.contentLabel.text = (self.type == WPMainPositionTypeRecruit?@"已申请":@"已抢");
//}

#pragma mark - 输入框Delegate
- (void)viewheightChanged:(float)height{
    //    [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}
//- (void)textViewEnterSend{
//    if (self.chatInputView.textView.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//
//    //发送消息
//    NSString* text = [self.chatInputView.textView text];
//
//    NSString* parten = @"\\s";
//    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString* checkoutText = [reg stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
//    if ([checkoutText length] == 0)
//    {
//        return;
//    }
//    NSLog(@"发送消息：%@",self.chatInputView.textView.text);
//    [self replyCommontWithModel];
//}


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myMsgInputView prepareToDismiss];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)dealloc{
//    [self removeObserver:self forKeyPath:@"_inputViewY"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.myMsgInputView isAndResignFirstResponder];
}

@end
