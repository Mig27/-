//
//  SPDateView.m
//  WP
//
//  Created by CBCCBC on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPDateView.h"

@interface SPDateView ()


@property (assign, nonatomic) CGFloat top;

@end

@implementation SPDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(248, 248, 248);
        _top = frame.origin.y;
        [self datePickerView];
    }
    return self;
}

- (UIDatePicker *)datePickerView
{
    if (!_datePickerView) {
        
        //创建
        _datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, self.width, 216)];
        
        _datePickerView.datePickerMode=UIDatePickerModeDate;
        //设定最大时间
        _datePickerView.maximumDate=[NSDate date];
        _datePickerView.date = [NSDate date];
        //设置最小时间
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        NSDate*date=[formatter dateFromString:@"1920-01-01"];
        _datePickerView.minimumDate=date;
        _datePickerView.backgroundColor=[UIColor whiteColor];
        //添加事件
        [_datePickerView addTarget:self action:@selector(datePickerClick) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePickerView];
        
//        _dateCompleteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
//        _dateCompleteView.backgroundColor = RGB(221, 221, 221);
//        [self.view addSubview:_dateCompleteView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 44);
        button.titleLabel.font = kFONT(15);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10));
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(160, 160, 160);
        [self addSubview:line];
        
        UILabel * line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = RGB(160, 160, 160);
        [self addSubview:line2];
        
    }
    return _datePickerView;
}

- (void)datePickerClick
{
    //获取时间 按照日期格式进行转换
    NSDateFormatter*formatter=[[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //进行转换
    NSString*str=[formatter stringFromDate:self.datePickerView.date];
    if (self.getDateBlock) {
        self.getDateBlock(str);
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}

- (void)hide
{
    [self datePickerClick];
    
    [self removeFromSuperview];
}

-(void)removeView
{
   [self removeFromSuperview]; 
}
@end
