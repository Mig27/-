//
//  WPPhoneBookGroupModel.h
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPPhoneBookGroupModel : NSObject

@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *g_id;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, strong) id group_icon;
@property (nonatomic, strong)NSArray *  user_lest;
@end
