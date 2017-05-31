//
//  WPChooseLinkViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/5/7.
//  Copyright © 2016年 WP. All rights reserved.
//  添加联系人界面,职场群和聊天群添加联系人均为该界面

#import "WPChooseLinkViewController.h"
#import "LinkManModel.h"
#import "WPAllSearchController.h"
#import "GroupChooseMemberCell.h"
#import "TableViewIndex.h"
#import "DDAddMemberToGroupAPI.h"
#import "DDCreateGroupAPI.h"
#import "RuntimeStatus.h"
#import "ChattingMainViewController.h"
#import "DDGroupModule.h"
#import "ContactsModule.h"
#import "DDUserModule.h"
#import "SessionModule.h"
#import "MTTDatabaseUtil.h"
#import "WPMyGroupController.h"
#import "PersonalInfoViewController.h"
#import "DDMessageSendManager.h"
#import "MTTSessionEntity.h"
#import <MAMapKit/MAMapKit.h>
#import "WPInfoManager.h"
#import "WPInfoController.h"
#import "MTTDatabaseUtil.h"
@interface WPChooseLinkViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MAMapViewDelegate, AMapSearchDelegate,WPInfoManagerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionTitle3;
@property (strong,nonatomic) UILabel *makeView;
@property (strong,nonatomic) UIButton *doneBtn;
@property (nonatomic,strong) UIView *tableHeader;
@property (nonatomic, strong)NSIndexPath*choiseIndex;
@property (nonatomic, strong)ChattingModule*mouble;
@property (nonatomic, strong)MAMapView*maMap;
@property (nonatomic, strong)AMapSearchAPI*search;
@property (nonatomic, copy)NSString* locationAdress;
@property (nonatomic, copy)NSString*industry;
@property (nonatomic, copy)NSString*industryId;
@property (nonatomic, strong)MTTMessageEntity * deleteMessage;
@end

@implementation WPChooseLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sectionTitle3 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    [self initNav];
    [self searchBar];
    [self requestData];
    [self locaton];
    [self getPersomalInfo];
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view];
}
-(void)getPersomalInfo
{
    WPInfoManager *manager = [WPInfoManager sharedManager];
    manager.delegate = self;
    [manager requestForWPInFo];
}
- (void)reloadData
{
    //    WPInfoModel * infoModel = [[WPInfoModel alloc]init];
    //    infoModel =[WPInfoManager sharedManager].model;
    
    
    WPInfoManager *manager = [WPInfoManager sharedManager];
    _industry = manager.model.industry;//industry
    _industryId = manager.model.positionId;//industryId
}
-(void)locaton
{
    self.maMap = [[MAMapView alloc] init];
    self.maMap.delegate = self;
    [AMapSearchServices sharedServices].apiKey = @"eb9761d4882a35c670410b580bfa2a50";
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    AMapReGeocodeSearchRequest* requst =  [[AMapReGeocodeSearchRequest alloc]init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    CGFloat latitude = [[user objectForKey:@"latitude"] floatValue];
    CGFloat longitude = [[user objectForKey:@"longitude"] floatValue];
    requst.location  = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    [self.search AMapReGoecodeSearch:requst];
}
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    //获取当前地址
    //    NSString * address = response.regeocode.formattedAddress;
    AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
    NSString * building = addressComponent.building;
    _locationAdress = [NSString stringWithFormat:@"%@",building];
    if (!_locationAdress.length)
    {
        _locationAdress = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailAdress"];
    }
    
    
    
}
-(ChattingModule*)mouble
{
    if (!_mouble) {
        _mouble = [[ChattingModule alloc]init];
    }
    return _mouble;
}
- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"选择联系人";
    self.doneBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
}
-(void)sendMessageToGroup:(NSString*)userIdStr andName:(NSString*)nameStr
{
    
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {
        MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        
        ChattingModule*mouble = [[ChattingModule alloc] init];
        mouble.MTTSessionEntity = session;
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        
        //新成员
        NSMutableArray *for_user_info_1_Arr = [NSMutableArray array];
        for (NSArray *arr in self.dataSource) {
            for (LinkManListModel *model in arr) {
                if ([model.is_be isEqualToString:@"0"] && [model.is_selected isEqualToString:@"1"]) {
                    
                    NSDictionary * dic = @{@"mark":[[NSString stringWithFormat:@"%@",model.nick_name] length]?[NSString stringWithFormat:@"%@",model.nick_name]:@"",
                                           @"name":[[NSString stringWithFormat:@"%@",model.user_name] length]?[NSString stringWithFormat:@"%@",model.user_name]:@"",
                                           @"avatar":[[NSString stringWithFormat:@"%@",model.avatar] length]?[NSString stringWithFormat:@"%@",model.avatar]:@"",
                                           @"id":[[NSString stringWithFormat:@"%@",model.friend_id] length]?[NSString stringWithFormat:@"%@",model.friend_id]:@""};
                    [for_user_info_1_Arr addObject:dic];
                }
            }
        }
        
        
        NSDictionary * dic = @{@"list": for_user_info_1_Arr};
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStirng = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":userIdStr,
                                                   @"for_username":nameStr,
                                                   @"note_type":@"1",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.nick_name,
                                                   @"for_user_info_1":jsonStirng,
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.chatMouble MsgType:msgContentType];//mouble
        
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
#pragma mark  点击确认
- (void)rightBtnClick:(UIButton*)sender
{
    if (self.isFromChat)//从聊天界面添加名片
    {
        NSMutableArray * array = [NSMutableArray array];
        for (NSArray *arr in self.dataSource) {
            for (LinkManListModel *model in arr) {
                if ([model.is_be isEqualToString:@"0"] && [model.is_selected isEqualToString:@"1"]) {
                    NSDictionary * dic = @{@"nick_name":[[NSString stringWithFormat:@"%@",model.nick_name] length]?[NSString stringWithFormat:@"%@",model.nick_name]:@"",
                                           @"avatar":[[NSString stringWithFormat:@"%@",model.avatar] length]?[NSString stringWithFormat:@"%@",model.avatar]:@"",
                                           @"wp_id":[[NSString stringWithFormat:@"%@",model.wp_id] length]?[NSString stringWithFormat:@"%@",model.wp_id]:@"",
                                           @"user_id":[[NSString stringWithFormat:@"%@",model.friend_id] length]?[NSString stringWithFormat:@"%@",model.friend_id]:@"",
                                           @"to_name":@"",
                                           @"from_name":kShareModel.username,
                                           @"position":model.position.length?model.position:@"",
                                           @"company":model.company.length?model.company:@""};
                    [array addObject: dic];
                }
            }
        }
        if (array.count > 20) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多选择20个名片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        
        [[ChattingMainViewController shareInstance] sendePersonalCard:array];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (self.addType == ChooseLinkTypeDynamicGroup)
        { //职场群组添加成员
            sender.enabled = NO;
            __block NSMutableArray *userIDs = [NSMutableArray new];
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
            NSMutableArray *friends = [NSMutableArray array];
            NSMutableArray * friendName = [NSMutableArray array];
            for (NSArray *arr in self.dataSource) {
                for (LinkManListModel *model in arr) {
                    if ([model.is_be isEqualToString:@"0"] && [model.is_selected isEqualToString:@"1"]) {
                        [friends addObject:model.friend_id];
                        [friendName addObject:model.nick_name];
                        [userIDs addObject:[NSString stringWithFormat:@"user_%@",model.friend_id]];
                    }
                }
            }
            if (friends.count == 0) {
                [MBProgressHUD createHUD:@"请选择想邀请的好友" View:self.view];
                return;
            }
            
            if (friends.count + self.numOfMemember.intValue > 40 && (friends.count+self.numOfMemember.intValue<=500))
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前群人数较多,需要对方同意后才能进入群聊,确认邀请?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 99998;
                [alert show];
                return;
            }
            else if (friends.count + self.numOfMemember.intValue > 40)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"人数已达上限,无法邀请成员加入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 9999;
                [alert show];
                sender.enabled = YES;
                return;
            }
            
            
            NSString *friendID = [friends componentsJoinedByString:@","];
            NSString * friendNameStr = [friendName componentsJoinedByString:@","];
            NSDictionary *params = @{@"action"   : @"inviteJoin",
                                     @"user_id"  : kShareModel.userId,
                                     @"username" : kShareModel.username,
                                     @"password" : kShareModel.password,
                                     @"group_id" : self.model.group_id,
                                     @"friendId" : friendID};
            DDAddMemberToGroupAPI*creatGroup = [[DDAddMemberToGroupAPI alloc] init];
            NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.groupId],userIDs];
            [MBProgressHUD showMessage:@"" toView:self.view];
            [creatGroup requestWithObject:array  Completion:^(id  response, NSError *error) {
                
                if (response != nil)
                {
                    [WPHttpTool postWithURL:url params:params success:^(id json) {
                        [MBProgressHUD hideHUDForView:self.view];
                        if ([json[@"status"] integerValue] == 0) {
                            [MBProgressHUD createHUD:json[@"info"] View:self.view];
                            if (self.inviteSuccessBlock) {
                                self.inviteSuccessBlock();
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupUpdate" object:nil];
                            [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {
                                for (NSString*tring in userIDs) {
                                    [group.groupUserIds addObject:tring];
                                }
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDMEMEMBERSUCCESS" object:nil];
                            }];
                            [self sendMessageToGroup:friendID andName:friendNameStr];
                            [self performSelector:@selector(delay) afterDelay:1.1];//1.1
                        }
                        else
                        {
                            sender.enabled = YES;
                        }
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view];
                        sender.enabled = YES;
                    }];
                }
            }];
        }
        else if (self.addType == ChooseLinkTypeChatGroup || self.addType == ChooseLinkTypeCreateChat)
        { //聊天群组的添加好友或者发起群聊
#pragma mark 此处loading由于下面的代码卡住线程了,以后要处理
             [MBProgressHUD showMessage:@"" toView:self.view];

            NSMutableArray * friendName = [NSMutableArray array];
            NSMutableArray * friendId = [NSMutableArray array];
            
            
            sender.enabled = NO;
            DDCreateGroupAPI *creatGroup = [[DDCreateGroupAPI alloc] init];
            __block NSMutableArray *userIDs = [NSMutableArray new];
            NSMutableArray *photoDatas = [NSMutableArray array];
            NSMutableArray *nickNames = [NSMutableArray array];
            NSString *groupName = TheRuntime.user.nick;
            [userIDs addObject:TheRuntime.user.objID];
            WPFormData *formdata1 = [[WPFormData alloc] init];
            NSURL *avatarUrl1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:TheRuntime.user.avatar]];
            NSString * string = [NSString stringWithFormat:@"%@",avatarUrl1];
            string = [string stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
            avatarUrl1 = [NSURL URLWithString:string];
            formdata1.data = [NSData dataWithContentsOfURL:avatarUrl1];
            formdata1.name = @"PhotoAddress1";
            formdata1.filename = @"PhotoAddress1.png";
            formdata1.mimeType = @"image/png";
            [photoDatas addObject:formdata1];
            int i = 2;
            
            for (NSArray *arr in self.dataSource) {
                for (LinkManListModel *model in arr) {
                    if ([model.is_be isEqualToString:@"1"] || [model.is_selected isEqualToString:@"1"]) {
                        [userIDs addObject:[NSString stringWithFormat:@"user_%@",model.friend_id]];
                        groupName = [groupName stringByAppendingString:[NSString stringWithFormat:@",%@",model.nick_name]];
                        
                        WPFormData *formdata = [[WPFormData alloc] init];
                        NSURL *avatarUrl = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
                        formdata.data = [NSData dataWithContentsOfURL:avatarUrl];
                        formdata.name = [NSString stringWithFormat:@"PhotoAddress%d",i];
                        formdata.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
                        formdata.mimeType = @"image/png";
                        [photoDatas addObject:formdata];
                        i++;
                        [nickNames addObject:model.friend_id];
                        
                        [friendId addObject:model.friend_id];
                        [friendName addObject:model.nick_name];
                    }
                }
            }
            //            if (nickNames.count == 1)//选择了一个人就是双方对话
            //            {
            //                MTTSessionEntity* session = [[MTTSessionEntity alloc] initWithSessionID:[@"user_" stringByAppendingString:nickNames[0]] type:SessionTypeSessionTypeSingle];
            //                [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
            //
            //                if (self.isFromSingle)
            //                {
            //                    [self.navigationController popToViewController:[ChattingMainViewController shareInstance] animated:YES];
            //                }
            //                else
            //                {
            //                    [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
            //                }
            //                return;
            //            }
            
            if (nickNames.count > 40)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"人数已达上限,无法邀请成员加入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 99999;
                [alert show];
                sender.enabled = YES;
                return;
            }
            if (!_locationAdress.length)
            {
                _locationAdress = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailAdress"];
            }
           
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"action"] = @"AddGroup";
            params[@"user_id"] = kShareModel.userId;
            params[@"username"] = kShareModel.username;
            params[@"password"] = kShareModel.password;
            params[@"group_name"] = groupName;
            params[@"content"] = @"";
            params[@"longitude"] = @"";
            params[@"latitude"] = @"";
            params[@"place_name"] = @"";//安徽省|合肥市|瑶海区
            params[@"address"] = _locationAdress;
            params[@"Industry_id"] = _industryId;
            params[@"group_Industry"] = _industry;
            params[@"PhotoNum"] = @"1";
            params[@"icon"] = @"1";
            params[@"group_number"] = [nickNames componentsJoinedByString:@","];//nickNames
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
            NSArray *array =@[groupName,@"",userIDs];
            [creatGroup requestWithObject:array Completion:^(MTTGroupEntity * response, NSError *error) {
                if (response !=nil)
                {
                    self.groupId = [NSString stringWithFormat:@"group_%@",[response.objID substringFromIndex:6]];
                    
                    NSString *friendID = [friendId componentsJoinedByString:@","];
                    NSString *friendNameStr = [friendName componentsJoinedByString:@","];
                    
                    
                    
                    params[@"g_id"] = [response.objID substringFromIndex:6];
                    [WPHttpTool postWithURL:url params:params formDataArray:photoDatas success:^(id json) {
                        
                        [MBProgressHUD hideHUDForView:self.view];
                        
                        response.groupCreatorId=TheRuntime.user.objID;
                        response.avatar = TheRuntime.user.avatar;
                        [[DDGroupModule instance] addGroup:response];
                        
                        MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:response.objID type:SessionTypeSessionTypeGroup];
                        session.avatar = TheRuntime.user.avatar;
                        session.lastMsg=@"群创建成功";
                        [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                        }];
                        [[MTTDatabaseUtil instance] updateRecentGroup:response completion:^(NSError *error) {
                        }];
                        //                [self sendMessageAboutInvite:session andFriendI d:friendID andName:friendNameStr];
                        
                        ChattingModule * mouble = [[ChattingModule alloc]init];
                        mouble.MTTSessionEntity = session;
                        
                        
                        NSMutableArray * array = [NSMutableArray array];
                        for (NSArray *arr in self.dataSource) {
                            for (LinkManListModel *model in arr) {
                                if ([model.is_be isEqualToString:@"1"] || [model.is_selected isEqualToString:@"1"]) {
                                    NSDictionary * dic = @{@"mark":[[NSString stringWithFormat:@"%@",model.nick_name] length]?[NSString stringWithFormat:@"%@",model.nick_name]:@"",
                                                           @"name":[[NSString stringWithFormat:@"%@",model.user_name] length]?[NSString stringWithFormat:@"%@",model.user_name]:@"",
                                                           @"avatar":[[NSString stringWithFormat:@"%@",model.avatar] length]?[NSString stringWithFormat:@"%@",model.avatar]:@"",
                                                           @"id":[[NSString stringWithFormat:@"%@",model.friend_id] length]?[NSString stringWithFormat:@"%@",model.friend_id]:@""};
                                    [array addObject: dic];
                                }
                            }
                        }
                        
                        NSDictionary * tempDic = @{@"list": array};
                        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONWritingPrettyPrinted error:nil];
                        NSString * jsonStirng = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                        
                        
                        NSDictionary * dictionary = @{@"display_type":@"12",
                                                      @"content":@{@"for_userid":friendId,
                                                                   @"for_username":friendNameStr,
                                                                   @"note_type":@"1",
                                                                   @"create_userid":kShareModel.userId,
                                                                   @"create_username":kShareModel.nick_name,
                                                                   @"for_user_info_1":jsonStirng,
                                                                   @"for_user_info_0":@""
                                                                   }
                                                      };
                        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
                        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
                        
                        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                            DDLog(@"消息插入DB成功");
                        } failure:^(NSString *errorDescripe) {
                            DDLog(@"消息插入DB失败");
                        }];
                        self.deleteMessage = message;
                        
                        //邀请成功时发送消息
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"notExit"];
                        NSDictionary * dic = @{@"session":session,@"friendID":friendID,@"friendNameStr":friendNameStr};
                        [self performSelector:@selector(sendMessage:) withObject:dic afterDelay:0.5];
                        
                        
                        [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
                        [ChattingMainViewController shareInstance].title=response.name;
                        if (self.isFromSingle)
                        {
                            [self.navigationController popToViewController:[ChattingMainViewController shareInstance] animated:YES];
                        }
                        else
                        {
                            [ChattingMainViewController shareInstance].isPushFromCreatQuick = YES;
                            [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
                        }
                        [[SessionModule instance] addToSessionModel:session];
                        if ([SessionModule instance].delegate && [[SessionModule instance].delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                            [[SessionModule instance].delegate sessionUpdate:session Action:ADD];
                        }
                        
                        
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view];
                    }];
                    //                response.groupCreatorId=TheRuntime.user.objID;
                    //                response.avatar = TheRuntime.user.avatar;
                    //                [[DDGroupModule instance] addGroup:response];
                    //                MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:response.objID type:SessionTypeSessionTypeGroup];
                    //                session.avatar = TheRuntime.user.avatar;
                    //                session.lastMsg=@"群创建成功";
                    //                [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                    //                }];
                    //                [[MTTDatabaseUtil instance] updateRecentGroup:response completion:^(NSError *error) {
                    //                }];
                    ////                [self sendMessageAboutInvite:session andFriendI d:friendID andName:friendNameStr];
                    //
                    //                ChattingModule * mouble = [[ChattingModule alloc]init];
                    //                mouble.MTTSessionEntity = session;
                    //                NSDictionary * dictionary = @{@"display_type":@"12",
                    //                                              @"content":@{@"for_userid":friendId,
                    //                                                           @"for_username":friendNameStr,
                    //                                                           @"note_type":@"1",
                    //                                                           @"create_userid":kShareModel.userId,
                    //                                                           @"create_username":kShareModel.nick_name
                    //                                                           }
                    //                                              };
                    //                DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
                    //                NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                    //                NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    //                MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
                    //
                    //                [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                    //                    DDLog(@"消息插入DB成功");
                    //                } failure:^(NSString *errorDescripe) {
                    //                    DDLog(@"消息插入DB失败");
                    //                }];
                    //                self.deleteMessage = message;
                    //
                    //                //邀请成功时发送消息
                    //                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"notExit"];
                    //                NSDictionary * dic = @{@"session":session,@"friendID":friendID,@"friendNameStr":friendNameStr};
                    //                [self performSelector:@selector(sendMessage:) withObject:dic afterDelay:0.5];
                    //
                    //
                    //                [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
                    //                [ChattingMainViewController shareInstance].title=response.name;
                    //                if (self.isFromSingle)
                    //                {
                    //                   [self.navigationController popToViewController:[ChattingMainViewController shareInstance] animated:YES];
                    //                }
                    //                else
                    //                {
                    //                 [ChattingMainViewController shareInstance].isPushFromCreatQuick = YES;
                    //                 [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
                    //                }
                    //                [[SessionModule instance] addToSessionModel:session];
                    //                if ([SessionModule instance].delegate && [[SessionModule instance].delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                    //                    [[SessionModule instance].delegate sessionUpdate:session Action:ADD];
                    //                }
                }
                else
                {
                    NSLog(@"出错啦出错啦");
                    sender.enabled = YES;
                    
                }
            }];
        }
    }
}
-(void)sendMessage:(id)obj
{
    NSDictionary * dic = (NSDictionary*)obj;
    [self sendMessageAboutInvite:dic[@"session"] andFriendId:dic[@"friendID"] andName:dic[@"friendNameStr"]];
}
-(void)sendMessageAboutInvite:(MTTSessionEntity*)session andFriendId:(NSString*)friendId andName:(NSString*)friendName
{
    
    ChattingModule * mouble = [[ChattingModule alloc]init];
    mouble.MTTSessionEntity = session;
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray *arr in self.dataSource) {
        for (LinkManListModel *model in arr) {
            if ([model.is_be isEqualToString:@"1"] || [model.is_selected isEqualToString:@"1"]) {
                NSDictionary * dic = @{@"mark":[[NSString stringWithFormat:@"%@",model.nick_name] length]?[NSString stringWithFormat:@"%@",model.nick_name]:@"",
                                       @"name":[[NSString stringWithFormat:@"%@",model.user_name] length]?[NSString stringWithFormat:@"%@",model.user_name]:@"",
                                       @"avatar":[[NSString stringWithFormat:@"%@",model.avatar] length]?[NSString stringWithFormat:@"%@",model.avatar]:@"",
                                       @"id":[[NSString stringWithFormat:@"%@",model.friend_id] length]?[NSString stringWithFormat:@"%@",model.friend_id]:@""};
                [array addObject: dic];
            }
        }
    }


    NSDictionary * dic = @{@"list": array};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStirng = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary * dictionary = @{@"display_type":@"12",
                                  @"content":@{@"for_userid":friendId,
                                               @"for_username":friendName,
                                               @"note_type":@"1",
                                               @"create_userid":kShareModel.userId,
                                               @"create_username":kShareModel.nick_name,
                                               @"for_user_info_1":jsonStirng,
                                               @"for_user_info_0":@""
                                               }
                                  };
    DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
    //    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
    //        DDLog(@"消息插入DB成功");
    //    } failure:^(NSString *errorDescripe) {
    //        DDLog(@"消息插入DB失败");
    //    }];
    message.msgContent = contentStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        if (self.deleteMessage) {
            [[MTTDatabaseUtil instance] deleteMesages:self.deleteMessage completion:^(BOOL success) {
                self.deleteMessage = nil;
            }];
        }
    } Error:^(NSError *error) {
        //        [self.tableView reloadData];
    }];
}
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [rightBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateDisabled];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = NO;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.makeView];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UIView *)tableHeader
{
    if (!_tableHeader) {
        _tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(58))];
        _tableHeader.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, 200, kHEIGHT(58))];
        label.text = @"选择一个群";
        label.font = kFONT(15);
        [_tableHeader addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, kHEIGHT(58)/2-7, 8, 14)];
        imageView.image = [UIImage imageNamed:@"jinru"];
        [_tableHeader addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [_tableHeader addGestureRecognizer:tap];
    }
    return _tableHeader;
}

- (void)click
{
    _tableHeader.backgroundColor = RGB(226, 226, 226);
    [self performSelector:@selector(backTo) afterDelay:0.3];
    WPMyGroupController *myGroup  = [[WPMyGroupController alloc] init];
    myGroup.fromChatNotCreat = self.fromChatNotCreat;
    myGroup.moreTranitArray = self.moreTranitArray;
    myGroup.display_type = self.display_type;
    myGroup.tranmitStr = self.tranmitStr;
    myGroup.toUserId = self.toUserId;
    myGroup.isFromTrnmit = self.isFromTrnmit;
    myGroup.isCreateChat = self.isFromTrnmit?NO:YES;
    [self.navigationController pushViewController:myGroup animated:YES];
}

- (void)backTo
{
    _tableHeader.backgroundColor = [UIColor whiteColor];
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
        for (LinkManListModel *model in arr) {
            if ([model.is_selected isEqualToString:@"1"] && ![model.is_be isEqualToString:@"1"]) {
                selectCount++;
            }
        }
    }
    
    self.makeView.hidden = !selectCount;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)selectCount];
    self.doneBtn.enabled = (selectCount > 0);
}


- (void)delay
{
    //    NSArray * viewArray = self.navigationController.viewControllers;
    //    [self.navigationController popToViewController:viewArray[viewArray.count-3] animated:YES];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDMEMEMBERSUCCESS" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    //    NSDictionary *params = @{@"action" : @"GetFriend",
    //                             @"username" : kShareModel.username,
    //                             @"user_id" : kShareModel.userId,
    //                             @"password" : kShareModel.password,
    //                             @"group_id" : self.model.group_id};
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"action"] = @"GetFriend";
    parame[@"user_id"] = kShareModel.userId;
    parame[@"username"] = kShareModel.username;
    parame[@"password"] = kShareModel.password;
    if (self.addType == ChooseLinkTypeDynamicGroup ) {
        parame[@"group_id"] = self.model.group_id;
    }
    [WPHttpTool postWithURL:url params:parame success:^(id json) {
        NSLog(@"%@",json);
        LinkManModel *model = [LinkManModel mj_objectWithKeyValues:json];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
        for (LinkManListModel *linkModel in arr) {
            linkModel.is_selected = @"0";
        }
        if (self.addType == ChooseLinkTypeChatGroup) {
            for (LinkManListModel *linkModel in arr) {
                linkModel.is_be = [linkModel.friend_id isEqualToString:self.currentUserId] ? @"1" : @"0";
            }
        }
        if (self.addType == ChooseLinkTypeCreateChat) {
            for (LinkManListModel *linkModel in arr) {
                linkModel.is_be = @"0";
            }
        }
        
        if (self.isFromChat) {//发送名片
            for (LinkManListModel *linkModel in arr) {
                linkModel.is_be = @"0";
            }
        }
        
        self.dataSource = [TableViewIndex transfer:arr];
        for (int i = (int)self.dataSource.count-1; i>=0; i--) {
            if ([self.dataSource[i] count] == 0) {
                [self.sectionTitle3 removeObjectAtIndex:i];
                [self.dataSource removeObjectAtIndex:i];
            }
        }
        [self updateToolBar];
        
        for (int i = 0 ; i < self.dataSource.count; i++) {
            NSArray * array = self.dataSource[i];
            for (int j = 0 ; j < array.count; j++) {
                LinkManListModel * model = array[j];
                if (model.is_be.intValue) {
                    self.numOfMemember= [NSString stringWithFormat:@"%d",self.numOfMemember.intValue+1];
                }
            }
        }
        //        for (LinkManListModel* model in self.dataSource) {
        //            if (model.is_be) {
        //                self.numOfMemember= [NSString stringWithFormat:@"%d",self.numOfMemember.intValue+1];
        //            }
        //        }
        
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getLinkMan:^(NSArray *array) {
            NSDictionary * dic = @{@"list":array};
            LinkManModel *model = [LinkManModel mj_objectWithKeyValues:dic];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
            for (LinkManListModel *linkModel in arr) {
                linkModel.is_selected = @"0";
            }
            if (self.addType == ChooseLinkTypeChatGroup) {
                for (LinkManListModel *linkModel in arr) {
                    linkModel.is_be = [linkModel.friend_id isEqualToString:self.currentUserId] ? @"1" : @"0";
                }
            }
            if (self.addType == ChooseLinkTypeCreateChat) {
                for (LinkManListModel *linkModel in arr) {
                    linkModel.is_be = @"0";
                }
            }
            
            if (self.isFromChat) {//发送名片
                for (LinkManListModel *linkModel in arr) {
                    linkModel.is_be = @"0";
                }
            }
            
            self.dataSource = [TableViewIndex transfer:arr];
            for (int i = (int)self.dataSource.count-1; i>=0; i--) {
                if ([self.dataSource[i] count] == 0) {
                    [self.sectionTitle3 removeObjectAtIndex:i];
                    [self.dataSource removeObjectAtIndex:i];
                }
            }
            [self updateToolBar];
            
            for (int i = 0 ; i < self.dataSource.count; i++) {
                NSArray * array = self.dataSource[i];
                for (int j = 0 ; j < array.count; j++) {
                    LinkManListModel * model = array[j];
                    if (model.is_be.intValue) {
                        self.numOfMemember= [NSString stringWithFormat:@"%d",self.numOfMemember.intValue+1];
                    }
                }
            }
            [self.tableView reloadData];
        }];
    }];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = [GroupChooseMemberCell cellHeight];
        if (self.addType == ChooseLinkTypeCreateChat) { //发起群聊的时候带headerView
            _tableView.tableHeaderView = self.tableHeader;
        }
        if (self.isFromChat) {
            _tableView.tableHeaderView = self.searchBar;
        }
        
        _tableView.sectionIndexColor = [UIColor blackColor];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
        
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
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        //        [self.view addSubview:_searchBar];
        //        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(ws.view).offset(64);
        //            make.left.right.equalTo(ws.view);
        //            make.height.equalTo(@(40));
        //        }];
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
    GroupChooseMemberCell *cell = [GroupChooseMemberCell cellWithTableView:tableView];
    cell.isFromChat = self.isFromChat;
    cell.isFromTranmit = self.isFromTrnmit;
    //    cell.tag = indexPath.row;
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    if (self.isFromChat) {
        cell.btnClick = ^(UIButton*sender){
            GroupChooseMemberCell * celle = (GroupChooseMemberCell*)sender.superview.superview;
            NSIndexPath * indexpath = [self.tableView indexPathForCell:celle];
            [self refreshTable:indexpath];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isFromChat)
    {
        PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
        LinkManListModel *model = self.dataSource[indexPath.section][indexPath.row];
        personalInfo.friendID = model.friend_id;
        personalInfo.isFromChat = self.isFromChat;
        //        personalInfo.comeFromVc = @"通讯录";
        [self.navigationController pushViewController:personalInfo animated:YES];
    }
    else
    {
        if (self.isFromTrnmit)
        {
            _choiseIndex = indexPath;
            LinkManListModel *model = self.dataSource[indexPath.section][indexPath.row];
            NSString * nickNaem = [NSString stringWithFormat:@"%@",model.nick_name];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定发送给%@",nickNaem] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            [self refreshTable:indexPath];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99998) {//人数大于40小于500
        if (buttonIndex == 1) {//请求新接口
            __block NSMutableArray *userIDs = [NSMutableArray new];
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
            NSMutableArray *friends = [NSMutableArray array];
            NSMutableArray * friendName = [NSMutableArray array];
            for (NSArray *arr in self.dataSource) {
                for (LinkManListModel *model in arr) {
                    if ([model.is_be isEqualToString:@"0"] && [model.is_selected isEqualToString:@"1"]) {
                        [friends addObject:model.friend_id];
                        [friendName addObject:model.nick_name];
                        [userIDs addObject:[NSString stringWithFormat:@"user_%@",model.friend_id]];
                    }
                }
            }
            NSString *friendID = [friends componentsJoinedByString:@","];
            //            NSString * friendNameStr = [friendName componentsJoinedByString:@","];
            NSDictionary *params = @{@"action"   : @"InviteJoin2",
                                     @"user_id"  : kShareModel.userId,
                                     @"username" : kShareModel.username,
                                     @"password" : kShareModel.password,
                                     @"group_id" : self.model.group_id,
                                     @"friendId" : friendID};
            //            DDAddMemberToGroupAPI*creatGroup = [[DDAddMemberToGroupAPI alloc] init];
            //            NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.groupId],userIDs];
            //            [creatGroup requestWithObject:array  Completion:^(id  response, NSError *error) {
            //                if (response != nil)
            //                {
            [WPHttpTool postWithURL:url params:params success:^(id json) {
                if ([json[@"status"] integerValue] == 0) {
                    [MBProgressHUD createHUD:json[@"info"] View:self.view];
                    if (self.inviteSuccessBlock) {
                        self.inviteSuccessBlock();
                    }
                    //                            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupUpdate" object:nil];
                    //                            [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {
                    //                                for (NSString*tring in userIDs) {
                    //                                    [group.groupUserIds addObject:tring];
                    //                                }
                    //                                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDMEMEMBERSUCCESS" object:nil];
                    //                            }];
                    [self performSelector:@selector(delay) afterDelay:1.1];//1.1
                }
                else
                {
                    _doneBtn.enabled = YES;
                }
            } failure:^(NSError *error) {
                _doneBtn.enabled = YES;
            }];
            //                }
            //            }];
        }
        else
        {
            _doneBtn.enabled = YES;
        }
        return;
    }
    else if(alertView.tag == 9999)//人数大于500
    {
        return;
    }
    else if (alertView.tag == 99999)//快速创建人数超过40
    {
        return;
    }
    else
    {
        if (buttonIndex == 1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
            if (self.moreTranitArray.count)
            {
                NSMutableArray * mesageArray = [NSMutableArray array];
                for (NSDictionary * dic  in self.moreTranitArray)
                {
                    LinkManListModel *model = self.dataSource[_choiseIndex.section][_choiseIndex.row];
                    NSString * friendId = [NSString stringWithFormat:@"%@",model.friend_id];
                    MTTSessionEntity* session = [[MTTSessionEntity alloc] initWithSessionID:[@"user_" stringByAppendingString:friendId] type:SessionTypeSessionTypeSingle];
                    self.mouble.MTTSessionEntity = session;
                    NSString * contentType = [NSString stringWithFormat:@"%@",dic[@"contentType"]];
                    self.tranmitStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                    DDMessageContentType msgContentType;
                    switch (contentType.intValue) {
                        case 0:
                            self.display_type = @"1";
                            msgContentType = DDMessageTypeText;
                            break;
                        case 1:
                            self.display_type = @"2";
                            msgContentType = DDMessageTypeImage;
                            break;
                        case 2:
                            self.display_type = @"3";
                            msgContentType = DDMessageTypeVoice;
                            break;
                        case 3:
                            self.display_type = @"";
                            msgContentType = DDMEssageEmotion;
                            break;
                        case 4:
                            self.display_type = @"6";
                            msgContentType = DDMEssagePersonalaCard;
                            break;
                        case 5:
                            self.display_type = @"8";
                            msgContentType = DDMEssageMyApply;
                            break;
                        case 6:
                            self.display_type = @"9";
                            msgContentType = DDMEssageMyWant;
                            break;
                        case 7:
                            self.display_type = @"10";
                            msgContentType = DDMEssageMuchMyWantAndApply;
                            break;
                        case 8:
                            self.display_type = @"11";
                            msgContentType = DDMEssageSHuoShuo;
                            break;
                        case 9:
                            self.display_type = @"7";
                            msgContentType = DDMEssageLitterVideo;
                            break;
                        default:
                            break;
                            
                    }
                    NSString * contentStr = [self getStringFromDic:self.tranmitStr];
                    MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble MsgType:msgContentType];
                    [mesageArray addObject:message];
                    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                        DDLog(@"消息插入DB成功");
                    } failure:^(NSString *errorDescripe) {
                        DDLog(@"消息插入DB失败");
                    }];
                    message.msgContent = contentStr;
                    [self sendMessage:self.tranmitStr messageEntity:message];
                }
                MTTMessageEntity * message = mesageArray[0];
                if ([message.toUserID isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:mesageArray];
                }
                
            }
            else
            {
                LinkManListModel *model = self.dataSource[_choiseIndex.section][_choiseIndex.row];
                NSString * friendId = [NSString stringWithFormat:@"%@",model.friend_id];
                MTTSessionEntity* session = [[MTTSessionEntity alloc] initWithSessionID:[@"user_" stringByAppendingString:friendId] type:SessionTypeSessionTypeSingle];
                self.mouble.MTTSessionEntity = session;
                DDMessageContentType msgContentType;
                switch (self.display_type.intValue) {
                    case 1:
                        msgContentType = DDMessageTypeText;
                        break;
                    case 2:
                        msgContentType = DDMessageTypeImage;
                        break;
                    case 3:
                        msgContentType = DDMessageTypeVoice;
                        break;
                    case 6:
                        msgContentType = DDMEssagePersonalaCard;
                        break;
                    case 7:
                        msgContentType = DDMEssageLitterVideo;
                        break;
                    case 8:
                        msgContentType = DDMEssageMyApply;
                        break;
                    case 9:
                        msgContentType = DDMEssageMyWant;
                        break;
                    case 10:
                        msgContentType = DDMEssageMuchMyWantAndApply;
                        break;
                    case 11:
                        msgContentType = DDMEssageSHuoShuo;
                        break;
                    default:
                        break;
                }
                NSString * contentStr = [self getStringFromDic:self.tranmitStr];
                MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble MsgType:msgContentType];
                
                if ([message.toUserID isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:message];
                }
                [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                    DDLog(@"消息插入DB成功");
                } failure:^(NSString *errorDescripe) {
                    DDLog(@"消息插入DB失败");
                }];
                message.msgContent = contentStr;
                [self sendMessage:self.tranmitStr messageEntity:message];
            }
            NSArray * viewArray = self.navigationController.viewControllers;
            [self.navigationController popToViewController:viewArray[viewArray.count-3] animated:YES];
        }
    }
}

-(void)sendMessage:(NSString *)msg messageEntity:(MTTMessageEntity *)message
{
    BOOL isGroup = NO;
    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:self.mouble.MTTSessionEntity  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToPersonSuccess" object:nil];
        });
    } Error:^(NSError *error) {
        [self.tableView reloadData];
    }];
}



-(NSString *)getStringFromDic:(NSString*)contentStr
{
    NSDictionary  * dictionary = [NSDictionary dictionary];
    if ([self.display_type isEqualToString:@"6"]||[self.display_type isEqualToString:@"8"]||[self.display_type isEqualToString:@"9"]||[self.display_type isEqualToString:@"11"]||[self.display_type isEqualToString:@"10"])
    {
        NSData * data = [self.tranmitStr dataUsingEncoding:NSUTF8StringEncoding];
        dictionary = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    NSDictionary * dic = @{@"display_type":self.display_type,@"content":dictionary.count?dictionary:contentStr};
    NSError * erreo = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&erreo];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
-(void)refreshTable:(NSIndexPath*)indexpath
{
    LinkManListModel *model = self.dataSource[indexpath.section][indexpath.row];
    model.is_selected = [model.is_selected isEqualToString:@"1"] ? @"0" : @"1";
    if ([model.is_be isEqualToString:@"0"])
    {
        [self updateToolBar];
    }
    //    [self.tableView reloadData];
    
    int num = 0;
    for (LinkManListModel * model1 in self.dataSource[indexpath.section]) {
        if (model1.is_selected.intValue) {
            ++num;
        }
    }
    if (num > 20) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择20条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        model.is_selected = @"0";
        if ([model.is_be isEqualToString:@"0"])
        {
            [self updateToolBar];
        }
    }
    else
    {
        [self.tableView reloadData];
    }
    
    //[self.tableView reloadData];
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
