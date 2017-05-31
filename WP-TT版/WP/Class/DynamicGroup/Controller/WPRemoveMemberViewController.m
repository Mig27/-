//
//  WPRemoveMemberViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRemoveMemberViewController.h"
#import "WPAllSearchController.h"
#import "GroupMemberTableViewIndex.h"
#import "GroupChooseMemberCell.h"
#import "DDDeleteMemberFromGroupAPI.h"
#import "DDGroupModule.h"
#import "MTTSessionEntity.h"
#import "SessionModule.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
@interface WPRemoveMemberViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong,nonatomic) UILabel *makeView;
@property (strong,nonatomic) UIButton *previewBtn;
@property (strong,nonatomic) UIButton *doneBtn;
@property (strong,nonatomic) UIToolbar *toolBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionTitle3;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger allMember;

@end

@implementation WPRemoveMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initNav];
    [self searchBar];
    [self setupToorBar];
    [self requestData];
}

- (UIView*)line
{
    if (!_line) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(177, 177, 177);
        [self.view addSubview:line];
    }
    return _line;
}

- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"移除成员";
}

- (void)initDataSource
{
    self.dataSource = [NSMutableArray array];
    self.sectionTitle3 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
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
        NSLog(@"%@---%@",json,json[@"info"]);
        [self line];
        GroupMemberModel *model = [GroupMemberModel mj_objectWithKeyValues:json];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
        self.allMember = arr.count - 1;
        for (int i = 0; i<arr.count; i++) {
            GroupMemberListModel *model = arr[i];
            model.is_selected = @"0";
            if ([model.is_create isEqualToString:@"1"]) {//admin
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
        [self updateToolBar];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = NO;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.makeView];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UIButton *)previewBtn{
    if (!_previewBtn) {
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//        previewBtn.enabled = YES;
        previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        previewBtn.frame = CGRectMake(0, 0, 45, 45);
        [previewBtn setTitle:@"全选" forState:UIControlStateNormal];
        [previewBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
        [previewBtn addSubview:self.makeView];
        self.previewBtn = previewBtn;
    }
    return _previewBtn;
}

- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-20, 12, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        //        makeView.backgroundColor = [UIColor redColor];
//        makeView.backgroundColor = RGB(10, 110, 210);
        makeView.backgroundColor = RGB(0, 172, 255);
//        [self.view addSubview:makeView];
        self.makeView = makeView;
        
    }
    return _makeView;
}

#pragma mark -初始化底部ToorBar
- (void) setupToorBar{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    toorBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 左视图 中间距 右视图
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.previewBtn];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    
    toorBar.items = @[leftItem,fiexItem,rightItem];
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom + 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - _searchBar.height - 64 - 45) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = [GroupChooseMemberCell cellHeight];
        _tableView.sectionIndexColor = [UIColor blackColor];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
//        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
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


- (void)preview
{
    self.previewBtn.selected = !self.previewBtn.isSelected;
    for (NSArray *arr in self.dataSource) {
        for (GroupMemberListModel *model in arr) {
            model.is_selected = self.previewBtn.isSelected ? @"1" : @"0";
        }
    }
    [self updateToolBar];
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self deleteChoise];
    }
}
-(void)deleteChoise
{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
    NSMutableArray *userIDs = [NSMutableArray array];
    NSMutableArray *friends = [NSMutableArray array];
    NSMutableArray * friendName = [NSMutableArray array];
    for (NSArray *arr in self.dataSource) {
        for (GroupMemberListModel *model in arr) {
            if ([model.is_selected isEqualToString:@"1"]) {
                [friends addObject:model.user_id];
                [friendName addObject:model.nick_name];
                [userIDs addObject:[NSString stringWithFormat:@"user_%@",model.user_id]];
            }
        }
    }
    NSString *friendID = [friends componentsJoinedByString:@","];
    NSString *frindStr = [friendName componentsJoinedByString:@","];
    NSDictionary *params = @{@"action" : @"deleteMenber",
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"group_id" : self.model.group_id,
                             @"menber_id" : friendID};
    for (NSString * userId in userIDs)
    {
        DDDeleteMemberFromGroupAPI*delete = [[DDDeleteMemberFromGroupAPI alloc]init];
        NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.deleGroupId],userId];
        [delete requestWithObject:array Completion:^(id response, NSError *error) {
            if (response)
            {
                [WPHttpTool postWithURL:url params:params success:^(id json) {
                    if ([json[@"status"] integerValue] == 1) {
                        [MBProgressHUD createHUD:json[@"info"] View:self.view];
                        if (self.removeSuccessBlock) {
                            self.removeSuccessBlock();
                        }
                        
                        [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.deleGroupId] completion:^(MTTGroupEntity *group) {
                            [group.groupUserIds removeObject:userId];
                        }];
                        
                        
                        
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
    [self sendMessageToGroup:friendID andName:frindStr];
    [self performSelector:@selector(delay) afterDelay:1.1];
}
#pragma mark 点击删除
- (void)done
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
    
    
    
//    
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
//    NSMutableArray *userIDs = [NSMutableArray array];
//    NSMutableArray *friends = [NSMutableArray array];
//    NSMutableArray * friendName = [NSMutableArray array];
//    for (NSArray *arr in self.dataSource) {
//        for (GroupMemberListModel *model in arr) {
//            if ([model.is_selected isEqualToString:@"1"]) {
//                [friends addObject:model.user_id];
//                [friendName addObject:model.nick_name];
//                [userIDs addObject:[NSString stringWithFormat:@"user_%@",model.user_id]];
//            }
//        }
//    }
//    NSString *friendID = [friends componentsJoinedByString:@","];
//    NSString *frindStr = [friendName componentsJoinedByString:@","];
//    NSDictionary *params = @{@"action" : @"deleteMenber",
//                             @"user_id" : kShareModel.userId,
//                             @"username" : kShareModel.username,
//                             @"password" : kShareModel.password,
//                             @"group_id" : self.model.group_id,
//                             @"menber_id" : friendID};
//    for (NSString * userId in userIDs)
//    {
//       DDDeleteMemberFromGroupAPI*delete = [[DDDeleteMemberFromGroupAPI alloc]init];
//      NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.deleGroupId],userId];
//        [delete requestWithObject:array Completion:^(id response, NSError *error) {
//            if (response)
//            {
//                [WPHttpTool postWithURL:url params:params success:^(id json) {
//                    if ([json[@"status"] integerValue] == 1) {
//                        [MBProgressHUD createHUD:json[@"info"] View:self.view];
//                        if (self.removeSuccessBlock) {
//                            self.removeSuccessBlock();
//                        }
//                        
//                        [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.deleGroupId] completion:^(MTTGroupEntity *group) {
//                            [group.groupUserIds removeObject:userId];
//                        }];
//                    }
//                } failure:^(NSError *error) {
//                    
//                }];
//            }
//        }];
//    }
//    [self sendMessageToGroup:friendID andName:frindStr];
//    [self performSelector:@selector(delay) afterDelay:1.1];
}
-(void)sendMessageToGroup:(NSString*)userIdStr andName:(NSString*)nameStr
{
    
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.deleGroupId] completion:^(MTTGroupEntity *group) {
        MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        
        ChattingModule*mouble = [[ChattingModule alloc] init];
        mouble.MTTSessionEntity = session;
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":userIdStr,
                                                   @"for_username":nameStr,
                                                   @"note_type":@"3",
                                                   @"create_userid":@"",
                                                   @"create_username":@"",
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
        
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        message.msgContent = contentStr;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INVITESUCCESS" object:message];
        
        [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        } Error:^(NSError *error) {
            [self.tableView reloadData];
        }];
    }];
}
- (void)delay
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deletegroupUpdate" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        WS(ws);
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
        _searchBar.tintColor = [UIColor blackColor];;
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

- (void)updateToolBar
{
    [self.makeView.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    NSInteger selectCount = 0;
    for (NSArray *arr in self.dataSource) {
        for (GroupMemberListModel *model in arr) {
            if ([model.is_selected isEqualToString:@"1"]) {
                selectCount++;
            }
        }
    }
    if (selectCount == _allMember) {
        _previewBtn.selected = YES;
    } else {
        _previewBtn.selected = NO;
    }
    self.makeView.hidden = !selectCount;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)selectCount];
    self.doneBtn.enabled = (selectCount > 0);
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
    GroupChooseMemberCell *cell = [GroupChooseMemberCell cellWithTableView:tableView];
    cell.memberModel = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupMemberListModel *model = self.dataSource[indexPath.section][indexPath.row];
    model.is_selected = [model.is_selected isEqualToString:@"1"] ? @"0" : @"1";
    [self updateToolBar];
    [self.tableView reloadData];
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
