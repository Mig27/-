//
//  WPCompanyManager.h
//  WP
//
//  Created by CBCCBC on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPCompanysModel.h"
#import "WPCompanyListModel.h"

@protocol WPCompanyManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end
@interface WPCompanyManager : NSObject
@property (nonatomic ,strong)WPCompanyListModel *model;
@property (nonatomic ,strong)NSMutableArray *modelArr;
@property (nonatomic ,strong)id<WPCompanyManagerDelegate>delegate;

singleton_interface(WPCompanyManager);

- (void)requstCompanyList;

- (void)removeCompanyWithIDs:(NSString *)ids success:(void(^)(id json))success;

- (void)requestCompanyWithEp_id:(NSString *)ep_id;



@end
