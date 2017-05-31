//
//  WPMeActivityController.m
//  WP
//
//  Created by CBCCBC on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeActivityController.h"
#import "WPMeRecruitController.h"
#import "WPMeActivitiesCell.h"
#import "WPMeActivitySesumeController.h"
#import "WPMeJionActivitiesController.h"

@interface WPMeActivityController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation WPMeActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的活动";
    
    NSArray *array = @[@{@"name":@"我发布的活动",
                         @"icon":@"me_wofabudehuodong",
                         @"recruitCount":@"0"},
                       @{@"name":@"我参与的活动",
                         @"icon":@"me_wodebaoming",
                         @"recruitCount":@"0"}];
    for (int i = 0; i < array.count; i++) {
        WPMeRecruitModel *model = [WPMeRecruitModel mj_objectWithKeyValues:array[i]];
        [self.array addObject:model];
    }
    
    [self.tableView reloadData];
    [self requestForCount];
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)requestForCount{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    NSDictionary *params = @{@"action":@"GetGameCount",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            NSArray *array = @[json[@"gameCount"],json[@"signCount"]];
            for (int i = 0; i < self.array.count; i++) {
                WPMeRecruitModel *model = self.array[i];
                model.recruitCount = array[i];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(43);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"WPMeActivitiesCell";
    WPMeActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPMeActivitiesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    WPMeRecruitModel *model = self.array[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:model.icon];
    cell.titleLabel.text = model.name;
    cell.countLabel.text = model.recruitCount;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        WPMeActivitySesumeController *resume = [[WPMeActivitySesumeController alloc]init];
        [self.navigationController pushViewController:resume animated:YES];
    }
    if (indexPath.row == 1) {
        WPMeJionActivitiesController *join = [[WPMeJionActivitiesController alloc]init];
        [self.navigationController pushViewController:join animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
