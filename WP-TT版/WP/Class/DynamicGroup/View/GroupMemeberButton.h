//
//  GroupMemeberButton.h
//  WP
//
//  Created by 沈亮亮 on 16/5/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMemberModel.h"

@interface GroupMemeberButton : UIView

@property (nonatomic, strong) GroupMemberListModel *modelInfo;
@property (nonatomic, copy) NSString * groupID;
@property (nonatomic, copy) void (^iconClick)(NSString *user_id);

- (instancetype)initWithFrame:(CGRect)frame model:(GroupMemberListModel *)model;

@end
