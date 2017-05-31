//
//  TopicViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/2/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "DynamicTopicTypeModel.h"

@interface TopicViewController : BaseViewController


@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) void (^topicDidselectBlock)(DynamicTopicTypeModel *model,NSIndexPath *clickIndex);

@end
