//
//  RecentGroupMessageCell.m
//  WP
//
//  Created by CC on 16/10/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "RecentGroupMessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+DDAddition.h"
#import "UIView+Addition.h"
#import "RuntimeStatus.h"
#import "MTTUserEntity.h"
#import "DDMessageModule.h"
#import "DDUserModule.h"
#import "MTTSessionEntity.h"
#import "DDGroupModule.h"
#import <QuartzCore/QuartzCore.h>
#import "MTTPhotosCache.h"
#import "MTTDatabaseUtil.h"
#import <Masonry/Masonry.h>
#import "MTTAvatarImageView.h"
#import "WPMySecurities.h"
#import "MTTMessageEntity.h"
#import "DDMessageModule.h"
#import "GetGroupInfoAPI.h"
#import "WPDownLoadVideo.h"
@implementation RecentGroupMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avatarImageView = [MTTAvatarImageView new];
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView setClipsToBounds:YES];
        [_avatarImageView.layer setCornerRadius:4.0];
        _avatarImageView.frame = CGRectMake(kHEIGHT(12), 10, 50, 50);
        
        
        _unreadMessageCountLabel = [UILabel new];
        [_unreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
        [_unreadMessageCountLabel setClipsToBounds:YES];
        [_unreadMessageCountLabel.layer setCornerRadius:9];
        [_unreadMessageCountLabel setTextColor:[UIColor whiteColor]];
        [_unreadMessageCountLabel setFont:systemFont(12)];
        [_unreadMessageCountLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.contentView addSubview:_unreadMessageCountLabel];
        _unreadMessageCountLabel.frame = CGRectMake(_avatarImageView.right-9, 2, 18, 18);
        
        
        _shiledUnreadMessageCountLabel = [UILabel new];
        [_shiledUnreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
        [_shiledUnreadMessageCountLabel setClipsToBounds:YES];
        [_shiledUnreadMessageCountLabel.layer setCornerRadius:5];
        [_shiledUnreadMessageCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_shiledUnreadMessageCountLabel];
        _shiledUnreadMessageCountLabel.frame = CGRectMake(_avatarImageView.right+4, 6, 10, 10);
        [_shiledUnreadMessageCountLabel setHidden:YES];
        
        
        
        _nameLabel = [UILabel new];
        _nameLabel.text = @"快聘";
        [_nameLabel setFont:systemFont(17)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        _nameLabel.frame = CGRectMake(_avatarImageView.right+kHEIGHT(10), 15, SCREEN_WIDTH-_avatarImageView.right-10-60-kHEIGHT(10), 17);
        
        
        
        _groupLabel = [UILabel new];
        _groupLabel.backgroundColor = RGB(0, 172, 255);
        _groupLabel.layer.cornerRadius = 3;
        _groupLabel.clipsToBounds = YES;
        _groupLabel.hidden = YES;
        _groupLabel.userInteractionEnabled = YES;
        _groupLabel.frame = CGRectMake(_nameLabel.right+8, 15, 30,kHEIGHT(12));
        [self.contentView addSubview:_groupLabel];
        
        
        //群组人数图片
        _groupImage = [UIImageView new];
        [_groupImage setImage:[UIImage imageNamed:@"xiaoxi_qunrenshu"]];
        _groupImage.hidden = YES;
        _groupImage.frame = CGRectMake(_groupLabel.left+4, _groupLabel.top+3.5, 12, 10);
        [self.contentView addSubview:_groupImage];
        
        
        //群组人数
        _groupNumLabel = [UILabel new];
        //        _groupNumLabel.backgroundColor = [UIColor redColor];
        _groupNumLabel.hidden = YES;
        _groupNumLabel.font = kFONT(10);
        _groupNumLabel.textColor = [UIColor whiteColor];
        _groupNumLabel.textAlignment = NSTextAlignmentLeft;
        _groupNumLabel.frame = CGRectMake(_groupLabel.left+18, _groupLabel.top+3.5, 10, 10);
        [self.contentView addSubview:_groupNumLabel];
        
//        _nameLabel = [UILabel new];
//        _nameLabel.text = @"快聘";
//        [_nameLabel setFont:systemFont(17)];
//        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_nameLabel];
//        _nameLabel.frame = CGRectMake(_groupLabel.right+8, 15, SCREEN_WIDTH-_avatarImageView.right-10-60-kHEIGHT(10), 17);
        
        
        _dateLabel = [UILabel new];
        [_dateLabel setFont:systemFont(12)];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel setTextColor:RGB(170, 170, 170)];
        _dateLabel.frame = CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), 15, 60, 12);
        
//        _dateLabel.backgroundColor = [UIColor greenColor];
        
        _shiledImageView = [UIImageView new];
        UIImage* shieldImg = [UIImage imageNamed:@"xiaoxi_miandarao"];
        [_shiledImageView setImage:shieldImg];
        [self.contentView addSubview:_shiledImageView];
        _shiledImageView.frame = CGRectMake(SCREEN_WIDTH-14-kHEIGHT(10), _dateLabel.bottom+15, 14, 14);
        
        _lastmessageLabel = [UILabel new];
        [_lastmessageLabel setFont:systemFont(14)];
        //        [_lastmessageLabel setTextColor:TTGRAY];
        [_lastmessageLabel setTextColor:RGB(127, 127, 127)];
        [self.contentView addSubview:_lastmessageLabel];
        _lastmessageLabel.frame = CGRectMake(_avatarImageView.right+kHEIGHT(12), _nameLabel.bottom+10, SCREEN_WIDTH-_avatarImageView.right-kHEIGHT(12)-kHEIGHT(10), 16);
        
        _bottomLine = [UILabel new];
        [_bottomLine setBackgroundColor:[UIColor redColor]];//TTCELLGRAY
        //        [self.contentView addSubview:_bottomLine];
        _bottomLine.frame = CGRectMake(0, 72, SCREEN_WIDTH, 0.5);
        
//        [self bringSubviewToFront:_unreadMessageCountLabel];
        [self.contentView addSubview:_unreadMessageCountLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_lastmessageLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setTextColor:[UIColor whiteColor]];
        [_groupLabel setBackgroundColor:RGB(0, 172, 255)];
        [_unreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
    }
    else
    {
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_lastmessageLabel setTextColor:RGB(135, 135, 135)];
        [_dateLabel setTextColor:RGB(170, 170, 170)];
        [_groupLabel setBackgroundColor:RGB(0, 172, 255)];
        [_unreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
    }
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated               // animate between regular and highlighted state
{
    [super setHighlighted:highlighted animated:NO];
    if (highlighted && self.selected)
    {
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_lastmessageLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setTextColor:[UIColor whiteColor]];
        [_groupLabel setBackgroundColor:RGB(0, 172, 255)];
        [_unreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
    }
    else
    {
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_lastmessageLabel setTextColor:RGB(135, 135, 135)];
        [_dateLabel setTextColor:RGB(170, 170, 170)];
        [_groupLabel setBackgroundColor:RGB(0, 172, 255)];
        [_unreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
    }
}

#pragma mark - public
- (void)setName:(NSString*)name
{
    if (!name)
    {
        [_nameLabel setText:@""];
    }
    else
    {
        [_nameLabel setText:name];
    }
}

- (void)setTimeStamp:(NSUInteger)timeStamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* dateString = [date transformToFuzzyDate];
    [_dateLabel setText:dateString];
}

- (void)setLastMessage:(NSString*)message
{
    
    NSLog(@"发送的消息:::%@",message);
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    message = [message stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    message = [message stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    if (!message)
    {
        [_lastmessageLabel setText:@"."];
    }
    else
    {
        [_lastmessageLabel setText:message];
    }
}

- (void)setAvatar:(NSString*)avatar
{
    
    [[_avatarImageView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    //    NSString *url1 = [IPADDRESS stringByAppendingString:avatar];
    NSString * url1 = [NSString stringWithFormat:@"%@%@",IPADDRESS,avatar];
    //    NSLog(@"**%@",url1);
    NSURL* avatarURL = [NSURL URLWithString:url1];
    UIImage* placeholder = [UIImage imageNamed:@"user_placeholder"];
    [_avatarImageView sd_setImageWithURL:avatarURL placeholderImage:placeholder];
}

- (void)setShiledUnreadMessage
{
    [self.unreadMessageCountLabel setHidden:YES];
    [self.shiledUnreadMessageCountLabel setHidden:NO];
}

- (void)setUnreadMessageCount:(NSUInteger)messageCount
{
    if (messageCount == 0)
    {
        [self.unreadMessageCountLabel setHidden:YES];
    }
    else if (messageCount < 10)
    {
        [self.unreadMessageCountLabel setHidden:NO];
        CGPoint center = self.unreadMessageCountLabel.center;
        NSString* title = [NSString stringWithFormat:@"%li",messageCount];
        [self.unreadMessageCountLabel setText:title];
        [self.unreadMessageCountLabel setWidth:16];
        [self.unreadMessageCountLabel setCenter:center];
        [self.unreadMessageCountLabel.layer setCornerRadius:8];
    }
    else if (messageCount < 99)
    {
        [self.unreadMessageCountLabel setHidden:NO];
        CGPoint center = self.unreadMessageCountLabel.center;
        NSString* title = [NSString stringWithFormat:@"%li",messageCount];
        [self.unreadMessageCountLabel setText:title];
        [self.unreadMessageCountLabel setWidth:25];
        [self.unreadMessageCountLabel setCenter:center];
        [self.unreadMessageCountLabel.layer setCornerRadius:8];
    }
    else
    {
        [self.unreadMessageCountLabel setHidden:NO];
        CGPoint center = self.unreadMessageCountLabel.center;
        NSString* title = @"···";//99+
        [self.unreadMessageCountLabel setText:title];
        [self.unreadMessageCountLabel setWidth:22];
        [self.unreadMessageCountLabel setCenter:center];
        [self.unreadMessageCountLabel.layer setCornerRadius:8];
    }
}


-(void)setShowSession:(MTTSessionEntity *)session
{
    self.sessionModel = session;
    NSString * name = [NSString stringWithFormat:@"%@",session.name];
    NSArray * nameArray = [name componentsSeparatedByString:@","];
    NSMutableArray * nickArray = [NSMutableArray array];
    if (nameArray.count > 3) {
        [nickArray addObject:nameArray[0]];
        [nickArray addObject:nameArray[1]];
        [nickArray addObject:nameArray[2]];
    }
    else
    {
        [nickArray addObjectsFromArray:nameArray];
    }
    NSString * nameStr= [nickArray componentsJoinedByString:@","];
    [self setName:nameStr];//session.name
    session.lastMsg = [WPMySecurities textFromEmojiString:session.lastMsg];
    BOOL isGroup = (session.sessionType == SessionTypeSessionTypeGroup);
    if ([session.lastMsg isKindOfClass:[NSString class]])
    {
        if ([session.lastMsg rangeOfString:DD_MESSAGE_IMAGE_PREFIX].location != NSNotFound)
        {
            NSArray *array = [session.lastMsg componentsSeparatedByString:DD_MESSAGE_IMAGE_PREFIX];
            NSString *string = [array lastObject];
            if ([string rangeOfString:DD_MESSAGE_IMAGE_SUFFIX].location != NSNotFound) {
                [self setLastMessage:isGroup?[NSString stringWithFormat:@"%@：%@",[session.lastMesageName isEqualToString:@"(null)"]?@"":session.lastMesageName,@"[图片]"]:@"[图片]"];
            }
            else
            {
                [self setLastMessage:isGroup?[NSString stringWithFormat:@"%@：%@",[session.lastMesageName isEqualToString:@"(null)"]?@"":session.lastMesageName,string]:string];
            }
        }
        else if ([session.lastMsg hasSuffix:@".spx"] || [session.lastMsg isEqualToString:@"[语音]"])
        {
            [self setLastMessage:[self lastMessageInfo:@"[语音]" andIsOrNot:isGroup]];//@"[语音]"
        }
        else
        {
            NSDictionary * dic = [self getLastMessage:session.lastMsg];
            NSString * message = [NSString string];
            if (dic)
            {
                if (dic.count == 8 && dic[@"user_id"])
                {
                    NSString * senderId = [NSString stringWithFormat:@"%ld",(long)session.lastMsgFromUserId];
                    if ([senderId isEqualToString:kShareModel.userId])
                    {
                        message = [self lastMessageInfo:[NSString stringWithFormat:@"你推荐了%@",dic[@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"你推荐了%@",dic[@"nick_name"]]
                    }
                    else
                    {
                        message = [self lastMessageInfo:[NSString stringWithFormat:@"向你推荐了%@",dic[@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"向你推荐了%@",dic[@"nick_name"]]
                    }
                }
                else if (dic.count == 3)
                {
                    message =  [self acceptApply:dic];
                    NSLog(@"%@",message);
                    //                    if ([dic[@"from_id"] isEqualToString:kShareModel.userId]) {
                    //                        NSString * string = [NSString stringWithFormat:@"你好,我是%@",dic[@"from_name"]];
                    //                        message = [self lastMessageInfo:string andIsOrNot:isGroup];
                    //                    }
                    //                    else
                    //                    {
                    //                        NSString * string = @"我通过了你的好友验证申请,现在我们可以聊天了";
                    //                        message = [self lastMessageInfo:string andIsOrNot:isGroup];
                    //                    }
                }
                else if (dic.count == 8)
                {
                    //                    message = dic[@"session_info"];
                    message = [NSString stringWithFormat:@"%@：%@",session.lastMesageName,dic[@"session_info"]];
                }
                else if (dic.count == 9)
                {
                    message = [NSString stringWithFormat:@"[%@：%@的聊天记录]",self.sessionModel.lastMesageName.length?self.sessionModel.lastMesageName:@"",dic[@"title"]];
                }
                else if (dic.count == 4)
                {
                    message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@]",dic[@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@]",dic[@"nick_name"]]
                }
                else if (dic.count == 11)
                {
                    message =[self lastMessageInfo:[dic[@"title"] length]?[NSString stringWithFormat:@"[%@]",dic[@"title"]]:[NSString stringWithFormat:@"[求职：%@]",dic[@"qz_position"]] andIsOrNot:isGroup];//[dic[@"title"] length]?[NSString stringWithFormat:@"[%@]",dic[@"title"]]:[NSString stringWithFormat:@"[求职：%@]",dic[@"qz_position"]]
                }
                else if (dic.count == 7 && dic[@"zp_position"])
                {
                    message =[self lastMessageInfo:[dic[@"title"] length]?[NSString stringWithFormat:@"[%@]",dic[@"title"]]:[NSString stringWithFormat:@"[招聘：%@]",dic[@"zp_position"]] andIsOrNot:isGroup];//[dic[@"title"] length]?[NSString stringWithFormat:@"[%@]",dic[@"title"]]:[NSString stringWithFormat:@"[招聘：%@]",dic[@"zp_position"]]
                }
                else if ([dic[@"display_type"] isEqualToString:@"1"])
                {
                    message = [self lastMessageInfo:[NSString stringWithFormat:@"%@",dic[@"content"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"%@",dic[@"content"]]
                }
                else if (dic.count == 13)
                {
                    NSString * curType = [NSString stringWithFormat:@"%@",dic[@"type"]];
                    switch (curType.intValue) {
                        case 1:
                            message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@等人的求职简历]",dic[@"title"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@等人的求职简历]",dic[@"title"]]
                            break;
                        case 2:
                            message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@等企业的招聘信息]",dic[@"title"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@等企业的招聘信息]",dic[@"title"]]
                            break;
                        default:
                            break;
                    }
                }
                else if (dic.count == 7)
                {
                    
                    NSString * note_type = dic[@"note_type"];
                    switch (note_type.intValue) {
                        case 0://申请
                        {
                            NSString * for_userid = dic[@"for_userid"];
                            if ([for_userid isEqualToString:kShareModel.userId]) {
                                message = @"你加入了群组";
                            }
                            else
                            {
                                message = [NSString stringWithFormat:@"%@加入了群组",dic[@"for_username"]];
                            }
                        }
                            break;
                        case 1://邀请
                        {
                            NSString * create_userid = dic[@"create_userid"];
                            if ([create_userid isEqualToString:kShareModel.userId]) {
                                message = [NSString stringWithFormat:@"你邀请%@加入群组",dic[@"for_username"]];
                            }
                            else
                            {
                                NSString * for_userid = dic[@"for_userid"];
                                if ([for_userid isEqualToString:kShareModel.userId]) {
                                    message = [NSString stringWithFormat:@"%@邀请你加入群组",dic[@"create_username"]];
                                }
                                else
                                {
                                    message = [NSString stringWithFormat:@"%@邀请%@加入群组",dic[@"create_username"],dic[@"for_username"]];
                                    
                                    
                                    NSString * nameStr = dic[@"for_username"];
                                    NSArray * nameArray = [nameStr componentsSeparatedByString:@","];
                                    NSMutableArray * nameMuArr = [NSMutableArray array];
                                    [nameMuArr addObjectsFromArray:nameArray];
                                    for (int i = 0 ; i < nameArray.count; i++) {
                                        NSString * string = nameArray[i];
                                        if ([string isEqualToString:kShareModel.nick_name]) {
                                            [nameMuArr replaceObjectAtIndex:i withObject:@"你"];
                                        }
                                    }
                                    NSString * nameString = [nameMuArr componentsJoinedByString:@","];
                                    message = [NSString stringWithFormat:@"%@邀请%@加入群组",dic[@"create_username"],nameString];
                                    
                                    
                                    
                                }
                            }
                        }
                            break;
                        case 2://退出
                            
                            break;
                        case 3://移除
                        {
                            NSString * create_userid = dic[@"create_userid"];
                            if ([create_userid isEqualToString:kShareModel.userId]) {
                                message  = @"";
                            }
                            else
                            {
                                NSString * for_userid = dic[@"for_userid"];
                                if ([for_userid isEqualToString:kShareModel.userId]) {
                                    message  = @"你已被移出群组";
                                }
                                else
                                {
                                    message  = [NSString stringWithFormat:@"%@已被移出群组",dic[@"for_username"]];
                                }
                            }
                        }
                            break;
                        case 8://被加入黑名单
                        {
                          message = @"消息已发出,但被对方拒收了。";
                        }
                            break;
                        case 10://被群组修改资料
                        {
                            NSString * name = dic[@"create_username"];
                            if ([name isEqualToString:kShareModel.nick_name]) {
                                name = @"你";
                            }
                            message = [NSString stringWithFormat:@"%@修改了群资料",name];
                        }
                            break;
                        case 11:
                        {
                            message = @"群创建成功!";
                        }
                            break;
                        default:
                            break;
                    }
                }
                else if (dic.count == 1)
                {
                    message = [self lastMessageInfo:@"[视频]" andIsOrNot:isGroup];
                }
                else if (dic.count == 6)
                {
                    message = [NSString stringWithFormat:@"%@：邀请%@加入群组",dic[@"create_username"],dic[@"for_username"]];
                }
                else if (dic.count == 2)
                {
                    if ([dic[@"display_type"] isEqualToString:@"8"])
                    {
                        NSString * content = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        if (dictionary)
                        {
                            message =[self lastMessageInfo:[dictionary[@"title"] length]?[NSString stringWithFormat:@"[%@]",dictionary[@"title"]]:[NSString stringWithFormat:@"[求职：%@]",dictionary[@"qz_position"]] andIsOrNot:isGroup];
                        }
                        else
                        {
                            message =[self lastMessageInfo:[dictionary[@"content"][@"title"] length]?[NSString stringWithFormat:@"[%@]",dictionary[@"title"]]:[NSString stringWithFormat:@"[求职：%@]",dic[@"content"][@"qz_position"]] andIsOrNot:isGroup];//[dictionary[@"content"][@"title"] length]?[NSString stringWithFormat:@"[%@]",dictionary[@"title"]]:[NSString stringWithFormat:@"[求职：%@]",dic[@"content"][@"qz_position"]]
                        }
                        
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"15"])
                    {
                        id objc = dic[@"content"];
                        if ([objc isKindOfClass:[NSString class]])
                        {
                            NSString * string = (NSString*)objc;
                            NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        message = [NSString stringWithFormat:@"%@：%@",self.sessionModel.lastMesageName,dictionary[@"title"]];
                        }
                        else
                        {
                            message = [NSString stringWithFormat:@"%@：%@",self.sessionModel.lastMesageName,dic[@"content"][@"title"]];
                        }
                        
                    }
                    if ([dic[@"display_type"] isEqualToString:@"13"])
                    {
                        id objc = dic[@"content"];
                        if ([objc isKindOfClass:[NSString class]])
                        {
                            NSString * string = (NSString*)objc;
                            NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                            dic = @{@"content":dictionary,@"display_type":@"13"};
                        }
                        else
                        {
                            
                        }
                        
//                        message = [NSString stringWithFormat:@"%@",dic[@"content"][@"session_info"]];
                        message = [NSString stringWithFormat:@"%@：%@",session.lastMesageName,dic[@"content"][@"session_info"]];
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"7"])
                    {
                        message =[self lastMessageInfo:@"[视频]" andIsOrNot:isGroup];//@"[视频]"
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"6"])
                    {
                        NSString * senderId = [NSString stringWithFormat:@"%ld",(long)session.lastMsgFromUserId];
                        NSString * content = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        if (dictionary)
                        {
                            if ([senderId isEqualToString:kShareModel.userId]) {
                                message = [self lastMessageInfo:[NSString stringWithFormat:@"你推荐了%@",dictionary[@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"你推荐了%@",dictionary[@"nick_name"]]
                            }
                            else
                            {
                                message = [self lastMessageInfo:[NSString stringWithFormat:@"向你推荐了%@",dictionary[@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"向你推荐了%@",dictionary[@"nick_name"]]
                            }
                            
                        }
                        else
                        {
                            if ([senderId isEqualToString:kShareModel.userId]) {
                                message = [self lastMessageInfo:[NSString stringWithFormat:@"你推荐了%@",dic[@"content"][@"nick_name"]] andIsOrNot:isGroup];
                            }
                            else
                            {
                                message = [self lastMessageInfo:[NSString stringWithFormat:@"向你推荐了%@",dic[@"content"][@"nick_name"]] andIsOrNot:isGroup];
                            }
                        }
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"9"])
                    {
                        NSString * content = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        if (dictionary) {
                            message = [self lastMessageInfo:[dictionary[@"title"] length]?[NSString stringWithFormat:@"[%@]",dictionary[@"title"]]:[NSString stringWithFormat:@"[招聘：%@]",dictionary[@"zp_position"]] andIsOrNot:isGroup];//[dictionary[@"title"] length]?[NSString stringWithFormat:@"[%@]",dictionary[@"title"]]:[NSString stringWithFormat:@"[招聘：%@]",dictionary[@"zp_position"]]
                            
                        }
                        else
                        {
                            message =[self lastMessageInfo:[dic[@"content"][@"title"] length]?[NSString stringWithFormat:@"[%@]",dic[@"content"][@"title"]]:[NSString stringWithFormat:@"[招聘：%@]",dic[@"content"][@"zp_position"]] andIsOrNot:isGroup];//[dic[@"content"][@"title"] length]?[NSString stringWithFormat:@"[%@]",dic[@"content"][@"title"]]:[NSString stringWithFormat:@"[招聘：%@]",dic[@"content"][@"zp_position"]]
                            
                        }
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"10"])
                    {
                        
                        NSString * contetn= [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data = [contetn dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        if (dictionary)
                        {
                            NSString *toType = [NSString stringWithFormat:@"%@",dictionary[@"type"]];
                            switch (toType.intValue) {
                                case 1:
                                    message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@等人的求职简历]",dictionary[@"title"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@等人的求职简历]",dictionary[@"title"]]
                                    break;
                                case 2:
                                    message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@等企业的招聘信息]",dictionary[@"title"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@等企业的招聘信息]",dictionary[@"title"]]
                                    break;
                                default:
                                    break;
                            }
                        }
                        else
                        {
                            NSString *toType = [NSString stringWithFormat:@"%@",dic[@"content"][@"type"]];
                            switch (toType.intValue) {
                                case 1:
                                    message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@等人的求职简历]",dic[@"content"][@"title"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@等人的求职简历]",dic[@"content"][@"title"]]
                                    break;
                                case 2:
                                    message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@等企业的招聘信息]",dic[@"content"][@"title"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@等企业的招聘信息]",dic[@"content"][@"title"]]
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"11"])
                    {
                        NSString * content = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        if (dictionary)
                        {
                            message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@]",dictionary[@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@]",dictionary[@"nick_name"]]
                        }
                        else
                        {
                            message = [self lastMessageInfo:[NSString stringWithFormat:@"[%@]",dic[@"content"][@"nick_name"]] andIsOrNot:isGroup];//[NSString stringWithFormat:@"[%@]",dic[@"content"][@"nick_name"]]
                        }
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"14"])
                    {
                        id objc = dic[@"content"];
                        if ([objc isKindOfClass:[NSString class]])
                        {
                            NSString * contentStr = (NSString*)objc;
                            NSData * data= [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                            message =   [self acceptApply:dictionary];
                        }
                        else
                        {
                            NSDictionary * dictionary = (NSDictionary*)objc;
                            message = [self acceptApply:dictionary];
                        }
                    }
                    else if ([dic[@"display_type"] isEqualToString:@"12"])
                    {
                        NSDictionary *dictionary = [NSDictionary dictionary];
                        id content = dic[@"content"];
                        if ([content isKindOfClass:[NSString class]]) {
                            NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                            dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        }
                        if (dictionary.count)
                        {
                            NSString * note_type = dictionary[@"note_type"];
                            switch (note_type.intValue) {
                                case 0://申请
                                {
                                    NSString * for_userid = dictionary[@"for_userid"];
                                    if ([for_userid isEqualToString:kShareModel.userId]) {
                                        message = @"你加入了群组";
                                    }
                                    else
                                    {
                                        message = [NSString stringWithFormat:@"%@加入了群组",dictionary[@"for_username"]];
                                    }
                                }
                                    break;
                                case 1://邀请
                                {
                                    NSString * create_userid = dictionary[@"create_userid"];
                                    if ([create_userid isEqualToString:kShareModel.userId]) {
                                        message = [NSString stringWithFormat:@"你邀请%@加入群组",dictionary[@"for_username"]];
                                    }
                                    else
                                    {
                                        NSString * for_userid = dictionary[@"for_userid"];
                                        if ([for_userid isEqualToString:kShareModel.userId]) {
                                            message = [NSString stringWithFormat:@"%@邀请你加入群组",dictionary[@"create_username"]];
                                        }
                                        else
                                        {
                                            message = [NSString stringWithFormat:@"%@邀请%@加入群组",dictionary[@"create_username"],dictionary[@"for_username"]];
                                            
                                            
                                            NSString * nameStr = dictionary[@"for_username"];
                                            NSArray * nameArray = [nameStr componentsSeparatedByString:@","];
                                            NSMutableArray * nameMuArr = [NSMutableArray array];
                                            [nameMuArr addObjectsFromArray:nameArray];
                                            for (int i = 0 ; i < nameArray.count; i++) {
                                                NSString * string = nameArray[i];
                                                if ([string isEqualToString:kShareModel.nick_name]) {
                                                    [nameMuArr replaceObjectAtIndex:i withObject:@"你"];
                                                }
                                            }
                                            NSString * nameString = [nameMuArr componentsJoinedByString:@","];
                                            message = [NSString stringWithFormat:@"%@邀请%@加入群组",dictionary[@"create_username"],nameString];
                                        }
                                    }
                                }
                                    break;
                                case 2://退出
                                    
                                    break;
                                case 3://移除
                                {
                                    NSString * create_userid = dictionary[@"create_userid"];
                                    if ([create_userid isEqualToString:kShareModel.userId]) {
                                        message  = @"";
                                    }
                                    else
                                    {
                                        NSString * for_userid = dictionary[@"for_userid"];
                                        if ([for_userid isEqualToString:kShareModel.userId]) {
                                            message  = @"你已被移出群组";
                                        }
                                        else
                                        {
                                            message  = [NSString stringWithFormat:@"%@已被移出群组",dictionary[@"for_username"]];
                                        }
                                    }
                                }
                                    break;
                                    case 8:
                                {
                                  message = @"消息已发出,但被对方拒收了。";
                                }
                                    break;
                                    case 10:
                                {
                                    NSString * name = dictionary[@"create_username"];
                                    if ([name isEqualToString:kShareModel.nick_name]) {
                                        name = @"你";
                                    }
                                    message = [NSString stringWithFormat:@"%@修改了群资料",name];
                                }
                                    break;
                                case 11:
                                {
                                    message = @"群创建成功!";
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                        else
                        {
                            NSString * note_type = dic[@"content"][@"note_type"];
                            switch (note_type.intValue) {
                                case 0://申请
                                {
                                    NSString * for_userid = dic[@"content"][@"for_userid"];
                                    if ([for_userid isEqualToString:kShareModel.userId]) {
                                        message = @"你加入了群组";
                                    }
                                    else
                                    {
                                        message = [NSString stringWithFormat:@"%@加入了群组",dic[@"content"][@"for_username"]];
                                    }
                                }
                                    break;
                                case 1://邀请
                                {
                                    NSString * create_userid = dic[@"content"][@"create_userid"];
                                    if ([create_userid isEqualToString:kShareModel.userId]) {
                                        message = [NSString stringWithFormat:@"你邀请%@加入群组",dic[@"content"][@"for_username"]];
                                    }
                                    else
                                    {
                                        NSString * for_userid = dic[@"content"][@"for_userid"];
                                        if ([for_userid isEqualToString:kShareModel.userId]) {
                                            message = [NSString stringWithFormat:@"%@邀请你加入群组",dic[@"content"][@"create_username"]];
                                        }
                                        else
                                        {
                                            message = [NSString stringWithFormat:@"%@邀请%@加入群组",dic[@"content"][@"create_username"],dic[@"content"][@"for_username"]];
                                        }
                                    }
                                }
                                    break;
                                case 2://退出
                                    
                                    break;
                                case 3://移除
                                {
                                    NSString * create_userid = dic[@"content"][@"create_userid"];
                                    if ([create_userid isEqualToString:kShareModel.userId]) {
                                        message  = @"";
                                    }
                                    else
                                    {
                                        NSString * for_userid = dic[@"content"][@"for_userid"];
                                        if ([for_userid isEqualToString:kShareModel.userId]) {
                                            message  = @"你已被移出群组";
                                        }
                                        else
                                        {
                                            message  = [NSString stringWithFormat:@"%@已被移出群组",dic[@"content"][@"for_username"]];
                                        }
                                    }
                                }
                                    break;
                                case 8:
                                {
                                  message = @"消息已发出,但被对方拒收了。";
                                }
                                    break;
                                case 10:
                                {
                                    NSString * name = dic[@"content"][@"create_username"];
                                    if ([name isEqualToString:kShareModel.nick_name]) {
                                        name = @"你";
                                    }
                                    message = [NSString stringWithFormat:@"%@修改了群资料",name];
                                }
                                    break;
                                case 11:
                                {
                                    message = @"群创建成功!";
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    else
                    {
                        NSString * local = [NSString stringWithFormat:@"%@",dic[@"local"]];
                        if ([local hasSuffix:@".mp4"]) {
                            message = [self lastMessageInfo:@"[视频]" andIsOrNot:isGroup];//@"[视频]"
                        }
                    }
                }
            }
            else
            {
                NSString * string = session.lastMsg;//[NSString stringWithFormat:@"%@",session.lastMsg]
                if ([string hasSuffix:@".mp4"])
                {
                    message = [self lastMessageInfo:@"[视频]" andIsOrNot:isGroup];//@"[视频]"
                }
                else
                {
                    
                    
                    NSError * error= nil;
                    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    if (dictionary)
                    {
                        message = [self acceptApply:dictionary];
                    }
                    else
                    {
                        message = [self lastMessageInfo:session.lastMsg andIsOrNot:isGroup];
                    }
                    
                    
                    message = [self lastMessageInfo:session.lastMsg andIsOrNot:isGroup];//session.lastMsg
                }
                
            }
            [self setLastMessage:message];
        }
    }
    
//    if (session.sessionType == SessionTypeSessionTypeSingle) {
//        [_avatarImageView setBackgroundColor:[UIColor clearColor]];
//        [[DDUserModule shareInstance] getUserForUserID:session.sessionID Block:^(MTTUserEntity *user) {
//            
//            _groupLabel.hidden = YES;
//            _groupNumLabel.hidden = YES;
//            _groupImage.hidden = YES;
//            CGRect rect = _nameLabel.frame;
//            rect.origin.x = _avatarImageView.right+kHEIGHT(10);
//            _nameLabel.frame = rect;
//            
//            [[_avatarImageView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [(UIView*)obj removeFromSuperview];
//            }];
//            [_avatarImageView setImage:nil];
//            [self setAvatar:[user getAvatarUrl]];
//        }];
//    }
//    else
//    {
        _groupLabel.hidden = NO;
        _groupNumLabel.hidden = NO;
        _groupImage.hidden = NO;
        [_nameLabel removeFromSuperview];
        [self.contentView addSubview:_nameLabel];
    
    
        
        
        [[DDGroupModule instance] getGroupInfogroupID:self.sessionModel.sessionID completion:^(MTTGroupEntity *group) {
            
            NSString * name = [NSString stringWithFormat:@"%@",session.name];
            NSArray * nameArray = [name componentsSeparatedByString:@","];
            NSMutableArray * nickArray = [NSMutableArray array];
            if (nameArray.count > 3) {
                [nickArray addObject:nameArray[0]];
                [nickArray addObject:nameArray[1]];
                [nickArray addObject:nameArray[2]];
            }
            else
            {
                [nickArray addObjectsFromArray:nameArray];
            }
            NSString * nameStr= [nickArray componentsJoinedByString:@","];
            nameStr = [nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize nameSize = [nameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
//            CGSize nameSize = [nameStr getSizeWithFont:FUCKFONT(17) Height:17];
            NSString * countStr = [NSString stringWithFormat:@"%lu",(unsigned long)group.groupUserIds.count];
            CGSize size = [countStr getSizeWithFont:FUCKFONT(10) Height:10];
        
            if (SCREEN_WIDTH-_avatarImageView.right-kHEIGHT(10)-15-kHEIGHT(10)-kHEIGHT(15)-kHEIGHT(10)<nameSize.width+6+size.width+22) {
                nameSize.width = SCREEN_WIDTH-_avatarImageView.right-kHEIGHT(15)-3*kHEIGHT(10)-15-6-size.width-22;
            }
            
//            _nameLabel.backgroundColor = [UIColor redColor];
            CGRect rect = _groupLabel.frame;
            CGRect rect1 = _groupNumLabel.frame;
            CGRect rect2 = _groupImage.frame;
            CGRect rect3 = _nameLabel.frame;
            
            rect3.size.width = nameSize.width;
            rect  = CGRectMake(_avatarImageView.right+kHEIGHT(10)+nameSize.width+6, 16, 22+size.width, kHEIGHT(12));
            rect1 = CGRectMake(_avatarImageView.right+kHEIGHT(10)+nameSize.width+6+18, 10+(kHEIGHT(12))/2+1, size.width, 10);
            rect2 = CGRectMake(_avatarImageView.right+kHEIGHT(10)+nameSize.width+6+4,10+(kHEIGHT(12))/2+1, 12, 10);
            
//            NSString * countStr = [NSString stringWithFormat:@"%lu",(unsigned long)group.groupUserIds.count];
//            CGSize size = [countStr getSizeWithFont:FUCKFONT(10) Height:10];
//            CGRect rect = _groupLabel.frame;
//            CGRect rect1 = _groupNumLabel.frame;
//            CGRect rect2 = _groupImage.frame;
//            CGRect rect3 = _nameLabel.frame;
//            rect = CGRectMake(_avatarImageView.right+kHEIGHT(10), 15, 22+size.width, 17);
//            rect1 = CGRectMake(_avatarImageView.right+kHEIGHT(10)+18, 18.5, size.width, 10);
//            rect2 = CGRectMake(_avatarImageView.right+kHEIGHT(10)+4,18.5, 12, 10);
//            rect3.origin.x = _avatarImageView.right+kHEIGHT(10)+22+size.width+6;
//            rect3.size.width = SCREEN_WIDTH-kHEIGHT(10)-60-_avatarImageView.right-kHEIGHT(10)-22-size.width-6;
            
            
            _groupLabel.frame = rect;
            _groupNumLabel.frame = rect1;
            _groupImage.frame = rect2;
            _nameLabel.frame = rect3;
            
            _groupNumLabel.text = countStr;
            _groupNumLabel.textColor = [UIColor whiteColor];
            
        }];
        [_avatarImageView setBackgroundColor:RGB(228, 227, 230)];
        [_avatarImageView setImage:nil];
        [[_avatarImageView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(UIView*)obj removeFromSuperview];
        }];
        [self loadGroupIcon:session];
//    }
    [self.shiledUnreadMessageCountLabel setHidden:YES];
    [self setUnreadMessageCount:session.unReadMsgCount];//session.unReadMsgCount
    [self.shiledImageView setHidden:YES];
    if(session.isGroup){
        MTTGroupEntity *group = [[DDGroupModule instance] getGroupByGId:session.sessionID];
        if (group) {
            if(group.isShield){
                if(session.unReadMsgCount){
                    [self setShiledUnreadMessage];
                }
                [self.shiledImageView setHidden:NO];
            }
        }
    }
    if (session.isShield) {
        [self.shiledImageView setHidden:NO];
    }
    
    
    //设置session的时间
    [self setTimeStamp:session.timeInterval];
    if(session.unReadMsgCount)
    {
        //实时获取未读消息从接口
    }
}

#pragma mark 判断申请的
-(NSString *)acceptApply:(NSDictionary*)dictionary
{
    NSString * string = [NSString string];
    if ([dictionary[@"from_id"] isEqualToString:kShareModel.userId]) {
        string = [NSString stringWithFormat:@"你好,我是%@。",dictionary[@"from_name"]];
        string = [self lastMessageInfo:string andIsOrNot:NO];
    }
    else
    {
        string = @"我通过了你的好友验证申请,现在我们可以聊天了。";
        string = [self lastMessageInfo:string andIsOrNot:NO];
    }
    return string;
}
-(void)setNameAndInfo:(NSString*)groupCount
{
    
    //    NSString * countStr = [NSString stringWithFormat:@"%lu",(unsigned long)group.groupUserIds.count];
    
//    CGSize size = [groupCount getSizeWithFont:FUCKFONT(10) Height:10];
//    CGRect rect = _groupLabel.frame;
//    CGRect rect1 = _groupNumLabel.frame;
//    CGRect rect2 = _groupImage.frame;
//    CGRect rect3 = _nameLabel.frame;
//    
//    rect = CGRectMake(_avatarImageView.right+kHEIGHT(10), 15, 22+size.width, 17);
//    rect1 = CGRectMake(_avatarImageView.right+kHEIGHT(10)+18, 18.5, size.width, 10);
//    rect2 = CGRectMake(_avatarImageView.right+kHEIGHT(10)+4,18.5, 12, 10);
//    rect3.origin.x = _avatarImageView.right+kHEIGHT(10)+22+size.width+6;
//    
//    
//    _groupLabel.frame = rect;
//    _groupNumLabel.frame = rect1;
//    _groupImage.frame = rect2;
//    _nameLabel.frame = rect3;
//    
//    _groupNumLabel.text = groupCount;
//    _groupNumLabel.textColor = [UIColor whiteColor];
}
-(NSUInteger)getUnReadMessageCount
{
    
    if (_sessionModel.unReadMsgCount)
    {
        [[DDMessageModule shareInstance] getMessageFromServer:0 currentSession:_sessionModel count:20 Block:^(NSMutableArray *array, NSError *error) {
            if (array.count) {
                int nnum= 0;
                for (  MTTMessageEntity* message in array) {
                    NSString * content = message.msgContent;
                    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    if (dictionary) {
                        NSString * display_type = [NSString stringWithFormat:@"%@",dictionary[@"display_type"]];
                        if ([display_type isEqualToString:@"12"]) {
                            nnum++;
                        }
                    }
                }
                
                _countNum = array.count-nnum;
            }
        }];
    }
    else
    {
        _countNum = 0;
    }
    return _countNum;
    
}
-(NSString*)lastMessageInfo:(NSString*)string andIsOrNot:(BOOL)isOrNot
{
    NSString * message = isOrNot?[NSString stringWithFormat:@"%@%@",([self.sessionModel.lastMesageName isEqualToString:@"(null)"]|| (!self.sessionModel.lastMesageName.length))?@"":[NSString stringWithFormat:@"%@：",self.sessionModel.lastMesageName],string]:string;
    if (!string.length) {
        message = @"";
    }
    return message;
}

#pragma mark 将字典类型的字符串转换成字典
-(NSDictionary*)getLastMessage:(NSString*)string
{
    
    NSString * content = [WPMySecurities textFromBase64String:string];
    if (content.length) {
        string = content;
    }
    
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
-(void)loadGroupIcon:(MTTSessionEntity *)session
{
    [[DDGroupModule instance] getGroupInfogroupID:session.sessionID completion:^(MTTGroupEntity *group) {
        NSString * name = [NSString stringWithFormat:@"%@",group.name];
        NSArray * nameArray = [name componentsSeparatedByString:@","];
        NSMutableArray * nickArray = [NSMutableArray array];
        if (nameArray.count > 3) {
            [nickArray addObject:nameArray[0]];
            [nickArray addObject:nameArray[1]];
            [nickArray addObject:nameArray[2]];
        }
        else
        {
            [nickArray addObjectsFromArray:nameArray];
        }
        NSString * nameStr= [nickArray componentsJoinedByString:@","];
        [self setName:nameStr];//group.name
        //        _avatarImageView.backgroundColor = [UIColor redColor];
        NSString * avatarStr = [NSString stringWithFormat:@"%@",self.sessionModel.avatar];
        if ([avatarStr isEqualToString:@"(null)"]|| (!avatarStr.length))
        {
            [[DDGroupModule instance] getGroupInfogroupID:self.sessionModel.sessionID completion:^(MTTGroupEntity *group) {
                NSString * avatar = [NSString stringWithFormat:@"%@",group.avatar];
                if (avatar.length && ![avatar isEqualToString:@"(null)"])
                {
                    NSString * imageStr = group.avatar;
                    imageStr = [imageStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                    imageStr = [imageStr stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
                    NSArray * imageArray = [imageStr componentsSeparatedByString:@"/"];
                    NSMutableArray * muarra = [NSMutableArray array];
                    [muarra addObjectsFromArray:imageArray];
                    NSString * lastStr = imageArray[imageArray.count-1];
                    lastStr =  [@"thumb_" stringByAppendingString:lastStr];
                    [muarra replaceObjectAtIndex:imageArray.count-1 withObject:lastStr];
                    imageStr = [muarra componentsJoinedByString:@"/"];
                    
                    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
                    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
                    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
                    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
                    NSData * data = [NSData dataWithContentsOfFile:fileName1];
                    if (data) {
                        _avatarImageView.image = [UIImage imageWithData:data];
                    }
                    else
                    {
                        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [down downLoadImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr] success:^(id response) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                  _avatarImageView.image = [UIImage imageWithData:response];
                                });
                                
                            } failed:^(NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    _avatarImageView.image = [UIImage imageNamed:@"user_placeholder"];
                                });
                               
                            }];
                        });
                    }
//                    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                }
                else
                {
                    [_avatarImageView setImage:[UIImage imageNamed:@"user_placeholder"]];
                }
            }];
        }
        else
        {
            NSString * imageStr = self.sessionModel.avatar;
            NSString * thumbStr = @"thumb_";
            NSString * thumbdStr = @"thumbd_";
            BOOL isOrNot = [imageStr containsString:thumbStr];
            BOOL isOrNot1 = [imageStr containsString:thumbdStr];
            if (!isOrNot && !isOrNot1) {
                NSArray * array = [imageStr componentsSeparatedByString:@"/"];
                NSMutableArray * muarra = [NSMutableArray array];
                [muarra addObjectsFromArray:array];
                NSString * string = array[array.count-1];
                string = [NSString stringWithFormat:@"%@%@",thumbStr,string];
                [muarra replaceObjectAtIndex:array.count-1 withObject:string];
                imageStr = [muarra componentsJoinedByString:@"/"];
            }
            if ([imageStr hasSuffix:@".jp"]) {
                imageStr = [imageStr stringByReplacingOccurrencesOfString:@".jp" withString:@".jpg"];
            }
            
            if ([imageStr hasSuffix:@".pn"]) {
               imageStr = [imageStr stringByReplacingOccurrencesOfString:@".pn" withString:@".png"];
            }
            NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
            NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            NSData * data = [NSData dataWithContentsOfFile:fileName1];
            if (data) {
                
//                NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                UIImage * iage = [UIImage imageWithData:data];
//                _avatarImageView.image = iage;
                _avatarImageView.image = [UIImage imageWithData:data];
            }
            else
            {
                WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [down downLoadImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr] success:^(id response) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                          _avatarImageView.image = [UIImage imageWithData:response];
                        });
                        
                    } failed:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           _avatarImageView.image = [UIImage imageNamed:@"user_placeholder"];
                        });
                    }];
                });
            }
//            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
        }
    }];
}

-(UIImage *)getImageFromView:(UIView *)orgView{
    CGSize s = orgView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
