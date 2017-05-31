//
//  FriendManager.h
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FriendManagerDelegate <NSObject>
@optional
- (void)reloadData;
@end

@interface FriendManager : NSObject
@property (nonatomic ,weak)id<FriendManagerDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *listArr;
@property (nonatomic ,strong)NSMutableDictionary *list;
singleton_interface(FriendManager)

- (void)requestWithAction:(NSString *)action;

@end
