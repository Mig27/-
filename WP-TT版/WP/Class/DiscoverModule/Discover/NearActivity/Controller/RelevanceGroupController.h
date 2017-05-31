//
//  RelevanceGroupController.h
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelevanceGroupModel.h"
#import "BaseViewController.h"

@interface RelevanceGroupController : BaseViewController

@property (nonatomic,copy) void(^selectBlock)(RelevanceGroupListModel *model);

@end
