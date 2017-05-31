//
//  WPFriendSettingController.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPFriendSettingController.h"
#import "SwitchView.h"

@interface WPFriendSettingController ()
{
    BOOL ON;
    BOOL settingValue;
}
@property (nonatomic ,strong)UIView *contentView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic ,strong)NSArray *detailArr;
@property (nonatomic ,strong)NSMutableArray *switchArr;
@end

@implementation WPFriendSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nearPerson?(self.title = @"设置个人信息"):(self.title = @"设置好友验证");
    ON = YES;
    
    [self.view addSubview:self.contentView];
    if (self.nearPerson)
    {
        if (self.isShowNear) {
            settingValue = YES;
        }else{
            settingValue = NO;
        }
     [self reloadSwitchView];
    }
    else
    {
        [self requestFriendValidate];
    }
   // [self requestFriendValidate];
    //[self.view addSubview:self.contentView];
    self.view.backgroundColor = RGB(235, 235, 235);
}

- (UIView *)contentView
{
    if (!_contentView) {
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+15, SCREEN_WIDTH, kHEIGHT(43))];
        self.contentView.backgroundColor = [UIColor whiteColor];
        int i = 0;
        for (NSString *string in self.titleArr) {
            SwitchView *switchView = [[SwitchView alloc]initWithFrame:CGRectMake(0,i * kHEIGHT(43), SCREEN_WIDTH, kHEIGHT(43))];
            NSLog(@"%f",switchView.frame.origin.x);
            switchView.title = string;
            switchView.switchView.tag = 10+i;
            //在这里设置 switch 的状态以及 相关属性
            [switchView.switchView setOn:ON];
            ON = !ON;
            switchView.detailTitle = self.detailArr[i];
            
            [self.contentView addSubview:switchView];
            [self.switchArr addObject:switchView];
            i ++;
            [switchView.switchView addTarget:self action:@selector(switchViewAction:) forControlEvents:UIControlEventValueChanged];
        }
    }
    return _contentView;
}



- (void)switchViewAction:(UISwitch *)sender
{
    SwitchView *switchView = (SwitchView *)sender.superview;
    SwitchView * view1 = self.switchArr[0];
//    SwitchView * view2 = self.switchArr[1];
    if (switchView == view1) {
       [view1.switchView setOn:sender.isOn animated:YES];
//        [view2.switchView setOn:!view2.switchView.isOn animated:YES];
        if (sender.isOn) {
            settingValue = YES;
        }
        else
        {
            settingValue = NO;
        }
    }
    else
    {
//        [view1.switchView setOn:!view1.switchView.isOn animated:YES];
//        [view2.switchView setOn:sender.isOn animated:YES];
//        if (sender.isOn) {
//            settingValue = NO;
//        }
//        else
//        {
//            settingValue = YES;
//        }
    }
    
    
    
    
}

- (NSMutableArray *)switchArr
{
    if (!_switchArr) {
        self.switchArr = [NSMutableArray array];
    }
    return _switchArr;
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        self.nearPerson?(self.titleArr = @[@"个人信息在附近显示"]):(self.titleArr = @[@"加我为好友时需要验证"]);
        //self.titleArr = @[@"加我为好友时需要验证"];//,@"求职招聘模式"
        
    }
    return _titleArr;
}

- (NSArray *)detailArr
{
    if (!_detailArr) {
        self.detailArr = @[@""];//,@"加我为好友时不需要验证"
    }
    return _detailArr;
}

- (void)requestFriendValidate
{
    NSDictionary *params = @{@"action":@"GetFriendValidate",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId};
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"friendValidate"] integerValue]) {
            settingValue = NO;
        }else{
            settingValue = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadSwitchView];
        });
    } failure:^(NSError *error) {
    }];
}

- (void)reloadSwitchView
{
    int i = 0;
    for (SwitchView *switchView in self.switchArr) {
        if (i == 0) {
            [switchView.switchView setOn:settingValue];
        }else{
            [switchView.switchView setOn:!settingValue];
        }
        i++;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.nearPerson?[self setNearAllow]:[self setModelOfComfi];
   // [self setModelOfComfi];
    
    
//    NSDictionary *params = @{@"action":@"UpdateFriendValidate",
//                             @"username":kShareModel.username,
//                             @"password":kShareModel.password,
//                             @"user_id":kShareModel.userId,
//                             @"settingValue":[self getsettingValue]};
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        if ([json[@"status"] integerValue]) {
//            NSLog(@"%@",json[@"status"]);
//        }
//    } failure:^(NSError *error) {
//    }];
}
-(void)setNearAllow
{
    NSDictionary * dic = @{@"action":@"setNear",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"state":[self getsettingValue]};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/userInfo.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        BOOL isOr = [[self getsettingValue] isEqualToString:@"0"];
        if (self.setNear) {
            self.setNear(isOr);
        }
    } failure:^(NSError *error) {
    }];
}
-(void)setModelOfComfi
{
    NSDictionary *params = @{@"action":@"UpdateFriendValidate",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"settingValue":[self getsettingValue]};
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            NSLog(@"%@",json[@"status"]);
        }
    } failure:^(NSError *error) {
    }];
}
- (NSString *)getsettingValue
{
    if (settingValue) {
        return @"0";
    }else{
        return @"1";
    }
}

@end
