//
//  IWCommonCheckGroup.m
//  MR博客
//
//  Created by teacher on 14-6-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MRCommonCheckGroup.h"
#import "MRCommonCheckItem.h"

@implementation MRCommonCheckGroup

- (void)setCheckedIndex:(int)checkedIndex
{
    _checkedIndex = checkedIndex;
    
    // 屏蔽外面的乱传参数行为
    int count = (int)self.items.count;
    if (checkedIndex < 0 || checkedIndex >= count) return;
    
    for (int i = 0; i<count; i++) {
        MRCommonCheckItem *item = self.items[i];
        
        if (i == checkedIndex) {
            item.checked = YES;
        } else {
            item.checked = NO;
        }
    }
}

- (void)setItems:(NSArray *)items
{
    [super setItems:items];
    
    self.checkedIndex = self.checkedIndex;
}

@end
