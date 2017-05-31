//
//  WPAddFriendController.m
//  WP
//
//  Created by CBCCBC on 15/9/17.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPAddFriendController.h"
#import "MBProgressHUD+MJ.h"

@interface WPAddFriendController () <UITextViewDelegate>

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UILabel *numberLabel;
@property (strong,nonatomic) UITextView *textView;

@end

@implementation WPAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(235, 235, 235);
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 60)];
    _textView.font = GetFont(15);
    _textView.delegate = self;
    
    [view addSubview:_textView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(3, 7, 200, 20)];
    _label.enabled = NO;
    _label.text = @"请填写申请理由";
    _label.font = GetFont(15);
    _label.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_label];
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, view.height-10-10, SCREEN_WIDTH-10-10, 20)];
    _numberLabel.text = @"30";
    _numberLabel.font = GetFont(15);
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.textColor = [UIColor darkGrayColor];
//    [view addSubview:_numberLabel];
 
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = barItem;
}

-(void)complete
{
    if (![_textView.text isEqualToString:@""]) {
        
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
    }else{
        [MBProgressHUD alertView:@"" Message:@"请填写申请理由"];
    }
}

-(void)delay
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [_label setHidden:NO];
    }else{
        [_label setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
