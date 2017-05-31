//
//  WPSysNotificationViewController.m
//  WP
//
//  Created by CC on 17/2/3.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPSysNotificationViewController.h"
#import "WPHttpTool.h"
#import "WPSysNotiTableViewCell.h"
#import "WPSysTimeTableViewCell.h"
@interface WPSysNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)NSMutableArray * heightArray;
@end

@implementation WPSysNotificationViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray*)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(247, 247, 247);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    self.view.backgroundColor = RGB(247, 247, 247);
    [self requstData];
    // Do any additional setup after loading the view.
}
-(void)requstData
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/getmsg.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"getJobMsglist",@"user_id":kShareModel.userId,@"jobid":self.jobID,@"type":self.type?@"1":@"2"};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (self.requstSuccess) {
            self.requstSuccess();
        }
        
        [self.dataSource removeAllObjects];
        NSArray * array = json[@"list"];
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = array[i];
            if (i == 0) {
                [self.dataSource addObject:dic[@"add_time"]];
                [self.dataSource addObject:dic];
            }
            else
            {
                NSDictionary * dic0 = array[i-1];
                NSString * string0 = dic0[@"add_time"];
                NSString * string1 = dic[@"add_time"];
                if ([string0 isEqualToString:string1]) {
                    [self.dataSource addObject:dic];
                }
                else
                {
                    [self.dataSource addObject:string1];
                    [self.dataSource addObject:dic];
                }
            }
        }
        [self.heightArray addObjectsFromArray:[self getHeightArray:self.dataSource]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
}
-(NSArray*)getHeightArray:(NSArray*)array
{
    NSMutableArray * muArray = [NSMutableArray array];
    for (id objc in array) {
        if ([objc isKindOfClass:[NSString class]])
        {
            CGSize timeSize = [@"哈哈" getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH-2*kHEIGHT(10)];
            NSString * string = [NSString stringWithFormat:@"%f",6+15+timeSize.height];
            [muArray addObject:string];
        }
        else
        {
            NSDictionary * dictionary = (NSDictionary*)objc;
            NSString * title = dictionary[@"title"];
            NSString * content = dictionary[@"remark"];
            CGSize titleSize =[title getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-4*12];
            CGSize contentSize = [content getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH-4*12];
            NSString * string = [NSString stringWithFormat:@"%f",12+titleSize.height+10+contentSize.height+12+18];
            [muArray addObject:string];
        }
    }
    NSArray * array1 = [NSArray arrayWithArray:muArray];
    return array1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if ([self.dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
        static NSString * identifier = @"WPSysTimeTableViewCell";
        WPSysTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WPSysTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.timeString = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    else
    {
        static NSString * identifier = @"WPSysNotiTableViewCell";
        WPSysNotiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell =[[WPSysNotiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.dictionary = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
