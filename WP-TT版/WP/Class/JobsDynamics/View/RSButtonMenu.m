//
//  RSButtonMenu.m
//  WP
//
//  Created by 沈亮亮 on 15/11/4.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RSButtonMenu.h"
#import "IndustryModel.h"
#import "ButtonMenuCollectionCell.h"
#import "ButtonMenuTableViewCell.h"
#import "WPHttpTool.h"
#import "DynamicTopicTypeModel.h"
#import "SelectModel.h"
#import "MTTDatabaseUtil.h"
#import "WPDownLoadVideo.h"
@interface RSButtonMenu ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (assign, nonatomic) NSInteger orignalHeight;
@property (assign, nonatomic) NSInteger tableViewHeight;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic,strong) UIView *buttonView;
@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSString *selectTime;
@property (nonatomic,assign) NSInteger seleteIndex1;  /**< 第一列的选中行 */
@property (nonatomic,assign) NSInteger seleteIndex2;  /**< 第二列的选中行 */
@property (nonatomic, strong) UITableView *secondTable;
@property (nonatomic,assign) NSInteger page;  /**< 第二列的选中行 */

@property (nonatomic, strong)ButtonMenuCollectionCell*currentCell;
@property (nonatomic, strong)ButtonMenuCollectionCell*FirstcurrentCell;

@property (nonatomic, copy)NSString * choiseId;
@end

@implementation RSButtonMenu

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        _orignalHeight = self.size.height;
        _tableViewHeight = _orignalHeight - 72;
    }
    return self;
}

-(void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.buttonView.height = 0;
        self.height = 0;
    }];
}

- (void)setLocalData:(NSArray *)arr
{
    self.dataArr = [[NSMutableArray alloc]initWithArray:arr];
    self.collectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);

    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.collectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (arr.count%2 + arr.count/2)*kHEIGHT(43));
//        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            NSInteger height = (arr.count%2 + arr.count/2)*kHEIGHT(43);
//            make.height.equalTo(@(height));
//        }];
        
    }];
    [_collectView reloadData];
    
}

- (void)setLocalTime:(NSArray *)arr andSelectTime:(NSString *)time
{
    self.dataArr = [[NSMutableArray alloc] initWithArray:arr];
    self.selectTime = time;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, arr.count*kHEIGHT(43));
        
    }];
    [_tableView reloadData];

}

- (void)setNewLocalData:(NSArray *)arr andSelectIndex:(NSInteger)index
{
    self.dataArr = [[NSMutableArray alloc]initWithArray:arr];
    self.collectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.seleteIndex1 = index;
    [UIView animateWithDuration:0.2 animations:^{
        self.height = _orignalHeight;
        self.collectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (arr.count%2 + arr.count/2)*kHEIGHT(43));
        //        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            NSInteger height = (arr.count%2 + arr.count/2)*kHEIGHT(43);
        //            make.height.equalTo(@(height));
        //        }];
        
    }];
    [_collectView reloadData];

}

-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(NSInteger)selectedIndex
{
    self.urlString = urlStr;
    self.page = 1;
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.seleteIndex1 = selectedIndex;
    self.secondTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [self.dataArr removeAllObjects];
//    [self.secondTable setContentOffset:CGPointMake(0, 0) animated:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.height = _orignalHeight;
        self.secondTable.frame = CGRectMake(0, 0, self.width, _orignalHeight);
        
    }];
//    [_secondTable reloadData];
    [self requsetInfo];

}

- (void)newSetUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(NSInteger)selectedIndex
{
    self.urlString = urlStr;
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.seleteIndex2 = selectedIndex;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.height = _orignalHeight;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _orignalHeight - 64);
    }];
    [_tableView reloadData];
    [self loadDataSource];

}

- (void)loadDataSource
{
    [WPHttpTool postWithURL:self.urlString params:self.params success:^(id json) {
        NSLog(@"%@",json);
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        self.dataArr =  [NSMutableArray arrayWithArray:model.list];
        if (self.isGroupCreate) {
            [self.dataArr removeObjectAtIndex:0];
        }
        
        if (self.isFromGroup) {
            IndustryModel * model = [[IndustryModel alloc]init];
            model.industryID = @"0";
            model.industryName = @"全部行业";
            [self.dataArr insertObject:model atIndex:0];
        }
        
        
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requsetInfo
{
    self.params[@"page"] = @(_page);
    [WPHttpTool postWithURL:self.urlString params:self.params success:^(id json) {
        DynamicTopicTypeListModel *model = [DynamicTopicTypeListModel mj_objectWithKeyValues:json];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:model.list];
        [_secondTable.mj_footer endRefreshing];
        if (arr.count == 0) {
            [self.secondTable.mj_footer endRefreshingWithNoMoreData];
            [[MTTDatabaseUtil instance] uploadTopic:json[@"list"]];
        }
        [self.dataArr addObjectsFromArray:arr];
        
//        _choiseId= [NSString stringWithFormat:@"%@",self.dataArr[self.seleteIndex1][@"sid"]];
        
        
        [_secondTable reloadData];
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getShuoShuoTopic:[NSString stringWithFormat:@"%ld",(_page-1)*10] success:^(NSArray *array) {
             [_secondTable.mj_footer endRefreshing];
            if (array.count) {
                NSDictionary * dic = @{@"list":array};
                DynamicTopicTypeListModel *model = [DynamicTopicTypeListModel mj_objectWithKeyValues:dic];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:model.list];
                 [self.dataArr addObjectsFromArray:arr];
                [_secondTable reloadData];
            }
        }];
    }];
}

- (void)setLocalType:(NSArray *)arr andSelectIndex:(NSInteger)index
{
    self.dataArr = [[NSMutableArray alloc] initWithArray:arr];
//    self.selectTime = time;
    self.seleteIndex2 = index;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.height = _orignalHeight;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-30-64);//arr.count*kHEIGHT(43)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if (arr.count *kHEIGHT(43) < SCREEN_HEIGHT-30-64) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-30-64-arr.count*kHEIGHT(43))];
            
            view.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFootView)];
            [view addGestureRecognizer:tap];
            UILabel * labe = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            labe.backgroundColor = RGB(226, 226, 226);
            [view addSubview:labe];
            self.tableView.tableFooterView = view;
        }
    }];
    [_tableView reloadData];

}

#pragma  mark  点击空白部分
-(void)clickFootView
{
    if (self.touchHide) {
        self.touchHide();
    }
}
- (void)loadData
{
    CGFloat width = SCREEN_WIDTH/2;
    CGFloat height = kHEIGHT(43);
    for (int i = 0; i<self.dataArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i%2*width, i/2*height, width, height);
        button.tag = i+10;
        [button setTitle:[self.dataArr[i] industryName] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        [button setBackgroundImage:[UIImage imageNamed:@"detail_button_highted.jpg"] forState:UIControlStateHighlighted];
        [self.buttonView addSubview:button];
    }
}

- (void)btnClick:(UIButton *)sender
{
    
}

- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectView setCollectionViewLayout:flowLayout];
        
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-30) collectionViewLayout:flowLayout];
        _collectView.backgroundColor = [UIColor whiteColor];;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [_collectView registerClass:[ButtonMenuCollectionCell class] forCellWithReuseIdentifier:@"ButtonMenuCollectionCell"];
        [self addSubview:_collectView];

    }
    
    return _collectView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellId = @"ButtonMenuCollectionCell";
//    ButtonMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[ButtonMenuCollectionCell alloc] init];
//    }
//    cell.model = self.dataArr[indexPath.row];
//    cell.titleLabel.textColor = [UIColor blackColor];
//    if (indexPath.row == self.seleteIndex1) {
//       cell.selectImage.hidden = NO;
//    }
////    NSLog(@"%@",[self.dataArr[indexPath.row] industryName]);
//    return cell;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH,kHEIGHT(58));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if ([self.delegate respondsToSelector:@selector(RSButtonMenuDelegate:selectMenu:)]) {
//        [self.delegate RSButtonMenuDelegate:self.dataArr[indexPath.row] selectMenu:self];
//    }
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = RGB(226, 226, 226);
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self addSubview:_tableView];
        
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
- (UITableView *)secondTable
{
    if (!_secondTable) {
        _secondTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30) style:UITableViewStylePlain];
        _secondTable.showsVerticalScrollIndicator = NO;
        _secondTable.delegate = self;
        _secondTable.dataSource = self;
        _secondTable.separatorColor = RGB(226, 226, 226);
        if ([self.secondTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.secondTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([self.secondTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.secondTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.secondTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self requsetInfo];
        }];

        [self addSubview:_secondTable];
        
    }
    return _secondTable;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
#pragma mark 滑动置顶
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == _secondTable)
//    {
//        NSIndexPath * indespath = [NSIndexPath indexPathForRow:1 inSection:0];
//        [tableView moveRowAtIndexPath:indexPath toIndexPath:indespath];
//    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _secondTable) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return NO;
        }
        else
        {
         return YES;
        }
        
        
    }
    else
    {
        return NO;
    }
//    return YES;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = [NSArray array];
    if (tableView == _secondTable)
    {
        
       
        
        
        UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"↑置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
            [_secondTable moveRowAtIndexPath:indexPath toIndexPath:indexpath];
            if (self.seleteIndex1 == 0) {
            }
            else
            {
                if (indexPath.row == self.seleteIndex1) {
                    self.seleteIndex1 = 2;
                }
                else
                {
                    if (indexPath.row>self.seleteIndex1) {
                        ++(self.seleteIndex1);
                    }
                }
            }
            //网络请求数据
            [self moveToFirstIndexpath:indexPath];
        }];
        action.backgroundColor = RGB(57, 58, 63);
        
        UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"↓" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSIndexPath * targetIndex = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
            [_secondTable moveRowAtIndexPath:indexPath toIndexPath:targetIndex];
            if (self.seleteIndex1 == indexPath.row) {
                self.seleteIndex1 += 1;
            }
            else if (self.seleteIndex1-1 == indexPath.row)
            {
               self.seleteIndex1 -= 1;
            }
            
            
            [self downMove:indexPath];
        }];
        action1.backgroundColor = RGB(127, 127, 127);
        
        
//        UITableViewRowAction * action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//            
//        }];
//        action2.backgroundColor =[UIColor whiteColor];
        
        NSArray * arr = @[action,action1];
        return arr;
    }
    else
    {
      
    }
   
    return array;
}
-(void)downMove:(NSIndexPath*)indexpath
{
    DynamicTopicTypeModel * model = self.dataArr[indexpath.row];
    [self.dataArr insertObject:model atIndex:indexpath.row+2];
    [self.dataArr removeObjectAtIndex:indexpath.row];
    
    NSString * strId = [NSString string];
    for (DynamicTopicTypeModel * model1 in self.dataArr) {
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
        [self.secondTable reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)moveToFirstIndexpath:(NSIndexPath*)indexpath
{
    DynamicTopicTypeModel * model = self.dataArr[indexpath.row];
    [self.dataArr removeObject:model];
    [self.dataArr insertObject:model atIndex:2];
    NSString * strId = [NSString string];
    for (DynamicTopicTypeModel * model1 in self.dataArr) {
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
        [self.secondTable reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        static NSString *cellId = @"ButtonMenuTableViewCell";
        ButtonMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ButtonMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.titleLabel.text = [self.dataArr[indexPath.row] industryName];
        cell.titleLabel.textColor = [UIColor blackColor];
        if (indexPath.row == 0) {
            cell.redDot.hidden = YES;
            cell.tipView.hidden = YES;
        }
        if (indexPath.row == 0) {
            if (self.isNew) {
              cell.redDot.hidden = NO;
            }
            else
            {
                cell.redDot.hidden = YES;
            }
        }
        if (indexPath.row == 1) {
            if (self.isFriend) {
                cell.redDot.hidden = NO;
            }
            else
            {
                cell.redDot.hidden = YES;
            }
        }
        
        if (indexPath.row == self.seleteIndex2) {
            cell.titleLabel.textColor = RGB(0, 172, 255);
        }
//        if (self.imageString.length&&indexPath.row == 1) {
//            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:self.imageString]]];
//        }
//        else
//        {
//            cell.iconImage.image = nil;
//        }
        return cell;
    } else {
        ButtonMenuCollectionCell *cell = [ButtonMenuCollectionCell cellWithTableView:tableView];
        cell.model = self.dataArr[indexPath.row];
        cell.titleLabel.textColor = [UIColor blackColor];
        if (indexPath.row == self.seleteIndex1) {
            cell.selectImage.hidden = NO;
        }
        
//        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCell:)];
//        longPress.minimumPressDuration = 0.5;
//        [cell addGestureRecognizer:longPress];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return kHEIGHT(43);
    } else {
        return kHEIGHT(58);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController * menuControll = [UIMenuController sharedMenuController];
    [menuControll setMenuVisible:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(RSButtonMenuDelegate:selectMenu: selectIndex:)]) {
        [self.delegate RSButtonMenuDelegate:self.dataArr[indexPath.row] selectMenu:self selectIndex:indexPath.row];
    }
}

#pragma  mark 点击长按
-(void)longPressCell:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        

        
        [self becomeFirstResponder];
        if (_currentCell) {
            _FirstcurrentCell = _currentCell;
        }
        
        _currentCell = (ButtonMenuCollectionCell*)gesture.view;
        _currentCell.selected = YES;

        if (_FirstcurrentCell != _currentCell) {
            _FirstcurrentCell.selected = NO;
        }
        
        UIMenuController * menuControll = [UIMenuController sharedMenuController];
        [menuControll setMenuVisible:NO];
        
        UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"排序" action:@selector(reOrder)];
        
        menuControll.menuItems = nil;
        [menuControll setMenuItems:@[item]];
        
        [menuControll setTargetRect:_currentCell.frame inView:_currentCell.superview];
        [menuControll setMenuVisible:YES animated:YES];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        
       
    }
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(reOrder)){
        
        return YES;
        
    }
    
    return NO;//隐藏系统默认的菜单项
}
-(void)reOrder
{
    _currentCell.selected = NO;
}
-(void)handleMenuWillShowNotification:(id)objc
{
    if (_FirstcurrentCell == _currentCell) {
        _FirstcurrentCell.selected = YES;
    }
    else
    {
        _FirstcurrentCell.selected = NO;
        _currentCell.selected = YES;
     }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
}
-(void)WillHideMenu:(id)objc
{
    
    if (_FirstcurrentCell)
    {
        _FirstcurrentCell.selected = NO;
    }
    else
    {
      _currentCell.selected = NO;
    }
   

}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (UIView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
        _buttonView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchHide) {
        self.touchHide();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
