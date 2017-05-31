//
//  WPNickNameEditViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"

@interface WPNickNameEditViewController : BaseViewController

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, strong) void (^modifyNickSuccess)();

@end
