//
//  PlusCollectionFooterView.m
//  WP
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "PlusCollectionFooterView.h"

@interface PlusCollectionFooterView()

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation PlusCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加头(尾)视图中的控件
        self.pageControl=[[UIPageControl alloc]init];
        [self.pageControl setCurrentPage:0];
        self.pageControl.pageIndicatorTintColor=RGB(178, 178, 178);
        self.pageControl.currentPageIndicatorTintColor=RGB(127, 127, 127);
        self.pageControl.numberOfPages = 2;
        [self.pageControl setBackgroundColor:[UIColor clearColor]];
//        [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.equalTo(@30);
        }];
    }
    return self;
}




@end
