//
//  WPGroupIntroduceViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupIntroduceViewController.h"

@interface WPGroupIntroduceViewController ()

@end

@implementation WPGroupIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群介绍";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 64 + kHEIGHT(10), SCREEN_WIDTH - 2*kHEIGHT(10), SCREEN_HEIGHT - 64 - 2*kHEIGHT(10))];
    label.font = kFONT(15);
    label.numberOfLines = 0;
    label.text = self.introduce;
    [self.view addSubview:label];
    [label sizeToFit];
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
