//
//  WPFullTimeViewController.m
//  WP
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPFullTimeViewController.h" 
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "WPCategoryDetailController.h"
#import "WPIndustryViewController.h"
#import "WPIndustyCategoryModel.h"
#import "FTCategoryCell.h"
#import "DiscoverCell.h"
#import "UIImageView+WebCache.h"


@interface WPFullTimeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) TouchTableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray* dataSourceArray;


@end

@implementation WPFullTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
//    [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"新建"];
    
    _dataSourceArray=[[NSMutableArray alloc] init];
    
    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    _searchBar.placeholder=@"请输入关键字搜索职位";
    [self.view addSubview:_searchBar];
    
    [self.view addSubview:self.tableView];
   
    [self requestWIthCategory];
}

- (TouchTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TouchTableView alloc]initWithFrame:CGRectMake(0, 30+64, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}

- (void)requestWIthCategory{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    NSDictionary *dic = @{@"action":@"getIndustry",@"fatherid":@"0"};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        WPIndustyCategoryModel *model = [WPIndustyCategoryModel mj_objectWithKeyValues:json];
        [self.dataSourceArray addObjectsFromArray:model.list];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(43);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    DiscoverCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[DiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WPIndustyCategoryListModel *model = self.dataSourceArray[indexPath.row];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.address]];
    [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    cell.title.text = model.industryName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPIndustyCategoryListModel *model = self.dataSourceArray[indexPath.row];
    WPCategoryDetailController *industry = [[WPCategoryDetailController alloc]init];
    industry.title = model.industryName;
    industry.industryName = model.industryName;
    industry.industryId = model.industryID;
    [self.navigationController pushViewController:industry animated:YES];
}

@end
