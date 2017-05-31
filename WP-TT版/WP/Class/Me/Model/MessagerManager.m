//
//  MessagerManager.m
//  WP
//
//  Created by CBCCBC on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "MessagerManager.h"


@implementation MessagerManager

singleton_implementation(MessagerManager)

- (void)requestMessagerSetting
{
    NSDictionary *params = @{@"action":@"GetMsgSetting",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,};
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        self.model = [MessagerModel mj_objectWithKeyValues:json];
        if (json) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate reloadData];
//                });
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)updateMessagerSetting
{
    NSDictionary *params = @{@"action":@"UpdateMsgSetting",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"voice":self.model.voice,
                             @"shock":self.model.shock,
                             @"deplayMsgContent":self.model.deplayMsgContent,
                             @"noReadMgsAlert":self.model.noReadMgsAlert};
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"status"] integerValue]) {
            [self updateMessagerSetting];
        }
    } failure:^(NSError *error) {
    }];
    
}

@end
