//
//  WPPersonalManager.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonalManager.h"
#import "WPResumeUserInfoModel.h"
#import "MTTDatabaseUtil.h"
@implementation WPPersonalManager

singleton_implementation(WPPersonalManager)

- (void)requstPersonInfoList
{
    
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetChangeResumeList",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        WPPersonListModel *model = [WPPersonListModel mj_objectWithKeyValues:json];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:model.resumeList];
        [self delegateAction];
        
        if (model.resumeList.count) {
            [[MTTDatabaseUtil instance] deleteAllMyPersonalInfo];
            [[MTTDatabaseUtil instance] upDateMyPersonalInfo:json[@"resumeList"]];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [[MTTDatabaseUtil instance] getMyPersonalInfo:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"resumeList":array};
                WPPersonListModel *model = [WPPersonListModel mj_objectWithKeyValues:dic];
                [self.modelArr removeAllObjects];
                [self.modelArr addObjectsFromArray:model.resumeList];
                [self delegateAction];
            }
        }];
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

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)removePersonInfoWithIDs:(NSString *)ids success:(void (^)(id))success
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"BatchDeleteResumeUser",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"resume_user_id":ids};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestPersonInfoWithResumeUserId:(NSString *)ResumeUserId
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetResumeUserInfo",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"resume_user_id":ResumeUserId};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        WPResumeUserInfoModel *model = [WPResumeUserInfoModel mj_objectWithKeyValues:json];
        self.model = model;
        [self delegateAction];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


@end
