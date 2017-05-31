//
//  WPInfoManager.h
//  WP
//
//  Created by CBCCBC on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPInfoManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end
@class WPInfoModel;
@interface WPInfoManager : NSObject
@property (nonatomic ,weak)id<WPInfoManagerDelegate>delegate;
@property (nonatomic ,strong)WPInfoModel *model;
singleton_interface(WPInfoManager)
-(void)requestForWPInFo;
@end

