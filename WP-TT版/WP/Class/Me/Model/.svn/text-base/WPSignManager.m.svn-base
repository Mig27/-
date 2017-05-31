//
//  SignManager.m
//  WP
//
//  Created by CBCCBC on 16/3/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSignManager.h"
#import "SignListModel.h"
#define INVITE_JOB_ADDRESS @"/ios/inviteJob.ashx"
#define RESUME_NEW_ADDRESS @"/ios/resume_new.ashx"

@implementation WPSignManager

singleton_implementation(WPSignManager);

- (void)requestWithId:(NSString *)id page:(NSString *)page
{
    
    NSDictionary *dictionary = @{(self.isResume?@"resume_id":@"job_id"):id,@"page":page};
    [self requestWithDictionaty:dictionary];
}

//- (void)requestWithResumeId:(NSString *)resume_id page:(NSString *)page
//{
//    NSDictionary *dictionary = @{@"resume_id":resume_id,@"page":page};
//    [self requestWithDictionaty:dictionary];
//}

- (void)requestWithDictionaty:(NSDictionary *)dictionary
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetSignList",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password}];
    [params setValuesForKeysWithDictionary:dictionary];
    NSString *url = [IPADDRESS stringByAppendingString:self.isResume?RESUME_NEW_ADDRESS:INVITE_JOB_ADDRESS];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        SignListModel *model = [SignListModel mj_objectWithKeyValues:json];
        if (json) {
            [self.signArr removeAllObjects];
            [self.signArr addObjectsFromArray:model.signList];
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                [self.delegate reloadData];
            }
        }
    } failure:^(NSError *error) {
    }];
}
- (NSMutableArray *)signArr
{
    if (!_signArr) {
        self.signArr = [NSMutableArray array];
    }
    return _signArr;
}

@end
