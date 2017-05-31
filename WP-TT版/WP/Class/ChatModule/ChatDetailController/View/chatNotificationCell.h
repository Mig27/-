//
//  chatNotificationCell.h
//  WP
//
//  Created by CC on 16/9/6.
//  Copyright © 2016年 WP. All rights reserved.
//  聊天 --> 群通知 --> 展示单元格

#import <UIKit/UIKit.h>
#import "chatNotiModel.h"
@interface chatNotificationCell : UITableViewCell
@property (nonatomic,strong)UIImageView*icomImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel* descriLabel;
@property (nonatomic, strong)UIButton * stateBtn;
@property (nonatomic, strong)NSDictionary*model;
@property (nonatomic, strong)NSIndexPath*indexPath;
@property (nonatomic, copy)void (^clickAgree)(NSIndexPath*indespath);
@end
