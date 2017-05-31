//
//  jionGroupRejectViewController.m
//  WP
//
//  Created by CC on 16/9/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "jionGroupRejectViewController.h"

@interface jionGroupRejectViewController ()

@end

@implementation jionGroupRejectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(235, 235, 235);
    [self creatUI];
}
-(void)creatUI
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, kHEIGHT(78))];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
