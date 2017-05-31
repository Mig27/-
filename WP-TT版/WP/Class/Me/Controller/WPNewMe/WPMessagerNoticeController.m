
//
//  WPMessagerNoticeController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMessagerNoticeController.h"
#import "SwitchView.h"
#import "MessagerModel.h"
#import "MessagerManager.h"


@interface WPMessagerNoticeController ()<MessagerManagerDelegate>
@property (nonatomic, strong)MessagerModel *msgModel;
@property (nonatomic ,strong)NSArray *titleArr;
@property (nonatomic ,strong)UIView *contenView;
@property (nonatomic ,strong)NSMutableArray *switchArr;
@end

@implementation WPMessagerNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息通知";
//    MessagerManager *manager =  [MessagerManager sharedManager];
//    manager.delegate = self;
//    [manager requestMessagerSetting];
    self.view.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:self.contenView];
    [self getMessageInfo];
}
-(void)getMessageInfo
{
    NSUserDefaults * standDefault = [NSUserDefaults standardUserDefaults];
    NSString * voice = [standDefault objectForKey:@"messageVoice"];
    NSString * shock = [standDefault objectForKey:@"messageShock"];
    NSString * noti = [standDefault objectForKey:@"messageNotification"];
    
    if (voice.length == 0 || [voice isEqualToString:@"(null)"]) {
        voice = @"1";
    }
    
    if (shock.length == 0 || [shock isEqualToString:@"(null)"]) {
        shock = @"1";
    }
    if (noti.length == 0 || [noti isEqualToString:@"(null)"]) {
        noti = @"1";
    }
    
    MessagerManager *manager =  [MessagerManager sharedManager];
    MessagerModel  * model = [[MessagerModel alloc]init];
    model.voice = voice;
    model.shock = shock;
    model.deplayMsgContent = noti;
    manager.model = model;
    [self reloadData];

}
- (void)reloadData
{
    self.msgModel = [MessagerManager sharedManager].model;
    for (int i = 0; i < self.switchArr.count; i++) {
        [self setSwitchStatusWithtag:i switchView:self.switchArr[i]];
    }
}

- (UIView *)contenView
{
    if (!_contenView) {
        self.contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+15, SCREEN_WIDTH, kHEIGHT(43)*4)];
        self.contenView.backgroundColor = [UIColor whiteColor];
        int i = 0;
        for (NSString *str in self.titleArr) {
            SwitchView *switchView = [[SwitchView alloc]initWithFrame:CGRectMake(0,i * kHEIGHT(43), SCREEN_WIDTH, kHEIGHT(43))];
            if (i==0) {
                switchView.status = @"已开启";
            }
            switchView.title = str;
            [self.contenView addSubview:switchView];
            [self.switchArr addObject:switchView.switchView];
            
            [switchView.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            i++;
        }
        
    }
    return _contenView;
}

- (void)setSwitchStatusWithtag:(int)i switchView:(UISwitch *)switchView
{
    if (i==1) {
        BOOL isOn = [self giveMeStatusWithOn:self.msgModel.voice];
        [switchView setOn:isOn animated:YES];
    }
    if (i==2) {
        [switchView setOn:[self giveMeStatusWithOn:self.msgModel.shock] animated:YES];
    }
    if (i==3) {
        [switchView setOn:[self giveMeStatusWithOn:self.msgModel.deplayMsgContent] animated:YES];
    }
    if (i==4) {
        [switchView setOn:[self giveMeStatusWithOn:self.msgModel.noReadMgsAlert] animated:YES];
    }
    
}

- (BOOL)giveMeStatusWithOn:(NSString *)status
{
    if ([status isEqualToString:@"0"]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)switchAction:(UISwitch *)sender
{
    NSInteger tag = [self.switchArr indexOfObject:sender];// 该数组第一个对象是已被移除父视图的
    switch (tag) {
        case 1:
            self.msgModel.voice = [self giveMeAcountWithOn:sender.isOn];
            [[NSUserDefaults standardUserDefaults] setObject:[self giveMeAcountWithOn:sender.isOn] forKey:@"messageVoice"];
            break;
        case 2:
            self.msgModel.shock = [self giveMeAcountWithOn:sender.isOn];
            [[NSUserDefaults standardUserDefaults] setObject:[self giveMeAcountWithOn:sender.isOn] forKey:@"messageShock"];
            break;
        case 3:
            self.msgModel.deplayMsgContent = [self giveMeAcountWithOn:sender.isOn];
            [[NSUserDefaults standardUserDefaults] setObject:[self giveMeAcountWithOn:sender.isOn] forKey:@"messageNotification"];
            break;
        case 4:
            self.msgModel.noReadMgsAlert = [self giveMeAcountWithOn:sender.isOn];
            break;
        default:
            break;
    }
}

- (NSString *)giveMeAcountWithOn:(BOOL)isOn
{
    if (isOn) {
        return @"1";
    }else{
        return @"0";
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
        self.titleArr = @[@"新消息通知",@"声音",@"震动",@"提醒时显示消息内容"];//,@"未读消息短信提醒"
    }
    return _titleArr;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MessagerManager sharedManager].model = self.msgModel;
    [[MessagerManager sharedManager] updateMessagerSetting];
    
}


@end
