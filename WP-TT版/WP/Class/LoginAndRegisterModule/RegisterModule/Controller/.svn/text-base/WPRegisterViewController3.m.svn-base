//
//  WPRegisterViewController3.m
//  WP
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRegisterViewController3.h"
#import "ZCControl.h"
#import "WPRegisterViewController2.h"
#import "WPTextField.h"
#import "WPRegisterViewController4.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "WPMainController.h"
#import "WPLoginViewController1.h"
#import "LoginModel.h"
#import "MBProgressHUD+MJ.h"
#import "WPRegisterViewController4.h"
#import "WPcodeAlert.h"
#define NUMBERS @"0123456789"

@interface WPRegisterViewController3 ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField* phoneTextField;
    UITextField* passWordTextfield;
    NSString* phoneStr;
    NSString* messageStr;
//    UIButton* btn;//眼睛
    BOOL btnStatus;
    
    //post请求
    NSString* photoPathStr;
    NSString* nameString;
    NSString* sexString;
    NSString* birthString;
    NSString* industryString;
    NSString* positionString;
    NSString* addressString;
    NSString* verificationString;

}
@end

@implementation WPRegisterViewController3


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"手机验证";

    //设置右按钮
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:NULLNAME Target:self Action:@selector(nextClick) Title:@"下一步"];
    rightButton.titleLabel.font = kFONT(14);
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
    WPShareModel* model=[WPShareModel sharedModel];
    nameString=model.usernameStr;
    sexString=model.sexStr;
    birthString=model.birthdayStr;
    industryString=[NSString stringWithFormat:@"%@/%@",model.industryModel.industryID,model.industryModel.industryName];
    positionString=[NSString stringWithFormat:@"%@/%@",model.positionModel.industryID,model.positionModel.industryName];
    addressString=[NSString stringWithFormat:@"%@/%@",model.addressModel.industryID,model.addressModel.industryName];
    photoPathStr=model.photoStr;

    [self createView];

}
-(void)backToFromViewController:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextClick
{
    [self touchesBegan:nil withEvent:nil];
    if (phoneTextField.text.length == 0) {
        [MBProgressHUD createHUD:@"请输入手机号" View:self.view];
        return;
    }
    
    if (passWordTextfield.text.length == 0) {
        [MBProgressHUD createHUD:@"请输入密码" View:self.view];
        return;
    }
    
    
    
    
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
    NSDictionary *dic = @{@"action":@"Exists",
                          @"username":phoneTextField.text,
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        NSString * staues = json[@"status"];
        if ([staues isEqualToString:@"1"]) {
            messageStr=[NSString stringWithFormat:@"确认手机号码%@",phoneTextField.text];
            
            if (phoneTextField.text.length==11&&passWordTextfield.text.length>=6&&passWordTextfield.text.length<=16) {
                
                WPcodeAlert * code = [[WPcodeAlert alloc]init];
                UIWindow * windon = [[UIApplication sharedApplication] keyWindow];
                [windon addSubview:code.view];
                
                [code creatAlert:@"提示" andMessage:messageStr aneCanTitle:@"取消" andDefault:@"确认"];
                __weak typeof(code) weakSelf = code;
                code.clickCancle = ^(){
                    NSLog(@"点击来取笑");
                    [weakSelf.view removeFromSuperview];
                };
                code.clickDefault = ^(){
                    [weakSelf.view removeFromSuperview];
                    WPRegisterViewController4 * resiget = [[WPRegisterViewController4 alloc]init];
                    resiget.isFromRegist = YES;
                    resiget.photoText = phoneTextField.text;
                    resiget.passWordText = passWordTextfield.text;
                    resiget.headImage = self.headImage;
                    [self.navigationController pushViewController:resiget animated:YES];
                };
            }else{
                
                if (phoneTextField.text.length != 11) {
                    [MBProgressHUD alertView:@"账号格式不正确" Message:messageStr];
                }
                else
                {
                    [MBProgressHUD alertView:@"密码格式不正确" Message:messageStr];
                }
            }
        }
        else
        {
            WPcodeAlert* alert = [[WPcodeAlert alloc]init];
            UIWindow * windo = [UIApplication sharedApplication].keyWindow;
            [windo addSubview:alert.view];
            [alert creatBottomAlert:@"提示" andMessage:@"手机号已注册,确认使用该手机号登录?" aneCanTitle:@"取消" andDefault:@"确认"];
            __weak typeof(alert) weakSelf = alert;
            alert.clickCancle= ^(){
                
                [weakSelf.view removeFromSuperview];
            };
            alert.clickDefault = ^(){
             [weakSelf.view removeFromSuperview];
                WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
                [self.navigationController pushViewController:login animated:YES];
//                NSArray * viewArray = self.navigationController.viewControllers;
//                [self.navigationController popToViewController:viewArray[1] animated:YES];
            };
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
    
//    messageStr=[NSString stringWithFormat:@"确认手机号码%@",phoneTextField.text];
//    
//    if (phoneTextField.text.length==11&&passWordTextfield.text.length>=6&&passWordTextfield.text.length<=16) {
//        WPcodeAlert * code = [[WPcodeAlert alloc]init];
//        UIWindow * windon = [[UIApplication sharedApplication] keyWindow];
//        [windon addSubview:code.view];
//        
//        [code creatAlert:@"提示" andMessage:messageStr aneCanTitle:@"取消" andDefault:@"确认"];
//        __weak typeof(code) weakSelf = code;
//        code.clickCancle = ^(){
//            NSLog(@"点击来取笑");
//            [weakSelf.view removeFromSuperview];
//        };
//        code.clickDefault = ^(){
//            NSLog(@"点击来确定");
//            [weakSelf.view removeFromSuperview];
//            WPRegisterViewController4 * resiget = [[WPRegisterViewController4 alloc]init];
//            resiget.isFromRegist = YES;
//            resiget.photoText = phoneTextField.text;
//            resiget.passWordText = passWordTextfield.text;
//            resiget.headImage = self.headImage;
//            [self.navigationController pushViewController:resiget animated:YES];
//        };
//        
//    }else{
//        
//        if (phoneTextField.text.length != 11) {
//          [MBProgressHUD alertView:@"账号格式不正确" Message:messageStr];
//        }
//        else
//        {
//         [MBProgressHUD alertView:@"密码格式不正确" Message:messageStr];
//        }
//        
//        
//    }
}
-(void)getYanZhengNum:(void(^)(NSString * code))success failed:(void(^)(NSError *error))failed
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/verify_code.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"getCode",@"mobile":phoneTextField.text};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:urlStr parameters:dic
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //          NSString * str = [NSString stringWithFormat:@"%@",responseObject];
          NSData * data = (NSData*)responseObject;
          NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          success(string);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failed(error);
      }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        WPRegisterViewController4 * resiget = [[WPRegisterViewController4 alloc]init];
        resiget.isFromRegist = YES;
        resiget.photoText = phoneTextField.text;
        resiget.passWordText = passWordTextfield.text;
        resiget.headImage = self.headImage;
        [self.navigationController pushViewController:resiget animated:YES];
        
//        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
//        NSDictionary *dic = @{@"action":@"Reg",
//                              @"username":nameString,
//                              @"address":@"",
//                              @"PhotoAddress":@"",
//                              @"sex":sexString,
//                              @"birthday":birthString,
//                              @"industry":industryString,
//                              @"profession":positionString,
//                              @"workAddress":addressString,
//                              @"School":@"",
//                              @"password":passWordTextfield.text,
//                              @"telphone":phoneTextField.text,
//                              @"graduateTime":@"",
//                              @"regMAC":@"100"
//                              };
//        
//        WPFormData *formData = [[WPFormData alloc]init];
//        formData.data = UIImageJPEGRepresentation(_headImage, 0.5);
//        formData.name = @"uploadFile";
//        formData.filename = @"headImage.png";
//        formData.mimeType = @"image/png";
//        NSArray *arr = @[formData];
//        
//        [WPHttpTool postWithURL:urlStr params:dic formDataArray:arr success:^(id json) {
//            LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];
//            if (loginModel.status) {
//                WPShareModel *model = [WPShareModel sharedModel];
//                model.dic=loginModel.list[0];
//                model.username = phoneTextField.text;
//                model.password = passWordTextfield.text;
//                WPRegisterViewController4 *vc = [[WPRegisterViewController4 alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [MBProgressHUD alertView:@"注册失败" Message:loginModel.info];
//                
//            }
//        } failure:^(NSError *error) {
//            
//            [MBProgressHUD alertView:@"注册失败" Message:error.localizedDescription];
//        }];
    }else
        return;
}

-(void)createView
{
    phoneTextField=[[WPTextField alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, kHEIGHT(43))];
    [self.view addSubview:phoneTextField];
    
    phoneTextField.font=kFONT(15);
    [phoneTextField setPlaceholder:@"请输入你的手机号码"];
    [phoneTextField setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [phoneTextField setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
    UIImageView* iconView1=[[UIImageView alloc] init];
    iconView1.frame=CGRectMake(kHEIGHT(10),(kHEIGHT(43)+1-24)/2, 15+kHEIGHT(10), 24);
    phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    iconView1.contentMode=UIViewContentModeLeft;
    iconView1.image=[UIImage imageNamed:@"login_shouji"];
    phoneTextField.leftView=iconView1;
    phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
    phoneTextField.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:phoneTextField];
    phoneTextField.tag=100;
//    phoneTextField.backgroundColor = [UIColor redColor];
    WPShareModel* model=[WPShareModel sharedModel];
    model.phoneNumberStr=phoneTextField.text;
    phoneTextField.delegate = self;

    UIView * passBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 75+kHEIGHT(43)+1, SCREEN_WIDTH, kHEIGHT(43))];
    [self.view addSubview:passBackView];
    
    passWordTextfield=[[WPTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHEIGHT(43))];
    [passBackView addSubview:passWordTextfield];
    passWordTextfield.font=kFONT(15);
    [passWordTextfield setPlaceholder:@"请输入你的密码(6-16位)"];
    
    [passWordTextfield setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [passWordTextfield setValue:kFONT(15) forKeyPath:@"_placeholderLabel.font"];
    
    UIImageView* iconView=[[UIImageView alloc] init];
    iconView.frame=CGRectMake(kHEIGHT(10),(kHEIGHT(43)+1-24)/2, 15+kHEIGHT(10), 24);
    passWordTextfield.leftViewMode=UITextFieldViewModeAlways;
    iconView.contentMode=UIViewContentModeLeft;
    iconView.image=[UIImage imageNamed:@"login_mima"];
    passWordTextfield.leftView=iconView;
    passWordTextfield.delegate = self;
    passWordTextfield.backgroundColor=[UIColor whiteColor];
    passWordTextfield.keyboardType=UIKeyboardTypeASCIICapable;
//    [self.view addSubview:passWordTextfield];
    
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(passBackView.frame.size.width-40, 0 , 40, kHEIGHT(43));
    [btn setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
    btnStatus=YES;
    passWordTextfield.delegate = self;
    passWordTextfield.secureTextEntry=YES;
    [passWordTextfield addSubview:btn];
    btn.selected = NO;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITextView* textView=[[UITextView alloc] initWithFrame:CGRectMake(5, passBackView.bottom+5, self.view.frame.size.width-10, self.view.frame.size.height-162)];
    textView.text=@"为保护你的账号安全，请勿设置过于简单的密码，快聘不会在任何地方泄漏你的手机号码。";
    textView.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    textView.editable=NO;
    textView.contentMode = UIViewContentModeTop;
    textView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:textView];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(2*kHEIGHT(10)+15, 79+kHEIGHT(42)-0.5, SCREEN_WIDTH-2*kHEIGHT(10)-15,0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:line];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"11111");
    [phoneTextField resignFirstResponder];
    [passWordTextfield resignFirstResponder];
}

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (textField.tag==100&textField.text.length==11) {
//        return YES;
//    }
//        return NO;
//}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneTextField) {
        if (range.location > 10)
            return NO;
        return YES;
    }
    else if (textField == passWordTextfield)
    {
        
        if (range.location > 0 && range.length == 1 && string.length == 0)
        {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
            return NO;
        }
        
        if (range.location > 15)
            return NO; // return NO to not change text
        return YES;
    }
    return YES;

}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.tag==101) {
//        btnStatus=!btnStatus;
//    }
//}


-(void)btnClick:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        passWordTextfield.secureTextEntry=YES;
        [btn setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
    }
    else
    {
        passWordTextfield.secureTextEntry=NO;
       [btn setImage:[UIImage imageNamed:@"login_xianshimima_pre"] forState:UIControlStateNormal];
    }
    NSLog(@"切换");
//    btnStatus=!btnStatus;
//        if (btnStatus==YES) {
//            passWordTextfield.secureTextEntry=YES;
//            [btn setImage:[UIImage imageNamed:@"login_xianshimima"] forState:UIControlStateNormal];
//        }else
//        {
//            passWordTextfield.secureTextEntry=NO;
//            [btn setImage:[UIImage imageNamed:@"login_xianshimima_pre"] forState:UIControlStateNormal];
//        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
