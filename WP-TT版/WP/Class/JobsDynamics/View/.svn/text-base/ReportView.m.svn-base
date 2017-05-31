//
//  ReportView.m
//  WP
//
//  Created by 沈亮亮 on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ReportView.h"

@interface ReportView ()

@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *titles;

@end

@implementation ReportView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(235, 235, 235);
        _images = [NSMutableArray array];
        _titles = [[NSMutableArray alloc] initWithArray:items];
        for (int i =0; i<items.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, ItemHeightAndLine*i,SCREEN_WIDTH, ItemHeight)];
            back.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(10, ItemHeightAndLine*i, SCREEN_WIDTH - 10, ItemHeight);
            [button setTitle:items[i] forState:UIControlStateNormal];
            button.tag = 10 + i;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleLabel.font = kFONT(15);
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:back];
            [self addSubview:button];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(button.width - 31, ItemHeight/2 - 11.5, 21, 21)];
            imageV.image = [UIImage imageNamed:@"是匿名"];
            [_images addObject:imageV];
            [button addSubview:imageV];
            
//            if (i == 0) {
//                imageV.hidden = NO;
//            } else {
                imageV.hidden = YES;
//            }
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    for (int i = 0; i<_images.count; i++) {
        UIImageView *icon = _images[i];
        if (i == index) {
            icon.hidden = NO;
        } else {
            icon.hidden = YES;
        }
    }
    if (self.selectItem) {
        self.selectItem(_titles[index]);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
