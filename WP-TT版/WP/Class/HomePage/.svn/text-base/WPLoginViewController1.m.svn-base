//
//  WPLoginViewController1.m
//  WP
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPLoginViewController1.h"
#import "WPTextField.h"
#import "WPRegistViewController.h"
#import "WPLoginViewController2.h"
#import "WPMainController.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "LoginModel.h"
#import "MBProgressHUD+MJ.h"
#import "MTTRootViewController.h"
#import "ForgetPassWordViewController.h"
#import "SessionModule.h"
#import "DDClientState.h"
#import "WPNavigationController.h"
@interface WPLoginViewController1 () <UITextFieldDelegate>
{
    UITextField* phoneTextField;
    UITextField* passWordTextfield;
}

@end

@implementation WPLoginViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用滑动返回手势
    if (self.isFromQuit) {
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
        [self.view addGestureRecognizer:pan];
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.navigationItem.title=@"登录";
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"注册" forState:UIControlStateNormal];
//    button.titleLabel.textColor = [UIColor greenColor];
    [button setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = kFONT(14);
//    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    NSString * isFirst = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOrNot"]];
    if ([isFirst isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    }
    
    [self createView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIsFrom) name:@"changIsFrom" object:nil];
    // Do any additional setup after loading the view.
}
-(void)changeIsFrom
{
    self.isFromQuit = YES;
    passWordTextfield.text = @"";
}
//#pragma mark 点击注册
//-(void)btnClick1:(UIButton*)sender
//{
// 
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view resignFirstResponder];
}

-(void)createView
{
    UIView* whView=[[UIView alloc] initWithFrame:CGRectMake(0, 116, 40, 2)];
    whView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whView];
    
    UIView* view1=[[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, kHEIGHT(43))];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    
    phoneTextField=[[WPTextField alloc] initWithFrame:CGRectMake(2*kHEIGHT(10)+15, 0, self.view.frame.size.width-2*kHEIGHT(10)-15, kHEIGHT(43))];
    phoneTextField.font=kFONT(15);
    phoneTextField.delegate = self;
    [phoneTextField setPlaceholder:@"请输入你的手机号码"];
    [phoneTextField setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [phoneTextField setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
    
    UIImageView* iconView1=[[UIImageView alloc] init];
    iconView1.frame=CGRectMake(kHEIGHT(10),(1+kHEIGHT(43)/2-11), 15, 22);
    phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    iconView1.contentMode=UIViewContentModeCenter;
    iconView1.image=[UIImage imageNamed:@"login_shouji"];//login_shouji@2x//手机号账号
    [view1 addSubview:iconView1];
    phoneTextField.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:phoneTextField];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-1, 2*kHEIGHT(10)+15, 2)];
    line.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:line];
    
    
    
    UIView* view2=[[UIView alloc] initWithFrame:CGRectMake(0, 79+kHEIGHT(43)+1, self.view.frame.size.width, kHEIGHT(43))];
    view2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view2];
    passWordTextfield=[[WPTextField alloc] initWithFrame:CGRectMake(2*kHEIGHT(10)+15, 0, self.view.frame.size.width-2*kHEIGHT(10)-15-70, kHEIGHT(43))];
    [view2 addSubview:passWordTextfield];
    passWordTextfield.secureTextEntry=YES;
    passWordTextfield.font=kFONT(15);
    passWordTextfield.delegate = self;
    [passWordTextfield setPlaceholder:@"请输入你的密码(6-16位)"];
    [passWordTextfield setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [passWordTextfield setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
    UIImageView* iconView=[[UIImageView alloc] init];
    iconView.frame=CGRectMake(kHEIGHT(10),(kHEIGHT(43)+1)/2-9, 15, 18);
    passWordTextfield.leftViewMode=UITextFieldViewModeAlways;
    iconView.contentMode=UIViewContentModeCenter;
    iconView.image=[UIImage imageNamed:@"login_mima"];//login_mima@2x//密码
    [view2 addSubview:iconView];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    passWordTextfield.backgroundColor=[UIColor whiteColor];
    
    
    //眼睛
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(SCREEN_WIDTH-70, 0 , 70, kHEIGHT(43));
    [btn setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
    btn.selected = NO;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10))];
    passWordTextfield.secureTextEntry=YES;
    [view2 addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    phoneTextField.text = @"15956975045";
//    passWordTextfield.text = @"123456";
    
//    phoneTextField.text = @"13888888888";
//    passWordTextfield.text = @"123456";
    if (self.phoneStr.length) {
        phoneTextField.text = self.phoneStr;
        passWordTextfield.text = @"";
    }
    
    NSString * phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginNum"];
    if (phoneStr.length && ![phoneStr isEqualToString:@"(null)"])
    {
        phoneTextField.text = phoneStr;
        passWordTextfield.text= @"";
    }
    
    
    
//    phoneTextField.text = @"18388888888";
//    passWordTextfield.text = @"123456789";

//    phoneTextField.text = @"14888888888";
//    passWordTextfield.text = @"123456";

//    phoneTextField.text = @"18612345678";
//    passWordTextfield.text = @"123456";

//    phoneTextField.text = @"18256989131";
//    passWordTextfield.text = @"123456";
    
//    phoneTextField.text = @"15556966763";
//    passWordTextfield.text = @"123456";

    
//    phoneTextField.text = @"18355156769";
//    passWordTextfield.text = @"123456";

//    phoneTextField.text = @"13777777777";
//    passWordTextfield.text = @"123456";
    
//    phoneTextField.text = @"18256989131";
//    passWordTextfield.text = @"123456";
    
//    phoneTextField.text = @"13999999999";
//    passWordTextfield.text = @"123456";
//

    //登录按钮
    UIButton* loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(kHEIGHT(10), 79+2*kHEIGHT(43)+22, self.view.frame.size.width-2*kHEIGHT(10), kHEIGHT(38));
    loginBtn.layer.cornerRadius=5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    loginBtn.titleLabel.font = kFONT(15);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"register2"] forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"register1"] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundColor:RGB(0, 172, 255)];
    
    loginBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(loginBtnClickDown:) forControlEvents:UIControlEventTouchDown];
    [loginBtn addTarget:self action:@selector(loginSwip:) forControlEvents:UIControlEventTouchDragOutside];
    
//    UIButton* leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame=CGRectMake(10, 74+44+10+44+36, 80, 30);
//    leftBtn.titleLabel.text=@"注册新账号";
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:leftBtn.titleLabel.text];
//    NSRange strRange1 = {0,[str1 length]};
//    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
//    [leftBtn setAttributedTitle:str1 forState:UIControlStateNormal];
//    leftBtn.titleLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
//    leftBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
//    leftBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    [leftBtn addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:leftBtn];
    
    UIButton* rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(self.view.frame.size.width-80, 79+2*kHEIGHT(43)+22+kHEIGHT(38)+kHEIGHT(10), 70, 18);
    rightBtn.titleLabel.text=@"忘记密码?";
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:rightBtn.titleLabel.text];
    NSRange strRange2 = {0,[str2 length]};
    [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange2];
    [rightBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    rightBtn.titleLabel.textColor = RGB(127, 127, 127);
    rightBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    rightBtn.titleLabel.font=kFONT(12);
    [rightBtn addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(btnClickDown:) forControlEvents:UIControlEventTouchDown];
    [rightBtn addTarget:self action:@selector(btnclickDreag:) forControlEvents:UIControlEventTouchDragOutside];
//    IPADDRESS
    
    [self.view addSubview:rightBtn];
    
    
//   self.textfiled1 = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 74+44+10+44+36+80, 200, 30)];
//    self.textfiled1.placeholder = @"输入本地服务器";
//    [self.view addSubview:self.textfiled1];
//    
//    
//    
//    self.textfiled2 = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 74+44+10+44+36+80+60, 200, 30)];
//    self.textfiled2.placeholder = @"输入聊天服务器";
//    [self.view addSubview:self.textfiled2];
//    
//    
//    
//    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    finishBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2, 74+44+10+44+36+80+60+60, 200, 40);
//    [finishBtn setBackgroundColor:[UIColor blueColor]];
//    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [finishBtn addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:finishBtn];
    
    
}
-(void)btnClickDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
-(void)btnclickDreag:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(235, 235, 235)];
}
-(void)btnClick:(UIButton*)btn
{
    NSLog(@"切换");
    btn.selected = !btn.selected;
    if (btn.selected==YES) {
        passWordTextfield.secureTextEntry=YES;
        [btn setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
    }else
    {
        passWordTextfield.secureTextEntry=NO;
        [btn setImage:[UIImage imageNamed:@"login_xianshimima_pre"] forState:UIControlStateNormal];
    }
}
-(void)loginBtnClickDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(0, 146, 217)];
}
-(void)loginSwip:(UIButton*)sendr
{
    [sendr setBackgroundColor:RGB(0, 172, 255)];
}
-(void)clickFinish
{
    [[NSUserDefaults standardUserDefaults] setObject:self.textfiled1.text forKey:@"bendi"];
    [[NSUserDefaults standardUserDefaults] setObject:self.textfiled2.text forKey:@"xiaoxi"];
}
#pragma mark - 取消界面编辑状态
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.view endEditing:YES];
}
-(void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
}
#pragma mark - Actions
-(void)loginClick:(UIButton*)sender
{
    if (!phoneTextField.text.length) {
        [MBProgressHUD createHUD:@"请输入手机号" View:self.view];
        return;
    }
    
    if (!passWordTextfield.text.length) {
        [MBProgressHUD createHUD:@"请输入密码" View:self.view];
        return;
    }
    
    //登陆的不是同一个账号时需要清除缓存
    if (![phoneTextField.text isEqualToString:kShareModel.username]) {
        [self clearFile];
    }
    
    
    
    //[user setObject:longitude forKey:@"longitude"];
//    [user setObject:latitude forKey:@"latitude"];
    
    NSUserDefaults * standDefault = [NSUserDefaults standardUserDefaults];
    NSString * latitude = [standDefault objectForKey:@"latitude"];
    NSString * longitude = [standDefault objectForKey:@"longitude"];
    
    [sender setBackgroundColor:RGB(0, 172, 255)];
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
    NSDictionary *dic = @{@"action":@"login",
                          @"username":phoneTextField.text,
                          @"password":passWordTextfield.text,
                          @"longitude":longitude,
                          @"latitude":latitude};

    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
       
        LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (loginModel.status) {
            
            NSString * isFirst = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOrNot"]];
            if (![isFirst isEqualToString:@"1"]) {
               [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstOrNot"];
            }
            WPShareModel* model=[WPShareModel sharedModel];
            model.dic=loginModel.list[0];
            model.userId = model.dic[@"userid"];
            model.nick_name = model.dic[@"nick_name"];
    
            model.username = phoneTextField.text;
            model.password = passWordTextfield.text;
            kShareModel.nick_name = loginModel.list[0][@"nick_name"];
            [USER_DEFAULT setObject:json forKey:@"LOGINUSERINFO"];
            [USER_DEFAULT setObject:passWordTextfield.text forKey:@"LOGINPASSWORD"];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] setObject:phoneTextField.text forKey:@"loginNum"];
            [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
            
            if (self.isFromQuit)
            {//退出后直接登陆
              [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAnother" object:nil];
            }
            
            [self performSelector:@selector(delay) withObject:self afterDelay:0.5];
            
        }else{
            [MBProgressHUD alertView:@"账号或密码错误" Message:loginModel.info];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD alertView:@"登录失败" Message:error.localizedDescription];
    }];

}

-(void)backToFromViewController:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneTextField)
    {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger length = textField.text.length + string.length - range.length;
        return length <= 11;
    }
    else
    {
        
        
        if (range.location > 0 && range.length == 1 && string.length == 0)
        {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
            return NO;
        }
    
        if (range.location >0 &&range.length == 0 && string.length) {
            textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
           
            return NO;
        }
        
        
        
        
        return YES;
    }
}
-(void)delay
{

//    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:@"dismissRoot"];
//    if (string.intValue)
//    {
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dismissRoot"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLoginSuccess" object:nil];
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
//    }
//    else
//    {
//        MTTRootViewController* vc=[[MTTRootViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
    
     NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:@"dismissRoot"];
    if (string.intValue)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dismissRoot"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLoginSuccess" object:nil];
    }
    MTTRootViewController* vc=[[MTTRootViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)btnClick1
{
    WPRegistViewController* vc=[[WPRegistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)btnClick2:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(235, 235, 235)];
    NSLog(@"注册遇到问题,跳转到找回密码的界面");
    ForgetPassWordViewController * forget = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFromKick) {
        [[ [UIAlertView alloc]initWithTitle:@"提示" message:@"该账号已在其他地方登录,请检查账号是否安全!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        self.isFromKick = NO;
    }
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBarHidden = NO;
//    self.title = @"登录";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
