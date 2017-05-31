//
//  WPHotCompanyPositionManager.h
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPositionListModel.h"

@protocol WPHotCompanyPositionManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end
@interface WPHotCompanyPositionManager : NSObject
@property (nonatomic ,strong)id<WPHotCompanyPositionManagerDelegate>delegate;

@property (nonatomic ,strong)NSMutableArray *modelArr;

singleton_interface(WPHotCompanyPositionManager)

- (void)requestPositionForCompanyWithEp_id:(NSString *)ep_id;

@end
