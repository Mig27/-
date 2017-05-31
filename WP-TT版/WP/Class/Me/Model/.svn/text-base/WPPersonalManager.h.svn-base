//
//  WPPersonalManager.h
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPersonListModel.h"
@protocol WPPersonalManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end
@class WPResumeUserInfoModel;
@interface WPPersonalManager : NSObject
@property (nonatomic , strong)WPResumeUserInfoModel *model;
@property (nonatomic ,strong)NSMutableArray *modelArr;
@property (nonatomic ,strong)id<WPPersonalManagerDelegate>delegate;

singleton_interface(WPPersonalManager)

- (void)requstPersonInfoList;

- (void)removePersonInfoWithIDs:(NSString *)ids success:(void(^)(id json))success;

- (void)requestPersonInfoWithResumeUserId:(NSString *)ResumeUserId;

@end
