//
//  WPRefreshManager.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRefreshManager.h"

@implementation WPRefreshManager

singleton_implementation(WPRefreshManager);

- (void)requestForRefreshList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetRefreshList",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"job_id":self.job_id,
                                                                                  @"type":self.type}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/refresh.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        WPSetRefreshListModel *model = [WPSetRefreshListModel mj_objectWithKeyValues:json];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:model.list];
        if (json) {
            [self delegateAction];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return  _modelArr;
}

- (void)requestForRefreshParam
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetRefreshParam",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"job_id":self.job_id,
                                                                                  @"type":self.type}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/refresh.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        WPSetRefreshListModel *model = [WPSetRefreshListModel mj_objectWithKeyValues:json];
        self.setModel = model.list[0];
        if (json) {
            [self delegateAction];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)delegateAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate reloadData];
        });
    }
}

- (void)requestForRefreshCount
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetRefreshCount",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"job_id":self.job_id,
                                                                                  @"type":self.type}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/refresh.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        WPSetRefreshListModel *model = [WPSetRefreshListModel mj_objectWithKeyValues:json];
        self.countModel = model.list[0];
        if (json) {
            [self delegateAction];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestForAutoRefreshsuccess:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"AddRefresh",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"job_id":self.job_id,
                                                                                  @"type":self.type,
                                                                                  @"begin_time":self.setModel.begin_time,
                                                                                  @"end_time":self.setModel.end_time,
                                                                                  @"r_time":self.setModel.r_time,
                                                                                  @"state":@"0"}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/refresh.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestForStopRefreshsuccess:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"UpdateState",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"job_id":self.job_id,
                                                                                  @"type":self.type,
                                                                                  @"state":@"1"}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/refresh.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestForClearReFreshList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"ClearReFreshList",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"job_id":self.job_id,
                                                                                  @"type":self.type}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/refresh.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cleanAction)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate cleanAction];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestForReFreshsuccess:(void (^)(id))success
{
    NSString *action;
    NSString *jod_id;
    if ([self.type isEqualToString:@"2"]) { // 求职
        action = @"RefreshJobRelease";
        jod_id = @"resume_id";
    }else{   // 招聘
        action = @"RefreshRecruit";
        jod_id = @"recruit_id";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":action,
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  jod_id:self.job_id,
                                                                                  @"refresh_type":@"1"}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        
    }];
}

@end
