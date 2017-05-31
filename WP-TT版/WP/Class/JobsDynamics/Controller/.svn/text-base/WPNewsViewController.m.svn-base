//
//  WPNewsViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/5.
//  Copyright © 2016年 WP. All rights reserved.
//  消息页面

#import "WPNewsViewController.h"
#import "WPHttpTool.h"
#import "DynamicNewsModel.h"
#import "DynamicNewsCell.h"
#import "WPNewResumeCell.h"
#import "NewDetailViewController.h"
#import "RKAlertView.h"
#import "WPNewCheckController.h"
#import "WPInfoListController.h"
#import "groupCommentTableViewCell.h"
#import "WPGroupAlumDetailViewController.h"
#import "GroupPhotoAlumModel.h"
#import "WPResumeCheckController.h"
#import "NearInterViewController.h"
#import "PersonalInfoViewController.h"
@interface WPNewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource; /**< 数据源 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL moreClick; /**< 是否点击查看更多的信息 */
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UITableViewCell *clickCell; /**< 长按的cell */

@end

@implementation WPNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = BackGroundColor;
    self.view.backgroundColor = [UIColor whiteColor];
    //    if (self.isComeFromePersonal) {
    //        self.page = 2;
    //    } else {
    self.page = 1;
    //    }
    self.moreClick = NO;
    [self initNav];
    [self requestData];
}


- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (self.readOverBlock) {
        self.readOverBlock();
    }
}

- (void)initNav
{
    self.title = @"消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)rightBtnClick
{
    //    NSLog(@"empty news");
    if (self.type == NewsTypeDynamic) {
        [RKAlertView showAlertWithTitle:@"提示" message:@"确定清空所有消息？" cancelTitle:@"取消" confirmTitle:@"确认" confrimBlock:^(UIAlertView *alertView) {//点击确认
            [self deleteMegWith:nil empty:YES];
        } cancelBlock:^{//点击取消
        }];
    }
    else
    {
        [RKAlertView showAlertWithTitle:@"提示" message:@"确定清空所有消息？" cancelTitle:@"取消" confirmTitle:@"确认" confrimBlock:^(UIAlertView *alertView) {//点击确认
            [self deleteMegWith:nil empty:YES];
        } cancelBlock:^{//点击取消
        }];
    }
    
}

- (void)requestData
{
    NSString *url;
    NSDictionary *params;
    if (self.type == NewsTypeDynamic) {
        url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
        params = @{@"action" : @"getMsg",
                   @"username" : kShareModel.username,
                   @"password" : kShareModel.password,
                   @"user_id" : kShareModel.userId,
                   @"page" : @(_page),
                   @"type" : self.isComeFromePersonal ? @"1" : @"0"};
    } else if (self.type == NewsTypeInvite || self.type == NewsTypeResume) {
        url = [IPADDRESS stringByAppendingString:@"/msg/getmsg.ashx"];
        params = @{@"action" : self.type == NewsTypeInvite ? @"getJobMsg" : @"getReMsg",
                   @"username" : kShareModel.username,
                   @"password" : kShareModel.password,
                   @"user_id" : kShareModel.userId,
                   @"page" : @(_page),
                   @"type" : self.isComeFromePersonal ? @"1" : @"0"};
    }
    else if (self.type == NewsTypeGroup)
    {
        url = [IPADDRESS stringByAppendingString:@"/msg/getmsg.ashx"];
        params = @{@"action" : @"getAlbumMsg",
                   @"username" : kShareModel.username,
                   @"password" : kShareModel.password,
                   @"user_id" : kShareModel.userId,
                   @"page" : @(_page),
                   @"type" : self.isComeFromePersonal ? @"1" : @"0",
                   @"group_id":self.groupId};
        
    }
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        
        DynamicNewsModel *model = [DynamicNewsModel mj_objectWithKeyValues:json];
        [self.dataSource addObjectsFromArray:model.list];
        if (!self.isComeFromePersonal) {
            if (self.moreClick) {
                [self.tableView2 reloadData];
            } else {
                [self.tableView2 reloadData];
                [self.tableView reloadData];
                self.tableView2.hidden = YES;
            }
        } else {
            [self.tableView2 reloadData];
            self.tableView.hidden = YES;
        }
        [_tableView2.mj_footer endRefreshing];
        if (model.list.count == 0) {
            [self.tableView2.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        self.page--;
        [_tableView2.mj_footer endRefreshing];
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        //        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.tableView.tableFooterView = self.moreBtn;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (UITableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        //        _tableView2.backgroundColor = RGB(235, 235, 235);
        _tableView2.backgroundColor = [UIColor whiteColor];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        if ([_tableView2 respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView2 setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView2 respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView2 setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        _tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            [self requestData];
        }];
        
        [self.view addSubview:_tableView2];
        
    }
    return _tableView2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == NewsTypeDynamic) {
        DynamicNewsCell *cell = [DynamicNewsCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        recognizer.minimumPressDuration = 0.5;
        [cell addGestureRecognizer:recognizer];
        cell.index = indexPath;
        __weak typeof(cell) weakCell = cell;
        cell.clickPhoto = ^(NSIndexPath*index){
            if (![weakCell.model.is_an isEqualToString:@"0"]) {
                [self pushPerson:index];
            }
        };
        return cell;
    }
    else if (self.type == NewsTypeGroup)
    {
        groupCommentTableViewCell * cell = [groupCommentTableViewCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        recognizer.minimumPressDuration = 0.5;
        cell.index = indexPath;
        [cell addGestureRecognizer:recognizer];
        __weak typeof(cell) weakCell = cell;
        
        cell.clickIcon=^(NSIndexPath*index){
            if (![weakCell.model.is_an isEqualToString:@"0"]) {
                [self pushPerson:index];
            }
        };
        return cell;
    }
    else
    {
        WPNewResumeCell *cell = [WPNewResumeCell cellWithTableView:tableView];
        cell.type = self.type;
        cell.model = self.dataSource[indexPath.row];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        recognizer.minimumPressDuration = 0.5;
        [cell addGestureRecognizer:recognizer];
        __weak typeof(cell) weakCell = cell;
        cell.clickPhoto = ^(NSIndexPath*index){//点击头像
            if (![weakCell.model.is_an isEqualToString:@"0"]) {
                [self pushPerson:index];
            }
            
        };
        return cell;
    }
}
-(void)pushPerson:(NSIndexPath*)index
{
    DynamicNewsListModel* model = self.dataSource[index.row];
    [self isFriendOrNot:model.user_id compl:^(BOOL isOr) {
        
        PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
        info.friendID = model.user_id;
        
        if ([info.friendID isEqualToString:kShareModel.userId]) {
            info.title = @"个人资料";
        }
        else
        {
            info.title = @"好友资料";
        }
        
        //NSDictionary *dic =  self.dataSource[indexPath.row];
        info.ccindex = index;
        if (isOr) {  // 1陌生人 0好友 [self.dataSource[indexPath.row] is_friend]
            info.newType = NewRelationshipTypeFriend;
        }else{
            info.newType = NewRelationshipTypeStranger;
        }
        info.comeFromVc= @"话题详情";
        [self.navigationController pushViewController:info animated:YES];
    }];
}
-(void)isFriendOrNot:(NSString*)userID compl:(void(^)(BOOL isOr))completion
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/friend.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"isFriend",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"friend_id":userID};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (![json[@"fstatus"] intValue]) {
            completion(YES);
        }
        else
        {
            completion(NO);
        }
    } failure:^(NSError *error) {
        completion(YES);
    }];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UITableViewCell *cell = (UITableViewCell *)recognizer.view;
        self.clickCell = cell;
        [cell becomeFirstResponder];
        cell.backgroundColor = RGB(226, 226, 226);
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(flag:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)flag:(id)sender {
    
    //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSIndexPath *index;
    if (self.isComeFromePersonal) {
        index = [self.tableView2 indexPathForCell:self.clickCell];
    } else {
        if (self.moreClick) {
            index = [self.tableView2 indexPathForCell:self.clickCell];
        } else {
            index = [self.tableView indexPathForCell:self.clickCell];
        }
    }
    [self deleteMegWith:index empty:NO];
    //    pasteboard.string = self.data[index.row][@"speak_comment_content"];
}

#pragma mark - 删除或清空消息列表
- (void)deleteMegWith:(NSIndexPath *)indexPath empty:(BOOL)isEmpty
{
    if (self.type == NewsTypeDynamic) {
        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"delMsg";
        params[@"user_id"] = kShareModel.userId;
        if (isEmpty) {
            params[@"msg_type"] = @"3";
        } else {
            DynamicNewsListModel *model = self.dataSource[indexPath.row];
            params[@"msg_type"] = model.set_type;
            params[@"msg_id"] = model.dis_id;
        }
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            if ([json[@"status"] integerValue] == 1) {
                [self handelTableWith:indexPath empty:isEmpty];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else if (self.type == NewsTypeGroup)
    {
        NSString *url = [IPADDRESS stringByAppendingString:@"/msg/delmsg.ashx"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"delAlbumMsg";
        params[@"user_id"] = kShareModel.userId;
        params[@"username"] = kShareModel.username;
        params[@"password"] = kShareModel.password;
        if (isEmpty) {
            params[@"msg_type"] = @"3";
        } else {
            DynamicNewsListModel *model = self.dataSource[indexPath.row];
            params[@"msg_type"] = @"0";
            params[@"msg_id"] = model.dis_id;
        }
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            if ([json[@"status"] integerValue] == 1) {
                [self handelTableWith:indexPath empty:isEmpty];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        NSString *url = [IPADDRESS stringByAppendingString:@"/msg/delmsg.ashx"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = self.type == NewsTypeInvite?@"delJobMsg":@"delReMsg";
        params[@"user_id"] = kShareModel.userId;
        if (isEmpty) {
            params[@"msg_type"] = @"3";
        } else {
            DynamicNewsListModel *model = self.dataSource[indexPath.row];
            params[@"msg_type"] = model.set_type;
            params[@"msg_id"] = model.dis_id;
        }
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            if ([json[@"status"] integerValue] == 1) {
                if (isEmpty) {
                    [self.dataSource removeAllObjects];
                    [self.tableView reloadData];
                    self.tableView2.hidden = YES;
                    _moreBtn.hidden = YES;
                }
                else
                {
                    if (self.moreClick)
                    {
                        [self.dataSource removeObjectAtIndex:indexPath.row];
                        [self.tableView2 reloadData];
                    }
                    else
                    {
                        [self.dataSource removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                    }
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)handelTableWith:(NSIndexPath *)index empty:(BOOL)isEmpty
{
    if (self.isComeFromePersonal) { //从消息界面进入
        if (isEmpty) {
            self.tableView2.hidden = YES;
        } else {
            [self.dataSource removeObjectAtIndex:index.row];
            [self.tableView2 reloadData];
        }
    } else {
        if (isEmpty) {
            self.tableView.hidden = YES;
            self.tableView2.hidden = YES;
        } else {
            [self.dataSource removeObjectAtIndex:index.row];
            [self.tableView2 reloadData];
            [self.tableView reloadData];
        }
    }
}

-(void)WillHideMenu:(id)sender
{
    self.clickCell.backgroundColor = [UIColor whiteColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == NewsTypeDynamic) {
        return [DynamicNewsCell rowHeightWithModel:self.dataSource[indexPath.row]];
    }
    else if (self.type == NewsTypeGroup)
    {
        return [groupCommentTableViewCell rowHeightWithModel:self.dataSource[indexPath.row]];
    }
    else {
        return [WPNewResumeCell rowHeightWithModel:self.dataSource[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DynamicNewsListModel
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == NewsTypeDynamic) {
        NewDetailViewController *detail = [[NewDetailViewController alloc] init];
        DynamicNewsListModel *model = self.dataSource[indexPath.row];
        detail.info = @{@"sid" : model.speak_id};
        detail.destination_id = model.dis_id;
        if ([model.set_type isEqualToString:@"0"]) {//评论
            detail.jumpType = DetailJumpToComment;
        } else if ([model.set_type isEqualToString:@"2"]) {//分享
            detail.jumpType = DetailJumpToShare;
        } else {//申请
            detail.jumpType = DetailJumpToApply;
        }
        detail.nickName = model.nick_name;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (self.type == NewsTypeGroup)//群组相册
    {
        DynamicNewsListModel *model = self.dataSource[indexPath.row];
        
        NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"GetAlbumInfo";
        params[@"username"] = kShareModel.username;
        params[@"password"] = kShareModel.password;
        params[@"album_id"] = model.album_id;
        params[@"user_id"] = kShareModel.userId;
        params[@"group_id"] = self.groupId;
        
        [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
            NSLog(@"**%@",json);
            GroupPhotoAlumListModel * model = [GroupPhotoAlumListModel mj_objectWithKeyValues:json];
            WPGroupAlumDetailViewController *detail = [[WPGroupAlumDetailViewController alloc] init];
            detail.isNeedChat = YES;
            detail.info = model;
            detail.isOwner = NO;
            detail.group_id = self.groupId;
            detail.groupId = self.gid;
            detail.isCommetFromAlum = NO;
            detail.isFromAlbumNoti = YES;
            DynamicNewsListModel * model1 = self.dataSource[indexPath.row];
            detail.fromAlbumUserName = model1.created_nick_name;
            detail.fromAlbumUserId = model1.created_user_id;
            detail.fromAlbumComment = model1.comment_content;
            detail.fromAlbumCommentId = model1.dis_id;
            detail.mouble = self.mouble;
            detail.albumId = model1.album_id;
            if (model1.set_type.intValue == 0) {//评论
                detail.currentIndex = 1;
            }
            else if (model1.set_type.intValue == 1)//点赞
            {
                detail.currentIndex = 2;
            }
            else
            {
                detail.currentIndex = 1;
            }
            detail.scrollerStr = model1.dis_id;
            [self.navigationController pushViewController:detail animated:YES];
        } failure:^(NSError *error) {
        }];
        
        //        WPGroupAlumDetailViewController *detail = [[WPGroupAlumDetailViewController alloc] init];
        //        detail.isNeedChat = YES;
        //       detail.info = self.dataSource[indexPath.row];
        //        detail.isOwner = NO;
        //        detail.group_id = self.groupId;
        //        detail.currentIndexPath = indexPath;
        //        detail.isCommetFromAlum = NO;
        //        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        WPNewCheckController *check = [[WPNewCheckController alloc]init];
        DynamicNewsListModel *model = self.dataSource[indexPath.row];
        check.type = self.type == NewsTypeInvite?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
        check.resumeId = model.speak_id;
        check.isFromMianShiMessage = YES;
        check.scrollerID = model.dis_id;
        check.isHideBottom = YES;
        check.isRecuilist = self.type == NewsTypeInvite?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
        if ([model.set_type isEqualToString:@"0"]) {//评论
            if ([model.from_user_id isEqualToString:kShareModel.userId])
            {//查看自己的
                WPNewCheckController *check = [[WPNewCheckController alloc]init];
                check.replayPerson = model.nick_name;
                check.replyUserId = model.user_id;//by_user_id
                check.replyCommentId = model.dis_id;
                
                check.listType = WPNewCheckListTypeMessage;
                check.type = self.type == NewsTypeInvite?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
                check.resumeId = model.speak_id;
                check.isFromMianShiMessage = YES;
                check.scrollerID = model.dis_id;
                check.isRecuilist = self.type == NewsTypeInvite?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
                [self.navigationController pushViewController:check animated:YES];
            }
            else//查看别人的
            {
                WPResumeCheckController *resume = [[WPResumeCheckController alloc]init];
                resume.replayName = model.nick_name;
                resume.replyUserId = model.user_id;
                resume.replyCommentId = model.dis_id;
                
                resume.currentType = WPResumeCheckMessageType;
                resume.isFromMianShiMessage = YES;
                resume.scrollerID = model.dis_id;
                resume.title = @"查看";
                resume.resumeId = model.speak_id;
                resume.userId = model.user_id;
                resume.isRecruit = self.type == NewsTypeInvite?WPMainPositionTypeRecruit:WPMainPositionTypeInterView;
                [self.navigationController pushViewController:resume animated:YES];
            }
            
        }
        else if ([model.set_type isEqualToString:@"2"])//分享
        {
            check.listType = WPNewCheckListTypeShare;
            
            [self.navigationController pushViewController:check animated:YES];
        }
        else if ([model.set_type isEqualToString:@"3"])//系统消息
        {
            
        }
        else if ([model.set_type isEqualToString:@"4"])//个人申请
        {
            
            DynamicNewsListModel *model = self.dataSource[indexPath.row];
            //            SignModel * model = self.signArr[indexPath.row];
            NearInterViewController * inter = [[NearInterViewController alloc]init];
            //            inter.isRecuilist = ;
            self.type == NewsTypeInvite?(inter.isRecuilist = 0):(inter.isRecuilist = 1);
            inter.isSelf = NO;
            inter.subId = model.speak_id;
            inter.resumeId = model.speak_id;
            inter.userId = model.user_id;
            
            if (self.type == NewsTypeInvite)
            {
                inter.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.speak_id,kShareModel.userId];//recruit_id
            }
            else
            {
                inter.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.speak_id,kShareModel.userId];//kShareModel.userId
            }
            [self.navigationController pushViewController:inter animated:YES];
            
            
            
            //            WPInfoListController *InfoVC = [[WPInfoListController alloc]init];
            ////            InfoVC.isResume = YES;
            //            if (self.type == NewsTypeInvite) {
            //                InfoVC.isResume = NO;
            //                InfoVC.title = @"求职申请";
            //                InfoVC.isRecurit = NO;
            //            }
            //            else if(self.type == NewsTypeResume)
            //            {
            //
            //                InfoVC.isResume = YES;
            //                InfoVC.isRecurit = YES;
            //                InfoVC.title = @"企业投递";
            //            }
            //
            //            InfoVC.Id = model.speak_id;
            //            [self.navigationController pushViewController:InfoVC animated:YES];
        }
    }
}


- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43));
        moreBtn.backgroundColor = [UIColor whiteColor];
        [moreBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [moreBtn setTitle:@"查看更多的消息..." forState:UIControlStateNormal];
        [moreBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = kFONT(12);
        [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(43) - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [moreBtn addSubview:line];
        _moreBtn = moreBtn;
    }
    return _moreBtn;
}

#pragma mark 点击查看更多消息
- (void)moreBtnClick
{
    self.moreClick = YES;
    _tableView.hidden = YES;
    //    NSIndexPath *index = [[NSIndexPath alloc]init];
    //    if (self.dataSource.count >= 1) {
    //        index = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    //    }
    //    else
    //    {
    //        index = [NSIndexPath indexPathForRow:0 inSection:0];
    //    }
    //    [_tableView2 scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    _tableView2.hidden = NO;
    self.page++;
    [self requestData];
    
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
