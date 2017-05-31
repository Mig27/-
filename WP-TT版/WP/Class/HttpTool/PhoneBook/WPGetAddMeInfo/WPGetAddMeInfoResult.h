//
//  WPGetAddMeInfoResult.h
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPAddMePersonInfoModel.h"
#import "WPToAddListFriendModel.h"

@interface WPGetAddMeInfoResult : NSObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *list;

@end
