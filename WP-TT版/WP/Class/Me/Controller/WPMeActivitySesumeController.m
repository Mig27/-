//
//  WPMeActivitySesumeController.m
//  WP
//
//  Created by CBCCBC on 16/1/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeActivitySesumeController.h"
#import "NearPersonalController.h"
#import "NearPersonalCell.h"
#import "NearMeCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "NearInterViewController.h"
#import "UITableView+EmptyData.h"

#import "WPInterviewApplyCompanyController.h"

@interface WPMeActivitySesumeController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *baseView;

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;

@property (nonatomic, strong) UIView *bottomView;
@property (strong, nonatomic) UIView *indicatorView;

@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *dataOne;
@property (nonatomic, strong) NSMutableArray *dataTwo;


@property (nonatomic, strong) NearPersonalModel *orignalModel;
@property (nonatomic, strong) NearPersonalModel *orignalModelOne;
@property (nonatomic, strong) NearPersonalModel *orignalModelTwo;


@property (assign, nonatomic) NSInteger page;
@property (nonatomic, assign) NSInteger pageOne;
@property (nonatomic, assign) NSInteger pageTwo;

@property (nonatomic, assign) NSInteger bottomType;

@end

@implementation WPMeActivitySesumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我发布的活动";
    
    _page = 1;
    _pageOne = 1;
    _pageTwo = 1;
    _bottomType = 1;
    
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.indicatorView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)baseView{
    if (!_baseView) {
        _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        _baseView.pagingEnabled = YES;
        _baseView.delegate = self;
        _baseView.contentSize = CGSizeMake(SCREEN_WIDTH*3, _baseView.height);
        _baseView.showsHorizontalScrollIndicator = NO;
        [_baseView addSubview:self.tableView];
        [_baseView addSubview:self.tableViewOne];
        [_baseView addSubview:self.tableViewTwo];
    }
    return _baseView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,self.baseView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.tableHeaderView = self.headView;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) unself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            [unself tableView:_tableView requestWithPage:1 Sucess:^(NSArray *datas, int more) {
                [unself.data removeAllObjects];
                [unself.data addObjectsFromArray:datas];
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
            }];
            [unself.tableView.mj_header endRefreshing];
        }];
        
        [_tableView.mj_header beginRefreshing];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself tableView:_tableView requestWithPage:_page Sucess:^(NSArray *datas, int more) {
                if (more == 0) {
                    [unself.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [unself.data addObjectsFromArray:datas];
                    [unself.tableView reloadData];
                }
            } Error:^(NSError *error) {
                _page--;
            }];
            [unself.tableView.mj_footer endRefreshing];
        }];
        
    }
    return _tableView;
}

-(UITableView *)tableViewOne
{
    if (!_tableViewOne) {
        _tableViewOne = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.baseView.height) style:UITableViewStylePlain];
        _tableViewOne.delegate = self;
        _tableViewOne.dataSource = self;
        //        _tableView.tableHeaderView = self.headView;
        _tableViewOne.allowsSelection = NO;
        _tableViewOne.tableFooterView = [[UIView alloc]init];
        _tableViewOne.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) unself = self;
        _tableViewOne.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableViewOne.mj_footer resetNoMoreData];
            [unself tableView:_tableViewOne requestWithPage:1 Sucess:^(NSArray *datas, int more) {
                [unself.dataOne removeAllObjects];
                [unself.dataOne addObjectsFromArray:datas];
                [unself.tableViewOne reloadData];
            } Error:^(NSError *error) {
            }];
            [unself.tableViewOne.mj_header endRefreshing];
        }];
        
        [_tableViewOne.mj_header beginRefreshing];
        
        _tableViewOne.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageOne++;
            [unself tableView:_tableViewOne requestWithPage:_pageOne Sucess:^(NSArray *datas, int more) {
                if (more == 0) {
                    [unself.tableViewOne.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [unself.dataOne addObjectsFromArray:datas];
                    [unself.tableViewOne reloadData];
                }
            } Error:^(NSError *error) {
                _pageOne--;
            }];
            [unself.tableViewOne.mj_footer endRefreshing];
        }];
        
    }
    return _tableViewOne;
}

-(UITableView *)tableViewTwo
{
    if (!_tableViewTwo) {
        _tableViewTwo = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, self.baseView.height) style:UITableViewStylePlain];
        _tableViewTwo.delegate = self;
        _tableViewTwo.dataSource = self;
        //        _tableView.tableHeaderView = self.headView;
        _tableViewTwo.allowsSelection = NO;
        _tableViewTwo.tableFooterView = [[UIView alloc]init];
        _tableViewTwo.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) unself = self;
        _tableViewTwo.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableViewTwo.mj_footer resetNoMoreData];
            [unself tableView:_tableViewTwo requestWithPage:1 Sucess:^(NSArray *datas, int more) {
                [unself.dataTwo removeAllObjects];
                [unself.dataTwo addObjectsFromArray:datas];
                [unself.tableViewTwo reloadData];
            } Error:^(NSError *error) {
            }];
            [unself.tableViewTwo.mj_header endRefreshing];
        }];
        
        [_tableViewTwo.mj_header beginRefreshing];
        
        _tableViewTwo.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageTwo++;
            [unself tableView:_tableViewTwo requestWithPage:_pageTwo Sucess:^(NSArray *datas, int more) {
                if (more == 0) {
                    [unself.tableViewTwo.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [unself.dataOne addObjectsFromArray:datas];
                    [unself.tableViewTwo reloadData];
                }
            } Error:^(NSError *error) {
                _pageTwo--;
            }];
            [unself.tableViewTwo.mj_footer endRefreshing];
        }];
        
    }
    return _tableViewTwo;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, BOTTOMHEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        NSArray *arr = @[@"已上架",@"已下架",@"被下架"];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, BOTTOMHEIGHT);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:RGB(10, 110, 210) forState:UIControlStateSelected];
            button.titleLabel.font = kFONT(15);
            button.tag = 30+i;
            i == 0?button.selected = YES:0;
            if (i!=2) {
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*SCREEN_WIDTH/3-0.5, BOTTOMHEIGHT/2-7.5, 0.5, 15)];
                line.backgroundColor = RGB(178, 178, 178);
                [_bottomView addSubview:line];
            }
            [button addTarget:self action:@selector(bottomExampleClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
        }
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-3, SCREEN_WIDTH/3, 3)];
        _indicatorView.backgroundColor = RGB(10, 110, 210);
    }
    return _indicatorView;
}

-(NSMutableArray *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}

-(NSMutableArray *)dataOne
{
    if (!_dataOne) {
        _dataOne = [[NSMutableArray alloc]init];
    }
    return _dataOne;
}

-(NSMutableArray *)dataTwo
{
    if (!_dataTwo) {
        _dataTwo = [[NSMutableArray alloc]init];
    }
    return _dataTwo;
}

-(void)tableView:(UITableView *)tableView requestWithPage:(NSInteger)page Sucess:(DealsSuccessBlock)success Error:(DealsErrorBlock)serror
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *type = @"";
    if (tableView == self.tableView) {
        type = @"1";
    }
    if (tableView == self.tableViewOne) {
        type = @"2";
    }
    if (tableView == self.tableViewTwo) {
        type = @"3";
    }
    NSDictionary *params = @{@"action":@"GetMyGame",
                             @"guser_id":kShareModel.userId,
                             @"page":[NSString stringWithFormat:@"%d",(int)page],
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":model.dic[@"userid"],
                             @"type":type};
    
    //    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        //        [MBProgressHUD hideHUDForView:self.view];
        
        if (tableView == self.tableView) {
            _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
            success(_orignalModel.list,(int)_orignalModel.list.count);
        }
        if (tableView == self.tableViewOne) {
            _orignalModelOne = [NearPersonalModel mj_objectWithKeyValues:json];
            success(_orignalModelOne.list,(int)_orignalModelOne.list.count);
        }
        if (tableView == self.tableViewTwo) {
            _orignalModelTwo = [NearPersonalModel mj_objectWithKeyValues:json];
            success(_orignalModelTwo.list,(int)_orignalModelTwo.list.count);
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error.localizedDescription);
        serror(error);
    }];
}

- (void)bottomExampleClick:(UIButton *)sender{
    for (int i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i+30];
        button.selected = (button.tag == sender.tag?YES:NO);
    }
    
    _bottomType = sender.tag-30+1;
    
    [self.baseView setContentOffset:CGPointMake(SCREEN_WIDTH*(sender.tag-30), 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.left = (sender.tag-30)*SCREEN_WIDTH/3;
    }];
}

- (void)getInterviewApplyCompanyInfo:(NSString *)epId{
    NSLog(@"%@",epId);
}

//-(void)requestForInfo
//{
//    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/jobswanted.ashx"];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSDictionary *params = @{@"action":@"getuserinfeo",@"guser_id":self.userId,@"user_id":model
//                             .dic[@"userid"]};
//    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
//        _infoModel = [NearInfoModel objectWithKeyValues:json];
//        NSURL *urlStr = [NSURL URLWithString:[IPADDRESS stringByAppendingString:json[@"avatar"]]];
//        [_headImageV sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"head_default"]];
//        _nameLabel.text = json[@"nick_name"];
//        _positionLabel.text = json[@"position"];
//        _companyLabel.text = json[@"company"];
//        self.title = json[@"nick_name"];
//
//        CGSize size = [json[@"position"] getSizeWithFont:15 Height:15];
//        _positionLabel.width = size.width+10;
//        _companyLabel.frame = CGRectMake(_positionLabel.right, 40, SCREEN_WIDTH-_positionLabel.right, 15);
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.tableView) {
        [tableView tableViewDisplayWitMsg:@"暂无活动信息" ifNecessaryForRowCount:self.data.count];
        count = self.data.count;
    }
    
    if (tableView == self.tableViewOne) {
        [tableView tableViewDisplayWitMsg:@"暂无活动信息" ifNecessaryForRowCount:self.dataOne.count];
        count = self.dataOne.count;
    }
    
    if (tableView == self.tableViewTwo) {
        [tableView tableViewDisplayWitMsg:@"暂无活动信息" ifNecessaryForRowCount:self.dataTwo.count];
        count = self.dataTwo.count;
    }
    
    return count;
    //    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (self.isSelf) {
    return [NearMeCell cellHeight];
    //}
    //return [NearPersonalCell cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    static NSString *cellId = @"NearMeCellId";
    NearMeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        //            cell = [[NSBundle mainBundle]loadNibNamed:@"NearMeCell" owner:self options:nil].lastObject;
        cell = [[NearMeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.tag = indexPath.row+10;
    cell.NearMeBlock = ^(NSInteger tag){
        [weakSelf checkInterview:tag];
    };
    cell.NearOperationBlock = ^(NSInteger tag,NSInteger operationNum){
        [weakSelf operationActions:tag operation:operationNum];
    };
    
    NearPersonalModel *nearModel = [[NearPersonalModel alloc]init];
    if (tableView == self.tableView) {
        nearModel = _orignalModel;
    }
    if (tableView == self.tableViewOne) {
        nearModel = _orignalModelOne;
    }
    if (tableView == self.tableViewTwo) {
        nearModel = _orignalModelTwo;
    }
    
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:nearModel.avatar]];
    [cell.headImageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    cell.positionLabel1.text = nearModel.position;
    cell.companyLabel1.text = nearModel.company;
    cell.nameLabel1.text = nearModel.nick_name;
    
    CGSize size = [nearModel.position getSizeWithFont:FUCKFONT(12) Height:cell.positionLabel1.height];
    cell.positionLabel1.width = size.width;
    cell.line.left = cell.positionLabel1.right+10;
    cell.companyLabel1.left = cell.line.right+10;
    
    
    NearPersonalListModel *model = [[NearPersonalListModel alloc]init];
    if (tableView == self.tableView) {
        model = self.data[indexPath.row];
    }
    if (tableView == self.tableViewOne) {
        model = self.dataOne[indexPath.row];
    }
    if (tableView == self.tableViewTwo) {
        model = self.dataTwo[indexPath.row];
    }
    
    cell.contentLabel1.text = model.position;
    cell.time = model.updateTime;
    
    NSURL *url1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [cell.contentImageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    if (model.game_type == 1) {
      cell.contentDetailLabel1.text = @"1";
    }
    if (model.game_type == 2) {
        cell.contentDetailLabel1.text = @"2";
    }
    if (model.game_type == 3) {
        cell.contentDetailLabel1.text = @"3";
    }
    if (model.game_type == 4) {
        cell.contentDetailLabel1.text = @"4";
    }
    
//    [cell.sysButton1 setTitle:model.ranking forState:UIControlStateNormal];
    
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"留言 : %@",model.sysMessage]];
//    //设置：在0-3个单位长度内的内容显示成红色
//    [str1 addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:NSMakeRange(0, 5)];
//    cell.messageLabel1.titleLabel.attributedText = str1;
//    
//    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"报名 : %@",model.signUp]];
//    //设置：在0-3个单位长度内的内容显示成红色
//    [str2 addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:NSMakeRange(0, 5)];
//    cell.applyLabel1.titleLabel.attributedText = str2;
//    
//    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"浏览 : %@",model.resumeId]];
//    //设置：在0-3个单位长度内的内容显示成红色
//    [str3 addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:NSMakeRange(0, 5)];
//    cell.broweLabel1.titleLabel.attributedText = str3;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)checkInterview:(NSInteger)num{
    NearInterViewController *interView = [[NearInterViewController alloc]init];
    interView.isRecuilist = 0;
    [self.navigationController pushViewController:interView animated:YES];
    NearPersonalListModel *model = [[NearPersonalListModel alloc]init];
    
    if (_bottomType == 1) {
        model = self.data[num];
    }
    if (_bottomType == 2) {
        model = self.dataOne[num];
    }
    if (_bottomType == 3) {
        model = self.dataTwo[num];
    }
    
    interView.subId = model.resumeId;
    WPShareModel *shareModel = [WPShareModel sharedModel];
    interView.isSelf = [shareModel.dic[@"userid"] isEqualToString:model.userId];
    //NSString *recruitStr = [NSString stringWithFormat:@"/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    //NSString *interviewStr = [NSString stringWithFormat:@"/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    
    interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,@"活动"];
}

- (void)operationActions:(NSInteger)tag operation:(NSInteger)operationNum{
    switch (operationNum) {
        case 0:
            [self deleteInterview:tag];
            break;
        case 1:
            NSLog(@"编辑");
            [self editInterview:tag];
            break;
        case 2:
            NSLog(@"刷新");
            [self refreshInterview:tag];
            break;
        case 3:
            NSLog(@"下架");
            [self shelfInterview:tag];
            break;
        case 4:
            NSLog(@"推广");
            [self ExtensionInterview:tag];
            break;
        default:
            break;
    }
}

- (void)deleteInterview:(NSInteger)tag{
    NearPersonalListModel *model = [[NearPersonalListModel alloc]init];
    
    if (_bottomType == 1) {
        model = self.data[tag];
    }
    if (_bottomType == 2) {
        model = self.dataOne[tag];
    }
    if (_bottomType == 3) {
        model = self.dataTwo[tag];
    }
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"",
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             @"":model.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            [self.tableView.mj_header beginRefreshing];
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)editInterview:(NSInteger)tag{
    
}

- (void)refreshInterview:(NSInteger)tag{
    NearPersonalListModel *model = [[NearPersonalListModel alloc]init];
    
    if (_bottomType == 1) {
        model = self.data[tag];
    }
    if (_bottomType == 2) {
        model = self.dataOne[tag];
    }
    if (_bottomType == 3) {
        model = self.dataTwo[tag];
    }
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    
    NSDictionary *params = @{@"action":@"",
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             @"":model.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            [self.tableView.mj_header beginRefreshing];
            [MBProgressHUD showSuccess:@"刷新成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)shelfInterview:(NSInteger)tag{
    NearPersonalListModel *model = [[NearPersonalListModel alloc]init];
    
    if (_bottomType == 1) {
        model = self.data[tag];
    }
    if (_bottomType == 2) {
        model = self.dataOne[tag];
    }
    if (_bottomType == 3) {
        model = self.dataTwo[tag];
    }
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    
    NSDictionary *params = @{@"action":@"",
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             @"":model.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            NSLog(@"%@",describe(json));
            [self.tableView.mj_header beginRefreshing];
            [MBProgressHUD showSuccess:@"下架成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)ExtensionInterview:(NSInteger)tag{
    NearPersonalListModel *model = [[NearPersonalListModel alloc]init];
    
    if (_bottomType == 1) {
        model = self.data[tag];
    }
    if (_bottomType == 2) {
        model = self.dataOne[tag];
    }
    if (_bottomType == 3) {
        model = self.dataTwo[tag];
    }
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    
    NSDictionary *params = @{@"action":@"",
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             @"":model.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            NSLog(@"%@",describe(json));
            [self.tableView.mj_header beginRefreshing];
            [MBProgressHUD showSuccess:@"推广成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.baseView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.left = targetContentOffset->x/3;
        }];
        _bottomType = targetContentOffset->x/SCREEN_WIDTH+1;
        
        for (int i = 0; i < 3; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:30+i];
            button.selected = (i+1 == _bottomType?YES:NO);
        }
    }
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
