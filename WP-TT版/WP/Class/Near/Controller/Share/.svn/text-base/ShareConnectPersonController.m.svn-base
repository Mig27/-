//
//  ShareConnectPersonController.m
//  WP
//
//  Created by CBCCBC on 16/1/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ShareConnectPersonController.h"

#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "LinkManModel.h"
#import "LinkGroupModel.h"
#import "TableViewIndex.h"
#import "LinkmanCell.h"
#import "LinkGroupCell.h"
#import "WPAllSearchController.h"
#import "AddNewFriendController.h"
#import "InterestedViewController.h"
#import "LinkAddViewController.h"
#import "PersonalInfoViewController.h"
#import "YYAlertManager.h"

@interface ShareConnectPersonController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UIScrollView *mainScrol;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) NSInteger currentPage; //当前显示的是在第几页

@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *data2;
@property (nonatomic,strong) NSMutableArray *data3;
@property (nonatomic,strong) NSMutableArray *data4;
@property (nonatomic,strong) NSMutableArray *datas;  //所有的数据

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic,strong) NSMutableArray *tableViews;  //所有的列表

@property (strong,nonatomic) NSMutableArray *sectionTitle1;
@property (strong,nonatomic) NSMutableArray *sectionTitle2;
@property (strong,nonatomic) NSMutableArray *sectionTitle3;
@property (strong,nonatomic) NSMutableArray *sectionTitle4;
@property (strong,nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UISearchBar *searchBar1;
@property (strong, nonatomic) UISearchBar *searchBar2;
@property (strong, nonatomic) UISearchBar *searchBar3;
@property (strong, nonatomic) UISearchBar *searchBar4;

@end

@implementation ShareConnectPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.title = @"通讯录";
    [self requireGroupDataSuccess:^(NSArray *datas, int more) {
        NSLog(@"%@",datas);
    } Error:^(NSError *error) {
        
    }];

    [self createUI];
    [self createBottom];
    self.currentPage = 0;
    [self initDatasource];
}

- (void)rightButtonClick
{
//    NSLog(@"右按钮点击");
    LinkAddViewController *add = [[LinkAddViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)initDatasource
{
    self.data1 = [NSMutableArray array];
    self.data2 = [NSMutableArray array];
    self.data3 = [NSMutableArray array];
    self.data4 = [NSMutableArray array];
    self.datas = [[NSMutableArray alloc] initWithObjects:_data1,_data2,_data3,_data4,nil];
    self.sectionTitle1 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    self.sectionTitle2 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    self.sectionTitle3 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    self.sectionTitle4 = [[NSMutableArray alloc] initWithObjects:@"我创建的群",@"我加入的群", nil];
    self.sectionTitles = [[NSMutableArray alloc] initWithObjects:_sectionTitle1,_sectionTitle2,_sectionTitle3, nil];
    //    self.tableViews = [[NSMutableArray alloc] initWithObjects:self.table1,self.table2,self.table3,self.table4,nil];
    [self table1];
    
}

- (NSArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [[NSArray alloc]init];
    }
    return _shareArray;
}

- (UITableView *)table1
{
    if (_table1 == nil) {
        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BOTTOMHEIGHT - 64) style:UITableViewStylePlain];
        _table1.delegate = self;
        _table1.dataSource = self;
        _table1.rowHeight = [LinkmanCell cellHeight];
        _table1.tableFooterView = [[UIView alloc] init];
        _table1.sectionIndexColor = [UIColor blackColor];
        _table1.tableHeaderView = self.searchBar1;
        [self.mainScrol addSubview:_table1];
        
        [self requireDataWithAciont:@"GetFriend" Success:^(NSArray *datas, int more) {
            self.data1 = [TableViewIndex archive:datas];
            for (int i = (int)self.data1.count-1; i>=0; i--) {
                if ([self.data1[i] count] == 0) {
                    [self.sectionTitle1 removeObjectAtIndex:i];
                    [self.data1 removeObjectAtIndex:i];
                }
            }
            
            //NSMutableArray *firstArr = [NSMutableArray array];
            //LinkManListModel *model = [[LinkManListModel alloc] init];
            //model.user_name = @"新的粉丝";
            //model.avatar = [UIImage imageNamed:@"linkman_1"];
            //[firstArr addObject:model];
            
            //[self.data1 insertObject:firstArr atIndex:0];
            //[self.sectionTitle1 insertObject:@"" atIndex:0];
            NSLog(@"11111%@",_data1);
            [_table1 reloadData];
        } Error:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    return _table1;
}

- (UITableView *)table2
{
    if (_table2 == nil) {
        _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BOTTOMHEIGHT - 64) style:UITableViewStylePlain];
        _table2.delegate = self;
        _table2.dataSource = self;
        _table2.rowHeight = [LinkmanCell cellHeight];
        _table2.tableFooterView = [[UIView alloc] init];
        _table2.sectionIndexColor = [UIColor blackColor];
        _table2.tableHeaderView = self.searchBar2;
        [self.mainScrol addSubview:_table2];
        
        [self requireDataWithAciont:@"GetAttention" Success:^(NSArray *datas, int more) {
            self.data2 = [TableViewIndex archive:datas];
            for (int i = (int)self.data2.count-1; i>=0; i--) {
                if ([self.data2[i] count] == 0) {
                    [self.sectionTitle2 removeObjectAtIndex:i];
                    [self.data2 removeObjectAtIndex:i];
                }
            }
            
            //NSMutableArray *firstArr = [NSMutableArray array];
            //LinkManListModel *model = [[LinkManListModel alloc] init];
            //model.user_name = @"你可能感兴趣";
            //model.avatar = [UIImage imageNamed:@"linkman_2"];
            //[firstArr addObject:model];
            
            //[self.data2 insertObject:firstArr atIndex:0];
            //[self.sectionTitle2 insertObject:@"" atIndex:0];
            NSLog(@"22222%@",_data2);
            [_table2 reloadData];
        } Error:^(NSError *error) {
            
        }];
    }
    return _table2;
}

- (UITableView *)table3
{
    if (_table3 == nil) {
        _table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BOTTOMHEIGHT - 64) style:UITableViewStylePlain];
        _table3.delegate = self;
        _table3.dataSource = self;
        _table3.tableFooterView = [[UIView alloc] init];
        _table3.rowHeight = [LinkmanCell cellHeight];
        _table3.sectionIndexColor = [UIColor blackColor];
        _table3.tableHeaderView = self.searchBar3;
        [self.mainScrol addSubview:_table3];
        
        [self requireDataWithAciont:@"GetFans" Success:^(NSArray *datas, int more) {
            self.data3 = [TableViewIndex archive:datas];
            for (int i = (int)self.data3.count-1; i>=0; i--) {
                if ([self.data3[i] count] == 0) {
                    [self.sectionTitle3 removeObjectAtIndex:i];
                    [self.data3 removeObjectAtIndex:i];
                }
            }
            
            //            NSMutableArray *firstArr = [NSMutableArray array];
            //            LinkManListModel *model = [[LinkManListModel alloc] init];
            //            model.user_name = @"新的粉丝";
            //            model.avatar = [UIImage imageNamed:@"linkman_3"];
            //            [firstArr addObject:model];
            //
            //            [self.data3 insertObject:firstArr atIndex:0];
            //            [self.sectionTitle3 insertObject:@"" atIndex:0];
            
            //            NSLog(@"33333%@",_data3);
            [_table3 reloadData];
        } Error:^(NSError *error) {
            
        }];
    }
    return _table3;
}


- (UITableView *)table4
{
    if (_table4 == nil) {
        _table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BOTTOMHEIGHT - 64) style:UITableViewStylePlain];
        _table4.delegate = self;
        _table4.dataSource = self;
        _table4.tableFooterView = [[UIView alloc] init];
        _table4.rowHeight = [LinkGroupCell cellHeight];
        
        _table4.tableHeaderView = self.searchBar4;
        [self.mainScrol addSubview:_table4];
        
        [self requireGroupDataSuccess:^(NSArray *datas, int more) {
            self.data4 = [[NSMutableArray alloc]initWithArray:datas];
            //NSMutableArray *firstArr = [NSMutableArray array];
            //linkGroupListModel *model = [[linkGroupListModel alloc] init];
            
            for (int i = (int)self.data4.count-1; i>=0; i--) {
                if ([self.data4[i] count] == 0) {
                    [self.sectionTitle4 removeObjectAtIndex:i];
                    [self.data4 removeObjectAtIndex:i];
                }
            }
            //model.group_name = @"附近的群";
            //model.group_icon = [UIImage imageNamed:@"linkman_4"];
            //[firstArr addObject:model];
            //[self.data4 insertObject:firstArr atIndex:0];
            //[self.sectionTitle4 insertObject:@"" atIndex:0];
            [_table4 reloadData];
        } Error:^(NSError *error) {
            
        }];
    }
    return _table4;
}


- (void)requireGroupDataSuccess:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetGroup";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        LinkGroupModel *model = [LinkGroupModel mj_objectWithKeyValues:json];
        NSArray *arr1 = [[NSArray alloc] initWithArray:model.mycreated];
        NSArray *arr2 = [[NSArray alloc] initWithArray:model.myjoin];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:arr1,arr2, nil];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}

- (void)requireDataWithAciont:(NSString *)action Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = action;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        LinkManModel *model = [LinkManModel mj_objectWithKeyValues:json];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _table1) {
        return [self.data1 count];
    } else if (tableView == _table2) {
        return [self.data2 count];
    } else if (tableView == _table3) {
        return [self.data3 count];
    } else {
        return [self.data4 count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _table1) {
        return [self.data1[section] count];
    } else if (tableView == _table2) {
        return [self.data2[section] count];
    } else if (tableView == _table3) {
        return [self.data3[section] count];
    } else {
        return [self.data4[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _table4) {
        LinkGroupCell *cell = [LinkGroupCell cellWithTableView:tableView];
        cell.model = self.data4[indexPath.section][indexPath.row];
        return cell;
    } else {
        LinkmanCell *cell = [LinkmanCell cellWithTableView:tableView];
        if (tableView == _table1) {
            cell.model = self.data1[indexPath.section][indexPath.row];
        } else if (tableView == _table2) {
            cell.model = self.data2[indexPath.section][indexPath.row];
        } else if (tableView == _table3) {
            cell.model = self.data3[indexPath.section][indexPath.row];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (tableView == _table1) {
        //if (indexPath.section == 0) {
            //AddNewFriendController *add = [[AddNewFriendController alloc] init];
            //[self.navigationController pushViewController:add animated:YES];
        //} else {
            //PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
            //LinkManListModel *model = self.data1[indexPath.section][indexPath.row];
            //personalInfo.friendID = model.user_id;
            //[self.navigationController pushViewController:personalInfo animated:YES];
        //}
    //} else if (tableView == _table2) {
        //if (indexPath.section == 0) {
            //InterestedViewController *interest = [[InterestedViewController alloc] init];
            //[self.navigationController pushViewController:interest animated:YES];
        //} else {
            //PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
            //LinkManListModel *model = self.data2[indexPath.section][indexPath.row];
            //personalInfo.friendID = model.user_id;
            //[self.navigationController pushViewController:personalInfo animated:YES];
        //}
    //} else if (tableView == _table3) {
        //PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
        //LinkManListModel *model = self.data3[indexPath.section][indexPath.row];
        //personalInfo.friendID = model.user_id;
        //[self.navigationController pushViewController:personalInfo animated:YES];
    //}
    [YYAlertManager messages:self.shareArray action:^{
       //使用聊天功能发送到群组中或是发给某一个人
        NSLog(@"%@",self.shareArray);
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//点击索引跳转到相应位置
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if (tableView == _table1) {
        if (![self.data1[index] count]) {
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    } else if (tableView == _table2) {
        if (![self.data2[index] count]) {
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    } else if (tableView == _table3) {
        if (![self.data3[index] count]) {
            return 0;
            
        }else{
            
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            return index;
        }
    } else {
        return 0;
    }
    
}

//分区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _table1) {
        if ([self.data1 count] == 0) {
            return nil;
        }else{
            return [self.sectionTitle1 objectAtIndex:section];
        }
    } else if (tableView == _table2) {
        if ([self.data2 count] == 0) {
            return nil;
        }else{
            return [self.sectionTitle2 objectAtIndex:section];
        }
    } else if (tableView == _table3) {
        if ([self.data3 count] == 0) {
            return nil;
        }else{
            return [self.sectionTitle3 objectAtIndex:section];
        }
    } else {
        if ([self.data4 count] == 0) {
            return nil;
        }else{
            return [self.sectionTitle4 objectAtIndex:section];
        }
    }
}

//索引标题
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _table1) {
        return self.sectionTitle1;
    } else if (tableView == _table2) {
        return self.sectionTitle2;
    } else if (tableView == _table3) {
        return self.sectionTitle3;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _table1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
        [view addSubview:label];
        label.text = [self.sectionTitle1 objectAtIndex:section];
        label.textColor = [UIColor blackColor];
        label.font = kFONT(12);
        return view;
    } else if (tableView == _table2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
        [view addSubview:label];
        label.text = [self.sectionTitle2 objectAtIndex:section];
        label.textColor = [UIColor blackColor];
        label.font = kFONT(12);
        return view;
    } else if (tableView == _table3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
        [view addSubview:label];
        label.text = [self.sectionTitle3 objectAtIndex:section];
        label.textColor = [UIColor blackColor];
        label.font = kFONT(12);
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
        [view addSubview:label];
        label.text = [self.sectionTitle4 objectAtIndex:section];
        label.textColor = [UIColor blackColor];
        label.font = kFONT(12);
        return view;
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = RGB(235, 235, 235);
//
//}


- (UISearchBar *)searchBar1{
    if (!_searchBar1) {
        _searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar1.tintColor = [UIColor lightGrayColor];
        _searchBar1.backgroundColor = WPColor(235, 235, 235);
        _searchBar1.barStyle     = UIBarStyleDefault;
        _searchBar1.translucent  = YES;
        _searchBar1.placeholder = @"搜索";
        _searchBar1.delegate = self;
        
        [_searchBar1 sizeToFit];
        
        for (UIView *view in _searchBar1.subviews) {
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
    return _searchBar1;
}

- (UISearchBar *)searchBar2{
    if (!_searchBar2) {
        _searchBar2 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar2.tintColor = [UIColor lightGrayColor];
        _searchBar2.backgroundColor = WPColor(235, 235, 235);
        _searchBar2.barStyle     = UIBarStyleDefault;
        _searchBar2.translucent  = YES;
        _searchBar2.placeholder = @"搜索";
        _searchBar2.delegate = self;
        
        [_searchBar2 sizeToFit];
        
        for (UIView *view in _searchBar2.subviews) {
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
    return _searchBar2;
}

- (UISearchBar *)searchBar3{
    if (!_searchBar3) {
        _searchBar3 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar3.tintColor = [UIColor lightGrayColor];
        _searchBar3.backgroundColor = WPColor(235, 235, 235);
        _searchBar3.barStyle     = UIBarStyleDefault;
        _searchBar3.translucent  = YES;
        _searchBar3.placeholder = @"搜索";
        _searchBar3.delegate = self;
        
        [_searchBar3 sizeToFit];
        
        for (UIView *view in _searchBar3.subviews) {
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
    return _searchBar3;
}

- (UISearchBar *)searchBar4{
    if (!_searchBar4) {
        _searchBar4 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar4.tintColor = [UIColor lightGrayColor];
        _searchBar4.backgroundColor = WPColor(235, 235, 235);
        _searchBar4.barStyle     = UIBarStyleDefault;
        _searchBar4.translucent  = YES;
        _searchBar4.placeholder = @"搜索";
        _searchBar4.delegate = self;
        
        [_searchBar4 sizeToFit];
        
        for (UIView *view in _searchBar4.subviews) {
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
    return _searchBar4;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    
    return NO;
}


- (void)createUI
{
    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT)];
    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT);
    self.mainScrol.pagingEnabled = YES;
    self.mainScrol.delegate = self;
    self.mainScrol.backgroundColor = RGB(235, 235, 235);
    self.mainScrol.showsHorizontalScrollIndicator = NO;
    self.mainScrol.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrol];
    //    for (int i=0; i<4; i++) {
    //        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 200, SCREEN_WIDTH, 20)];
    //        titleLabel.text = [NSString stringWithFormat:@"第%d页",i+1];
    //        titleLabel.textColor = [UIColor redColor];
    //        titleLabel.textAlignment = NSTextAlignmentCenter;
    //        [self.mainScrol addSubview:titleLabel];
    //    }
    
}

#pragma mark - 底部按钮的创建
- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainScrol.bottom, SCREEN_WIDTH, BOTTOMHEIGHT + 0.5)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - BOTTOMHEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3)];
    self.line.backgroundColor = RGBColor(10, 110, 210);
    [backView addSubview:self.line];
    
    CGFloat linwWidth = 0.5;
    CGFloat btnWidth = (SCREEN_WIDTH - 3)/4;
    NSArray *titles = @[@"好友",@"关注",@"粉丝",@"群组"];
    for (int i = 0; i<[titles count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth + linwWidth)*i, 0, btnWidth, BOTTOMHEIGHT)];
        button.tag = i+1;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if (i != 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), (BOTTOMHEIGHT - 15)/2, linwWidth, 15)];
            line.backgroundColor = RGBColor(178, 178, 178);
            [backView addSubview:line];
        }
        
        if (i == 0) {
            button.selected = YES;
            self.button1 = button;
        } else if (i == 1) {
            self.button2 = button;
        } else if (i == 2) {
            self.button3 = button;
        } else if (i == 3) {
            self.button4 = button;
        }
    }
    
}

#pragma mark 点击好友，关注，粉丝和群组
- (void)btnClick:(UIButton *)sender//1.2.3.4
{
    //    [self keyBoardDismiss];
    
    self.currentPage = sender.tag - 1;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
        }
    }];
    
    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self table1];
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self table2];
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        [self table3];
    } else if (sender.tag == 4) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        [self table4];
    }
    //    [self refreshIsNeedEmpty:NO];
    //    [self.tableViews[self.currentPage] reloadData];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    if ([scrollView isEqual:self.mainScrol]) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self btnClickWithIndex:index];
    }
    
}

- (void)btnClickWithIndex:(NSInteger)index
{
    self.currentPage = index;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
        }
    }];
    
    if (index == 0) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self table1];
    } else if (index == 1) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self table2];
    } else if (index == 2) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        [self table3];
    } else if (index == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        [self table4];
    }
    //    [self refreshIsNeedEmpty:NO];
    //    [self.tableViews[self.currentPage] reloadData];
}


@end
