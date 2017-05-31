//
//  DDChatBaseCell.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-28.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "DDChatBaseCell.h"
#import "UIView+Addition.h"
#import "DDUserModule.h"
#import "ChattingMainViewController.h"
#import "PublicProfileViewControll.h"
#import "UILabel+VerticalAlign.h"
#import "MTTBubbleModule.h"
#import <UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "PersonalInfoViewController.h"
#import "ChattingMainViewController.h"
#import "WPDownLoadVideo.h"
CGFloat const dd_avatarEdge = 10;                 //头像到边缘的距离
CGFloat const dd_avatarBubbleGap = 5;             //头像和气泡之间的距离
CGFloat const dd_bubbleUpDown = 20;                //气泡到上下边缘的距离
@interface DDChatBaseCell ()
@property(copy)NSString *currentUserID;

@end
@implementation DDChatBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        press.minimumPressDuration = 0.5;
        [_contentLabel addGestureRecognizer:press];
        
        [[ChattingMainViewController shareInstance].singleTap requireGestureRecognizerToFail:press];
//        [self.contentView setBackgroundColor:TTBG];
        [self.contentView setBackgroundColor:RGB(235, 235, 235)];//[UIColor clearColor]
        [self setBackgroundColor:RGB(235, 235, 235)];//[UIColor clearColor]
        
        self.userAvatar = [UIImageView new];
        [self.userAvatar setUserInteractionEnabled:YES];
        [self.userAvatar setContentMode:UIViewContentModeScaleAspectFill];
        [self.userAvatar setClipsToBounds:YES];
        [self.userAvatar.layer setCornerRadius:5];
        [self.contentView addSubview:self.userAvatar];
        
        
        self.userName = [UILabel new];
        [self.userName setBackgroundColor:[UIColor clearColor]];
        [self.userName setFont:systemFont(11)];
        [self.userName setTextColor:RGB(127, 127, 127)];
        [self.userName alignTop];
        [self.contentView addSubview:self.userName];
        [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 15));
            make.top.mas_equalTo(0);
            make.left.equalTo(self.userAvatar.mas_right).offset(13);
        }];
        
        self.bubbleImageView = [MenuImageView new];
        self.bubbleImageView.tag = 1000;
        self.bubbleImageView.delegate = self;
        [self.bubbleImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.bubbleImageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityView setHidesWhenStopped:YES];
        [self.activityView setHidden:YES];
        [self.contentView addSubview:self.activityView];
        
        self.sendFailuredImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.sendFailuredImageView setHidden:YES];
        [self.contentView setAutoresizesSubviews:NO];
        self.sendFailuredImageView.userInteractionEnabled=YES;
        [self.contentView addSubview:self.sendFailuredImageView];
        [self.sendFailuredImageView setImage:[UIImage imageNamed:@"dd_send_failed"]];
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheSendAgain)];
        [self.sendFailuredImageView addGestureRecognizer:pan];
        UITapGestureRecognizer *openProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfilePage)];
        [self.userAvatar addGestureRecognizer:openProfile];
        
        
        self.choiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.choiseBtn addTarget: self action:@selector(choiseCell:) forControlEvents:UIControlEventTouchUpInside];
        [self.choiseBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.choiseBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        self.choiseBtn.hidden = YES;
//        [self.contentView addSubview:self.choiseBtn];
        
        self.choiseBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.choiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
  return self;
}
-(void)choiseCell:(UIButton*)sender
{
    if (self.clickLeftBtn) {
        self.clickLeftBtn(self.indexPath,sender);
    }
}
-(void)setItemSelected:(BOOL)itemSelected
{
    self.choiseBtn.selected = itemSelected;
}
#pragma mark - 聊天页面,点击头像跳到个人资料
-(void)openProfilePage
{
    if (self.currentUserID) {
        [[DDUserModule shareInstance] getUserForUserID:self.currentUserID Block:^(MTTUserEntity *user) {
            PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
            info.friendID = [user.objID substringFromIndex:5];
            info.newType = NewRelationshipTypeFriend;
//            [self.navigationController pushViewController:info animated:YES];
//            PublicProfileViewControll *public = [PublicProfileViewControll new];
//            public.user=user;
            [[ChattingMainViewController shareInstance].navigationController pushViewController:info animated:YES];
        }];
    }
}
-(void)clickTheSendAgain
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重发" message:@"是否重新发送此消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self clickTheSendAgain:nil];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(NSData*)imageData:(NSString*)imageStr
{
    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
- (void)setContent:(MTTMessageEntity*)content
{
    // 获取气泡设置
    _leftConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:YES];
    _rightConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:NO];
    
    id<DDChatCellProtocol> cell = (id<DDChatCellProtocol>)self;
    if (self.location == DDBubbleLeft) {
       
    }
    //设置头像位置
    switch (self.location) {
        case DDBubbleLeft:
            [self.userAvatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(dd_avatarEdge);
            }];
            break;
        case DDBubbleRight:
            [self.userAvatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(-dd_avatarEdge);
            }];
            break;
        default:
            break;
    }
    // 设置头像和昵称
    self.currentUserID=content.senderId;
    [[DDUserModule shareInstance] getUserForUserID:content.senderId Block:^(MTTUserEntity *user) {
        if (user&&user.avatar.length > 0) {
            NSString *urlStr = [IPADDRESS stringByAppendingString:user.avatar];
            NSURL* avatarURL = [NSURL URLWithString:urlStr];
            
            NSData * data = [self imageData:urlStr];
            if (data) {
                self.userAvatar.image = [UIImage imageWithData:data];
            }
            else
            {
                WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [down downLoadImage:urlStr success:^(id response) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.userAvatar.image = [UIImage imageWithData:response];
                        });
                    } failed:^(NSError *error) {
                        self.userAvatar.image = [UIImage imageNamed:@"user_placeholder"];
                    }];
                });
            }
            [self.userName setText:user.nick];
            
            //群聊是设置备注名称
            if (content.sessionType == 0) {
                NSString * string = user.email;
                NSData * strData = [string dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];
                NSArray * group = dic[@"group"];
                NSString * sessionID = [content.sessionId componentsSeparatedByString:@"_"][1];
                for (NSDictionary * dictionary in group) {
                    if ([dictionary[@"group_id"] isEqualToString:sessionID]) {
                        NSString * friend_nick = dictionary[@"friend_nick"];
                        if (friend_nick.length && ![friend_nick isEqualToString:@" "]) {
                         [self.userName setText:dictionary[@"friend_nick"]];
                        }
                    }
                }
            }
        }
        else
        {
            [self.userAvatar setImage:[UIImage imageNamed:@"user_placeholder"]];
        }
    }];
    
    //设置昵称是否隐藏
    if (self.session.sessionType == SessionTypeSessionTypeSingle || self.location == DDBubbleRight) {
        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.userName setHidden:YES];
    }else{
        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
        }];
        [self.userName setHidden:NO];
    }
    
    CGSize size = [cell sizeForContent:content];
    float bubbleheight = [cell contentUpGapWithBubble] + size.height + [cell contentDownGapWithBubble];
    float bubbleWidth = [cell contentLeftGapWithBubble] + size.width + [cell contentRightGapWithBubble];
    
    //设置按钮位置
    self.choiseBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, bubbleheight);
    [self.choiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
//    [self.choiseBtn setBackgroundColor:[UIColor redColor]];
    
    //设置气泡相关
    UIImage* bubbleImage = nil;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            bubbleImage = [UIImage imageNamed:_leftConfig.textBgImage];
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:_leftConfig.stretchy.left topCapHeight:_leftConfig.stretchy.top];
            [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.userAvatar.mas_right).offset(dd_avatarBubbleGap);
                make.top.mas_equalTo(self.userName.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(bubbleWidth, bubbleheight));
            }];
        }
            break;
        case DDBubbleRight:
        {
            bubbleImage = [UIImage imageNamed:_rightConfig.textBgImage];
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:_rightConfig.stretchy.left topCapHeight:_rightConfig.stretchy.top];
            [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.userAvatar.mas_left).offset(-dd_avatarBubbleGap);
                make.top.mas_equalTo(self.userName.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(bubbleWidth, bubbleheight));
            }];
            break;
        }
        default:
            break;
    }
    [self.bubbleImageView setImage:bubbleImage];
    self.bubbleImageView.userInteractionEnabled = YES;
    self.contentLabel.userInteractionEnabled = YES;
    
    //设置菊花位置
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bubbleImageView.mas_right).offset(10);
                make.bottom.mas_equalTo(self.bubbleImageView.mas_bottom);
            }];
            [self.sendFailuredImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bubbleImageView.mas_right).offset(10);
                make.bottom.mas_equalTo(self.bubbleImageView.mas_bottom);
            }];
        }
            break;
        case DDBubbleRight:
        {
            
            [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.bubbleImageView.mas_left).offset(-10);
                make.bottom.mas_equalTo(self.bubbleImageView.mas_bottom);
            }];
            [self.sendFailuredImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.bubbleImageView.mas_left).offset(-10);
                make.bottom.mas_equalTo(self.bubbleImageView.mas_bottom);
            }];
        }
            break;
        default:
            break;
    }
    
    DDImageShowMenu showMenu = 0;
    
    switch (content.state)
    {
        case DDMessageSending:
            [self.activityView startAnimating];
            self.sendFailuredImageView.hidden = YES;
            break;
        case DDMessageSendFailure:
            [self.activityView stopAnimating];
            self.sendFailuredImageView.hidden = NO;
            showMenu = DDShowSendAgain;
            break;
        case DDmessageSendSuccess:
            [self.activityView stopAnimating];
            self.sendFailuredImageView.hidden = YES;
            break;
    }
    if (self.location == DDBubbleLeft) {
        self.sendFailuredImageView.hidden = YES;
    }
    
//    DDShowEarphonePlay                      = 1,        //听筒播放
//    DDShowSpeakerPlay                       = 1 << 1,   //扬声器播放
//    DDShowSendAgain                         = 1 << 2,   //重发
//    DDShowCopy                              = 1 << 3,   //复制
//    DDShowPreview                           = 1 << 4,   //图片预览
//    DDShowMore                              = 1 << 5,   //更多
//    DDShowtransferText                      = 1 << 6,   //转文字
//    DDShowRevoke                            = 1 << 7,   //撤回
//    DDShowDelete                            = 1 << 8,   //删除
//    DDShowTransmit                          = 1 << 9,   //转发
//    DDShowCollect                           = 1 << 10,  //收藏
//    DDShowAdd                               = 1 << 11,  //添加
//    DDShowLookup                            = 1 << 12,  //查看
    
    //设置菜单
    BOOL isOrNot = (content.state == DDMessageSendFailure);
    switch (content.msgContentType) {
        case DDMessageTypeImage:
            if (isOrNot) {
               showMenu = showMenu | DDShowTransmit | DDShowSendAgain | DDShowCollect  | DDShowDelete  | DDShowMore  ;
            }
            else
            {
                showMenu = showMenu | DDShowTransmit | DDShowCollect  | DDShowDelete  | DDShowMore  ;
            }
//            showMenu = showMenu | DDShowTransmit | DDShowCollect  | DDShowDelete  | DDShowMore  ;
            break;
        case DDMessageTypeText:
            if (isOrNot) {
                showMenu = showMenu | DDShowCopy | DDShowTransmit  | DDShowSendAgain | DDShowCollect  | DDShowDelete | DDShowMore ;
            }
            else
            {
              showMenu = showMenu | DDShowCopy | DDShowTransmit  | DDShowCollect  | DDShowDelete | DDShowMore ;
            }
            
//            showMenu = showMenu | DDShowCopy | DDShowTransmit  | DDShowCollect  | DDShowDelete | DDShowMore ;
            break;
        case DDMessageTypeVoice:
            if (isOrNot) {
                showMenu = showMenu | DDShowEarphonePlay |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu | DDShowEarphonePlay | DDShowCollect | DDShowDelete | DDShowMore ;
            }
//            showMenu = showMenu | DDShowEarphonePlay | DDShowCollect | DDShowDelete | DDShowMore ;
            break;
        case DDMEssageMyApply:
            if (isOrNot) {
                showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
            showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            break;
        case DDMEssageMyWant:
            if (isOrNot) {
                showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
//            showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            break;
        case DDMEssagePersonalaCard://DDMEssageLitteralbume
            if (isOrNot) {
                showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
            break;
        case DDMEssageLitteralbume://DDMEssageLitteralbume
            if (isOrNot) {
                showMenu = showMenu  |DDShowSendAgain | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu  | DDShowDelete | DDShowMore ;
            }
            break;
        case DDMEssageMuchMyWantAndApply:
            if (isOrNot) {
                showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
               showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
            showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            break;
        case DDMEssageSHuoShuo:
            if (isOrNot) {
                showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
//            showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            break;
        case DDMEssageLitterVideo:
            if (isOrNot) {
                 showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                 showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
//            showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            break;//DDMEssageMuchCollection
        case DDMEssageMuchCollection:
            if (isOrNot) {
                showMenu = showMenu | DDShowTransmit |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
            }
            else
            {
                showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            }
            showMenu = showMenu | DDShowTransmit | DDShowCollect | DDShowDelete | DDShowMore ;
            break;
        default:
            break;
    }
    [self.bubbleImageView setShowMenu:showMenu];
    //设置内容位置
    [cell layoutContentView:content];
}

-(void)setInfo:(NSDictionary*)dictionary
{

    // 获取气泡设置
    _leftConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:YES];
    _rightConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:NO];
    
    id<DDChatCellProtocol> cell = (id<DDChatCellProtocol>)self;
    //设置头像位置
    switch (self.location) {
        case DDBubbleLeft:
            [self.userAvatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(dd_avatarEdge);
            }];
            break;
        case DDBubbleRight:
            [self.userAvatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(-dd_avatarEdge);
            }];
            break;
        default:
            break;
    }
            [self.userName setText:@"快捷招聘"];
            [self.userAvatar setImage:[UIImage imageNamed:@"sysinfo"]];

        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
        }];
        [self.userName setHidden:NO];

    
    CGSize size = [cell sizeForinfoContent:dictionary[@"speak_content"]];
    float bubbleheight = [cell contentUpGapWithBubble] + size.height + [cell contentDownGapWithBubble];
    float bubbleWidth = [cell contentLeftGapWithBubble] + size.width + [cell contentRightGapWithBubble];
    
    //设置按钮位置
    self.choiseBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, bubbleheight);
    [self.choiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
    //    [self.choiseBtn setBackgroundColor:[UIColor redColor]];
    
    //设置气泡相关
    UIImage* bubbleImage = nil;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            bubbleImage = [UIImage imageNamed:_leftConfig.textBgImage];
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:_leftConfig.stretchy.left topCapHeight:_leftConfig.stretchy.top];
            [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.userAvatar.mas_right).offset(dd_avatarBubbleGap);
                make.top.mas_equalTo(self.userName.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(bubbleWidth, bubbleheight));
            }];
        }
            break;
        case DDBubbleRight:
        {
            bubbleImage = [UIImage imageNamed:_rightConfig.textBgImage];
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:_rightConfig.stretchy.left topCapHeight:_rightConfig.stretchy.top];
            [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.userAvatar.mas_left).offset(-dd_avatarBubbleGap);
                make.top.mas_equalTo(self.userName.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(bubbleWidth, bubbleheight));
            }];
            break;
        }
        default:
            break;
    }
    [self.bubbleImageView setImage:bubbleImage];
    self.bubbleImageView.userInteractionEnabled = YES;
    self.contentLabel.userInteractionEnabled = NO;
    [self layoutinfoContentView:dictionary[@"speak_content"]];
}
-(void)layoutinfoContentView:(NSDictionary*)dic
{

}

-(void)earOrSpeak:(BOOL)menu andMessage:(MTTMessageEntity*)message
{
    DDImageShowMenu showMenu = 0;
    if (message.msgContentType == DDMessageTypeVoice) {
        BOOL isOrNot = (message.state == DDMessageSendFailure);
        if (isOrNot) {
            showMenu = showMenu | (menu?DDShowSpeakerPlay:DDShowEarphonePlay) |DDShowSendAgain| DDShowCollect | DDShowDelete | DDShowMore ;
        }
        else
        {
            showMenu = showMenu | (menu?DDShowSpeakerPlay:DDShowEarphonePlay) | DDShowCollect | DDShowDelete | DDShowMore ;
        }
        [self.bubbleImageView setShowMenu:showMenu];
    }
}

-(void)setIsMore:(BOOL)isMore
{
    if (isMore)
    {
        self.choiseBtn.hidden = NO;
        if (self.location == DDBubbleLeft)
        {
            [self.userAvatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(dd_avatarEdge+40);
            }];
        }
        
        
    }
    else
    {
        self.choiseBtn.hidden = YES;
        if (self.location == DDBubbleLeft)
        {
            [self.userAvatar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(dd_avatarEdge);
            }];
        }
    }

}
-(void)longPress:(UIGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.bubbleImageView showTheMenu];
    }

}


- (void)showSendFailure
{
    [self.activityView stopAnimating];
    self.sendFailuredImageView.hidden = NO;
    DDImageShowMenu showMenu = self.bubbleImageView.showMenu | DDShowSendAgain;
    [self.bubbleImageView setShowMenu:showMenu];
}

- (void)showSendSuccess
{
    [self.activityView stopAnimating];
    self.sendFailuredImageView.hidden = YES;
}

- (void)showSending
{
    [self.activityView startAnimating];
    self.sendFailuredImageView.hidden = YES;
}

#pragma mark -
#pragma mark Protocol
- (CGSize)sizeForContent:(MTTMessageEntity*)message
{
    return CGSizeZero;
}

- (float)contentUpGapWithBubble
{
    return 0;
}

- (float)contentDownGapWithBubble
{
    return 0;
}

- (float)contentLeftGapWithBubble
{
    return 0;
}

- (float)contentRightGapWithBubble
{
    return 0;
}

- (void)layoutContentView:(MTTMessageEntity*)content
{
    
}

- (float)cellHeightForMessage:(MTTMessageEntity*)message
{
    _leftConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:YES];
    _rightConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:NO];
    return 0;
}

- (float)cellHeightForinfo:(NSString*)message
{
    _leftConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:YES];
    _rightConfig = [[MTTBubbleModule shareInstance] getBubbleConfigLeft:NO];
    return 0;
}

#pragma mark -
#pragma mark DDMenuImageView Delegate

//点击更多
- (void)clickTheMore:(MenuImageView *)imageView
{
    if (self.clickMoreChoise) {
        self.clickMoreChoise();
    }
}
#pragma mark 复制
- (void)clickTheCopy:(MenuImageView*)imageView
{
    //子类去继承
}
//转发
- (void)clickTheTransmit:(MenuImageView *)imageView
{
    if (self.tranmitMessag) {
        self.tranmitMessag();
    }
}
//听筒
- (void)clickTheEarphonePlay:(MenuImageView*)imageView
{
    if (self.clickEarPhone) {
        self.clickEarPhone();
    }
}
//扬声器
- (void)clickTheSpeakerPlay:(MenuImageView*)imageView
{
    if (self.clickSpeak) {
        self.clickSpeak();
    }
}
//从新发送
- (void)clickTheSendAgain:(MenuImageView*)imageView
{
    //子类去继承
    if (self.clickMenuSendAgain) {
        self.clickMenuSendAgain();
    }
}

- (void)tapTheImageView:(MenuImageView*)imageView
{
    if (self.tapInBubble)
    {
        self.tapInBubble();
    }
}

- (void)clickThePreview:(MenuImageView *)imageView
{
    //子类去继承
}
//删除
- (void)clickTheDelete:(MenuImageView *)imageView
{
    if (self.deleteMessage) {
        self.deleteMessage();
    }
}
-(void)clickTheCollect:(MenuImageView *)imageView
{
    if (self.clickCollection) {
        self.clickCollection();
    }
}

@end
