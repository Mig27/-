//
//  ForgetPassWordViewController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "GetValidationView.h"
#import "InputView.h"
#import "WPLoginViewController1.h"
#import "LogoutAPI.h"
#import "WPcodeAlert.h"
@interface ForgetPassWordViewController ()
{
    NSInteger time;
}
@property (nonatomic ,strong)GetValidationView *telephone;
@property (nonatomic ,strong)InputView *validation;
@property (nonatomic ,strong)InputView *nowPass;
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic, copy) NSString * codeStr;
@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    [self.view addSubview:self.label];
    [self.view addSubview:self.telephone];
    [self.view addSubview:self.validation];
    [self.view addSubview:self.nowPass];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}
#pragma mark  点击完成
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    
    
   
    if (!self.nowPass.textField.text.length) {
        [MBProgressHUD createHUD:@"请输入新密码" View:self.view];
        return;
    }
    
    if (!self.validation.textField.text.length) {
        [MBProgressHUD createHUD:@"请输入验证码" View:self.view];
        return;
    }
    
    if (![self.codeStr isEqualToString:self.validation.textField.text]) {
        [MBProgressHUD createHUD:@"验证码错误" View:self.view];
        return;
    }
   [MBProgressHUD showMessage:@"" toView:self.view];
    NSDictionary * dic = @{@"action":@"updatePwd",
                           @"username":self.telephone.textField.text,//kShareModel.username
                           @"password":self.nowPass.textField.text,
                           @"code":self.validation.textField.text};
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,@"/ios/login_reg.ashx"];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
       
        if ([json[@"status"] isEqualToString:@"1"]) {
            kShareModel.username = self.telephone.textField.text;
            kShareModel.password = self.nowPass.textField.text;
            
            if (self.isFrom) {

                
                [self changeSecuretSuccess];
                
                
//                [MBProgressHUD createHUD:@"修改成功" View:self.view];
//                WPLoginViewController1 *login = [[WPLoginViewController1 alloc]init];
//                [self.navigationController pushViewController:login animated:YES];
            }
            else
            {
                [self changeSecuretSuccess];
//                [MBProgressHUD createHUD:@"修改成功" View:self.view];
//                WPLoginViewController1 *login = [[WPLoginViewController1 alloc]init];
//                [self.navigationController pushViewController:login animated:YES];

            }
        }
        else
        {
            [MBProgressHUD createHUD:@"修改密码失败!" View:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD createHUD:@"修改密码失败!" View:self.view];
    }];
    
}
-(void)showMessage
{
    [MBProgressHUD showHudTipStr:@"密码修改成功,请重新登录"];
}
-(void)changeSecuretSuccess
{
    
    NSArray * object = @[kShareModel.username,kShareModel.password];
    LogoutAPI * login = [[LogoutAPI alloc]init];
    
    [login requestWithObject:object Completion:^(id response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
            [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.1];
            [MTTUtil loginOut];
            WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
            login.isFromQuit = YES;
            [self.navigationController pushViewController:login animated:NO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        });
//        [MTTUtil loginOut];
//        //             [MTTNotification postNotification:DDNotificationLogout userInfo:nil object:nil];
//        WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
//        login.isFromQuit = YES;
//        [self.navigationController pushViewController:login animated:NO];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
    }];
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(16, 9+64, SCREEN_WIDTH, 30)];
        self.label.font = kFONT(12);
        self.label.textColor = RGB(127, 127, 127);
        self.label.text = @"请获取短信验证码,并设置新的登录密码:";
    }
    return _label;
}

- (InputView *)validation
{
    if (!_validation) {
        CGFloat y = self.telephone.origin.y + self.telephone.size.height+20;
        self.validation = [[InputView alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, kHEIGHT(43))placeHolder:@"输入验证码"];
        self.validation.textField.delegate = self;
        
        self.validation.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.validation.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.validation.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.validation.textField setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
        [self.validation.textField setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
    }
    return _validation;
}

- (InputView *)nowPass
{
    if (!_nowPass) {
        
        CGFloat y = self.validation.origin.y + self.validation.size.height+20;
        self.nowPass = [[InputView alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, kHEIGHT(43))placeHolder:@"设置新密码"];
        [self.nowPass.textField setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
        [self.nowPass.textField setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
        self.nowPass.textField.delegate = self;
        
        self.nowPass.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.nowPass.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.nowPass.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.nowPass.textField.secureTextEntry = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(43), 0, kHEIGHT(43), kHEIGHT(43));
        [button setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"login_xianshimima_pre"] forState:UIControlStateSelected];
//        button.selected = YES;
        [button addTarget:self action:@selector(PassButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.nowPass addSubview:button];
    }
    return _nowPass;
}

- (void)PassButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.nowPass.textField.secureTextEntry = !sender.selected;
}

- (GetValidationView *)telephone
{
    if (!_telephone) {
        CGFloat y = self.label.origin.y + self.label.size.height;
        self.telephone = [[GetValidationView alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, kHEIGHT(43))];
        self.telephone.textField.placeholder = @"请输入手机号";
        [self.telephone setTaget:self action:@selector(buttonAction:)];
        self.telephone.textField.delegate = self;
        
        self.telephone.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.telephone.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.telephone.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.telephone.textField setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
        [self.telephone.textField setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
        
        
    }
    return _telephone;
}

- (void)buttonAction:(UIButton *)sender
{
    if (!self.telephone.textField.text.length) {
        [MBProgressHUD createHUD:@"请输入手机号" View:self.view];
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    NSString * title = [NSString stringWithFormat:@"确认手机号码%@",self.telephone.textField.text];
    WPcodeAlert * alert = [[WPcodeAlert alloc]init];
    [window addSubview:alert.view];
    __weak typeof(alert) weakAlert = alert;
    [alert creatAlert:@"提示" andMessage:title aneCanTitle:@"取消" andDefault:@"确认" clickCancel:^(NSString * string) {
        [weakAlert.view removeFromSuperview];
    } clickSure:^(NSString*String) {
        [weakAlert.view removeFromSuperview];
        
        time = 60;
        [self.telephone.button setBackgroundImage:[UIImage imageWithColor:RGB(170, 170, 170) size:CGSizeMake(kHEIGHT(76), kHEIGHT(26))] forState:UIControlStateNormal];
        self.telephone.button.userInteractionEnabled = NO;
        [self.telephone.button setTitle:@"重发(60s)" forState:UIControlStateNormal];
        [self.telephone.button removeTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(timerAction:)
                                                    userInfo:nil
                                                     repeats:YES];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [self getYanZhengNumsuccess:^(NSString *code) {
            [MBProgressHUD hideHUDForView:self.view];
            self.codeStr = code;
        }];
    }];
    
    
   // time = 60;
   // [self.telephone.button setBackgroundImage:[UIImage imageWithColor:RGB(170, 170, 170) size:CGSizeMake(kHEIGHT(76), kHEIGHT(26))] forState:UIControlStateNormal];
   // self.telephone.button.userInteractionEnabled = NO;
   // [self.telephone.button setTitle:@"重发(60s)" forState:UIControlStateNormal];
   // [self.telephone.button removeTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
     //                                             target:self
    //                                            selector:@selector(timerAction:)
   //                                             userInfo:nil
    //                                             repeats:YES];
   // [self getYanZhengNumsuccess:^(NSString *code) {
   //     self.codeStr = code;
   // }];
}

-(void)getYanZhengNumsuccess:(void(^)(NSString*code))successCode
{
//    WPHttpTool
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/verify_code.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"getCode",@"mobile":self.telephone.textField.text};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:urlStr parameters:dic
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //          NSString * str = [NSString stringWithFormat:@"%@",responseObject];
          NSData * data = (NSData*)responseObject;
          NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          if ([string isEqualToString:@"-1"]) {
              [MBProgressHUD createHUD:@"今日验证次数已达上限" View:self.view];
          }
          else
          {
              successCode(string);
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
      }];
    
}
- (void)timerAction:(NSTimer *)timer
{
    time -- ;
    
//    self.telephone.button.enabled = NO;
//    [self.telephone.button setBackgroundColor:RGB(170, 170, 170)];
    [self.telephone.button setTitle:[NSString stringWithFormat:@"重发(%lds)",(long)time] forState:UIControlStateNormal];
    if (time == 0) {
//        self.telephone.button.enabled = YES;
        self.telephone.button.userInteractionEnabled = YES;
        [self.telephone.button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(kHEIGHT(76), kHEIGHT(26))] forState:UIControlStateNormal];
//        self.telephone.button.titleLabel.font = kFONT(14);
        [self.telephone.button setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.telephone.button.titleLabel.font = kFONT(12);
        [self.telephone setTaget:self action:@selector(buttonAction:)];
        [self.timer invalidate];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.telephone.textField && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    if (textField.text.length > 16 && textField == self.nowPass.textField) {
        textField.text = [textField.text substringToIndex:16];
    }
}






@end
