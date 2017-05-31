//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  MLSelectPhotoBrowserViewController.m
//  MLSelectPhoto
//
//  Created by 张磊 on 15/4/23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "MLSelectPhotoBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+MLExtension.h"
#import "MLSelectPhotoPickerBrowserPhotoScrollView.h"
#import "MLSelectPhotoCommon.h"
#import "UIImage+MLTint.h"
#import "HJCActionSheet.h"

// 分页控制器的高度
static NSInteger ZLPickerColletionViewPadding = 20;
static NSString *_cellIdentifier = @"collectionViewCell";

@interface MLSelectPhotoBrowserViewController () <UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,HJCActionSheetDelegate>

// 控件
@property (strong,nonatomic)    UIButton         *deleleBtn;
@property (weak,nonatomic)      UIButton         *backBtn;
@property (weak,nonatomic)      UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *settingButton;

// 标记View
@property (strong,nonatomic)    UIToolbar *toolBar;
@property (weak,nonatomic)      UILabel *makeView;
@property (strong,nonatomic)    UIButton *doneBtn;
@property (nonatomic, strong)   UIButton *originalPictureBtn;

@property (strong,nonatomic)    NSMutableDictionary *deleteAssets;
@property (strong,nonatomic)    NSMutableArray *doneAssets;
@property (strong,nonatomic)    NSMutableArray *preViewAssets;   //预览时候的图片数组

// 是否是编辑模式
@property (assign,nonatomic) BOOL isEditing;
@property (assign,nonatomic) BOOL isHidden;
@property (assign,nonatomic) BOOL isShowShowSheet;
@property (nonatomic, strong) NSMutableArray*indexArray;


@end

@implementation MLSelectPhotoBrowserViewController

#pragma mark - getter
#pragma mark collectionView
-(NSMutableDictionary *)deleteAssets{
    if (!_deleteAssets) {
        _deleteAssets = [NSMutableDictionary dictionary];
    }
    return _deleteAssets;
}

- (NSMutableArray *)doneAssets{
    if (!_doneAssets) {
        _doneAssets = [NSMutableArray array];
    }
    return _doneAssets;
}
-(NSMutableArray*)indexArray
{
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}
- (NSMutableArray *)preViewAssets
{
    if (!_preViewAssets) {
        _preViewAssets = [NSMutableArray array];
    }
    return _preViewAssets;
}
-(UIButton*)originalPictureBtn
{
    
    if (!_originalPictureBtn) {
        _originalPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_originalPictureBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_originalPictureBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [_originalPictureBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_originalPictureBtn setImage:[UIImage imageNamed:@"tupian_xuanze_pre"] forState:UIControlStateSelected];
        [_originalPictureBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [_originalPictureBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        _originalPictureBtn.titleLabel.font = kFONT(15);
        [_originalPictureBtn addTarget:self action:@selector(clickPictureBnt:) forControlEvents:UIControlEventTouchUpInside];
        _originalPictureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _originalPictureBtn.frame = CGRectMake(kHEIGHT(10), 0, 90, 44);
        if (self.isOriginal) {
            _originalPictureBtn.selected = YES;
        }
    }
    else
    {
        if (self.isOriginal) {
            _originalPictureBtn.selected = YES;
        }
    }
    return _originalPictureBtn;
}
#pragma mark 点击原图
-(void)clickPictureBnt:(UIButton*)sender
{
    
    int num= self.collectionView.contentOffset.x/(SCREEN_WIDTH+ZLPickerColletionViewPadding);
    NSIndexPath * index = [NSIndexPath indexPathForRow:num inSection:0];
    MLSelectPhotoAssets * asset = self.photos[num];
    if (!asset.isSelected) {
        [self.indexArray addObject:index];
        asset.isSelected = YES;
        [self.doneAssets addObject:asset];
        [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    sender.selected = !sender.selected;
    for (id objc in self.doneAssets) {
        if ([objc isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoAssets * asset = (MLSelectPhotoAssets*)objc;
            asset.isThumbOrOrginal = sender.selected;
        }
    }
    self.isOriginal = sender.selected;
    if (sender.selected) {
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = ZLPickerColletionViewPadding;
        flowLayout.itemSize = self.view.ml_size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.ml_width + ZLPickerColletionViewPadding,self.view.ml_height) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-20)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        if (self.isEditing) {
            if (self.browersIndex) {
                if (!self.doneAssets.count) {
                    self.makeView.hidden = YES;
                }
                else
                {
                  self.makeView.hidden = NO;
                }
            }
            else
            {
             self.makeView.hidden = !(self.photos.count && self.isEditing);
            }
//            self.makeView.hidden = !(self.photos.count && self.isEditing);
            // 初始化底部ToorBar
            [self setupToorBar];
        }
        
        if (self.isPreView) {
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(preViewDelectClick)];
//            [self setupToorBar2];
            [self newPreviewImageWithRightItemOperation];
        }
        
        
        
    }
    return _collectionView;
}

- (UIButton *)settingButton{
    if (!_settingButton) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 200);
        NSString *title;
        if (self.comeType == MLSelectPhotoBroswerComeTypeDynamic) {
            title = @"设为首图";
        } else {
            title = @"设为头像";
        }
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(setCover) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        self.settingButton = rightBtn;
        _settingButton = rightBtn;
        
    }
    return _settingButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        //        previewBtn.enabled = YES;
        previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        previewBtn.frame = CGRectMake(0, 0, 45, 45);
        [previewBtn setTitle:@"删除" forState:UIControlStateNormal];
        [previewBtn addTarget:self action:@selector(preViewDelectClick) forControlEvents:UIControlEventTouchUpInside];
        [previewBtn addSubview:self.makeView];
        self.deleteButton = previewBtn;
    }
    return _deleteButton;
}

#pragma mark -初始化底部ToorBar
- (void) setupToorBar2{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    toorBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 左视图 中间距 右视图
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleteButton];
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    [rightItem setWidth:80];
    toorBar.items = @[leftItem,fiexItem,rightItem];
}

- (void)setCover
{
    id obj = [self.photos objectAtIndex:self.currentPage];
    [self.photos removeObjectAtIndex:self.currentPage];
    [self.photos insertObject:obj atIndex:0];
    if (self.needUpdataAssestBlock) {
        self.needUpdataAssestBlock(self.photos);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 预览的时候删除按钮点击事件
- (void)preViewDelectClick
{
    if (self.photos.count == 1) { //当前相册里只有一张图片了
        [self.photos removeAllObjects];
        if (self.needUpdataAssestBlock) {
            self.needUpdataAssestBlock(self.photos);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else { //不是只有一张图片
        [self.photos removeObjectAtIndex:self.currentPage];
        if (self.currentPage == 0) {
            self.currentPage = self.currentPage;
        } else {
            self.currentPage = self.currentPage - 1;
        }
        [self reloadDataWithFirst:NO];
    }
}

#pragma mark Get View
#pragma mark makeView 红点标记View
- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
//        makeView.frame = CGRectMake(-5, -5, 20, 20);
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

- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        if (self.isFromChat) {
            [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        }
        else
        {
           [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        }
//        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.makeView];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn{
    if (!_deleleBtn)
    {
        _deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleleBtn.frame = CGRectMake(0, 0, 30, 30);
        [_deleleBtn setImage:[UIImage imageNamed:@"common_xuanze"]  forState:UIControlStateNormal];//MLSelectPhotoSrcName(@"AssetsPickerChecked")
        [_deleleBtn addTarget:self action:@selector(deleteAsset) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleleBtn;
}

- (void)setPhotos:(NSMutableArray *)photos{
    _photos = photos;
    if (self.browersIndex) {
        _doneAssets = [NSMutableArray array];
        for (int i = 0 ; i < photos.count; i++) {
            MLSelectPhotoAssets * asset = photos[i];
            if (asset.isSelected) {
                NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
                [self.indexArray addObject:index];
                [_doneAssets addObject:asset];
            }
        }
        
        if (!_doneAssets.count) {
//            self.doneBtn.enabled = NO;
            self.makeView.hidden = YES;
        }
    }
    else
    {
      _doneAssets = [NSMutableArray arrayWithArray:photos];
    }
//    _doneAssets = [NSMutableArray arrayWithArray:photos];
    
    
    [self reloadDataWithFirst:YES];
//    self.makeView.text = [NSString stringWithFormat:@"%ld",self.photos.count];
    if (self.browersIndex.row>=0)
    {
        int num = 0;
        for (id objc in self.photos) {
            if ([objc isKindOfClass:[MLSelectPhotoAssets class]]) {
                MLSelectPhotoAssets * asset = (MLSelectPhotoAssets*)objc;
                if (asset.isSelected) {
                    ++num;
                }
            }
            else
            {
                ++num;
            }
            
            
        }
        if (num) {
           self.makeView.text = [NSString stringWithFormat:@"%d",num];
        }
    }
    else
    {
        self.makeView.text = [NSString stringWithFormat:@"%ld",self.photos.count];
    }
    
    
}

- (void)setSheet:(UIActionSheet *)sheet{
    _sheet = sheet;
    if (!sheet) {
        self.isShowShowSheet = NO;
    }
}

#pragma mark - Life cycle
- (void)dealloc{
    self.isShowShowSheet = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage creatUIImageWithColor:RGBA(1, 1, 1, 0.5)] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.translucent = YES;
    self.isHidden = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.preViewAssets = [NSMutableArray arrayWithArray:self.photos];
    self.view.backgroundColor = [UIColor clearColor];
  //  [self createBackButton];

    
    //self.collectionView.backgroundColor = [UIColor blueColor];
    
}
//
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
}





#pragma mark-添加返回按钮
-(void)createBackButton
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    //    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToFromViewController) forControlEvents:UIControlEventTouchUpInside];
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

- (void)backToFromViewController
{
    
    
    if (self.isPreView) {
        if (self.needUpdataAssestBlock) {
            self.needUpdataAssestBlock(self.photos);
        }
    }
    
    if (self.browersIndex) {
        if (self.backChoisePhoto) {
            self.backChoisePhoto(self.indexArray);
        }
    }
    if (self.backOriginalPhoto) {
        self.backOriginalPhoto(self.isOriginal);
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -初始化底部ToorBar
- (void) setupToorBar{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
//    toorBar.barTintColor = UIColorFromRGB(0x333333);
    toorBar.barTintColor = [UIColor whiteColor];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    toorBar.translucent = NO;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    // 左视图 中间距 右视图
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleleBtn];//self.doneBtn
    

    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.originalPictureBtn];
    
    
    
//    [toorBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 44)] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    if (self.isFromChat)
    {
      toorBar.items = @[leftItem,fiexItem,rightItem];
    }
    else
    {
      toorBar.items = @[fiexItem,rightItem];
    }
//    toorBar.items = @[leftItem,fiexItem,rightItem];
}

- (void)deleteAsset{
    
    NSString *currentPage = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSLog(@"当前选择页面是 %lu", self.currentPage);
    if (self.browersIndex) {
        int num = (self.collectionView.contentOffset.x + ZLPickerColletionViewPadding)/(SCREEN_WIDTH+ZLPickerColletionViewPadding);
        NSIndexPath * index = [NSIndexPath indexPathForRow:num inSection:0];
        MLSelectPhotoAssets * asset = self.photos[num];
        if (asset.isSelected) { //备选中---> 取消选中
            [self.indexArray removeObject:index];
            asset.isSelected = NO;
            [self.doneAssets removeObject:asset];
            [self.deleleBtn setImage:[[UIImage imageNamed:@"common_xuanze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        else
        {   //未被选中过 --> 变成选中
            if (self.indexArray.count==9) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"最多剩余只能选择9张图片" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            [self.indexArray addObject:index];
            asset.isSelected = YES;
            [self.doneAssets addObject:asset];
            [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        if (self.choiseImage) {
            self.choiseImage(index,asset.isSelected);
        }
        
        
    }
    else
    {
        if ([_deleteAssets valueForKeyPath:currentPage] == nil) {
            [self.deleteAssets setObject:@YES forKey:currentPage];
            [self.deleleBtn setImage:[[UIImage imageNamed:@"common_xuanze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            if ([self.doneAssets containsObject:[self.photos objectAtIndex:self.currentPage]]) {
                [self.doneAssets removeObject:[self.photos objectAtIndex:self.currentPage]];
            }
        }else{
            if (![self.doneAssets containsObject:[self.photos objectAtIndex:self.currentPage]]) {
                [self.doneAssets addObject:[self.photos objectAtIndex:self.currentPage]];
            }
            [self.deleteAssets removeObjectForKey:currentPage];
            [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
//    if ([_deleteAssets valueForKeyPath:currentPage] == nil) {
//        [self.deleteAssets setObject:@YES forKey:currentPage];
//        [self.deleleBtn setImage:[[UIImage imageNamed:@"common_xuanze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        if ([self.doneAssets containsObject:[self.photos objectAtIndex:self.currentPage]]) {
//            [self.doneAssets removeObject:[self.photos objectAtIndex:self.currentPage]];
//        }
//    }else{
//        if (![self.doneAssets containsObject:[self.photos objectAtIndex:self.currentPage]]) {
//            [self.doneAssets addObject:[self.photos objectAtIndex:self.currentPage]];
//        }
//        [self.deleteAssets removeObjectForKey:currentPage];
//        [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    }
    if (self.browersIndex) {
        if (self.doneAssets.count) {
            self.makeView.hidden = NO;
            self.doneBtn.enabled = YES;
            self.makeView.text = [NSString stringWithFormat:@"%ld",self.doneAssets.count];
        }
        else
        {
            self.makeView.hidden = YES;
        }
    }
    else
    {
      self.makeView.text = [NSString stringWithFormat:@"%ld",self.doneAssets.count];
    }
    
    
//    self.makeView.text = [NSString stringWithFormat:@"%ld",self.doneAssets.count];
}

#pragma mark - reloadData
- (void) reloadDataWithFirst:(BOOL) isFirst{
    
    //[self.collectionView reloadData];
    
    if (self.currentPage == 0 && isFirst) {
        self.currentPage = self.browersIndex.row;
    }
    if (self.currentPage >= 0) {
        CGFloat attachVal = 0;
        if (self.currentPage == self.photos.count - 1 && self.currentPage > 0) {
            attachVal = ZLPickerColletionViewPadding;
        }
        
        
        self.collectionView.ml_x = -attachVal;
        if (isFirst) {
            self.collectionView.contentOffset = CGPointMake(self.browersIndex.row * self.collectionView.ml_width, 0);
        }else{
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, 0);
        }
        
        if (self.currentPage == self.photos.count - 1 && self.photos.count > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(00.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, self.collectionView.contentOffset.y);
            });
        }
    }
//    if (!isFirst) {
//        [self.collectionView reloadData];
//    }
    
    // 添加自定义View
    [self setPageLabelPage:self.currentPage];
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    
    if (isEditing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];//self.deleleBtn
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (self.photos.count) {
        cell.backgroundColor = [UIColor clearColor];
        MLSelectPhotoAssets *photo = self.photos[indexPath.item]; //[self.dataSource photoBrowser:self photoAtIndex:indexPath.item];
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = cell.bounds;
        scrollBoxView.ml_y = cell.ml_y;
        [cell.contentView addSubview:scrollBoxView];
        
        MLSelectPhotoPickerBrowserPhotoScrollView *scrollView =  [[MLSelectPhotoPickerBrowserPhotoScrollView alloc] init];
        if (self.sheet || self.isShowShowSheet == YES) {
            scrollView.sheet = self.sheet;
        }
        scrollView.backgroundColor = [UIColor clearColor];
        // 为了监听单击photoView事件
        scrollView.frame = [UIScreen mainScreen].bounds;
        scrollView.photoScrollViewDelegate = self;
        scrollView.photo = photo;
        
        [scrollBoxView addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return cell;
}
// 单击调用
- (void) pickerPhotoScrollViewDidSingleClick:(MLSelectPhotoPickerBrowserPhotoScrollView *)photoScrollView{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
    if (self.isEditing || self.isPreView) {
        self.toolBar.hidden = !self.toolBar.isHidden;
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.toolBar.hidden = NO;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.sendNum  = (int)self.browersIndex.row;
    CGRect tempF = self.collectionView.frame;
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.ml_width) + 0.5);
    if (tempF.size.width < [UIScreen mainScreen].bounds.size.width){
        tempF.size.width = [UIScreen mainScreen].bounds.size.width;
    }
    
    if ((currentPage < self.photos.count -1) || self.photos.count == 1) {
        tempF.origin.x = 0;
    }else if(scrollView.isDragging){
        tempF.origin.x = -ZLPickerColletionViewPadding;
    }
    
    if (self.browersIndex)
    {
        int num = scrollView.contentOffset.x/(SCREEN_WIDTH+ZLPickerColletionViewPadding);
        MLSelectPhotoAssets * asset = self.photos[num];
        if (asset.isSelected) {
            [self.deleleBtn setImage:[UIImage imageNamed:@"tupian_xuanze_pre"] forState:UIControlStateNormal];
        }
        else
        {
            [self.deleleBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if([[self.deleteAssets allValues] count] == 0 || [self.deleteAssets valueForKeyPath:[NSString stringWithFormat:@"%ld",(currentPage)]] == nil){
            [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else{
            [self.deleleBtn setImage:[[UIImage imageNamed:@"common_xuanze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
    
    
//    if([[self.deleteAssets allValues] count] == 0 || [self.deleteAssets valueForKeyPath:[NSString stringWithFormat:@"%ld",(currentPage)]] == nil){
//        [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    }else{
//        [self.deleleBtn setImage:[[UIImage imageNamed:@"common_xuanze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    }
    
        self.collectionView.frame = tempF;
    if (self.isBrowers) {
        [self.collectionView setContentOffset:CGPointMake((SCREEN_WIDTH+ZLPickerColletionViewPadding)*self.browersIndex.row, 0)];
        self.isBrowers = NO;
        /*
        MLSelectPhotoAssets * asset = self.photos[self.browersIndex.row];
        if (asset.isSelected) {
            [self.deleleBtn setImage:[UIImage imageNamed:@"tupian_xuanze_pre"] forState:UIControlStateNormal];
        }
         */
        
    }

    //common_xuanze
 
}

- (void)done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        if (self.isFromChat) {
//            if (!self.doneAssets.count) {
//                [self.doneAssets addObject:self.photos[self.sendNum]];
        if (!self.doneAssets.count) {
            NSInteger  pageCurrent =  (self.collectionView.contentOffset.x + ZLPickerColletionViewPadding)/(SCREEN_WIDTH+ZLPickerColletionViewPadding);;
            [self.doneAssets addObject:self.photos[pageCurrent]];
        }
//            }
//        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.doneAssets}];
        NSLog(@"%@",self.doneAssets);
    });
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)setPageLabelPage:(NSInteger)page{
//    self.title = [NSString stringWithFormat:@"%ld / %ld",page + 1, self.photos.count];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"预览";
    titleLabel.font = kFONT(15);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor= [UIColor blackColor];
    self.navigationItem.titleView = titleLabel;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)scrollView.contentOffset.x / (scrollView.ml_width - ZLPickerColletionViewPadding);
    if (currentPage == self.photos.count - 1 && currentPage != self.currentPage && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    }
    self.currentPage = currentPage;
    NSLog(@"当前页是  === %ld",(long)self.currentPage);
    [self setPageLabelPage:currentPage];
    
    
    self.sendNum = scrollView.contentOffset.x/(SCREEN_WIDTH+ZLPickerColletionViewPadding);
    
//    if (self.browersIndex) {
//        int num =(int)scrollView.contentOffset.x/(SCREEN_WIDTH+ZLPickerColletionViewPadding);
//        MLSelectPhotoAssets * asset = self.photos[num];
//        if (asset.isSelected) {
//            [self.deleleBtn setImage:[UIImage imageNamed:@"tupian_xuanze_pre"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [self.deleleBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
//        }
//    }
    
    int num = (self.collectionView.contentOffset.x + ZLPickerColletionViewPadding)/(SCREEN_WIDTH+ZLPickerColletionViewPadding);
   // NSIndexPath * index = [NSIndexPath indexPathForRow:num inSection:0];
    MLSelectPhotoAssets * asset = self.photos[num];
    if (asset.isSelected) { //备选中---> 取消选中
        [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    else
    {   //未被选中过 --> 变成选中
        [self.deleleBtn setImage:[[UIImage imageNamed:@"tupian_xuanze"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

#pragma mark 新的图片预览样式 
- (void)newPreviewImageWithRightItemOperation{

    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGENAMED(@"common_tishi") style:UIBarButtonItemStylePlain target:self action:@selector(shonNewPreviewImageA)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

//展示Asheet
- (void)shonNewPreviewImageA{
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从手机选择",@"设为首图",@"保存图片",@"删除", nil];
    // 2.显示出来
    [sheet show];
}

#pragma mark HJCActionSheetDelegate 代理方法
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1: //拍照
        {
            if (self.takePictureByCameraBlock) {
                self.takePictureByCameraBlock(buttonIndex);
                
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
            break;
        case 2: //从手机选择
        {
            if (self.takePictureByAlbumBlock) {
                self.takePictureByAlbumBlock(buttonIndex);
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
            break;
        case 3: //设为首图
        {
            id obj = [self.photos objectAtIndex:self.currentPage];
            [self.photos removeObjectAtIndex:self.currentPage];
            [self.photos insertObject:obj atIndex:0];
            if (self.needUpdataAssestBlock) {
                self.needUpdataAssestBlock(self.photos);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 4: //保存图片
        {
            if (self.savePictureToAlbumBlock) {
                self.savePictureToAlbumBlock(buttonIndex);
            }
        }
            break;
        case 5: //删除
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self preViewDelectClick];
            });
        }
            break;
            
            
        default:
            break;
    }
}



@end
