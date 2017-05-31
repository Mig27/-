//
//  WPAfterChooseUserView.m
//  WP
//
//  Created by CBCCBC on 15/11/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPAfterChooseUserView.h"

#import "SPItemView.h"

@implementation WPAfterChooseUserView

- (void)reloadData{
    
}

- (void)initWithSubView{
        UIScrollView *afterChooseUserInterview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self addSubview:afterChooseUserInterview];
        //选择求职者
        UIView *chooseUserView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, ItemViewHeight)];
        chooseUserView.backgroundColor = [UIColor whiteColor];
        [afterChooseUserInterview addSubview:chooseUserView];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, ItemViewHeight)];
        label.text = @"请选择求职者";
        label.font = kFONT(15);
        [chooseUserView addSubview:label];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120, 0, SCREEN_WIDTH-120-26, ItemViewHeight);
        button.titleLabel.font = kFONT(12);
        button.tag = 11;
        [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [button addTarget:self action:@selector(chooseUserClick) forControlEvents:UIControlEventTouchUpInside];
        [chooseUserView addSubview:button];

        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(button.right, 0, SCREEN_WIDTH-button.right, 48);
//        [button1 addTarget:self action:@selector(chooseUserClick) forControlEvents:UIControlEventTouchUpInside];
        [chooseUserView addSubview:button1];

        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        imageV.frame = CGRectMake(chooseUserView.width-10-8, chooseUserView.height/2-7, 8,14);
        [chooseUserView addSubview:imageV];

        UIView *userInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, chooseUserView.bottom+10, SCREEN_WIDTH, 80)];
        [afterChooseUserInterview addSubview:userInfoView];

        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        headImageView.image = [UIImage imageNamed:@"head_default"];
        [userInfoView addSubview:headImageView];

        NSArray *titleArr = @[@"期望职位:",
                              @"期望薪资:",
                              @"期望福利:",
                              @"期望地区:"];
        NSArray *placeArr = @[@"请选择期望职位",
                              @"请选择期望薪资",
                              @"请选择期望福利",
                              @"请选择期望地区"];
        NSArray *typeArr = @[kCellTypeButton,
                             kCellTypeButton,
                             kCellTypeButton,
                             kCellTypeButton];
        for (int i = 0; i < titleArr.count; i++) {
            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+i*10, SCREEN_WIDTH, ItemViewHeight)];
            [view setTitle:titleArr[i] placeholder:placeArr[i] style:typeArr[i]];
            [afterChooseUserInterview addSubview:view];
            view.tag = i;
            view.SPItemBlock = ^(NSInteger tag){
//                [afterChooseUserInterview buttonItem:tag];
            };
            view.hideFromFont = ^(NSInteger tag, NSString *title){
//                weakSelf.model.name = title;
            };
        }
}

@end
