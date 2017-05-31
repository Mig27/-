//
//  WPInterviewListController.m
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewListController.h"
#import "WPInterviewEditController.h"

#import "MJRefresh.h"
#import "WPInterviewListCell.h"
#import "WPDraftListModel.h"

@interface WPInterviewListController () <UICollectionViewDelegate,UICollectionViewDataSource,WPInterviewListCellDelegate,RefreshUserListDelegate>

#pragma mark - UI层变量
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *bottomView;
#pragma mark - 数据层变量
@property (strong, nonatomic) NSMutableArray *arr;
#pragma mark - 被选中User
@property (strong, nonatomic) WPDraftListContentModel *selectedModel;

@end

@implementation WPInterviewListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 32, 22);
    button1.titleLabel.font = kFONT(14);
    [button1 setTitle:@"完成" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button1 addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem= rightBarItem;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 网络层
- (void)requestUserInfo:(DealsSuccessBlock)success error:(DealsErrorBlock)dealError{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetMyResumeUser",@"username":model.username,@"password":model.password,@"user_id":model.userId};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            WPDraftListModel *model = [WPDraftListModel mj_objectWithKeyValues:json];
            for (WPDraftListContentModel *contentModel in model.list) {
                contentModel.itemIsSelected = NO;
            }
            success(model.list,(int)model.list.count);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}   

- (void)requesUserContentWithResumeUserId:(NSString *)resumeUserId success:(void(^)(WPUserListModel *listModel))success{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetResumeUserInfo",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"resume_user_id":resumeUserId};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        WPUserListModel *model = [WPUserListModel mj_objectWithKeyValues:json];
        if (!model.status) {
            success(model);
        }else{
            [MBProgressHUD showError:model.info toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 交互层 - 添加新求职者
- (void)addInterViewAction:(UIButton *)sender{
    WPInterviewEditController *edit = [[WPInterviewEditController alloc]init];
    edit.delegate = self;
    [edit setupSubViews];
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma mark - 数据层
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [[NSMutableArray alloc]init];
    }
    return _arr;
}

#pragma mark - UI层
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView setCollectionViewLayout:flowLayout];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WPColor(235, 235, 235);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        __weak __typeof(self) unself = self;
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView.mj_footer resetNoMoreData];
            [unself requestUserInfo:^(NSArray *datas, int more) {
                if (more!= 0) {
                    [unself.arr removeAllObjects];
                    [unself.arr addObjectsFromArray:datas];
                    [unself.collectionView reloadData];
                }else{
                    [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                }
            } error:^(NSError *error) {
            }];
            [unself.collectionView.mj_header endRefreshing];
        }];
        
        [_collectionView registerClass:[WPInterviewListCell class] forCellWithReuseIdentifier:@"WPInterviewListCell"];
    }
    return _collectionView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        previewBtn.frame = CGRectMake(0, 0, _bottomView.height, _bottomView.height);
        previewBtn.titleLabel.font = kFONT(12);
        [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [previewBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [previewBtn addTarget:self action:@selector(collectionView:didSelectItemAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:previewBtn];
        
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.frame = CGRectMake(SCREEN_WIDTH-_bottomView.height, 0, _bottomView.height, _bottomView.height);
        completeBtn.titleLabel.font = kFONT(12);
        [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [completeBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [completeBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:completeBtn];
        
//        [self.view addSubview:_bottomView];
    }
    return nil;
}

#pragma mark - CollectionView代理函数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    WPInterviewListCell *cell = [WPInterviewListCell cellectionView:collectionView IndexPath:indexPath];
    static NSString *cellId = @"WPInterviewListCell";
    WPInterviewListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    WPDraftListContentModel *listModel = self.arr[indexPath.row];
    [cell initWithSubViews:indexPath];
    [cell updateData:listModel];
    cell.delegate = self;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPInterviewEditController *edit = [[WPInterviewEditController alloc]init];
    edit.delegate = self;
    [edit setupSubViews];
    edit.title = @"个人信息";
    
    WPDraftListContentModel *contentModel = self.arr[indexPath.row];
    
    [self requesUserContentWithResumeUserId:contentModel.resumeUserId success:^(WPUserListModel *listModel) {
        edit.listModel = listModel;
        [self.navigationController pushViewController:edit animated:YES];
    }];
    
    
    
//    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
//        WPInterviewEditController *edit = [[WPInterviewEditController alloc]init];
//        edit.delegate = self;
//        [edit setupSubViews];
//        edit.title = @"个人信息";
//        edit.listModel = self.arr[indexPath.row];
//        [self.navigationController pushViewController:edit animated:YES];
//    }else{
//        if ([self judgeSelectedUserIsExisted]) {
//            WPInterviewEditController *edit = [[WPInterviewEditController alloc]init];
//            edit.delegate = self;
//            [edit setupSubViews];
//            edit.title = @"个人信息";
//            edit.listModel = _selectedModel;
//            [self.navigationController pushViewController:edit animated:YES];
//        }else{
//
//            [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个用户！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
//        }
//    }
}

#pragma mark - Cell代理函数
#pragma mark 点击编辑
- (void)didEditItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPInterviewEditController *edit = [[WPInterviewEditController alloc]init];
//    edit.delegate = self;
    [edit setupSubViews];
    edit.title = @"我的简历";
    edit.listModel = self.arr[indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
}
#pragma mark 点击选择
- (void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    for (WPUserListModel *model in self.arr) {
//        model.userIsSelected = NO;
//    }
    BOOL isLastSelected = NO;
    for (int i = 0; i < self.arr.count; i++) {
        WPDraftListContentModel *model = self.arr[i];
        if (model.itemIsSelected) {
            model.itemIsSelected = NO;
            isLastSelected = (indexPath.row==i?YES:NO);
        }
    }
    WPDraftListContentModel *model = self.arr[indexPath.row];
    model.itemIsSelected = !isLastSelected;
    _selectedModel = model;
    [self.collectionView reloadData];
}

- (void)completeAction:(UIButton *)sender{
    
    if ([self judgeSelectedUserIsExisted]) {
        if (self.delegate) {
            [self requesUserContentWithResumeUserId:_selectedModel.resumeUserId success:^(WPUserListModel *listModel) {
                [self.delegate WPInterviewListController:listModel];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else{

        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个用户！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }
}

#pragma mark - 编辑界面回调刷新函数
//- (void)refreshUserListDelegate{
//    [self.collectionView.mj_header beginRefreshing];
//}
- (void)refreshUserListDelegate:(WPUserListModel *)model{
    [self.collectionView.mj_header beginRefreshing];
}

- (BOOL)judgeSelectedUserIsExisted{
    for (WPDraftListContentModel *model in self.arr) {
        if (model.itemIsSelected) {
            return YES;
        }
    }
    return NO;
}

@end
