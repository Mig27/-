//
//  LoginViewController.m
//  WP
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPMainController.h"
#import "WPRegistViewController.h"
#import "ZCControl.h"
#import "WPLoginViewController1.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LinkmanInfoModel.h"
#import "WPNavigationController.h"
@implementation WPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self setUpMode];
    
   
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setUpMode
{
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    image.image=[UIImage imageNamed:@"stara"];
    [self.view addSubview:image];
    
    
//    UIImageView* smallimage=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-66)/2, self.view.frame.size.height/6+10, 66, 66)];
//    smallimage.image=[UIImage imageNamed:@"微聘团队.png"];
//    [image addSubview:smallimage];
    
//    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/6+76, self.view.frame.size.width, 30)];
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textAlignment=NSTextAlignmentCenter;
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.text=@"微聘";
//    [self.view addSubview:titleLabel];
    
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    
    UIButton*registbutton=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-60-2*120)+120+30,  self.view.frame.size.height-30-kHEIGHT(43),120, kHEIGHT(43))];
    registbutton.titleLabel.font = GetFont(16);
    [registbutton setTitle:@"注册" forState:UIControlStateNormal];
    [registbutton setBackgroundColor:[UIColor whiteColor]];
    [registbutton setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    registbutton.titleLabel.font = kFONT(15);
    registbutton.layer.cornerRadius = 5;
//    [registbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [registbutton setBackgroundImage:[UIImage imageNamed:@"register2"] forState:UIControlStateNormal];
//    [registbutton setBackgroundImage:[UIImage imageNamed:@"register1"] forState:UIControlStateHighlighted];
    [registbutton addTarget:self action:@selector(GoToRegistVC:) forControlEvents:UIControlEventTouchUpInside];
    [registbutton addTarget:self action:@selector(registClkickDown:) forControlEvents:UIControlEventTouchDown];
    [registbutton addTarget:self action:@selector(registCliockDownDrag:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:registbutton];
    registbutton.alpha = 0;
//    [UIView animateWithDuration:1.5 animations:^{
//       
//    }];
    
    
    UIButton*loginbutton=[[UIButton alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height-30-kHEIGHT(43), 120, kHEIGHT(43))];
//    UIButton *loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbutton.titleLabel.font = GetFont(16);
    [loginbutton setTitle:@"登录" forState:UIControlStateNormal];
    loginbutton.titleLabel.font = kFONT(15);
    loginbutton.layer.cornerRadius = 5;
    [loginbutton setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    [loginbutton setBackgroundColor:[UIColor whiteColor]];
    

    loginbutton.alpha = 0;
    [loginbutton addTarget:self action:@selector(GoToMainVC:) forControlEvents:UIControlEventTouchUpInside];
    [loginbutton addTarget:self action:@selector(clickLoginDown:) forControlEvents:UIControlEventTouchDown];
    [loginbutton addTarget:self action:@selector(clickLoginDrag:) forControlEvents:UIControlEventTouchDragOutside];
    
    
    [self.view addSubview:loginbutton];
    [UIView animateWithDuration:0.5 animations:^{
        loginbutton.alpha = 1;
         registbutton.alpha = 1;
    }];
    

//    UIButton* travalbutton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*2, self.view.frame.size.height - 50, self.view.frame.size.width/3, 50)];
//    travalbutton.titleLabel.font = GetFont(16);
//    [travalbutton setTitle:@"逛逛" forState:UIControlStateNormal];
//    [travalbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [travalbutton setBackgroundImage:[UIImage imageNamed:@"register2"] forState:UIControlStateNormal];
//    [travalbutton setBackgroundImage:[UIImage imageNamed:@"register1"] forState:UIControlStateHighlighted];
//    [travalbutton addTarget:self action:@selector(GoToTravalVC) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:travalbutton];

//    for (int i=0; i<2; i++) {
//        UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*(i+1), self.view.frame.size.height - 50 + 17.5, 0.5, 15)];
//        label.backgroundColor=[UIColor whiteColor];
//        [self.view addSubview:label];
//    }
    
}
-(void)ShowView:(UIView *)view To:(CGRect)frame During:(float)time delegate:(id)delegate;{
    
//    [UIView beginAnimations:@"View Flip" context:nil];
//    2
//    3     [UIView setAnimationDuration:1.25];//动画持续时间
//    4     [UIView setAnimationDelegate:self];//设置动画的回调函数，设置后可以使用回调方法
//    5     [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];//设置动画曲线，控制动画速度
//    6
//    7     [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
//           8                            forView:noteView
//           9                              cache:YES];//设置动画方式，并指出动画发生的位置
//    10
//    11     [UIView commitAnimations];//提交UIView动画
//    
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if(delegate !=nil &&[delegate respondsToSelector:@selector(onAnimationComplete:finished:context:)]){
        
        [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
        [UIView setAnimationDelegate:delegate];
    }
    view.hidden = NO;
    view.layer.opacity = 1.0;
    view.frame = frame;
    [UIView commitAnimations];
    
}

- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
 
}
-(void)GoToMainVC:(UIButton*)sender
{
  //  [self address];
    [sender setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"登录界面");
    WPLoginViewController1* vc=[[WPLoginViewController1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    显示状态栏
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    切换窗口的根控制器
//    self.view.window.rootViewController = [[WPMainController alloc] init];

}

- (void)address
{
    //dataSource = [[NSMutableArray alloc] init];
    //NSMutableArray *contactsdata= [[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        LinkmanInfoModel *addressBook = [[LinkmanInfoModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.telephone = (__bridge NSString*)value;
                        NSLog(@"%@",addressBook.telephone);
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}

-(void)clickLoginDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
-(void)clickLoginDrag:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
}
-(void)GoToRegistVC:(UIButton*)sender
{
    //[self address];
    NSLog(@"zhuce");
    // 显示状态栏
    [sender setBackgroundColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarHidden = NO;
    WPRegistViewController* vc=[[WPRegistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)registClkickDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
-(void)registCliockDownDrag:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
}
-(void)GoToTravalVC
{
    NSLog(@"逛逛界面");
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [MBProgressHUD alertView:@"" Message:@"敬请期待"];
    
    // 切换窗口的根控制器
//    self.view.window.rootViewController = [[WPMainController alloc] init];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"敬请期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"透明"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     [UIApplication sharedApplication].statusBarHidden = NO;
//    self.title = @"登录";
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)viewDidLayoutSubviews
{
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
