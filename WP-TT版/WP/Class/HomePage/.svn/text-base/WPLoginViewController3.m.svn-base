//
//  WPLoginViewController3.m
//  WP
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPLoginViewController3.h"
#import "ZCControl.h"
#import "WPTextField.h"
#import "WPLoginViewController4.h"

@interface WPLoginViewController3 ()
{
    UILabel* label;
    UILabel* phoneLabel;
    NSString* phoneString;
    NSString* str;
    UITextField* verificationTextfield;
}

@end

@implementation WPLoginViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //设置右按钮
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(nextClick) Title:@"下一步"];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.title=@"输入验证码";
    label=[[UILabel alloc] initWithFrame:CGRectMake(10, 64, 150, 32)];
    label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.text=@"验证码短信已发送到:";
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
    phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(125, 64, self.view.frame.size.width-125, 32)];
    phoneLabel.textColor=[UIColor colorWithRed:10/255.0 green:110/255.0 blue:210/255.0 alpha:1];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=[UIFont systemFontOfSize:12];
    phoneLabel.text=self.phoneNumberStr;
    [self.view addSubview:phoneLabel];
    
    verificationTextfield=[[WPTextField alloc] initWithFrame:CGRectMake(0, 96, self.view.frame.size.width, 43)];
    verificationTextfield.font=[UIFont systemFontOfSize:15];
    [verificationTextfield setPlaceholder:@"请输入验证码"];
    UIImageView* iconView=[[UIImageView alloc] init];
    iconView.frame=CGRectMake(10,10, 24, 24);
    verificationTextfield.leftViewMode=UITextFieldViewModeAlways;
    iconView.contentMode=UIViewContentModeCenter;
    iconView.image=[UIImage imageNamed:@"验证码"];
    verificationTextfield.leftView=iconView;
    verificationTextfield.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:verificationTextfield];
    
    // Do any additional setup after loading the view.
}
-(void)nextClick
{
    WPLoginViewController4* vc=[[WPLoginViewController4 alloc] init];
    vc.phoneNumberStr = self.phoneNumberStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
