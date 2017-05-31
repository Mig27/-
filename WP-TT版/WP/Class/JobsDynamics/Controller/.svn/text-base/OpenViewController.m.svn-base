//
//  OpenViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/2/4.
//  Copyright © 2016年 WP. All rights reserved.
//  公开页面

#import "OpenViewController.h"
#import "OpenCell.h"
#import "WPOpenHeadView.h"
#import "WPHttpTool.h"
#import "WPOpenContact.h"
#import "WPSeeOrNotController.h"
#import "WPChooseContactToNewCategoryController.h"
@interface OpenViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign)NSInteger choiseIndex;//选择的公开。。。私密
@property (nonatomic, assign)NSInteger choiseCell;//看和不看选择的cell

@property (nonatomic, strong)NSMutableArray*dataArray;
@property (nonatomic,assign) BOOL selecteCanSee;//点击了让谁看
@property (nonatomic,assign) BOOL selectCanNotSee;//点击不让谁看

@end

@implementation OpenViewController

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    [self initNav];
//    [self makeSelected];
//    [self tableView];
    
    self.selectIndex =  10;
    [self getData:^(id objc) {
    }];
    [self initNav];
    [self tableView];
}
-(void)getData:(void(^)(id objc))Success
{
    NSDictionary*dictionary = @{@"id":@"",@"type_name":@"从通讯录选择",@"users_name":@"",@"users_id":@""};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"getfriendtypelist",@"user_id":kShareModel.userId};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        [self.dataArray removeAllObjects];
        NSArray * list = json[@"list"];
        [self.dataArray addObjectsFromArray:list];
        if (self.dataArray.count)
        {
            [self.dataArray insertObject:dictionary atIndex:self.dataArray.count];
        }
        else
        {
            [self.dataArray addObject:dictionary];
        }
        Success(@"");
    } failure:^(NSError *error) {
          [self.dataArray addObject:dictionary];
    }];
}
- (void)initNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"公开";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRight)];
}
#pragma mark 点击完成
-(void)clickRight
{
    
    NSString * title = nil;
    NSString * userID = nil;
    NSString * see = nil;
    if (self.choiseIndex<=3) {
        title = self.dataSource[self.choiseIndex][@"title"];
    }
    else
    {
        title = self.dataArray[self.choiseCell][@"type_name"];
        userID = self.dataArray[self.choiseCell][@"users_id"];
        if (self.selecteCanSee)
        {
            see = @"1";//从让谁看中选择
        }
        else
        {
            see = @"2";
        }
    }
    
    NSIndexPath * index = nil;
    if (self.choiseIndex <=3 )
    {
        index = [NSIndexPath indexPathForRow:0 inSection:self.choiseIndex];
    }
    else
    {
        if (self.selecteCanSee)
        {
          index = [NSIndexPath indexPathForRow:self.choiseCell inSection:5];
        }
        else
        {
          index = [NSIndexPath indexPathForRow:self.choiseCell inSection:6];
        }
        
    }
    
    NSDictionary * dic = @{@"title":title,@"userID":userID?userID:@"",@"see":see?see:@""};
    if (self.clickComplete)
    {
        self.clickComplete(dic,index);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [OpenCell cellHeight];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@{@"title" : @"公开",
                          @"subTitle" : @"所有人可见"},
                        @{@"title" : @"好友",
                          @"subTitle" : @"仅好友可见"},
                        @{@"title" : @"陌生人",
                          @"subTitle" : @"仅陌生人可见"},
                        @{@"title" : @"私密",
                          @"subTitle" : @"仅自己可见"},
                        @{@"title" : @"让谁看",
                          @"subTitle" : @"选中的好友可见"},
                        @{@"title" : @"不让谁看",
                          @"subTitle" : @"选中的好友不可见"}];
    }
    return _dataSource;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        return 8;
    }
    else
    {
     return kHEIGHT(58);
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.dataSource.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 6)
    {
        if (self.selectCanNotSee)
        {
            return self.dataArray.count;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 5)
    {
        if (self.selecteCanSee) {
            return self.dataArray.count;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        label.backgroundColor = RGB(235, 235, 235);
        return label;
    }
    else
    {
        WPOpenHeadView * headView = [WPOpenHeadView headViewWithTableView:tableView];
        headView.index = section;
        if (section == self.choiseIndex) {
            headView.isSelecteImage = YES;
        }
        else
        {
            headView.isSelecteImage = NO;
        }
        if (section <= 3) {
           headView.dic = self.dataSource[section];
        }
        else
        {
           headView.dic = self.dataSource[section-1];
        }
        headView.isHideSelectImage = (section>3);
        headView.isHideUpDownImage = (section<=3);
        if (section == 5) {
            headView.canSee = self.selecteCanSee;
        }
        if (section == 6) {
            headView.canSee = self.selectCanNotSee;
        }
        //点击头部
        headView.clickHeadView = ^(NSInteger index){
            if (index<=3) {//点击隐私之前的东西
                self.selecteCanSee = NO;
                self.selectCanNotSee = NO;
              
                self.choiseIndex = index;
                [self.tableView reloadData];
//                for (int i = 0 ; i < 4; i++) {
//                    if (i != index) {//未选中的改变选中状态
//                        WPOpenHeadView * view = (WPOpenHeadView*)[self.tableView headerViewForSection:i];
//                        view.selectImage.selected = NO;
//                    }
//                }
            }
            else
            {
//                self.choiseIndex = 10;
//                for (int i = 0 ; i < 4; i++) {
//                        WPOpenHeadView * view = (WPOpenHeadView*)[self.tableView headerViewForSection:i];
//                        view.selectImage.selected = NO;
//                }
                
                
                if (index == 5) {
                    self.selecteCanSee = !self.selecteCanSee;
                    self.selectCanNotSee = NO;
                }
                else
                {
                    self.selecteCanSee = NO;
                    self.selectCanNotSee = !self.selectCanNotSee;
                }
                [self.tableView reloadData];
            }
        };
        return headView;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count-1) {//通讯录
        static NSString * identifier = @"WPOpenContact";
        WPOpenContact * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WPOpenContact alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.dic = self.dataArray[indexPath.row];
        return cell;
    }
    else
    {
        OpenCell *cell = [OpenCell cellWithTableView:tableView];
        cell.dic = self.dataArray[indexPath.row];
        cell.index = indexPath;
        if (indexPath.row == self.selectIndex) {
            cell.selectImage.selected = YES;
            self.choiseCell = indexPath.row;
        }
        else
        {
            cell.selectImage.selected = NO;
        }
//        cell.selectImage.selected = NO;
        
        //点击cell上的按钮
        cell.choiseBtnClick = ^(NSIndexPath*index,BOOL isOrNot){
            NSLog(@"%ld",(long)index.row);
            self.choiseCell = index.row;
            [self cancelSelected];
        };
        return cell;
    }
}

-(void)cancelSelected
{
    self.choiseIndex = 10;
    for (int i = 0 ; i < 4; i++) {
        WPOpenHeadView * view = (WPOpenHeadView*)[self.tableView headerViewForSection:i];
        view.selectImage.selected = NO;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self cancelSelected];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[WPOpenContact class]]) {//点击通讯录
        WPChooseContactToNewCategoryController *chooseContact = [[WPChooseContactToNewCategoryController alloc] init];
        chooseContact.isFromOpen = YES;
        chooseContact.backSuccess = ^(NSString*title,NSString*name,NSString*typeID,NSString*userID){
            self.selectIndex = 0;
            NSDictionary * dic = @{@"id":typeID,@"users_id":userID,@"type_name":title,@"users_name":name};
            [self.dataArray insertObject:dic atIndex:0];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:chooseContact animated:YES];
    }
    else//点击其他
    {
        WPSeeOrNotController* see = [[WPSeeOrNotController alloc]init];
        see.title = self.dataArray[indexPath.row][@"type_name"];
        see.typeID = self.dataArray[indexPath.row][@"id"];
        see.allUserId = self.dataArray[indexPath.row][@"users_id"];
        see.deleteSuccess = ^(NSString*string){
            [self getData:^(id objc) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        };
        [self.navigationController pushViewController:see animated:YES];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count-1) {
        return NO;
    }
    else
    {
      return YES;
    }
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
        NSDictionary * dic = @{@"action":@"delfriendtype",@"typeid":self.dataArray[indexPath.row][@"id"],@"user_id":kShareModel.userId};
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            if ([json[@"status"] isEqualToString:@"1"]) {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    NSArray * array = @[action1];
    return array;
}



//-(void)makeSelected
//{
//    for (int i = 0 ; i < self.dataSource.count; i++) {
//        NSString * string = [NSString stringWithFormat:@"%@",self.dataSource[i][@"subTitle"]];
//        if ([string isEqualToString:self.titleString]) {
//            self.selectIndex = i;
//        }
//    }
//}
//- (void)initNav{
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"公开";
//}
//
//- (NSArray *)dataSource
//{
//    if (!_dataSource) {
//        _dataSource = @[@{@"title" : @"公开",
//                          @"subTitle" : @"所有人可见"},
//                        @{@"title" : @"好友",
//                          @"subTitle" : @"仅好友可见"},
//                        @{@"title" : @"陌生人",
//                          @"subTitle" : @"仅陌生人可见"},
//                        @{@"title" : @"私密",
//                          @"subTitle" : @"仅自己可见"}];
//    }
//    return _dataSource;
//}
//
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = RGB(235, 235, 235);
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.rowHeight = [OpenCell cellHeight];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        
//        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        [self.view addSubview:_tableView];
//
//    }
//    return _tableView;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OpenCell *cell = [OpenCell cellWithTableView:tableView];
//    cell.dic = self.dataSource[indexPath.row];
//    if (indexPath.row == self.selectIndex) {
//        cell.selectImage.hidden = NO;
//    }
//    else
//    {
//        cell.selectImage.hidden = YES;
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dic = self.dataSource[indexPath.row];
//    if (self.openDidselectBlock) {
//        self.openDidselectBlock(dic,indexPath.row);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
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
