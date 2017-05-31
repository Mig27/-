//
//  WPIndustryDetailViewController.m
//  WP
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPIndustryDetailViewController.h"
#import "WPShareModel.h"

@interface WPIndustryDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataSource;
}

@end

@implementation WPIndustryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    _dataSource=[[NSMutableArray alloc] init];
    WPShareModel* model=[WPShareModel sharedModel];
    _dataSource=model.industryArray;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tag=1;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView.tag==1) {
        cell.textLabel.text=_dataSource[indexPath.row][@"industryName"];
    }
//    }else if(tableView.tag==2){
//        cell.textLabel.text=_dataSourceArray1[indexPath.row][@"industryName"];
//    }else if (tableView.tag==3){
//        cell.textLabel.text = _dataSourceArray2[indexPath.row][@"industryName"];
//    }else if (tableView.tag==4){
//        cell.textLabel.text = _dataSourceArray3[indexPath.row][@"industryName"];
//    }else if (tableView.tag==5){
//        cell.textLabel.text = _dataSourceArray4[indexPath.row][@"industryName"];
//    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"二级界面＊＊＊＊＊＊＊＊");
//    if (tableView.tag==1) {
//        NSLog(@"进入二级界面");
//        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/IOS/ios_area.ashx"];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"action"] = @"getIndustry";
//        dic[@"fatherid"] = _dataSource[indexPath.row][@"industryID"];
//        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
//            NSLog(@"*****%@",json);
//            _dataSourceArray1=json[@"list"];
//            if (_dataSourceArray1.count!=0) {
//                [self createTableView2];
//            }else
//            {
//                [self.navigationController popViewControllerAnimated:YES];
//                industryString=_dataSourceArray[indexPath.row][@"industryName"];
//                self.passValueDelegate=self.navigationController.childViewControllers[0];
//                [self.passValueDelegate setValue:industryString];
//            }
//            
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error.localizedDescription);
//        }];
//    }else if (tableView.tag==2){
//        NSLog(@"进入三级界面");
//        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/IOS/ios_area.ashx"];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"action"] = @"getIndustry";
//        dic[@"fatherid"] = _dataSourceArray1[indexPath.row][@"industryID"];
//        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
//        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
//            NSLog(@"*****%@",json);
//            _dataSourceArray2=json[@"list"];
//            industryString=_dataSourceArray1[indexPath.row][@"industryName"];
//            if (_dataSourceArray2.count!=0) {
//                [self createTableView3];
//            }else
//            {
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                self.passValueDelegate=self.navigationController.childViewControllers[0];
//                [self.passValueDelegate setValue:industryString];
//            }
//            
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error.localizedDescription);
//        }];
//    }else if (tableView.tag==3){
//        NSLog(@"进入三级界面");
//        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/IOS/ios_area.ashx"];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"action"] = @"getIndustry";
//        dic[@"fatherid"] = _dataSourceArray2[indexPath.row][@"industryID"];
//        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
//        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
//            NSLog(@"*****%@",json);
//            industryString=_dataSourceArray2[indexPath.row][@"industryName"];
//            _dataSourceArray3=json[@"list"];
//            if (_dataSourceArray3.count!=0) {
//                [self createTableView4];
//            }else
//            {
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error.localizedDescription);
//        }];
//    }else if (tableView.tag==4){
//        NSLog(@"进入四级界面");
//        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/IOS/ios_area.ashx"];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"action"] = @"getIndustry";
//        dic[@"fatherid"] = _dataSourceArray3[indexPath.row][@"industryID"];
//        NSLog(@"<<<<<>>>>>%@,%@",urlStr,dic);
//        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
//            NSLog(@"*****%@",json);
//            
//            _dataSourceArray4=json[@"list"];
//            industryString=_dataSourceArray3[indexPath.row][@"industryName"];
//            NSLog(@"*****************%ld",_dataSourceArray4.count);
//            if (_dataSourceArray4.count!=0) {
//                [self createTableView5];
//            }else if(_dataSourceArray4.count==0){
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error.localizedDescription);
//        }];
//    }
    
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
