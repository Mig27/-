//
//  AnonymousManager.m
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "AnonymousManager.h"
#define kPersonal_info @"/ios/personal_info.ashx"

@implementation AnonymousManager

singleton_implementation(AnonymousManager)

- (void)getAnonymityList
{
    NSString *url = [IPADDRESS stringByAppendingString:kPersonal_info];
    NSDictionary *params = @{@"action":@"GetAnonymityList",
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        AnonymousListModel *model = [AnonymousListModel mj_objectWithKeyValues:json];
        if (json) {
            self.anonyList = model.list;
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate reloadData];//进入主线程让代理对象执行代理方法
                });
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getAnonymityInfo
{
    NSString *url = [IPADDRESS stringByAppendingString:kPersonal_info];
    NSDictionary *params = @{@"action":@"GetAnonymityInfo",
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        AnonymousModel *model = [AnonymousModel mj_objectWithKeyValues:json];
        if (json) {
            self.model = model;
//            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.reload(self.model);//进入主线程让代理对象执行代理方法
                });
//            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setAnonymousModelWithModel:(AnonymousModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:kPersonal_info];
    NSDictionary *params = @{@"action":@"SetAnonymity",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"photo":model.photo,
                             @"name":model.name,
                             @"postionId":model.anonyid,
                             @"postionName":model.postionName};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(backToControllerWithStatus:)]) {
            BOOL status = NO;
            if (![json[@"status"]integerValue]) {
                status = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate backToControllerWithStatus:status];//进入主线程让代理对象执行代理方法
            });
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
