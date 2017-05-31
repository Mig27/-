//
//  ActivityConditionController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityConditionController.h"
#import "ConditionCell.h"
#import "WPHttpTool.h"

@interface ActivityConditionController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *objects;
@property (nonatomic,strong) NSMutableArray *states;

@end

@implementation ConditionModel


@end

@implementation ActivityConditionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self objects];
    [self createUI];
}

- (void)createUI
{
//    NSLog(@"11111%@",_originalConditions);
    for (ConditionModel *model in self.originalConditions) {
        [_objects replaceObjectAtIndex:model.index withObject:model];
//        if (model.isSelect) {
//            NSLog(@"第%d行选中",model.index);
//        } else {
//            NSLog(@"第%d行未选中",model.index);
//        }
        
    }
    self.title = @"活动条件";
    self.view.backgroundColor = RGB(235, 235, 235);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds]; // Here is where the magic happens
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //    [_tableView setEditing:YES animated:YES]; //打开UItableView 的编辑模式
    //    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
    
}

- (NSArray *)objects
{
    if (!_objects) {
        _objects = [NSMutableArray array];
    NSArray *arr = @[@"照片",
                     @"姓名",
                     @"性别",
                     @"证件",
                     @"出生年月",
                     @"手机",
                     @"微信",
                     @"QQ",
                     @"邮箱",
                     @"行业",
                     @"职位",
                     @"企业名称",
                     @"目前薪资",
                     @"学历",
                     @"工作年限",
                     @"婚姻状况",
                     @"现居住地",
                     @"工作经历"];
        for (int i = 0; i<arr.count; i++) {
            ConditionModel *model = [[ConditionModel alloc] init];
            model.name = arr[i];
            model.isSelect = NO;
            model.index = i;
            [_objects addObject:model];
        }
    }
    return _objects;
}

- (void)rightBtnClick{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    [self.originalConditions removeAllObjects];
    for (ConditionModel *model in _objects) {
        if (model.isSelect) {
            ConditionModel *newModel  = [[ConditionModel alloc] init];
            newModel.name = model.name;
            newModel.isSelect = model.isSelect;
            newModel.index = model.index;
            [arr addObject:newModel];
        }
    }
//    NSLog(@"22222%@",arr);
    if (self.completeBlock) {
        self.completeBlock(arr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ConditionCell";
    ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
//    cell.titleLabel.text = _objects[indexPath.row];
    ConditionModel *model = _objects[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.btnIsSelect = model.isSelect;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.selectBtn.isSelected) {
//        cell.selectBtn.selected = NO;
//    } else {
//        cell.selectBtn.selected = YES;
//    }
    ConditionModel *model = _objects[indexPath.row];
    model.isSelect = !model.isSelect;
    [_objects replaceObjectAtIndex:indexPath.row withObject:model];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
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
