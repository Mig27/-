
//
//  WPSetAccountController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSetAccountController.h"
#import "SetAccountView.h"
//#import "PersonalView.h"
#import "WPIDManager.h"
#import "WPInfoManager.h"

@interface WPSetAccountController ()<SetAccountViewDelgate,UIAlertViewDelegate,WPInfoManagerDelegate>
@property (nonatomic ,strong)SetAccountView *accountView;
@property (nonatomic ,strong)UIBarButtonItem *editButton;
@property (nonatomic ,strong)UIBarButtonItem *enterButton;
@end

@implementation WPSetAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"设置微聘号";
    [self.view addSubview:self.accountView];
    [self addRightBarButtonItem];
//    [self request];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 50, 44);
//    [button normalTitle:@"完成" Color:RGB(127, 127, 127) Font:kFONT(14)];
//    [button addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)clickFinish
{
  
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
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
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
    NSString *string = [NSString stringWithFormat:@"确认设置微聘号为%@吗?\n确定后将不能再修改",self.accountView.textField.text];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        WS(ws);
        [[WPIDManager sharedManager] requestWPIDWithWp_id:self.accountView.textField.text return:^(id json) {
            if ([json [@"status"] integerValue]) {
                [MBProgressHUD createHUD:json[@"info"] View:self.view];
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setWeiPinNumberSuccessed" object:nil];
                if (self.setSucceed) {
                    self.setSucceed(self.accountView.textField.text);
                }
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (SetAccountView *)accountView
{
    if (!_accountView) {
        self.accountView = [[SetAccountView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200)];
        self.accountView.delegate = self;
    }
    return _accountView;
}



@end
