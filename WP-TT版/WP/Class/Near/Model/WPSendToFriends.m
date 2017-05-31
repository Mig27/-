//
//  WPSendToFriends.m
//  WP
//
//  Created by CC on 16/11/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSendToFriends.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "MTTMessageEntity.h"
#import "WPMySecurities.h"
@implementation WPSendToFriends

#pragma mark从求职面试中批量发送
-(void)sendToFriendsMuch:(void(^)(NSArray*,NSArray*,NSString*))sendSuccess
{
    
    NSMutableArray * MuArray = [NSMutableArray array];
    for (WPNewResumeListModel * model in self.selectedArray) {
        self.model = model;
        NSDictionary * dic = nil;
        if (self.isRecuilist)
        {//招聘
            dic = @{@"zp_id":self.model.resumeId,
                    @"zp_position":self.model.jobPositon,
                    @"zp_avatar":self.model.logo,
                    @"cp_name":[NSString stringWithFormat:@"%@",self.model.enterpriseName],
                    @"belong":self.model.resume_user_id,
                    @"title":@"",
                    @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName.length?self.model.enterpriseName:@"",self.model.dataIndustry.length?self.model.dataIndustry:@"",self.model.enterprise_properties.length?self.model.enterprise_properties:@"",self.model.enterprise_scale.length?self.model.enterprise_scale:@"",self.model.enterprise_address.length?self.model.enterprise_address:@"",self.model.enterprise_brief.length?self.model.enterprise_brief:@""]};
        }
        else//求职
        {
            dic = @{@"qz_id":self.model.resumeId,@"qz_avatar":self.model.avatar,@"qz_position":self.model.HopePosition,@"qz_name":self.model.name,@"qz_sex":self.model.sex,@"qz_age":@"",@"qz_educaiton":self.model.education,@"qz_workTime":self.model.WorkTim,@"belong":self.model.resume_user_id,@"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",model.name.length?model.name:@"",model.age.length?model.age:@"",model.sex.length?model.sex:@"",model.education.length?model.education:@"",model.worktime.length?model.worktime:@"",model.lightspot.length?model.lightspot:@""],@"title":@""};
        }
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DDMessageContentType  contentType;
        if (self.isRecuilist)
        {
            contentType = DDMEssageMyWant;
        }
        else
        {
            contentType = DDMEssageMyApply;
        }
        NSDictionary * dictionary = @{@"content":messageContent,@"contentType":[NSString stringWithFormat:@"%lu",(unsigned long)contentType]};
        [MuArray addObject:dictionary];
    }
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    sendSuccess(muarray,MuArray,@"");
}
#pragma mark 发送单个的求职招聘
-(void)sendeToWeiPinFriends:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess
{
    
    NSDictionary * dic = nil;
    if (self.isRecuilist)
    {//招聘
        dic = @{@"zp_id":self.model.resumeId,
                @"zp_position":self.model.jobPositon,
                @"zp_avatar":self.model.logo,
                @"cp_name":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName,self.model.dataIndustry,self.model.enterprise_properties,self.model.enterprise_scale,self.model.enterprise_address,self.model.enterprise_brief],
                @"belong":self.model.resume_user_id,
                @"title":@"",@"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName.length?self.model.enterpriseName:@"",self.model.dataIndustry.length?self.model.dataIndustry:@"",self.model.enterprise_properties.length?self.model.enterprise_properties:@"",self.model.enterprise_scale.length?self.model.enterprise_scale:@"",self.model.enterprise_address.length?self.model.enterprise_address:@"",self.model.enterprise_brief.length?self.model.enterprise_brief:@""]};
    }
    else//求职
    {
        dic = @{@"qz_id":self.model.resumeId,@"qz_avatar":self.model.avatar,@"qz_position":self.model.HopePosition,@"qz_name":self.model.name,@"qz_sex":self.model.sex,@"qz_age":@"",@"qz_educaiton":self.model.education,@"qz_workTime":self.model.WorkTim,@"belong":self.model.resume_user_id,@"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.sex.length?self.model.sex:@"",self.model.age.length?self.model.age:@"",self.model.education.length?self.model.education:@"",self.model.WorkTim.length?self.model.WorkTim:@"",self.model.lightspot.length?self.model.lightspot:@""],@"title":@""};
    }
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    DDMessageContentType  contentType;
    if (self.isRecuilist)
    {
        contentType = DDMEssageMyWant;
    }
    else
    {
        contentType = DDMEssageMyApply;
    }

    [self tranmitMessage:messageContent andMessageType:contentType andToUserId:@"" success:^(NSArray *array, NSString *userId, NSString *messageContent, NSString *display_type) {
        sendSuccess(array,userId,messageContent,display_type);
    }];
}
#pragma mark 发送名片
-(void)sendPersonalCard:(LinkManListModel*)model success:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess
{
//    NSDictionary * dic = @{@"display_type":@"6",@"content":{}};
    NSDictionary * dic = @{@"nick_name":model.nick_name,
                           @"avatar":model.avatar,
                           @"wp_id":model.wp_id,
                           @"user_id":model.user_id,
                           @"to_name":@"",
                           @"from_name":kShareModel.nick_name,
                           @"position":model.position,
                           @"company":model.company};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self tranmitMessage:string andMessageType:DDMEssagePersonalaCard andToUserId:@"" success:^(NSArray *array, NSString *userId, NSString *messageContent, NSString *display_type) {
        sendSuccess(array,userId,messageContent,display_type);
    }];
    
}

#pragma mark 发送说说
-(void)sendShuoShuoToFriends:(NSDictionary*)sendDic success:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess
{
    NSString * share = sendDic[@"share"];
    NSString * title = nil;
    NSString * message = nil;
    switch (share.intValue) {
        case 0://原
            title = [NSString stringWithFormat:@"%@的话题",sendDic[@"nick_name"]];
            message = [self getContentStr:sendDic];
            break;
        case 1://转发
            title = [NSString stringWithFormat:@"%@的话题",sendDic[@"nick_name"]];
            message = [self getContentStr:sendDic];
            break;
        case 2://求职
            title = [NSString stringWithFormat:@"%@的话题",sendDic[@"nick_name"]];
            message = [self getContentStr:sendDic];
            break;
        case 3:
            title = [NSString stringWithFormat:@"%@的话题",sendDic[@"nick_name"]];
            message = [self getContentStr:sendDic];
            break;
        default:
            break;
    }
    NSDictionary * dic = @{@"nick_name":title,@"shuoshuoid":sendDic[@"sid"],@"avatar":[NSString stringWithFormat:@"%@%@",IPADDRESS,sendDic[@"avatar"]],@"message":message};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self tranmitMessage:string andMessageType:DDMEssageSHuoShuo andToUserId:@"" success:^(NSArray *array, NSString *userId, NSString *messageContent, NSString *display_type) {
        sendSuccess(array,userId,messageContent,display_type);
    }];
}

-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId success:(void(^)(NSArray*,NSString*,NSString*,NSString*))Success
{
  
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    NSString * display_type = nil;
    switch (type) {
        case DDMessageTypeText:
           display_type = @"1";
            break;
        case DDMEssageMyWant:
            display_type = @"9";
            break;
        case DDMEssageMyApply:
            display_type = @"8";
            break;
        case DDMEssageSHuoShuo:
            display_type = @"11";
            break;
        case DDMessageTypeImage:
            display_type = @"2";
            break;
        case DDMessageTypeVoice:
            display_type = @"3";
            break;
        case DDMEssageMuchMyWantAndApply:
            display_type = @"10";
            break;
        case DDMEssageEmotion:
            display_type = @"1";
            break;
        case DDMEssagePersonalaCard:
            display_type = @"6";
            break;
        case DDMEssageLitterVideo:
            display_type = @"7";
            break;
        case DDMEssageLitterInviteAndApply:
            display_type = @"12";
            break;
        case DDMEssageLitteralbume:
            display_type = @"13";
            break;
        case DDMEssageMuchCollection:
            display_type = @"15";
            break;
        default:
            break;
    }
    Success(muarray,userId,messageContent,display_type);
}

-(void)sendeMuchFromMianshiToWeiPinFriends:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess
{
    NSData * data = [NSJSONSerialization dataWithJSONObject:self.muchDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self tranmitMessage:messageContent andMessageType:DDMEssageMuchMyWantAndApply andToUserId:@"" success:^(NSArray *array, NSString *userId, NSString *messageContent, NSString *display_type) {
        sendSuccess(array,userId,messageContent,display_type);
    }];
}
#pragma mark 分享求职招聘
-(NSString*)shareToOtherPeople:(BOOL)singleOrNot
{
    NSString * briefStr = self.model.enterprise_brief;
    NSString *description1 = [WPMySecurities textFromBase64String:briefStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length) {
     self.model.enterprise_brief = description3;   
    }
    
    
    
    NSString * titlteStr = nil;
    NSString * firstStr  = nil;
    NSString * secondStr = nil;
    NSString * imageStr  = nil;
    if (singleOrNot)//分享单个人的
    {
        if (self.type == WPMainPositionTypeInterView)
        {//面试
            firstStr = [NSString stringWithFormat:@"求职：%@",self.model.HopePosition];
            secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.sex.length?self.model.sex:@"",self.model.age.length?self.model.age:@"",self.model.education.length?self.model.education:@"",self.model.worktime.length?self.model.worktime:@"",self.model.lightspot.length?self.model.lightspot:@""];
            imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,self.model.avatar];
        }
        else
        {
            firstStr = [NSString stringWithFormat:@"招聘：%@",self.model.jobPositon];
            secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName.length?self.model.enterpriseName:@"",self.model.dataIndustry.length?self.model.dataIndustry:@"",self.model.enterprise_properties.length?self.model.enterprise_properties:@"",self.model.enterprise_scale.length?self.model.enterprise_scale:@"",self.model.enterprise_address.length?self.model.enterprise_address:@"",self.model.enterprise_brief.length?self.model.enterprise_brief:@""];
            imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,self.model.logo];
        }
        titlteStr = [NSString stringWithFormat:@"%@|%@|%@",firstStr,secondStr,imageStr];
    }
    else
    {
        BOOL isOrNot = (self.type == WPMainPositionTypeInterView);
        NSString * fiveStr = isOrNot?@"等人的求职":@"等企业的招聘";
        NSString * threeStr = isOrNot?@"的求职":@"的招聘";
        NSString * twoStr = isOrNot?@"求职：":@"招聘：";
        NSString * title = nil;
        NSString * position = nil;
        NSString * position1 = nil;
        NSString * position2 = nil;
        imageStr =isOrNot?[IPADDRESS stringByAppendingString:[self.selectedArray[0] avatar]]:[IPADDRESS stringByAppendingString:[self.selectedArray[0] logo]];
        if (self.selectedArray.count>2)
        {
            NSString * firstStr = [NSString stringWithFormat:@"%@",isOrNot?[self.selectedArray[0] name]:[self.selectedArray[0] enterpriseName]];
            NSString * secondStr= nil;
            for (int i = 1; i < self.selectedArray.count; i++)
            {
                secondStr =isOrNot?[self.selectedArray[i] name]:[self.selectedArray[i] enterpriseName];
                if (![secondStr isEqualToString:firstStr])
                {
                    break;
                }
                else
                {
                    secondStr = @"";
                }
            }
            title = secondStr.length?[NSString stringWithFormat:@"%@,%@%@",firstStr,secondStr,fiveStr]:[NSString stringWithFormat:@"%@%@",firstStr,threeStr];
            position  = [NSString stringWithFormat:@"%@%@",twoStr,isOrNot?[self.selectedArray[0] HopePosition]:[self.selectedArray[0] jobPositon]];
            position1 = [NSString stringWithFormat:@"%@%@",twoStr,isOrNot?[self.selectedArray[1] HopePosition]:[self.selectedArray[1] jobPositon]];
            position2 = [NSString stringWithFormat:@"%@%@",twoStr,isOrNot?[self.selectedArray[2] HopePosition]:[self.selectedArray[2] jobPositon]];
        }
        else
        {
            NSString * string = isOrNot?[self.selectedArray[0] name]:[self.selectedArray[0] enterpriseName];
            NSString * string1 = isOrNot?[self.selectedArray[1] name]:[self.selectedArray[1] enterpriseName];
            title = [string isEqualToString:string1]?[NSString stringWithFormat:@"%@%@",string,threeStr]:[NSString stringWithFormat:@"%@,%@%@",string,string1,threeStr];
            position  = [NSString stringWithFormat:@"%@%@",twoStr,isOrNot?[self.selectedArray[0] HopePosition]:[self.selectedArray[0] jobPositon]];
            position1 = [NSString stringWithFormat:@"%@%@",twoStr,isOrNot?[self.selectedArray[1] HopePosition]:[self.selectedArray[1] jobPositon]];
            position2 = @"";
        }
        titlteStr = [NSString stringWithFormat:@"%@|%@|%@",title,[NSString stringWithFormat:@"%@\n%@\n%@",position,position1,position2],imageStr];
    }
    return titlteStr;
}
-(NSString *)getContentStr:(NSDictionary*)dictionary
{
    NSString * speak_comment_state = dictionary[@"speak_comment_state"];
    
    NSString * description = dictionary[@"speak_comment_content"];
    NSString *description1 = [WPMySecurities textFromBase64String:description];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (!description3.length) {
        NSString * videoCount = [NSString stringWithFormat:@"%@",dictionary[@"videoCount"]];
        if (videoCount.intValue) {
            description3 = @"[视频]";
        }
        else
        {
            description3 = @"[图片]";
        }
    }
    if ([description3 isEqualToString:@"分享"])
    {
       description3 = [NSString stringWithFormat:@"%@/%@",speak_comment_state,description3];
    }
    else
    {
      description3 = [NSString stringWithFormat:@"%@：%@",speak_comment_state,description3];
    }
    
    return description3;
}
#pragma mark 从说说详情中分享说说
-(NSString*)shareShuoShuo:(NSArray*)array
{
    NSString * title =nil;
    NSString * imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,array[0][@"avatar"]];
    NSString * contentStr = nil;
    NSString * share = array[0][@"share"];
    switch (share.intValue) {
        case 0://原说说
        {
            title = [NSString stringWithFormat:@"%@的话题",array[0][@"nick_name"]];
            NSString *description3 = [self getContentStr:array[0]];
            contentStr = [NSString stringWithFormat:@"%@",description3];
        }
            break;
        case 1:
        {
            title = [NSString stringWithFormat:@"%@的话题",array[0][@"nick_name"]];
            NSString *description3 =[self getContentStr:array[0]];
            contentStr = [NSString stringWithFormat:@"%@",description3];
        }
            break;
        case 2://求职
        {
            title = [NSString stringWithFormat:@"%@的话题",array[0][@"nick_name"]];
            NSString *description3 =[self getContentStr:array[0]];
            contentStr = [NSString stringWithFormat:@"%@",description3];
            //contentStr = array[0][@"shareMsg"][@"share_title"];
        }
            break;
        case 3://招聘
        {
            title = [NSString stringWithFormat:@"%@的话题",array[0][@"nick_name"]];
            NSString *description3 =[self getContentStr:array[0]];
            contentStr = [NSString stringWithFormat:@"%@",description3];
            //contentStr = array[0][@"shareMsg"][@"share_title"];
        }
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@|%@|%@",title,contentStr,imageStr];
}

#pragma mark从说说详情中发送给好友
-(void)sendShuoShuoToWeiPinFriendsFromDetail:(NSDictionary*)dictionary success:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess
{
    NSString * share  = [NSString stringWithFormat:@"%@",dictionary[@"share"]];
    NSString * nickName = [NSString string];
    if ([share isEqualToString:@"0"]) {//原说说
        nickName = [NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]];
    }
    else if ([share isEqualToString:@"1"])//分享的说说
    {
        nickName = [NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]];
    }
    else if ([share isEqualToString:@"2"])
    {
        nickName = [NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]];
    }
    else
    {
        nickName = [NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]];//分享的招聘
    }
    NSString * contentStr = [NSString string];
    NSString * speak_comment_state = [NSString stringWithFormat:@"%@",dictionary[@"speak_comment_state"]];
    NSString * speak_comment_content = [NSString stringWithFormat:@"%@",dictionary[@"speak_comment_content"]];
    NSString *description1 = [WPMySecurities textFromBase64String:speak_comment_content];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length)
    {
        if ([description3 isEqualToString:@"分享"])
        {
          contentStr = [NSString stringWithFormat:@"%@/%@",speak_comment_state,description3];
        }
        else
        {
          contentStr = [NSString stringWithFormat:@"%@：%@",speak_comment_state,description3];
        }
        
    }
    else
    {
        NSString * videoCount = [NSString stringWithFormat:@"%@",dictionary[@"videoCount"]];
        if (videoCount.intValue) {
            contentStr = [NSString stringWithFormat:@"%@：[视频]",speak_comment_state];
        }
        else
        {
            contentStr = [NSString stringWithFormat:@"%@：[图片]",speak_comment_state];
        }
    }
    NSDictionary * dic = @{@"nick_name":nickName,
                           @"shuoshuoid":[dictionary[@"id"] length]?dictionary[@"id"]:@"",
                           @"avatar":[dictionary[@"avatar"] length]?[NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"avatar"]]:@"",
                           @"message":contentStr.length?contentStr:@""};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self tranmitMessage:messageContent andMessageType:DDMEssageSHuoShuo andToUserId:@"" success:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
        sendSuccess(array,toUserId,messageContent,display_type);
    }];
}
#pragma mark从招聘求职的查看详情中分享
-(NSString*)shareDetailFromZhaopinOrQiuZhiandImage:(NSString*)iageStr
{
    
    NSString * briefStr = self.model.enterprise_brief;
    NSString *description1 = [WPMySecurities textFromBase64String:briefStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    self.model.enterprise_brief = description3;
    
    iageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,iageStr];//[IPADDRESS stringByAppendingString:iageStr]
    NSString * firstStr = nil;
    NSString * secondStr = nil;
    if (self.isRecuilist)
    {//招聘
        firstStr = [NSString stringWithFormat:@"招聘：%@",self.model.jobPositon];
        secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName.length?self.model.enterpriseName:@"",self.model.dataIndustry.length?self.model.dataIndustry:@"",self.model.enterprise_properties.length?self.model.enterprise_properties:@"",self.model.enterprise_scale.length?self.model.enterprise_scale:@"",self.model.enterprise_address.length?self.model.enterprise_address:@"",self.model.enterprise_brief.length?self.model.enterprise_brief:@""];
    }
    else
    {
        firstStr = [NSString stringWithFormat:@"求职：%@",self.model.HopePosition];
        secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.age.length?self.model.age:@"",self.model.sex.length?self.model.sex:@"",self.model.education.length?self.model.education:@"",self.model.WorkTim.length?self.model.WorkTim:@""];
    }
    NSString * titleStr = [NSString stringWithFormat:@"%@|%@|%@",firstStr,secondStr,iageStr];
    return titleStr;
}
@end
