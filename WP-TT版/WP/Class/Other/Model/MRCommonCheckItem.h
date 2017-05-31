//
//  IWCommonCheckItem.h
//  MR博客
//
//  Created by teacher on 14-6-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MRCommonItem.h"

@interface MRCommonCheckItem : MRCommonItem
/** 标记这个item是否要打钩 */
@property (nonatomic, assign, getter = isChecked) BOOL checked;
@end
