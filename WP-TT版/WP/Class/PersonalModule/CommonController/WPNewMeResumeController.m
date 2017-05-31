//
//  WPNewMeResumeController.m
//  WP
//
//  Created by CBCCBC on 16/1/29.
//  Copyright © 2016年 WP. All rights reserved.
//  

#import "WPNewMeResumeController.h"
#import "NearPersonalController.h"
#import "NearPersonalCell.h"
#import "NearMeCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "NearInterViewController.h"
#import "UITableView+EmptyData.h"

#import "WPInterviewApplyCompanyController.h"
#import "WPInterviewController.h"
#import "WPRecruitController.h"
#import "SPSelectView.h"
#import "YYSelectView.h"
#import "WPDraftListModel.h"
#import "WPCompanyModel.h"
#import "WPNewCheckController.h"
#import "WPRecruitDraftEditController.h"
#import "WPInterviewDraftEditController.h"
#import "WPInterviewDraftInfoModel.h"
#import "WPNewsViewController.h"
#import "HJCActionSheet.h"
#import "WPPersonListModel.h"
#import "PersonalInfoViewController.h"
#import "MTTDatabaseUtil.h"
#import "WPApplyAndInviteTableViewCell.h"
@interface WPNewMeResumeController ()

#define ChooseViewHeight kHEIGHT(32)

<
UITableViewDelegate,
UITableViewDataSource,
HJCActionSheetDelegate
>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *chooseView;

@property (strong, nonatomic) NSMutableArray *data;

@property (assign, nonatomic) NSInteger page;

@property (nonatomic, strong) NearPersonalModel *orignalModel;
@property (nonatomic, strong) NearPersonalModel *nilModel;

@property (copy, nonatomic) NSString *resumeType;
@property (copy, nonatomic) NSString *resumeId;

@property (assign, nonatomic) NSInteger allSelectedItem;
@property (assign, nonatomic) NSInteger singleSelectedItem;

@end

@implementation WPNewMeResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = ((self.type == WPNewMeResumeTypeRecruit)?@"我发布的招聘":@"我发布的求职");
    _resumeType = @"4";//@"0"
    _resumeId = @"";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    _allSelectedItem = 0;
    _singleSelectedItem = 0;
    
    [self chooseView];
  //  [self tableView];
    
    
    if (self.type == WPNewMeResumeTypeInterview) {
        [[MTTDatabaseUtil instance] getMyApply:^(NSDictionary *json) {
            if (json) {
                _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:_orignalModel.list];
                [self.tableView reloadData];
            }
            else
            {
               [self tableView];
            }
            
        }];
    }
    else
    {
        
        [[MTTDatabaseUtil instance] getMyInvite:^(NSDictionary *dic) {
            if (dic) {
                _orignalModel = [NearPersonalModel mj_objectWithKeyValues:dic];
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:_orignalModel.list];
                [self.tableView reloadData];
            }
            else
            {
               [self tableView];
            }
            
        }];
      //[self tableView];
    }
    
    
}

- (void)rightBtnClick
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"消息列表", nil];
    [sheet show];
//    WPNewsViewController *news = [[WPNewsViewController alloc] init];
//    if (self.type == WPNewMeResumeTypeInterview) {
//        news.type = NewsTypeResume;
//    } else {
//        news.type = NewsTypeInvite;
//    }
//    news.isComeFromePersonal = YES;
//    [self.navigationController pushViewController:news animated:YES];
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        WPNewsViewController *news = [[WPNewsViewController alloc] init];
        if (self.type == WPNewMeResumeTypeInterview) {
            news.type = NewsTypeResume;
        } else {
            news.type = NewsTypeInvite;
        }
        news.isComeFromePersonal = YES;
        [self.navigationController pushViewController:news animated:YES];
    }
   
}
- (NSMutableArray *)data{
    if (!_data) {
        _data  = [[NSMutableArray alloc]init];
    }
    return _data;
}

- (NearPersonalModel *)orignalModel{
    if (!_orignalModel) {
        _orignalModel = [[NearPersonalModel alloc]init];
    }
    return _orignalModel;
}

- (UIView *)chooseView{
    if (!_chooseView) {
        _chooseView = ({
            
            UIView *view = [UIView new];
            view.backgroundColor =[UIColor whiteColor];
            
            [self.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_topLayoutGuideBottom);
                make.left.width.equalTo(self.view);
                make.height.mas_equalTo(ChooseViewHeight);
            }];
            
            UIButton *leftButton = ({
                
                UIButton *button = [UIButton new];
                button.tag = 101;
                button.titleLabel.font = kFONT(14);
                [button setTitle:(self.type == WPMainPositionTypeRecruit?@"所有企业":@"所有人") forState:UIControlStateNormal];
                [button setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                [button setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(chooseViewActions:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.equalTo(view);
                    make.width.equalTo(view).dividedBy(2);
                }];
                
                button;
            });
            
            UIImageView *leftImageView = [UIImageView new];
            leftImageView.tag = 103;
            leftImageView.image = [UIImage imageNamed:@"arrow_down"];
            [leftButton addSubview:leftImageView];
            [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftButton.titleLabel.mas_right).offset(6);
                make.centerY.equalTo(leftButton.titleLabel);
                make.size.mas_equalTo(CGSizeMake(11, 6));
            }];
            
            UIButton *rightButton = ({
                
                UIButton *button = [UIButton new];
                button.tag =102;
                button.titleLabel.font = kFONT(14);
                [button setTitle:@"全部" forState:UIControlStateNormal];//已上架
                [button setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                [button setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(chooseViewActions:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.bottom.equalTo(view);
                    make.left.equalTo(leftButton.mas_right);
                }];
                
                button;
            });
            
            UIImageView *rightImageView = [UIImageView new];
            rightImageView.tag = 104;
            rightImageView.image = [UIImage imageNamed:@"arrow_down"];
            [rightButton addSubview:rightImageView];
            [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(rightButton.titleLabel.mas_right).offset(6);
                make.centerY.equalTo(rightButton.titleLabel);
                make.size.mas_equalTo(CGSizeMake(11, 6));
            }];
            
            UILabel *line1 = [UILabel new];
            line1.backgroundColor = RGB(226, 226, 226);
            [view addSubview:line1];
            [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(0.5, 20));
            }];
            
            UILabel *line = [UILabel new];
            line.backgroundColor = RGB(226, 226, 226);
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.width.bottom.equalTo(view);
                make.height.mas_equalTo(0.5);
            }];
            
            view;
            
        });
    }
    return _chooseView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorColor = [UIColor clearColor];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.tableFooterView = [[UIView alloc]init];
            tableView.tableHeaderView = [[UIView alloc]init];
            [self.view addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chooseView.mas_bottom);
                make.left.width.bottom.equalTo(self.view);
            }];
            
            WS(ws);
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                _page = 1;
                [ws tableView:tableView requestWithPage:_page Sucess:^(NSArray *datas, int more) {
                    [tableView.mj_footer resetNoMoreData];
                    [self.data removeAllObjects];
                    [self.data addObjectsFromArray:datas];
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
                        [self.data addObjectsFromArray:datas];
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

- (void)backToFromViewController:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseViewActions:(UIButton *)sender{
    
    [YYSelectView removeFromSuperView:self.view];
    
    UIButton *oneButton = (UIButton *)[self.view viewWithTag:101];
    UIButton *twoButton = (UIButton *)[self.view viewWithTag:102];
    UIImageView *leftImageView = (UIImageView *)[self.view viewWithTag:103];
    UIImageView *rightImageView = (UIImageView *)[self.view viewWithTag:104];
    
    sender.selected = !sender.selected;
    if (sender.tag == 101) {
        twoButton.selected = NO;
        if (sender.selected) {
            [self getResumeListRequest:^(NSArray *array)
             {
                 
                [YYSelectView superView:self.view top:self.chooseView.bottom array:array type:isAllInfo selectedItem:_allSelectedItem block:^(NSString *title,NSString *selectedId,NSInteger selectedItem, BOOL isRemoved)
                {
                    _resumeId = [selectedId isEqualToString:@"1"]?@"":(selectedId?selectedId:_resumeId);
                    sender.selected = !sender.selected;
                    title?[sender setTitle:title forState:UIControlStateNormal]:0;
                    selectedId?[self requstFirstData]:0;
                    
                    _allSelectedItem = selectedItem;
                    
                    leftImageView.image = oneButton.selected?[UIImage imageNamed:@"arrow_up"]:[UIImage imageNamed:@"arrow_down"];
                    rightImageView.image = twoButton.selected?[UIImage imageNamed:@"arrow_up"]:[UIImage imageNamed:@"arrow_down"];
        
                }];
              
            }];
        }else{
            [YYSelectView removeFromSuperView:self.view];
        }
    }
    if (sender.tag == 102) {
        oneButton.selected = NO;
        if (sender.selected) {
            NSArray *Education = @[@"全部",@"已上架",@"已下架",@"被下架"];
            [YYSelectView superView:self.view top:self.chooseView.bottom array:Education type:isNotAllInfo selectedItem:_singleSelectedItem block:^(NSString *title,NSString *selectedId,NSInteger selectedItem, BOOL isRemoved) {
                _resumeType = [NSString stringWithFormat:@"%d",selectedId.intValue-2];
                if ([title isEqualToString:@"全部"])
                {
                    _resumeType = @"4";
                }
                
                sender.selected = !sender.selected;
                title?[sender setTitle:title forState:UIControlStateNormal]:0;
                selectedId?[self requstFirstData]:0;
                
                _singleSelectedItem = selectedItem;
                
                leftImageView.image = oneButton.selected?[UIImage imageNamed:@"arrow_up"]:[UIImage imageNamed:@"arrow_down"];
                rightImageView.image = twoButton.selected?[UIImage imageNamed:@"arrow_up"]:[UIImage imageNamed:@"arrow_down"];
            }];
        }else{
            [YYSelectView removeFromSuperView:self.view];
        }
    }
    
    leftImageView.image = oneButton.selected?[UIImage imageNamed:@"arrow_up"]:[UIImage imageNamed:@"arrow_down"];
    rightImageView.image = twoButton.selected?[UIImage imageNamed:@"arrow_up"]:[UIImage imageNamed:@"arrow_down"];
    
}
#pragma mark获取所有人和所有企业的信息
- (void)getResumeListRequest:(void(^)(NSArray *array))success{
    
    
//    
//    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
//    NSDictionary *params = @{@"action":@"GetChangeResumeList"
//        WPPersonListModel *model = [WPPersonListModel mj_objectWithKeyValues:json];
//        [self.modelArr addObjectsFromArray:model.resumeList];

    
    
    // 请求 招聘
    if (self.type == WPNewMeResumeTypeInterview) {
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
        WPShareModel *models = [WPShareModel sharedModel];
        NSDictionary *params = @{@"action":@"GetChangeResumeList",
                                 @"username":models.username,
                                 @"password":models.password,
                                 @"user_id":models.userId};//GetMyResumeUser
        [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
            if ([json[@"status"] isEqualToString:@"0"]) {
            WPPersonListModel *model = [WPPersonListModel mj_objectWithKeyValues:json];
                NSMutableArray * muarray = [[NSMutableArray alloc]init];
                for (WPPersonModel * permodel in model.resumeList) {
                    WPDraftListContentModel * listModel = [[WPDraftListContentModel alloc]init];
                    listModel.sex = permodel.sex;
                    listModel.age = permodel.age;
                    listModel.education = permodel.education;
                    listModel.WorkTime = permodel.education;
                    listModel.name = permodel.name;
                    listModel.avatar = permodel.user_avatar;
                    listModel.resumeUserId = permodel.sid;
                    [muarray addObject:listModel];
                }
                success(muarray);
//                WPDraftListModel *model = [WPDraftListModel mj_objectWithKeyValues:json];
//                for (WPDraftListContentModel *contentModel in model.list) {
//                    contentModel.itemIsSelected = NO;
//                }
//                success(model.resumeList);
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else{
        
        // 请求 求职
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
        WPShareModel *model = [WPShareModel sharedModel];
        NSDictionary *params = @{@"action":@"GetMyCompany",
                                 @"username":model.username,
                                 @"password":model.password,
                                 @"user_id":model.dic[@"userid"]};
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            
            WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
            for (WPCompanyListDetailModel *listModel in model.companyList) {
                listModel.itemIsSelected = NO;
            }
            success(model.companyList);
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}


- (void)requestCompanyInfo:(NSString *)jobId success:(void (^)(WPRecruitDraftInfoModel *model))success{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetJobDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"job_id":jobId};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPRecruitDraftInfoModel *model = [WPRecruitDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)getInterviewResumeDraftDetail:(NSString *)resumeId success:(void (^)(WPInterviewDraftInfoModel *model))success{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"resume_id":resumeId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPInterviewDraftInfoModel *model = [WPInterviewDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


-(void)tableView:(UITableView *)tableView requestWithPage:(NSInteger)page Sucess:(DealsSuccessBlock)success Error:(DealsErrorBlock)serror
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/jobswanted.ashx"];
    NSString *action = (self.type == WPNewMeResumeTypeRecruit?@"getjobs":@"swanted");
    NSString *resumeId = (self.type == WPNewMeResumeTypeRecruit?@"ep_id":@"resume_user_id");
    
    NSDictionary *params = @{@"action":action,
                             @"guser_id":kShareModel.userId,
                             @"page":[NSString stringWithFormat:@"%d",(int)page],
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             resumeId:_resumeId,
                             @"type":_resumeType};
    
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        
        NSArray * array = json[@"UserInfo"];
        if (page>1) {
            if (array.count) {
                _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
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
            success(_orignalModel.list,(int)_orignalModel.list.count);
        }
        
        if (_orignalModel.list.count) {
            if (self.type == WPNewMeResumeTypeInterview && page == 1) {
              [[MTTDatabaseUtil instance] upDateMyApply:json];
            }
            else
            {
                if (self.type == WPNewMeResumeTypeRecruit && page == 1) {
                    [[MTTDatabaseUtil instance] updateMyInvite:json];
                }
            }
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        serror(error);
        if (page == 1) {
            if (self.type == WPNewMeResumeTypeInterview && page == 1) {
                [[MTTDatabaseUtil instance] getMyApply:^(NSDictionary *json) {
                    _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
                    success(_orignalModel.list,(int)_orignalModel.list.count);
                }];
            }
            else
            {
                if (self.type == WPNewMeResumeTypeRecruit && page == 1) {
                    [[MTTDatabaseUtil instance] getMyInvite:^(NSDictionary *dic) {
                        _orignalModel = [NearPersonalModel mj_objectWithKeyValues:dic];
                        success(_orignalModel.list,(int)_orignalModel.list.count);
                    }];
                }
            }
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [NearMeCell cellHeight];
    return kHEIGHT(58);
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"WPApplyAndInviteTableViewCell";
    WPApplyAndInviteTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WPApplyAndInviteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.type = self.type;
    cell.model = self.data[indexPath.row];
    return cell;
//    __weak typeof(self) weakSelf = self;
//    
//    static NSString *cellId = @"NearMeCellId";
//    NearMeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        
//        cell = [[NearMeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    
//    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
//    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.tag = indexPath.row+10;
////    cell.backgroundColor = [UIColor redColor];
//    cell.NearMeBlock = ^(NSInteger tag){
//        [weakSelf checkInterview:tag];
//    };
//    
//    //有删除
//    cell.NearOperationBlock = ^(NSInteger tag,NSInteger operationNum){
//        [weakSelf operationActions:tag operation:operationNum];
//    };
//    
//    //点击名称和头像
//    cell.clickName = ^(){
//        PersonalInfoViewController *VC = [[PersonalInfoViewController alloc]init];
//        VC.friendID = _orignalModel.user_id;
//        [self.navigationController pushViewController:VC animated:YES];
//    };
//    cell.clickHeadImage = ^(){
//        PersonalInfoViewController *VC = [[PersonalInfoViewController alloc]init];
//        VC.friendID = _orignalModel.user_id;
//    [self.navigationController pushViewController:VC animated:YES];
//    };
//    
//    
//    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_orignalModel.avatar]];
//    [cell.headImageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
//    cell.positionLabel1.text = _orignalModel.position;
//    cell.companyLabel1.text = _orignalModel.company;
//    cell.nameLabel1.text = _orignalModel.nick_name;
//    
//    CGSize size = [_orignalModel.position getSizeWithFont:FUCKFONT(12) Height:cell.positionLabel1.height];
//    cell.positionLabel1.width = size.width;
//    cell.line.left = cell.positionLabel1.right+10;
//    cell.companyLabel1.left = cell.line.right+10;
//    
//    NearPersonalListModel *model = self.data[indexPath.row];
//    cell.contentLabel1.text = model.position;
//    cell.time = model.updateTime;
//    
//    NSURL *url1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
//    [cell.contentImageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"head_default"]];
//    
//    UIButton *twoButton = (UIButton *)[self.view viewWithTag:102];
//    //    NSString *title = [twoButton.titleLabel.text isEqualToString:@"已下架"]?@"上架":twoButton.titleLabel.text;
//    [cell.downButton1 setContentLabelTitle:twoButton.titleLabel.text font:FUCKFONT(12)];
//    [cell.downButton1 setContentAlignment:SPButtonContentAlignmentLeft];
//    [cell.downButton1 setContentLabelTextColor:RGB(127, 127, 127)];
//    //    cell.refButton1.contentLabel.textColor = [twoButton.titleLabel.text isEqualToString:@"已下架"]?RGB(170,170,170):RGB(0,0,0);
//    if (self.type == WPNewMeResumeTypeRecruit) {
//        cell.contentDetailLabel1.text = model.enterprise_name;
//    }
//    if (self.type == WPNewMeResumeTypeInterview) {
//        cell.contentDetailLabel1.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.nike_name,model.sex,model.worktime,model.education];
//    }
//    return cell;
}
-(void)requstFirstData
{
    _page = 1;
    [self tableView:self.tableView requestWithPage:_page Sucess:^(NSArray *datas, int more) {
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:datas];
        [self.tableView reloadData];
    } Error:^(NSError *error) {
    }];
}

#pragma mark -- 跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NearPersonalListModel *model = self.data[indexPath.row];
    WPNewCheckController *check = [[WPNewCheckController alloc]init];
    check.companyClick = ^(){
        _page = 1;
        [self tableView:self.tableView requestWithPage:1 Sucess:^(NSArray *datas, int more) {
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:datas];
            [self.tableView reloadData];
        } Error:^(NSError *error) {
            
        }];
    };
    check.upAndDownSuccess = ^(){//上下架成功刷新数据
        _page = 1;
        [self tableView:self.tableView requestWithPage:1 Sucess:^(NSArray *datas, int more) {
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:datas];
            [self.tableView reloadData];
        } Error:^(NSError *error) {
            
        }];
    };
    check.clickSuccess = ^(NSIndexPath*index){
        WPApplyAndInviteTableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
        cell.badgBtn.badgeValue = @"";
        cell.badgBtn.hidden = YES;
        
    };
    check.type = self.type == WPNewMeResumeTypeRecruit?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
    check.resumeId = model.resumeId;
    check.choiseIndex = indexPath;
    check.isRecuilist = self.type;
    check.isFromQiuzhi = YES;
    check.listType = WPNewCheckListTypeMessage;
    check.deleteSucvcess = ^(NSIndexPath*index){
        [self.data removeObjectAtIndex:index.row];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:check animated:YES];
}

- (void)checkInterview:(NSInteger)num{
    NearInterViewController *interView = [[NearInterViewController alloc]init];
    interView.isRecuilist = 0;
    [self.navigationController pushViewController:interView animated:YES];
    
    NearPersonalListModel *model = self.data[num];
    
    interView.subId = model.resumeId;
    WPShareModel *shareModel = [WPShareModel sharedModel];
    interView.isSelf = [shareModel.dic[@"userid"] isEqualToString:model.userId];
    NSString *recruitStr = [NSString stringWithFormat:@"/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    NSString *interviewStr = [NSString stringWithFormat:@"/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    if (self.type == WPNewMeResumeTypeRecruit) {
        interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,recruitStr];
    }
    if (self.type == WPNewMeResumeTypeInterview) {
        interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,interviewStr];
    }
}

-(void)pushNextController:(NSInteger)indexPath
{
    NearPersonalListModel *model = self.data[indexPath];
    WPNewCheckController *check = [[WPNewCheckController alloc]init];
    check.type = self.type == WPNewMeResumeTypeRecruit?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
    check.resumeId = model.resumeId;
    [self.navigationController pushViewController:check animated:YES];
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
            [self pushNextController:tag];
//            [self shelfInterview:tag];
            break;
        case 4:
            [self pushToDetailController:0 tag:tag];
            break;
        case 5:
            NSLog(@"推广");
            [self pushToDetailController:1 tag:tag];
            break;
        case 6:
            NSLog(@"推广");
            [self pushToDetailController:2 tag:tag];
            break;
        case 7:
            NSLog(@"推广");
            [self pushToDetailController:3 tag:tag];
            break;
    }
}

- (void)pushToDetailController:(NSInteger)type tag:(NSInteger)tag{
    NearPersonalListModel *model = self.data[tag];
    WPNewCheckController *check = [[WPNewCheckController alloc]init];
    check.type = self.type == WPNewMeResumeTypeRecruit?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
    check.listType = type;
    check.resumeId = model.resumeId;
    [self.navigationController pushViewController:check animated:YES];
}

#pragma mark 删除求职
- (void)deleteInterview:(NSInteger)tag{
    
    [SPAlert alertControllerWithTitle:nil message:@"确认删除？" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
        NearPersonalListModel *model = self.data[tag];
        
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
        WPShareModel *shareModel = [WPShareModel sharedModel];
        NSString *action = (self.type == WPNewMeResumeTypeRecruit?@"DelRecruit":@"DelJobRelease");
        NSString *sid = (self.type == WPNewMeResumeTypeRecruit?@"recruit_id":@"resume_id");
        NSDictionary *params = @{@"action":action,
                                 @"username":shareModel.username,
                                 @"password":shareModel.password,
                                 @"user_id":shareModel.dic[@"userid"],
                                 sid:model.resumeId};
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            if ([json[@"status"] integerValue]) {

                [self.data removeObjectAtIndex:tag];
                [self.tableView reloadData];
                
                if (self.type == WPNewMeResumeTypeInterview) {
                  [[MTTDatabaseUtil instance] deleteMyApply:model.resumeId];
                }
                
                
                [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            }else{
                [MBProgressHUD showError:@"删除失败" toView:self.view];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }];
}

- (void)editInterview:(NSInteger)tag{
    WS(ws);
    NearPersonalListModel *model = self.data[tag];
    if (self.type == WPMainPositionTypeRecruit) {
        [self requestCompanyInfo:model.resumeId success:^(WPRecruitDraftInfoModel *model) {
            //if (self.delegate) {
            //[ws.delegate getDraftInfo:model];
            //[ws.navigationController popViewControllerAnimated:YES];
            //}
            WPRecruitDraftEditController *edit = [[WPRecruitDraftEditController alloc]init];
            edit.type = WPRecuitEditTypeEdit;
            edit.Infomodel = model;
            [ws.navigationController pushViewController:edit animated:YES];
        }];
    }else{
        [self getInterviewResumeDraftDetail:model.resumeId success:^(WPInterviewDraftInfoModel *model) {
            //if (self.delegate) {
            //[ws.delegate returnDraftToInterviewController:model];
            //[ws.navigationController popViewControllerAnimated:YES];
            //}
            WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
            edit.type = WPInterviewEditTypeEdit;
            edit.draftInfoModel = model;
            [ws.navigationController pushViewController:edit animated:YES];
        }];
        
    }
}

- (void)refreshInterview:(NSInteger)tag{
    NearPersonalListModel *model = self.data[tag];
    UIButton *twoButton = (UIButton *)[self.view viewWithTag:102];
    if (![twoButton.titleLabel.text isEqualToString:@"已下架"]) {
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
        WPShareModel *shareModel = [WPShareModel sharedModel];
        
        NSString *action = (self.type == WPNewMeResumeTypeRecruit?@"RefreshRecruit":@"RefreshJobRelease");
        NSString *resumeId = (self.type == WPNewMeResumeTypeRecruit?@"recruit_id":@"resume_id");
        
        NSDictionary *params = @{@"action":action,
                                 @"username":shareModel.username,
                                 @"password":shareModel.password,
                                 @"user_id":shareModel.dic[@"userid"],
                                 resumeId:model.resumeId};
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            if ([json[@"status"] integerValue]) {
                [self requstFirstData];
                [MBProgressHUD showSuccess:@"刷新成功" toView:self.view];
            }else{
                [MBProgressHUD showError:@"删除失败" toView:self.view];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}

- (void)shelfInterview:(NSInteger)tag{
    NearPersonalListModel *model = self.data[tag];
    
    UIButton *twoButton = (UIButton *)[self.view viewWithTag:102];
    NSString *alertMessage = [twoButton.titleLabel.text isEqualToString:@"已上架"]?@"确认下架？":@"确认上架？";
    
    [SPAlert alertControllerWithTitle:nil message:alertMessage superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
        WPShareModel *shareModel = [WPShareModel sharedModel];
        
        NSString *action = (self.type == WPNewMeResumeTypeRecruit?@"ShelfRecruit":@"ShelfJobRelease");
        NSString *resumeId = (self.type == WPNewMeResumeTypeRecruit?@"recruit_id":@"resume_id");
        
        NSDictionary *params = @{@"action":action,
                                 @"username":shareModel.username,
                                 @"password":shareModel.password,
                                 @"user_id":shareModel.dic[@"userid"],
                                 resumeId:model.resumeId};
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            if ([json[@"status"] integerValue]) {
                NSLog(@"%@",describe(json));
                [self requstFirstData];
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            }else{
                [MBProgressHUD showError:@"删除失败" toView:self.view];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }];
}

- (void)ExtensionInterview:(NSInteger)tag{
    NearPersonalListModel *model = self.data[tag];
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    
    NSString *action = (self.type == WPNewMeResumeTypeRecruit?@"ExtensionRecruit":@"ExtensionJobRelease");
    NSString *resumeId = (self.type == WPNewMeResumeTypeRecruit?@"recruit_id":@"resume_id");
    
    NSDictionary *params = @{@"action":action,
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             resumeId:model.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            NSLog(@"%@",describe(json));
            [self requstFirstData];
            [MBProgressHUD showSuccess:@"推广成功" toView:self.view];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
