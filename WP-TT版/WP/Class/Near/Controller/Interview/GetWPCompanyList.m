//
//  GetWPCompanyList.m
//  WP
//
//  Created by CBCCBC on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//  获取 公司信息

#import "GetWPCompanyList.h"

@implementation GetWPCompanyList

+ (instancetype)sharemanager
{
    static GetWPCompanyList *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GetWPCompanyList alloc]init];
    });
    return manager;
}

- (void)acquireDataWithEp_id:(NSString *)ep_id
{
    if (self.companyList[ep_id]) {
        return;
    }
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetRecruitDetail",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"job_id":ep_id};
    
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        WPCompanyListModel *model = [WPCompanyListModel objectWithKeyValues:json];
        [self.companyList setObject:model forKey:ep_id];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (WPCompanyListModel *)ModelOfKey:(NSString *)key
{
    return self.companyList[key];
}

- (NSMutableDictionary *)companyList
{
    if (!_companyList) {
        self.companyList = [NSMutableDictionary dictionary];
    }
    return _companyList;
}

@end
