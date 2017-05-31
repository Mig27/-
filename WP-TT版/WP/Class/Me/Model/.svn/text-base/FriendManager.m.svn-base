//
//  FriendManager.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "FriendManager.h"
#import "FrienDListModel.h"
#import "NSString+Characters.h"

#define IOSREQUESETADDRESS @"/ios/friend.ashx"
//#define URLSTR [IPADDRESS stringByAppendingString:IOSREQUESETADDRESS]
@implementation FriendManager

singleton_implementation(FriendManager)

- (void)requestWithAction:(NSString *)action
{
    NSDictionary *params = @{@"action":action,
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password};
    NSString *url = [IPADDRESS stringByAppendingString:IOSREQUESETADDRESS];
    NSLog(@"%@",action);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        FrienDListModel *model = [FrienDListModel mj_objectWithKeyValues:json];
        [self.list removeAllObjects];
        [self sortForFriendNameWithModel:model];
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate reloadData];//进入主线程让代理对象执行代理方法
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)sortForFriendNameWithModel:(FrienDListModel *)frienListModel
{
    for (WPFriendModel *model in frienListModel.list) {
        NSArray *arr = [self.list allKeys];
        // 这里是将不是拼音开头单独出来 用#
        NSString *string = [model.nick_name firstCharacterOfName];
        if ([arr containsObject:string]) {
            NSMutableArray *array = self.list[string];
            [array addObject:model];
            [self.list setObject:array forKey:string];
        }else{
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:model];
            [self.list setObject:array forKey:string];
        }
    }
}

- (NSMutableDictionary *)list
{
    if (!_list) {
        self.list = [NSMutableDictionary dictionary];
    }
    return _list;
}


@end
