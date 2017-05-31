//
//  GetWPCompanyList.h
//  WP
//
//  Created by CBCCBC on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPCompanyListModel.h"

@interface GetWPCompanyList : NSObject

@property(nonatomic , strong)NSMutableDictionary *companyList;

+ (instancetype)sharemanager;

- (void)acquireDataWithEp_id:(NSString *)ep_id;

- (WPCompanyListModel *)ModelOfKey:(NSString *)key;



@end
