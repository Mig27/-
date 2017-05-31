//
//  WPRegisterViewController2-3.m
//  WP
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRegisterViewController2-3.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "WPRegisterViewController2.h"


@interface WPRegisterViewController2_3 ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    UITableView* tableView2;
    UITableView* tableView3;
    UITableView* tableView4;
    
    NSMutableArray* _dataSourceArray;
    NSMutableArray* _dataSourceArray1;
    NSMutableArray* _dataSourceArray2;
    NSMutableArray* _dataSourceArray3;
    NSMutableArray* _dataSourceArray4;
    
    NSString* addressStr;
}


@end

@implementation WPRegisterViewController2_3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [self createTableView];
    // Do any additional setup after loading the view.
}
-(void)createTableView
{
    WPShareModel* model=[WPShareModel sharedModel];
    _dataSourceArray=model.addressArr;
    NSLog(@"数组%@",_dataSourceArray);
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.tag=1;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return _dataSourceArray.count;
    }else
        return _dataSourceArray1.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (tableView.tag==1) {
        cell.textLabel.text=_dataSourceArray[indexPath.row][@"cityName"];
    }else if(tableView.tag==2){
        cell.textLabel.text=_dataSourceArray1[indexPath.row][@"cityName"];
     //   cell.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    }else if (tableView.tag==3){
        cell.textLabel.text = _dataSourceArray2[indexPath.row][@"cityName"];
     //   cell.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        NSLog(@"进入二级界面");
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"action"] = @"getarea";
        dic[@"fatherid"] = _dataSourceArray[indexPath.row][@"cityID"];
        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            NSLog(@"*****%@",json);
            _dataSourceArray1=json[@"list"];
            if (_dataSourceArray1.count!=0) {
                _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH/2, _dataSourceArray.count*40);
                tableView2=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, _dataSourceArray1.count*40) style:UITableViewStylePlain];
                tableView2.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
                tableView2.tag=2;
                tableView2.delegate=self;
                tableView2.dataSource=self;
                [self.view addSubview:tableView2];
               // [self createTableView2];
            }else
            {
                addressStr=_dataSourceArray[indexPath.row][@"cityName"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if (tableView.tag==2){
        NSLog(@"进入三级界面");
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"action"] = @"getarea";
        dic[@"fatherid"] = _dataSourceArray1[indexPath.row][@"cityID"];
        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            NSLog(@"*****%@",json);
            _dataSourceArray2=json[@"list"];
            if (_dataSourceArray2.count!=0) {
                [_tableView removeFromSuperview];
                tableView2.frame=CGRectMake(0, 64,SCREEN_WIDTH/2, _dataSourceArray2.count*40);
                tableView3=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, 40*_dataSourceArray2.count) style:UITableViewStylePlain];
                tableView3.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
                tableView3.tag=3;
                tableView3.delegate=self;
                tableView3.dataSource=self;
                [self.view addSubview:tableView3];
              //  [self createTableView3];
            }else
            {
                addressStr=_dataSourceArray1[indexPath.row][@"cityName"];
                [self.navigationController popViewControllerAnimated:YES];
            }

        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if (tableView.tag==3){
        NSLog(@"进入三级界面");
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"action"] = @"getarea";
        dic[@"fatherid"] = _dataSourceArray2[indexPath.row][@"cityID"];
        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            NSLog(@"*****%@",json);
            
            _dataSourceArray3=json[@"list"];
            if (_dataSourceArray3.count!=0) {
                NSLog(@"司机界面");
                [tableView2 removeFromSuperview];
                tableView3.frame=CGRectMake(0, 64,SCREEN_WIDTH/2, _dataSourceArray2.count*40);
                tableView4=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, _dataSourceArray3.count*40) style:UITableViewStylePlain];
                tableView3.backgroundColor=[UIColor whiteColor];
                tableView4.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
                tableView4.tag=4;
                tableView4.delegate=self;
                tableView4.dataSource=self;
                [self.view addSubview:tableView4];
              //  [self createTableView4];
            }else
            {
                addressStr=_dataSourceArray2[indexPath.row][@"cityName"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else if (tableView.tag==4){
        NSLog(@"进入三级界面");
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"action"] = @"getarea";
        dic[@"fatherid"] = _dataSourceArray3[indexPath.row][@"cityID"];
        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            NSLog(@"*****%@",json);
            
            _dataSourceArray4=json[@"list"];
            if (_dataSourceArray4.count!=0) {
                [self createTableView5];
            }else
            {
                addressStr=_dataSourceArray3[indexPath.row][@"cityName"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }

}

-(void)createTableView5
{
    NSLog(@"五级界面");
}
//-(void)viewWillDisappear:(BOOL)animated
//{
////    WPShareModel* model=[WPShareModel sharedModel];
////    model.addressStr=addressStr;
//}

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
