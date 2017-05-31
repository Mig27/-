//
//  WPDataView.m
//  WP
//
//  Created by 沈亮亮 on 15/10/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPDataView.h"

@interface WPDataView ()

@property (assign, nonatomic) CGFloat top;
@property (nonatomic, strong) UILabel *label;

@end

@implementation WPDataView

-(id)initWithFrame:(CGRect)frame
{
    NSLog(@"%@",NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(221, 221, 221);
        _top = frame.origin.y;
        [self datePickerView];
    }
    return self;
}

-(UIDatePicker *)datePickerView
{
    if (!_datePickerView) {
        
        //创建
        _datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, self.width, 216)];
        
        _datePickerView.datePickerMode=UIDatePickerModeDate;
        //设定最大时间
//        _datePickerView.maximumDate=[NSDate date];
        //设置最小时间
//        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
//        NSDate*date=[formatter dateFromString:@"1920-01-01"];
    
        _datePickerView.minimumDate=[NSDate date];
        _datePickerView.backgroundColor=[UIColor whiteColor];
        //添加事件
        [_datePickerView addTarget:self action:@selector(datePickerClick) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePickerView];
        
        //        _dateCompleteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
        //        _dateCompleteView.backgroundColor = RGB(221, 221, 221);
        //        [self.view addSubview:_dateCompleteView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH - 40, 0, 40, 30);
        button.titleLabel.font = GetFont(15);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 40, 30);
        cancel.titleLabel.font = GetFont(15);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 30)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor lightGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _datePickerView;
}

-(void)datePickerClick{
//    NSLog(@"选择日期");
    //获取时间 按照日期格式进行转换
//    NSDateFormatter*formatter=[[NSDateFormatter  alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    //进行转换
//    NSString*str=[formatter stringFromDate:self.datePickerView.date];
//    if (self.getDateBlock) {
//        self.getDateBlock(str);
//    }
}

- (void)confirm
{
    NSDateFormatter*formatter=[[NSDateFormatter  alloc]init];
    if (self.isNeedSecond) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    //进行转换
    NSString*str=[formatter stringFromDate:self.datePickerView.date];
    if (self.getDateBlock) {
        self.getDateBlock(str);
    }
    [self removeFromSuperview];
}

-(void)resetTitle:(NSString *)title
{
    _label.text = title;
}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
}

-(void)hide
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
