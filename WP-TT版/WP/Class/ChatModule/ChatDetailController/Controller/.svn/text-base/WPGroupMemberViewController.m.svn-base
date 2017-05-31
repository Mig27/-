//
//  WPGroupMemberViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/5/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupMemberViewController.h"
#import "WPAllSearchController.h"
#import "GroupMemberModel.h"
#import "GroupMemeberButton.h"
#import "PersonalInfoViewController.h"
#import "WPChooseLinkViewController.h"
#import "WPRemoveMemberViewController.h"
#import "MTTDatabaseUtil.h"
@interface WPGroupMemberViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WPGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self searchBar];
    [self mainScroll];
    [self requestData];
}

- (void)initNav
{
    if (self.numOfMemeber.intValue) {
        self.title = [NSString stringWithFormat:@"群成员(%@)",self.numOfMemeber];
    }
    else
    {
      self.title = @"群成员";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

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
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model.list];
        NSArray * array = model.list;
        for (GroupMemberListModel*listModel in array) {
            if ([listModel.is_create isEqualToString:@"1"]) {
                [self.dataSource removeObject:listModel];
                [self.dataSource insertObject:listModel atIndex:0];
                break;
            }
        }
        [self updateScrollView];
        if ([json[@"list"] count]) {
            [[MTTDatabaseUtil instance] deleteGroupMember:self.model.group_id];
            [[MTTDatabaseUtil instance] upDateGroupMember:json[@"list"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD createHUD:@"网络错误,请稍后重试" View:self.view];
        [[MTTDatabaseUtil instance] getGroupMember:self.model.group_id success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array};
                GroupMemberModel *model = [GroupMemberModel mj_objectWithKeyValues:dic];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:model.list];
                [self updateScrollView];
            }
        }];
    }];
}

- (void)updateScrollView
{
    CGSize businessSize = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat width = (SCREEN_WIDTH - 18*5)/4;
    CGFloat height = width + 8 + businessSize.height;
    CGFloat line = 18;
    for (UIView *view in _mainScroll.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i<self.dataSource.count; i++) {
        GroupMemeberButton *button = [[GroupMemeberButton alloc] initWithFrame:CGRectMake(line + i%4*(width + line), line + i/4*(height + line), width, height) model:_dataSource[i]];
        button.iconClick = ^(NSString *user_id){
            PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
            info.friendID = user_id;
            info.comeFromVc = @"自己判断";
            [self.navigationController pushViewController:info animated:YES];
        };
        [_mainScroll addSubview:button];
    }
    int k;
    if (self.isOwner) {
        k = 2;
    } else {
        k = 1;
    }
    NSArray *images = @[@"member_add",@"member_del"];
    for (int i = 0; i<k; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(line + (i+_dataSource.count)%4*(width + line), line + (i + _dataSource.count)/4*(height + line), width, width)];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [_mainScroll addSubview:btn];
    }
    NSInteger row = (_dataSource.count + k)%4 == 0 ? (_dataSource.count + k)/4 : (_dataSource.count + k)/4 + 1;
    _mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, row * (line + height));
}

- (void)addBtnClick:(UIButton *)sender
{
    if (sender.tag == 1000) {
        NSLog(@"添加");
        WPChooseLinkViewController *choose = [[WPChooseLinkViewController alloc] init];
        choose.chatMouble = self.mouble;
        choose.groupId = self.deleteGroupId;
        choose.model = self.model;
        choose.addType = ChooseLinkTypeDynamicGroup;
        choose.inviteSuccessBlock = ^(){
            [self requestData];
        };
        [self.navigationController pushViewController:choose animated:YES];
    } else {
        NSLog(@"移除");
        WPRemoveMemberViewController *remove = [[WPRemoveMemberViewController alloc] init];
        remove.deleGroupId = self.deleteGroupId;
        remove.model = self.model;
        remove.removeSuccessBlock = ^(){
            [self requestData];
        };
        [self.navigationController pushViewController:remove animated:YES];
    }
}

- (UIScrollView *)mainScroll
{
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc] init];
        [self.view addSubview:_mainScroll];
        [_mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_searchBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
//        _mainScroll.backgroundColor = [UIColor redColor];
    }
    
    return _mainScroll;
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
