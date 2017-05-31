//
//  LinkManViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/12/22.
//  Copyright © 2015年 WP. All rights reserved.
//  消息 --> 通讯录

#import "BaseViewController.h"

typedef void (^RequiredSuccessBlock)(NSMutableArray *datas);
typedef void (^RequiredErrorBlock)(NSError *error);

@interface LinkManViewController : BaseViewController
@property (nonatomic, copy)NSString*tranmitStr;
@property (nonatomic, copy)NSString*display_type;
@end
