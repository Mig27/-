//
//  ApplyGroupController.h
//  WP
//
//  Created by 沈亮亮 on 15/10/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyGroupController : BaseViewController

@property (nonatomic,strong) NSString *group_id;
@property (nonatomic, strong)NSDictionary * dictionary;
@property (nonatomic, assign)BOOL isFromGroupApply;
@property (nonatomic, copy)void (^rejectPass)();

@end
