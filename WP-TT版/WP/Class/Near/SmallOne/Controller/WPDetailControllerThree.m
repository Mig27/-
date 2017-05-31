//
//  WPDetailControllerThree.m
//  WP
//
//  Created by Asuna on 15/6/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPDetailControllerThree.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"

#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "QuestionCell.h"
#import "AnswerCell.h"
#import "PraiseCell.h"
#import "WriteViewController.h"
#import "WFPopView.h"
#import "WorkTableViewCell.h"
#import "PersonalHomepageController.h"
#import "AnswerViewController.h"

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
#define DDCOMPONENT_BOTTOM          CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) + NAVBAR_HEIGHT, SCREEN_WIDTH, 216)
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height + NAVBAR_HEIGHT,SCREEN_WIDTH,self.chatInputView.frame.size.height)
#define DDINPUT_HEIGHT              self.chatInputView.frame.size.height
#define DDINPUT_TOP_FRAME           CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height + NAVBAR_HEIGHT - 216, SCREEN_WIDTH, self.chatInputView.frame.size.height)
#define DDUTILITY_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) + NAVBAR_HEIGHT -216, SCREEN_WIDTH, 216)
#define DDEMOTION_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) + NAVBAR_HEIGHT-216, SCREEN_WIDTH, 216)


#define SHAREMAGIN 16
#define SHAREPICWIDTH 44
#define SHARESCROLLHEIGHT 80
@interface WPDetailControllerThree ()<UITableViewDataSource,UITableViewDelegate,updateDataSources,writeRefreshData,refreshList,refreshData>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* shareView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, strong) UIView *functionBackView;
@property (nonatomic, assign) BOOL isCreate;
@property (nonatomic, strong) NSMutableArray *answerData;  //评论的数据
@property (nonatomic, strong) NSMutableArray *praiseData;  //赞的数据
@property (nonatomic, assign) BOOL isPraise;               //是否切换到点赞页面


@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSString *isFavour; //     是否已赞过
@property (nonatomic,strong) UIButton *praiseButton; //下面的点赞按钮

- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;

@end

@implementation WPDetailControllerThree
{
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    DDBottomShowComponent _bottomShowComponent;
    UIButton *_recordButton;
    float _inputViewY;
    NSString* _currentInputContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"***%@",self.userInfo);
    self.isCreate = NO;
    self.isPraise = NO;
    
    _answerData = [NSMutableArray array];
    _praiseData = [NSMutableArray array];
    
    
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(selectPicture)];
//    self.view.backgroundColor = WPColor(235, 235, 235);
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBottomView];
    [self reloadData];
    [self notificationCenter];
//    [self addViewBottomTWO];
    // Do any additional setup after loading the view.
}

- (void)selectPicture{
    
    if (self.isCreate) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.functionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 - 44)];
    }];
    self.functionView.backgroundColor = RGBColor(235, 235, 235);
    NSArray *titles = @[@" 收藏",@" 举报"];
    NSArray *images = @[@"collection",@"report"];
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 44*i, SCREEN_WIDTH, 43);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(14, SCREEN_WIDTH/2-28, 15, SCREEN_WIDTH/2 + 14)];
        button.tag = i + 1;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.functionView addSubview:button];
    }
    
    UIButton *buttonSix = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSix.frame = CGRectMake(0, 44*2 + 6, self.view.bounds.size.width, 43);
    [buttonSix setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
    //    [buttonSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSix setBackgroundColor:[UIColor whiteColor]];
    buttonSix.tag = 4;
    [buttonSix setImageEdgeInsets:UIEdgeInsetsMake(5, (SCREEN_WIDTH - 33)/2, 5, (SCREEN_WIDTH - 33)/2)];
    [buttonSix addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:buttonSix];
    
    self.functionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.functionBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.functionBackView addSubview:self.functionView];
    self.functionBackView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    [self.functionBackView addGestureRecognizer:tap];
    
    [self.view addSubview:self.functionBackView];
    
    self.isCreate = YES;
}

- (void)photoBtnClick:(UIButton *)sender
{
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
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
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = self.userInfo[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
//    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
    params[@"is_type"] = @"1";
    params[@"odd_domand_id"] = @"0";
    params[@"wp_speak_click_state"] = @"1";
    if (sender.tag == 1) {       //收藏
        params[@"wp_speak_click_type"] = @"3";
    } else if (sender.tag == 2) {//举报
        params[@"wp_speak_click_type"] = @"4";
    } else if (sender.tag == 3) {//分享
        params[@"wp_speak_click_type"] = @"2";
    }
    
    NSLog(@"******%@",params);
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];

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
    params[@"action"] = @"GetList";
    params[@"ask_id"] = self.userInfo[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    NSLog(@"******%@",params);
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/answer.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
//        self.answerData = json[@"answerlist"];
        self.praiseData = json[@"UserList"];
        NSArray *arr = json[@"answerlist"];
        [_answerData addObjectsFromArray:arr];
//        NSLog(@"*****%@",_answerData);
        [self tableView];
        [_tableView reloadData];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];


}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isPraise) {
        return self.answerData.count + 1;
    } else {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.type == DetailTypeQuestion) {
            static NSString *cellId = @"cellId";
            QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[QuestionCell alloc] init];
                cell.type = QuestionCellTypeSpecial;
            }
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.is_praise = self.isPraise;
            cell.isComment = NO;
            cell.delegate = self;
            [cell confineCellwithData:self.userInfo];
            cell.functionBtn.appendIndexPath = indexPath;
            [cell.dustbinBtn addTarget:self action:@selector(dustbinClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.attentionBtn addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.iconBtn addTarget:self action:@selector(checkHeadPersonalHomePage) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else {
            static NSString *cellId = @"workcellId";
            WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[WorkTableViewCell alloc] init];
                cell.delegate2 = self;
                if (self.type == DetailTypeDynamic) {
                    cell.cellType = CellLayoutTypeSpecial;
                } else {
                    cell.cellType = CellLayoutTypeNormal;
                }
                //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
                cell.type = WorkCellTypeSpecial;
            }
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.is_praise = self.isPraise;
            [cell confineCellwithData:self.userInfo];
            cell.functionBtn.appendIndexPath = indexPath;
            [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.dustbinBtn addTarget:self action:@selector(dustbinClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.attentionBtn addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.iconBtn addTarget:self action:@selector(checkHeadPersonalHomePage) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }
    } else {
        if (!self.isPraise) {
            static NSString *cellID = @"cell";
            AnswerCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!Cell) {
                Cell = [[AnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            Cell.selectionStyle = UITableViewCellAccessoryNone;
            NSDictionary *dic = self.answerData[indexPath.row - 1];
            Cell.iconBtn.appendIndexPath = indexPath;
            [Cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
            [Cell confignCellWith:dic];
            return Cell;
        } else {
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

- (void)reloadDataWith:(NSString *)staue
{
    if ([staue isEqualToString:@"1"]) {
        self.isPraise = NO;
        [_tableView reloadData];
    } else {
        self.isPraise = YES;
        [_tableView reloadData];
    }
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

- (void)checkHeadPersonalHomePage
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",self.userInfo[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = self.userInfo[@"nick_name"];
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

- (void)checkPersonalHomePage:(WPButton *)sender
{
    self.iconClickIndexPath = sender.appendIndexPath;
    NSDictionary *dic = self.answerData[self.iconClickIndexPath.row - 1];
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


- (void)replyAction:(WPButton *)sender
{
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    
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
    NSString *is_good = [NSString stringWithFormat:@"%@",self.userInfo[@"is_good"]];
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
        if (self.type == DetailTypeQuestion) {
            _operationView.rightType = WFRightButtonTypeAnswer;
        } else {
            _operationView.rightType = WFRightButtonTypePraise;
        }
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
    QuestionCell *cell = (QuestionCell *)[_tableView cellForRowAtIndexPath:index];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = self.userInfo[@"sid"];
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
            if (!self.is_good) {
                count ++;
            } else {
                count --;
            }
            cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            self.is_good = !self.is_good;
            [self.userInfo setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [self.praiseButton setTitle:self.is_good ? @"  已赞" : @"  赞" forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];

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
    params[@"speakid"] = [NSString stringWithFormat:@"%@",self.userInfo[@"sid"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    
    NSInteger count = [self.userInfo[@"original_photos"] count];
    if (count > 0) {
        NSArray *arr = self.userInfo[@"original_photos"];
        NSMutableArray *adress = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *str = dic[@"media_address"];
            [adress addObject:str];
        }
        NSString *img_address = [adress componentsJoinedByString:@"|"];
        params[@"img_address"] = img_address;
        
    }
    NSLog(@"****%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json[@"info"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

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
    params[@"by_user_id"] = self.userInfo[@"user_id"];
    params[@"by_nick_name"] = self.userInfo[@"nick_name"];
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
            NSString *attention = [NSString stringWithFormat:@"%@",self.userInfo[@"attention_state"]];
            if ([attention isEqualToString:@"0"]) {
                [self.userInfo setObject:@"1" forKey:@"attention_state"];
            } else if([attention isEqualToString:@"1"]){
                [self.userInfo setObject:@"0" forKey:@"attention_state"];
            } else if ([attention isEqualToString:@"2"]) {
                [self.userInfo setObject:@"3" forKey:@"attention_state"];
            } else if ([attention isEqualToString:@"3"]) {
                [self.userInfo setObject:@"2" forKey:@"attention_state"];
            }
            
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];

}


- (void)replyMessage:(WPButton *)sender
{
    [self answerTheQuestion];
}

- (void)buttonClick:(UIButton *)btn
{
    NSLog(@"点击");
    UIButton *button = (UIButton *)[self.view viewWithTag:10000];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:10001];
    if (btn.tag == 10000) {
//        self.btn1.selected = YES;
//        self.btn2.selected = NO;
        button.selected = YES;
        button2.selected = NO;
        self.isPraise = NO;
        [_tableView reloadData];
    } else {
        button.selected = NO;
        button2.selected = YES;
//        self.btn1.selected = NO;
//        self.btn2.selected = YES;
        self.isPraise = YES;
        [_tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { //第一行
        if (self.type == DetailTypeQuestion) {
            NSInteger count = [self.userInfo[@"imgCount"] integerValue];
            NSInteger videoCount = [self.userInfo[@"videoCount"] integerValue];
            
            CGFloat descriptionLabelHeight;//内容的显示高度
            if ([self.userInfo[@"speak_comment_content"] length] == 0) {
                descriptionLabelHeight = 0;
            } else {
                descriptionLabelHeight = [self sizeWithString:self.userInfo[@"speak_comment_content"] fontSize:14].height;
//                if (descriptionLabelHeight > 16.702 *6) {
//                    descriptionLabelHeight = 16.702 *6;
//                } else {
//                    descriptionLabelHeight = descriptionLabelHeight;
//                }
            }
            CGFloat photosHeight;//定义照片的高度
            
            if (videoCount == 1) {
                NSLog(@"controller 有视频");
                photosHeight = 76;
            } else {
                if (count == 0) {
                    photosHeight = 0;
                } else if (count >= 1 && count <= 3) {
                    photosHeight = 76;
                } else if (count >= 4 && count <= 6) {
                    photosHeight = 76*2 + 3;
                } else {
                    photosHeight = 76*3 + 6;
                }
            }
            
            CGFloat cellHeight;
            if ([self.userInfo[@"address"] length] == 0) {
                if ([self.userInfo[@"original_photos"] count] == 0) {
                    cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 27 + 6;
                } else {
                    cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 22 + 6 + 2;
                }
            } else {
                cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 + 6;
            }
            
            return cellHeight;
        } else {
            
            NSInteger count = [self.userInfo[@"imgCount"] integerValue];
            NSInteger videoCount = [self.userInfo[@"videoCount"] integerValue];
            
            CGFloat descriptionLabelHeight;//内容的显示高度
            if ([self.userInfo[@"speak_comment_content"] length] == 0) {
                descriptionLabelHeight = 0;
            } else {
                CGSize size = [self.userInfo[@"speak_comment_content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-68, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;

                descriptionLabelHeight = size.height;
//                if (descriptionLabelHeight > 16.702 *6) {
//                    descriptionLabelHeight = 16.702 *6;
//                } else {
//                    descriptionLabelHeight = descriptionLabelHeight;
//                }
            }
            CGFloat photosHeight;//定义照片的高度
            
            if (self.type == DetailTypeDynamic) { //职场动态
                if (videoCount == 1) {
                    NSLog(@"controller 有视频");
                    photosHeight = 0.625*SCREEN_WIDTH;
                } else {
                    if (count == 0) {
                        photosHeight = 0;
                    } else if (count == 1) {
                        NSString *url = [IPADDRESS stringByAppendingString:self.userInfo[@"original_photos"][0][@"media_address"]];
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                        CGFloat width = image.size.width;
                        CGFloat height = image.size.height;
                        if (width >height) {
                            CGFloat scaleOne = width/200;
                            width = 200;
                            height = height/scaleOne;
                        } else {
                            CGFloat scaleTwo = height/200;
                            height = 200;
                            width = width/scaleTwo;
                        }
                        
                        photosHeight = height;
                        
                    } else if (count == 2 || count == 3) {
                        photosHeight = 76;
                    } else if (count >= 4 && count <= 6) {
                        photosHeight = 76*2 + 3;
                    } else {
                        photosHeight = 76*3 + 6;
                    }
                }
            } else {  //除职场动态外的其他模块
                if (videoCount == 1) {
                    NSLog(@"controller 有视频");
                    photosHeight = 76;
                } else {
                    if (count == 0) {
                        photosHeight = 0;
                    } else if (count >= 1 && count <= 3) {
                        photosHeight = 76;
                    } else if (count >= 4 && count <= 6) {
                        photosHeight = 76*2 + 3;
                    } else {
                        photosHeight = 76*3 + 6;
                    }
                }
            }
            
            CGFloat cellHeight;
            if ([self.userInfo[@"address"] length] == 0) {
                if ([self.userInfo[@"original_photos"] count] == 0) {
                    cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 27 + 6;
                } else {
                    cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 22 + 6 + 2;
                }
            } else {
                cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 + 6;
            }
            return cellHeight;
            
        }
    } else { //不是第一行
        if (!self.isPraise) {//显示回答
            CGFloat commentLabelHeight;//内容的显示高度
            NSDictionary *dic = _answerData[indexPath.row - 1];
            if ([dic[@"answer_content"] length] == 0) {
                commentLabelHeight = 0;
            } else {
                CGSize size = [dic[@"answer_content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                commentLabelHeight = size.height;
                if (commentLabelHeight > 16.702 *3) {
                    commentLabelHeight = 16.702 *3;
                } else {
                    commentLabelHeight = commentLabelHeight;
                }
            }
            if (commentLabelHeight <18) {
                return 48;
            } else {
                return 10 + 16.702 + 10 + commentLabelHeight;
            }
        } else { //显示赞
            if (_praiseData.count == 0) {
                return 0;
            } else {
                CGFloat width = (SCREEN_WIDTH - 120)/5;
                return (_praiseData.count/5 + 1)*(width + 10 + 21) + 10;
            }
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == DetailTypeQuestion && !self.isPraise) {
        if (indexPath.row != 0) {
            AnswerViewController *answer = [[AnswerViewController alloc] init];
            answer.delegate = self;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.answerData[indexPath.row - 1]];
            answer.info = dic;
            [self.navigationController pushViewController:answer animated:YES];
        }
    }
    
}

- (void)refreshList
{
    [_answerData removeAllObjects];
    [_praiseData removeAllObjects];
    [self reloadData];
}

- (void)refreshData
{
    [_answerData removeAllObjects];
    [_praiseData removeAllObjects];
    [self reloadData];
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_operationView dismiss];
    
//    WorkTableViewCell *cell = (WorkTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
//    cell.functionBtn.selected = NO;
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
}


- (void)createBottomView
{
    NSArray *titles;
    NSArray *images;
    if (self.type == DetailTypeQuestion) {
        titles = @[@"  回答",@"  赞"];
        images = @[@"detail_answer",@"detail_praise"];
    } else {
        titles =  @[@"  评论",@"  赞"];
        images = @[@"detail_comment",@"detail_praise"];
    }
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH/2*i, SCREEN_HEIGHT-107, SCREEN_WIDTH/2, 43);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if (i == 1) {
            [button setTitle:self.is_good ? @"  已赞" : @"  赞" forState:UIControlStateNormal];
            self.praiseButton = button;
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
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 107, 0.5, 43)];
    line2.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line2];
}

- (void)functionBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"评论");
        [self answerTheQuestion];
    } else {
        NSLog(@"赞");
        [self addLike];
//        WPShareModel *model = [WPShareModel sharedModel];
//        NSMutableDictionary *userInfo = model.dic;
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"action"] = @"prise";
//        params[@"speak_trends_id"] = self.userInfo[@"sid"];
//        params[@"user_id"] = userInfo[@"userid"];
//        params[@"username"] = model.username;
//        params[@"password"] = model.password;
////        params[@"nick_name"] = userInfo[@"nick_name"];
//        //    params[@"user_id"] = @"108";
//        //    params[@"nick_name"] = @"Jack";
//        params[@"is_type"] = @"1";
//        params[@"wp_speak_click_type"] = @"1";
//        params[@"odd_domand_id"] = @"0";
//        if (!self.is_good) {
//            params[@"wp_speak_click_state"] = @"0";
//        } else {
//            params[@"wp_speak_click_state"] = @"1";
//        }
//        
//        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//        [WPHttpTool postWithURL:url params:params success:^(id json) {
//            NSLog(@"json: %@",json);
//            
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////            [alert show];
//            UIButton *button = (UIButton *)[self.view viewWithTag:btn.tag];
//            self.is_good = !self.is_good;
//            [button setTitle:self.is_good ? @"  已赞" : @"  赞" forState:UIControlStateNormal];
//        } failure:^(NSError *error) {
//            NSLog(@"error: %@",error);
//        }];
    }
}

- (void)answerTheQuestion
{
    if (self.type == DetailTypeQuestion) {
        WriteViewController *write = [[WriteViewController alloc] init];
        write.delegate = self;
        write.type = WriteTypeAnswer;
        write.myTitle = @"回答";
        write.ask_id = self.userInfo[@"sid"];
        [self.navigationController pushViewController:write animated:YES];
    }  else {
        self.chatInputView.hidden = NO;
        [self.chatInputView.textView becomeFirstResponder];
    }
}

- (void)addViewBottomTWO
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = 40;
    CGFloat xPos = 0;
    CGFloat yPos = self.view.bounds.size.height - 2 * height - 20;

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
    view.backgroundColor = [UIColor blackColor];

    UIButton* buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonOne setFrame:CGRectMake(0, 0, width / 2, height)];
    [buttonOne setImage:[UIImage imageNamed:@"蓝色评论"] forState:UIControlStateNormal];
    [buttonOne setTitle:@"评论" forState:UIControlStateNormal];
    [buttonOne setBackgroundColor:[UIColor blackColor]];
    [view addSubview:buttonOne];

    UIButton* buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTwo setFrame:CGRectMake(width / 2, 0, width / 2, height)];
    [buttonTwo setImage:[UIImage imageNamed:@"蓝色赞"] forState:UIControlStateNormal];
    [buttonTwo setBackgroundColor:[UIColor blackColor]];
    [buttonTwo setTitle:@"点赞" forState:UIControlStateNormal];
    [view addSubview:buttonTwo];
    self.bottomView = view;
    [self.view insertSubview:view aboveSubview:self.webView];
}
- (void)clickPointButton
{
    self.backView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    backView.backgroundColor = [UIColor blackColor];
//    backView.alpha = 0.6;
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 205 + 64, self.view.bounds.size.width, 205)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(clickCancel)];
    [self.backView addGestureRecognizer:tap];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.shareView aboveSubview:self.bottomView];
    [_backView addSubview:self.shareView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_backView];

    [self addShareScrollView];

    //第一页
    [self addSharePageOne];
    //第二页
    [self addSharePageTwo];
    // //第三页
    [self addSharePageThree];

    [self addViewBottom];
}
- (void)addViewBottom
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, SHARESCROLLHEIGHT, self.view.bounds.size.width, 300 - SHARESCROLLHEIGHT)];

    view.backgroundColor = WPColor(235, 235, 235);
    for (int i = 0; i < 2; ++i) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SHAREMAGIN + (i) * (SHAREMAGIN + SHAREPICWIDTH), SHAREMAGIN, SHAREPICWIDTH, SHAREPICWIDTH);
        NSString* strPic = [NSString stringWithFormat:@"share_bottom_%d", i];
        [button setImage:[UIImage imageNamed:strPic] forState:UIControlStateNormal];
        [view addSubview:button];
    }

    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 8, SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lable.text = @"收藏";
    [lable setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lable];

    UILabel* lableOne = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 8 + (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH + 8, SHAREPICWIDTH - 20)];
    lableOne.text = @"举报";
    [lableOne setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lableOne];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, SHAREMAGIN + SHAREPICWIDTH + SHAREPICWIDTH - 20, self.view.bounds.size.width, 40);
    [button setImage:[UIImage imageNamed:@"share_cancel"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchDown];
    button.backgroundColor = [UIColor whiteColor];
    [view addSubview:button];
    [self.shareView addSubview:view];
}

- (void)clickCancel
{
    [self.shareView removeFromSuperview];
    [self.backView removeFromSuperview];
}
- (void)addShareScrollView
{
    //UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.shareView.bounds];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.shareView.bounds.size.width, SHARESCROLLHEIGHT)];
    scrollView.contentSize = CGSizeMake(self.shareView.frame.size.width * 3, SHARESCROLLHEIGHT);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = WPColor(235, 235, 235);
    //不显示水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    //支持分页属性
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;
    [self.shareView addSubview:self.scrollView];
}

//第一页
- (void)addSharePageOne
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.shareView.frame.size.width, SHARESCROLLHEIGHT)];
    view.backgroundColor = WPColor(235, 235, 235);

//    NSArray* array = @[ @"好友", @"职场动态", @"微信好友", @"朋友圈", @"QQ" ];

    for (int i = 0; i < 5; ++i) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SHAREMAGIN + (i) * (SHAREMAGIN + SHAREPICWIDTH), SHAREMAGIN, SHAREPICWIDTH, SHAREPICWIDTH);
        NSString* strPic = [NSString stringWithFormat:@"share_one_%d", i];
        [button setImage:[UIImage imageNamed:strPic] forState:UIControlStateNormal];
        [view addSubview:button];
    }

    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 8, SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lable.text = @"好友";
    [lable setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lable];

    UILabel* lableOne = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lableOne.text = @"职场动态";
    [lableOne setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lableOne];

    UILabel* lableTwo = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 3 + 2 * (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lableTwo.text = @"微信好友";
    [lableTwo setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lableTwo];

    UILabel* lableThree = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 5 + 3 * (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lableThree.text = @"朋友圈";
    [lableThree setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lableThree];

    UILabel* lableFour = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 10 + 4 * (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lableFour.text = @"QQ";
    [lableFour setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lableFour];

    [self.scrollView addSubview:view];
}
//第二页
- (void)addSharePageTwo
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(self.shareView.frame.size.width, 0, self.shareView.frame.size.width, SHARESCROLLHEIGHT)];
    view.backgroundColor = WPColor(235, 235, 235);
    for (int i = 0; i < 5; ++i) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SHAREMAGIN + (i) * (SHAREMAGIN + SHAREPICWIDTH), SHAREMAGIN, SHAREPICWIDTH, SHAREPICWIDTH);
        NSString* strPic = [NSString stringWithFormat:@"share_two_%d", i];
        [button setImage:[UIImage imageNamed:strPic] forState:UIControlStateNormal];
        [view addSubview:button];
    }

    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN - 3, SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lable.text = @"QQ空间";
    [lable setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lable];

    UILabel* lableOne = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + (SHAREPICWIDTH + SHAREMAGIN) - 3, SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH + 8, SHAREPICWIDTH - 20)];
    lableOne.text = @"职场正能量";
    [lableOne setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lableOne];

    UILabel* lableTwo = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 2 * (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lableTwo.text = @"职场吐槽";
    [lableTwo setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lableTwo];

    UILabel* lableThree = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 3 * (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH + 8, SHAREPICWIDTH - 20)];
    lableThree.text = @"职场心理学";
    [lableThree setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lableThree];

    UILabel* lableFour = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + 4 + 4 * (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lableFour.text = @"职场智慧";
    [lableFour setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lableFour];

    [self.scrollView addSubview:view];
}
//第三页
- (void)addSharePageThree
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(self.shareView.frame.size.width * 2, 0, self.shareView.frame.size.width, SHARESCROLLHEIGHT)];
    view.backgroundColor = WPColor(235, 235, 235);
    for (int i = 0; i < 2; ++i) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SHAREMAGIN + (i) * (SHAREMAGIN + SHAREPICWIDTH), SHAREMAGIN, SHAREPICWIDTH, SHAREPICWIDTH);
        NSString* strPic = [NSString stringWithFormat:@"share_three_%d", i];
        [button setImage:[UIImage imageNamed:strPic] forState:UIControlStateNormal];
        [view addSubview:button];
    }

    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN, SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH, SHAREPICWIDTH - 20)];
    lable.text = @"创业心得";
    [lable setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lable];

    UILabel* lableOne = [[UILabel alloc] initWithFrame:CGRectMake(SHAREMAGIN + (SHAREPICWIDTH + SHAREMAGIN), SHAREMAGIN + SHAREPICWIDTH, SHAREPICWIDTH + 8, SHAREPICWIDTH - 20)];
    lableOne.text = @"情感新悟";
    [lableOne setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lableOne];

    [self.scrollView addSubview:view];
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
    __weak WPDetailControllerThree* weakSelf = self;
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


//评论
- (void)commentClick:(UIButton *)sender
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"*****%@",self.chatInputView.textView.text);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = self.userInfo[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
//    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = self.userInfo[@"nick_name"];
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    params[@"speak_reply"] = @"0";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
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
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = self.userInfo[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
////    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"by_nick_name"] = self.userInfo[@"nick_name"];
//    //    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    params[@"speak_reply"] = @"0";
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
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
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
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
    
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
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = self.userInfo[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
//    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = self.userInfo[@"nick_name"];
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    params[@"speak_reply"] = @"0";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
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
