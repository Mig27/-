//
//  MyApplyAndWantViewController.m
//  WP
//
//  Created by CC on 16/8/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "MyApplyAndWantViewController.h"
#import "WPPersonListModel.h"
#import "WPDraftListModel.h"
#import "WPCompanyModel.h"
#import "ApplyAndWantTableViewCell.h"
#import "NearPersonalController.h"
#import "ChattingMainViewController.h"
#import "ApplyAndWantDetailController.h"
#import "WPMySecurities.h"
@interface MyApplyAndWantViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray*datasource;
@property (assign, nonatomic) NSInteger page;
@property (nonatomic, strong)NearPersonalModel *orignalModel;
@property (nonatomic, strong)UIButton*doneButton;
@property (nonatomic, strong)UILabel*makeView;
@end

@implementation MyApplyAndWantViewController


#pragma mark 从消息内容界面发送简历和招聘
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    self.doneButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.doneButton];
//    [self requstData];
    
    
}
- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_doneButton setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        _doneButton.enabled = NO;
        _doneButton.selected = NO;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _doneButton.frame = CGRectMake(0, 0, 45, 45);
        _doneButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_doneButton setTitle:@"发送" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton addSubview:self.makeView];
    }
    return _doneButton;
}
#pragma mark 点击发送
-(void)rightBtnClick
{
    NSMutableArray * muarray = [[NSMutableArray alloc]init];
    for (NearPersonalListModel * model in self.datasource) {
        
        if (model.isSelected) {
            NSDictionary * dic = [NSDictionary dictionary];
            if (_myApply)
            {
               dic = @{@"qz_id":[NSString stringWithFormat:@"%@",model.resumeId],
                       @"qz_avatar":[NSString stringWithFormat:@"%@",model.avatar],
                       @"qz_position":[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",model.position] componentsSeparatedByString:@"："][1]],
                       @"qz_name":[NSString stringWithFormat:@"%@",model.nike_name],
                       @"qz_sex":[NSString stringWithFormat:@"%@",model.sex],
                       @"qz_age":[NSString stringWithFormat:@"%@",model.age],
                       @"qz_educaiton":[NSString stringWithFormat:@"%@",model.education],
                       @"qz_workTime":[NSString stringWithFormat:@"%@",model.worktime],
                       @"belong":[NSString stringWithFormat:@"%@",model.userId],
                       @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",model.nike_name.length?model.nike_name:@"",model.age.length?model.age:@"",model.sex.length?model.sex:@"",model.education.length?model.education:@"",model.worktime.length?model.worktime:@"",model.lightSpot.length?model.lightSpot:@""],
                       @"title":@""};
            }
            else
            {
                model.enterprise_brief = [WPMySecurities textFromBase64String:model.enterprise_brief];
                model.enterprise_brief = [WPMySecurities textFromEmojiString:model.enterprise_brief];
                dic = @{@"zp_id":[NSString stringWithFormat:@"%@",model.resumeId],
                        @"zp_position":[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",model.position] componentsSeparatedByString:@"："][1]],
                        @"zp_avatar":[NSString stringWithFormat:@"%@",model.avatar],
                        @"cp_name":[NSString stringWithFormat:@"%@",model.enterprise_name],
                        @"belong":[NSString stringWithFormat:@"%@",model.userId],
                        @"title":@"",
                        @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",model.enterprise_name.length?model.enterprise_name:@"",model.dataIndustry.length?model.dataIndustry:@"",model.enterprise_properties.length?model.enterprise_properties:@"",model.enterprise_scale.length?model.enterprise_scale:@"",model.enterprise_address.length?model.enterprise_address:@"",model.enterprise_brief.length?model.enterprise_brief:@""]};
            }
            [muarray addObject:dic];
        }
    }
    
    if (muarray.count > 20) {
        NSString * title = self.myApply?@"最多选择20个求职信息":@"最多选择20个招聘信息";
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[ChattingMainViewController shareInstance] sendMyApplyAndWant:muarray andApply:_myApply];
    NSArray * viewArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:viewArray[viewArray.count-2] animated:YES];
}
- (UILabel *)makeView
{
    if (!_makeView)
    {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-20, 12, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = RGB(0, 172, 255);
        self.makeView = makeView;
    }
    return _makeView;
}
-(NSMutableArray*)datasource
{
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc]init];
    }
    return _datasource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorColor = RGB(226, 226, 226);
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.tableFooterView = [[UIView alloc]init];
            tableView.tableHeaderView = [[UIView alloc]init];
            [self.view addSubview:tableView];
            WS(ws);
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _page = 1;
                [ws tableView:tableView requestWithPage:_page Sucess:^(NSArray *datas, int more) {
                    [tableView.mj_footer resetNoMoreData];
                    [self.datasource removeAllObjects];
                    [self.datasource addObjectsFromArray:datas];
                    [self.tableView reloadData];
                } Error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                [tableView.mj_header endRefreshing];
            }];
            [tableView.mj_header beginRefreshing];
            
            tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _page++;
                [ws tableView:tableView requestWithPage:_page Sucess:^(NSArray *datas, int more) {
                    if (more != 0) {
                        [self.datasource addObjectsFromArray:datas];
                        [tableView reloadData];
                    }else{
                        [tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } Error:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                }];
                
                [tableView.mj_footer endRefreshing];
            }];
            tableView;
        });
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView requestWithPage:(NSInteger)page Sucess:(DealsSuccessBlock)success Error:(DealsErrorBlock)serror
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/jobswanted.ashx"];
    NSString *action = (!_myApply?@"getjobs":@"swanted");
    NSString *resumeId = (!_myApply?@"ep_id":@"resume_user_id");
    
    NSDictionary *params = @{@"action":action,
                             @"guser_id":kShareModel.userId,
                             @"page":[NSString stringWithFormat:@"%d",(int)page],
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             resumeId:@"",
                             @"type":@"0",
                             @"pageSize":@"12"};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        NSArray * array = json[@"UserInfo"];
        if (page>1) {
            if (array.count) {
                _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
                for (NearPersonalListModel * model in _orignalModel.list) {
                    NSString *description1 = [WPMySecurities textFromBase64String:model.txtcontent];
                    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
                    if (description3.length) {
                        model.lightSpot = description3;
                    }
                }
                success(_orignalModel.list,(int)_orignalModel.list.count);
            }
            else
            {
               success(_orignalModel.list,0);
            }
        }
        else
        {
            _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
            for (NearPersonalListModel * model in _orignalModel.list) {
                NSString *description1 = [WPMySecurities textFromBase64String:model.txtcontent];
                NSString *description3 = [WPMySecurities textFromEmojiString:description1];
                if (description3.length) {
                    model.lightSpot = description3;
                }
            }
            success(_orignalModel.list,(int)_orignalModel.list.count);
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        serror(error);
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kHEIGHT(58);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * identifier = @"ApplyAndWantTableViewCell";
    ApplyAndWantTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ApplyAndWantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NearPersonalListModel * model = self.datasource[indexPath.row];
    cell.indexPath = indexPath;
    cell.choiseCell = ^(NSIndexPath * indexPath){
        [self changeSatte:indexPath];
    };
    [cell setListModel:model andApply:_myApply];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    ApplyAndWantDetailController * detail = [[ApplyAndWantDetailController alloc]init];
    NearPersonalListModel * model = self.datasource[indexPath.row];
    if (_myApply) {
        detail.isApply = YES;
        detail.subId = [NSString stringWithFormat:@"%@",model.resumeId];
        detail.listModel = model;
        detail.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@&isVisible=1",IPADDRESS,model.resumeId,kShareModel.userId];
        detail.title = @"我的求职";
    }else{
        detail.isApply = NO;
        detail.subId = [NSString stringWithFormat:@"%@",model.resumeId];
        detail.listModel = model;
        detail.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@&isVisible=1",IPADDRESS,model.resumeId,kShareModel.userId];
        detail.title = @"我的招聘";
    }
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(void)changeSatte:(NSIndexPath*)indexPath
{
     NearPersonalListModel * model = self.datasource[indexPath.row];
    model.isSelected = !model.isSelected;
//    [self.tableView reloadData];
    
  
    int num = 0;
    for (NearPersonalListModel * model1 in self.datasource) {
        if (model1.isSelected) {
            num ++;
        }
    }
    
    if (num == 0) {
        
        _doneButton.enabled = NO;
        _doneButton.selected = NO;
        _makeView.text = @"";
        _makeView.hidden = YES;
    }
    else
    {
        if (num > 20) {
            model.isSelected = NO;
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择20条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            num = 20;
//            [self.tableView reloadData];
          
        }
        else
        {
            _doneButton.enabled = YES;
            _doneButton.selected = YES;
            _makeView.text = [NSString stringWithFormat:@"%d",num];
            _makeView.hidden = NO;
            [self.makeView.layer removeAllAnimations];
            CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            scaoleAnimation.duration = 0.25;
            scaoleAnimation.autoreverses = YES;
            scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
            scaoleAnimation.fillMode = kCAFillModeForwards;
            [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
          
        }
        
        
//        _doneButton.enabled = YES;
//        _doneButton.selected = YES;
//        _makeView.text = [NSString stringWithFormat:@"%d",num];
//        _makeView.hidden = NO;
//        [self.makeView.layer removeAllAnimations];
//        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        scaoleAnimation.duration = 0.25;
//        scaoleAnimation.autoreverses = YES;
//        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
//        scaoleAnimation.fillMode = kCAFillModeForwards;
//        [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }
    
     [self.tableView reloadData];
 
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
