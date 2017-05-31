//
//  WPCompanysModel.h
//  WP
//
//  Created by CBCCBC on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
@class CompanyModel;
@interface WPCompanysModel : BaseModel
@property (nonatomic ,strong)NSArray <CompanyModel *>*companyList;
@end

@interface CompanyModel : NSObject
@property (nonatomic,assign )BOOL selected;
@property (nonatomic ,strong)NSString *ep_id;
@property (nonatomic ,strong)NSString *enterprise_name;
@property (nonatomic ,strong)NSString *QR_code;
@property (nonatomic ,strong)NSString *dataIndustry;
@property (nonatomic ,strong)NSString *enterprise_properties;
@property (nonatomic ,strong)NSString *enterprise_scale;
@end
