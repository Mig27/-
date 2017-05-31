//
//  LinkGroupModel.h
//  WP
//
//  Created by 沈亮亮 on 15/12/24.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface linkGroupListModel : BaseModel

@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, strong) id group_icon;

@end

@interface LinkGroupModel : BaseModel

@property (nonatomic, strong) NSArray *mycreated;
@property (nonatomic, strong) NSArray *myjoin;

@end
