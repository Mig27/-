//
//  WPFriendValidateView.m
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPFriendValidateView.h"

@interface WPFriendValidateView()

@end

@implementation WPFriendValidateView

+(UIView *)createValiadateView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(kHEIGHT(78)));
    }];
    
    
    //textView
    UITextView *textview = [[UITextView alloc] init];
    [view addSubview:textview];
    textview.text = @"我是XX";
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //字数label  限制28个字  往下减
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"28";
    countLabel.font = [UIFont systemFontOfSize:kHEIGHT(15)];
    countLabel.textColor = RGB(127, 127, 127);
    [view addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(kHEIGHT(10));
        make.bottom.equalTo(view.mas_bottom).with.offset(kHEIGHT(-10));
    }];
    
    
    return view;
    
}


@end
