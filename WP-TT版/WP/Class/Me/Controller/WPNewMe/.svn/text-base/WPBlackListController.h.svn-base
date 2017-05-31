//
//  WPBlackListController.h
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
@protocol WPBlackListControllerDelegate <NSObject>

- (void)reloadData;
@end

@interface WPBlackListController : BaseViewController
@property (nonatomic ,weak)id<WPBlackListControllerDelegate>delegate;
@property (nonatomic ,strong)NSString *action;

@property (nonatomic ,strong)NSArray *pushViewData;

@end
