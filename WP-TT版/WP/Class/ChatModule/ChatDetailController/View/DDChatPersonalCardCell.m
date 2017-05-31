//
//  DDChatPersonalCardCell.m
//  WP
//
//  Created by CC on 16/8/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DDChatPersonalCardCell.h"
#import "DDMessageSendManager.h"
#import "SessionModule.h"
#import "MTTDatabaseUtil.h"
#import "WPDownLoadVideo.h"
@implementation DDChatPersonalCardCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.signLabel = [[SPLabel alloc]init];
        [self.signLabel setFont:kFONT(15)];
        self.signLabel.textColor = [UIColor blackColor];
        [self.signLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.signLabel];
        
         self.nameLabel = [[SPLabel alloc]init];
//        [self.nameLabel setFont:kFONT(14)];
//        self.nameLabel.numberOfLines = 0;
//
        self.nameLabel.textColor = [UIColor blackColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.nameLabel];
        
         self.infoLabel = [[SPLabel alloc]init];
         [self.infoLabel setFont:kFONT(12)];
         self.infoLabel.verticalAlignment = VerticalAlignmentTop;
         self.infoLabel.textColor = RGB(127, 127, 127);
        [self.infoLabel setNumberOfLines:0];
        [self.infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.infoLabel];
        
        
        self.iconImage = [UIImageView new];
        self.iconImage.layer.cornerRadius = 4;
        self.iconImage.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        
    }
    return self;
}
#pragma mark 重新发送的协议
- (void)clickTheSendAgain:(MenuImageView*)imageView
{
    //子类去继承
    if (self.sendAgain)
    {
        self.sendAgain();
    }
}

-(void)sendePersoinCardAgajn:(MTTMessageEntity *)message success:(void(^)(NSString*,MTTMessageEntity*))Success
{
    if (self.isBlackNameOrNot||self.isDeleteOrNot)
    {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":self.isBlackNameOrNot?@"8":@"9",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username
                                                   ,
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *blackMessage =[MTTMessageEntity makeMessage:contentStr session:message.sessionId MsgType:msgContentType];
        Success(@"1",blackMessage);
        return;
    }
    
     message.state = DDMessageSending;
    NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
    NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * doic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * dictionary = @{@"content":doic,@"display_type":(message.msgContentType==DDMEssagePersonalaCard)?@"6":((message.msgContentType==DDMEssageMyApply)?@"8":(message.msgContentType == DDMEssageSHuoShuo)?@"11":(message.msgContentType == DDMEssageLitteralbume)?@"13":@"9")};//@"9"
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString * conten = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    message.msgContent = conten;
    
    BOOL isGroup = [message isGroupMessage];
    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:[[SessionModule instance] getSessionById:message.sessionId]  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        Success(@"0",nil);
        if (error) {
             [self showSendFailure];
            message.state = DDMessageSendFailure;
            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                if (result)
                {
                    [self showSendFailure];
                }
            }];
        }
        else
        {
             [self showSendSuccess];
            message.state = DDmessageSendSuccess;
            //刷新DB
            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                if (result)
                {
                   [self showSendSuccess];
                }
            }];
         }
    } Error:^(NSError *error) {
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
            if (result)
            {
                [self showSendFailure];
            }
        }];

    }];
}
- (void)setContent:(MTTMessageEntity*)content
{
//    self.signLabel.backgroundColor = [UIColor redColor];
//    self.nameLabel.backgroundColor = [UIColor greenColor];
    
    
    [super setContent:content];
    
    [self.choiseBtn removeFromSuperview];
    [self.contentView addSubview:self.choiseBtn];
    // 获取气泡设置
    NSString * contentStr = [NSString stringWithFormat:@"%@",content.msgContent];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * contentDic = dic[@"content"];
    if (contentDic.count)
    {
        dic = contentDic;
    }
    
    UIImage *bubbleImage = nil;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            bubbleImage = [UIImage imageNamed:@"qitaBubblel"];//self.leftConfig.picBgImage
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:self.leftConfig.imgStretchy.left topCapHeight:self.leftConfig.imgStretchy.top];
        }
            break;
        case DDBubbleRight:
        {
            bubbleImage = [UIImage imageNamed:@"qitaBubble"];//self.leftConfig.picBgImage
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:self.rightConfig.imgStretchy.left topCapHeight:self.rightConfig.imgStretchy.top];
        }
        default:
            break;
    }
    [self.bubbleImageView setImage:bubbleImage];
    switch (content.msgContentType)
    {
        case DDMEssageMyApply:
        {
//            _signLabel.text = @"求职简历";
//            self.nameLabel.text =[dic[@"qz_position"] length]?[NSString stringWithFormat:@"求职：%@",dic[@"qz_position"]]:[NSString stringWithFormat:@"%@",dic[@"title"]];
//            self.nameLabel.textColor = [UIColor blackColor];
//            self.nameLabel.font = kFONT(14);
//            self.infoLabel.text =[dic[@"info"] length]?[NSString stringWithFormat:@"%@",dic[@"info"]]:[NSString stringWithFormat:@"%@ %@ %@ %@ %@",dic[@"qz_name"],dic[@"qz_sex"],dic[@"qz_age"],dic[@"qz_educaiton"],dic[@"qz_workTime"]];
//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"qz_avatar"]]]];
        
            
            _signLabel.text = [dic[@"qz_position"] length]?[NSString stringWithFormat:@"求职：%@",dic[@"qz_position"]]:[NSString stringWithFormat:@"%@",dic[@"title"]];
            self.nameLabel.text = [dic[@"info"] length]?[NSString stringWithFormat:@"%@",dic[@"info"]]:[NSString stringWithFormat:@"%@ %@ %@ %@ %@",dic[@"qz_name"],dic[@"qz_sex"],dic[@"qz_age"],dic[@"qz_educaiton"],dic[@"qz_workTime"]];
            self.nameLabel.textColor = [UIColor blackColor];
//            self.nameLabel.font = kFONT(14);
            self.nameLabel.font = kFONT(11);
            self.nameLabel.numberOfLines = 3;
            self.nameLabel.textColor = RGB(127, 127, 127);
            self.infoLabel.text = @"";
            
            [self iconImage:dic[@"qz_avatar"]];

//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"qz_avatar"]]]];
        }
            break;
        case DDMEssagePersonalaCard://
        {
            _signLabel.text = @"个人名片";
            [self.nameLabel setFont:kFONT(14)];
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
//            self.infoLabel.text = [NSString stringWithFormat:@"微聘号 ：%@",dic[@"wp_id"]];
            self.nameLabel.textColor = [UIColor blackColor];
            NSString * positionStr = dic[@"position"];
            NSString * companyStr = dic[@"company"];
            if (positionStr.length>6) {
                positionStr = [positionStr substringToIndex:6];
                positionStr = [positionStr stringByAppendingString:@"..."];
            }
            if (companyStr.length > 6) {
                companyStr = [companyStr substringToIndex:6];
                companyStr = [companyStr stringByAppendingString:@"..."];
            }
            self.infoLabel.text = [NSString stringWithFormat:@"%@ | %@",positionStr,companyStr];
            
            [self iconImage:dic[@"avatar"]];

//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar"]]]];
        }
            break;
        case DDMEssageMyWant:
        {
//            _signLabel.text = @"企业招聘";
//            self.nameLabel.text =[dic[@"zp_position"] length]?[NSString stringWithFormat:@"招聘：%@",dic[@"zp_position"]]:[NSString stringWithFormat:@"%@",dic[@"title"]];
//            self.nameLabel.textColor = [UIColor blackColor];
//            self.nameLabel.font = kFONT(14);
//            self.infoLabel.text =[dic[@"info"] length]?[NSString stringWithFormat:@"%@",dic[@"info"]]:[NSString stringWithFormat:@"%@",dic[@"cp_name"]];
//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"zp_avatar"]]]];
            
            _signLabel.text = [dic[@"zp_position"] length]?[NSString stringWithFormat:@"招聘：%@",dic[@"zp_position"]]:[NSString stringWithFormat:@"%@",dic[@"title"]];
            self.nameLabel.text =dic[@"info"];
            self.nameLabel.textColor = [UIColor blackColor];
            self.nameLabel.font = kFONT(11);
            self.nameLabel.numberOfLines = 3;
            self.nameLabel.textColor = RGB(127, 127, 127);
            self.infoLabel.text = @"";
            [self iconImage:dic[@"zp_avatar"]];
            
//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"zp_avatar"]]]];
        }
            break;
        case DDMEssageSHuoShuo:
        {
            _signLabel.text = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"message"]];
            self.nameLabel.font = kFONT(11);
            self.nameLabel.numberOfLines = 3;
            self.nameLabel.textColor = RGB(127, 127, 127);
            self.infoLabel.text = @"";
            
            
            [self iconImage:dic[@"avatar"]];

//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"avatar"]]]];
        }
            break;
        case DDMEssageLitteralbume:
        {
            _signLabel.text = [NSString stringWithFormat:@"%@",dic[@"from_title"]];
            self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"from_info"]];
            self.nameLabel.font = kFONT(11);
            self.nameLabel.numberOfLines = 3;
            self.nameLabel.textColor = RGB(127, 127, 127);
            self.infoLabel.text = @"";
            [self iconImage:dic[@"from_avatar"]];
//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"from_avatar"]]]];
        }
            break;
        default:
            break;
    }
}
-(void)iconImage:(NSString*)imageStr
{
    NSData * data = [self photoData:imageStr];
    if (data) {
        
        UIImage * image = [UIImage imageWithData:data];
        if (image) {
            self.iconImage.image = image;
        }
        else
        {
            
            NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
            NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            [[NSFileManager defaultManager] removeItemAtPath:fileName1 error:nil];
            
            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [down downLoadImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr] success:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.iconImage.image = [UIImage imageWithData:response];
                    });
                } failed:^(NSError *error) {
                    NSLog(@"%@",error.description);
                }];
            });
        }
//        self.iconImage.image = [UIImage imageWithData:data];
    }
    else
    {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [down downLoadImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr] success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconImage.image = [UIImage imageWithData:response];
                });
            } failed:^(NSError *error) {
            }];
        });
    }
}
-(NSData*)photoData:(NSString*)filePath
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
- (float)contentUpGapWithBubble
{
    return kHEIGHT(43);//kHEIGHT(43)
}

- (float)contentDownGapWithBubble
{
    return kHEIGHT(43);//kHEIGHT(43)
}

- (float)contentLeftGapWithBubble
{
    return CHATH(105);//kHEIGHT(106.5)
}

- (float)contentRightGapWithBubble
{
    return CHATH(105);
}
- (float)cellHeightForMessage:(MTTMessageEntity*)message
{
   return kHEIGHT(86);//kHEIGHT(86)
}
- (void)layoutContentView:(MTTMessageEntity*)content
{
    NSString * contentStr = [NSString stringWithFormat:@"%@",content.msgContent];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([dic[@"content"] count]) {
        dic = dic[@"content"];
    }
    
    
    BOOL isImageOrNot = false;
    if (content.msgContentType == DDMEssageLitteralbume) {
        NSString * imageStr = dic[@"from_avatar"];
        isImageOrNot = !imageStr.length;
    }
    
    
    BOOL isOrNot = NO;
    switch (content.msgContentType) {
        case DDMEssagePersonalaCard:
            isOrNot = NO;
            break;
        case DDMEssageMyApply:
            isOrNot = YES;
//            isOrNot = ![[NSString stringWithFormat:@"%@%@%@%@%@",dic[@"qz_name"],dic[@"qz_sex"],dic[@"qz_age"],dic[@"qz_educaiton"],dic[@"qz_workTime"]] length];
            break;
        case DDMEssageMyWant:
//            isOrNot = ![[NSString stringWithFormat:@"%@",dic[@"cp_name"]] length];
            isOrNot = YES;
            break;
        case DDMEssageSHuoShuo:
            isOrNot = YES;
            break;
        case DDMEssageLitteralbume:
            isOrNot = YES;
            break;
        default:
            break;
    }
    self.nameLabel.verticalAlignment = isOrNot?VerticalAlignmentTop:VerticalAlignmentBottom;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            [_signLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(CHATH(213)-2*kHEIGHT(10)-8, kHEIGHT(32)));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10)+6);
            }];
            
            [_iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10)+6);
                make.top.equalTo(self.bubbleImageView.mas_top).offset(kHEIGHT(32));
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
            }];
            [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconImage.mas_right).offset(isImageOrNot?(-kHEIGHT(43)):10);
                make.top.equalTo(_iconImage.mas_top).offset(0);
                make.size.mas_equalTo(CGSizeMake(isImageOrNot?CHATH(213)-30:CHATH(213)-kHEIGHT(10)-kHEIGHT(43)-30,isOrNot?kHEIGHT(43):(kHEIGHT(43)-10)/2));
            }];
            
            [_infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(CHATH(213)-kHEIGHT(10)-kHEIGHT(43)-30,isOrNot?0:(kHEIGHT(43)-10)/2));
                make.bottom.equalTo(_iconImage.mas_bottom).offset(0);
                make.left.equalTo(_iconImage.mas_right).offset(10);
            }];
        }
            break;
        case DDBubbleRight:
        {
            [_signLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(CHATH(213)-2*kHEIGHT(10)-8, kHEIGHT(32)));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10));
            }];
            
            [_iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(kHEIGHT(32));
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
            }];
            [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconImage.mas_right).offset(isImageOrNot?(-kHEIGHT(43)):10);
                make.top.equalTo(_iconImage.mas_top).offset(0);
                make.size.mas_equalTo(CGSizeMake(isImageOrNot?CHATH(213)-30:CHATH(213)-kHEIGHT(10)-kHEIGHT(43)-30,isOrNot?kHEIGHT(43):(kHEIGHT(43)-10)/2));
            }];
            
            [_infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(CHATH(213)-kHEIGHT(10)-kHEIGHT(43)-30,isOrNot?0:(kHEIGHT(43)-10)/2));
                make.bottom.equalTo(_iconImage.mas_bottom).offset(0);
                make.left.equalTo(_iconImage.mas_right).offset(10);
            }];
        }
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
