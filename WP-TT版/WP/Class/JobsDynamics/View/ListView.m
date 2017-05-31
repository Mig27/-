//
//  ListView.m
//  WP
//
//  Created by 沈亮亮 on 15/9/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "ListView.h"
#import "ListButton.h"

#define LISTHEIGHT 80

@interface ListView ()

@property (nonatomic,strong) NSMutableArray *buttons;

@end

@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"创建");
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.borderWidth = 0.5;
        self.showsHorizontalScrollIndicator = NO;
        self.buttons = [NSMutableArray array];

    }
    
    return self;
}

- (void)makeContain
{
    self.contentSize = CGSizeMake(56*self.titles.count + 16*(self.titles.count - 1), LISTHEIGHT);
    CGFloat x = (56+16)*self.selectIndex + 56;
    if (x > SCREEN_WIDTH) {
        CGFloat content_x = x - SCREEN_WIDTH;
        NSLog(@"x:%f, \n content_x:%f, \n real_x%f",x,content_x,self.contentOffset.x);
        if (self.contentOffset.x < content_x) {
            [UIView animateWithDuration:0.5 animations:^{
                self.contentOffset = CGPointMake(content_x, 0);
            }];
        }
    }
    CGFloat width = SCREEN_WIDTH/5;
    for (int i = 0; i < self.titles.count; i++) {
        //        NSLog(@"%@",self.titles[i]);
//        ListButton *button = [[ListButton alloc] initWithFrame:CGRectMake((56+16)*i, 0, 56, LISTHEIGHT) title:self.titles[i] icon:self.images[i]];
        ListButton *button = [[ListButton alloc] initWithFrame:CGRectMake(width*i, 0, width, LISTHEIGHT) title:self.titles[i] icon:self.images[i]];
//        if (i == self.selectIndex) {
//            button.titleLabel.textColor = [UIColor redColor];
//        }
        [_buttons addObject:button];
        button.userInteractionEnabled = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((56+16)*i, 0, 56, LISTHEIGHT);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(buttonClickWith:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self addSubview:btn];
    }
}

- (void)buttonClickWith:(UIButton *)sender
{
    NSInteger index = sender.tag - 1;
    for (int i = 0; i<self.titles.count; i ++ ) {
//        ListButton *button = _buttons[i];
//        if (i == index) {
//            button.titleLabel.textColor = [UIColor redColor];
//        } else {
//            button.titleLabel.textColor = [UIColor blackColor];
//        }
    }
    
    if (self.buttonClick) {
        self.buttonClick(index,self.titles[index]);
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
