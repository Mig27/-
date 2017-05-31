//
//  WPSetRefreshController.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSetRefreshController.h"
#import "SwitchView.h"
#import "WPRefreshManager.h"
#import "WPDateCheckView.h"
#import "SPItemView.h"
#import "WPTimeCheckView.h"
//#import "WPRefreshManager.h"

@interface WPSetRefreshController ()<WPRefreshManagerDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)SwitchView *switchView;
@property (nonatomic ,strong)UIButton *cycleView;
@property (nonatomic ,strong)UIButton *timeView;
@property (nonatomic ,strong)WPDateCheckView *dateView;
@property (nonatomic ,strong)WPTimeCheckView *timePicker;
@property (nonatomic ,strong)NSString *startTime;
@property (nonatomic ,strong)NSString *endTime;
@property (nonatomic ,strong)WPRefreshManager *manager;
@property (nonatomic, strong)WPSetRefreshModel *originalModel;
@property (nonatomic, assign)BOOL isChanged;
@end

@implementation WPSetRefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChanged = NO;
    // Do any additional setup after loading the view.
    self.title = @"自动刷新设置";
    [self requestForRefreshParam];
    [self.view addSubview:self.switchView];
    [self addRightBarButtonItem];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//点击返回按钮
-(void)backToFromViewController:(UIButton *)sender
{
    UILabel *autoTime = (UILabel *)[self.timeView viewWithTag:10];
    UILabel *returnTime = (UILabel *)[self.cycleView viewWithTag:10];
    NSString * timeDate = [NSString stringWithFormat:@"%@--%@",[self getDateWithtime: self.originalModel.begin_time],[self getDateWithtime: self.originalModel.end_time]];
    NSString * time = [NSString stringWithFormat:@"%@小时",self.originalModel.r_time];
    BOOL isOrNot = NO;
    if (![autoTime.text isEqualToString:timeDate] || (![returnTime.text isEqualToString:time]) || self.isChanged) {
        isOrNot = YES;
    }
    if (isOrNot) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)requestForRefreshParam
{
    
    WPRefreshManager *manager = [WPRefreshManager sharedManager];
    manager.delegate = self;
    [manager requestForRefreshParam];
}

- (BOOL)couldCommit
{
    BOOL commit = NO;
    if (self.manager.setModel.begin_time && _manager.setModel.end_time && _manager.setModel.r_time) {
        commit = YES;
    }
    return commit;
}

- (WPRefreshManager *)manager
{
    if (!_manager) {
        self.manager = [WPRefreshManager sharedManager];
    }
    return _manager;
}

- (void)reloadData
{
    if (![self.manager.setModel.state intValue] && self.manager.setModel) {
        self.originalModel = self.manager.setModel;
        [self.switchView.switchView setOn:YES];
        [self switchAction:self.switchView.switchView];
        UILabel *autoTime = (UILabel *)[self.timeView viewWithTag:10];
        autoTime.text = [NSString stringWithFormat:@"%@--%@",[self getDateWithtime: self.manager.setModel.begin_time],[self getDateWithtime: self.manager.setModel.end_time]];
        UILabel *returnTime = (UILabel *)[self.cycleView viewWithTag:10];
        returnTime.text = [NSString stringWithFormat:@"%@小时",self.manager.setModel.r_time];
    }
}

- (NSString *)getDateWithtime:(NSString *)time
{
    NSString *timeString = [time substringWithRange:NSMakeRange(5, 3)];
    NSArray *timeArr = [timeString componentsSeparatedByString:@"/"];
    NSString *string = [NSString stringWithFormat:@"%@月%@日",timeArr[0],timeArr[1]];
    
    return string;
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if (self.switchView.switchView.isOn) {
        if ([self couldCommit]) {
            [self.manager requestForAutoRefreshsuccess:^(id json) {
                if (self.setRefreshSuccess) {
                    self.setRefreshSuccess();
                }
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else{
        [self.manager requestForStopRefreshsuccess:^(id json) {
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    
}

- (SwitchView *)switchView
{
    if (!_switchView) {
        self.switchView = [[SwitchView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(43))];
        self.switchView.title = @"自动刷新";
        self.switchView.backgroundColor = [UIColor whiteColor];
        [self.switchView.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (void)switchAction:(UISwitch *)sender
{
    self.isChanged = !self.isChanged;
    [self removePickers];
    if (sender.isOn) {
        [self.view addSubview:self.timeView];
        [self.view addSubview:self.cycleView];
    }else{
        [self.cycleView removeFromSuperview];
        [self.timeView removeFromSuperview];
    }
}

- (UIButton *)cycleView
{
    if (!_cycleView) {
        self.cycleView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cycleView.frame = CGRectMake(0, self.timeView.bottom, SCREEN_WIDTH, ItemViewHeight);
        self.cycleView.backgroundColor = [UIColor whiteColor];
        
        CGSize size = [@"刷新间隔时间:" getSizeWithFont:FUCKFONT(15) Height:ItemViewHeight];
        CGFloat width = size.width;
        
        UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, width, ItemViewHeight)];
        label.text = @"刷新间隔时间:";
        label.font = kFONT(15);
        CGFloat leftEdge = label.right + 6;
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftEdge, 0, SCREEN_WIDTH-leftEdge-24, ItemViewHeight)];
        timeLabel.tag = 10;
        timeLabel.font = kFONT(15);
        timeLabel.textColor = RGB(170, 170, 170);
        timeLabel.text = @"请选择刷新间隔时间";
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        image.frame = CGRectMake(self.cycleView.width-10-8, self.cycleView.height/2-7, 8,14);
        
        [self.cycleView addSubview:label];
        [self.cycleView addSubview:timeLabel];
        [self.cycleView addSubview:image];
        [self.cycleView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        
        
    }
    return _cycleView;
}

- (UIButton *)timeView
{
    if (!_timeView) {
        self.timeView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.timeView.frame = CGRectMake(0, self.switchView.bottom+15, SCREEN_WIDTH, ItemViewHeight);
        self.timeView.backgroundColor = [UIColor whiteColor];
        
        CGSize size = [@"自动刷新周期:" getSizeWithFont:FUCKFONT(15) Height:ItemViewHeight];
        
        CGFloat width = size.width;
        
        UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, width, ItemViewHeight)];
        label.text = @"自动刷新周期:";
        label.font = kFONT(15);
        CGFloat leftEdge = label.right + 6;
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftEdge, 0, SCREEN_WIDTH-leftEdge-24, ItemViewHeight)];
        timeLabel.tag = 10;
        timeLabel.font = kFONT(15);
        timeLabel.textColor = RGB(170, 170, 170);
        timeLabel.text = @"请选择开始时间和结束时间";
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        image.frame = CGRectMake(self.timeView.width-10-8, self.timeView.height/2-7, 8,14);
        
        [self.timeView addSubview:label];
        [self.timeView addSubview:timeLabel];
        [self.timeView addSubview:image];
        [self.timeView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.timeView addSubview:line];
    }
    return _timeView;
}

-(WPDateCheckView *)dateView
{
    if (!_dateView) {
        WS(ws);
        _dateView = [[WPDateCheckView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        self.dateView.startTime = ^(NSString *time){ //起始时间
            UILabel *label = (UILabel *)[ws.timeView viewWithTag:10];
            ws.startTime = [ws getMyDateWithtime:time];
            label.text = ws.startTime;
            //            ws.manager.setModel.begin_time = time;
            
            WPSetRefreshModel *setModel = ws.manager.setModel;
            if (!setModel) {
                setModel = [[WPSetRefreshModel alloc]init];
            }
            setModel.begin_time = time;
            ws.manager.setModel = setModel;
            label.textColor = [UIColor blackColor];
        };
        
        self.dateView.endTime = ^(NSString *time){  //结束时间
            UILabel *label = (UILabel *)[ws.timeView viewWithTag:10];
            ws.endTime = [ws getMyDateWithtime:time];
            label.text = [NSString stringWithFormat:@"%@--%@",ws.startTime,ws.endTime];
            //            ws.manager.setModel.end_time = time;
            
            WPSetRefreshModel *setModel = ws.manager.setModel;
            if (!setModel) {
                setModel = [[WPSetRefreshModel alloc]init];
            }
            setModel.end_time = time;
            ws.manager.setModel = setModel;
            label.textColor = [UIColor blackColor];
        };
    }
    return _dateView;
}

- (NSString *)getMyDateWithtime:(NSString *)time
{
    NSString *timeString = [time substringWithRange:NSMakeRange(5, 5)];
    NSArray *timeArr = [timeString componentsSeparatedByString:@"-"];
    NSString *string = [NSString stringWithFormat:@"%@月%@日",timeArr[0],timeArr[1]];
    
    return string;
}

- (WPTimeCheckView *)timePicker
{
    if (!_timePicker) {
        WS(ws);
        self.timePicker = [[WPTimeCheckView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-246, SCREEN_WIDTH, 246)];
        self.timePicker.time = ^(NSString *time){
            UILabel *label = (UILabel *)[ws.cycleView viewWithTag:10];
            label.text = time;
            //            ws.manager.setModel.r_time = [time substringToIndex:1];
            
            
            WPSetRefreshModel *setModel = ws.manager.setModel;
            if (!setModel) {
                setModel = [[WPSetRefreshModel alloc]init];
            }
            setModel.r_time = [time substringToIndex:1];
            ws.manager.setModel = setModel;
            label.textColor = [UIColor blackColor];
        };
    }
    return _timePicker;
}

- (void)buttonAction:(UIButton *)sender
{
    [self removePickers];
    if (sender == self.timeView) {
        [self.dateView showInView:self.view];
    }
    if (sender == self.cycleView) {
        [self.view addSubview:self.timePicker];
    }
}

- (void)removePickers
{
    if (self.dateView.superview) {
        [self.dateView removeFromSuperview];
    }
    if (self.timePicker.superview) {
        [self.timePicker removeFromSuperview];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self removePickers];
//}

@end
