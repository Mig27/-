//
//  WPRefreshManager.h
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPSetRefreshModel.h"

@protocol WPRefreshManagerDelegate <NSObject>
@optional
- (void)reloadData;
- (void)cleanAction;
@end
@interface WPRefreshManager : NSObject
@property (nonatomic ,strong)id<WPRefreshManagerDelegate>delegate;
@property (nonatomic ,strong)NSMutableArray *modelArr;     // model数组
@property (nonatomic, strong)WPSetRefreshModel *setModel;  // 刷新状态model
//@property (nonatomic, strong)WPSetRefreshModel *autoModel; // 自动刷新model
@property (nonatomic ,strong)WPSetRefreshModel *countModel;// 排名等信息model

@property (nonatomic ,strong)NSString *job_id;

@property (nonatomic, strong)NSString *type;

singleton_interface(WPRefreshManager);

- (void)requestForRefreshList;          // 获取刷新列表

- (void)requestForRefreshCount;         // 获取刷新状态

- (void)requestForRefreshParam;         // 获取刷新设置

- (void)requestForAutoRefreshsuccess:(void (^)(id json))success;          // 开启自动刷新

- (void)requestForStopRefreshsuccess:(void (^)(id json))success;          // 取消自动刷新

- (void)requestForClearReFreshList;     // 清空刷新列表

- (void)requestForReFreshsuccess:(void (^)(id json))success;              // 手动刷新










@end
