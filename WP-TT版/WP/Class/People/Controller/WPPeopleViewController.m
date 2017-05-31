//
//  WPPeopleViewController.m
//  WP
//  WP


//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleViewController.h"
#import "MRCommonGroup.h"
#import "MRCommonArrowItem.h"
#import "MRCommonCell.h"
#import "WPPeopleNearViewController.h"
#import "WPPeopleConnectionViewController.h"
#import "WPPeopleActivityViewController.h"
#import "WPPeopleWorkViewController.h"
#import "WPPeopleRevolutionViewController.h"
#import "WPPeopleInviteViewController.h"
#import "MacroDefinition.h"

@interface WPPeopleViewController ()

@end

@implementation WPPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脉圈";
    // 初始化模型数据
    [self setupItems];
    self.tableView.backgroundColor = WPColor(235, 235, 235);


//    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [right setImage:[UIImage imageNamed:@"黑色搜索"] forState:UIControlStateNormal];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:right];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
}


-(void)setupItems
{
    /** 0组 */
    [self setupGroup0];
    
    /** 1组 */
    [self setupGroup1];
    
    /** 2组 */
    [self setupGroup2];
    
    [self setupGroup3];
    [self setupGroup4];
    [self setupGroup5];
    
}

- (void)setupGroup0
{
    MRCommonGroup *group0 = [self addGroup];
    
    MRCommonArrowItem *one = [MRCommonArrowItem itemWithTitle:@"附近" icon:@"附近"];
    
    WPPeopleNearViewController *peopleNear = [[WPPeopleNearViewController alloc] init];
    one.destVc = [peopleNear class];
    
    group0.items = @[one];
}

/**
 *  1组
 */
- (void)setupGroup1
{
    MRCommonArrowItem *two = [MRCommonArrowItem itemWithTitle:@"人脉" icon:@"人脉圈"];

    WPPeopleConnectionViewController *connection = [[WPPeopleConnectionViewController alloc] init];
    two.destVc = [connection class];
    
    MRCommonGroup *group1 = [self addGroup];
    group1.items = @[two];
}

/**
 *  2组
 */
- (void)setupGroup2
{
    MRCommonGroup *group2 = [self addGroup];
    MRCommonArrowItem *three = [MRCommonArrowItem itemWithTitle:@"职场群" icon:@"粉丝"];
    MRCommonArrowItem *four = [MRCommonArrowItem itemWithTitle:@"附近的活动" icon:@"附近的活动"];
    WPPeopleWorkViewController *work = [[WPPeopleWorkViewController alloc] init];
    WPPeopleActivityViewController *activity = [[WPPeopleActivityViewController alloc] init];
    three.destVc = [work class];
    four.destVc = [activity class];
    group2.items = @[three,four];
}

- (void)setupGroup3
{
    
    MRCommonGroup *group3 = [self addGroup];
    
    MRCommonArrowItem *five = [MRCommonArrowItem itemWithTitle:@"关系" icon:@"关系"];
    
    WPPeopleRevolutionViewController *revolution = [[WPPeopleRevolutionViewController alloc] init];
    five.destVc = [revolution class];

    group3.items = @[five];
    
    
}

-(void)setupGroup4
{
    MRCommonGroup *group4 = [self addGroup];
    MRCommonArrowItem *six = [MRCommonArrowItem itemWithTitle:@"邀请好友" icon:@"邀请"];

    WPPeopleInviteViewController *invite = [[WPPeopleInviteViewController alloc] init];
    six.destVc = [invite class];
    group4.items = @[six];
}

-(void)setupGroup5
{
    MRCommonGroup *group4 = [self addGroup];
    MRCommonArrowItem *seven = [MRCommonArrowItem itemWithTitle:@"黑名单" icon:@"矢量智能对象"];
    
    group4.items = @[seven];
}


- (void)rightBarButtonClick
{
    NSLog(@"rightBarButtonClick");
}


@end
