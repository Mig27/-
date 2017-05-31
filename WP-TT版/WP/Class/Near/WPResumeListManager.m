//
//  WPResumeListManager.m
//  WP
//
//  Created by CBCCBC on 16/4/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeListManager.h"
#import "WPResumeUserListModel.h"
#import "WPResumeUserInfoModel.h"

#define INVITEJOB @"/ios/invitejob.ashx"
#define RESUME_NEW @"/ios/resume_new.ashx"

@implementation WPResumeListManager

singleton_implementation(WPResumeListManager);

- (void)delegateAction
{
    
}

- (void)requestForResumeuserList:(void (^)(NSArray *))Successblock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetJobResumeList",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password
            /*为空 进*/                 /*为0 进*/                                  }];
    if (!self.resumeUserIds || self.resumeUserIds.length != 0) {
        [params setObject:@"" forKey:@"resume_user_id"];
    }else{
        [params setObject:self.resumeUserIds forKey:@"resume_user_id"];
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:INVITEJOB];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        WPResumeUserInfoListModel *models = [WPResumeUserInfoListModel mj_objectWithKeyValues:json];
//        self.modelArray = models.list;
        Successblock(models.resumeList);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 请求选择的数据
- (void)requestForResumeList:(void (^)(NSArray *))Successblock
{
    NSString *str = [IPADDRESS stringByAppendingString:RESUME_NEW];
    
    WPShareModel *model = [WPShareModel sharedModel];
    
    NSDictionary *params = @{@"action":@"GetMyResumeUser",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"]};
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            WPResumeUserInfoListModel *models = [WPResumeUserInfoListModel mj_objectWithKeyValues:json];
            Successblock(models.resumeList);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

@end
