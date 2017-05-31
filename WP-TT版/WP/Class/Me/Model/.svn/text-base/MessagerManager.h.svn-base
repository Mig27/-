//
//  MessagerManager.h
//  WP
//
//  Created by CBCCBC on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagerModel.h"
@protocol MessagerManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end

@interface MessagerManager : NSObject
@property (nonatomic,strong)MessagerModel *model;
@property (nonatomic ,weak)id<MessagerManagerDelegate>delegate;
singleton_interface(MessagerManager)


-(void)requestMessagerSetting;
- (void)updateMessagerSetting;

@end
