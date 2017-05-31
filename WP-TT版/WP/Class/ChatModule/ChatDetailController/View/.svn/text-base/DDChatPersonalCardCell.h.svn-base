//
//  DDChatPersonalCardCell.h
//  WP
//
//  Created by CC on 16/8/20.
//  Copyright © 2016年 WP. All rights reserved.
//  消息 --> 详情页 --> cell
#import <UIKit/UIKit.h>
#import "DDChatBaseCell.h"
#import "SPLabel.h"

@interface DDChatPersonalCardCell : DDChatBaseCell<DDChatCellProtocol>
//@interface DDChatTextCell : DDChatBaseCell<DDChatCellProtocol,TTTAttributedLabelDelegate>

@property (nonatomic, strong)UIImageView*iconImage;
@property (nonatomic, strong)SPLabel *signLabel;
@property (nonatomic, strong)SPLabel * nameLabel;
@property (nonatomic, strong)SPLabel * infoLabel;
@property (nonatomic, strong)UILabel * dayLabel;
-(void)sendePersoinCardAgajn:(MTTMessageEntity *)message success:(void(^)(NSString*,MTTMessageEntity*))Success;
@end
