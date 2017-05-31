//
//  WPLoginViewController4.m
//  WP
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPLoginViewController4.h"
#import "WPTextField.h"
#import "WPMainController.h"
#import "WPHttpTool.h"
#import "LoginModel.h"
#import "WPShareModel.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+StringType.h"
#import "MTTRootViewController.h"
@interface WPLoginViewController4 ()<UIAlertViewDelegate>
{
    UITextField* passWordTextField1;
    UITextField* passWordTextField2;
    UIButton* loginBtn;
}

@end

@implementation WPLoginViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.navigationItem.title=@"修改密码";
    
    passWordTextField1=[[WPTextField alloc] initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 43)];
    [self.view addSubview:passWordTextField1];
    passWordTextField1.font=[UIFont systemFontOfSize:15];
    [passWordTextField1 setPlaceholder:@"请输入密码(6-16位)"];
    UIImageView* iconView1=[[UIImageView alloc] init];
    iconView1.frame=CGRectMake(10,14, 14, 16);
    passWordTextField1.leftViewMode=UITextFieldViewModeAlways;
    iconView1.contentMode=UIViewContentModeCenter;
    iconView1.image=[UIImage imageNamed:@"密码"];
    passWordTextField1.leftView=iconView1;
    passWordTextField1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passWordTextField1];
    
    passWordTextField2=[[WPTextField alloc] initWithFrame:CGRectMake(0, 74+44, self.view.frame.size.width, 43)];
    [self.view addSubview:passWordTextField2];
    passWordTextField2.font=[UIFont systemFontOfSize:15];
    [passWordTextField2 setPlaceholder:@"请输入密码(6-16位)"];
    UIImageView* iconView2=[[UIImageView alloc] init];
    iconView2.frame=CGRectMake(10,14, 14, 19);
    passWordTextField2.leftViewMode=UITextFieldViewModeAlways;
    iconView2.contentMode=UIViewContentModeCenter;
    iconView2.image=[UIImage imageNamed:@"确认密码"];
    passWordTextField2.leftView=iconView2;
    passWordTextField2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passWordTextField2];
    
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(10, 118+10+43, self.view.frame.size.width-20, 36);
    loginBtn.layer.cornerRadius=5;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    loginBtn.backgroundColor=[UIColor blueColor];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginClock) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void)loginClock
{
    if([passWordTextField2.text isEqualToString:passWordTextField1.text]&&([passWordTextField1.text isType:StringTypePassword])){
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
        NSDictionary *dic = @{@"action":@"updatePwd",
                              @"username":self.phoneNumberStr,
                              @"password":passWordTextField1.text};
        
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];

            if (loginModel.status) {
                WPShareModel* model=[WPShareModel sharedModel];
                model.dic=loginModel.list[0];
                model.username = self.phoneNumberStr;
                model.password = passWordTextField1.text;
                
                [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
                [self performSelector:@selector(delay) withObject:self afterDelay:0.5];
                
            }else{
                [MBProgressHUD alertView:@"登录失败" Message:loginModel.info];
            }
        } failure:^(NSError *error) {
            
            [MBProgressHUD alertView:@"登录失败" Message:error.localizedDescription];
        }];
    }else{
        [MBProgressHUD alertView:nil Message:@"密码格式不正确"];
    }
}

-(void)delay
{
    MTTRootViewController * root = [[MTTRootViewController alloc]init];
    [self presentViewController:root animated:YES completion:nil];
    
//    WPMainController* vc=[[WPMainController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
