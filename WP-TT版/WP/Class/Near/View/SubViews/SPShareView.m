//
//  SPShareView.m
//  WP
//
//  Created by CBCCBC on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPShareView.h"

#import "OpenViewController.h"


#define sShareTag 30

@interface SPShareView ()
{
    
}


@end

@implementation SPShareView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAllowEdit = YES;
        [self initWithSubviews];
    }
    return self;
}

-(NSMutableArray *)buttonsArr
{
    if (!_buttonsArr) {
        _buttonsArr = [[NSMutableArray alloc]init];
    }
    return _buttonsArr;
}

//-(NSMutableArray *)selectedArr
//{
//    if (!_selectedArr) {
//        _selectedArr = [[NSMutableArray alloc]init];
//    }
//    return _selectedArr;
//}

- (void)setSelectedArr:(NSArray *)selectedArr{
    _selectedArr = [[NSArray alloc]initWithArray:selectedArr];
    for (int i = 0; i < _selectedArr.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+sShareTag];
        UIButton *button1 = self.selectedArr[i];
        button.selected = button1.selected;
//        button.enabled = _isAllowEdit;
    }
}

-(void)initWithSubviews
{
    // 公开
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
    view1.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(12), kHEIGHT(43)/2-7, 14, 14)];
    icon1.image = [UIImage imageNamed:@"share_open"];
    [view1 addSubview:icon1];
    
    // title
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(icon1.right + 10, (kHEIGHT(43)-20)/2, 100, 20)];
    label1.text = @"公开";
    label1.font = kFONT(15);
    [view1 addSubview:label1];
    
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 8,(kHEIGHT(43)-14)/2, 8, 14)];
    imgView1.image = [UIImage imageNamed:@"jinru"];
    [view1 addSubview:imgView1];
    
    // subTitle
    _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(imgView1.left - 10 - 150, (kHEIGHT(43)-20)/2, 150, 20)];
    _subTitle.textAlignment = NSTextAlignmentRight;
    _subTitle.text = @"所有人可见";
    _subTitle.font = kFONT(12);
    _subTitle.textColor = [UIColor grayColor];
    [view1 addSubview:_subTitle];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = view1.frame;
    
    [btn setTarget:self action:@selector(publicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:btn];
    [self addSubview:view1];
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self addSubview:line];
    
    // 分享到
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom, SCREEN_WIDTH, 43)];
    view2.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43/2-7, 14, 14)];
    icon3.image = [UIImage imageNamed:@"publish"];
    [view2 addSubview:icon3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(icon3.right + 10, 11.5, 100, 20)];
    label3.text = @"分享到";
    label3.font = kFONT(15);
    [view2 addSubview:label3];
    
    NSArray *unSelectImg = @[@"weixin",@"friend",@"qq",@"qzone",@"sina"];
    NSArray *selectImg = @[@"weixin_select",@"friend_select",@"qq_select",@"qzone_select",@"sina_select"];
    
    CGFloat x1 = SCREEN_WIDTH - 144;
    CGFloat y1 = 11.5;
    CGFloat width1 = 22;
    
    for (int i = 0; i < unSelectImg.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x1 + i%5*(width1 + 6), y1 + i/5*(width1 + 6), width1, width1);
        [btn setImage:[UIImage imageNamed:unSelectImg[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImg[i]] forState:UIControlStateSelected];
        btn.tag = i + sShareTag;
        btn.selected = NO;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArr addObject:btn];
        [view2 addSubview:btn];
    }
    
//    [self addSubview:view2];
}

- (void)shareBtnClick:(UIButton *)sender
{
    UIButton *button = self.buttonsArr[sender.tag - sShareTag];
//    if (button.isSelected) {
//        button.selected = NO;
//    } else {
//        button.selected = YES;
//    }
    button.selected = !button.isSelected;
}

- (void)setIsAllowEdit:(BOOL)isAllowEdit{
    _isAllowEdit = isAllowEdit;
    self.userInteractionEnabled = _isAllowEdit;
}

-(void)deleteAllButtons 
{
    for (int i = 0; i < 5; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:30+i];
        [button setSelected:NO];
    }
}

// 公开按钮
- (void)publicBtnClick:(UIButton *)sender
{
    NSLog(@"publicBtnClick");
    
    if (self.publicAction) {
        self.publicAction();
    }
    
    
}
@end
