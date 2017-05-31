//
//  ActivityConditionController.h
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ConditionModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger index;

@end

@interface ActivityConditionController : BaseViewController

@property (nonatomic,copy) void(^completeBlock)(NSMutableArray *condition);
@property (nonatomic,copy) NSMutableArray *originalConditions;

@end
