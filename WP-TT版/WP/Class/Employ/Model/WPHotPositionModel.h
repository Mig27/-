//
//  WPHotPositionModel.h
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface WPHotPositionModel : BaseModel

@property (strong, nonatomic) NSArray *list;

@end

@interface WPHotPositionListModel : BaseModel

@property (copy, nonatomic) NSString *iconAddress;
@property (copy, nonatomic) NSString *fatherID;
@property (copy, nonatomic) NSString *industryID;
@property (copy, nonatomic) NSString *industryName;
@property (copy, nonatomic) NSString *layer;
@property (copy, nonatomic) NSString *positionID;
@property (copy, nonatomic) NSString *positionName;
@property (copy, nonatomic) NSString *recommend;
@property (copy, nonatomic) NSString *sid;

@end
