//
//  WPGetFriendCategoryListResult.h
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPhoneBookFriendCategoryModel.h"

@interface WPGetFriendCategoryListResult : NSObject

@property (nonatomic, strong) NSArray *list;    /**< 好友类别 */
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *status;

@end
