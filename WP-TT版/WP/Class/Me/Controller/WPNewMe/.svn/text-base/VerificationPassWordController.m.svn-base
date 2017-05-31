//
//  VerificationPassWordController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "VerificationPassWordController.h"
#import "InputView.h"
#import "ResetTelephoneController.h"


@interface VerificationPassWordController ()<UITextFieldDelegate>
@property (nonatomic ,strong)InputView *inputView;
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)UIBarButtonItem *editButton;
@property (nonatomic ,strong)UIBarButtonItem *enterButton;
@end

@implementation VerificationPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改绑定手机号";
    [self.view addSubview:self.label];
    [self.view addSubview:self.inputView];
    [self timeToFinishEditingWithSelected:NO];
}

- (UIBarButtonItem *)editButton
{
    if (!_editButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [@"下一步" getSizeWithFont:FUCKFONT(14) Height:44];
        button.frame = CGRectMake(0, 0, size.width, 44);
        
        [button normalTitle:@"下一步" Color:RGB(127, 127, 127) Font:kFONT(14)];
        self.editButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _editButton;
}

- (UIBarButtonItem *)enterButton
{
    if (!_enterButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [@"下一步" getSizeWithFont:FUCKFONT(14) Height:44];
        button.frame = CGRectMake(0, 0, size.width, 44);
        [button normalTitle:@"下一步" Color:RGB(0, 0, 0) Font:kFONT(14)];
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
    if (![self.inputView.textField.text isEqualToString:kShareModel.password]) {
        [MBProgressHUD createHUD:@"密码错误" View:self.view];
        return;
    }
    ResetTelephoneController *resetVC = [[ResetTelephoneController alloc]init];
    resetVC.password = self.inputView.textField.text;
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(16, 9+64, SCREEN_WIDTH, 30)];
        self.label.font = kFONT(12);
        self.label.textColor = RGB(127, 127, 127);
        self.label.text = @"验证账号密码:";
    }
    return _label;
}

- (InputView *)inputView
{
    if (!_inputView) {
        self.inputView = [[InputView alloc]initWithFrame:CGRectMake(0, 30+64+6, SCREEN_WIDTH, kHEIGHT(43)) placeHolder:@"请输入账号密码"];
        self.inputView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.inputView.textField.delegate = self;
        self.inputView.textField.secureTextEntry = YES;
        self.inputView.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.inputView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputView;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
        textField.text = [textField.text substringToIndex:16];
    }
    if (textField.text.length >= 6) {
        [self timeToFinishEditingWithSelected:YES];
    }else{
        [self timeToFinishEditingWithSelected:NO];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputView.textField resignFirstResponder];
}

@end
