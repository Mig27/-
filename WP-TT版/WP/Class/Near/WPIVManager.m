//
//  WPIVManager.m
//  WP
//
//  Created by CBCCBC on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPIVManager.h"

#define kPersonal @"/ios/personal_info.ashx"

@implementation WPIVManager

singleton_implementation(WPIVManager);

- (void)setFk_type:(NSString *)fk_type
{
    if ([fk_type isEqualToString:@"0"]) {
        _fk_type = @"1";
    }
    if ([fk_type isEqualToString:@"1"]) {
        _fk_type = @"2";
    }
    
    if ([fk_type isEqualToString:@"2"]) {
        _fk_type = @"4";
    }
    if ([fk_type isEqualToString:@"3"]) {
        _fk_type = @"3";
    }
    if ([fk_type isEqualToString:@"5"]) {
        _fk_type = @"5";
    }
}
- (void)requsetForImageAndVideo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"GetImgAndVideo",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"fk_id":_fk_id,
                                                                                  @"fk_type":_fk_type}];
    
    NSString *url = [IPADDRESS stringByAppendingString:kPersonal];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        
        self.model = [WPIVModel mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
        
    }];
}

@end
