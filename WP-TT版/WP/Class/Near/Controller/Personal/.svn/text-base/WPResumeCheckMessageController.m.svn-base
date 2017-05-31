//
//  WPResumeCheckMessageController.m
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPResumeCheckMessageController.h"
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"
#import "IQKeyboardManager.h"

#import "WPCommonCommentHeadCell.h"
#import "WPCommonCommentBodyCell.h"
#import "WPResumeMessageModel.h"

@interface WPResumeCheckMessageController () <UITableViewDelegate,UITableViewDataSource,JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>

@property (strong, nonatomic) UIView *bottomMessageView;
@property (strong, nonatomic) TouchTableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (assign, nonatomic) NSInteger messagePage;

@property (copy, nonatomic) NSString *replyCommentId;
@property (copy, nonatomic) NSString *replyUserId;

@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@end

@implementation WPResumeCheckMessageController


- (void)viewDidLoad {
    [super viewDidLoad];
    _messagePage = 1;
    _replyUserId = @"";
    _replyCommentId = @"";
    
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view).offset(-49);
        make.left.right.equalTo(self.view);
    }];
    [self bottomMessageView];
    
//    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[WPResumeCheckMessageController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPResumeCheckMessageController class]];
    
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
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
}

- (UIView *)bottomMessageView{
    if (!_bottomMessageView) {
        _bottomMessageView = [[UIView alloc]init];
        _bottomMessageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomMessageView];
        [_bottomMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.bottom.equalTo(self.view);
            make.height.equalTo(@49);
        }];
        
        [_bottomMessageView addSubview:self.chatInputView];
        [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bottomMessageView);
        }];
        
    }
    return _bottomMessageView;
}

- (TouchTableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.backgroundColor = [UIColor whiteColor];
        _messageTableView.separatorColor = [UIColor whiteColor];
        _messageTableView.tableFooterView = [[UIView alloc]init];
        
        WS(ws);
        _messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requestMessageList:1 success:^(NSArray *datas, int more) {
                [ws.messageTableView.mj_footer resetNoMoreData];
                [ws.messageArray removeAllObjects];
                [ws.messageArray addObjectsFromArray:datas];
                [ws.messageTableView reloadData];
            } error:^(NSError *error) {
            }];
            [ws.messageTableView.mj_header endRefreshing];
        }];
        
        [_messageTableView.mj_header beginRefreshing];
        
        _messageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _messagePage++;
            [ws requestMessageList:_messagePage success:^(NSArray *datas, int more) {
                if (!more) {
                    [ws.messageTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [ws.messageArray addObjectsFromArray:datas];
                    [ws.messageTableView reloadData];
                }
            } error:^(NSError *error) {
                _messagePage--;
            }];
            [ws.messageTableView.mj_footer endRefreshing];
        }];
        
    }
    return _messageTableView;
}

- (JSMessageInputView *)chatInputView{
    if (!_chatInputView) {
        //        CGRect inputFrame = CGRectMake(0, 0,SCREEN_WIDTH,49.0f);
        _chatInputView = [[JSMessageInputView alloc] initWithFrame:CGRectZero delegate:self];
        [_chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
        //        [self.view addSubview:_chatInputView];
        [self.view bringSubviewToFront:_chatInputView];
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
        
        //        _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
        //        __weak WPDetailControllerThree* weakSelf = self;
        //        _touchDownGestureRecognizer.touchDown = ^{
        //            [weakSelf p_record:nil];
        //        };
        //
        //        _touchDownGestureRecognizer.moveInside = ^{
        //            [weakSelf p_endCancelRecord:nil];
        //        };
        //
        //        _touchDownGestureRecognizer.moveOutside = ^{
        //            [weakSelf p_willCancelRecord:nil];
        //        };
        //
        //        _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
        //            if (inside)
        //            {
        //                [weakSelf p_sendRecord:nil];
        //            }
        //            else
        //            {
        //                [weakSelf p_cancelRecord:nil];
        //            }
        //        };
        //        [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
        //        _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
        //        [_recordingView setHidden:YES];
        //        [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
        [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.view bringSubviewToFront:self.chatInputView];
        _chatInputView.hidden = NO;
    }
    return _chatInputView;
}

- (void)requestMessageList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":(_isRecruit?@"GetJobComment":@"GetResumeComment"),@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.dic[@"userid"],@"page":@(page),(_isRecruit?@"job_id":@"resume_id"):_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeMessageModel *model = [WPResumeMessageModel mj_objectWithKeyValues:json];
        dealsSuccess(model.CommentList,(int)model.CommentList.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)replyCommontWithModel{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSDictionary *params = @{@"action":_isRecruit?@"AddCommentForJob":@"AddCommentForResume",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.dic[@"userid"],
                             _isRecruit?@"job_id":@"resume_id":_resumeId,
                             @"commentContent":self.chatInputView.textView.text,
                             @"Replay_commentID":_replyCommentId,
                             @"replay_user_id":_replyUserId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        [SPAlert alertControllerWithTitle:@"提示" message:json[@"info"] superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        [self.chatInputView.textView resignFirstResponder];
        if ([json[@"status"] isEqualToString:@"0"]) {
            self.chatInputView.textView.text = nil;
            self.chatInputView.textView.placeholder = @"评论";
            [self.chatInputView.textView resignFirstResponder];
            [self.messageTableView.mj_header beginRefreshing];
        }
    } failure:^(NSError *error) {
        [SPAlert alertControllerWithTitle:@"提示" message:error.localizedDescription superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self.messageTableView tableViewDisplayWitMsg:@"暂无留言信息" ifNecessaryForRowCount:self.messageArray.count];
    return self.messageArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.messageArray[section] ReplayCommentList]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"commentCellId";
    WPCommonCommentBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPCommonCommentBodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell confignDataWithModel:[self.messageArray[indexPath.section] ReplayCommentList][indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *cellId = @"WPCommonCommentHeadCell";
    WPCommonCommentHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPCommonCommentHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.tag = section;
    cell .model =self.messageArray[section];
    cell.ReplyBlock = ^(NSInteger number){
        WPResumeCheckMessageModel *model = self.messageArray[number];
        _replyCommentId = model.commentId;
        self.chatInputView.textView.placeholder = [NSString stringWithFormat:@"回复:%@",model.userName];
        [self.chatInputView.textView becomeFirstResponder];
        
    };
    
    cell.UserInfoBlock = ^(NSString *userid, NSString *userName){
        [SPAlert alertControllerWithTitle:@"提示" message:@"不知道跳到哪去" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    WPResumeCheckMessageModel *model = self.messageArray[section];
    return [WPCommonCommentHeadCell cellHeight:model.commentContent];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WPResumeCheckMessageModel *model = self.messageArray[indexPath.section];
    WPResumeCheckReplayCommentListModel *modelList = [self.messageArray[indexPath.section] ReplayCommentList][indexPath.row];
    _replyCommentId = model.commentId;
    _replyUserId = modelList.replayUserId;
    self.chatInputView.textView.placeholder = [NSString stringWithFormat:@"回复:%@",modelList.replayUserName];
    [self.chatInputView.textView becomeFirstResponder];
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

- (void)showEmotions:(UIButton *)sender{
    
}

- (void)showUtilitys:(UIButton *)sender{
    
}

- (void)p_clickThRecordButton:(UIButton *)button{
    
}

//监测键盘弹起收起
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [self.chatInputView willBeginInput];
    [self.bottomMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardRect.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [self.bottomMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}

@end
