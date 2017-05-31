//
//  WPInterviewListController.m
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "MyResumeController.h"
#import "WPInterviewEditController.h"
#import "MyResumeEditController.h"

#import "MJRefresh.h"
#import "WPInterviewListCell.h"
#import "MyResumeCell.h"

@interface MyResumeController () <UICollectionViewDelegate,UICollectionViewDataSource,MyResumeCellDelegate,RefreshMyResumeDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arr;

@end

@implementation MyResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人简历";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(addInterViewAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)requestUserInfo:(DealsSuccessBlock)success error:(DealsErrorBlock)dealError{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetSignList",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"]};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        NSLog(@"****%@",json);
        if ([json[@"status"] isEqualToString:@"0"]) {
            NSArray *arr = json[@"signList"];
            NSMutableArray *result = [[NSMutableArray alloc]init];
            for (int i=0; i < arr.count; i++) {
                DefaultParamsModel *model = [DefaultParamsModel mj_objectWithKeyValues:arr[i]];
                [result addObject:model];
            }
            success(result,(int)result.count);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)addInterViewAction:(UIButton *)sender{
    MyResumeEditController *edit = [[MyResumeEditController alloc]init];
    edit.delegate = self;
    edit.title = @"创建求职者";
    edit.isEditing = NO;
    [edit setupSubViews];
    [self.navigationController pushViewController:edit animated:YES];
}

- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [[NSMutableArray alloc]init];
    }
    return _arr;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView setCollectionViewLayout:flowLayout];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
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

        [_collectionView registerClass:[MyResumeCell class] forCellWithReuseIdentifier:@"MyResumeCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    WPInterviewListCell *cell = [WPInterviewListCell cellectionView:collectionView IndexPath:indexPath];
    static NSString *cellId = @"MyResumeCell";
    MyResumeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    DefaultParamsModel *listModel = self.arr[indexPath.row];
    [cell initWithSubViews:indexPath];
    [cell updateData:listModel];
    cell.delegate = self;

    return cell;
}

- (void)didEditItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyResumeEditController *edit = [[MyResumeEditController alloc]init];
    edit.delegate = self;
    [edit setupSubViews];
    edit.title = @"我的求职者";
    edit.isEditing = YES;
    edit.listModel = self.arr[indexPath.row];
//    DefaultParamsModel *mdel = self.arr[indexPath.row];
//    NSLog(@"*****%ld",(long)indexPath.row);
//    for (PhotoList *list in mdel.Photo) {
//        NSLog(@"%@",[list thumb_path]);
//    }

    [self.navigationController pushViewController:edit animated:YES];
}

- (void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"5555555555");
    if (self.delegate) {
        [self.delegate WPInterviewListController:self.arr[indexPath.row]];
//        DefaultParamsModel *mdel = self.arr[indexPath.row];
//        NSLog(@"*****%ld",(long)indexPath.row);
//        for (PhotoList *list in mdel.Photo) {
//            NSLog(@"%@",[list thumb_path]);
//        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refreshUserListDelegate{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2, [MyResumeCell getCellHeight]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
