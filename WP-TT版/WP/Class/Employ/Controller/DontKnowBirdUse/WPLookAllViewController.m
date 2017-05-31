//
//  WPLookAllViewController.m
//  WP
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPLookAllViewController.h"
#import "WPShareModel.h"
#import "UIImageView+WebCache.h"

@interface WPLookAllViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _tableDataSource;
}

@end

@implementation WPLookAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    WPShareModel* model=[WPShareModel sharedModel];
    _tableDataSource=model.positionArray;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView* iconView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
        NSString* str=[IPADDRESS stringByAppendingString:_tableDataSource[indexPath.row][@"address"]];
        NSURL *urlImage = [NSURL URLWithString:str];
        // NSData *data = [NSData dataWithContentsOfURL:urlImage];
        [iconView sd_setImageWithURL:urlImage];
        //        UIImage* image=[UIImage imageWithData:data];
        //        iconView.image=image;
        [cell addSubview:iconView];
        UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH-44, 44)];
        label1.text=_tableDataSource[indexPath.row][@"industryName"];
        label1.textAlignment=NSTextAlignmentLeft;
        [cell addSubview:label1];
        //   cell.textLabel.text=_tableDataSource[indexPath.row][@"industryName"];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
