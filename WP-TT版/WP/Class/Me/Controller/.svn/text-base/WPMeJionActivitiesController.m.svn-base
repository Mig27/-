//
//  WPMeJionActivitiesController.m
//  WP
//
//  Created by CBCCBC on 16/1/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeJionActivitiesController.h"
#import "NewNearActivityCell.h"
#import "WPMeActivityModel.h"

@interface WPMeJionActivitiesController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, assign) NSInteger page;

@end

@implementation WPMeJionActivitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我参与的活动";
    
    _page = 1;
    
    [self.tableView.mj_header beginRefreshing];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
        
        WS(ws);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
            [ws requestForActivityListWithPage:1 success:^(NSArray *datas, int more) {
                
                [ws.tableView.mj_footer resetNoMoreData];
                [ws.array removeAllObjects];
                [ws.array addObjectsFromArray:datas];
                [ws.tableView reloadData];
                
            } error:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
            [ws.tableView.mj_header endRefreshing];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
           [ws requestForActivityListWithPage:_page success:^(NSArray *datas, int more) {
               if (more == 0) {
                   [ws.tableView.mj_footer endRefreshingWithNoMoreData];
               }else{
                   [ws.array addObjectsFromArray:datas];
                   [ws.tableView reloadData];
               }
           } error:^(NSError *error) {
               _page--;
           }];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (void)requestForActivityListWithPage:(NSInteger)page success:(DealsSuccessBlock)success error:(DealsErrorBlock)dealError{
    
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    NSDictionary *params = @{@"action":@"GetMySign",
                             @"password":kShareModel.password,
                             @"username":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"page":[NSString stringWithFormat:@"%ld",page]
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
       
        WPMeActivityModel *model = [WPMeActivityModel mj_objectWithKeyValues:json];
        success(model.list,(int)model.list.count);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(98);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewNearActivityCell *cell = [NewNearActivityCell cellWithTableView:tableView];
    WPMeActivityListModel *model = self.array[indexPath.row];
    //    cell.titleLabel.text = model.title;
    NearActivityListModel *listModel = [[NearActivityListModel alloc]init];
    
    listModel.sid = model.game_id;
    listModel.show_img = model.show_img;
    listModel.title = model.title;
    listModel.bigen_time = model.bigen_time;
    listModel.address_2 = model.address;
    listModel.sign = model.signCount;
    
    cell.model = listModel;
    return cell;
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
