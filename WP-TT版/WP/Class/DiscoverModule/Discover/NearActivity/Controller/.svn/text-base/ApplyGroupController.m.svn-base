//
//  ApplyGroupController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ApplyGroupController.h"
#import "UIPlaceHolderTextView.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "MBProgressHUD+MJ.h"

@interface ApplyGroupController () <UITextViewDelegate>

@property (nonatomic,strong) UIPlaceHolderTextView *textView;
@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation ApplyGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(235, 235, 235);
    [self initNav];
    [self createUI];
//    NSLog(@"%@",kShareModel.nick_name);
}

- (void)initNav
{
    self.title = self.isFromGroupApply?@"拒绝申请":@"申请验证";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark - 点击发送按钮
- (void)rightBtnClick
{
    if (self.isFromGroupApply)
    {//拒绝
        [MBProgressHUD showMessage:@"" toView:self.view];
        NSString *b_user_id = self.dictionary[@"b_user_id"];
        NSString * action = [NSString string];
        if (![b_user_id isEqualToString:kShareModel.userId]) {
            action = @"examineJoin";
        }
        else
        {
          action= @"examineJoin2";
        }
        
        NSDictionary * dictionary = @{@"action":action,//@"examineJoin"
                                      @"status":@"2",
                                      @"user_id":kShareModel.userId,
                                      @"username":kShareModel.username,
                                      @"password":kShareModel.password,
                                      @"denial":self.textView.text,
                                      @"group_id":self.dictionary[@"group_id"],
                                      @"join_nick_name":self.dictionary[@"b_user_name"],
                                      @"join_user_id":self.dictionary[@"b_user_id"],
                                      @"id":self.dictionary[@"a_user_id"]
                                      };
        NSString * urlStr = [NSString stringWithFormat:@"%@/android/Group_member.ashx",IPADDRESS];
        [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if (self.rejectPass) {
                self.rejectPass();
                [self.navigationController popViewControllerAnimated:YES];
            }
          } failure:^(NSError *error) {
              [MBProgressHUD hideHUDForView:self.view];
              [MBProgressHUD createHUD:error.description View:self.view];
        }];
    }
    else
    {
        if (_textView.text.length == 0) {
            [MBProgressHUD createHUD:@"验证信息不能为空" View:self.view];
            return;
        }
        WPShareModel *model = [WPShareModel sharedModel];
        NSMutableDictionary *userInfo = model.dic;
        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
        NSDictionary *params = @{@"action" : @"applicationJoin",
                                 @"Group_id" : self.group_id,
                                 @"user_id" : userInfo[@"userid"],
                                 @"username" : model.username,
                                 @"password" : model.password,
                                 @"post_remark" : self.textView.text};
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([json[@"status"] integerValue] == 0) {
                [MBProgressHUD createHUD:@"发送成功" View:self.view];
                [self performSelector:@selector(delayTime) withObject:nil afterDelay:0.7];
//                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD createHUD:@"发送失败" View:self.view];
            }
        } failure:^(NSError *error) {
            
        }];
    }
//    if (_textView.text.length == 0) {
//        [MBProgressHUD createHUD:@"验证信息不能为空" View:self.view];
//        return;
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
//    NSDictionary *params = @{@"action" : @"applicationJoin",
//                             @"Group_id" : self.group_id,
//                             @"user_id" : userInfo[@"userid"],
//                             @"username" : model.username,
//                             @"password" : model.password,
//                             @"post_remark" : self.textView.text};
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        if ([json[@"status"] integerValue] == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
}
-(void)delayTime
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI
{
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.isFromGroupApply?15:kHEIGHT(32))];
    tipView.backgroundColor = BackGroundColor;
    [self.view addSubview:tipView];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 16, kHEIGHT(32))];
    tipLabel.text = self.isFromGroupApply?@"":@"发送验证信息";
    tipLabel.textColor = RGB(127, 127, 127);
    tipLabel.font = kFONT(12);
    [tipView addSubview:tipLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, tipView.bottom, SCREEN_WIDTH, kHEIGHT(78))];
    backView.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(kHEIGHT(10), 10, SCREEN_WIDTH - 2*kHEIGHT(10), kHEIGHT(78) - 22)];
    _textView.font = kFONT(15);
    _textView.placeholder =self.isFromGroupApply? @"请填写拒绝理由": @"填写申请理由";
    _textView.delegate = self;
//    [_textView becomeFirstResponder];
    [backView addSubview:_textView];
    
    NSString *placeName = [NSString string];
    if (kShareModel.nick_name.length && ![kShareModel.nick_name isEqualToString:@"(null)"]) {
        placeName = [NSString stringWithFormat:@"我是微聘科技%@",kShareModel.nick_name];
    }
    else
    {
        placeName = [NSString stringWithFormat:@"我是微聘科技%@",kShareModel.username];
    }
    
    _textView.text = self.isFromGroupApply?@"":placeName;
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, kHEIGHT(78)- 12 - kHEIGHT(10), 40, 12)];
    _numberLabel.text = [NSString stringWithFormat:@"%lu",30 - placeName.length];
    _numberLabel.textColor = RGB(127, 127, 127);
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = kFONT(15);
    [backView addSubview:_numberLabel];
    
    [self.view addSubview:backView];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if(str.length>30)
    {
        textView.text = [str substringToIndex:30];
        return NO;
    }
    else
    {
        return YES;
    }  

}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 30)
    {
        textView.text = [textView.text substringToIndex:30];
    }
    NSString *text = textView.text;
    _numberLabel.text = [NSString stringWithFormat:@"%lu",30 - text.length];
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
