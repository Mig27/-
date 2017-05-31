//
//  WPResumeCheckApplyListController.m
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPResumeCheckApplyListController.h"
#import "WPResumeCheckApplyModel.h"
#import "UITableView+EmptyData.h"
#import "WPResumeCheckApplyCell.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPInterviewApplyChooseController.h"
#import "WPInterviewApplyController.h"
#import "WPRecruitApplyChooseModel.h"
#import "WPRecruitApplyChooseController.h"
#import "WPRecruitApplyController.h"
#import "SPButton.h"

@interface WPResumeCheckApplyListController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) TouchTableView *applyTableView;
@property (strong, nonatomic) UIView *bottomApplyView;

@property (strong, nonatomic) NSMutableArray *applyArray;
@property (assign, nonatomic) NSInteger applyPage;

@end

@implementation WPResumeCheckApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _applyPage = 1;
    [self.view addSubview:self.applyTableView];
    [self.applyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)applyArray{
    if (!_applyArray) {
        _applyArray = [[NSMutableArray alloc]init];
    }
    return _applyArray;
}

- (TouchTableView *)applyTableView{
    if (!_applyTableView) {
        _applyTableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _applyTableView.delegate = self;
        _applyTableView.dataSource = self;
        _applyTableView.backgroundColor = [UIColor whiteColor];
        _applyTableView.tableFooterView = [[UIView alloc]init];
        WS(ws);
        _applyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requestApplyList:1 success:^(NSArray *datas, int more) {
                [ws.applyTableView.mj_footer resetNoMoreData];
                [ws.applyArray removeAllObjects];
                [ws.applyArray addObjectsFromArray:datas];
                [ws.applyTableView reloadData];
            } error:^(NSError *error) {
            }];
            [ws.applyTableView.mj_header endRefreshing];
        }];
        
        [_applyTableView.mj_header beginRefreshing];
        
        _applyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _applyPage++;
            [ws requestApplyList:_applyPage success:^(NSArray *datas, int more) {
                if (more) {
                    [ws.applyArray addObjectsFromArray:datas];
                    [ws.applyTableView reloadData];
                }else{
                    [ws.applyTableView.mj_footer endRefreshingWithNoMoreData];
                }
            } error:^(NSError *error) {
                _applyPage--;
            }];
        }];
    }
    return _applyTableView;
}

- (void)requestApplyList:(NSInteger)page success:(DealsSuccessBlock)dealsSuccess error:(DealsErrorBlock)dealsError{
    NSString *str = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetShare",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.dic[@"userid"],@"page":@(page),_isRecruit?@"job_id":@"resume_id":_resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPResumeCheckApplyModel *model = [WPResumeCheckApplyModel mj_objectWithKeyValues:json];
        dealsSuccess(model.signList,(int)model.signList.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitMsg:@"暂无分享信息" ifNecessaryForRowCount:self.applyArray.count];
    return self.applyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"WPResumeCheckApplyCell";
    WPResumeCheckApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPResumeCheckApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.listModel = self.applyArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
