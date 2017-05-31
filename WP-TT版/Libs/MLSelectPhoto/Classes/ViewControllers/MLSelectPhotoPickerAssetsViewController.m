//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  ZLPhotoPickerAssetsViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-12.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoPickerGroup.h"
#import "MLSelectPhotoPickerDatas.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoPickerCollectionView.h"
#import "MLSelectPhotoPickerCollectionViewCell.h"
#import "MLSelectPhotoPickerFooterCollectionReusableView.h"
#import "MLSelectPhotoBrowserViewController.h"

static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOOLBAR_HEIGHT = 44;

static NSString *const _cellIdentifier = @"cell";
static NSString *const _footerIdentifier = @"FooterView";
static NSString *const _identifier = @"toolBarThumbCollectionViewCell";

@interface MLSelectPhotoPickerAssetsViewController () <ZLPhotoPickerCollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

// View
@property (nonatomic , strong) MLSelectPhotoPickerCollectionView *collectionView;
// 标记View
@property (strong,nonatomic) UILabel *makeView;
@property (strong,nonatomic) UIButton *previewBtn;
@property (strong,nonatomic) UIButton *doneBtn;
@property (strong,nonatomic) UIToolbar *toolBar;
// Datas
@property (assign,nonatomic) NSUInteger privateTempMinCount;
// 数据源
@property (strong,nonatomic) NSMutableArray *assets;
// 记录选中的assets
@property (strong,nonatomic) NSMutableArray *selectAssets;
@property (nonatomic, strong) UIButton * cancelBtn;
@end

@implementation MLSelectPhotoPickerAssetsViewController

#pragma mark - getter
#pragma mark Get Data
- (NSMutableArray *)selectAssets{
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
}
-(UIButton*)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _cancelBtn.enabled = YES;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _cancelBtn.frame = CGRectMake(0, 0, 45, 45);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
#pragma mark Get View
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.makeView];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UIButton *)previewBtn{
    if (!_previewBtn) {
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        previewBtn.enabled = YES;
        previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        previewBtn.frame = CGRectMake(0, 0, 45, 45);
        [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
//        [previewBtn addSubview:self.makeView];
        self.previewBtn = previewBtn;
    }
    return _previewBtn;
}

- (void)setSelectPickerAssets:(NSArray *)selectPickerAssets{
    NSSet *set = [NSSet setWithArray:selectPickerAssets];
    _selectPickerAssets = [set allObjects];
    
    if (!self.assets) {
        self.assets = [NSMutableArray arrayWithArray:selectPickerAssets];
    }else{
        [self.assets addObjectsFromArray:selectPickerAssets];
    }
    
    for (MLSelectPhotoAssets *assets in selectPickerAssets) {
        if ([assets isKindOfClass:[MLSelectPhotoAssets class]]) {
            if (self.isRegist) {
                assets.isThumbOrOrginal = YES;
            }
            [self.selectAssets addObject:assets];
        }
    }
  
    self.collectionView.lastDataArray = nil;
    self.collectionView.isRecoderSelectPicker = YES;
    self.collectionView.selectAsstes = self.selectAssets;
    NSInteger count = self.selectAssets.count;
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.doneBtn.enabled = (count > 0);
    self.previewBtn.enabled = (count > 0);
}

#pragma mark collectionView
- (MLSelectPhotoPickerCollectionView *)collectionView{
    if (!_collectionView) {
        
      
        
        CGFloat cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2);
        
        MLSelectPhotoPickerCollectionView *collectionView = [[MLSelectPhotoPickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        __weak typeof(collectionView) wealView = collectionView;
        
        //点击跳到预览界面
        collectionView.didSelectedPhoto = ^(NSMutableArray*muarray,NSIndexPath*indexPath){
            MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
            browserVc.isFromChat = self.isFromChat;
            browserVc.isRegist = self.isRegist;
            [browserVc setValue:@(YES) forKeyPath:@"isEditing"];
            browserVc.isBrowers = YES;
            browserVc.browersIndex = indexPath;
            browserVc.isOriginal = self.isOriginal;
            browserVc.photos = muarray;
            
           //MLSelectPhotoAssets* asset = muarray[indexPath.row];
           // if (asset.isSelected) {
            //    NSLog(@"111111111");
           // }
           // else
            //{
            //    NSLog(@"00000000");
           // }
            
            browserVc.backOriginalPhoto = ^(BOOL isOrNot){
                wealView.isOriginal = isOrNot;
                self.isOriginal = isOrNot;
            };
            
            //预览界面点击选择和取消的回调
            browserVc.choiseImage = ^(NSIndexPath*index,BOOL isOrNot){
                    MLSelectPhotoAssets * asset = muarray[index.row];
                BOOL isExit = NO;
                for (MLSelectPhotoAssets * photo in self.selectAssets) {
                    if ([[[[photo.asset defaultRepresentation] url] absoluteString] isEqualToString:[[[asset.asset defaultRepresentation] url]absoluteString]]) {
                        isExit = YES;
                    }
                }
                if (isExit)
                {
                    if (!isOrNot) {
                        asset.isSelected = NO;
                        [self.collectionView.selectsIndexPath removeObject:@(index.row)];
                        [self.selectAssets removeObject:asset];
                        [self.collectionView.selectAsstes removeObject:asset];
                    }
                }
                else
                {
                    if (isOrNot) {
                        asset.isSelected = YES;
                        [self.collectionView.selectsIndexPath addObject:@(index.row)];
                        [self.selectAssets addObject:asset];
                        [self.collectionView.selectAsstes addObject:asset];
                    }
                }
                if (self.selectAssets.count) {
                    self.doneBtn.enabled = YES;
                    self.makeView.hidden = NO;
                    self.makeView.text = [NSString stringWithFormat:@"%ld",self.selectAssets.count];
                }
                else
                {
                    self.doneBtn.enabled = NO;
                    self.makeView.hidden = YES;
                    self.makeView.text = @"";
                }
                
                [self.collectionView reloadItemsAtIndexPaths:@[index]];
            };
            
            //点击浏览界面的返回的回调
            browserVc.backChoisePhoto = ^(NSMutableArray*selecArr){
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [self.selectAssets removeAllObjects];
//                    [self.collectionView.selectAsstes removeAllObjects];
//                    for (int i = 0 ; i < selecArr.count; i++) {
//                        NSIndexPath*index = selecArr[i];
//                        MLSelectPhotoAssets * asset = muarray[index.row];
//                        asset.isSelected = YES;
//                        [self.collectionView.selectsIndexPath addObject:@(index.row)];
//                        [self.selectAssets addObject:asset];
//                        [self.collectionView.selectAsstes addObject:asset];
//                    }
//                    self.collectionView.dataArray = muarray;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                       [self.collectionView reloadData];
//                       if (selecArr.count) {
//                            self.makeView.hidden = NO;
//                            self.makeView.text = [NSString stringWithFormat:@"%ld",selecArr.count];
//                        }
//                    });
//                });
            };
            [self.navigationController pushViewController:browserVc animated:YES];
            
        };
        // 时间置顶
        collectionView.status = ZLPickerCollectionViewShowOrderStatusTimeDesc;
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [collectionView registerClass:[MLSelectPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        // 底部的View
        [collectionView registerClass:[MLSelectPhotoPickerFooterCollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier];
        
        collectionView.contentInset = UIEdgeInsetsMake(5, 0,TOOLBAR_HEIGHT, 0);
        collectionView.collectionViewDelegate = self;
        [self.view insertSubview:collectionView belowSubview:self.toolBar];
        self.collectionView = collectionView;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
        
        NSString *widthVfl = @"H:|-0-[collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
        
        NSString *heightVfl = @"V:|-0-[collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
        
    }
    return _collectionView;
}

#pragma mark makeView 红点标记View
- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-20, 12, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
//        makeView.backgroundColor = [UIColor redColor];
        makeView.backgroundColor = RGB(0, 172, 255);
        [self.view addSubview:makeView];
        self.makeView = makeView;
    }
    return _makeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bounds = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化按钮
    [self setupButtons];
//    self.title = @"相机胶卷";
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    label.text = @"相机胶卷";
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = kFONT(15);
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.translucent = NO;
    // 初始化底部ToorBar
    [self setupToorBar];
}


#pragma mark - setter
#pragma mark 初始化按钮
- (void) setupButtons
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    //    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToFromViewController) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"相册";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
}
-(void)backToFromViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 初始化所有的组
- (void) setupAssets{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }
    
    __block NSMutableArray *assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[MLSelectPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            MLSelectPhotoAssets *zlAsset = [[MLSelectPhotoAssets alloc] init];
            zlAsset.asset = asset;
            [assetsM addObject:zlAsset];
        }];
        
        weakSelf.collectionView.dataArray = assetsM;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
    }];
}

#pragma mark -初始化底部ToorBar
- (void) setupToorBar{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    self.toolBar.translucent = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    // 左视图 中间距 右视图
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.previewBtn];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelBtn];
    toorBar.items = @[leftItem,fiexItem,rightItem];
}

#pragma mark - setter
-(void)setMinCount:(NSInteger)minCount{
    _minCount = minCount;
    
    if (!_privateTempMinCount) {
        _privateTempMinCount = minCount;
    }

    if (self.selectAssets.count == minCount){
        minCount = 0;
    }else if (self.selectPickerAssets.count - self.selectAssets.count > 0) {
        minCount = _privateTempMinCount;
    }
    
    self.collectionView.minCount = minCount;
}

- (void)setAssetsGroup:(MLSelectPhotoPickerGroup *)assetsGroup{
    if (!assetsGroup.groupName.length) return ;
    
    _assetsGroup = assetsGroup;
    
    self.title = assetsGroup.groupName;
    
    // 获取Assets
    [self setupAssets];
}

- (void)pickerCollectionViewDidCameraSelect:(MLSelectPhotoPickerCollectionView *)pickerCollectionView{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
        ctrl.delegate = self;
        ctrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ctrl animated:YES completion:nil];
    }else{
        NSLog(@"请在真机使用!");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 处理
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        
        [self.assets addObject:image];
        [self.selectAssets addObject:image];
        
        NSInteger count = self.selectAssets.count;
        self.makeView.hidden = !count;
        self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
        self.doneBtn.enabled = (count > 0);
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"请在真机使用!");
    }
}

#pragma mark  点击预览
- (void)preview{
    MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
    browserVc.isFromChat = self.isFromChat;
    browserVc.isRegist = self.isRegist;
    [browserVc setValue:@(YES) forKeyPath:@"isEditing"];
    browserVc.photos = self.selectAssets;
    browserVc.isOriginal = self.isOriginal;
    browserVc.backOriginalPhoto = ^(BOOL isOrNot){
        self.isOriginal = isOrNot;
    };
//    for (id objc in self.selectAssets) {
//        if ([objc isKindOfClass:[MLSelectPhotoAssets class]]) {
//            MLSelectPhotoAssets * asset = (MLSelectPhotoAssets*)objc;
//            
//        }
//    }
    
    
    [self.navigationController pushViewController:browserVc animated:YES];
}

- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker{
    _topShowPhotoPicker = topShowPhotoPicker;
    
    if (self.topShowPhotoPicker == YES) {
       
        NSMutableArray *reSortArray= [[NSMutableArray alloc] init];
        for (id obj in [self.collectionView.dataArray reverseObjectEnumerator]) {
            [reSortArray addObject:obj];
        }
        
        MLSelectPhotoAssets *mlAsset = [[MLSelectPhotoAssets alloc] init];
        [reSortArray insertObject:mlAsset atIndex:0];
        self.collectionView.status = ZLPickerCollectionViewShowOrderStatusTimeAsc;
        self.collectionView.topShowPhotoPicker = topShowPhotoPicker;
        self.collectionView.dataArray = reSortArray;
        [self.collectionView reloadData];
    }
}

//点击选择图片
- (void) pickerCollectionViewDidSelected:(MLSelectPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(MLSelectPhotoAssets *)deleteAssets{
    [self.makeView.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    if (self.selectPickerAssets.count == 0){
        self.selectAssets = [NSMutableArray arrayWithArray:pickerCollectionView.selectAsstes];
    }else if (deleteAssets == nil){
        [self.selectAssets addObject:[pickerCollectionView.selectAsstes lastObject]];
    }
    NSInteger count = self.selectAssets.count;
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.doneBtn.enabled = (count > 0);
    self.previewBtn.enabled = (count > 0);
    if (self.selectPickerAssets.count || deleteAssets) {
        MLSelectPhotoAssets *asset = [pickerCollectionView.lastDataArray lastObject];
        if (deleteAssets){
            asset = deleteAssets;
        }
        NSInteger selectAssetsCurrentPage = -1;
        for (NSInteger i = 0; i < self.selectAssets.count; i++) {
            MLSelectPhotoAssets *photoAsset = self.selectAssets[i];
            if([[[[asset.asset defaultRepresentation] url] absoluteString] isEqualToString:[[[photoAsset.asset defaultRepresentation] url] absoluteString]]){
                selectAssetsCurrentPage = i;
                break;
            }
        }
        if ( (self.selectAssets.count > selectAssetsCurrentPage) && (selectAssetsCurrentPage >= 0) ){
            if (deleteAssets){
                [self.selectAssets removeObjectAtIndex:selectAssetsCurrentPage];
            }
            [self.collectionView.selectsIndexPath removeObject:@(selectAssetsCurrentPage)];
            self.makeView.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.selectAssets.count];
        }
        // 刷新下最小的页数
        self.minCount = self.selectAssets.count + (_privateTempMinCount - self.selectAssets.count);
    }
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectAssets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
    
    if (self.selectAssets.count > indexPath.item) {
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        
        imageView.tag = indexPath.item;
        imageView.image = [self.selectAssets[indexPath.item] thumbImage];
    }
    
    return cell;
}

#pragma mark -<Navigation Actions>
#pragma mark -开启异步通知
- (void) back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.selectAssets}];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc{
    // 赋值给上一个控制器
    self.groupVc.selectAsstes = self.selectAssets;
}

@end
