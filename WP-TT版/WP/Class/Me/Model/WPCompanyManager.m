//
//  WPCompanyManager.m
//  WP
//
//  Created by CBCCBC on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyManager.h"
#import "MTTDatabaseUtil.h"
@implementation WPCompanyManager

singleton_implementation(WPCompanyManager);

- (void)requstCompanyList
{
    
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetMyCompany",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        WPCompanysModel *model = [WPCompanysModel mj_objectWithKeyValues:json];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:model.companyList];
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate reloadData];
            });
        }
        if (model.companyList.count) {
            [[MTTDatabaseUtil instance] deleteMyCompoanyInfo];
            [[MTTDatabaseUtil instance] upDateMyCompanyInfo:json[@"companyList"]];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [[MTTDatabaseUtil instance] getMyComoanyInfo:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"companyList":array};
                WPCompanysModel *model = [WPCompanysModel mj_objectWithKeyValues:dic];
                [self.modelArr removeAllObjects];
                [self.modelArr addObjectsFromArray:model.companyList];
                if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate reloadData];
                    });
                }
            }
        }];
        
    }];
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)removeCompanyWithIDs:(NSString *)ids success:(void (^)(id))success
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"BatchDeleteCompany",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"ep_id":ids};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestCompanyWithEp_id:(NSString *)ep_id
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetCompanyInfo",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"ep_id":ep_id};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        WPCompanyListModel *model = [WPCompanyListModel mj_objectWithKeyValues:json];
        self.model = model;
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate reloadData];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}





@end
