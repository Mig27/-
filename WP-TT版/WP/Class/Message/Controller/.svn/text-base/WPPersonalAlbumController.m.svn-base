//
//  WPPersonalAlbumController.m
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonalAlbumController.h"
#import "WPPersonalAlbumCell.h"
#import "WPGetPersonPhotoListHttp.h"
#import "MLPhotoBrowserPhoto.h"
#import "SPPhotoAsset.h"
#import "MLPhotoBrowserViewController.h"
#import "SPPhotoBrowser.h"
#import "WPIVManager.h"

static NSString *kWPPersonalAlbumCellIdentifier = @"kWPPersonalAlbumCellIdentifier";

@interface WPPersonalAlbumController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SPPhotoBrowserDelegate,MLPhotoBrowserViewControllerDelegate,MLPhotoBrowserViewControllerDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation WPPersonalAlbumController

-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return  _array;
}

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    [self initNav];
//    if (_isOrNot)
//    {
//        [self  getFriendPhoto];
//    }
//    else
//    {
       [self getFriendPhotoList];
//    }
   
    [self collectionView];
}
-(void)getFriendPhoto
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/personal_info.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"GetImgAndVideo",@"username":kShareModel.username,@"password":kShareModel.username,@"user_id":kShareModel.userId,@"fk_id":self.fk_id,@"fk_type":self.fk_type};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
       WPGetPersonPhotoListResult *result = [WPGetPersonPhotoListResult mj_objectWithKeyValues:json];
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:result.ImgPhoto];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark -  初始化UI
- (void)initNav{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromVC) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

-(void)backToFromVC{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.friend_id,@"UserId",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWebView" object:self userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 数据相关
-(void)getFriendPhotoList{
    WPShareModel *model = [WPShareModel sharedModel];
    WPGetPersonPhotoListParam *param = [[WPGetPersonPhotoListParam alloc] init];
    param.action = @"GetUserPhoto";
    param.user_id = self.friend_id;
    param.username = model.username;
    param.password = model.password;
    
    [WPGetPersonPhotoListHttp WPGetPersonPhotoListHttpWithParam:param success:^(WPGetPersonPhotoListResult *result){
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:result.ImgList];
            [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}


#pragma mark -- 设置布局,根据布局创建collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 4.0;
        CGFloat width = (SCREEN_WIDTH - 20)/4;
        layout.itemSize = CGSizeMake(width, width);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[WPPersonalAlbumCell class] forCellWithReuseIdentifier:kWPPersonalAlbumCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}



#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView     numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPPersonalAlbumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWPPersonalAlbumCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.item];
    
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    
    [self showPhotoBrowserWithPhotoArray:self.dataList withurlStr:[self.dataList[indexPath.item] original_path]];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - 查看图片
- (void)showPhotoBrowserWithPhotoArray:(NSArray *)array withurlStr:(NSString *)urlStr
{
    NSInteger count = array.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    [self removeAllImageViews];
    for (int i = 0; i<array.count; i++) {
        WPGlobalPhotoModel *model = array[i];
        NSString *url = [IPADDRESS stringByAppendingString:model.original_path];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        imageView.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
        imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.view addSubview:imageView];
        photo.toView = imageView;
        [self.array addObject:imageView];
        [self.view sendSubviewToBack:imageView];
        [photos addObject:photo];
    }
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.isNewZoom = YES;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:[self getCurrentIndexPathWithUrl:urlStr] inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:self];
}

- (NSInteger)getCurrentIndexPathWithUrl:(NSString *)urlStr
{
    int i = 0;
    for (Pohotolist *model in [WPIVManager sharedManager].model.ImgPhoto) {
        if ([model.original_path isEqualToString:urlStr]) {
            return i;
        }
        i++;
    }
    return 0;
}

- (void)removeAllImageViews
{
    for (UIImageView *imageView in self.array) {
        [imageView removeFromSuperview];
    }
}

@end
