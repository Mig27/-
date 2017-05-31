//
//  DemandDetailViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/9/11.
//  Copyright (c) 2015年 WP. All rights reserved.
// 奇葩需求详情

#import "DemandDetailViewController.h"
#import "MJRefresh.h"
#import "WFPopView.h"
#import "MBProgressHUD+MJ.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"
#import "AFHTTPRequestOperationManager.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "DemandCell.h"
#import "IQKeyboardManager.h"

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

@interface DemandDetailViewController ()

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIButton *applyBtn;

- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;

@end

@implementation DemandDetailViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self createWeb];
    [self createBottomView];
    [self initialInput];
    [self notificationCenter];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[DemandDetailViewController class]];
}

- (void)initNav{
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark 右按钮点击事件
- (void)rightBtnClick{
    
}

- (void)createWeb{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107)];
    _webView.backgroundColor = RGBColor(226, 226, 226);
    NSString *url = [NSString stringWithFormat:@"%@/webmobile/wonderful_details.aspx?domand_id=%@&user_id=%@",IPADDRESS,self.domand_id,self.user_id];
    NSLog(@"%@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
}

- (void)createBottomView
{
    NSArray *titles =  @[@"  评论",@"  报名"];
    NSArray *images = @[@"detail_comment",@"detail_apply"];
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH/2*i, SCREEN_HEIGHT-107, SCREEN_WIDTH/2, 43);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if (i == 1) {
            [button setTitle:self.is_good ? @"  已报" : @"  报名" forState:UIControlStateNormal];
            self.applyBtn = button;
        }
        [button setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i + 1;
        [button addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_normal.jpg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_highted.jpg"] forState:UIControlStateHighlighted];
        [self.view addSubview:button];
    }
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 107, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 107 + 14, 0.5, 15)];
    line2.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line2];
}

- (void)functionBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"评论");
//        [self answerTheQuestion];
                self.chatInputView.hidden = NO;
//                    self.chatInputView.textView.placeholder = @"回复:为情所伤";
                [self.chatInputView.textView becomeFirstResponder];
    } else {
        NSLog(@"赞");
        [self addLike];
    }
}

- (void)addLike
{
//    DemandCell *cell = (DemandCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
//    cell.functionBtn.selected = NO;
//    NSLog(@"%ld",(long)_selectedIndexPath.row);
//    NSString *is_good = _goodData[_selectedIndexPath.row];
//    NSLog(@"====%@",is_good);
//    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.info];
    params[@"action"] = @"ClickEntry";
    params[@"domandId"] = dic[@"domandId"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
    //    params[@"is_type"] = @"1";
    //    params[@"wp_speak_click_type"] = @"1";
    //    params[@"odd_domand_id"] = @"0";
    //    if ([is_good isEqualToString:@"0"]) {
    //        params[@"wp_speak_click_state"] = @"0";
    //    } else {
    //        params[@"wp_speak_click_state"] = @"1";
    //    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            self.is_good = !self.is_good;
            [self.applyBtn setTitle:self.is_good ? @"  已报" : @"  报名" forState:UIControlStateNormal];
            //            if ([is_good isEqualToString:@"0"]) {
            //                count ++;
            //                [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"entryCount"];
            //                [_goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
            //                [_data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
            //
            //            } else {
            //                count --;
            //                [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"entryCount"];
            //                [_goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
            //                [_data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
            //            }
            //            cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            //            [_tableView reloadData];
//            [self updateCommentCoutAndApplyCount];
        } else {
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
        [MBProgressHUD alertView:@"操作失败" Message:error.localizedDescription];
    }];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyBoadrDismiss];
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
    [self.view bringSubviewToFront:self.chatInputView];
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
    __weak DemandDetailViewController* weakSelf = self;
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
    [_recordingView setHidden:YES];
    [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.view bringSubviewToFront:self.chatInputView];
    self.chatInputView.hidden = YES;
}

- (void)keyBoadrDismiss
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
}

//- (JSMessageInputView *)chatInputView{
//    if (_chatInputView == nil) {
//        NSLog(@"创建");
//        CGRect inputFrame = CGRectMake(0, SCREEN_HEIGHT - 44.0f - 64.f,SCREEN_WIDTH,44.0f);
//        self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
//        [self.chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
//        [self.view addSubview:self.chatInputView];
//        [self.chatInputView.emotionbutton addTarget:self
//                                             action:@selector(showEmotions:)
//                                   forControlEvents:UIControlEventTouchUpInside];
//
//        [self.chatInputView.showUtilitysbutton addTarget:self
//                                                  action:@selector(showUtilitys:)
//                                        forControlEvents:UIControlEventTouchDown];
//
//        [self.chatInputView.voiceButton addTarget:self
//                                           action:@selector(p_clickThRecordButton:)
//                                 forControlEvents:UIControlEventTouchUpInside];
//        [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
//        _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
//        [_recordingView setHidden:YES];
//        [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
//        [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//        //        self.chatInputView.hidden = YES;
//
//    }
//    return _chatInputView;
//}

//评论
- (void)commentClick:(UIButton *)sender
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"*****%@",self.chatInputView.textView.text);
    //    NSMutableArray *data = _dataSources[self.currentPage];
    //    WPShareModel *model = [WPShareModel sharedModel];
    //    NSMutableDictionary *myDic = model.dic;
    //    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"action"] = @"replySpeak";
    //    params[@"speak_id"] = dic[@"sid"];
    //    params[@"username"] = model.username;
    //    params[@"password"] = model.password;
    //    params[@"user_id"] = myDic[@"userid"];
    //    //    params[@"nick_name"] = myDic[@"nick_name"];
    //    params[@"by_nick_name"] = dic[@"nick_name"];
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
    //            [self updateCommentCount];
    //        }
    //    } failure:^(NSError *error) {
    //        NSLog(@"error: %@",error);
    //    }];
    //
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self commentTheReq];
    [self keyBoadrDismiss];
}

- (void)commentTheReq
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.info];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"AddComment";
    params[@"domandId"] = dic[@"domandId"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    //    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"commentContent"] = self.chatInputView.textView.text;
    params[@"Replay_commentID"] = @"";
    params[@"replay_user_id"] = @"";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 0) {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            //            [self updateCommentCount];
//            [self updateCommentCoutAndApplyCount];
        } else {
            [MBProgressHUD showMessage:json[@"info"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    }];
    
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
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.info];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"AddComment";
//    params[@"domandId"] = dic[@"domandId"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    //    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"commentContent"] = @"";
//    params[@"Replay_commentID"] = @"";
//    params[@"replay_user_id"] = @"";
//    NSLog(@"****%@",params);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
//    NSData *audioData = [NSData dataWithContentsOfFile:file];
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:audioData name:@"speak_comment_content" fileName:@"speak_comment_content.mp3" mimeType:@"audio/mpeg3"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*****%@",json[@"info"]);
//        if ([json[@"status"] integerValue] == 0) {
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //            [alert show];
//            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
//            //            [self updateCommentCount];
////            [self updateCommentCoutAndApplyCount];
//        } else {
//            [MBProgressHUD showMessage:json[@"info"]];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//        [MBProgressHUD showError:error.localizedDescription toView:self.view];
//    }];
//    [self keyBoadrDismiss];
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
    [self keyBoadrDismiss];
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
    [self commentTheReq];
    [self keyBoadrDismiss];
    //    NSMutableArray *data = _datas[self.currentPage];
    //    WPShareModel *model = [WPShareModel sharedModel];
    //    NSMutableDictionary *myDic = model.dic;
    //    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"action"] = @"replySpeak";
    //    params[@"speak_id"] = dic[@"sid"];
    //    params[@"username"] = model.username;
    //    params[@"password"] = model.password;
    //    params[@"user_id"] = myDic[@"userid"];
    //    //    params[@"nick_name"] = myDic[@"nick_name"];
    //    params[@"by_nick_name"] = dic[@"nick_name"];
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
    //            [self updateCommentCount];
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

- (void)dealloc{
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
