//
//  WPInfoManager.m
//  WP
//
//  Created by CBCCBC on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPInfoManager.h"
#import "WPInfoController.h"

@implementation WPInfoManager

singleton_implementation(WPInfoManager)

-(void)requestForWPInFo
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *dic = @{@"action":@"GetUserInfo",@"username":model.username,@"password":model.password,@"user_id":model.userId};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        self.model = [WPInfoModel mj_objectWithKeyValues:json];
        if (json) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * user_id = json[@"user_id"];
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@{user_id:json} forKey:@"personalDetailInfo"];
                    [self.delegate reloadData];//进入主线程让代理对象执行代理方法
                });
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"personalDetailInfo"];
        NSDictionary * dictionary = dic[model.userId];
        if (dictionary) {
            self.model = [WPInfoModel mj_objectWithKeyValues:dictionary];
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate reloadData];//进入主线程让代理对象执行代理方法
                });
            }
        }
       // self.model = [WPInfoModel mj_objectWithKeyValues:dic];
       // if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
       //     dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.delegate reloadData];//进入主线程让代理对象执行代理方法
         //   });
        //}
    }];
}

@end
