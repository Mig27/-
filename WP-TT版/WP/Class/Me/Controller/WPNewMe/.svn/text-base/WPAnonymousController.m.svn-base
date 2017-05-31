//
//  WPAnonymousController.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAnonymousController.h"
#import "AnonymousView.h"
#import "SetAnonymousController.h"
#import "AnonymousModel.h"
#import "AnonymousManager.h"
#import "CustomAnonymousController.h"

@interface WPAnonymousController ()<AnonymousManagerDelegate,CustomAnonymousControllerDelegate>
@property (nonatomic ,strong)UIButton *next;
@property (nonatomic, strong)AnonymousView *anonymousView;
@end

@implementation WPAnonymousController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"匿名信息";
    self.view.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:self.next];
    [self.view addSubview:self.anonymousView];
//    [AnonymousManager shareManager].delegate = self;
    [self requestForData];
}

- (void)requestForData
{
    WS(ws);
    [AnonymousManager sharedManager].reload = ^(AnonymousModel *model){
        [ws reloadData];
    };
    [[AnonymousManager sharedManager]getAnonymityInfo];
    
}

- (void)reloadData
{
    self.anonymousView.model = [AnonymousManager sharedManager].model;
}

- (UIButton *)next
{
    if (!_next) {
        self.next = [UIButton buttonWithType:UIButtonTypeCustom];
        self.next.frame = CGRectMake(0, 15+64, SCREEN_WIDTH, kHEIGHT(43));
        self.next.backgroundColor = [UIColor whiteColor];
        [self.next addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, kHEIGHT(14), SCREEN_WIDTH, kHEIGHT(15))];
        label.text = @"设置匿名信息";
        [self.next addSubview:label];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, kHEIGHT(14), kHEIGHT(8), kHEIGHT(15))];
        image.image = [UIImage imageNamed:@"jinru"];
        [self.next addSubview:image];
    }
    return _next;
}

- (AnonymousView *)anonymousView
{
    if (!_anonymousView) {
        CGFloat height = 64+15+kHEIGHT(43)+10;
        self.anonymousView = [[AnonymousView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _anonymousView;
}

- (void)buttonAction:(UIButton *)sender
{
    SetAnonymousController *VC = [[SetAnonymousController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

@end
