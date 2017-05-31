//
//  FrienDListModel.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "FrienDListModel.h"

@implementation FrienDListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WPFriendModel class]};
}
@end

@implementation WPFriendModel

- (BOOL)selected
{
    if (!_selected) {
        self.selected = NO;
    }
    return _selected;
}

@end
