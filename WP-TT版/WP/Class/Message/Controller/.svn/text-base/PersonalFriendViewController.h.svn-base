//
//  PersonalFriendViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"

typedef  NS_ENUM(NSInteger, PersonalViewControllerType){
    PersonalViewControllerTypeFriend,
    PersonalViewControllerTypeAttention,
    PersonalViewControllerTypeFans
};

@interface PersonalFriendViewController : BaseViewController

@property (nonatomic, assign) PersonalViewControllerType type;
@property (nonatomic, strong) NSString *friend_id;
@property (nonatomic, copy) void (^friendRefreshBlock)();
@end
