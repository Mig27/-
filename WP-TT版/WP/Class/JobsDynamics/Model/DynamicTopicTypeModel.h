//
//  DynamicTopicTypeModel.h
//  WP
//
//  Created by 沈亮亮 on 16/4/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface DynamicTopicTypeModel : BaseModel

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *CoutSum;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *isSelected; /**< 0未选中 1已选中 */

@end


@interface DynamicTopicTypeListModel : BaseModel

@property (nonatomic, copy) NSArray *list;

@end