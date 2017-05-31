//
//  WPHotCompanyModel.h
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface WPHotCompanyModel : BaseModel

@property (strong, nonatomic) NSArray *list;

@end

@interface WPHotCompanyListModel : BaseModel

@property (copy ,nonatomic) NSString *company_name;
@property (copy ,nonatomic) NSString *sid;
@property (copy ,nonatomic) NSString *logo;
@property (copy ,nonatomic) NSString *userId;

@end