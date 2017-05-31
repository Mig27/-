//
//  WPMoreInfoView.m
//  WP
//
//  Created by CBCCBC on 16/3/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMoreInfoView.h"
#import "SPItemView.h"

#import "WPRecruitApplyView.h"

@implementation WPMoreInfoView

- (instancetype)initWithTop:(CGFloat)top
{
    if ([super init]) {
        NSArray *title = @[@"目前薪资:",@"婚姻状况:",@"微       信:",@"Q       Q:",@"邮       箱:"];
        NSArray *placeholder = @[@"请选择目前薪资",@"请选择婚姻状况",@"请输入微信",@"请输入QQ",@"请输入邮箱"];
        NSArray *type = @[kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeText];
        CGFloat height = 0;
        for (int i = 0; i < title.count; i++) {
            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*kHEIGHT(43), SCREEN_WIDTH, ItemViewHeight)];
            [view setTitle:title[i] placeholder:placeholder[i] style:type[i]];
            view.tag = WPRecruitApplyViewActionTypeNowSalary+i;
            [self addSubview:view];
            if (i == title.count-1) {
                height = i*kHEIGHT(43)+ItemViewHeight;
            }
        }
        self.frame = CGRectMake(0, top, SCREEN_WIDTH, height);
    }
    return self;
}

- (CGFloat)leftCorner
{
    if (!_leftCorner) {
        self.leftCorner = self.frame.origin.y + self.frame.size.height;
    }
    return _leftCorner;
}

@end
