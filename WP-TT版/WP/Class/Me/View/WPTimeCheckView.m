//
//  WPTimeCheckView.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPTimeCheckView.h"

@interface WPTimeCheckView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL move;
}
@property (nonatomic, assign)CGFloat top;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)NSMutableArray *timeArray;
@end

@implementation WPTimeCheckView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(221, 221, 221);
        _top = frame.origin.y;
        [self addSubview:self.pickerView];
//        [self.pickerView reloadAllComponents];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 30);
        button.titleLabel.font = kFONT(15);
        
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)hide
{
    if (!move) {
        self.time(self.timeArray[0]);
    }
    [self removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        
        //创建
        self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, self.width, 216)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.timeArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc]init];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.text = self.timeArray[row];
    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = RGB(226, 226, 226);
    label.font = kFONT(20);
    [view addSubview:label];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    move = YES;
    self.time(self.timeArray[row]);
}

- (NSMutableArray *)timeArray
{
    if (!_timeArray) {
        self.timeArray = [NSMutableArray array];
        for (int i = 1; i < 25; i++) {
            NSString *string = [NSString stringWithFormat:@"%d小时",i];
            [self.timeArray addObject:string];
        }
    }
    return _timeArray;
}


@end
