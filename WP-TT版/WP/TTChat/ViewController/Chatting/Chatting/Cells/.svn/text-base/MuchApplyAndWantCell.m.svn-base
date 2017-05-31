//
//  MuchApplyAndWantCell.m
//  WP
//
//  Created by CC on 16/8/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "MuchApplyAndWantCell.h"
#import "DDMessageSendManager.h"
#import "SessionModule.h"
#import "MTTDatabaseUtil.h"
#import "WPDownLoadVideo.h"
@implementation MuchApplyAndWantCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.positionLabel = [[UILabel alloc]init];
        [self.positionLabel setFont:kFONT(15)];
        self.positionLabel.numberOfLines = 1;
        [self.positionLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.positionLabel];
        
        self.positionLabel1 = [[UILabel alloc]init];
        [self.positionLabel1 setFont:kFONT(12)];
        self.positionLabel1.textColor = [UIColor grayColor];
        [self.positionLabel1 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.positionLabel1];
        
        self.positionLabel2 = [[UILabel alloc]init];
        [self.positionLabel2 setFont:kFONT(12)];
        self.positionLabel2.textColor = [UIColor grayColor];
        [self.positionLabel2 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.positionLabel2];
        
        
        self.positionLabel3 = [[UILabel alloc]init];
        [self.positionLabel3 setFont:kFONT(12)];
        self.positionLabel3.textColor = [UIColor grayColor];
        [self.positionLabel3 setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.positionLabel3];
        
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = RGB(221, 221, 221);
        self.backView.layer.cornerRadius = 4;
        self.backView.clipsToBounds = YES;
        self.backView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.backView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [self.backView addGestureRecognizer:tap];
        
        
        self.iconImage = [UIImageView new];
        self.iconImage.layer.cornerRadius = 2.5;
        self.iconImage.clipsToBounds = YES;
        [self.backView addSubview:self.iconImage];
        
        self.iconImage1 = [UIImageView new];
        self.iconImage1.layer.cornerRadius = 2.5;
        self.iconImage1.clipsToBounds = YES;
        [self.backView addSubview:self.iconImage1];
        
        self.iconImage2 = [UIImageView new];
        self.iconImage2.layer.cornerRadius = 2.5;
        self.iconImage2.clipsToBounds = YES;
        [self.backView addSubview:self.iconImage2];
        
        self.iconImage3 = [UIImageView new];
        self.iconImage3.layer.cornerRadius = 2.5;
        self.iconImage3.clipsToBounds = YES;
        [self.backView addSubview:self.iconImage3];
        
        self.iconImage.userInteractionEnabled = YES;
        self.iconImage1.userInteractionEnabled = YES;
        self.iconImage2.userInteractionEnabled = YES;
        self.iconImage3.userInteractionEnabled = YES;
    }
    return self;
}
-(void)tapImage
{
    if (self.clickImage) {
        self.clickImage(self.index);
    }
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

-(void)sendeApplyAndWantAgajn:(MTTMessageEntity *)message success:(void(^)(NSString*,MTTMessageEntity*))Success
{
    if (self.isBlackNameOrNot||self.isDeleteOrNot)
    {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":self.isBlackNameOrNot?@"8":@"9",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username,
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

    
    NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
    NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * doic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * dictionary = @{@"content":doic,@"display_type":message.msgContentType ==DDMEssageMuchMyWantAndApply?@"10":@"15"};//@"10"
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
    [super setContent:content];
    [self.choiseBtn removeFromSuperview];
    [self.contentView addSubview:self.choiseBtn];
    // 获取气泡设置
    NSString * contentStr = [NSString stringWithFormat:@"%@",content.msgContent];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ( dic.count == 2) {
        id objc =  dic[@"content"];
        if ([objc isKindOfClass:[NSDictionary class]]) {
            dic = (NSDictionary*)objc;
        }
        else
        {
            NSString * contentStr = dic[@"content"];
            NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
            dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        }
//        NSString * contentStr = dic[@"content"];
//        NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//        dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    }
    
    
    UIImage * bubbleImage = nil;
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
    if (content.msgContentType == DDMEssageMuchMyWantAndApply) {
        NSString * curType = [NSString stringWithFormat:@"%@",dic[@"type"]];
        switch (curType.intValue) {
            case 1://求职
                self.positionLabel.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
                break;
            case 2:
                self.positionLabel.text =[NSString stringWithFormat:@"%@",dic[@"title"]];
                break;
            default:
                break;
        }
        self.positionLabel1.text = [dic[@"position_0"] length]?[NSString stringWithFormat:@"%@",dic[@"position_0"]]:@"";
        self.positionLabel2.text = [dic[@"position_1"] length]?[NSString stringWithFormat:@"%@",dic[@"position_1"]]:@"";
        self.positionLabel3.text = [dic[@"position_2"] length]?[NSString stringWithFormat:@"%@",dic[@"position_2"]]:@"";
        
        NSString * num = [NSString stringWithFormat:@"%@",dic[@"num"]];
        switch (num.intValue) {
            case 1:
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_0"]]]];
                break;
            case 2:
            {
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_0"]]]];
                [self.iconImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_1"]]]];
            }
                
                break;
            case 3:
            {
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_0"]]]];
                [self.iconImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_1"]]]];
                [self.iconImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_2"]]]];
            }
                break;
            case 4:
            {
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_0"]]]];
                [self.iconImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_1"]]]];
                [self.iconImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_2"]]]];
                [self.iconImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_3"]]]];
            }
                break;
            default:
            {
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_0"]]]];
                [self.iconImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_1"]]]];
                [self.iconImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_2"]]]];
                [self.iconImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar_3"]]]];
            }
                break;
        }
 
    }
    else
    {
        self.positionLabel.text = dic[@"title"];
        self.positionLabel1.text = [dic[@"info_0"] length]?[NSString stringWithFormat:@"%@",dic[@"info_0"]]:@"";
        self.positionLabel2.text = [dic[@"info_1"] length]?[NSString stringWithFormat:@"%@",dic[@"info_1"]]:@"";
        self.positionLabel3.text = [dic[@"info_2"] length]?[NSString stringWithFormat:@"%@",dic[@"info_2"]]:@"";
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@""]];
        self.iconImage.userInteractionEnabled = YES;
        NSData * data = [self imageData:dic[@"avatar"]];
        UIImage * image = [UIImage imageWithData:data];
        if (image) {
            self.iconImage.image = image;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                WPDownLoadVideo * downLoad = [[WPDownLoadVideo alloc]init];
                [downLoad downLoadImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar"]] success:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSData * data = (NSData*)response;
                        UIImage * image = [UIImage imageWithData:data];
                        self.iconImage.image = image;
                    });
                } failed:^(NSError *error) {
                    
                }];
            });
        }
    }
}
-(NSData *)imageData:(NSString*)filePath
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
    return kHEIGHT(43);
}

- (float)contentDownGapWithBubble
{
    return kHEIGHT(43);
}

- (float)contentLeftGapWithBubble
{
    return CHATH(105);
}

- (float)contentRightGapWithBubble
{
    return CHATH(105);
}
- (float)cellHeightForMessage:(MTTMessageEntity*)message
{
    return kHEIGHT(86);
}
- (void)layoutContentView:(MTTMessageEntity*)content
{
    NSString * contentStr = [NSString stringWithFormat:@"%@",content.msgContent];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString * num = [NSString stringWithFormat:@"%@",dic[@"num"]];
    CGFloat muchphotoWidth;
    if (num.intValue == 1) {
        muchphotoWidth = kHEIGHT(43);
    } else {
        muchphotoWidth = (kHEIGHT(43) - 6)/2;//1.5->6
    }
    
    BOOL isOrNot = (num.intValue == 3);
    BOOL isMuch = content.msgContentType != DDMEssageMuchMyWantAndApply;
    
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            [self.positionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-2*kHEIGHT(10)-5, kHEIGHT(32)));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10));
            }];
            
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(kHEIGHT(32));
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
            }];
            [self.positionLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backView.mas_right).offset(10);
                make.top.equalTo(_backView.mas_top).offset(0);
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-kHEIGHT(10)-kHEIGHT(43)-30,kHEIGHT(43)/3));
            }];
            
            [self.positionLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-kHEIGHT(10)-kHEIGHT(43)-30,kHEIGHT(43)/3));
                make.top.equalTo(_positionLabel1.mas_bottom).offset(0);
                make.left.equalTo(_backView.mas_right).offset(10);
            }];
            
            [self.positionLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-kHEIGHT(10)-kHEIGHT(43)-30,kHEIGHT(43)/3));
                make.top.equalTo(_positionLabel2.mas_bottom).offset(0);
                make.left.equalTo(_backView.mas_right).offset(10);
            }];
            
            if (isMuch) {
                [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
                    make.top.equalTo(_backView.mas_top).offset(0);
                    make.left.equalTo(_backView.mas_left).offset(0);
                }];
            }
            else
            {
                [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
                    make.top.equalTo(_backView.mas_top).offset(2);//0->2
                    make.left.equalTo(_backView.mas_left).offset(isOrNot?(kHEIGHT(43)-muchphotoWidth)/2:2);//0->2
                }];
                
                [self.iconImage1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(isOrNot?0:muchphotoWidth, isOrNot?0:muchphotoWidth));
                    make.top.equalTo(_backView.mas_top).offset(2);//0->2
                    make.left.equalTo(_iconImage.mas_right).offset(2);//0.5->2
                }];
                
                [self.iconImage2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
                    make.top.equalTo(_iconImage.mas_bottom).offset(2);//0.5->2
                    make.left.equalTo(_backView.mas_left).offset(2);//0->2
                }];
                
                [self.iconImage3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
                    make.top.equalTo(_iconImage.mas_bottom).offset(2);//0.5->2
                    make.left.equalTo(_iconImage2.mas_right).offset(2);//0.5->2
                }];
            }
//            [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
//                make.top.equalTo(_backView.mas_top).offset(0);
//                make.left.equalTo(_backView.mas_left).offset(isOrNot?(kHEIGHT(43)-muchphotoWidth)/2:0);
//            }];
//            
//            [self.iconImage1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(isOrNot?0:muchphotoWidth, isOrNot?0:muchphotoWidth));
//                make.top.equalTo(_backView.mas_top).offset(0);
//                make.left.equalTo(_iconImage.mas_right).offset(0.5);
//            }];
//            
//            [self.iconImage2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
//                make.top.equalTo(_iconImage.mas_bottom).offset(0.5);
//                make.left.equalTo(_backView.mas_left).offset(0);
//            }];
//            
//            [self.iconImage3 mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
//                make.top.equalTo(_iconImage.mas_bottom).offset(0.5);
//                make.left.equalTo(_iconImage2.mas_right).offset(0.5);
//            }];
        }
            break;
        case DDBubbleRight:
        {
            [self.positionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-2*kHEIGHT(10)-5, kHEIGHT(32)));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10));
            }];
            
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(kHEIGHT(10));
                make.top.equalTo(self.bubbleImageView.mas_top).offset(kHEIGHT(32));
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
            }];
            [self.positionLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backView.mas_right).offset(10);
                make.top.equalTo(_backView.mas_top).offset(0);
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-kHEIGHT(10)-kHEIGHT(43)-30,kHEIGHT(43)/3));
            }];
            
            [self.positionLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-kHEIGHT(10)-kHEIGHT(43)-30,kHEIGHT(43)/3));
                make.top.equalTo(_positionLabel1.mas_bottom).offset(0);
                make.left.equalTo(_backView.mas_right).offset(10);
            }];
            
            [self.positionLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(213)-kHEIGHT(10)-kHEIGHT(43)-30,kHEIGHT(43)/3));
                make.top.equalTo(_positionLabel2.mas_bottom).offset(0);
                make.left.equalTo(_backView.mas_right).offset(10);
            }];
            
            if (isMuch)
            {
                [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kHEIGHT(43), kHEIGHT(43)));
                    make.top.equalTo(_backView.mas_top).offset(0);
                    make.left.equalTo(_backView.mas_left).offset(0);
                }];
            }
            else
            {
                [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
                    make.top.equalTo(_backView.mas_top).offset(2);//0->2
                    make.left.equalTo(_backView.mas_left).offset(isOrNot?(kHEIGHT(43)-muchphotoWidth)/2:2);//0->2
                }];
                
                [self.iconImage1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(isOrNot?0:muchphotoWidth, isOrNot?0:muchphotoWidth));
                    make.top.equalTo(_backView.mas_top).offset(2);//0->2
                    make.left.equalTo(_iconImage.mas_right).offset(2);//0.5->2
                }];
                
                [self.iconImage2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
                    make.top.equalTo(_iconImage.mas_bottom).offset(2);//0.5->2
                    make.left.equalTo(_backView.mas_left).offset(2);//0->2
                }];
                
                [self.iconImage3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
                    make.top.equalTo(_iconImage.mas_bottom).offset(2);//0.5->2
                    make.left.equalTo(_iconImage2.mas_right).offset(2);//0.5->2
                }];
            }
//            [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
//                make.top.equalTo(_backView.mas_top).offset(0);
//                make.left.equalTo(_backView.mas_left).offset(isOrNot?(kHEIGHT(43)-muchphotoWidth)/2:0);
//            }];
//            
//            [self.iconImage1 mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(isOrNot?0:muchphotoWidth, isOrNot?0:muchphotoWidth));
//                make.top.equalTo(_backView.mas_top).offset(0);
//                make.left.equalTo(_iconImage.mas_right).offset(0.5);
//            }];
//            
//            [self.iconImage2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
//                make.top.equalTo(_iconImage.mas_bottom).offset(0.5);
//                make.left.equalTo(_backView.mas_left).offset(0);
//            }];
//            
//            [self.iconImage3 mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(muchphotoWidth, muchphotoWidth));
//                make.top.equalTo(_iconImage.mas_bottom).offset(0.5);
//                make.left.equalTo(_iconImage2.mas_right).offset(0.5);
//            }];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
