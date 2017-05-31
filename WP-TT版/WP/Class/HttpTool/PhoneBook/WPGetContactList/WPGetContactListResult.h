//
//  WPGetContactListResult.h
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPhoneBookContactModel.h"

@interface WPGetContactListResult : NSObject

@property (nonatomic, strong) NSArray *list;    /**< 好友类别 */
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *status;

@end
