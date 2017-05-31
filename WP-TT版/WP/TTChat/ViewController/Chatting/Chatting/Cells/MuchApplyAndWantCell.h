//
//  MuchApplyAndWantCell.h
//  WP
//
//  Created by CC on 16/8/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DDChatBaseCell.h"

@interface MuchApplyAndWantCell : DDChatBaseCell<DDChatCellProtocol>
@property (nonatomic, strong)UIView * backView;
@property (nonatomic, strong)UIImageView*iconImage;
@property (nonatomic, strong)UIImageView*iconImage1;
@property (nonatomic, strong)UIImageView*iconImage2;
@property (nonatomic, strong)UIImageView*iconImage3;
@property (nonatomic, strong)UILabel * positionLabel;
@property (nonatomic, strong)UILabel * positionLabel1;
@property (nonatomic, strong)UILabel * positionLabel2;
@property (nonatomic, strong)UILabel * positionLabel3;
@property (nonatomic, strong)NSIndexPath*index;
@property (nonatomic, copy) void (^clickImage)(NSIndexPath*index);
-(void)sendeApplyAndWantAgajn:(MTTMessageEntity *)message success:(void(^)(NSString*,MTTMessageEntity*))Success;
@end
