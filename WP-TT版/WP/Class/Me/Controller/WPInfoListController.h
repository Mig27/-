//
//  WPInfoListController.h
//  WP
//
//  Created by CBCCBC on 16/3/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"

@interface WPInfoListController : BaseViewController
@property (nonatomic ,assign)BOOL isResume;
@property (nonatomic ,strong)NSString *Id;
@property (nonatomic, assign)int isRecurit;
@property (nonatomic, copy) void(^clickCompany)();
@end
