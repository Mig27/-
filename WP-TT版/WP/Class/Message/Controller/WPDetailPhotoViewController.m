//
//  WPDetailPhotoViewController.m
//  WP
//
//  Created by CC on 16/7/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDetailPhotoViewController.h"
#import "WPDetailPhotoCollectionViewCell.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "BaseModel.h"
#import "WPIVManager.h"


static NSString *kWPPersonalAlbumCellIdentifier = @"WPDetailPhotoCollectionViewCellIdentifier";

@interface WPDetailPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray * dataList;
@property (nonatomic,strong)NSMutableArray * array;

@end

@implementation WPDetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    [self initNav];
    [self  getFriendPhoto];
    [self collectionView];
}
-(void)getFriendPhoto
    {
        NSString * urlStr = [NSString stringWithFormat:@"%@/ios/personal_info.ashx",IPADDRESS];
        NSDictionary * dic = @{@"action":@"GetImgAndVideo",@"username":kShareModel.username,@"password":kShareModel.username,@"user_id":kShareModel.userId,@"fk_id":self.fk_id,@"fk_type":self.fk_type};
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:json[@"ImgPhoto"]];
            [self.collectionView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
}
-(NSMutableArray*)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
-(NSMutableArray*)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
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
-(void)backToFromVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [_collectionView registerClass:[WPDetailPhotoCollectionViewCell class] forCellWithReuseIdentifier:kWPPersonalAlbumCellIdentifier];
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
    WPDetailPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWPPersonalAlbumCellIdentifier forIndexPath:indexPath];
//    cell.model = self.dataList[indexPath.item];
    [cell setModel:self.dataList[indexPath.item]];
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
    NSDictionary * dic = self.dataList[indexPath.item];
    [self showPhotoBrowserWithPhotoArray:self.dataList withurlStr:dic[@"original_path"]];
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
        NSDictionary * dic = array[i];
        NSString *url = [IPADDRESS stringByAppendingString:dic[@"original_path"]];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
