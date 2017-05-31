//
//  WPResumeViewController3.m
//  WP
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPResumeViewController3.h"

@interface WPResumeViewController3 ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
}


@end

@implementation WPResumeViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.navigationItem.title=@"求职简历";
    [self createTableView];
    
    // Do any additional setup after loading the view.
}
-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//2 4 4
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else if(section==1||section==2){
        return 4;
    }else if (section==4)
    {
        return 2;
    }else{
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, 44)];
    UITextField* textField=[[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100, 44)];
    label1.textColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    if (indexPath.section==0&indexPath.row==0) {
        label.text=@"姓       名：";
        textField.placeholder=@"请填写姓名";
        [cell addSubview:label];
        [cell addSubview:textField];
    }else if (indexPath.section==0&indexPath.row==1) {
        label.text=@"出生年月：";
        [cell addSubview:label];
        label1.text=@"请选择生日";
        [cell addSubview:label1];
    }else if (indexPath.section==1) {
        NSArray* arr=@[@"学       历：",@"工作年限：",@"家       乡：",@"现居住地："];
        NSArray* arr1=@[@"请选择学历",@"请选择工作年限",@"请选择家乡",@"请选择居住地"];
        label.text=arr[indexPath.row];
        label1.text=arr1[indexPath.row];
        [cell addSubview:label];
        [cell addSubview:label1];
    }else if (indexPath.section==2) {
        NSArray* arr=@[@"期望职位：",@"期望薪资：",@"期望福利：",@"期望地区："];
        NSArray* arr1=@[@"请选择期望职位",@"请选择期望薪资",@"请选择期望福利",@"请选择期望地区"];
        label.text=arr[indexPath.row];
        label1.text=arr1[indexPath.row];
        [cell addSubview:label];
        [cell addSubview:label1];
    }else if (indexPath.section==3) {
        UITextField* textField1=[[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH, 100)];
        textField1.placeholder=@"请填写工作经历";
        label.text=@"工作经历：";
        [cell addSubview:label];
        [cell addSubview:textField1];
    }else if (indexPath.section==4&indexPath.row==0) {
        label.text=@"联系方式：";
        [cell addSubview:label];
        textField.placeholder=@"请填写联系方式";
    }else if (indexPath.section==4&indexPath.row==0) {
        label.text=@"个人亮点：";
        [cell addSubview:label];
        textField.placeholder=@"请填写个人亮点";
        [cell addSubview:textField];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        return 100;
    }else if (indexPath.section==4&indexPath.row==0) {
        return 44;
    }else if(indexPath.section==4&indexPath.row==1) {
        return 60;
    }else{
        return 44;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
