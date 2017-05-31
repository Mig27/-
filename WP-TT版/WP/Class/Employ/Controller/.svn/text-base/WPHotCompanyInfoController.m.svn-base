//
//  WPHotCompanyInfoController.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPHotCompanyInfoController.h"
#import "WPHotCompanyPositionManager.h"
#import "WPCompanyPositionCell.h"
#import "WPButtons.h"
#import "NearInterViewController.h"
#import "WPPersonalResumeListController.h"
#import "VideoBrowser.h"
#import "WPDownLoadVideo.h"
#import "WPIVManager.h"
#import "SAYVideoManagerViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "PersonalInfoViewController.h"
#import "WPTitleView.h"
#import "WPMySecurities.h"
#import "MTTSessionEntity.h"
#import "ChattingMainViewController.h"
#import "YYShareManager.h"
#import "ShareEditeViewController.h"
#import "ReportViewController.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "WPResumeCheckController.h"
#import "CollectViewController.h"
#import "RequestManager.h"
#import "WPRecruitApplyController.h"
#import "WPApplyViewController.h"
#define shuoShuoVideo @"/shuoShuoVideo"
#define kCompanyPositionCellReuse @"WPCompanyPositionCellReuse"

@interface NearInterViewFour1Button ()
@property (nonatomic ,strong)NSMutableArray *buttonArr;
@end
@implementation NearInterViewFour1Button
#pragma mark -- 这是一个封装的View
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"  聊聊",@"  申请",@"  收藏",@"  留言"];
        NSArray *images = @[@"common_liaoliao",@"common_gongyong",@"common_shoucang",@"quanzhi_liuyan"];
        for (int i = 0; i< 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateHighlighted];
            button.titleLabel.font = kFONT(15);
            [button addTarget:self action:@selector(userOperationClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4+1, 49);
            if (i==0) {
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateHighlighted];
            }else{
                [button setBackgroundImage:[UIImage imageWithColor:RGB(255, 139, 0) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(217, 118, 0) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateHighlighted];
            }
            [self addSubview:button];
            if (i==1) {
                //                [button setTitle:@"已申请" forState:UIControlStateSelected];
            }else if (i == 2) {
                [button setTitle:@"已收藏" forState:UIControlStateSelected];
            }
            if (i>0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, 0.5, 49)];
                line.backgroundColor = [UIColor whiteColor];
                [self addSubview:line];
            }
            [self.buttonArr addObject:button];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [self addSubview:line];
    }
    return self;
}
-(NSMutableArray*)buttonArr
{
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}
#pragma mark 点击底部按钮
-(void)userOperationClick:(UIButton *)sender
{
    NSInteger tag = [self.buttonArr indexOfObject:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegat1eActionWithIndex:)]) {
        [self.delegate delegat1eActionWithIndex:tag];
    }
}
@end



@interface WPHotCompanyInfoController ()<UITableViewDelegate,UITableViewDataSource,WPHotCompanyPositionManagerDelegate,UIScrollViewDelegate,UIWebViewDelegate,NearInterViewFour1ButtonDelegate,WPRecruitApplyDelegate>
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UIWebView *webView;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)WPHotCompanyPositionManager *manager;
@property (nonatomic ,strong)UIButton *chatButton;
@property (nonatomic ,strong)WPButtons *button;
@property (nonatomic, strong)NSMutableArray * array;
@property (nonatomic, strong)WPTitleView* titleView;
@property (nonatomic, copy)NSString * urlString;
@property (nonatomic, copy)NSString * applyID;
@property (nonatomic, assign)BOOL isSame;
@property (nonatomic, strong)UIButton*rightBtn;
@property (nonatomic, strong)WPNewResumeListModel*listModel;
@property (nonatomic, strong)NearInterViewFour1Button*bottomView;
@end

@implementation WPHotCompanyInfoController
-(NSMutableArray*)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
-(UIButton*)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 30, 40);
        [_rightBtn setBackgroundColor:[UIColor redColor]];
        [_rightBtn setImage:[UIImage imageNamed:@"3点白色其他"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightBtn;
}
-(NearInterViewFour1Button *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NearInterViewFour1Button alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.delegate = self;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}
-(void)backToFromViewController:(UIButton *)sender
{
    if (self.isSame)
    {
        self.title = @"";
        self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.titleView.titleString = self.model.company_name;
        self.navigationItem.titleView = self.titleView;
        self.isSame = NO;
        
        NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/hotcompany.aspx?recruit_id=%@",IPADDRESS,self.model.sid];
        NSURLRequest * requst = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:requst];
        
        CGRect rect = self.webView.frame;
        rect.size.height += 49;
        self.webView.frame = rect;
        self.bottomView.hidden = YES;
        
        //显示分享的按钮
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)delegat1eActionWithIndex:(NSInteger)index
{
    switch (index) {
            case 0:
            [self chatAction:nil];
            break;
        case 3:
            [self message];
            break;
        case 2:
        {
            [self requstModel:^(id string) {
                [self collection];
            }];
        }
            break;
            //申请
        case 1:
            [self applyTouchAction];
            break;
        default:
            break;
    }
}

#pragma mark - 查看简历或招聘
- (void)message{
    WPResumeCheckController *resume = [[WPResumeCheckController alloc]init];
    resume.resumeId = self.applyID;
    resume.userId = kShareModel.userId;
    resume.isRecruit = YES;
    resume.model = self.listModel;
    resume.isApply = NO;
    [self.navigationController pushViewController:resume animated:YES];
}

-(NSString*)getImageString:(NSString*)image
{
    NSArray * array = [image componentsSeparatedByString:@"/"];
    NSString * lastStr = array[array.count-1];
    lastStr = [@"thumb_" stringByAppendingString:lastStr];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
    return [muarray componentsJoinedByString:@"/"];
}
- (void)collection
{
    //收藏匿名
    NSString * col3 = nil;
    CollectViewController *VC = [[CollectViewController alloc]init];
        VC.titles = self.listModel.jobPositon;
        VC.companys = self.listModel.enterpriseName;
        VC.jobid = self.listModel.resumeId;
        VC.collect_class = @"5";
        VC.user_id = self.model.userId;
        VC.img_url = [self getImageString:self.model.logo];
    if (col3.length) {
        VC.col3 = col3;
    }
    VC.collectSuccessBlock = ^(){
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)requestRecruitGetApplyCondition{
    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    apply.applySuccess = ^(){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"个人求职简历申请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络求职需谨慎，谨防招聘骗局，如发现违法求职者请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    };
    apply.title = @"申请";
    apply.delegate = self;
    apply.sid = self.applyID;
    [self.navigationController pushViewController:apply animated:YES];
}

- (void)cancelActionWithJson:(NSDictionary *)json
{
    UIButton *button = self.bottomView.buttonArr[1];
    if (![json[@"status"] integerValue]) {
        button.selected = NO;
    }else{
        [MBProgressHUD showError:json[@"info"] toView:self.view];
    }
}
- (void)applyTouchAction{
    UIButton *button = self.bottomView.buttonArr[1];
    if (!button.selected) {
        [self requestRecruitGetApplyCondition];
    }else
    {
                [[RequestManager shareManager]cancelApplicationJobWithJobid:self.applyID status:^(id json) {
                    [self cancelActionWithJson:json];
                } fail:^(NSError *error) {
                    
                }];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = self.model.company_name;
    self.navigationItem.titleView = self.titleView;
    
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.model.sid;
    manager.fk_type = @"3";
    ;
    [manager requsetForImageAndVideo];
    [self.view addSubview:self.webView];//self.scrollView
    [self requestForData];
    
//    [self.view addSubview:self.chatButton];
//    [self.view addSubview:self.button];
}


- (WPButtons *)button{
    if (!_button) {
        self.button = [[WPButtons alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        [self.button addTargate:self action:@selector(buttonAction:)];
    }
    return _button;
}

- (void)requestForData
{
    self.manager = [WPHotCompanyPositionManager sharedManager];
    self.manager.delegate = self;
    [self.manager requestPositionForCompanyWithEp_id:self.model.sid];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float x = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (x>0.5) {
        self.button.isLeft = YES;
    }else{
        self.button.isLeft = NO;
    }
}

- (void)buttonAction:(UIButton *)sender
{
    
    if ([sender.titleLabel.text isEqualToString:@"全部职位"]) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.manager.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPCompanyPositionCell *cell = [[WPCompanyPositionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCompanyPositionCellReuse];
    WPPositionModel *model = self.manager.modelArr[indexPath.row];
    cell.model = model;
    return cell;
}

//- (UIButton *)chatButton
//{
//    if (!_chatButton) {
//        self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.chatButton.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
//        [self.chatButton setTitle:@"  聊聊" forState:UIControlStateNormal];
//        [self.chatButton setImage:[UIImage imageNamed:@"common_liaoliao"] forState:UIControlStateNormal];
//        [self.chatButton setImage:[UIImage imageNamed:@"common_liaoliao"] forState:UIControlStateHighlighted];
//        self.chatButton.titleLabel.tintColor = RGB(0, 0, 0);
//        [self.chatButton setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(SCREEN_WIDTH, 49)] forState:UIControlStateNormal];
//        [self.chatButton setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(SCREEN_WIDTH, 49)] forState:UIControlStateHighlighted];
//        [self.chatButton addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(178, 178, 178);
//        [self.chatButton addSubview:line];
//        
//    }
//    return _chatButton;
//}

- (void)requireDataWithAciont
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
        if (list.count)
        {
            for (NSDictionary* dictory in list) {
                NSString * friend_id = [NSString stringWithFormat:@"%@",dictory[@"friend_id"]];
                if ([friend_id isEqualToString:self.model.userId]) {
                    isOrNot = YES;
                }
                else
                {}
            }
            if (isOrNot) {
                MTTSessionEntity *session = [[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"user_%@",self.model.userId] type:SessionTypeSessionTypeSingle];
//                if (self.isFromChatClick)
//                {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPFROMINTERVIEW" object:session];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//                else
//                {
                    ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
                    [chat showChattingContentForSession:session];
                    [self.navigationController pushViewController:chat animated:YES];
//                }
                
                //                ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
                //                [chat showChattingContentForSession:session];
                //                [self.navigationController pushViewController:chat animated:YES];
                
            }//不是好友则跳到添加页面
            else
            {
                PersonalInfoViewController * person = [[PersonalInfoViewController alloc]init];
                person.friendID = self.model.userId;
                person.newType = NewRelationshipTypeStranger;
                [self.navigationController pushViewController:person animated:YES];
            }
        }
        else//通讯录中没有好友跳到添加页面
        {
            PersonalInfoViewController * person = [[PersonalInfoViewController alloc]init];
            person.friendID = self.model.userId;
            person.newType = NewRelationshipTypeStranger;
            [self.navigationController pushViewController:person animated:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
    }];
}


- (void)chatAction:(UIButton *)sender
{
    [self requireDataWithAciont];
//    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
//    WPShareModel *model = [WPShareModel sharedModel];
//    
//    NSDictionary *params = @{@"action":@"GetJobSignStatus",//:@"GetResumeSignStatus"),
//                             @"username":model.username,
//                             @"password":model.password,
//                             @"user_id":model.dic[@"userid"],
//                             @"job_id":self.applyID};
//    [WPHttpTool postWithURL:str params:params success:^(id json) {
//        
////        XHDemoWeChatMessageTableViewController *chat = [[XHDemoWeChatMessageTableViewController alloc] init];
////        chat.chatObj = json[@"user_name"];
////        chat.avatar = json[@"avatar"];
////        chat.nick_name = json[@"nick_name"];
////        [self.navigationController pushViewController:chat animated:YES];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
//        [self.scrollView addSubview:self.webView];
//        [self.scrollView addSubview:self.tableView];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
    }
    return  _scrollView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];

        UIScrollView *scroller = [self.webView.subviews objectAtIndex:0];
        if (scroller){
            scroller.bounces = NO;
            scroller.alwaysBounceVertical = NO;
            scroller.alwaysBounceHorizontal = NO;
        }
        
        NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/hotcompany.aspx?recruit_id=%@",IPADDRESS,self.model.sid];
        self.webView.delegate = self;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
    return _webView;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.titleView.activity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.titleView.activity stopAnimating];
    self.urlString = @"";
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/hotcompany.aspx?recruit_id=%@",IPADDRESS,self.model.sid];
//    if (![str isEqualToString:url]) {
//        WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
//        list.userId = array[1];
//        list.isSelf = NO;
//        [self.navigationController pushViewController:list animated:YES];
//        return NO;
//    }
    if ([array[0]isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?img_path",IPADDRESS]]) {//点击图片
        NSString *urlstr1 = array[1];
        NSArray *arr2 = [urlstr1 componentsSeparatedByString:@"&"];
        NSString *mediaType = arr2[0];
        if ([mediaType hasSuffix:@".mp4"]) {
            NSString * path = [self getVideoPath:[IPADDRESS stringByAppendingString:mediaType]];
            if (!path.length) {
                [MBProgressHUD showMessage:@"" toView:self.view];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    WPDownLoadVideo * video = [[WPDownLoadVideo alloc]init];
                    [video downLoadVideo:[IPADDRESS stringByAppendingString:mediaType] success:^(id response) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString* string = [self getVideoPath:[IPADDRESS stringByAppendingString:mediaType]];
                            [MBProgressHUD hideHUDForView:self.view];
                            VideoBrowser *video = [[VideoBrowser alloc] init];
                            video.videoUrl = string;
                            video.isNetOrNot = NO;
                            video.isCreat = YES;
                            video.addLongPress = YES;
                            [video showPickerVc:self];
                        });
                    } failed:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view];
                            [MBProgressHUD createHUD:@"获取失败" View:self.view];
                        });
                    } progress:^(NSProgress *progreee) {
                    }];
                });
            }
            else
            {
                VideoBrowser *video = [[VideoBrowser alloc] init];
                video.videoUrl = path;
                video.isNetOrNot = NO;
                video.isCreat = YES;
                video.addLongPress = YES;
                [video showPickerVc:self];
            }
        } else {
            NSArray *images = [WPIVManager sharedManager].model.ImgPhoto;
            [self showPhotoBrowserWithPhotoArray:images url:arr2[0]];
        }
        return NO;
    }
    else  if ([array[0] isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?fk_id",IPADDRESS]]){
        WPIVManager *sharedManager = [WPIVManager sharedManager];
        NSMutableArray * photoArray = [NSMutableArray array];
        NSArray * array = sharedManager.model.ImgPhoto;
        [photoArray addObjectsFromArray:array];
        NSMutableArray * videoArray = [NSMutableArray array];
        NSArray * array1 = sharedManager.model.VideoPhoto;
        [videoArray addObjectsFromArray:array1];
        SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
        vc.arr = photoArray;
        vc.videoArr = videoArray;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navc animated:YES completion:nil];
        return NO;
    }
//    else if ([array[0] containsObject:@"EnterpriseRecruit"])
//    {
//        [UIView animateWithDuration:0.5 animations:^{
        
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//            [self.webView loadRequest:request];
//        }];
//    }
    else if([str isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/user_id=%@",IPADDRESS,array[1]]])
    {
        
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        personInfo.comeFromVc = @"自己判断";
        personInfo.friendID = array[1];
        [self.navigationController pushViewController:personInfo animated:YES];
//        WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
//        list.userId = array[1];
//        list.isSelf = NO;
//        [self.navigationController pushViewController:list animated:YES];
        return NO;
    }
    else{
        if (![str isEqualToString:url]) {
//            if (self.urlString.length) {
//            }
//            else
//            {
            
                NSArray * array1 = [array[1] componentsSeparatedByString:@"&"];
                self.applyID = [NSString stringWithFormat:@"%@",array1[0]];
                WPApplyViewController * apply = [[WPApplyViewController alloc]init];
                apply.urlStr = str;
                apply.applyID = self.applyID;
                apply.model = self.model;
                apply.isMySelf = [self.model.userId isEqualToString:kShareModel.userId];
                apply.listModel = self.listModel;
                [self.navigationController pushViewController:apply animated:YES];
                
            return NO;
                //显示分享的按钮
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
//                
//            
//                self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//                self.titleView.titleString = @"职位详情";
//                self.navigationItem.titleView = self.titleView;
//
//
//                self.isSame = YES;
//                
//                self.urlString = str;
//                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//                [self.webView loadRequest:request];
//                
//                CGRect rect = self.webView.frame;
//                rect.size.height -= 49;
//                self.webView.frame = rect;
//                
//                self.bottomView.hidden = NO;
//                
//                
//                NSArray * array1 = [array[1] componentsSeparatedByString:@"&"];
//                self.applyID = [NSString stringWithFormat:@"%@",array1[0]];
            
//            }
        }
    }
    return YES;
}
- (void)rightBtnClick
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":@"onesharejob2",
                             @"jobid":self.applyID,
                             @"user_id":kShareModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if([json[@"status"] isEqualToString:@"1"]){
            [self requstModel:^(id string) {
                [self shareWithUrl:json[@"url"] angImageStr:[IPADDRESS stringByAppendingString:self.model.logo]];
            }];
            //            [self shareWithUrl:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
-(void)shareWithUrl:(NSString *)urlString angImageStr:(NSString*)iageStr;
{
    NSString * briefStr = self.listModel.enterprise_brief;
    NSString *description1 = [WPMySecurities textFromBase64String:briefStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length) {
        self.listModel.enterprise_brief = description3;
    }
    
    
    
    NSString*light = self.listModel.lightspot;
    NSString *description4 = [WPMySecurities textFromBase64String:light];
    NSString *description5 = [WPMySecurities textFromEmojiString:description4];
    if (description5.length) {
        self.listModel.lightspot = description5;
    }
    
    urlString = [IPADDRESS stringByAppendingString:urlString];
    NSString * firstStr = nil;
    NSString * secondStr = nil;
//    if (self.isRecuilist)
//    {//招聘
    
        firstStr = [NSString stringWithFormat:@"招聘:%@",self.listModel.jobPositon];
        secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.listModel.enterpriseName.length?self.listModel.enterpriseName:@"",self.listModel.dataIndustry.length?self.listModel.dataIndustry:@"",self.listModel.enterprise_properties.length?self.listModel.enterprise_properties:@"",self.listModel.enterprise_scale.length?self.listModel.enterprise_scale:@"",self.listModel.enterprise_address.length?self.listModel.enterprise_address:@"",self.listModel.enterprise_brief.length?self.listModel.enterprise_brief:@""];
//    }
//    else
//    {
//        firstStr = [NSString stringWithFormat:@"求职:%@",self.model.HopePosition];
//        secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.age.length?self.model.age:@"",self.model.sex.length?self.model.sex:@"",self.model.education.length?self.model.education:@"",self.model.WorkTim.length?self.model.WorkTim:@"",self.model.lightspot];
//    }
    
    NSString * titleStr = [NSString stringWithFormat:@"%@|%@|%@",firstStr,secondStr,iageStr];
    [YYShareManager newShareWithTitle:titleStr url:urlString action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            [self sendeToWeiPinFriends];
        }
        if (type == YYShareManagerTypeWorkLines) {
            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
            NSString *jobids;
            NSString *share_title;
            NSString *name;
//            NSString *sex;
//            NSString *birthday;
//            NSString *education;
//            NSString *workTime;
            NSMutableArray *jobPhoto = [NSMutableArray array];
            int i = 0;
                if (jobids.length == 0) {
                    jobids = _listModel.resumeId;
                }else{
                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_listModel.resumeId];
                }
                share_title = [NSString stringWithFormat:@"招聘:%@",_listModel.jobPositon];
                if (!_listModel.avatar) {
                    _listModel.avatar = @"";
                }
                [jobPhoto addObject:@{@"small_address":_listModel.avatar}];
                name = _listModel.enterpriseName;
                
                i ++;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name}}];
                
            share.shareInfo = dic;
            share.shareSuccessedBlock = ^(id json){
                [MBProgressHUD createHUD:@"分享成功" View:self.view];
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
        //        if (status == UMSResponseCodeSuccess) {
        //        }
    }];
}

-(void)sendeToWeiPinFriends
{
    NSDictionary * dic = nil;
//    if (self.isRecuilist)
//    {//招聘
        dic = @{@"zp_id":self.listModel.resumeId,
                @"zp_position":self.listModel.jobPositon,
                @"zp_avatar":self.listModel.logo,
                @"cp_name":[NSString stringWithFormat:@"%@",self.listModel.enterpriseName],
                @"belong":self.listModel.resume_user_id,
                @"title":@"",@"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.listModel.enterpriseName.length?self.listModel.enterpriseName:@"",self.listModel.dataIndustry.length?self.listModel.dataIndustry:@"",self.listModel.enterprise_properties.length?self.listModel.enterprise_properties:@"",self.listModel.enterprise_scale.length?self.listModel.enterprise_scale:@"",self.listModel.enterprise_address.length?self.listModel.enterprise_address:@"",self.listModel.enterprise_brief.length?self.listModel.enterprise_brief:@""]};
//    }
//    else//求职
//    {
//        dic = @{@"qz_id":self.model.resumeId,
//                @"qz_avatar":self.model.avatar,
//                @"qz_position":self.model.HopePosition,
//                @"qz_name":self.model.name,
//                @"qz_sex":self.model.sex,
//                @"qz_age":@"",@"qz_educaiton":self.model.education,
//                @"qz_workTime":self.model.WorkTim,
//                @"belong":self.model.resume_user_id,
//                @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.age.length?self.model.age:@"",self.model.sex.length?self.model.sex:@"", self.model.education.length?self.model.education:@"",self.model.WorkTim.length?self.model.WorkTim:@"",self.model.lightspot.length?self.model.lightspot:@""],
//                @"title":@""};
//    }
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    DDMessageContentType  contentType;
//    if (self.isRecuilist)
//    {
        contentType = DDMEssageMyWant;
//    }
//    else
//    {
//        contentType = DDMEssageMyApply;
//    }
    [self tranmitMessage:messageContent andMessageType:contentType andToUserId:@""];
}

-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId
{//DDMessageTypeText
    
    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    
    person.dataSource = muarray;
    person.toUserId = userId;
    person.transStr = messageContent;
    switch (type) {
        case DDMEssageMyWant:
            person.display_type = @"9";
            break;
        case DDMEssageMyApply:
            person.display_type = @"8";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}

-(void)shareSuccess
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":@"onesharejob",
                             @"jobid":self.applyID,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
    } failure:^(NSError *error) {
    }];
}
-(void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];

    report.speak_trends_id = self.applyID;
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
}
-(void)requstModel:(void(^)(id))Success
{
    NSDictionary * dic = nil;
    NSString * urlStr = nil;
        dic = @{@"action":@"GetJobDraftInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":self.applyID};
        urlStr = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.logo = json[@"photoList"][0][@"original_path"];
            model.enterpriseName = json[@"enterprise_name"];
            model.resumeId = self.applyID;
            model.resume_user_id = json[@"user_id"];
            model.jobPositon = json[@"jobPositon"];
            model.enterprise_properties = json[@"enterprise_properties"];
            model.enterprise_brief = json[@"enterprise_brief"];
            model.enterprise_scale = json[@"enterprise_scale"];
            model.enterprise_address = json[@"enterprise_address"];
            model.dataIndustry = json[@"dataIndustry"];
            model.userId = json[@"user_id"];
            
            NSArray *epRemarkList = json[@"epRemarkList"];
            if (epRemarkList.count) {
                model.enterprise_brief = epRemarkList[0][@"txtcontent"];
            }
            self.listModel = model;
        Success(json);
    } failure:^(NSError *error) {
    }];
}


-(NSString*)getVideoPath:(NSString*)filePath
{
   
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    BOOL isOrNOt = [[NSFileManager defaultManager] fileExistsAtPath:fileName1];
    if (isOrNOt) {
        return fileName1;
    }
    else
    {
        return @"";
    }
}

- (void)removeAllImageViews
{
    for (UIImageView *imageView in self.array) {
        [imageView removeFromSuperview];
    }
}
- (NSInteger)getCurrentIndexPathWithUrl:(NSString *)urlStr
{
    int i = 0;
    for (Pohotolist *model in [WPIVManager sharedManager].model.ImgPhoto) {
        if ([model.original_path isEqualToString:urlStr]) {
            return i;
        }
        i++;
    }
    return 0;
}
- (void)showPhotoBrowserWithPhotoArray:(NSArray *)array url:(NSString *)urlStr
{
    NSInteger count = array.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    [self removeAllImageViews];
    for (int i = 0; i<array.count; i++) {
        Pohotolist *list = array[i];
        NSString *url = [IPADDRESS stringByAppendingString:list.original_path];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        imageView.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
        imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.view addSubview:imageView];
        photo.toView = imageView;
        [self.array addObject:imageView];
        [self.view sendSubviewToBack:imageView];
        [photos addObject:photo];
    }
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.isNewZoom = YES;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:[self getCurrentIndexPathWithUrl:urlStr] inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:self];
    //    [photoBrowser show];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[WPCompanyPositionCell class] forCellReuseIdentifier:kCompanyPositionCellReuse];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPPositionModel *model = self.manager.modelArr [indexPath.row];
    NearInterViewController *VC = [[NearInterViewController alloc]init];
    VC.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/recruit_info.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.job_id,kShareModel.userId];
    VC.subId = model.job_id;
    VC.resumeId = model.job_id;
    VC.userId = kShareModel.userId;
    VC.isRecuilist = 1;
    VC.title = model.jobPositon;
    [self.navigationController pushViewController:VC animated:YES];
}


@end
