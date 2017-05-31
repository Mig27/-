//
//  chatNotiModel.h
//  WP
//
//  Created by CC on 16/9/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"
@interface chatNotiListModel : BaseModel
@property (nonatomic, copy)NSString * messageId;
@property (nonatomic, copy)NSString * group_id;
@property (nonatomic, copy)NSString * group_name;
@property (nonatomic, copy)NSString * user_id;
@property (nonatomic, copy)NSString * user_name;
@property (nonatomic, copy)NSString * nick_name;
@property (nonatomic, copy)NSString * post_remark;
@property (nonatomic, copy)NSString * add_time;
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * avatar;
@property (nonatomic, strong)NSArray* List;
@property (nonatomic, assign)BOOL itemSelec;
@end

@interface chatNotiModel : BaseModel
@property (nonatomic, strong)NSArray * List;
@end
