//
//  ListView.h
//  WP
//
//  Created by 沈亮亮 on 15/9/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListView : UIScrollView

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,copy) void(^buttonClick)(NSInteger index, NSString *title);

- (void)makeContain;

@end
