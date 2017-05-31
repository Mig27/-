//
//  WPEditButton.m
//  WP
//
//  Created by CBCCBC on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPEditButton.h"

@interface WPEditButton ()

@property (nonatomic ,strong)UIButton *edit;
@end

@implementation WPEditButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
            [self addSubview:self.edit];
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [self addSubview:line];
    }
    return self;
}


//编辑
- (void)setEditTarget:(id)editTarget editdAction:(SEL)editdAction
{
    [self.edit addTarget:editTarget action:editdAction forControlEvents:UIControlEventTouchDown];
}
- (UIButton *)edit{
    if (!_edit) {
        self.edit = [UIButton buttonWithType:UIButtonTypeCustom];
        self.edit.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(20)-30, 0, kHEIGHT(20)+30, 49);
        [self.edit setTitle:@"编辑" forState:UIControlStateNormal];
        self.edit.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10));
        self.edit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.edit.titleLabel.font = kFONT(15);
    }
    return _edit;
}




@end
