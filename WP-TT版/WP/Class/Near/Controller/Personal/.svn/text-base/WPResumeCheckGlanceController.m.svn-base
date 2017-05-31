//
//  WPResumeCheckGlanceController.m
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPResumeCheckGlanceController.h"
#import "WPResumeCheckApplyModel.h"
#import "WPResumeCheckApplyCell.h"
#import "UITableView+EmptyData.h"

@interface WPResumeCheckGlanceController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) TouchTableView *glanceTableView;
@property (strong, nonatomic) NSMutableArray *glanceArray;
@property (assign, nonatomic) NSInteger glancePage;

@end

@implementation WPResumeCheckGlanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    _glancePage = 1;
    [self.view addSubview:self.glanceTableView];
    [self.glanceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)glanceArray{
    if (!_glanceArray) {
        _glanceArray = [[NSMutableArray alloc]init];
    }
    return _glanceArray;
}

- (TouchTableView *)glanceTableView{
    if (!_glanceTableView) {
        _glanceTableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _glanceTableView.delegate = self;
        _glanceTableView.dataSource = self;
        _glanceTableView.backgroundColor = [UIColor whiteColor];
        _glanceTableView.tableFooterView = [[UIView alloc]init];
        WS(ws);
        _glanceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requestCommitList:1 success:^(NSArray *datas, int more) {
                [ws.glanceTableView.mj_footer resetNoMoreData];
                [ws.glanceArray removeAllObjects];
                [ws.glanceArray addObjectsFromArray:datas];
                [ws.glanceTableView reloadData];
            } error:^(NSError *error) {
            }];
            [ws.glanceTableView.mj_header endRefreshing];
        }];
        
        [_glanceTableView.mj_header beginRefreshing];
        
        _glanceTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _glancePage++;
            [ws requestCommitList:_glancePage success:^(NSArray *datas, int more) {
                if (more) {
                    [ws.glanceArray addObjectsFromArray:datas];
                    [ws.glanceTableView reloadData];
                }else{
                    [ws.glanceTableView.mj_footer endRefreshingWithNoMoreData];
                }
            } error:^(NSError *error) {
                _glancePage--;
            }];
        }];
    }
    return _glanceTableView;
}

- (void)requestCommitList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetBrowseList",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.dic[@"userid"],@"page":@(page),_isRecruit?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        dealsSuccess(model.browseList,(int)model.browseList.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.glanceArray.count];
    return self.glanceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"WPResumeCheckApplyCell";
    WPResumeCheckApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPResumeCheckApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.listModel = self.glanceArray[indexPath.row];
    return cell;
}

@end
