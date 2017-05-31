//
//  WPHotIndustryModel.h
//  WP
//
//  Created by CBCCBC on 16/3/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface WPHotIndustryModel : BaseModel
@property (nonatomic , strong)NSArray *list;
@end
@interface WPHotIndustryListModel : BaseModel
@property (nonatomic , strong)NSString *sid;
@property (nonatomic , strong)NSString *industryID;
@property (nonatomic , strong)NSString *fatherID;
@property (nonatomic , strong)NSString *industryName;
@property (nonatomic , strong)NSString *layer;
@property (nonatomic , strong)NSString *recommend;
@property (nonatomic , strong)NSString *address;
@property (nonatomic , strong)NSString *hotCount;
@property (nonatomic , strong)NSString *rowNumber;
@end