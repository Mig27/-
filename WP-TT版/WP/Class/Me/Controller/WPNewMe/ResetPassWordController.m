//
//  ResetPassWordController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ResetPassWordController.h"
#import "NewInputView.h"
#import "ForgetPassWordViewController.h"
#import "LogoutAPI.h"
#import "WPLoginViewController1.h"
@interface ResetPassWordController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIButton *next;
@property (nonatomic ,strong)NewInputView *oldPass;
@property (nonatomic ,strong)NewInputView *nowPass;
@property (nonatomic ,strong)UIBarButtonItem *editButton;
@property (nonatomic ,strong)UIBarButtonItem *enterButton;
@end

@implementation ResetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self.view addSubview:self.oldPass];
    [self.view addSubview:self.nowPass];
    [self.view addSubview:self.next];
    self.navigationItem.rightBarButtonItem = self.editButton;
}

- (UIBarButtonItem *)editButton
{
    if (!_editButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button normalTitle:@"完成" Color:RGB(127, 127, 127) Font:kFONT(14)];
        self.editButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _editButton;
}

- (UIBarButtonItem *)enterButton
{
    if (!_enterButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 44);
        [button normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchDown];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.enterButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _enterButton;
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if (!self.oldPass.textField.text.length) {
        [MBProgressHUD createHUD:@"请输入旧密码" View:self.view];
        return;
    }
    
    if (![self.oldPass.textField.text isEqualToString:kShareModel.password]) {
        [MBProgressHUD createHUD:@"旧密码输入错误" View:self.view];
        return;
    }
    
    if (self.nowPass.textField.text.length == 0) {
        [MBProgressHUD createHUD:@"请输入新密码" View:self.view];
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/login_reg.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"updatePaw",@"username":kShareModel.username,@"oldPassword":self.oldPass.textField.text,@"password":self.nowPass.textField.text};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([json[@"status"] isEqualToString:@"1"]) {
            [self changeSecuretSuccess];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
}
-(void)changeSecuretSuccess
{
    NSArray * object = @[kShareModel.username,kShareModel.password];
    LogoutAPI * login = [[LogoutAPI alloc]init];
    [login requestWithObject:object Completion:^(id response, NSError *error) {
//      [MBProgressHUD hideHUD];
        [MTTUtil loginOut];
        WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
        login.isFromQuit = YES;
        [self.navigationController pushViewController:login animated:NO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
    }];
}
- (NewInputView *)oldPass
{
    if (!_oldPass) {
        self.oldPass = [[NewInputView alloc]initWithFrame:CGRectMake(0, 64+15, SCREEN_WIDTH, kHEIGHT(43))];
        [self.oldPass setTitle:@"旧密码:" placeholder:@"请输入旧密码"];
        self.oldPass.textField.delegate = self;
        self.oldPass.textField.secureTextEntry = YES;
        self.oldPass.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.oldPass.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.oldPass.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldPass;
}

- (NewInputView *)nowPass
{
    if (!_nowPass) {
        self.nowPass = [[NewInputView alloc]initWithFrame:CGRectMake(0, 64+15+kHEIGHT(43)+0.5, SCREEN_WIDTH, kHEIGHT(43))];
        [self.nowPass setTitle:@"新密码:" placeholder:@"请输入新密码"];
        self.nowPass.textField.delegate = self;
        self.nowPass.textField.secureTextEntry = YES;
        self.nowPass.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.nowPass.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.nowPass.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(43), 0, kHEIGHT(43), kHEIGHT(43));
        [button setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"login_xianshimima_pre"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(PassButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.nowPass addSubview:button];
    }
    return _nowPass;
}

- (void)PassButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.nowPass.textField.secureTextEntry = sender.selected;
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text length]>=6 && textField == self.nowPass.textField) {
        self.navigationItem.rightBarButtonItem = self.enterButton;
    }else{
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
    if (textField.text.length > 16) {
        textField.text = [textField.text substringToIndex:16];
    }
}


- (UIButton *)next
{
    if (!_next) {
        self.next = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = self.nowPass.frame.origin.y+self.nowPass.frame.size.height;
        self.next.frame = CGRectMake(0, width+20, SCREEN_WIDTH, kHEIGHT(43));
        self.next.backgroundColor = [UIColor whiteColor];
        [self.next addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, kHEIGHT(14), SCREEN_WIDTH, kHEIGHT(15))];
        label.text = @"忘记密码";
        [self.next addSubview:label];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-22, kHEIGHT(14), 6, kHEIGHT(15))];
        image.image = [UIImage imageNamed:@"jinru"];
        [self.next addSubview:image];
    }
    return _next;
}
#pragma mark 点击忘记密码
- (void)buttonAction:(UIButton *)sender
{
    ForgetPassWordViewController *forgetVC = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.nowPass.textField resignFirstResponder];
    [self.oldPass.textField resignFirstResponder];
}

@end
