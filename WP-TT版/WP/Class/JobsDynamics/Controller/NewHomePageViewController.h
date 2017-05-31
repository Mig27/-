//
//  NewHomePageViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/3/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPTitleView.h"
@interface NewHomePageViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, assign) BOOL isComeFromDynamic;
@property (nonatomic, strong) WPTitleView*titleView;
@end
 
