//
//  WPPersonalResumeListController.m
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPPersonalResumeListController.h"
#import "WPPersonalResumeListCell.h"
#import "WPSelfResumeListCell.h"
#import "UIImageView+WebCache.h"
#import "NearInterViewController.h"
#import "WPResumeCheckApplyListController.h"
#import "WPResumeCheckMessageController.h"
#import "WPResumeCheckGlanceController.h"
#import "WPInterviewResumeController.h"
#import "WPRecruitDraftEditController.h"
#import "WPInterviewDraftEditController.h"
#import "WPInterviewDraftInfoModel.h"
#import "WPRecruitDraftController.h"
#import "WPRecruitDraftInfoModel.h"
#import "WPOtherResumeTwoController.h"
#import "PersonalInfoViewController.h"

@interface WPPersonalResumeListController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) TouchTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NearPersonalModel *orignalModel;

@property (assign, nonatomic) NSInteger page;

//@property (strong, nonatomic)WPNewResumeListModel *resumeModel;
@property (strong, nonatomic)WPNewResumeModel * model;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * company;
@property (nonatomic, copy) NSString * avatar;
@end

@implementation WPPersonalResumeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _page = 1;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (TouchTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        WS(ws);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requestWithPage:1 Sucess:^(NSArray *datas, int more) {
                [ws.tableView.mj_footer resetNoMoreData];
                [ws.dataSource removeAllObjects];
                [ws.dataSource addObjectsFromArray:datas];
                [ws.tableView reloadData];
            } Error:^(NSError *error) {
            }];
            [ws.tableView.mj_header endRefreshing];
        }];
        [_tableView.mj_header beginRefreshing];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [ws requestWithPage:_page Sucess:^(NSArray *datas, int more) {
                if (more) {
                    [ws.dataSource addObjectsFromArray:datas];
                    [ws.tableView reloadData];
                }else{
                    [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } Error:^(NSError *error) {
                _page--;
            }];
            [ws.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}

-(void)requestWithPage:(NSInteger)page Sucess:(DealsSuccessBlock)success Error:(DealsErrorBlock)serror
{
    NSString *urlStr = [[NSString alloc]init];
    NSDictionary *params = [[NSDictionary alloc]init];
//    if (_isSelf) {
    
    
//        urlStr = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx"];
//        WPShareModel *model = [WPShareModel sharedModel];
//        params = @{@"action":(_isRecruit?@"GetJobInfoMgr":@"GetResumeInfoMgr"),
//                   @"user_id":self.userId,
//                   @"page":[NSString stringWithFormat:@"%d",(int)page],
//                   @"username":model.username,
//                   @"password":model.password};
    urlStr = [IPADDRESS stringByAppendingString:_isRecruit?@"/ios/jobswanted.ashx":@"/ios/jobswanted.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    params = @{@"action":(_isRecruit?@"getjobs":@"swanted"),
               @"user_id":model.userId,
               @"page":[NSString stringWithFormat:@"%d",(int)page],
               @"username":model.username,
               @"password":model.password,
               @"guser_id":self.userId};
    
    
    
//    }else{
//        urlStr = [IPADDRESS stringByAppendingString:@"/ios/jobswanted.ashx"];
//        WPShareModel *model = [WPShareModel sharedModel];
//        params = @{@"action":(_isRecruit?@"getjobs":@"swanted"),
//                   @"guser_id":model.userId,
//                   @"page":[NSString stringWithFormat:@"%d",(int)page],
//                   @"user_id":model.dic[@"userid"],
//                   @"username":model.username,
//                   @"password":model.password,
//                   @"type":@"0"
//                   };
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
//    NSDictionary *params = @{@"action":@"Interview",
//                             @"state":@"4",
//                             @"user_name":model.username,
//                             @"password":model.password,
//                             @"user_id":self.userId,
//                             @"keyWords":@"",
//                             @"areaID":@"",
//                             @"Position_f":@"",
//                             @"Position":@"",
//                             @"Sex":@"",
//                             @"Wage":@"",
//                             @"Experience":@"",
//                             @"Demand":@"1",
//                             @"education":@"",
//                             @"Welfare":@"",
//                             @"age":@"",
//                             @"page":[NSString stringWithFormat:@"%ld",(long)page]};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        //        [MBProgressHUD hideHUDForView:self.view];
//        _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
//        self.title = _orignalModel.nick_name;
//        _resumeModel = [WPNewResumeListModel mj_objectWithKeyValues:json];
        if (![json[@"list"] count]) {
            return ;
        }
        
        _model = [WPNewResumeModel mj_objectWithKeyValues:json];
        self.title = _model.nick_name;
        for (WPNewResumeListModel*list in _model.list) {
            list.HopePosition = list.position;
            list.WorkTim = list.worktime;
            list.name = _isRecruit?list.enterpriseName:list.nike_name;
            list.birthday = list.age;
            list.jobPositon = list.position;
            
        }
        success(_model.list,(int)_model.list.count);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error.localizedDescription);
        serror(error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_isSelf) {
//        return [WPSelfResumeListCell cellHeight];
//    }
    return [WPPersonalResumeListCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_isSelf) {
//        static NSString *cellId = @"WPSelfResumeListCell";
//        WPSelfResumeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (!cell) {
//            cell = [[WPSelfResumeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        }
//        cell.tag = indexPath.row+10;
//        WS(ws);
//        cell.NearOperationBlock = ^(NSInteger tag,NSInteger operationNum){
//            [ws operationActions:tag operation:operationNum];
//        };
//        cell.NearCheckBlock = ^(NSInteger tag,NSInteger operationNum){
//            [ws checkActions:tag operation:operationNum];
//        };
//        cell.DidSelectedBlock = ^(NSInteger tag){
//            [ws didSelectedBlock:tag];
//        };
//        
//        cell.indexPath = indexPath;
//        NearPersonalListModel *model = self.dataSource[indexPath.row];
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
//        [cell.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
//        
//        cell.nameLabel.text = model.position;
//        cell.positionAndCompanyLabel.text = _isRecruit?model.enterprise_name:[NSString stringWithFormat:@"%@ %@ %@ %@",model.nike_name,model.sex,model.education,model.worktime];
//        cell.timeLabel.text = model.updateTime;
//        [cell.sysMessageBtn setTitle:model.ranking forState:UIControlStateNormal];
//        cell.applyNumberLabel.text = [NSString stringWithFormat:@"报名:%@",model.signUp];
//        cell.messageNumberLabel.text = [NSString stringWithFormat:@"留言:%@",model.comcount];
//        cell.glanceNumberLabel.text = [NSString stringWithFormat:@"浏览:%@",model.ranking];
//        
//        return cell;
//    }else{
        static NSString *cellId = @"WPPersonalResumeListCell";
        WPPersonalResumeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
        if (!cell) {
            cell = [[WPPersonalResumeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        WPNewResumeListModel *model = self.dataSource[indexPath.row];
//      NSLog(@"9999999999+++++%@",model.resumeId);
    cell.isRecruit = self.isRecruit;
    cell.model = _model;
    cell.resumeModel = model;
    
        cell.coverClickBlock = ^(){//点击个人资料
            PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
            personInfo.comeFromVc = @"自己判断";
            personInfo.friendID = self.userId;
            [self.navigationController pushViewController:personInfo animated:YES];
        };
        cell.bottomCoverBlock = ^(){//点击具体的内容
            WPOtherResumeTwoController *vc = [[WPOtherResumeTwoController alloc]init];
            vc.resumeModel = model;
            vc.subId = model.resumeId;
            vc.userId = self.userId;
            vc.isSelf = _isSelf;
            vc.resumeId = model.resumeId;
            vc.isRecuilist = _isRecruit;
            vc.isFromCompanyGiveList = self.isFromCompanyGiveList;
            vc.personalApplyList = self.personalApplyList;
            vc.listFix = YES;
            vc.isFromMyAplly = self.isFromMyApply;
            vc.isFromMyRobList = self.isFromMyRobList;
            vc.urlStr = _isRecruit?[NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId]:[NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
            [self.navigationController pushViewController:vc animated:YES];
        };
    
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.avatar]];
//        [cell.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
//        
//        cell.nameLabel.text = _model.nick_name;
//        CGSize size = [cell.nameLabel.text getSizeWithFont:FUCKFONT(15) Height:20];
//        CGRect rect = cell.nameLabel.frame;
//        rect.size.width = size.width;
//        cell.nameLabel.frame = rect;
//
//    
//    
//        cell.positionAndCompanyLabel.text = [NSString stringWithFormat:@"%@ | %@",_model.position,_model.company];
//        NSURL *url1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
//        [cell.contentImageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"head_default"]];
//        cell.contentLabel.text = model.position;
//        cell.contentDetailLabel.text = _isRecruit?model.enterpriseName:[NSString stringWithFormat:@"%@ %@ %@ %@",model.nike_name,model.sex,model.education,model.worktime];
////        cell.contentActionBlock = ^(NSIndexPath *indexPath){
////            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
////        };
//    cell.timeLabel.text = model.updateTime;
        return cell;
//    }
}

-(void)clickBottomBtn:(UIButton*)sender
{
    
//    NSInteger inter = sender.tag -1;
////    NSLog(@"gagagagagag==%@",self.dataSource[inter]);
//    WPNewResumeListModel * listmodel = self.dataSource[inter];
//    WPOtherResumeTwoController *vc = [[WPOtherResumeTwoController alloc]init];
//    vc.resumeModel = listmodel;
//    vc.subId = listmodel.resumeId;
//    vc.userId = self.userId;
//    vc.isSelf = _isSelf;
//    vc.resumeId = listmodel.resumeId;
//    vc.isRecuilist = _isRecruit;
//    vc.urlStr = _isRecruit?[NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,listmodel.resumeId,kShareModel.userId]:[NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,listmodel.resumeId,kShareModel.userId];
//                [self.navigationController pushViewController:vc animated:YES];
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

- (void)didSelectedBlock:(NSInteger)indexPathRow{
    NearPersonalListModel *model = self.dataSource[indexPathRow];
    //BOOL judgeIsSelf = ([kShareModel.dic[@"userid"] isEqualToString:model.userId]);
    if (self.isSelf) {
        if (_isRecruit) {
            WS(ws);
            [self requestCompanyInfo:model.resumeId success:^(WPRecruitDraftInfoModel *model) {
                //if (self.delegate) {
                //[ws.delegate getDraftInfo:model];
                //[ws.navigationController popViewControllerAnimated:YES];
                //}
                WPRecruitDraftEditController *edit = [[WPRecruitDraftEditController alloc]init];
                edit.type = WPRecuitEditTypeInfo;
                edit.Infomodel = model;
                [ws.navigationController pushViewController:edit animated:YES];
            }];
        }else{
            WS(ws);
            [self getInterviewResumeDraftDetail:model.resumeId success:^(WPInterviewDraftInfoModel *model) {
                //if (self.delegate) {
                //[ws.delegate returnDraftToInterviewController:model];
                //[ws.navigationController popViewControllerAnimated:YES];
                //}
                WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
                edit.type = WPInterviewEditTypeInfo;
                edit.draftInfoModel = model;
                [ws.navigationController pushViewController:edit animated:YES];
            }];
        }
        //WPInterviewResumeController *vc = [[WPInterviewResumeController alloc]init];
        //vc.subId = model.resumeId;
        //vc.userId = self.userId;
        //vc.isSelf = _isSelf;
        //vc.isRecuilist = _isRecruit;
        //vc.urlStr = _isRecruit?[NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId]:[NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        //[self.navigationController pushViewController:vc animated:YES];
    }else{
        //NearInterViewController *near = [[NearInterViewController alloc]init];
        //near.subId = model.resumeId;
        //near.userId = self.userId;
        //near.isSelf = _isSelf;
        //near.isRecuilist = _isRecruit;
        //near.urlStr = _isRecruit?[NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId]:[NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        //[self.navigationController pushViewController:near animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPNewResumeListModel *model = self.dataSource[indexPath.row];
//    [self jumpToUrl:model];
    WPOtherResumeTwoController *vc = [[WPOtherResumeTwoController alloc]init];
    vc.resumeModel = model;
    vc.subId = model.resumeId;
    vc.userId = self.userId;
    vc.isSelf = _isSelf;
    vc.resumeId = model.resumeId;
    vc.isRecuilist = _isRecruit;
    vc.isFromCompanyGiveList = self.isFromCompanyGiveList;
    vc.personalApplyList = self.personalApplyList;
    vc.listFix = YES;//从列表中点击进行修改
    vc.isApplyFromDetailList = YES;
    vc.isFromMyAplly = self.isFromMyApply;
    vc.isFromMyRobList = self.isFromMyRobList;
    vc.urlStr = _isRecruit?[NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId]:[NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)requestCompanyInfo:(NSString *)jobId success:(RecruitDraftSuccessBlock)success{
    
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

- (void)checkActions:(NSInteger)tag operation:(NSInteger)operationNum{
    NearPersonalListModel *model = self.dataSource[tag];
    if (operationNum == 0) {
        NSLog(@"报名");
        WPResumeCheckApplyListController *apply = [[WPResumeCheckApplyListController alloc]init];
        apply.resumeId = model.resumeId;
        apply.isRecruit = self.isRecruit;
        apply.title = @"报名";
        [self.navigationController pushViewController:apply animated:YES];
    }
    if (operationNum == 1) {
        NSLog(@"留言");
        WPResumeCheckMessageController *apply = [[WPResumeCheckMessageController alloc]init];
        apply.title = @"留言";
        apply.resumeId = model.resumeId;
        [self.navigationController pushViewController:apply animated:YES];
    }
    if (operationNum == 2) {
        NSLog(@"浏览");
        WPResumeCheckGlanceController *apply = [[WPResumeCheckGlanceController alloc]init];
        apply.resumeId = model.resumeId;
        apply.isRecruit = self.isRecruit;
        apply.title = @"浏览";
        [self.navigationController pushViewController:apply animated:YES];
    }
}

- (void)operationActions:(NSInteger)tag operation:(NSInteger)operationNum{
    WS(ws);
    if (operationNum == 0) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"是否确认删除？" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            [ws deleteInterview:tag];
        }];
    }
    if (operationNum == 1) {
        [self editInterview:tag];
    }
    if (operationNum == 2) {
        [self refreshInterview:tag];
    }
    if (operationNum == 3) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"是否确认下架？" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            [self shelfInterview:tag];
        }];
    }
    if (operationNum == 4) {
        [self ExtensionInterview:tag];
    }
}

- (void)deleteInterview:(NSInteger)tag{
    NearPersonalListModel *model = self.dataSource[tag];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSString *action = self.isRecruit?@"DelRecruit":@"DelJobRelease";
    NSString *sid = self.isRecruit?@"recruit_id":@"resume_id";
    NSDictionary *params = @{@"action":action,
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             sid:model.resumeId};
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            [self.tableView.mj_header beginRefreshing];
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
        }else{
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)delay{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kNotificationDeleteResume" object:nil];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)editInterview:(NSInteger)tag{
    WS(ws);
    NearPersonalListModel *model = self.dataSource[tag];
    if (_isRecruit) {
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
    NearPersonalListModel *model = self.dataSource[tag];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":(self.isRecruit?@"RefreshRecruit":@"RefreshJobRelease"),
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             (self.isRecruit?@"recruit_id":@"resume_id"):model.resumeId};
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
    NearPersonalListModel *model = self.dataSource[tag];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":(self.isRecruit?@"ShelfRecruit":@"ShelfJobRelease"),
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             (self.isRecruit?@"recruit_id":@"resume_id"):model.resumeId};
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
    NearPersonalListModel *model = self.dataSource[tag];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":(self.isRecruit?@"ExtensionRecruit":@"ExtensionJobRelease"),
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.dic[@"userid"],
                             (self.isRecruit?@"recruit_id":@"resume_id"):model.resumeId};
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

-(void)attention
{
    NSString *nickname;
    if ([_orignalModel.nick_name isEqualToString:@""]) {
        WPShareModel *model = [WPShareModel sharedModel];
        nickname = model.username;
    }else{
        nickname = _orignalModel.nick_name;
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSDictionary *dic = @{@"action":@"attentionSigh",
                          @"username":model.username,
                          @"password":model.password,
                          @"nick_name":userInfo[@"nick_name"],
                          @"user_id":userInfo[@"userid"],
                          @"by_user_id":_orignalModel.user_id,
                          @"by_nick_name":nickname,
                          };
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
        
        if ([json[@"status"] isEqualToString:@"1"]) {
            switch (_orignalModel.attention_state) {
                case 0:/**< 关注 */
                    //                    button.contentLabel.text = @"已关注";
                    _orignalModel.attention_state = 1;
                    break;
                case 1:/**< 已关注 */
                    //                    button.contentLabel.text = @"关注";
                    _orignalModel.attention_state = 0;
                    break;
                case 2:/**< 被关注 */
                    //                    button.contentLabel.text = @"互关注";
                    _orignalModel.attention_state = 3;
                    break;
                case 3:/**< 互关注 */
                    //                    button.contentLabel.text = @"被关注";
                    _orignalModel.attention_state = 2;
                    break;
                default:
                    break;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

@end
