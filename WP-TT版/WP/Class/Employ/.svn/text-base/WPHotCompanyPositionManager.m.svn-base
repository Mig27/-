//
//  WPHotCompanyPositionManager.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPHotCompanyPositionManager.h"

@implementation WPHotCompanyPositionManager

singleton_implementation(WPHotCompanyPositionManager)

- (void)requestPositionForCompanyWithEp_id:(NSString *)ep_id
{
    NSDictionary *params = @{@"action":@"GetJobList",
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"ep_id":ep_id};
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        WPPositionListModel *model = [WPPositionListModel mj_objectWithKeyValues:json];
        [self.modelArr removeAllObjects];
        [self.modelArr addObjectsFromArray:model.list];
        if (json) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate reloadData];
                });
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return _modelArr;
}


@end
