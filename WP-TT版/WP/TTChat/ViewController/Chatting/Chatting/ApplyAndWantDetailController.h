//
//  ApplyAndWantDetailController.h
//  WP
//
//  Created by CC on 16/8/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "NearPersonalController.h"
@interface ApplyAndWantDetailController : BaseViewController
@property (nonatomic, copy)NSString*urlStr;
@property (nonatomic, strong)NearPersonalListModel * listModel;
@property (nonatomic, assign)BOOL isApply;
@property (nonatomic, copy)NSString *subId;
@end
