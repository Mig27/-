//
//  WPPhoneBookFriendCategoryModel.h
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPPhoneBookFriendCategoryModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *typename;
@property (nonatomic ,assign)BOOL selected;

@end
