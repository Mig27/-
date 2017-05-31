//
//  NearPersonalController.m
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "NearPersonalController.h"
#import "NearPersonalCell.h"
#import "NearMeCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "NearInterViewController.h"
#import "UITableView+EmptyData.h"
#import "PersonalInfoViewController.h"

@interface NearPersonalController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) NearPersonalModel *orignalModel;/**< 后台返回的Json->model */

@property (assign, nonatomic) NSInteger page;

@end

@implementation NearPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"个人简历";
    [self initNav];
    _page = 1;
    
    [self.view addSubview:self.tableView];
//    [self requestForInfo];
}

- (void)initNav
{
    if (self.type == WPNearPersonalTypeRecruit) {
        self.title = [NSString stringWithFormat:@"%@的招聘",self.nick_name];
    } else if (self.type == WPNearPersonalTypeInterview) {
        self.title = [NSString stringWithFormat:@"%@的求职",self.nick_name];
    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableHeaderView = self.headView;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor = [UIColor whiteColor];
        __weak typeof(self) unself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            [unself requestWithPage:1 Sucess:^(NSArray *datas, int more) {
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
            [unself requestWithPage:_page Sucess:^(NSArray *datas, int more) {
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

-(NSMutableArray *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}

-(void)requestWithPage:(NSInteger)page Sucess:(DealsSuccessBlock)success Error:(DealsErrorBlock)serror
{
    //jobswanted.ashx 招聘
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/jobswanted.ashx"];//((self.type == WPNearPersonalTypeActivity)?@"/ios/game.ashx":
    
    NSString *action = (self.type == WPNearPersonalTypeRecruit?@"getjobs":@"swanted");
    
    NSDictionary *params = @{@"action":action,
                             @"guser_id":self.userId,
                             @"page":[NSString stringWithFormat:@"%d",(int)page],
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"type":@"0",
                             @"user_id":kShareModel.userId};
    NSLog(@"----------->>%@",params);
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        
        _orignalModel = [NearPersonalModel mj_objectWithKeyValues:json];
        success(_orignalModel.list,(int)_orignalModel.list.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        serror(error);
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *noDataStr = [[NSString alloc] init];
    if (self.type == WPNearPersonalTypeRecruit) {
//        noDataStr = @"暂无招聘信息";
    } else if (self.type == WPNearPersonalTypeInterview) {
//        noDataStr = @"暂无求职信息";
    }
//    [tableView tableViewDisplayWitMsg:noDataStr ifNecessaryForRowCount:self.data.count];
    return self.data.count;
//    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NearPersonalCell cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    static NSString *cellId = @"NearPersonalCellId";
    NearPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NearPersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.indexPath = indexPath;
    cell.coverClickBlock = ^(){
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        personInfo.friendID = _orignalModel.user_id;
        if (self.newType == NewRelationshipTypeFriend) {  // 0陌生人 1好友
            personInfo.newType = NewRelationshipTypeFriend;
        }else{
            personInfo.newType = NewRelationshipTypeStranger;
        }
        personInfo.comeFromVc = @"求职";
        [self.navigationController pushViewController:personInfo animated:YES];
    };
    
    
    cell.clickDetail = ^(NSIndexPath*indexPath){
       [weakSelf checkInterview:indexPath.row];
    };
    cell.tag = indexPath.row+10;/**< 查看详情时确认被点击的Cell */
    cell.NearPersonalBlock = ^(NSInteger tag){
        [weakSelf checkInterview:tag];
    };
    
    //cell上部的个人头像，昵称，职位，和公司
    NSURL *url1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_orignalModel.avatar]];
    [cell.headImageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"head_default"]];
        CGSize size = [_orignalModel.position getSizeWithFont:FUCKFONT(12) Height:cell.positionLabel1.height];
        cell.nameLabel1.text = _orignalModel.nick_name;
    cell.positionLabel1.text = _orignalModel.position;
    cell.companyLabel1.text = _orignalModel.company;
    
    //重置头部职位和公司的位置
    cell.positionLabel1.width = size.width;
    cell.line.left = cell.positionLabel1.right+10;
    cell.companyLabel1.left = cell.line.right+10;
    
    //cell中部的（招聘 or 求职 or 活动）的信息
    NearPersonalListModel *model = self.data[indexPath.row];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [cell.contentImageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    cell.contentLabel1.text = model.position;
    cell.timeLabel1.text = model.updateTime;
    
    if (self.type == WPNearPersonalTypeRecruit) {
        cell.contentDetailLabel1.text = model.enterprise_name;
    }
    if (self.type == WPNearPersonalTypeInterview) {
        cell.contentDetailLabel1.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.sex,model.age,model.worktime,model.education];
    }
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self checkInterview:indexPath.row];
}

- (void)checkInterview:(NSInteger)num{
    NearInterViewController *interView = [[NearInterViewController alloc]init];
    interView.isRecuilist = self.isRecruit;
    [self.navigationController pushViewController:interView animated:YES];
    NearPersonalListModel *model = self.data[num];
    interView.subId = model.resumeId;
    interView.resumeId = model.resumeId;
    interView.userId = model.userId;
    WPShareModel *shareModel = [WPShareModel sharedModel];
    interView.isSelf = [shareModel.dic[@"userid"] isEqualToString:model.userId];
    NSString *recruitStr = [NSString stringWithFormat:@"/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    NSString *interviewStr = [NSString stringWithFormat:@"/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    NSString *activityStr = [NSString stringWithFormat:@"/webMobile/November/game_info.aspx?game_id=%@&user_id=%@",model.resumeId,kShareModel.dic[@"userid"]];
    if (self.type == WPNearPersonalTypeRecruit) {
//        interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,recruitStr];
        if (self.isFromPersonalInfo)
        {
            interView.urlStr = [NSString stringWithFormat:@"%@%@&isVisible=1",IPADDRESS,recruitStr];
        }
        else
        {
          interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,recruitStr];
        }
    }
    if (self.type == WPNearPersonalTypeInterview) {
        interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,interviewStr];
        if (self.isFromPersonalInfo)
        {
            interView.urlStr = [NSString stringWithFormat:@"%@%@&isVisible=1",IPADDRESS,interviewStr];
        }
        else
        {
            interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,interviewStr];
        }
    }
    if (self.type == WPNearPersonalTypeActivity) {
        interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,activityStr];
    }
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
                    _orignalModel.attention_state = 1;
                    break;
                case 1:/**< 已关注 */
                    _orignalModel.attention_state = 0;
                    break;
                case 2:/**< 被关注 */
                    _orignalModel.attention_state = 3;
                    break;
                case 3:/**< 互关注 */
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation NearPersonalModel

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"NearPersonalListModel",
             };
}

@end

@implementation NearPersonalListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"sysMessage":@"sys_message",
             @"updateTime":@"update_Time",
             @"userId":@"user_id"
             };
}

@end
