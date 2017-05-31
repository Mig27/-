//
//  AreaView.m
//  WP
//
//  Created by 沈亮亮 on 15/8/27.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "AreaView.h"
#import "WPHttpTool.h"

@interface AreaView ()

@property (nonatomic,strong) UITableView *province;  //省
@property (nonatomic,strong) UITableView *city;      //市
@property (nonatomic,strong) UITableView *area;      //区

@end

@implementation AreaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
//    self.province = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - 104 - 44 - 20)];
//    self.province.delegate = self;
//    self.province.dataSource = self;
//    [self addSubview:self.province];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
