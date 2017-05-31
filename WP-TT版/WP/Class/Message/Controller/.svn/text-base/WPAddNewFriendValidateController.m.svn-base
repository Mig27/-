//
//  WPAddNewFriendValidateController.m
//  WP
//
//  Created by Kokia on 16/5/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAddNewFriendValidateController.h"
#import "WPDragIntoBlackListCell.h"
#import "WPFriendValidateView.h"
#import "WPAddNewFriendHttp.h"
#import "CCAlertView.h"
#import "WPFriendValidateCell.h"
#import "LoginModel.h"
#import "DDUserModule.h"
#import "WPSetMessageType.h"
#import "RSSocketClinet.h"
#import "ChattingModule.h"
#import "MTTSessionEntity.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#define MAXVALUE 30
#define MINVALUE 5

@interface WPAddNewFriendValidateController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,WPDragIntoBlackListCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) UISwitch *fcircle;
@property (nonatomic,strong) UISwitch *fjob; //招聘
@property (nonatomic,strong) UISwitch *fresume;//求职


@end

@implementation WPAddNewFriendValidateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友验证";
    [self initNav];
    self.view.backgroundColor =  RGBCOLOR(238, 238, 238);
    [self setupTableView];
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wordLimit) name:UITextViewTextDidChangeNotification object:self.textView];
}



#pragma mark -  键盘通知方法
-(void)wordLimit{
    
    NSString *tobeString = self.textView.text;
    NSString *lang = self.textInputMode.primaryLanguage;  //获取键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.textView markedTextRange];
        if (!selectedRange) {
            if (tobeString.length > 30) {
                [MBProgressHUD createHUD:@"超过字数限制" View:self.view];
                self.textView.text = [tobeString substringToIndex:30];
                return;
            }
        }
        
    }else{
        if (tobeString.length > 30) {
            [MBProgressHUD createHUD:@"超过字数限制" View:self.view];
            self.textView.text = [tobeString substringToIndex:30];
            return;
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", 30 - (unsigned long)tobeString.length];
    
}
-(void)sendeMessageToOther:(NSString*)friendId andUser:(NSString*)userName
{
    
    MTTSessionEntity* session = [[MTTSessionEntity alloc]initWithSessionID:[@"user_" stringByAppendingString:friendId] SessionName:userName type:SessionTypeSessionTypeSingle];
    
    ChattingModule * mouble = [[ChattingModule alloc]init];
    mouble.MTTSessionEntity = session;
    
    NSDictionary * dic = @{@"display_type":@"16",
                           @"content":@{@"friend_name":[NSString stringWithFormat:@"%@",kShareModel.nick_name],
                                        @"friend_id":kShareModel.userId
                                       }
                           };
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
    NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:mouble MsgType:DDMEssageNotification];
//    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
//        DDLog(@"消息插入DB成功");
//    } failure:^(NSString *errorDescripe) {
//        DDLog(@"消息插入DB失败");
//    }];
    message.msgContent = cardStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
        });
    } Error:^(NSError *error) {
    }];
}
-(void)sendValidateMsg{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPAddNewFriendParam *param = [[WPAddNewFriendParam alloc] init];
    param.action = @"AddFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.fuser_id = self.fuser_id;
    if (self.fjob.isOn == YES) {
        param.is_fjob = @"true";
    }else{
        param.is_fjob = @"false";
    }
    if (self.fcircle.isOn == YES) {
        param.is_fcircle = @"true";
    }else{
        param.is_fcircle = @"false";
    }
    if (self.fresume.isOn == YES) {
        param.is_fresume = @"true";
    }else{
        param.is_fresume = @"false";
    }
    if (self.textView.text.length == 0||self.textView.text == nil) {
        param.belongGroup = @"请求添加你为好友";
    }
    param.belongGroup = self.textView.text;
    param.AddFriend = @"1";
    if (self.needPassIsShow == YES) {
         param.is_show = @"0";
    }
    param.friend_mobile = self.friend_mobile;
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPAddNewFriendHttp WPAddNewFriendHttpWithParam:param success:^(WPAddNewFriendResult *result) {
        if (result.status.intValue == 0) {
            
            //只发送一次推送
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"addFriends"];
            if (![array containsObject:self.fuser_id]) {
                //发送推送
                WPSetMessageType * type = [[WPSetMessageType alloc]init];
                [type sendNotification:kShareModel.nick_name user:self.fuser_id];
                NSMutableArray * muarr = [NSMutableArray array];
                [muarr addObjectsFromArray:array];
                [muarr addObject:self.fuser_id];
                array = [NSArray arrayWithArray:muarr];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"addFriends"];
            }
            //给安卓发送推送的消息
            [self sendeMessageToOther:self.fuser_id andUser:self.name];
            
            
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"发送成功" View:self.view];
            if ([self.comeFromVc isEqualToString:@"添加手机好友"]) {
                if (self.refreshState) {
                    self.refreshState(self.index);
                }
                AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                if (appDelegate.mobileArr == nil){
                    appDelegate.mobileArr = [NSMutableArray array];
                }
                //添加之前还要进行判断，去重
                for (NSString *str in appDelegate.mobileArr) {
                    if ([str isEqualToString:self.fuser_id]) {
                        return;
                    }else{
                        [appDelegate.mobileArr addObject:self.fuser_id];
                    }
                }
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.fuser_id,@"UserId",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"onlyShowOneTimeWaitValidate" object:self userInfo:dict];
            }
            else
            {
                if (self.refreshState) {
                    self.refreshState(self.index);
                }
            }
            [self performSelector:@selector(delayTime) withObject:nil afterDelay:0.5];
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
       
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}
-(void)delayTime
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendValidateMsg)];
    
}

-(void)backToFromVC{
    NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
//    NSString *nameStr = [NSString stringWithFormat:@"我是%@",kShareModel.nick_name];
    NSString *nameStr = [NSString stringWithFormat:@"我是%@的%@",dictionary[@"list"][0][@"company"],kShareModel.nick_name];
    if (self.fjob.isOn == YES ||self.fresume.isOn == YES ||self.fcircle.isOn == YES ||!([self.textView.text isEqualToString:nameStr])) {
        if (![self.textView.text isEqualToString:@""]) {
            CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:@"确认取消申请?"];
            [alert addBtnTitle:@"取消" action:^{
            }];
            [alert addBtnTitle:@"确定" action:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showAlertWithSender:self];

        }else{
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(32))];
    view.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:view];
    //字数label  限制28个字  往下减
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"发送验证信息";
    countLabel.font = kFONT(12);
    countLabel.textColor = RGB(127, 127, 127);
    [view addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(16);
        make.centerY.equalTo(view);
    }];

    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
}

#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                WPFriendValidateCell *cell= [WPFriendValidateCell cellWithTableView:tableView];
                cell.titleLbl.text = @"不让他看我的话题";
                self.fcircle =  cell.switchView;
                return cell;
            }else if(indexPath.row == 1){
                WPFriendValidateCell *cell= [WPFriendValidateCell cellWithTableView:tableView];
                cell.titleLbl.text = @"不让他看我的招聘";
                self.fjob =  cell.switchView;
                return cell;
            }else{
                WPFriendValidateCell *cell= [WPFriendValidateCell cellWithTableView:tableView];
                cell.titleLbl.text = @"不让他看我的求职";
                self.fresume =  cell.switchView;
                return cell;
            }
            
        }
            break;
        default:
            return nil;
            break;
    }
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = @"ahahha";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHEIGHT(78) + 20;
}


#pragma mark - UITextView delegate Methods
-(void)textViewDidChange:(UITextView *)textView{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 30;    //行间距
    paragraphStyle.maximumLineHeight = 60;   /**最大行高*/
    paragraphStyle.firstLineHeadIndent = kHEIGHT(10);    /**首行缩进宽度*/
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:kFONT(15),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(78) + 20)];
    UITextView *textview = [[UITextView alloc] init];
    self.textView = textview;
    textview.delegate = self;
    textview.font = kFONT(15);
    [view addSubview:textview];
    
    NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
//    LoginModel *loginModel = [LoginModel objectWithKeyValues:dictionary];
    
    if (kShareModel.nick_name.length == 0 || kShareModel.nick_name == nil) {
        textview.text = [NSString stringWithFormat:@"我是%@",@""];
    }else{
        textview.text = [NSString stringWithFormat:@"我是%@的%@",dictionary[@"list"][0][@"company"],kShareModel.nick_name];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 30;    //行间距
    paragraphStyle.maximumLineHeight = 60;   /**最大行高*/
    paragraphStyle.firstLineHeadIndent = kHEIGHT(10);    /**首行缩进宽度*/
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:kFONT(15),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textview.attributedText = [[NSAttributedString alloc] initWithString:textview.text attributes:attributes];
    

    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //字数label  限制28个字  往下减
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = [NSString stringWithFormat:@"%lu",30-textview.text.length];
    countLabel.font = kFONT(15);
    countLabel.textColor = RGB(127, 127, 127);
    [view addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(kHEIGHT(-10));
        make.bottom.equalTo(view.mas_bottom).with.offset(kHEIGHT(-30));
    }];
    self.countLabel = countLabel;
    UIView *bottomView=[[UIView alloc] init];
    bottomView.backgroundColor = RGB(235, 235, 235);
    [view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.bottom.equalTo(view.mas_bottom);
        make.height.equalTo(@20);
    }];

    
   
    return view;

}


- (void)doBtn
{
//    if (self.textView.text.length > MAXVALUE) {
//        NSLog(@"可以弹一个toast，说明不能超过某个限制的数字");
//    } else if (self.textView.text.length < MINVALUE){
//        NSLog(@"可以弹一个toast，说明不能小于某个限制的数字");
//    } else {
//        NSLog(@"可以进行下一步");
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//    
//    //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        return;
//    }
//    
//    NSUInteger count = textView.text.length;
//    if (count == MINVALUE) {
//        [MBProgressHUD createHUD:@"申请理由不得超过30" View:self.view];
//    } else {
//        self.countLabel.text = [NSString stringWithFormat:@"%ld", 30 - (unsigned long)count];
//    }
//}

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



@end
