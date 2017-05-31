//
//  WPRegisterViewController4.m
//  WP
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//


#import "WPRegisterViewController4.h"
#import "WPMainController.h"
#import "WPShareModel.h"
#import "WPTextField.h"
#import "ZCControl.h"
#import "WPHttpTool.h"
#import "LoginModel.h"
#import "MBProgressHUD+MJ.h"
#import "MacroDefinition.h"
#import "WPLoginViewController1.h"
#import "MTTRootViewController.h"
@interface WPRegisterViewController4 ()<UIAlertViewDelegate>
{
    UILabel* label;
    UILabel* phoneLabel;
    NSString* phoneString;
    NSString* str;
    UITextField* verificationTextfield;
    UIButton* button;
    NSTimer * timer;
    int timeNum;
    NSString * codeStr;
}

@end

@implementation WPRegisterViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromViewController:) forControlEvents:UIControlEventTouchUpInside];
    back.titleLabel.font = kFONT(14);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    //设置右按钮
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:NULLNAME Target:self Action:@selector(loginClick) Title:@"完成"];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.titleLabel.font = kFONT(14);
    [rightButton setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    [rightButton setTitleColor:RGB(226, 226, 226) forState:UIControlStateHighlighted];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.title=@"输入验证码";
    
    NSString * codeString = @"验证码短信已发送到:";
    CGSize strSise = [codeString getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH-2*kHEIGHT(10)];
    label=[[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 79, strSise.width, strSise.height)];
    label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.text=@"验证码短信已发送到:";
    label.textAlignment=NSTextAlignmentLeft;
    label.font=kFONT(12);
    [self.view addSubview:label];
    
    
    
    phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10)+strSise.width+2, 79, self.view.frame.size.width-125, strSise.height)];
//    phoneLabel.textColor=[UIColor colorWithRed:10/255.0 green:110/255.0 blue:210/255.0 alpha:1];
    phoneLabel.textColor = RGB(0, 172, 255);
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.font=kFONT(12);
//    phoneLabel.backgroundColor = [UIColor redColor];
    phoneLabel.text = self.photoText;
    [self.view addSubview:phoneLabel];
    
    
    verificationTextfield=[[WPTextField alloc] initWithFrame:CGRectMake(0, 79+strSise.height+6, self.view.frame.size.width, kHEIGHT(43))];//96
    verificationTextfield.font=[UIFont systemFontOfSize:15];
    [verificationTextfield setPlaceholder:@"请输入验证码"];
    UIImageView* iconView=[[UIImageView alloc] init];
    iconView.frame=CGRectMake(kHEIGHT(10),(kHEIGHT(43)+1-24)/2, 15+kHEIGHT(10), 24);
    verificationTextfield.leftViewMode=UITextFieldViewModeAlways;
    iconView.contentMode=UIViewContentModeLeft;
    iconView.image=[UIImage imageNamed:@"login_yanzhengma"];
    verificationTextfield.leftView=iconView;
    verificationTextfield.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:verificationTextfield];
    
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(kHEIGHT(10), verificationTextfield.bottom+20, SCREEN_WIDTH-20, kHEIGHT(38));
    [button setTitle:@"重发验证码(30s)"forState:UIControlStateNormal];
    button.layer.cornerRadius=5;
    button.backgroundColor=[UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    button.titleLabel.font=kFONT(14);
    [self.view addSubview:button];
    button.enabled = NO;
    [button addTarget:self action:@selector(reBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    int i = 60;
    
    timeNum = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    [timer fire];
    
    [self getYanZhengNum];
    
    
    // Do any additional setup after loading the view.
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)backToFromViewController:(UIButton*)sender
{
    if (!codeStr.length) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码短信可能略有延迟,确认返回?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString*)getYanZhengNum
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/verify_code.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"getCode",@"mobile":self.photoText};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:urlStr parameters:dic
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//          NSString * str = [NSString stringWithFormat:@"%@",responseObject];
          NSData * data = (NSData*)responseObject;
          NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          codeStr = string;
          if ([string isEqualToString:@"-1"]) {
              [MBProgressHUD createHUD:@"今日验证次数已达上限" View:self.view];
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      }];
   return codeStr;
}
-(void)timerStart:(id)sender
{
    --timeNum;
    if (timeNum == 0) {
        [timer setFireDate:[NSDate distantFuture ]];
        [button setTitle:@"重发验证码" forState:UIControlStateNormal];
        [button setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        button.enabled = YES;
        timeNum = 60;
    }
    else
    {
        [button setTitle:[NSString stringWithFormat:@"重发验证码(%ds)",timeNum] forState:UIControlStateNormal];
        [button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    }
    
}
#pragma mark 点击重发验证码
-(void)reBtnClick
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    [timer fire];
    [self getYanZhengNum];
//    NSLog(@"重发验证码");
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!self.isFromRegist) {
        WPShareModel* model=[WPShareModel sharedModel];
        phoneLabel.text=model.phoneNumberStr;
    }
   
    
//    NSLog(@"***********%@************",phoneLabel.text);
}

-(void)loginClick
{
    if (self.isFromRegist)
    {
        if (!verificationTextfield.text.length) {
            [MBProgressHUD createHUD:@"请输入验证码" View:self.view];
            return;
        }
        
        if (![codeStr isEqualToString:verificationTextfield.text]) {
            [MBProgressHUD createHUD:@"验证码错误" View:self.view];
            return;
        }
        
        if ([codeStr isEqualToString:@"-1"]) {
            return;
        }
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        WPShareModel* model=[WPShareModel sharedModel];
      // NSString * nameString=model.usernameStr;
       NSString * sexString=model.sexStr;
       NSString * birthString=model.birthdayStr;
       NSString * industryString=[NSString stringWithFormat:@"%@",model.industryModel.industryName];
       NSString * positionString=[NSString stringWithFormat:@"%@-%@",model.positionModel.industryID,model.positionModel.industryName];
       NSString * addressString=[NSString stringWithFormat:@"%@-%@",model.addressModel.industryID,model.addressModel.industryName];
//      NSString *  photoPathStr=model.photoStr;
     NSString * longitude = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]];
        NSString * latitude =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
        NSDictionary *dic = @{
                              @"action":@"Reg",
                              @"username":self.photoText,
                              @"address":@"",
                              @"PhotoAddress":@"",
                              @"sex":sexString,
                              @"birthday":birthString,
                              @"profession":positionString,
                              @"workAddress":addressString,
                              @"School":@"",
                              @"password":self.passWordText,
                              @"telphone":self.photoText,
                              @"graduateTime":@"",
                              @"regMAC":@"100",
                              @"code":codeStr,//verificationTextfield.text
                              @"nick_name":model.usernameStr,
                              @"company":industryString,
                              @"longitude":longitude.length?longitude:@"",
                              @"latitude":latitude.length?latitude:@""
                              };
        WPFormData *formData = [[WPFormData alloc]init];
        formData.data = UIImageJPEGRepresentation(self.headImage,1.0);
        formData.name = @"PhotoAddress";//uploadFile
        formData.filename = @"headImage.png";
        formData.mimeType = @"image/png";
        NSArray *arr = @[formData];
        [WPHttpTool postWithURL:urlStr params:dic formDataArray:arr success:^(id json) {
         NSString* statueds = json[@"status"];
            switch (statueds.intValue) {
                case 0:
                    [MBProgressHUD alertView:json[@"info"] Message:json[@"info"]];
                    break;
                case 1:
                {
                    WPShareModel *model = [WPShareModel sharedModel];
//                    model.dic=loginModel.list[0];
                    model.username = self.photoText;
                    model.password = self.passWordText;
                    [self loginClick:nil];
//                    WPLoginViewController1 *vc = [[WPLoginViewController1 alloc]init];
//                    vc.phoneStr = self.photoText;
//                    [self.navigationController pushViewController:vc animated:YES];
                 }
                    break;
                case 2:
                    [MBProgressHUD alertView:json[@"info"] Message:json[@"info"]];
                    break;
                case 3:
                    [MBProgressHUD alertView:json[@"info"] Message:json[@"info"]];
                    break;
                case 4:
                    [MBProgressHUD alertView:json[@"info"] Message:json[@"info"]];
                    break;
                default:
                    break;
            }
            
//            LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];
//            if (loginModel.status) {
//                WPShareModel *model = [WPShareModel sharedModel];
//                model.dic=loginModel.list[0];
//                model.username = self.photoText;
//                model.password = self.passWordText;
//                WPRegisterViewController4 *vc = [[WPRegisterViewController4 alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [MBProgressHUD alertView:@"注册失败" Message:loginModel.info];
//                
//            }
        } failure:^(NSError *error) {
            
            [MBProgressHUD alertView:@"注册失败" Message:error.localizedDescription];
        }];
  
    }
    else
    {
    
        [[NSUserDefaults standardUserDefaults] objectForKey:@"bendi"];
        [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoxi"];
        
        
        WPShareModel *model = [WPShareModel sharedModel];
        
        NSLog(@"登录下一步");
        [self.view endEditing:YES];
        NSLog(@"%@  %@",model.phoneNumberStr,model.passWordStr);
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
        
        NSDictionary *dic = @{@"action":@"login",
                              @"username":model.username,
                              @"password":model.password};
        
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (loginModel.status) {
                model.dic=loginModel.list[0];
                model.userId = model.dic[@"userid"];
                
                [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
                
                [self performSelector:@selector(delay) withObject:self afterDelay:0.5];
            }
            else{
                [MBProgressHUD alertView:@"登录失败" Message:loginModel.info];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD alertView:@"登录失败" Message:error.localizedDescription];
        }];
    
    }
    
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"bendi"];
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoxi"];
//    
//    
//    WPShareModel *model = [WPShareModel sharedModel];
//    
//    NSLog(@"登录下一步");
//    [self.view endEditing:YES];
//    NSLog(@"%@  %@",model.phoneNumberStr,model.passWordStr);
//    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
//
//    NSDictionary *dic = @{@"action":@"login",
//                          @"username":model.username,
//                          @"password":model.password};
//
//    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
//        LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (loginModel.status) {
//            model.dic=loginModel.list[0];
//            model.userId = model.dic[@"userid"];
//            
//            [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
//            
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//            
//            [self performSelector:@selector(delay) withObject:self afterDelay:0.5];
//        }
//        else{
//            [MBProgressHUD alertView:@"登录失败" Message:loginModel.info];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD alertView:@"登录失败" Message:error.localizedDescription];
//    }];
}
-(void)loginClick:(NSString*)sender
{
//    [sender setBackgroundColor:RGB(0, 172, 255)];
    [self.view endEditing:YES];
//    [MBProgressHUD showMessage:@"登录中" toView:self.view];
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/login_reg.ashx"];
    NSDictionary *dic = @{@"action":@"login",
                          @"username":kShareModel.username,
                          @"password":kShareModel.password};
    
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSLog(@"%@",json);
        LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:json];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (loginModel.status) {
            
            NSString * isFirst = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOrNot"]];
            if (![isFirst isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstOrNot"];
            }
            //            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstOrNot"];
            
            WPShareModel* model=[WPShareModel sharedModel];
            model.dic=loginModel.list[0];
            model.userId = model.dic[@"userid"];
            model.nick_name = model.dic[@"nick_name"];
//            model.username = phoneTextField.text;
//            model.password = passWordTextfield.text;
            [USER_DEFAULT setObject:json forKey:@"LOGINUSERINFO"];
            [USER_DEFAULT setObject:kShareModel.password forKey:@"LOGINPASSWORD"];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
            //将密码账号保存在本地
            [[NSUserDefaults standardUserDefaults] setObject:kShareModel.username forKey:@"loginNum"];
            
            //注册新账号登陆成功不显示群通知
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"registNew"];
            
            [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
            
            //修改帐号后直接注册原来的帐号需要重新加载数据
            BOOL isORNot = [[[NSUserDefaults standardUserDefaults] objectForKey:@"changeTelephoneSuccess"] boolValue];
            if (isORNot) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"changeTelephoneSuccess"];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAnother" object:nil];
            }
           
            [self performSelector:@selector(delay) withObject:self afterDelay:0.5];
            
        }else{
            [MBProgressHUD alertView:@"密码错误" Message:loginModel.info];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD alertView:@"登录失败" Message:error.localizedDescription];
    }];
    
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
