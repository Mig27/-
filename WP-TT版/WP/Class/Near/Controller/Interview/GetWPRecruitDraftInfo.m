//
//  GetWPRecruitDraftInfo.m
//  WP
//
//  Created by CBCCBC on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//  获取  企业信息  企业招聘信息

#import "GetWPRecruitDraftInfo.h"
#import "WPHttpTool.h"

@implementation GetWPRecruitDraftInfo

+ (instancetype)sharemanager
{
    static GetWPRecruitDraftInfo *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GetWPRecruitDraftInfo alloc]init];
    });
    return manager;
}

- (void)acquireDataWithRecruit_id:(NSString *)recruit_id
{
    if (self.recruits[recruit_id]) {
        return;
    }
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetRecruitDetail",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"job_id":recruit_id};
    
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        WPRecruitDraftInfoRemarkModel *model = [WPRecruitDraftInfoRemarkModel objectWithKeyValues:json];
        [self.recruits setObject:model forKey:recruit_id];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (WPRecruitDraftInfoRemarkModel *)ModelOfKey:(NSString *)key
{
    return self.recruits[key];
}

- (NSMutableDictionary *)recruits
{
    if (!_recruits) {
        self.recruits = [NSMutableDictionary dictionary];
    }
    return _recruits;
}

@end
