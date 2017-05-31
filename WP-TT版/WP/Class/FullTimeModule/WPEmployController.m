//
//  WPEmployController.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPEmployController.h"

#import "DiscoverCell.h"
#import "WPNewResumeController.h"
#import "WPNewSchoolController.h"
#import "WPNewSalaryController.h"
#import "WPTipModel.h"

@interface WPEmployController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *iconAndTitle;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WPEmployController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"全职";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
//    WPTipModel *model = [WPTipModel sharedManager];
    _iconAndTitle = @[
                      @[@{@"image" : @"mianshi",
                          @"title" : @"面试",
                          @"count" : @"",
                          @"avatar": @""
                          }],
                      @[@{@"image" : @"qiyezhaopin",
                          @"title" : @"企业招聘",
                          @"count" : @"",
                          @"avatar": @""
                          }]
//                      ,
//                      @[@{@"image" : @"hangyefenlei",
//                          @"title" : @"校园求职",
//                          @"count" : @"",
//                          @"avatar": @""
//                          },
//                        @{@"image" : @"xiaoyuanzhaopin",
//                          @"title" : @"校园招聘",
//                          @"count" : @"",
//                          @"avatar": @""
//                          }
//                        ]//,
                      //                      @[@{@"image" : @"xunqiuqianlima",
                      //                          @"title" : @"寻求千里马"
                      //                          },
                      //                        @{@"image" : @"maosuizijian",
                      //                          @"title" : @"毛遂自荐"
                      //                          }
                      //                          ]
                      ];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(235, 235, 235);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        {
            if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            
            if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
                [tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        }
        
        [self.view addSubview:tableView];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        tableView;
    });

}

- (void)messageTip
{
    WPTipModel *model = [WPTipModel sharedManager];
//    NSLog(@"message::%@",model.ReMsgCount);
    _iconAndTitle = @[
                      @[@{@"image" : @"mianshi",
                          @"title" : @"面试",
                          @"count" : model.ReMsgCount,//评论我的数字
                          @"avatar": model.re_com_avatar,//评论我的头像
                          @"publishAvatar":model.re_avatar.length?model.re_avatar:model.M_re_avatar//好友最新发布
                          }],
                      @[@{@"image" : @"qiyezhaopin",
                          @"title" : @"企业招聘",
                          @"count" : model.jobMsgCount,//评论我的个数
                          @"avatar": model.job_com_avatar,//评论我的头像
                          @"publishAvatar":model.job_avatar.length?model.job_avatar:model.M_job_avatar//最新发布
                          }]
//                      ,
//                      @[@{@"image" : @"hangyefenlei",
//                          @"title" : @"校园求职",
//                          @"count" : model.ReSchoolCount,
//                          @"avatar": model.re_School_avatar
//                          },
//                        @{@"image" : @"xiaoyuanzhaopin",
//                          @"title" : @"校园招聘",
//                          @"count" : model.JobSchoolCount,
//                          @"avatar": model.Job_School_avatar
//                          }
//                        ]//,
                      //                      @[@{@"image" : @"xunqiuqianlima",
                      //                          @"title" : @"寻求千里马"
                      //                          },
                      //                        @{@"image" : @"maosuizijian",
                      //                          @"title" : @"毛遂自荐"
                      //                          }
                      //                          ]
                      ];
    [_tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GlobalMessageTip" object:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _iconAndTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_iconAndTitle[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(43);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DiscoverCell";
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DiscoverCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *info = _iconAndTitle[indexPath.section][indexPath.row];
    cell.dic = info;
    return cell;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPNewResumeController *job = [[WPNewResumeController alloc] init];
    job.isIndustry = YES;
    if (indexPath.section == 0) {//点击跳到面试界面
        job.title = @"面试";
        job.type = WPMainPositionTypeInterView;
        [self.navigationController pushViewController:job animated:YES];
    }
    else if (indexPath.section == 1) {
        job.title = @"企业招聘";
        job.type = WPMainPositionTypeRecruit;
        [self.navigationController pushViewController:job animated:YES];
    }
    else if (indexPath.section == 2) {
        WPNewSchoolController *school = [[WPNewSchoolController alloc]init];
        if (indexPath.row == 0) {
            school.type = WPMainPositionTypeInterView;
            school.title = @"校园求职";
            [self.navigationController pushViewController:school animated:YES];
        } else if (indexPath.row == 1) {
            school.type = WPMainPositionTypeRecruit;
            school.title = @"校园招聘";
            [self.navigationController pushViewController:school animated:YES];
        }
    }
//    else if (indexPath.section == 3){
//        WPNewSalaryController *salary = [[WPNewSalaryController alloc]init];
//        if (indexPath.row == 0) {
//            salary.type = WPMainPositionTypeRecruit;
//            salary.title = @"寻找千里马";
//            [self.navigationController pushViewController:salary animated:YES];
//        } else if (indexPath.row == 1) {
//            salary.type = WPMainPositionTypeInterView;
//            salary.title = @"毛遂自荐";
//            [self.navigationController pushViewController:salary animated:YES];
//
//        }
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
