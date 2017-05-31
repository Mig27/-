//
//  joinGroupApplyController.m
//  WP
//
//  Created by CC on 16/9/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "joinGroupApplyController.h"
#import "DDAddMemberToGroupAPI.h"
#import "jionGroupRejectViewController.h"
#import "ApplyGroupController.h"
#import "PersonalInfoViewController.h"
#import "WPGroupInformationViewController.h"
#import "THLabel.h"
#import "DDGroupModule.h"
#import "SessionModule.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "MLLinkLabel.h"
#import "WPGroupInformationViewController.h"
@interface joinGroupApplyController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView*tableView;
@property (nonatomic, strong)UIView*backView;
@end

@implementation joinGroupApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:self.tableView];
    
    
}
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = RGB(235, 235, 235);
    }
    return _tableView;
}

-(NSString *)getNick:(NSString * )bickName andUserName:(NSString*)userName
{
    if (bickName.length)
    {
        return bickName;
    }
    else
    {
        return userName;
    }
}
-(void)clickBtnDown:(UIButton*)btn
{
    [self.backView setBackgroundColor:RGB(226, 226, 226)];
}

-(void)clickBtnDrag:(UIButton*)btn
{
    [self.backView setBackgroundColor:[UIColor whiteColor]];
}
-(void)creatUI
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, kHEIGHT(9), kHEIGHT(54), kHEIGHT(54))];
    imageView.layer.cornerRadius= 5;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor redColor];
    [_backView addSubview:imageView];
    
    UILabel *nameLabel =[THLabel new];
    nameLabel.font = kFONT(14.5);
    nameLabel.textColor = [UIColor blackColor];
    [_backView addSubview:nameLabel];
    
    UILabel * positionLabel = [THLabel new];
    [_backView addSubview:positionLabel];
    positionLabel.textColor = RGB(127, 127, 127);
    positionLabel.font = kFONT(12);
    
    UILabel * separeLabel = [THLabel new];
    separeLabel.backgroundColor = RGB(127, 127, 127);
    separeLabel.tintColor = [UIColor redColor];
    [_backView addSubview:separeLabel];
    
    UILabel * companyLabel = [THLabel new];
    [_backView addSubview:companyLabel];
    companyLabel.textColor = RGB(127, 127, 127);
    companyLabel.font = kFONT(12);
    
    UILabel * WPlabel = [UILabel new];
    [_backView addSubview:WPlabel];
    WPlabel.textColor = RGB(127, 127, 127);
    WPlabel.font = kFONT(12);
    
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(72), SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [_backView addSubview:line];
    
    MLLinkLabel * bottomLabel = [[MLLinkLabel alloc]initWithFrame:CGRectMake(16, kHEIGHT(72), SCREEN_WIDTH-32, kHEIGHT(43))];
    bottomLabel.textColor = RGB(127, 127, 127);
    bottomLabel.font = kFONT(12);
    bottomLabel.numberOfLines = 0;
    [_backView addSubview:bottomLabel];
    
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-24, kHEIGHT(72)/2-7, 8, 14)];
    rightImage.image = [UIImage imageNamed:@"jinru"];
    [_backView addSubview:rightImage];
    
    UIButton * clickBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBnt.frame = CGRectMake(0, 0, _backView.size.width, _backView.size.height);
    //    [clickBnt setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    //    [clickBnt setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    
    [clickBnt addTarget:self action:@selector(clickBnt:) forControlEvents:UIControlEventTouchUpInside];
    [clickBnt addTarget:self action:@selector(clickBtnDown:) forControlEvents:UIControlEventTouchDown];
    [clickBnt addTarget:self action:@selector(clickBtnDrag:) forControlEvents:UIControlEventTouchDragOutside];
    [_backView addSubview:clickBnt];
    [_backView bringSubviewToFront:bottomLabel];
    
    NSString * state = [NSString stringWithFormat:@"%@",self.infoDic[@"status"]];
    NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
    NSString * a_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"a_user_id"]];
    
    /*
     *
     群通知消息现分为群主消息、群成员主动消息、群成员被动消息
     1)
     群主消息: 入群申请消息、成员退群消息
     条件：a_user_id等于0 b_user_id不等于当前用户user_id  status为0\1\2\6
     
     2）
     群成员主动消息：
     a>申请被拒绝
     条件: a_user_id等于0  b_user_id等于当前用户user_id status为2
     b>邀请被拒绝
     条件: a_user_id等于当前用户user_id status为2
     
     3)
     群成员被动消息：别人邀请我入群(满40人需验证)、被移出群组、群被解散、别人转移群主权限给我
     条件: a_user_id不等于0  b_user_id等于当前用户user_id status为0\1\2\4\5\7
     *
     */
    
    //移除或者拒绝时隐藏三个信息,切将群号码显示出来
    companyLabel.hidden = NO;
    positionLabel.hidden = NO;
    separeLabel.hidden = NO;
    
    if (![b_user_id isEqualToString:kShareModel.userId] && [a_user_id isEqualToString:@"0"])
    {   // 入群申请消息、成员退群消息
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,self.infoDic[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        
        NSString * nickName = [NSString stringWithFormat:@"%@",self.infoDic[@"b_nick_name"]];
        nameLabel.text = nickName;
        
        NSString * position= [NSString stringWithFormat:@"%@",self.infoDic[@"b_position"]];
        positionLabel.text = position;
        
        NSString * company = [NSString stringWithFormat:@"%@",self.infoDic[@"b_company"]];
        companyLabel.text = company;
        if ([self.infoDic[@"b_wp_id"] length]&& ![self.infoDic[@"b_wp_id"] isEqualToString:@"(null)"]) {
            WPlabel.text = [NSString stringWithFormat:@"快聘号 : %@",self.infoDic[@"b_wp_id"]];
        }
        
        NSString * bottomStr = nil;
        NSString * groupName= nil;
        CGFloat location;
        if (state.intValue == 6)
        {
            
            bottomStr = [NSString stringWithFormat:@"已退出 %@",self.infoDic[@"group_name"]];
            groupName = self.infoDic[@"group_name"];
            location = 4;
        }
        else if (state.intValue == 2)
        {
            bottomStr = [NSString stringWithFormat:@"拒绝加入 %@",self.infoDic[@"group_name"]];
            groupName = self.infoDic[@"group_name"];
            location = 5;
        }
        else
        {
            bottomStr = [NSString stringWithFormat:@"申请加入 %@ :大家好,我是%@",self.infoDic[@"group_name"],[self getNick:self.infoDic[@"b_nick_name"] andUserName:self.infoDic[@"b_user_name"]]];
            groupName = self.infoDic[@"group_name"];
            location = 5;
        }
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:bottomStr];
        [attStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(location,groupName.length)];
        bottomLabel.attributedText = attStr;
        for (MLLink *link in bottomLabel.links) {
            link.linkTextAttributes = @{NSForegroundColorAttributeName:RGB(0, 172, 255)};
        }
        [bottomLabel invalidateDisplayForLinks];
        WS(ws);
        [bottomLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            WPGroupInformationViewController * group = [[WPGroupInformationViewController alloc]init];
            group.titleStr = self.infoDic[@"group_name"];
            group.group_id = self.infoDic[@"g_id"];
            group.groupId = self.infoDic[@"group_id"];
            group.gtype = @"1";
            [ws.navigationController pushViewController:group animated:YES];
        }];
    }
    else if ([a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {       //申请被拒绝
        if (state.intValue == 2)
        {
            nameLabel.text = [NSString stringWithFormat:@"%@",self.infoDic[@"group_name"]];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,self.infoDic[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
            WPlabel.text = [NSString stringWithFormat:@"群号 : %@",self.infoDic[@"g_id"]];
            bottomLabel.text = [NSString stringWithFormat:@"群主拒绝了你的加群申请: %@", self.infoDic[@"denial"]];
            separeLabel.hidden = YES;
            companyLabel.hidden = YES;
            positionLabel.text = [NSString stringWithFormat:@"群号码: %@",self.infoDic[@"group_id"]];
        }
    }
    else if ([a_user_id isEqualToString:kShareModel.userId])
    {       //邀请被拒绝
        if ([state isEqualToString:@"2"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,self.infoDic[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
            
            NSString * nickName = [NSString stringWithFormat:@"%@",self.infoDic[@"b_nick_name"]];
            nameLabel.text = nickName;
            
            NSString * position= [NSString stringWithFormat:@"%@",self.infoDic[@"b_position"]];
            positionLabel.text = position;
            
            NSString * company = [NSString stringWithFormat:@"%@",self.infoDic[@"b_company"]];
            companyLabel.text = company;
            if ([self.infoDic[@"b_wp_id"] length]&& ![self.infoDic[@"b_wp_id"] isEqualToString:@"(null)"]) {
                WPlabel.text = [NSString stringWithFormat:@"快聘号 : %@",self.infoDic[@"b_wp_id"]];
            }
            
            //            bottomLabel.text = [NSString stringWithFormat:@"拒绝加入 %@",self.infoDic[@"group_name"]];
            NSString * bottomStr = [NSString stringWithFormat:@"拒绝加入 %@",self.infoDic[@"group_name"]];
            NSString * groupName = self.infoDic[@"group_name"];
            CGFloat location = 5;
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:bottomStr];
            [attStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(location,groupName.length)];
            bottomLabel.attributedText = attStr;
            for (MLLink *link in bottomLabel.links) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:RGB(0, 172, 255)};
            }
            [bottomLabel invalidateDisplayForLinks];
            WS(ws);
            [bottomLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
                WPGroupInformationViewController * group = [[WPGroupInformationViewController alloc]init];
                group.titleStr = self.infoDic[@"group_name"];
                group.group_id = self.infoDic[@"g_id"];
                group.groupId = self.infoDic[@"group_id"];
                group.gtype = @"3";
                [ws.navigationController pushViewController:group animated:YES];
            }];
            
            separeLabel.hidden = YES;
            companyLabel.hidden = YES;
            positionLabel.text = [NSString stringWithFormat:@"群号码: %@",self.infoDic[@"group_id"]];
        }
        
    }
    else if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {       //群成员被动消息：别人邀请我入群(满40人需验证)、被移出群组、群被解散、别人转移群主权限给我
        //  separeLabel.hidden = YES;
        if (state.intValue == 1 || state.intValue == 0)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,self.infoDic[@"a_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
            
            NSString * position= [NSString stringWithFormat:@"%@",self.infoDic[@"a_position"]];
            positionLabel.text = position;
            
            NSString * company = [NSString stringWithFormat:@"%@",self.infoDic[@"a_company"]];
            companyLabel.text = company;
        }
        else
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,self.infoDic[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        }
        NSString * nickName = [NSString stringWithFormat:@"%@",self.infoDic[@"group_name"]];
        nameLabel.text = nickName;
        if (state.intValue == 1 || state.intValue == 0 || state.intValue == 3)
        {
            nameLabel.text = [NSString stringWithFormat:@"%@",self.infoDic[@"a_nick_name"]];
        }
        WPlabel.text = [NSString stringWithFormat:@"群号 : %@",self.infoDic[@"g_id"]];
        if (state.intValue== 1)
        {
            WPlabel.text = [NSString stringWithFormat:@"快聘号 : %@",self.infoDic[@"a_wp_id"]];
            if (![self.infoDic[@"a_wp_id"] length]) {
                WPlabel.hidden = YES;
            }
            
        }
        if (state.intValue == 4)
        {
            bottomLabel.text = @"群主已将你移出群组";
            separeLabel.hidden = YES;
            companyLabel.hidden = YES;
            positionLabel.text = [NSString stringWithFormat:@"群号码: %@",self.infoDic[@"group_id"]];
        }
        else if (state.intValue == 1)
        {
            bottomLabel.text = [NSString stringWithFormat:@"邀请你加入%@",[self getNick:self.infoDic[@"group_name"] andUserName:self.infoDic[@"group_name"]]];
            NSString * bottomStr = [NSString stringWithFormat:@"邀请你加入 %@",self.infoDic[@"group_name"]];
            NSString * groupName = self.infoDic[@"group_name"];
            CGFloat location = 6;
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:bottomStr];
            [attStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(location,groupName.length)];
            bottomLabel.attributedText = attStr;
            for (MLLink *link in bottomLabel.links) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:RGB(0, 172, 255)};
            }
            [bottomLabel invalidateDisplayForLinks];
            WS(ws);
            [bottomLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
                WPGroupInformationViewController * group = [[WPGroupInformationViewController alloc]init];
                group.titleStr = self.infoDic[@"group_name"];
                group.group_id = self.infoDic[@"g_id"];
                group.groupId = self.infoDic[@"group_id"];
                UIButton * button = [self.view viewWithTag:56788];
                if ([button.titleLabel.text isEqualToString:@"已同意"]) {
                    group.gtype = @"2";
                }else{
                    group.gtype = @"3";
                }
                
                [ws.navigationController pushViewController:group animated:YES];
            }];
            
            
            
        }
        else if (state.intValue == 5)
        {
            bottomLabel.text = @"群主已解散群组";
        }
        else if (state.intValue == 7)
        {
            bottomLabel.text = [NSString stringWithFormat:@"%@已将群主权限转移给你,你已成为群主",[self getNick:self.infoDic[@"a_nick_name"] andUserName:self.infoDic[@"a_user_name"]]];
            separeLabel.hidden = YES;
            companyLabel.hidden = YES;
            positionLabel.text = [NSString stringWithFormat:@"群号码: %@",self.infoDic[@"group_id"]];
        }
        else
        {
            //           bottomLabel.text = [NSString stringWithFormat:@"%@邀请你加入群组",[self getNick:self.infoDic[@"a_nick_name"] andUserName:self.infoDic[@"a_user_name"]]];
            bottomLabel.text = [NSString stringWithFormat:@"邀请你加入%@",[self getNick:self.infoDic[@"group_name"] andUserName:self.infoDic[@"group_name"]]];
            NSString * bottomStr = [NSString stringWithFormat:@"邀请你加入 %@",self.infoDic[@"group_name"]];
            NSString * groupName = self.infoDic[@"group_name"];
            CGFloat location = 6;
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:bottomStr];
            [attStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(location,groupName.length)];
            bottomLabel.attributedText = attStr;
            for (MLLink *link in bottomLabel.links) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:RGB(0, 172, 255)};
            }
            [bottomLabel invalidateDisplayForLinks];
            WS(ws);
            [bottomLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
                WPGroupInformationViewController * group = [[WPGroupInformationViewController alloc]init];
                group.titleStr = self.infoDic[@"group_name"];
                group.group_id = self.infoDic[@"g_id"];
                group.groupId = self.infoDic[@"group_id"];
                if (state.intValue == 3) {
                    group.gtype = @"3";
                }else{
                    group.gtype = @"2";
                }
                
                [ws.navigationController pushViewController:group animated:YES];
            }];
            NSString * position= [NSString stringWithFormat:@"%@",self.infoDic[@"a_position"]];
            positionLabel.text = position;
            
            NSString * company = [NSString stringWithFormat:@"%@",self.infoDic[@"a_company"]];
            companyLabel.text = company;
        }
    }
    
    //    BOOL isOrNot = [self.infoDic[@"b_wp_id"] length];
    BOOL isOrNot = NO;
    if (![b_user_id isEqualToString:kShareModel.userId]) {
        isOrNot = [self.infoDic[@"b_wp_id"] length];
    }
    else
    {
        if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId]) {
            if (state.intValue == 1)
            {
                isOrNot = [self.infoDic[@"a_wp_id"] length];
            }
            else
            {
                isOrNot = [self.infoDic[@"g_id"] length];
            }
        }
        else
        {
            isOrNot = [self.infoDic[@"g_id"] length];
        }
        //        isOrNot = [self.infoDic[@"g_id"] length];
    }
    
    NSString * nickName;
    if (![b_user_id isEqualToString:kShareModel.userId] && [a_user_id isEqualToString:@"0"])
    {
        nickName =  [NSString stringWithFormat:@"%@",self.infoDic[@"b_nick_name"]];
    }
    else if ([a_user_id isEqualToString:kShareModel.userId])
    {
        nickName =  [NSString stringWithFormat:@"%@",self.infoDic[@"b_nick_name"]];
    }
    else if ([a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {
        nickName =  [NSString stringWithFormat:@"%@",self.infoDic[@"group_name"]];
    }
    else
    {
        if (state.intValue == 1)
        {
            nickName =  [NSString stringWithFormat:@"%@",self.infoDic[@"a_nick_name"]];
        }
        else
        {
            nickName =  [NSString stringWithFormat:@"%@",self.infoDic[@"group_name"]];
        }
        //      nickName =  [NSString stringWithFormat:@"%@",self.infoDic[@"group_name"]];
    }
    CGSize size = [nickName getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(54)/2];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(kHEIGHT(10));
        make.bottom.equalTo(imageView.mas_centerY).offset((-4));
        make.size.mas_equalTo(CGSizeMake(size.width, 20));
    }];
    
    NSString * position= [NSString stringWithFormat:@"%@",self.infoDic[@"b_position"]];
    if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId]) {
        if (state.intValue == 1) {
            position = [NSString stringWithFormat:@"%@",self.infoDic[@"a_position"]];
        }
        
    }
    CGSize size1 = [position getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(54)/2];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(size1.width, 20));
    }];
    //    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(nameLabel.mas_right).offset(8);
    //        make.bottom.equalTo(nameLabel.mas_bottom).offset(0);
    //        make.size.mas_equalTo(CGSizeMake(size1.width, 20));
    //    }];
    
    
    [separeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(positionLabel.mas_right).offset(8);
        make.bottom.equalTo(positionLabel.mas_bottom).offset(-3);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    NSString * company = [NSString stringWithFormat:@"%@",self.infoDic[@"b_company"]];
    if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId]) {
        if (state.intValue == 1) {
            position = [NSString stringWithFormat:@"%@",self.infoDic[@"a_company"]];
        }
        
    }
    CGSize size2 = [company getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(54)/2];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(positionLabel.mas_right).offset(16);
        make.bottom.equalTo(positionLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(size2.width, 20));
    }];
    
    
    //    [WPlabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(nameLabel.mas_left);
    //        make.top.equalTo(nameLabel.mas_bottom).offset(8);
    //        make.size.mas_equalTo(CGSizeMake(120, 20));
    //    }];
}

#pragma mark 跳到个人资料界面
// FIXME: 此处将b_user_id(申请人) 修改为 a_user_id(邀请人)
//我被邀请,同意了,详情页,点击邀请人资料进入好友页面
-(void)clickBnt:(UIButton*)sender
{
    // if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    NSString *b_user_id = self.infoDic[@"b_user_id"];
    NSString * state = [NSString stringWithFormat:@"%@",self.infoDic[@"status"]];
    NSString * a_user_id = self.infoDic[@"a_user_id"];
    
    
    if([a_user_id isEqualToString:@"0"] && ![b_user_id isEqualToString:kShareModel.userId])
    {   //群主消息
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        [self isOrNotFriendsuccess:^(NSArray *array) {
            BOOL isOrNot = NO;
            for (NSDictionary * dictionar in array) {
                if ([dictionar[@"friend_id"] isEqualToString:self.infoDic[@"b_user_id"]]) {
                    isOrNot = YES;
                }
            }
            personInfo.newType = isOrNot?NewRelationshipTypeFriend:NewRelationshipTypeStranger;
            personInfo.friendID = self.infoDic[@"b_user_id"];
            [self.navigationController pushViewController:personInfo animated:YES];
        } andFailed:^(NSError *error) {
            
        }];
    }else if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId] && state.intValue == 0)
    {   //群成员消息
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        [self isOrNotFriendsuccess:^(NSArray *array) {
            BOOL isOrNot = NO;
            for (NSDictionary * dictionar in array) {
                if ([dictionar[@"friend_id"] isEqualToString:self.infoDic[@"b_user_id"]]) {
                    isOrNot = YES;
                }
            }
            personInfo.newType = isOrNot?NewRelationshipTypeFriend:NewRelationshipTypeStranger;
            personInfo.friendID = self.infoDic[@"a_user_id"];
            [self.navigationController pushViewController:personInfo animated:YES];
        } andFailed:^(NSError *error) {
            
        }];
    }
    else if ([b_user_id isEqualToString:kShareModel.userId] && state.intValue != 4 && state.intValue != 0 && state.intValue != 2 && state.intValue != 7)//显示群成员
    { //进入个人资料  个人 / 群成员
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        [self isOrNotFriendsuccess:^(NSArray *array) {
            BOOL isOrNot = NO;
            for (NSDictionary * dictionar in array) {
                if ([dictionar[@"friend_id"] isEqualToString:self.infoDic[@"b_user_id"]]) {
                    isOrNot = YES;
                }
            }
            personInfo.newType = isOrNot?NewRelationshipTypeFriend:NewRelationshipTypeStranger;
            personInfo.friendID = self.infoDic[@"a_user_id"];
            [self.navigationController pushViewController:personInfo animated:YES];
        } andFailed:^(NSError *error) {
            
        }];
    }
    else
    {
        WPGroupInformationViewController *information = [[WPGroupInformationViewController alloc] init];
        information.titleStr = self.infoDic[@"group_name"];
        information.group_id = self.infoDic[@"g_id"];
        information.groupId = self.infoDic[@"group_id"];
        information.gtype = [self.infoDic[@"status"] isEqualToString:@"0"]?@"2":([self.infoDic[@"status"] isEqualToString:@"7"]?@"1":@"3");
        information.isFromZhiChang = YES;
        [self.navigationController pushViewController:information animated:YES];
    }
}
-(void)isOrNotFriendsuccess:(successBlock)success andFailed:(faieldBlock)failed
{
    
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    
    WPShareModel *model = [WPShareModel sharedModel];
    
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"GetFriend";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSArray * array = json[@"list"];
        success(array);
        
    } failure:^(NSError *error) {
        failed(error);
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-64;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"identifierhaha";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = RGB(235, 235, 235);
    cell.selectionStyle = UITableViewCellAccessoryNone;
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_HEIGHT, kHEIGHT(115))];
    _backView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:_backView];
    [self creatUI];
    
    
    UIButton * agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(kHEIGHT(10), 15+20+kHEIGHT(115), SCREEN_WIDTH-2*kHEIGHT(10), kHEIGHT(38));
    [agreeBtn setBackgroundColor:RGB(0, 172, 255)];
    agreeBtn.layer.cornerRadius = 5;
    agreeBtn.tag = 56788;
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeBtn setTitle:@"接受邀请" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(clickAgree:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:agreeBtn];
    
    
    UIButton * rejectBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame = CGRectMake(kHEIGHT(10), agreeBtn.bottom+15, SCREEN_WIDTH-2*kHEIGHT(10), kHEIGHT(38));
    [rejectBtn setBackgroundColor:[UIColor whiteColor]];
    rejectBtn.layer.cornerRadius = 5;
    rejectBtn.tag = 56789;
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rejectBtn setTitle:@"拒绝邀请" forState:UIControlStateNormal];
    [rejectBtn addTarget:self action:@selector(clickReject) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:rejectBtn];
    
    
    
    NSString * state = [NSString stringWithFormat:@"%@",self.infoDic[@"status"]];
    NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
    NSString * a_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"a_user_id"]];
    
    if (![b_user_id isEqualToString:kShareModel.userId] &&[a_user_id isEqualToString:@"0"]) {
        NSString * status = self.infoDic[@"status"];
        switch (status.intValue) {
            case 0:
            {
                [agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
                agreeBtn.titleLabel.font = kFONT(12);
                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
                
            }
                break;
            case 1:
                [agreeBtn setTitle:@"接受申请" forState:UIControlStateNormal];
                [rejectBtn setTitle:@"拒绝申请" forState:UIControlStateNormal];
                break;
            case 3:
            {
                [agreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                agreeBtn.titleLabel.font = kFONT(12);
                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
            }
                break;
            case 6:
            {
                //                [agreeBtn setTitle:@"已退出" forState:UIControlStateNormal];
                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
                agreeBtn.hidden = YES;
            }
                break;
            default:
                break;
        }
    }
    else if ([a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {
        NSString * status = self.infoDic[@"status"];
        if (status.intValue == 2)
        {
            [agreeBtn setTitle:@"重新申请" forState:UIControlStateNormal];
            rejectBtn.hidden = YES;
            
        }
    }
    else if ([a_user_id isEqualToString:kShareModel.userId])
    {
        if (state.intValue == 2)
        {
            [agreeBtn setTitle:@"重新邀请" forState:UIControlStateNormal];
            //            [agreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            //            agreeBtn.titleLabel.font = kFONT(12);
            //            [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
            //            [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            rejectBtn.hidden = YES;
        }
    }
    else if(![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {
        NSString * status = self.infoDic[@"status"];
        switch (status.intValue) {
            case 0:
            {
                [agreeBtn setTitle:@"已同意" forState:UIControlStateNormal];
                agreeBtn.titleLabel.font = kFONT(12);
                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
            }
                break;
            case 1:
                
                break;
            case 3:
            {
                //                [agreeBtn setTitle:@"重新申请" forState:UIControlStateNormal];
                //                rejectBtn.hidden = YES;
                [agreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                agreeBtn.titleLabel.font = kFONT(12);
                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
            }
                break;
            case 4:
            {
                [agreeBtn setTitle:@"重新申请" forState:UIControlStateNormal];
                //                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                //                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
                //                agreeBtn.hidden = YES;
                
            }
                break;
            case 5:
            {
                [agreeBtn setTitle:@"该群已解散" forState:UIControlStateNormal];
                [agreeBtn setBackgroundColor:RGB(235, 235, 235)];
                [agreeBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                rejectBtn.hidden = YES;
            }
                break;
            case 7:
            {
                agreeBtn.hidden = YES;
                rejectBtn.hidden = YES;
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

-(void)isExitOfGroup:(NSString*)groupId  success:(void(^)(id))Success failed:(void(^)(NSError*))Failed
{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"action" : @"GroupInfo",
                             @"g_id" :groupId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        Success(json);
    } failure:^(NSError *error) {
        Failed(error);
    }];
}


-(void)isFullOrNot:(NSString *)groupId success:(void(^)(id))Success andFailed:(void(^)(NSError*))failed
{
    
    
    NSDictionary * dic = @{@"action":@"IsGroupMember",@"group_id":groupId,@"username":kShareModel.username,@"password":kShareModel.password};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/Group_member.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * string = json[@"count"];
        Success(string);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

-(void)clickAgree:(UIButton*)sender
{
    WS(ws);
    [self isFullOrNot:self.infoDic[@"group_id"] success:^(id str) {
        NSString * string = (NSString*)str;
        if (string.intValue  >= 500) {
            [MBProgressHUD createHUD:@"群人数已达上限" View:self.view];
            return ;
        }else if (string.intValue == 0){
            [MBProgressHUD createHUD:@"该群已被解散" View:self.view];
            return;
        }
        else
        {
            if ([sender.titleLabel.text isEqualToString:@"重新申请"]||[sender.titleLabel.text isEqualToString:@"重新邀请"])
            {
                [self isExitOfGroup:self.infoDic[@"g_id"] success:^(id json) {
                    if (!json) {
                        [MBProgressHUD createHUD:@"获取群信息失败" View:self.view];
                        return ;
                    }
                    NSArray * MenberList = json[@"json"][0][@"MenberList"];
                    BOOL isExitOrNot = NO;
                    for (NSDictionary* dic in MenberList) {
                        NSString * user_id = dic[@"user_id"];
                        if ([sender.titleLabel.text isEqualToString:@"重新申请"])
                        {
                            if ([user_id isEqualToString:kShareModel.userId]) {
                                isExitOrNot = YES;
                            }
                        }
                        else
                        {
                            NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
                            if ([b_user_id isEqualToString:user_id]) {
                                isExitOrNot = YES;
                            }
                        }
                    }
                    
                    if (isExitOrNot)//存在群中
                    {
                        NSString * string = nil;
                        if ([sender.titleLabel.text isEqualToString:@"重新申请"])
                        {
                            string = @"你已是该群成员";
                        }
                        else
                        {
                            string = @"对方已是该群成员";
                        }
                        [MBProgressHUD createHUD:string View:self.view];
                    }
                    else
                    {
                        if ([sender.titleLabel.text isEqualToString:@"重新申请"])
                        {
                            ApplyGroupController *apply = [[ApplyGroupController alloc] init];
                            apply.group_id = self.infoDic[@"group_id"];
                            [self.navigationController pushViewController:apply animated:YES];
                        }
                        else//重新邀请
                        {
                            [self imviteAgain:self.infoDic[@"b_user_id"] andGroup:self.infoDic[@"group_id"]];
                        }
                    }
                    
                } failed:^(NSError *error) {
                    [MBProgressHUD createHUD:@"获取群信息失败" View:self.view];
                }];
            }
            else
            {
                
                NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
                NSString * action;
                if (![b_user_id isEqualToString:kShareModel.userId])
                {
                    action = @"examineJoin";
                }
                else
                {
                    action = @"examineJoin2";
                }
                
                
                NSDictionary * dictionary = @{@"action":action,//@"examineJoin"
                                              @"status":@"0",
                                              @"user_id":kShareModel.userId,
                                              @"username":kShareModel.username,
                                              @"password":kShareModel.password,
                                              @"denial":@"",
                                              @"group_id":self.infoDic[@"group_id"],
                                              @"join_nick_name":self.infoDic[@"b_user_name"],
                                              @"join_user_id":self.infoDic[@"b_user_id"]
                                              };
                NSString * urlStr = [NSString stringWithFormat:@"%@/android/Group_member.ashx",IPADDRESS];
                DDAddMemberToGroupAPI *groupApi = [[DDAddMemberToGroupAPI alloc]init];
                __block NSMutableArray * muarray = [NSMutableArray array];
                [muarray addObject:[NSString stringWithFormat:@"user_%@",self.infoDic[@"b_user_id"]]];
                NSArray * array = @[[NSString stringWithFormat:@"group_%@",self.infoDic[@"g_id"]],muarray];
                
                [groupApi requestWithObject:array Completion:^(id response, NSError *error) {
                    if (response) {
                        [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
                            [sender setTitle:@"已同意" forState:UIControlStateNormal];
                            [sender setBackgroundColor:RGB(235, 235, 235)];
                            [sender setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                            sender.userInteractionEnabled = NO;
                            sender.titleLabel.font = kFONT(12);
                            UIButton * button = (UIButton*)[self.view viewWithTag:56789];
                            button.hidden = YES;
                            if (self.listAgree) {
                                self.listAgree(self.indexpath);
                            }
                            [self sendMessageToGroup];
                        } failure:^(NSError *error) {
                        }];
                    }
                }];
            }
        }
    } andFailed:^(NSError *error) {
        [MBProgressHUD createHUD:@"网络错误" View:self.view];
    }];
    
    
    
    //    if ([sender.titleLabel.text isEqualToString:@"重新申请"]||[sender.titleLabel.text isEqualToString:@"重新邀请"])
    //    {
    //        [self isExitOfGroup:self.infoDic[@"g_id"] success:^(id json) {
    //            if (!json) {
    //                [MBProgressHUD createHUD:@"获取群信息失败" View:self.view];
    //                return ;
    //            }
    //            NSArray * MenberList = json[@"json"][0][@"MenberList"];
    //            BOOL isExitOrNot = NO;
    //            for (NSDictionary* dic in MenberList) {
    //                NSString * user_id = dic[@"user_id"];
    //                if ([sender.titleLabel.text isEqualToString:@"重新申请"])
    //                {
    //                    if ([user_id isEqualToString:kShareModel.userId]) {
    //                        isExitOrNot = YES;
    //                    }
    //                }
    //                else
    //                {
    //                  NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
    //                    if ([b_user_id isEqualToString:user_id]) {
    //                        isExitOrNot = YES;
    //                    }
    //                }
    //            }
    //
    //            if (isExitOrNot)//存在群中
    //            {
    //                NSString * string = nil;
    //                if ([sender.titleLabel.text isEqualToString:@"重新申请"])
    //                {
    //                    string = @"你已是该群成员";
    //                }
    //                else
    //                {
    //                  string = @"对方已是该群成员";
    //                }
    //                [MBProgressHUD createHUD:string View:self.view];
    //            }
    //            else
    //            {
    //                if ([sender.titleLabel.text isEqualToString:@"重新申请"])
    //                {
    //                    ApplyGroupController *apply = [[ApplyGroupController alloc] init];
    //                    apply.group_id = self.infoDic[@"group_id"];
    //                    [self.navigationController pushViewController:apply animated:YES];
    //                }
    //                else//重新邀请
    //                {
    //                    [self imviteAgain:self.infoDic[@"b_user_id"] andGroup:self.infoDic[@"group_id"]];
    //                }
    //            }
    //
    //        } failed:^(NSError *error) {
    //            [MBProgressHUD createHUD:@"获取群信息失败" View:self.view];
    //        }];
    //    }
    //    else
    //    {
    //
    //        NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
    //        NSString * action;
    //        if (![b_user_id isEqualToString:kShareModel.userId])
    //        {
    //          action = @"examineJoin";
    //        }
    //        else
    //        {
    //          action = @"examineJoin2";
    //        }
    //
    //
    //        NSDictionary * dictionary = @{@"action":action,//@"examineJoin"
    //                                      @"status":@"0",
    //                                      @"user_id":kShareModel.userId,
    //                                      @"username":kShareModel.username,
    //                                      @"password":kShareModel.password,
    //                                      @"denial":@"",
    //                                      @"group_id":self.infoDic[@"group_id"],
    //                                      @"join_nick_name":self.infoDic[@"b_user_name"],
    //                                      @"join_user_id":self.infoDic[@"b_user_id"]
    //                                      };
    //        NSString * urlStr = [NSString stringWithFormat:@"%@/android/Group_member.ashx",IPADDRESS];
    //        DDAddMemberToGroupAPI *groupApi = [[DDAddMemberToGroupAPI alloc]init];
    //        __block NSMutableArray * muarray = [NSMutableArray array];
    //        [muarray addObject:[NSString stringWithFormat:@"user_%@",self.infoDic[@"b_user_id"]]];
    //        NSArray * array = @[[NSString stringWithFormat:@"group_%@",self.infoDic[@"g_id"]],muarray];
    //
    //        [groupApi requestWithObject:array Completion:^(id response, NSError *error) {
    //            if (response) {
    //                [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
    //                    [sender setTitle:@"已同意" forState:UIControlStateNormal];
    //                    [sender setBackgroundColor:RGB(235, 235, 235)];
    //                    [sender setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    //                    sender.userInteractionEnabled = NO;
    //                    sender.titleLabel.font = kFONT(12);
    //                    UIButton * button = (UIButton*)[self.view viewWithTag:56789];
    //                    button.hidden = YES;
    //                    if (self.listAgree) {
    //                        self.listAgree(self.indexpath);
    //                    }
    //                    [self sendMessageToGroup];
    //                } failure:^(NSError *error) {
    //                }];
    //            }
    //        }];
    //    }
}
-(void)imviteAgain:(NSString*)userId andGroup:(NSString*)groupId
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_member.ashx"];
    NSDictionary *params = @{@"action"   : @"InviteJoin2",
                             @"user_id"  : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"group_id" : groupId,
                             @"friendId" : userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD createHUD:json[@"info"] View:self.view];
        }
        else
        {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}



-(void)sendMessageToGroup
{
    
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.infoDic[@"g_id"]] completion:^(MTTGroupEntity *group) {
        MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        if (!session) {
            session = [[MTTSessionEntity alloc]initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
        }
        ChattingModule*mouble = [[ChattingModule alloc] init];
        mouble.MTTSessionEntity = session;
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":self.infoDic[@"b_user_id"],
                                                   @"for_username":self.infoDic[@"b_nick_name"],
                                                   @"note_type":@"0",
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
        [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        } Error:^(NSError *error) {
            [self.tableView reloadData];
        }];
    }];
    
}
-(void)clickReject
{
    [self isFullOrNot:self.infoDic[@"group_id"] success:^(id str) {
        NSString * string = (NSString*)str;
        if (string.intValue == 0){
            [MBProgressHUD createHUD:@"该群已被解散" View:self.view];
            return;
        }
        NSString * b_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"b_user_id"]];
        NSString * a_user_id = [NSString stringWithFormat:@"%@",self.infoDic[@"a_user_id"]];
        if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
        {
            [MBProgressHUD showMessage:@"" toView:self.view];
            NSString * action = [NSString string];
            action= @"examineJoin2";
            NSDictionary * dictionary = @{@"action":action,//@"examineJoin"
                                          @"status":@"2",
                                          @"user_id":kShareModel.userId,
                                          @"username":kShareModel.username,
                                          @"password":kShareModel.password,
                                          @"denial":@"",
                                          @"group_id":self.infoDic[@"group_id"],
                                          @"join_nick_name":self.infoDic[@"b_user_name"],
                                          @"join_user_id":self.infoDic[@"b_user_id"],
                                          @"a_user_id":self.infoDic[@"a_user_id"]
                                          };
            NSString * urlStr = [NSString stringWithFormat:@"%@/android/Group_member.ashx",IPADDRESS];
            [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
                [MBProgressHUD hideHUDForView:self.view];
                UIButton * button = (UIButton*)[self.view viewWithTag:56788];
                UIButton * button1 = (UIButton*)[self.view viewWithTag:56789];
                button1.hidden = YES;
                [button setTitle:@"已拒绝" forState:UIControlStateNormal];
                [button setBackgroundColor:RGB(235, 235, 235)];
                [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                button.titleLabel.font = kFONT(12);
                button.userInteractionEnabled = NO;
                if (self.listReject) {
                    self.listReject(self.indexpath);
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD createHUD:error.description View:self.view];
            }];
        }
        else
        {
            ApplyGroupController * apply = [[ApplyGroupController alloc]init];
            apply.dictionary = self.infoDic;
            apply.isFromGroupApply = YES;
            apply.rejectPass= ^(){
                UIButton * button = (UIButton*)[self.view viewWithTag:56788];
                UIButton * button1 = (UIButton*)[self.view viewWithTag:56789];
                button1.hidden = YES;
                [button setTitle:@"已拒绝" forState:UIControlStateNormal];
                [button setBackgroundColor:RGB(235, 235, 235)];
                [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
                button.titleLabel.font = kFONT(12);
                button.userInteractionEnabled = NO;
                if (self.listReject) {
                    self.listReject(self.indexpath);
                }
            };
            [self.navigationController pushViewController:apply animated:YES];
        }
        
        //    ApplyGroupController * apply = [[ApplyGroupController alloc]init];
        //    apply.dictionary = self.infoDic;
        //    apply.isFromGroupApply = YES;
        //    apply.rejectPass= ^(){
        //        UIButton * button = (UIButton*)[self.view viewWithTag:56788];
        //        UIButton * button1 = (UIButton*)[self.view viewWithTag:56789];
        //        button1.hidden = YES;
        //        [button setTitle:@"已拒绝该申请" forState:UIControlStateNormal];
        //        [button setBackgroundColor:RGB(235, 235, 235)];
        //        [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        //        button.titleLabel.font = kFONT(12);
        //        button.userInteractionEnabled = NO;
        //        if (self.listReject) {
        //            self.listReject(self.indexpath);
        //        }
        //    };
        //    [self.navigationController pushViewController:apply animated:YES];
    } andFailed:^(NSError *error) {
        [MBProgressHUD createHUD:@"网络错误" View:self.view];
    }];
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
