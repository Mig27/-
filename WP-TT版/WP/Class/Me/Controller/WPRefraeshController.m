//
//  WPRefraeshController.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRefraeshController.h"
#import "WPRefreshManager.h"
#import "WPSetRefreshController.h"
#import "WPRefreshRecordController.h"

@interface WPRefraeshController ()<WPRefreshManagerDelegate>
{
    BOOL reloading;
    NSInteger time;
}
@property (nonatomic ,strong)UIView *rankView;
@property (nonatomic, strong)UIButton *reloadBtn;
@property (nonatomic, strong)UIButton *autoBtn;
@property (nonatomic ,strong)UIButton *bigBtn;
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic ,strong)UILabel *touchLabel;
@property (nonatomic ,strong)UILabel *textLabel;
@end

@implementation WPRefraeshController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"刷新";
    [self requestForSetData];
    [self.view addSubview:self.rankView];
    [self.view addSubview:self.reloadBtn];
    [self.view addSubview:self.autoBtn];
    [self.view addSubview:self.bigBtn];
    [self.view addSubview:self.textLabel];
}

- (void)requestForSetData
{
    WPRefreshManager *manager = [WPRefreshManager sharedManager];
    manager.job_id = self.job_id;
    manager.type = self.type;
    manager.delegate = self;
    [manager requestForRefreshCount];
}
-(void)backToFromViewController:(UIButton *)sender
{
    if (self.setRefresh) {
        self.setRefresh(self.isRefreshOrNot);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadData
{
    WPRefreshManager *manager = [WPRefreshManager sharedManager];
    
    UILabel *rankLabel = (UILabel *)[self.rankView viewWithTag:12];
    rankLabel.text = manager.countModel.num;
    CGSize size = [manager.countModel.num getSizeWithFont:FUCKFONT(12) Height:15];
    rankLabel.frame = CGRectMake(SCREEN_WIDTH-16-size.width, 0, size.width, kHEIGHT(43));
    
    UILabel *numLabel = (UILabel *)[self.reloadBtn viewWithTag:11];
    numLabel.text = manager.countModel.refreshcount;
    size = [manager.countModel.refreshcount getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(43)];
    numLabel.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(8)-24-size.width, 0, size.width, kHEIGHT(43));
    
    UILabel *doLabel = (UILabel *)[self.autoBtn viewWithTag:10];
    if ([manager.countModel.state isEqualToString:@"0"]) {
        doLabel.text = @"已开启";
        self.isRefreshOrNot = YES;
        doLabel.textColor = RGB(0, 172, 255);
    }else{
        doLabel.text = @"";
        self.isRefreshOrNot = NO;
    }
    NSLog(@"%@",[WPRefreshManager sharedManager].countModel.num);
}

- (UIView *)rankView
{
    if (!_rankView) {
        self.rankView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(43))];
        self.rankView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-100, kHEIGHT(43))];
        label.font = kFONT(15);
        UILabel *rank = [[UILabel alloc]init];
        rank.textColor = RGB(127, 127, 127);
        rank.font = kFONT(12);
        label.text = @"简历排名";
        
        UILabel *rankLabel = [[UILabel alloc]init];
        rankLabel.tag = 12;
        rankLabel.font = kFONT(12);
        rankLabel.textColor = RGB(127, 127, 127);
        [self.rankView addSubview:rankLabel];
        [self.rankView addSubview:label];
    }
    return _rankView;
}

- (UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reloadBtn.frame = CGRectMake(0, kHEIGHT(43)+20+64, SCREEN_WIDTH, kHEIGHT(43));
        self.reloadBtn.backgroundColor = [UIColor whiteColor];
        self.reloadBtn.tag = 1;
        [self.reloadBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, kHEIGHT(14), SCREEN_WIDTH, kHEIGHT(15))];
        label.text = @"刷新纪录";
        [self.reloadBtn addSubview:label];
        UILabel *numlabel = [[UILabel alloc]init];
        numlabel.tag = 11;
        numlabel.font = kFONT(12);
        numlabel.textColor = RGB(127, 127, 127);
        [self.reloadBtn addSubview:numlabel];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(8)-16, kHEIGHT(14), kHEIGHT(8), kHEIGHT(15))];
        image.image = [UIImage imageNamed:@"jinru"];
        [self.reloadBtn addSubview:image];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.reloadBtn addSubview:line];
    }
    return _reloadBtn;
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 2) {
        WPSetRefreshController *VC = [[WPSetRefreshController alloc]init];
        VC.setRefreshSuccess = ^(){
          [self rankingAction];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (sender.tag == 1) {
        WPRefreshRecordController *VC = [[WPRefreshRecordController alloc]init];
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (UIButton *)autoBtn
{
    if (!_autoBtn) {
        self.autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.autoBtn.frame = CGRectMake(0, kHEIGHT(43)*2+20+64, SCREEN_WIDTH, kHEIGHT(43));
        self.autoBtn.backgroundColor = [UIColor whiteColor];
        self.autoBtn.tag = 2;
        [self.autoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, kHEIGHT(14), SCREEN_WIDTH, kHEIGHT(15))];
        label.text = @"自动刷新设置";
        [self.autoBtn addSubview:label];
        CGSize size = [@"已开启" getSizeWithFont:FUCKFONT(12) Height:15];
        UILabel *dolabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-16-kHEIGHT(8)-size.width-8, 0, size.width, kHEIGHT(43) )];
        dolabel.tag = 10;
        dolabel.font = kFONT(12);
        dolabel.textColor = RGB(127, 127, 127);
        [self.autoBtn addSubview:dolabel];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, kHEIGHT(14), kHEIGHT(8), kHEIGHT(15))];
        image.image = [UIImage imageNamed:@"jinru"];
        [self.autoBtn addSubview:image];
    }
    return _autoBtn;
}


- (UIButton *)bigBtn
{
    if (!_bigBtn) {
        self.bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bigBtn.frame = CGRectMake(0, 0, 60, 60);
        self.bigBtn.layer.cornerRadius = 30;
        self.bigBtn.layer.masksToBounds = YES;
        self.bigBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-kHEIGHT(94)-30);
        [self.bigBtn addTarget:self action:@selector(reloadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bigBtn setImage:[UIImage imageNamed:@"common_shuaxin"] forState:UIControlStateNormal];
    }
    return _bigBtn;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        CGSize size = [@"点击手动刷新" getSizeWithFont:FUCKFONT(12) Height:20];
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.textLabel.center = CGPointMake(SCREEN_WIDTH/2, self.bigBtn.bottom+kHEIGHT(10)+size.height/2);
        self.textLabel.text = @"点击手动刷新";
        self.textLabel.font = kFONT(12);
        self.textLabel.textColor = RGB(127, 127, 127);
    }
    return _textLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestForSetData];
}

- (void)reloadBtnAction:(UIButton *)sender
{
    [self.timer invalidate];
    if (!reloading) {
        if (self.isOrNot) {//已经下架需要提示
            [SPAlert alertControllerWithTitle:@"提示" message:@"上架简历才可刷新,确认上架?" superController:self cancelButtonTitle:@"取消" cancelAction:nil defaultButtonTitle:@"确认" defaultAction:^{
                NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
                WPShareModel *shareModel = [WPShareModel sharedModel];
                
//                NSString *action = (self.type == WPMainPositionTypeRecruit?@"ShelfRecruit":@"ShelfJobRelease");
//                NSString *resumeId = (self.type == WPMainPositionTypeRecruit?@"recruit_id":@"resume_id");
                
                NSDictionary *params = @{@"action":self.action,
                                         @"username":shareModel.username,
                                         @"password":shareModel.password,
                                         @"user_id":shareModel.dic[@"userid"],
                                         self.resume:self.resumeId};
                [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
                    if ([json[@"status"] integerValue]) {
                        [self rankingAction];
//                        NSLog(@"%@",describe(json));
//                        [MBProgressHUD showError:@"上架成功" toView:self.view];
//                        [MBProgressHUD showSuccess:@"上架成功" toView:self.view];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"delegateResumeSuccess" object:nil];
                        _isOrNot = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DEFRESHUPSUCCESS" object:nil];
                    }else{
                        [MBProgressHUD showError:@"上架失败" toView:self.view];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                
                
            }];

        }
        else
        {
         [self rankingAction];
        }
        
    }
    else{
        CGFloat pi = (M_PI *2) - (M_PI /15 *time);
        CGAffineTransform rotate= CGAffineTransformRotate(self.bigBtn.transform, pi);
        self.bigBtn.transform = rotate;
        [self rankingAction];
    }
    
}

- (void)rankingAction
{
    time = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ranking) userInfo:nil repeats:YES];
    reloading = YES;
}

- (void)ranking
{
    
    CGAffineTransform rotate= CGAffineTransformRotate(self.bigBtn.transform, M_PI/15);
    self.bigBtn.transform = rotate;
    time += 1;
    NSLog(@"%ld",time);
    if (time > 29) {
        [self.timer invalidate];
        reloading = NO;
        [[WPRefreshManager sharedManager]requestForReFreshsuccess:^(id json) {
            if ([json[@"status"] intValue]) {
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
                [self requestForSetData];
            }
        }];
    }
}








@end
