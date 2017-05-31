//
//  WPPeopleDetailViewController.m
//  WP
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleDetailViewController.h"
#import "WPPeopleDetailTableViewCell.h"
#import "WPPeopleDetailHeadView.h"
#import "MacroDefinition.h"

@interface WPPeopleDetailViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic,strong) UIButton *bottomButton1;

@property (nonatomic,strong) UIButton *bottomButton2;

@property (nonatomic,strong) UIButton *bottomButton3;

@property (nonatomic,strong) UITableView *tableView;








@end

@implementation WPPeopleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70) style:UITableViewStylePlain];
    _tableView.bounces=NO;
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:_tableView];

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 310;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WPPeopleDetailHeadView *_headView = [[WPPeopleDetailHeadView alloc] init];
    
    return _headView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 3;
    }
    if (section == 3) {
        return 3;
    }
    if (section == 4) {
        return 2;
    }

    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

@end
