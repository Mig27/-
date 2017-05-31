//
//  WPRegisterViewController2-1.m
//  WP
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRegisterViewController2-1.h"//
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "WPRegisterViewController2.h"
#import "MacroDefinition.h"
#import "UISelectCity.h"

@interface WPRegisterViewController2_1 () <UISelectDelegate>



@end

@implementation WPRegisterViewController2_1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.titleLabel.font = GetFont(15);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:DefaultControlColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    UISelectCity *city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    city.delegate = self;
    city.isIndusty = self.isIndustry;
    city.isArea = self.isArea;
//    if (self.isArea) {
//        city.isArea = YES;
//    } else {
//        city.isArea = NO;
//    }
    if (self.arr) {
        [city setLocalData:self.arr];
    }else{
        [city setUrlStr:self.urlStr dictionary:self.params];
    }
    [self.view addSubview:city];
    
}

-(void)click
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)UISelectDelegate:(IndustryModel *)model
{
    if (self.delegate) {
        [self.delegate FuckTheSBcompanyDelegate:model];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
