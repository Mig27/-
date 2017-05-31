//
//  WPNickNameEditViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNickNameEditViewController.h"
#import "RKAlertView.h"

@interface WPNickNameEditViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation WPNickNameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self createUI];
}

- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"设置群昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"group_id" : self.model.group_id,
                             @"userID" : kShareModel.userId,
                             @"action" : @"updatemyname",
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"remark_name" : _textField.text};
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@----%@",json,json[@"info"]);
        if ([json[@"status"] integerValue] == 0) {
            if (self.modifyNickSuccess) {
                self.modifyNickSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)backToFromViewController:(UIButton *)sender
{
    [_textField resignFirstResponder];
    if ([_textField.text isEqualToString:self.nickName]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [RKAlertView showAlertWithTitle:@"提示" message:@"确定退出编辑？" cancelTitle:@"取消" confirmTitle:@"确定" confrimBlock:^(UIAlertView *alertView) {
            [self.navigationController popViewControllerAnimated:YES];
        } cancelBlock:^{
            
        }];
    }
}

- (void)createUI
{
    CGSize normalSize = [@"群名称 :" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    UIView *item1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + 64, SCREEN_WIDTH, kHEIGHT(43))];
    item1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:item1];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH - 2*kHEIGHT(10), kHEIGHT(43))];
    _textField.centerY = kHEIGHT(43)/2;
    _textField.delegate = self;
    _textField.font = kFONT(15);
    UIColor *color = RGB(170, 170, 170);
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写我的群昵称" attributes:@{NSForegroundColorAttributeName: color}];
    _textField.text = self.nickName;
    _textField.tintColor = color;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [item1 addSubview:_textField];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 100, item1.bottom + kHEIGHT(10), 100, normalSize.height)];
    _tipLabel.textColor = RGB(127, 127, 127);
    _tipLabel.font = kFONT(12);
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.text = [NSString stringWithFormat:@"%ld/20",self.nickName.length];
    [self.view addSubview:_tipLabel];
    
//    [_textField becomeFirstResponder];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if(str.length>20)
    {
        textField.text = [str substringToIndex:20];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)textFieldDidChange:(UITextField *)theTextField{
    if (theTextField.text.length>20) {
        theTextField.text = [theTextField.text substringToIndex:20];
    }
    _tipLabel.text = [NSString stringWithFormat:@"%ld/20",theTextField.text.length];
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
