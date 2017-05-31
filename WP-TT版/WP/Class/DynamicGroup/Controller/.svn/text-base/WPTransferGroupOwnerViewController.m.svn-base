//
//  WPTransferGroupOwnerViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPTransferGroupOwnerViewController.h"
#import "WPAllSearchController.h"
#import "GroupMemberModel.h"
#import "GroupMemberTableViewIndex.h"
#import "WPGroupMemberCell.h"
#import "RKAlertView.h"
#import "DDGroupModule.h"
#import "MTTDatabaseUtil.h"
@interface WPTransferGroupOwnerViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionTitle3;

@end

@implementation WPTransferGroupOwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择群主";
    [self initDataSource];
    [self searchBar];
    [self requestData];
    
}

- (void)initDataSource
{
    self.dataSource = [NSMutableArray array];
    self.sectionTitle3 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
}
//获取群成员
- (void)requestData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
    NSDictionary *params = @{@"action" : @"getMenberList",
                             @"group_id" : self.model.group_id,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        GroupMemberModel *model = [GroupMemberModel mj_objectWithKeyValues:json];
//        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
//        NSArray * array = model.list;
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObjectsFromArray:model.list];
        for (int i = 0; i<arr.count; i++) {
            GroupMemberListModel *model = arr[i];
            if ([model.is_create isEqualToString:@"1"]) {
                [arr removeObjectAtIndex:i];
            }
        }
        
        self.dataSource = [GroupMemberTableViewIndex archive:arr];
        for (int i = (int)self.dataSource.count-1; i>=0; i--) {
            if ([self.dataSource[i] count] == 0) {
                [self.sectionTitle3 removeObjectAtIndex:i];
                [self.dataSource removeObjectAtIndex:i];
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _searchBar.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = [WPGroupMemberCell cellHeight];
        _tableView.sectionIndexColor = [UIColor blackColor];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


- (UISearchBar *)searchBar{
    if (!_searchBar) {
        WS(ws);
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        _searchBar.tintColor = [UIColor lightGrayColor];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        _searchBar.backgroundColor = WPColor(235, 235, 235);
        [self.view addSubview:_searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.view).offset(64);
            make.left.right.equalTo(ws.view);
            make.height.equalTo(@(40));
        }];
        for (UIView *view in _searchBar.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    
    return NO;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPGroupMemberCell *cell = [WPGroupMemberCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupMemberListModel *model = self.dataSource[indexPath.section][indexPath.row];
    NSString *message = [NSString stringWithFormat:@"确认将群主管理权转移给%@?",model.nick_name];
    [RKAlertView showAlertWithTitle:@"提示" message:message cancelTitle:@"取消" confirmTitle:@"确认" confrimBlock:^(UIAlertView *alertView) {
        NSLog(@"确认");
        [self transferOwnerWith:model];
    } cancelBlock:^{
        
    }];
}

- (void)transferOwnerWith:(GroupMemberListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"action" : @"UpdateCreateUser",
                             @"group_id" : self.model.group_id,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"update_id" : model.user_id,
                             @"g_id":self.groupId};
    
 [WPHttpTool postWithURL:url params:params success:^(id json) {
     if ([json[@"status"] integerValue] == 1) {
         
         //改变数据库中的创建者
         [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {
             group.groupCreatorId = model.user_id;
             [[DDGroupModule instance] addGroup:group];
             [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
             }];
         }];
         
         if (self.transferSuccess) {
             self.transferSuccess();
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDataUpdate" object:nil];
         [self.navigationController popViewControllerAnimated:YES];
     }
     else
     {
         [MBProgressHUD createHUD:json[@"info"] View:self.view];
     }
 } failure:^(NSError *error) {
     
 }];
 
}

//点击索引跳转到相应位置
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
        if (![self.dataSource[index] count]) {
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    
}

//分区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if ([self.dataSource count] == 0) {
            return nil;
        }else{
            return [self.sectionTitle3 objectAtIndex:section];
        }
}

//索引标题
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
        return self.sectionTitle3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
        [view addSubview:label];
        label.text = [self.sectionTitle3 objectAtIndex:section];
        label.textColor = [UIColor blackColor];
        label.font = kFONT(12);
        return view;
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
