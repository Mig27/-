//
//  WPRemoveMemberViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"

@interface WPRemoveMemberViewController : BaseViewController

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, copy) void (^removeSuccessBlock)();
@property (nonatomic, copy)NSString * deleGroupId;
@end
