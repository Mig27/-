//
//  GroupChooseMemberCell.h
//  WP
//
//  Created by 沈亮亮 on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkManModel.h"
#import "GroupMemberModel.h"

@interface GroupChooseMemberCell : UITableViewCell

@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIImageView *selectBtnImg;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) LinkManListModel *model;
@property (nonatomic, strong) GroupMemberListModel *memberModel;
@property (nonatomic, assign) BOOL isFromChat;//从聊天界面发送名片
@property (nonatomic, assign) BOOL isFromTranmit;//从转发来
@property (nonatomic, copy) void(^btnClick)(UIButton*sebder);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


@end
