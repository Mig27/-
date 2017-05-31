//
//  WPResumeUserVC.m
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeUserVC.h"

#import "WPResumeUserListModel.h"

#import "WPResumeUserCell.h"

#import "WPRecruitApplyController.h"

#import "WPRecruitWebViewController.h"

#import "WPResumeWebVC.h"
#import "WPResumeListManager.h"
#import "WPChooseResumerController.h"

@interface WPResumeUserVC () <UITableViewDelegate, UITableViewDataSource,WPChooseResumerDelegate>
{
    NSString *ep_id;
}
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *userDatas;

@property (assign, nonatomic) NSInteger page;

@property (nonatomic ,strong) UIButton *button;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation WPResumeUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ep_id = @"";
    _page = 1;
    self.title = self.title?self.title:@"求职者";
    if (!_userDatas) {
        _userDatas = [NSMutableArray new];
    }
    //[self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"确认"];
    [self.view addSubview:self.tableView];
    [self setRightBarButtonItem];
}
-(UIButton*)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 45, 45);
        //        [_rightBtn setBackgroundColor:[UIColor redColor]];
        [_rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        //        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(12))];
        [_rightBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateSelected];
        _rightBtn.selected = !self.choiseResume.length;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightBtn.userInteractionEnabled = self.choiseResume.length;
    }
    return  _rightBtn;
}
- (void)setIsBuildNew:(BOOL)isBuildNew
{
    _isBuildNew = isBuildNew;
    if (isBuildNew) {
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    }else{
//        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
//        [self.view addSubview:self.button];
        
    }
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(43));
        [self.button setTitle:@"选择个人信息" forState:UIControlStateNormal];
        self.button.titleLabel.font = kFONT(15);
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.button setBackgroundColor:[UIColor whiteColor]];
        
        [self.button setImage:[UIImage imageNamed:@"jinru"] forState:UIControlStateNormal];
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_WIDTH-18, 0, 0);
        
        CGFloat width = [@"默认·全部" getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(43)].width;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.button.imageView.left-width-8, 0, width, kHEIGHT(43))];
//        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 123;
        label.font = kFONT(12);
        label.textColor = RGB(127, 127, 127);
        label.text = @"默认·全部";
        [self.button addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
        [self.button addSubview:label];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.button addSubview:line];
        self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    return _button;
}
#pragma mark 点击选择求职者
- (void)chooseCompanyClick{
    WPChooseResumerController *company = [[WPChooseResumerController alloc]init];
    company.delegate = self;
    company.title = @"个人信息";
    company.choiseCell = ep_id?ep_id:@"";
    
    company.isBuild = self.isBuild;
    company.isApplyFromList = self.isApplyFromList;
    company.isApplyFromDetail = self.isApplyFromDetail;
    company.isApplyFromDetailList = self.isApplyFromDetailList;
    company.isFromCompanyGive = self.isFromCompanyGive;
    company.isFromCompanyGiveList = self.isFromCompanyGiveList;
    company.isFromMyApply = self.isFromMyApply;
    company.isFromCollection = self.isFromCollection;
    company.isFromMuchCollection = self.isFromMuchCollection;
    [self.navigationController pushViewController:company animated:YES];
}

- (void)getInterviewApplypersonInfo:(NSString *)epId andIsAll:(BOOL)isAll{
    _page = 1;
    _rightBtn.selected = YES;
    _rightBtn.userInteractionEnabled = NO;
    WPResumeListManager * manger = [WPResumeListManager sharedManager];
    ep_id = epId;
    manger.resumeUserIds = epId;
    NSString * string = epId;
    NSArray * array = [NSArray array];
    if (string.length)
    {
        array = [string componentsSeparatedByString:@","];
    }
    UILabel *label = [self.view viewWithTag:123];
    label.text = isAll?@"全选":[NSString stringWithFormat:@"已选择%lu个个人信息",(unsigned long)array.count];
    CGFloat width = [label.text getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(43)].width;
    label.frame = CGRectMake(self.button.imageView.left-width-8, 0, width, kHEIGHT(43));
    [self.tableView.mj_header beginRefreshing];
}
-(void)reloadDataWithEpid:(NSString*)resumeUserId
{
    _page = 1;
    _rightBtn.selected = YES;
    _rightBtn.userInteractionEnabled = NO;
    WPResumeListManager * manger = [WPResumeListManager sharedManager];
    ep_id = resumeUserId;
    manger.resumeUserIds = resumeUserId;
    UILabel *label = [self.view viewWithTag:123];
    label.text = [NSString stringWithFormat:@"已选择1个个人信息"];
    CGFloat width = [label.text getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(43)].width;
    label.frame = CGRectMake(self.button.imageView.left-width-8, 0, width, kHEIGHT(43));
    [self.tableView.mj_header beginRefreshing];

}
- (void)setRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
//    
//    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark 点击确认
- (void)rightBarButtonItemAction:(UIButton *)sender
{
//    if (_isBuildNew) {
        WPResumeUserInfoModel *userModel = nil;
        for (WPResumeUserInfoModel *model in _userDatas) {
            (model.itemIsSelected ? userModel = model : 0);
        }
        if (userModel) {
//            __weak typeof(self) weakSelf = self;
            [self requireDataChoise:_isBuildNew?userModel.resumeUserId:userModel.resume_id success:^(WPResumeUserInfoModel *model) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(reloadResumeDataWithModel:)]) {
                    [self.delegate reloadResumeDataWithModel:model];
                }
            }];
    
        }
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

-(void)requireDataChoise:(NSString*)resumeId success:(void(^)(WPResumeUserInfoModel *model))success
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSDictionary *params = @{@"action":_isBuildNew ? @"GetResumeUserInfo" : @"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             _isBuildNew ? @"resume_user_id": @"resume_id": _isBuildNew ? resumeId : resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json)
     {
         WPResumeUserInfoModel *model = [WPResumeUserInfoModel mj_objectWithKeyValues:json];
         success(model);
     } failure:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
     }];
}
//(void)getResumeDraftDetail:(WPResumDraftModel *)draftModel success:(void (^)(WPResumeUserInfoModel *model))success
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];//RGB(235, 235, 235)
            tableView.delegate = self;
            tableView.dataSource = self;
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            {
                if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                }
                
                if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
                    [tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
                }
            }
            
            [self.view addSubview:tableView];
            
            {
                WS(ws);
                tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [tableView.mj_footer resetNoMoreData];
                    if (_isBuildNew) {
                        [[WPResumeListManager sharedManager]requestForResumeList:^(NSArray *modelArray) {
                            [ws.userDatas removeAllObjects];
                            [ws.userDatas addObjectsFromArray:modelArray];
                            
                            for (WPResumeUserInfoModel * model in ws.userDatas) {
                                NSString * str = [NSString stringWithFormat:@"%@",model.resumeUserId];
                                if ([str isEqualToString:self.choiseResume]) {
                                    model.itemIsSelected = YES;
                                }
                            }
                            
                            
                            [tableView reloadData];
                            
                        }];
                    }else{//申请时选择求职者
//                        [[WPResumeListManager sharedManager]requestForResumeuserList:^(NSArray *modelArray) {
//
//                            [ws.userDatas removeAllObjects];
//                            
//                            [ws.userDatas addObjectsFromArray:modelArray];
//                            
//                            [tableView reloadData];
//                        }];
                        [ws requestGetApplyCondition:_page Success:^(NSArray *datas, int more) {
                            [ws.userDatas removeAllObjects];
                            [ws.userDatas addObjectsFromArray:datas];
                            [tableView reloadData];
                        } Error:^(NSError *error) {
                        }];
                    }
                    [tableView.mj_header endRefreshing];
                }];
                [tableView.mj_header beginRefreshing];
                
                
                if (!_isBuildNew) {//申请时加载数据
                    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        _page++;
                        [ws requestGetApplyCondition:_page Success:^(NSArray *datas, int more) {
                            if (!more) {
                                [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                            }
                            [ws.userDatas addObjectsFromArray:datas];
                            [ws.tableView reloadData];
                            
                        } Error:^(NSError *error) {
                        }];
                        [ws.tableView.mj_footer endRefreshing];
                    }];
                }
            }
            tableView;
        });
    }
    
    return _tableView;
}
- (void)requestGetApplyCondition:(NSInteger)page Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)dealError{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];//@"action":@"GetJobResumeList"
    NSDictionary *params = @{@"action":@"GetJobResumeList",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"],
                             @"resume_user_id":ep_id,
                             @"page":[NSString stringWithFormat:@"%d",(int)page]};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        WPResumeUserInfoListModel *model = [WPResumeUserInfoListModel mj_objectWithKeyValues:json];
        
        for (WPResumeUserInfoModel * listmodel in model.resumeList) {
            if ([listmodel.resume_id isEqualToString:self.choiseResume]) {
                listmodel.itemIsSelected = YES;
            }
            else
            {
                listmodel.itemIsSelected = NO;
            }
        }
        
        
        success(model.resumeList,(int)model.resumeList.count);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
//        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    
    static NSString *ID = @"WPResumeUserCell";
    WPResumeUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[WPResumeUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.isReume = !_isBuildNew;
    cell.tag = indexPath.row;   // 给每个Cell 添加indexPath作为tag
    
    [cell setModel:_userDatas[indexPath.row]];
    
    
//    NSLog(@"999999999%@",_userDatas);
    cell.chooseActionBlock = ^(NSInteger cellTag)
    {
        [ws chooseCurUser:cellTag];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    WPRecruitWebViewController *WebVC = [[WPRecruitWebViewController alloc]init];
//    WebVC.model = _userDatas[indexPath.row];
//    if (_isBuildNew) {
    
    WPResumeUserInfoModel *userModel = _userDatas[indexPath.row];
   
    if (userModel) {
        //            __weak typeof(self) weakSelf = self;
        [self requireDataChoise:_isBuildNew?userModel.resumeUserId:userModel.resume_id success:^(WPResumeUserInfoModel *model) {
            
            WPResumeWebVC *WebVC = [WPResumeWebVC new];
            WebVC.isBuildNew = _isBuildNew;
            WebVC.isRecuilist = self.isRecuilist;
            WebVC.model = _userDatas[indexPath.row];
            WebVC.infoModel = model;
            
//            WebVC.isBuild = self.isBuild;
            WebVC.choiseResume = YES;//直接选择查看简历
//            WebVC.isApplyFromDetail = self.isApplyFromDetail;
//            WebVC.isApplyFromList = self.isApplyFromList;
//            WebVC.isApplyFromDetailList = self.isApplyFromDetailList;
//            WebVC.isFromCompanyGive = self.isFromCompanyGive;
//            WebVC.isFromCompanyGiveList = self.isFromCompanyGiveList;
//            WebVC.isFromMyApply = self.isFromMyApply;
            
//            WebVC.isFromCollection = self.isFromCollection;
//            WebVC.isFromMuchCollection = self.isFromMuchCollection;
            [self.navigationController pushViewController:WebVC animated:YES];
            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadResumeDataWithModel:)]) {
//                [self.delegate reloadResumeDataWithModel:model];
//            }
        }];
        
    }
    
    
    
    
//        WPResumeWebVC *WebVC = [WPResumeWebVC new];
//        WebVC.isBuildNew = _isBuildNew;
//        WebVC.isRecuilist = self.isRecuilist;
//        WebVC.model = _userDatas[indexPath.row];
//
//        [self.navigationController pushViewController:WebVC animated:YES];
    
//    }
}


- (void)chooseCurUser:(NSInteger)cellTag
{
    for (int i = 0; i < _userDatas.count; i++) {
        WPResumeUserModel *model = _userDatas[i];
        
        (i == cellTag ? (model.itemIsSelected = !model.itemIsSelected) : (model.itemIsSelected = NO));
    }
    
//    self.navigationItem.rightBarButtonItem.enabled = YES;
    WPResumeUserModel *model  = _userDatas[cellTag];
    _rightBtn.selected = !model.itemIsSelected;
    _rightBtn.userInteractionEnabled = model.itemIsSelected;
    
    [self.tableView reloadData];
}

@end
