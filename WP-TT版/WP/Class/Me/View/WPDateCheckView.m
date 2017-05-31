//
//  WPDateCheckView.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDateCheckView.h"
@interface WPDateCheckView()
{
    BOOL new;
}
@property (nonatomic, strong)NSString *oldDate;
@property (nonatomic, strong)UIDatePicker *datePickerView;
@property (nonatomic ,strong)UILabel *textLabel;
@end

@implementation WPDateCheckView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(221, 221, 221);
        [self addSubview:self.datePickerView];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.text = @"起始时间";
        self.textLabel.userInteractionEnabled = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 30);
        button.titleLabel.font = kFONT(15);
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(datePickerClick) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.textLabel addSubview:button];
        
    }
    return _textLabel;
}

-(UIDatePicker *)datePickerView
{
    if (!_datePickerView) {
    
        //创建
        self.datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, self.width, 216)];
        
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        
        if (new) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            NSDate *date = [formatter dateFromString:_oldDate];
            self.datePickerView.minimumDate = [NSDate dateWithTimeInterval:86401 sinceDate:date];;
            
           // self.datePickerView.maximumDate = [NSDate dateWithTimeInterval:5270401 sinceDate:date]; // 一天后
        }else{
            self.datePickerView.minimumDate= [NSDate date];
            //self.datePickerView.maximumDate = [NSDate dateWithTimeIntervalSinceNow:5184001];
        }
        self.datePickerView.backgroundColor=[UIColor whiteColor];
        //添加事件
        [self.datePickerView addTarget:self action:@selector(datePickerClick) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.datePickerView];
    }
    return _datePickerView;
}

-(void)datePickerClick{
    //    NSLog(@"选择日期");
    //获取时间 按照日期格式进行转换
    NSDateFormatter*formatter=[[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //进行转换
    NSString*str=[formatter stringFromDate:self.datePickerView.date];
    if (!new) {
        if (self.startTime) {
            self.oldDate = str;
            self.startTime(str);
        }
    }else{
        if (self.endTime) {
            self.endTime(str);
        }
    }
}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
}

-(void)hide
{
    [self datePickerClick];
    if (!new) {
        new = YES;
        [self.datePickerView removeFromSuperview];
        self.datePickerView = nil;
        [self addSubview:self.datePickerView];
        self.textLabel.text = @"结束时间";
    }else{
        new = NO;
        [self removeFromSuperview];
        self.datePickerView = nil;
        self.textLabel.text = @"开始时间";
    }
}

@end
