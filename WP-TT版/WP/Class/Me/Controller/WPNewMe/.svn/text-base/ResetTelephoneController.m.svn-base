//
//  ResetTelephoneController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ResetTelephoneController.h"
#import "InputView.h"
#import "UIImage+autoGenerate.h"
#import "GetValidationView.h"
#import "WPLoginViewController1.h"
#import "LogoutAPI.h"
@interface ResetTelephoneController ()<UITextFieldDelegate>
{
    NSInteger time;
}
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)GetValidationView *newTelephone;
@property (nonatomic ,strong)InputView *inputverification;
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic ,strong)UIBarButtonItem *editButton;
@property (nonatomic ,strong)UIBarButtonItem *enterButton;
@property (nonatomic, copy) NSString *codeStr;
@end

@implementation ResetTelephoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机号";
    [self.view addSubview:self.label];
    [self.view addSubview:self.newTelephone];
    [self.view addSubview:self.inputverification];
    
    [self timeToFinishEditingWithSelected:NO];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

- (UIBarButtonItem *)editButton
{
    if (!_editButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [@"完成" getSizeWithFont:FUCKFONT(14) Height:44];
        button.frame = CGRectMake(0, 0, size.width, 44);
        
        [button normalTitle:@"完成" Color:RGB(127, 127, 127) Font:kFONT(14)];
        self.editButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _editButton;
}

- (UIBarButtonItem *)enterButton
{
    if (!_enterButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [@"完成" getSizeWithFont:FUCKFONT(14) Height:44];
        button.frame = CGRectMake(0, 0, size.width, 44);
        [button normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchDown];
        self.enterButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _enterButton;
}

- (void)timeToFinishEditingWithSelected:(BOOL)selected
{
    if (selected) {
        self.navigationItem.rightBarButtonItem = self.enterButton;
    }else{
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    
    if (![self.inputverification.textField.text isEqualToString:self.codeStr]) {
        [MBProgressHUD createHUD:@"验证码错误" View:self.view];
        return;
    }
    
    if ([self.codeStr isEqualToString:@"-1"]) {
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/login_reg.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"SetBanding",@"oldusername":kShareModel.username,@"newusername":self.newTelephone.textField.text,@"password":self.password};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        switch ([json[@"status"] intValue]) {
            case 0://失败
//                [MBProgressHUD createHUD:json[@"info"] View:self.view];
                [MBProgressHUD showError:json[@"info"] toView:self.view];
                break;
            case 1://成功
            {
                [self changeSecuretSuccess];
//                [MBProgressHUD createHUD:json[@"info"] View:self.view];
                
//                WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
//                [self.navigationController pushViewController:login animated:NO];
            }
                break;
            case 2://密码错误
//                [MBProgressHUD createHUD:json[@"info"] View:self.view];
                [MBProgressHUD showError:json[@"info"] toView:self.view];
                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
    
    }];
}

-(void)changeSecuretSuccess
{
    
    NSArray * object = @[kShareModel.username,kShareModel.password];
    LogoutAPI * login = [[LogoutAPI alloc]init];
    
    [login requestWithObject:object Completion:^(id response, NSError *error) {
        [MBProgressHUD hideHUD];
        [MTTUtil loginOut];
        //[MTTNotification postNotification:DDNotificationLogout userInfo:nil object:nil];
        WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
        login.isFromQuit = YES;
        [self.navigationController pushViewController:login animated:NO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"changeTelephoneSuccess"];
        
    }];
}
- (UILabel *)label
{
    if (!_label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(16, 9+64, SCREEN_WIDTH, 30)];
        self.label.font = kFONT(12);
        self.label.textColor = RGB(127, 127, 127);
        self.label.text = @"请输入手机号并验证:";
    }
    return _label;
}

- (InputView *)inputverification
{
    if (!_inputverification) {
        self.inputverification = [[InputView alloc]initWithFrame:CGRectMake(0, 64+30+20+kHEIGHT(43)+6, SCREEN_WIDTH, kHEIGHT(43))placeHolder:@"请输入验证码"];
        self.inputverification.textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    return _inputverification;
}

- (GetValidationView *)newTelephone
{
    if (!_newTelephone) {
        self.newTelephone = [[GetValidationView alloc]initWithFrame:CGRectMake(0, 30+64+6, SCREEN_WIDTH, kHEIGHT(43))];
        [self.newTelephone setTaget:self action:@selector(buttonAction:)];
        self.newTelephone.textField.delegate = self;
        
        self.newTelephone.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.newTelephone.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.newTelephone.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _newTelephone;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    if (textField.text.length > 6) {
        [self timeToFinishEditingWithSelected:YES];
    }else{
        [self timeToFinishEditingWithSelected:NO];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    if ([self.newTelephone.textField.text isEqualToString:kShareModel.username]) {
        [MBProgressHUD createHUD:@"该账号已绑定" View:self.view];
        return;
    }
    
    [self getCode];
    time = 60;
//    self.newTelephone.button.titleLabel.font = kFONT(12);
    [self.newTelephone.button setTitle:@"60s后重试" forState:UIControlStateNormal];
    [self.newTelephone.button removeTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:YES];
}

-(NSString*)getCode
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/verify_code.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"getCode",@"mobile":self.newTelephone.textField.text};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:urlStr parameters:dic
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //          NSString * str = [NSString stringWithFormat:@"%@",responseObject];
          NSData * data = (NSData*)responseObject;
          NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          self.codeStr = string;
          
          if ([string isEqualToString:@"-1"]) {
              [MBProgressHUD createHUD:@"今日验证次数已达上限" View:self.view];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          self.codeStr = error.description;
      }];
    return self.codeStr;
}
- (void)timerAction:(NSTimer *)timer
{
    time -- ;
    [self.newTelephone.button setTitle:[NSString stringWithFormat:@"%lds后重试",(long)time] forState:UIControlStateNormal];
    if (time == 0) {
        
//        self.newTelephone.button.titleLabel.font = kFONT(14);
        [self.newTelephone.button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.newTelephone setTaget:self action:@selector(buttonAction:)];
        [self.timer invalidate];
    }
}









@end
