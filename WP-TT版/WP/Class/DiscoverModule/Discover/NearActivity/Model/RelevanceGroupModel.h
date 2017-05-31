//
//  RelevanceGroupModel.h
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface RelevanceGroupListModel : BaseModel

@property(nonatomic,copy) NSString *sid;
@property(nonatomic,copy) NSString *group_icon;
@property(nonatomic,copy) NSString *group_name;
@property(nonatomic,copy) NSString *GroupUserSum;
@property(nonatomic,copy) NSString *group_cont;


@end

@interface RelevanceGroupModel : BaseModel

@property (nonatomic,strong) NSArray *list;

@end
