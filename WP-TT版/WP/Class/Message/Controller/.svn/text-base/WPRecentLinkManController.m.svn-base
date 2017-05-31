//
//  WPRecentLinkManController.m
//  WP
//
//  Created by CC on 16/8/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRecentLinkManController.h"
#import "recentLinkTableViewCell.h"
#import "LinkManViewController.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "MTTDatabaseUtil.h"
#import "WPChooseLinkViewController.h"
#import "DDMessageSendManager.h"
@interface WPRecentLinkManController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)UITableView*tableView;
@property (nonatomic, strong)UISearchBar * searchBar1;
@property (nonatomic, strong)ChattingModule*mouble;
@property (nonatomic, strong)NSIndexPath*choisePath;
@end

@implementation WPRecentLinkManController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    [self.view addSubview:self.tableView];
}
-(ChattingModule*)mouble
{
    if (!_mouble)
    {
        _mouble = [[ChattingModule alloc]init];
    }
    return _mouble;
}
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
-(UITableView*)tableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(64, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.sectionIndexColor = [UIColor blackColor];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    _tableView.tableHeaderView = self.searchBar1;
    _tableView.separatorInset =UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
       return self.dataSource.count;
     }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return kHEIGHT(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
     return 20;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = RGB(235, 235, 235);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 20)];
    label.text = @"最近聊天";
    label.font = kFONT(12);
    label.textColor = [UIColor grayColor];
    label.backgroundColor =RGB(235, 235, 235);
    [view addSubview:label];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString * identifier = @"recentLinkTableViewCell";
    recentLinkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
   
    
    if (!cell )
    {
        cell = [[recentLinkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0)
    {
        cell.iconImage.hidden = YES;
        cell.nameLabel.left = 10;
        cell.nameLabel.text = @"通讯录";
        cell.groupBtn.hidden = YES;
        
        cell.rightImage.hidden = NO;
        [cell.contentView addSubview:cell.rightImage];
       
    }
    else
    {
      cell.iconImage.hidden = NO;
      cell.rightImage.hidden = YES;
      cell.nameLabel.left = cell.iconImage.right +10;
     [cell setNameAndImage:self.dataSource[indexPath.row]];
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0)
    {
        WPChooseLinkViewController *choose = [[WPChooseLinkViewController alloc] init];
        choose.fromChatNotCreat = self.fromChatNotCreat;
        choose.display_type = self.display_type;
        choose.tranmitStr = self.transStr;
        choose.isFromTrnmit= YES;
        choose.moreTranitArray = self.moreTranitArray;
        choose.addType = ChooseLinkTypeCreateChat;
        choose.toUserId = self.toUserId;
        [self.navigationController pushViewController:choose animated:YES];
    }
    else
    {
        _choisePath = indexPath;
        MTTSessionEntity * session = self.dataSource[indexPath.row];
        NSString * nameStr = [NSString stringWithFormat:@"%@",session.name];
       
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定发送给%@",nameStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        //发出通知改变消息页面
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
        
        //分享的说说次数加一
        if (self.isFromShuoDetail) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString * urlStr = [NSString stringWithFormat:@"%@/ios/sharefile.ashx",IPADDRESS];
                NSDictionary * dic = @{@"action":@"shareSpeak",@"jobid":self.shuoID,@"user_id":kShareModel.userId};
                [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToFriendSuccess" object:nil];
                    
                } failure:^(NSError *error) {
                }];
            });
        }
        
        //分享的面试招聘
        if (self.isFromApplyInvite) {
            NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
            NSDictionary *params = @{@"action":(self.isRecruit == 0?@"oneshareresume":@"onesharejob"),
                                     (self.isRecruit == 0?@"resumeid":@"jobid"):self.shuoID,
                                     @"user_id":kShareModel.userId,
                                     };
            [WPHttpTool postWithURL:str params:params success:^(id json) {
               [[NSNotificationCenter defaultCenter] postNotificationName:@"sendApplyToFriendSuccess" object:nil]; 
            } failure:^(NSError *error) {
            }];
        }
        
        
        
        if (self.moreTranitArray.count)
        {
            NSMutableArray * mesageArray = [NSMutableArray array];
            for (NSDictionary * dic  in self.moreTranitArray)
            {
                NSString * contentType = [NSString stringWithFormat:@"%@",dic[@"contentType"]];
                self.transStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                self.mouble.MTTSessionEntity = self.dataSource[_choisePath.row];
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
                    case 11:
                        self.display_type = @"13";
                        msgContentType = DDMEssageLitteralbume;
                        break;
                    case 12:
                        self.display_type = @"14";
                        msgContentType = DDMEssageAcceptApply;
                        break;
                    case 13:
                        self.display_type = @"15";
                        msgContentType = DDMEssageMuchCollection;
                        break;
                    default:
                        break;
                        
                }
                NSString * contentStr = [self getStringFromDic:self.transStr];
                
                MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble MsgType:msgContentType];
                
              
                
                [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                    DDLog(@"消息插入DB成功");
                } failure:^(NSString *errorDescripe) {
                    DDLog(@"消息插入DB失败");
                }];
                
                message.msgContent = contentStr;
                [self sendMessage:self.transStr messageEntity:message];
                 message.msgContent = contentStr;
                [mesageArray addObject:message];
                
                if (mesageArray.count == self.moreTranitArray.count) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:mesageArray];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
                }
                
            }
            
//                if ([message.toUserID isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:mesageArray];
//                }

        }
        else
        {
            self.mouble.MTTSessionEntity = self.dataSource[_choisePath.row];
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
                case 13:
                    msgContentType = DDMEssageLitteralbume;
                    break;
                case 14:
                    msgContentType = DDMEssageAcceptApply;
                    break;
                case 15:
                    msgContentType = DDMEssageMuchCollection;
                    break;
                default:
                    break;
            }
            
//            NSString * contentStr = [self getStringFromDic:self.transStr];
            NSString * contentStr = [NSString string];
            if (msgContentType == DDMEssageLitterVideo)
            {
                contentStr =self.transStr;
            }
            else
            {
               contentStr =[self getStringFromDic:self.transStr];
            }
            
            
            MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble MsgType:msgContentType];
            
//            NSString * toUserId = [NSString stringWithFormat:@"%@",message.toUserID];
//            if ([toUserId isEqualToString:self.toUserId]) {//发送给 i同一个人是要刷新界面
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:message];
//            }
            
            
            [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                DDLog(@"消息插入DB成功");
            } failure:^(NSString *errorDescripe) {
                DDLog(@"消息插入DB失败");
            }];
           
            message.msgContent = contentStr;
            [self sendMessage:contentStr messageEntity:message];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
                message.msgContent = contentStr;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:message];
            });
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
//            message.msgContent = contentStr;
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToSamePeople" object:message];
            
        }
        
        [self performSelector:@selector(popoverBack) afterDelay:0.5];
    }
    

}
-(void)popoverBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
     [self.navigationController popViewControllerAnimated:YES];
    });
// [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendMessage:(NSString *)msg messageEntity:(MTTMessageEntity *)message
{
    message.msgContent = msg;
    BOOL isGroup = [self.mouble.MTTSessionEntity isGroup];
    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:self.mouble.MTTSessionEntity  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendToPersonSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tranmitMoreMessageSuccess" object:nil];
        });
    } Error:^(NSError *error) {
        [self.tableView reloadData];
    }];
}
-(NSString *)getStringFromDic:(NSString*)contentStr
{
    NSDictionary  * dictionary = [NSDictionary dictionary];
    if ([self.display_type isEqualToString:@"6"]||[self.display_type isEqualToString:@"8"]||[self.display_type isEqualToString:@"9"]||[self.display_type isEqualToString:@"11"]||[self.display_type isEqualToString:@"10"]||[self.display_type isEqualToString:@"13"]||[self.display_type isEqualToString:@"15"])
    {
        NSData * data = [self.transStr dataUsingEncoding:NSUTF8StringEncoding];
        dictionary = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    NSDictionary * dic = @{@"display_type":self.display_type,@"content":dictionary.count?dictionary:contentStr};
    NSError * erreo = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&erreo];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
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
