//
//  WPLoginViewController2.m
//  WP
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPLoginViewController2.h"
#import "WPTextField.h"
#import "ZCControl.h"
#import "NSString+StringType.h"
#import "WPLoginViewController3.h"

@interface WPLoginViewController2 ()<UIAlertViewDelegate>
{
    UITextField* phoneTextField;
}

@end

@implementation WPLoginViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.navigationItem.title=@"找回密码";
    
    phoneTextField=[[WPTextField alloc] initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 43)];
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.font=[UIFont systemFontOfSize:15];
    [phoneTextField setPlaceholder:@"请输入你的手机号码"];
    UIImageView* iconView1=[[UIImageView alloc] init];
    iconView1.frame=CGRectMake(10,14, 14, 19);
    phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    iconView1.contentMode=UIViewContentModeCenter;
    iconView1.image=[UIImage imageNamed:@"手机号账号"];
    phoneTextField.leftView=iconView1;
    phoneTextField.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:phoneTextField];
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(self.view.frame.size.width-100, 64+53, 95, 30);
    btn.titleLabel.text=@"手机号不可用？";
    btn.titleLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:btn.titleLabel.text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
    btn.titleLabel.textAlignment=NSTextAlignmentRight;
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //设置右按钮
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(nextClick) Title:@"下一步"];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    // Do any additional setup after loading the view.
}

-(void)nextClick
{
    if ([phoneTextField.text isType:StringTypePhone]) {
        NSString* str = [NSString stringWithFormat:@"(86+)%@",phoneTextField.text];;
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"号码格式错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [phoneTextField resignFirstResponder];
        WPLoginViewController3* vc=[[WPLoginViewController3 alloc] init];
        vc.phoneNumberStr = phoneTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else
        return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)btnClick1
{
    NSLog(@"**********手机号不可用***********");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
