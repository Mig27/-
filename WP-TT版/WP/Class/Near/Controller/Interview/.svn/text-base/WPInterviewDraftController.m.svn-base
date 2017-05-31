//
//  WPInterviewDraftController.m
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewDraftController.h"
#import "WPUserListModel.h"
#import "WPDraftListModel.h"
#import "WPInterviewListCell.h"
#import "UICollectionView+EmptyData.h"
#import "WPInterviewDraftEditController.h"

@interface WPInterviewDraftController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WPInterviewListCellDelegate>

#pragma mark - UI层变量
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *bottomView;

#pragma mark - 数据层变量
@property (strong, nonatomic) NSMutableArray *arr;



#pragma mark - 被选中User
@property (strong, nonatomic) WPUserListModel *selectedModel;

@end

@implementation WPInterviewDraftController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"草稿";
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - 网络层
- (void)requestUserInfo:(DealsSuccessBlock)success error:(DealsErrorBlock)dealError{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetResumeDraftList",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"]};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            WPDraftListModel *model = [WPDraftListModel mj_objectWithKeyValues:json];
            for (WPDraftListContentModel *contentModel in model.draftList) {
                contentModel.itemIsSelected = NO;
            }
            success(model.draftList,(int)model.draftList.count);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
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
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) collectionViewLayout:flowLayout];
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
//                    [MBProgressHUD createHUD:@"没有草稿信息" View:self.view];
                }
            } error:^(NSError *error) {
            }];
            [unself.collectionView.mj_header endRefreshing];
        }];
        
        [_collectionView.mj_header beginRefreshing];
        
        [_collectionView registerClass:[WPInterviewListCell class] forCellWithReuseIdentifier:@"WPInterviewListCell"];
    }
    return _collectionView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        previewBtn.frame = CGRectMake(10, 0, 120, _bottomView.height);
        previewBtn.tag = 1000;
        [previewBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [previewBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        [previewBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [previewBtn addTarget:self action:@selector(chooseAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:previewBtn];
        
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.frame = CGRectMake(SCREEN_WIDTH-_bottomView.height-10, 0, _bottomView.height, _bottomView.height);
        completeBtn.titleLabel.font = kFONT(14);
        [completeBtn normalTitle:@"删除" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [completeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [completeBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:completeBtn];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
        
        [self.view addSubview:_bottomView];
    }
    return nil;
}

#pragma mark - CollectionView代理函数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView collectionViewDisplayWitMsg:@"暂无草稿信息" ifNecessaryForRowCount:self.arr.count];
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
    cell.label.hidden = YES;
    cell.editLabel.hidden = NO; 
    cell.imageV.hidden = NO;
    [cell initWithSubViews:indexPath];
    [cell updateData:listModel];
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WS(ws);
    [self getInterviewResumeDraftDetail:self.arr[indexPath.row] success:^(WPInterviewDraftInfoModel *model) {
        //if (self.delegate) {
            //[ws.delegate returnDraftToInterviewController:model];
            //[ws.navigationController popViewControllerAnimated:YES];
        //}
        WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
        edit.type = WPInterviewEditTypeDraft;
        edit.draftInfoModel = model;
        [ws.navigationController pushViewController:edit animated:YES];
    }];
}

#pragma mark - Cell代理函数
#pragma mark 点击编辑
-(void)didEditItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark 点击选择
- (void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    for (WPUserListModel *model in self.arr) {
    //        model.userIsSelected = NO;
    //    }
//    BOOL isLastSelected = NO;
//    for (int i = 0; i < self.arr.count; i++) {
//        WPUserListModel *model = self.arr[i];
//        if (model.userIsSelected) {
//            model.userIsSelected = NO;
//            isLastSelected = (indexPath.row==i?YES:NO);
//        }
//    }
//    WPUserListModel *model = self.arr[indexPath.row];
//    model.userIsSelected = !isLastSelected;
//    _selectedModel = model;
    
    for (int i = 0; i < self.arr.count; i++) {
        WPDraftListContentModel *model = self.arr[i];
        (indexPath.row == i?model.itemIsSelected = !model.itemIsSelected:0);
    }
    [self.collectionView reloadData];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1000];
    button.selected = [self judgeAllIsSelected];
}

- (void)chooseAllAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    for (WPDraftListContentModel *model in self.arr) {
        model.itemIsSelected = sender.selected;
    }
    [self.collectionView reloadData];
}

- (void)completeAction:(UIButton *)sender{
    
    NSString *str = [IPADDRESS stringByAppendingFormat:@"/ios/resume_new.ashx"];
    
    NSString *arr = @"";
    for (WPDraftListContentModel *model in self.arr) {
        if (model.itemIsSelected) {
            arr = [NSString stringWithFormat:@"%@%@,",arr,model.resumeId];
        }
    }
    
    if (![arr isEqualToString:@""]) {
        NSDictionary *params = @{@"action":@"BatchDeleteResumeDraft",
                                 @"username":kShareModel.username,
                                 @"password":kShareModel.password,
                                 @"user_id":kShareModel.userId,
                                 @"resumeList":[arr substringToIndex:arr.length-1]};
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:str params:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            [self.collectionView.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",error.localizedDescription);
        }];
    }else{
        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择要删除的草稿" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }

//    if ([self judgeSelectedUserIsExisted]) {
//        if (self.delegate) {
//            [self.delegate returnDraftToInterviewController:_selectedModel];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }else{
//        
//        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个用户！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
//    }
}

- (void)getInterviewResumeDraftDetail:(WPDraftListContentModel *)draftModel success:(void (^)(WPInterviewDraftInfoModel *model))success{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"resume_id":draftModel.resumeId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPInterviewDraftInfoModel *model = [WPInterviewDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
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

- (BOOL)judgeAllIsSelected{
    for (WPDraftListContentModel *model in self.arr) {
        if (!model.itemIsSelected) {
            return NO;
        }
    }
    return YES;
}

@end
