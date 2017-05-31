//
//  CollectTypeModel.h
//  WP
//
//  Created by 沈亮亮 on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface CollectTypeModel : BaseModel
@property (nonatomic ,assign)BOOL selected;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *type_id;

@end

@interface CollectTypeListModel : BaseModel

@property (nonatomic, copy) NSArray *list;

@end