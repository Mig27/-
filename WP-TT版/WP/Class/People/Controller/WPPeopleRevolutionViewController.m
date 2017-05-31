//
//  WPPeopleRevolutionViewController.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleRevolutionViewController.h"
#import "WPPeopleTableViewCell.h"
#import "MacroDefinition.h"


@interface WPPeopleRevolutionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *button1;

@property (nonatomic,strong) UIButton *button2;

@property (nonatomic,strong) UIButton *button3;

@property (nonatomic,strong) UIButton *button4;


@end

@implementation WPPeopleRevolutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"关系");
    self.view.backgroundColor = RGBColor(235, 235, 235);
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [right setImage:[UIImage imageNamed:@"黑色搜索"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, kScreenW/2, 36)];
    [_button1 setBackgroundColor:[UIColor whiteColor]];
    [_button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    UIImageView *_button1Image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*0.086, 7.5, 21, 21)];
    _button1Image.image = [UIImage imageNamed:@"谁赞过我"];
    [_button1 addSubview:_button1Image];
    UILabel *_button1Label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*0.178, 0, kScreenW/2 - kScreenW*0.178, 36)];
    _button1Label.text = @"有谁赞过我";
    _button1Label.textAlignment = NSTextAlignmentLeft;
    _button1Label.font = [UIFont systemFontOfSize:15.0];
    [_button1 addSubview:_button1Label];
    
    _button2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2, 10, kScreenW/2, 36)];
    [_button2 setBackgroundColor:[UIColor whiteColor]];
    [_button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    UIImageView *_button2Image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*0.086, 7.5, 21, 21)];
    _button2Image.image = [UIImage imageNamed:@"谁收藏过我哦"];
    [_button2 addSubview:_button2Image];
    UILabel *_button2Label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*0.178, 0, kScreenW/2 - kScreenW*0.178, 36)];
    _button2Label.text = @"有谁收藏我";
    _button2Label.textAlignment = NSTextAlignmentLeft;
    _button2Label.font = [UIFont systemFontOfSize:15.0];
    [_button2 addSubview:_button2Label];
    
    _button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, kScreenW/2, 36)];
    [_button3 setBackgroundColor:[UIColor whiteColor]];
    [_button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button3];
    UIImageView *_button3Image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*0.086, 7.5, 21, 21)];
    _button3Image.image = [UIImage imageNamed:@"谁转发我"];
    [_button3 addSubview:_button3Image];
    UILabel *_button3Label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*0.178, 0, kScreenW/2 - kScreenW*0.178, 36)];
    _button3Label.text = @"有谁转发我";
    _button3Label.textAlignment = NSTextAlignmentLeft;
    _button3Label.font = [UIFont systemFontOfSize:15.0];
    [_button3 addSubview:_button3Label];
    

    _button4 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2, 46, kScreenW/2, 36)];
    [_button4 setBackgroundColor:[UIColor whiteColor]];
    [_button4 addTarget:self action:@selector(button4Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button4];
    UIImageView *_button4Image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*0.086, 7.5, 21, 21)];
    _button4Image.image = [UIImage imageNamed:@"谁看过我"];
    [_button4 addSubview:_button4Image];
    UILabel *_button4Label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*0.178, 0, kScreenW/2 - kScreenW*0.178, 36)];
    _button4Label.text = @"有谁看过我";
    _button4Label.textAlignment = NSTextAlignmentLeft;
    _button4Label.font = [UIFont systemFontOfSize:15.0];
    [_button4 addSubview:_button4Label];


    UILabel *_line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, kScreenW, 1)];
    _line1.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:_line1];
    
    UILabel *_line2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, 10, 1, 72)];
    _line2.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:_line2];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 92, kScreenW, kScreenH-92)];
    _tableView.rowHeight = 59.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString  *cellId = @"ViewCellId";
    
    
    WPPeopleTableViewCell *cell = [[WPPeopleTableViewCell alloc] init];
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[WPPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    
    
    
    
    return cell;
}

- (void)button1Click
{
    
}

- (void)button2Click
{
    
}


- (void)button3Click
{
    
}


- (void)button4Click
{
    
}


@end
