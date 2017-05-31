//
//  TopicViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/2/4.
//  Copyright © 2016年 WP. All rights reserved.
//  发布时选择话题页面

#import "TopicViewController.h"
#import "TopicCell.h"
#import "DynamicTopicTypeModel.h"
#import "ButtonMenuCollectionCell.h"
#import "WPHttpTool.h"
#import "HPReorderTableView.h"
#import "MTTDatabaseUtil.h"

@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    [self initNav];
    [self reloadData];
//    [self tableView];
}

- (void)initNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择话题";
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
//        _dataSource = @[@"职场说说",@"匿名吐槽",@"职场八卦",@"上班族",@"正能量",@"心理学",@"工作狂",@"创业心得",@"老板心得",@"管理智慧",@"求职宝典",@"找工作",@"交友",@"在路上",@"早安心语",@"情感心语"];
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)reloadData
{
    [WPHttpTool postWithURL:[IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"] params:@{@"action" : @"getTypeList", @"page" : @(_page),@"user_id":kShareModel.userId} success:^(id json) {
        if ([json[@"list"] count]) {
            [[MTTDatabaseUtil instance] uploadTopic:json[@"list"]];
        }
        DynamicTopicTypeListModel *model = [DynamicTopicTypeListModel mj_objectWithKeyValues:json];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:model.list];
        [_tableView.mj_footer endRefreshing];
        if (arr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_page == 1) {
            [arr removeObjectAtIndex:0];
//            [arr removeObjectAtIndex:0];
        }
        [self.dataSource addObjectsFromArray:arr];
        
        for (int i = 0; i < self.dataSource.count; i++) {
            DynamicTopicTypeModel* model = self.dataSource[i];
            if ([model.type_name isEqualToString:self.typeName]) {
                self.selectIndex = i;
            }
        }
     
//        for (int i = 0; i<self.dataSource.count; i++) {
//            DynamicTopicTypeModel *model = self.dataSource[i];
//            model.isSelected = (i == self.selectIndex) ? @"1" : @"0";
//        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getShuoShuoTopic:[NSString stringWithFormat:@"%ld",(_page-1)*10] success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array};
                DynamicTopicTypeListModel *model = [DynamicTopicTypeListModel mj_objectWithKeyValues:dic];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:model.list];
                [self.dataSource addObjectsFromArray:arr];
                [self.tableView reloadData];
            }
        }];
        [_tableView.mj_footer endRefreshing];
    }];

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGB(226, 226, 226);
        _tableView.rowHeight = [TopicCell cellHeight];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self reloadData];
        }];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ButtonMenuCollectionCell *cell = [ButtonMenuCollectionCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    if (indexPath.row == self.selectIndex) {
        cell.selectImage.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark 滑动置顶
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;

}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = [NSArray array];
    
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"↑置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:indexpath];
            
            if (indexPath.row == self.selectIndex) {
                self.selectIndex = 1;
            }
            else
            {
                if (self.selectIndex == 0) {
                    
                }
                else
                {
                    if (indexPath.row>self.selectIndex) {
                        ++(self.selectIndex);
                    }
                }
                
                
            }
        NSIndexPath * index = [NSIndexPath indexPathForRow:self.selectIndex inSection:0];
        if (self.topicDidselectBlock) {
            self.topicDidselectBlock(self.dataSource[index.row],index);
        }
            //网络请求数据
            [self moveToFirstIndexpath:indexPath];
        }];
    action.backgroundColor = RGB(57, 58, 63);
   //action.backgroundColor = [UIColor redColor];
        //action.backgroundColor = RGB(0, 172, 255);
    
    
    
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"↓" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSIndexPath * targetIndex = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:targetIndex];
        if (self.selectIndex == indexPath.row) {
            self.selectIndex += 1;
        }
        else if (self.selectIndex-1 == indexPath.row)
        {
            self.selectIndex -= 1;
        }
        
        
        [self downMove:indexPath];
    }];
    action1.backgroundColor = RGB(127, 127, 127);
        NSArray * arr = @[action,action1];
        return arr;
    return array;
}

-(void)downMove:(NSIndexPath*)indexpath
{
    DynamicTopicTypeModel * model = self.dataSource[indexpath.row];
    [self.dataSource insertObject:model atIndex:indexpath.row+2];
    [self.dataSource removeObjectAtIndex:indexpath.row];
    
    NSString * strId = [NSString string];
    for (DynamicTopicTypeModel * model1 in self.dataSource) {
        if (strId.length)
        {
            
            strId = [NSString stringWithFormat:@"%@,%@",strId,model1.sid];
        }
        else
        {
            strId = [NSString stringWithFormat:@"%@",model1.sid];
        }
    }
    NSDictionary * diction = @{@"action":@"updatetype",@"user_id":kShareModel.userId,@"json_list":strId,
                               @"my_user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:diction success:^(id json) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}





-(void)moveToFirstIndexpath:(NSIndexPath*)indexpath
{
    DynamicTopicTypeModel * model = self.self.dataSource[indexpath.row];
    [self.self.dataSource removeObject:model];
    [self.self.dataSource insertObject:model atIndex:1];
    NSString * strId = [NSString string];
    for (DynamicTopicTypeModel * model1 in self.self.dataSource) {
        if (strId.length)
        {
            
            strId = [NSString stringWithFormat:@"%@,%@",strId,model1.sid];
        }
        else
        {
            strId = [NSString stringWithFormat:@"%@",model1.sid];
        }
    }
    NSDictionary * diction = @{@"action":@"updatetype",@"user_id":kShareModel.userId,@"json_list":strId,
                               @"my_user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:diction success:^(id json) {
        [self.tableView reloadData];
        
        
        
        
    } failure:^(NSError *error) {
        
    }];
}
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
//    [self.tableView reloadData];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.topicDidselectBlock) {
        self.topicDidselectBlock(self.dataSource[indexPath.row],indexPath);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
