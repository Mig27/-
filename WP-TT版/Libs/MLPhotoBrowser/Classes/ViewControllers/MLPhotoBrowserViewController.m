//
//  MLPhotoBrowserViewController.m
//  MLPhotoBrowser
//
//  Created by 张磊 on 14-11-14.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLPhotoBrowserViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserDatas.h"
#import "MLPhotoBrowserPhotoScrollView.h"
#import "UIImage+MLBrowserPhotoImageForBundle.h"
#import "CollectViewController.h"
#import "ReportViewController.h"
#import "UIView+MLExtension.h"
#import "WPRecentLinkManController.h"
#import "MTTMessageEntity.h"
#import "SessionModule.h"
// 点击销毁的block
typedef void(^ZLPickerBrowserViewControllerTapDisMissBlock)(NSInteger);
static NSString *_cellIdentifier = @"collectionViewCell";

// 分页控制器的高度
static NSInteger const ZLPickerPageCtrlH = 43;
// ScrollView 滑动的间距
static CGFloat const ZLPickerColletionViewPadding = 20;


@interface MLPhotoBrowserViewController () <UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

// 控件
@property (strong,nonatomic) UIView           *bottomView;
@property (weak,nonatomic) UILabel          *pageLabel;
@property (weak,nonatomic) UIButton         *coverBtn;
@property (weak,nonatomic) UIButton         *deleleBtn;
@property (weak,nonatomic) UIButton         *backBtn;
@property (weak,nonatomic) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isHideOrNot;

// 数据相关
// 单击时执行销毁的block
@property (nonatomic , copy) ZLPickerBrowserViewControllerTapDisMissBlock disMissBlock;
// 装着所有的图片模型
//@property (nonatomic , strong) NSMutableArray *photos;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;

@end

@implementation MLPhotoBrowserViewController

#pragma mark - getter
#pragma mark photos
- (NSArray *)photos{
    if (!_photos) {
        _photos = [self getPhotos];
    }
    return _photos;
}

#pragma mark collectionView
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
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-20)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        [self.view addSubview:self.bottomView];
        self.pageLabel.hidden = NO;
        self.deleleBtn.hidden = !self.isEditing;
//        if (self.isEditing) {
//            NSLog(@"编辑");
//        } else {
//            NSLog(@"不编辑");
//        }
        self.coverBtn.hidden = !self.isEditing;
//        self.coverBtn.hidden = NO;
    }
    return _collectionView;
}

#pragma mark bottomView
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 43)];
//        _bottomView.backgroundColor = RGBA(0, 0, 0, 0);
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (BOOL)prefersStatusBarHidden{
    
    return YES; //返回NO表示要显示，返回YES将hiden
    
}

#pragma mark coverBtn
- (UIButton *)coverBtn
{
    if (!_coverBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setTitle:@"设为封面" forState:UIControlStateNormal];
        //        [deleleBtn setImage:[UIImage ml_imageFromBundleNamed:@"nav_delete_btn"] forState:UIControlStateNormal];

        // 设置阴影
        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
        deleleBtn.layer.shadowRadius = 3;
        deleleBtn.layer.shadowOpacity = 1.0;
        
        [deleleBtn addTarget:self action:@selector(cover) forControlEvents:UIControlEventTouchUpInside];
        deleleBtn.hidden = YES;
        [self.bottomView addSubview:deleleBtn];
        self.coverBtn = deleleBtn;
        
        NSString *widthVfl = @"H:[deleleBtn(80)]-margin-|";
        NSString *heightVfl = @"V:[deleleBtn(deleteBtnWH)]-margin-|";
        NSDictionary *metrics = @{@"deleteBtnWH":@(43),@"margin":@(0)};
        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
    }
    return _coverBtn;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn{
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [deleleBtn setImage:[UIImage ml_imageFromBundleNamed:@"nav_delete_btn"] forState:UIControlStateNormal];

        // 设置阴影
        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
        deleleBtn.layer.shadowRadius = 3;
        deleleBtn.layer.shadowOpacity = 1.0;
        
        [deleleBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        deleleBtn.hidden = YES;
        [self.bottomView addSubview:deleleBtn];
        self.deleleBtn = deleleBtn;
        
        NSString *widthVfl = @"H:|-margin-[deleleBtn(deleteBtnWH)]";
        NSString *heightVfl = @"V:[deleleBtn(deleteBtnWH)]-margin-|";
        NSDictionary *metrics = @{@"deleteBtnWH":@(43),@"margin":@(0)};
        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
        
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _deleleBtn;
}

#pragma mark pageLabel
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.bottomView addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        NSString *widthVfl = @"H:|-0-[pageLabel]-0-|";
        NSString *heightVfl = @"V:[pageLabel(ZLPickerPageCtrlH)]-0-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageLabel);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(ZLPickerPageCtrlH)};
        
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageLabel;
}

#pragma mark - Life cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    if (!self.photos.count) {
//        NSAssert(self.dataSource, @"你没成为数据源代理 或者 没传self.photos");
    }
    
    if (self.isNeedShow) {
        if (self.status != UIViewAnimationAnimationStatusNotAnimation){
            [self showToView];
        }
        self.isNeedShow = NO;
    }

}

- (void)dealloc{
    self.disMissBlock = nil;
    self.photos = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SpecialImgCollect" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SpecialImgRoport" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstPage = self.currentIndexPath.row;
    
    self.view.backgroundColor = [UIColor blackColor];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectNotification:) name:@"SpecialImgCollect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportNotification:) name:@"SpecialImgRoport" object:nil];
    
    //发送给朋友
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendeToFriends:) name:@"SENDIMAGETOWEIPINFRIENDS" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:@"loadImageSuccess" object:nil];

}
-(void)loadImage
{
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    UIView * view = [win viewWithTag:5555];
    view.hidden = YES;
//    if (view) {
//        [view removeFromSuperview];
//    }
    self.isHideOrNot = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - collect action
- (void)collectNotification:(NSNotification *)notification
{
    MLPhotoBrowserPhoto *photo = notification.userInfo[@"info"];
    NSString *subStr = [photo.photoURL.absoluteString substringFromIndex:IPADDRESS.length];
//    NSLog(@"%@----%@",photo.sid,subStr);
    CollectViewController *collect = [[CollectViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    collect.user_id = photo.user_id;
    collect.img_url = subStr;
    collect.collect_class = @"1";
//    collect.isFromChat = YES;
    [self.navigationController pushViewController:collect animated:YES];
}

- (void)reportNotification:(NSNotification *)notification
{
    MLPhotoBrowserPhoto *photo = notification.userInfo[@"info"];
    ReportViewController *collect = [[ReportViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    collect.speak_trends_id = photo.sid;
    collect.type = ReportTypeDynamice;
    [self.navigationController pushViewController:collect animated:YES];

}
-(void)sendeToFriends:(NSNotification*)notification
{
    self.navigationController.navigationBarHidden = NO;
    NSDictionary * dictionary = (NSDictionary*)notification.userInfo;
    MLPhotoBrowserPhoto * photo = dictionary[@"info"];
    NSString * photoUrl = [NSString stringWithFormat:@"%@",photo.photoURL];
    photoUrl = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,photoUrl];
    photoUrl = [NSString stringWithFormat:@"%@%@",photoUrl,DD_MESSAGE_IMAGE_SUFFIX];
    [self tranmitMessage:photoUrl andMessageType:DDMessageTypeImage andToUserId:@""];
}
-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId
{//DDMessageTypeText
    
    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    
    person.dataSource = muarray;
    person.toUserId = userId;
    person.transStr = messageContent;
    switch (type) {
        case DDMessageTypeText:
            person.display_type = @"1";
            break;
        case DDMEssageMyWant:
            person.display_type = @"9";
            break;
        case DDMEssageMyApply:
            person.display_type = @"8";
            break;
        case DDMEssageSHuoShuo:
            person.display_type = @"11";
            break;
        case DDMessageTypeImage:
            person.display_type = @"2";
            break;
        case DDMessageTypeVoice:
            person.display_type = @"3";
            break;
        case DDMEssageMuchMyWantAndApply:
            person.display_type = @"10";
            break;
        case DDMEssageEmotion:
            person.display_type = @"1";
            break;
        case DDMEssagePersonalaCard:
            person.display_type = @"6";
            break;
        case DDMEssageLitterVideo:
            person.display_type = @"7";
            break;
        case DDMEssageLitterInviteAndApply:
            person.display_type = @"12";
            break;
        case DDMEssageLitteralbume:
            person.display_type = @"13";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
#pragma mark - Get
#pragma mark getPhotos
- (NSArray *) getPhotos{
    NSMutableArray *photos = [NSMutableArray array];
    NSInteger section = self.currentIndexPath.section;
    NSInteger rows = [self.dataSource photoBrowser:self numberOfItemsInSection:section];
    for (NSInteger i = 0; i < rows; i++) {
        [photos addObject:[self.dataSource photoBrowser:self photoAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]]];
    }
    return photos;
}

#pragma mark get Controller.view
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

#pragma mark - reloadData
- (void)reloadData{
    
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndexPath.item;
    }else{
        self.currentPage--;
    }
    [self.collectionView reloadData];
    
    // 添加自定义View
    if ([self.delegate respondsToSelector:@selector(photoBrowserShowToolBarViewWithphotoBrowser:)]) {
        UIView *toolBarView = [self.delegate photoBrowserShowToolBarViewWithphotoBrowser:self];
        toolBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat width = self.view.frame.size.width;
        CGFloat x = self.view.frame.origin.x;
        if (toolBarView.frame.size.width) {
            width = toolBarView.frame.size.width;
        }
        if (toolBarView.frame.origin.x) {
            x = toolBarView.frame.origin.x;
        }
        toolBarView.frame = CGRectMake(x, self.view.frame.size.height - 44, width, 44);
        [self.view addSubview:toolBarView];
    }
    
//    if (self.currentPage >= 0) {
//        if (self.currentPage == self.photos.count - 1) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.frame.size.width, 0);
//            });
//        }else{
//            self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.frame.size.width, 0);
//        }
//        
//    }
    if (self.currentPage >= 0) {
        CGFloat attachVal = 0;
        if (self.currentPage == self.photos.count - 1 && self.currentPage > 0) {
            attachVal = ZLPickerColletionViewPadding;
        }
        
        self.collectionView.ml_x = -attachVal;
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, 0);
        
        if (self.currentPage == self.photos.count - 1 && self.photos.count > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(00.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, self.collectionView.contentOffset.y);
            });
        }
    }
    [self setPageLabelPage:self.currentPage];

}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ([self isDataSourceElsePhotos])?[self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section]:self.photos.count+1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    MLPhotoBrowserPhotoScrollView * scroller = nil;
    for (UIView * view in cell.contentView.subviews) {
        for (UIView * vie in view.subviews) {
            if ([vie isKindOfClass:[MLPhotoBrowserPhotoScrollView class]]) {
               scroller = (MLPhotoBrowserPhotoScrollView*)vie;
            }
        }
    }
    if (self.photos.count) {
        if (scroller)//cell上存在，不需要再创建
        {
            if (indexPath.row == self.photos.count) {
                return cell;
            }
            scroller.photo = nil;
            cell.backgroundColor = [UIColor clearColor];
            NSLog(@"%ld",(long)indexPath.item);
            MLPhotoBrowserPhoto *photo = self.photos[indexPath.item]; //[self.dataSource photoBrowser:self photoAtIndex:indexPath.item];
            if (self.firstPage == indexPath.row)
            {
                scroller.superview.ml_y = cell.ml_y + 37;//23
            }
            else
            {
                scroller.superview.ml_y = cell.ml_y;
            }
            scroller.sheet = self.sheet;
            scroller.hideCollection = self.hideCollection;
//            scroller.backgroundColor = [UIColor clearColor];
//            // 为了监听单击photoView事件
//            scroller.frame = [UIScreen mainScreen].bounds;
            scroller.photoScrollViewDelegate = self;
            
            if (self.firstPage == indexPath.row)
            {
                self.firstPage = -1;
            }
            else
            {
                scroller.photo = photo;
            }
            __weak typeof(scroller.superview)weakScrollBoxView = scroller.superview;
            __weak typeof(self)weakSelf = self;
            if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndexPath:)]) {
                [[scroller.superview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                scroller.callback = ^(id obj){
                    [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndexPath:indexPath];
                };
            }
        }
        else
        {
            if (indexPath.row == self.photos.count) {
                return cell;
            }
            cell.backgroundColor = [UIColor clearColor];
            NSLog(@"%ld",(long)indexPath.item);
            MLPhotoBrowserPhoto *photo = self.photos[indexPath.item]; //[self.dataSource photoBrowser:self photoAtIndex:indexPath.item];
            
            if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
                [[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            
            UIView *scrollBoxView = [[UIView alloc] init];
            scrollBoxView.frame = cell.bounds;
            if (self.firstPage == indexPath.row)
            {
                scrollBoxView.ml_y = cell.ml_y + 37;//23
            }
            else
            {
                scrollBoxView.ml_y = cell.ml_y;
            }
            [cell.contentView addSubview:scrollBoxView];
            MLPhotoBrowserPhotoScrollView *scrollView =  [[MLPhotoBrowserPhotoScrollView alloc] init];
            scrollView.sheet = self.sheet;
            scrollView.hideCollection = self.hideCollection;
            scrollView.backgroundColor = [UIColor clearColor];
            // 为了监听单击photoView事件
            scrollView.frame = [UIScreen mainScreen].bounds;
            scrollView.photoScrollViewDelegate = self;
            
            if (self.firstPage == indexPath.row)
            {
                self.firstPage = -1;
            }
            else
            {
                scrollView.photo = photo;
            }
            //        scrollView.photo = photo;
            __weak typeof(scrollBoxView)weakScrollBoxView = scrollBoxView;
            __weak typeof(self)weakSelf = self;
            if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndexPath:)]) {
                [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                scrollView.callback = ^(id obj){
                    [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndexPath:indexPath];
                };
            }
            [scrollBoxView addSubview:scrollView];
            scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 
        }
    }
    
  
    

    
    
//    if (self.photos.count) {
//        if (indexPath.row == self.photos.count) {
//            return cell;
//        }
//        cell.backgroundColor = [UIColor clearColor];
//        MLPhotoBrowserPhoto *photo = self.photos[indexPath.item]; //[self.dataSource photoBrowser:self photoAtIndex:indexPath.item];
//        
//        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
//            [[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//        
//        UIView *scrollBoxView = [[UIView alloc] init];
//        scrollBoxView.frame = cell.bounds;
//        if (self.firstPage == indexPath.row)
//        {
//            scrollBoxView.ml_y = cell.ml_y + 37;//23
//        }
//        else
//        {
//           scrollBoxView.ml_y = cell.ml_y;
//        }
//        [cell.contentView addSubview:scrollBoxView];
//        MLPhotoBrowserPhotoScrollView *scrollView =  [[MLPhotoBrowserPhotoScrollView alloc] init];
//        scrollView.sheet = self.sheet;
//        scrollView.hideCollection = self.hideCollection;
//        scrollView.backgroundColor = [UIColor clearColor];
//        // 为了监听单击photoView事件
//        scrollView.frame = [UIScreen mainScreen].bounds;
//        scrollView.photoScrollViewDelegate = self;
//        
//        if (self.firstPage == indexPath.row)
//        {
//            self.firstPage = -1;
//        }
//        else
//        {
//         scrollView.photo = photo;
//        }
////        scrollView.photo = photo;
//        __weak typeof(scrollBoxView)weakScrollBoxView = scrollBoxView;
//        __weak typeof(self)weakSelf = self;
//        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndexPath:)]) {
//            [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            scrollView.callback = ^(id obj){
//                [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndexPath:indexPath];
//            };
//        }
//        [scrollBoxView addSubview:scrollView];
//        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    }
    
    return cell;
}
- (void) pickerPhotoScrollViewDidSingleClick:(MLPhotoBrowserPhotoScrollView *)photoScrollView
{
    
    if(self.isDetail)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuoDetail" object:self.reloadIndex];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuo" object:self.reloadIndex];
    }
    
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuo" object:self.reloadIndex];
//    //刷新点击说说的头像
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuoDetail" object:self.reloadIndex];
    self.disMissBlock(self.currentPage);
    
   
   
}
#pragma mark - 获取CollectionView
- (UIView *) getScrollViewBaseViewWithCell:(UIView *)view{
    if (view == nil) {
        return nil;
    }
    for (int i = 0; i < view.subviews.count; i++) {
        UICollectionViewCell *cell = view.subviews[i];
        if ([cell isKindOfClass:[UICollectionView class]] || [cell isKindOfClass:[UITableView class]]  || [cell isKindOfClass:[UIScrollView class]] || view == nil) {
            return cell;
        }
    }
    return [self getScrollViewBaseViewWithCell:view.superview];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat nowX = self.collectionView.contentOffset.x;
    CGFloat maxX = (self.photos.count-1)*(SCREEN_WIDTH+20);
    if (nowX>maxX)
    {
        self.collectionView.contentOffset = CGPointMake(maxX, 0);
//        self.collectionView.scrollEnabled = NO;
    }
    else
    {
        if (nowX<0)
        {
            self.collectionView.scrollEnabled = NO;
        }
        else
        {
            self.collectionView.scrollEnabled = YES;
        }
    }
    CGRect tempF = self.collectionView.frame;
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.ml_width) + 0.5);
    if (tempF.size.width < [UIScreen mainScreen].bounds.size.width){
        tempF.size.width = [UIScreen mainScreen].bounds.size.width;
    }
    if ((currentPage < self.photos.count -1) || self.photos.count == 1) {
        tempF.origin.x = 0;
    }
    else if(scrollView.isDragging)
    {
        tempF.origin.x = -ZLPickerColletionViewPadding;
    }
//    if ([self isDataSourceElsePhotos]) {
//        if ((currentPage < [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section] - 1) || self.photos.count == 1) {
//            tempF.origin.x = 0;
//        }else{
//            tempF.origin.x = -ZLPickerColletionViewPadding;
//        }
//    }else{
//        if ((currentPage < self.photos.count - 1) || self.photos.count == 1) {
//            tempF.origin.x = 0;
//        }else{
//            tempF.origin.x = -ZLPickerColletionViewPadding;
//        }
//    }
//    self.collectionView.frame = tempF;
}

-(void)setPageLabelPage:(NSInteger)page{
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %d",page + 1, (int)self.photos.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width));
//    
//    if (currentPage == self.photos.count - 2) {
//        currentPage = roundf((scrollView.contentOffset.x) / (scrollView.frame.size.width));
//    }
//    
//    if (currentPage == self.photos.count - 1 && currentPage != self.currentPage && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
//        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + ZLPickerColletionViewPadding, 0);
//    }
    NSInteger currentPage = (NSInteger)scrollView.contentOffset.x / (scrollView.ml_width - ZLPickerColletionViewPadding);
    if (currentPage == self.photos.count - 1 && currentPage != self.currentPage && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    }
    
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
        [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
    }
    
}

#pragma mark - 展示控制器
- (void)showPickerVc:(UIViewController *)vc{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
//        [weakVc presentViewController:nav animated:NO completion:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
        [CATransaction begin];
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        transition.duration=0.3;
        transition.fillMode=kCAFillModeBoth;
        transition.removedOnCompletion=YES;
        [[UIApplication sharedApplication] .keyWindow.layer addAnimation:transition forKey:@"transition"];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [CATransaction setCompletionBlock: ^ {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        }];
        [weakVc presentViewController:nav animated:NO completion:nil];
        [CATransaction commit];
    }
}

- (void)show{
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}


#pragma mark cover
- (void)cover{
    // 准备删除
//    if ([self.delegate respondsToSelector:@selector(photoBrowser:coverPhotoAtIndexPath:)]) {
//        if(![self.delegate photoBrowser:self willRemovePhotoAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:self.currentIndexPath.section]]){
//            return ;
//        }
//        if (![self.delegate photoBrowser:self coverPhotoAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:self.currentIndexPath.section]]) {
//            
//        }
//    }
    
    UIAlertView *removeAlert = [[UIAlertView alloc]
                                initWithTitle:@"确定要设置此图片为封面？"
                                message:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:@"确定", nil];\
    removeAlert.tag = 10;
    [removeAlert show];
}

#pragma mark - 删除照片
- (void) delete{
    
    if (self.isGroup && self.photos.count == 1) {
        [MBProgressHUD createHUD:@"当前只有一张图片" View:self.view];
        return;
    }
    
    // 准备删除
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willRemovePhotoAtIndexPath:)]) {
        if(![self.delegate photoBrowser:self willRemovePhotoAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:self.currentIndexPath.section]]){
            return ;
        }
    }
    
//    UIAlertView *removeAlert = [[UIAlertView alloc]
//                                initWithTitle:@"确定要删除此图片？"
//                                message:nil
//                                delegate:self
//                                cancelButtonTitle:@"取消"
//                                otherButtonTitles:@"确定", nil];
//    removeAlert.tag = 20;
//    [removeAlert show];
    
    
    if (self.photos.count == 1)//创建求职简历浏览图片删除时至少保留一张
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留一张照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 30;
        [alert show];
    }
    else
    {
        UIAlertView *removeAlert = [[UIAlertView alloc]
                                    initWithTitle:@"确定要删除此图片？"
                                    message:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    otherButtonTitles:@"确定", nil];
        removeAlert.tag = 20;
        [removeAlert show];
    }
    
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            NSInteger page = self.currentPage;
            if ([self.delegate respondsToSelector:@selector(photoBrowser:coverPhotoAtIndexPath:)]) {
                [self.delegate photoBrowser:self coverPhotoAtIndexPath:[NSIndexPath indexPathForRow:page inSection:self.currentIndexPath.section]];
            }
            
            MLPhotoBrowserPhoto *photo = self.photos[page];
            if (self.photos.count > self.currentPage && self.dataSource != nil) {
                NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
                [photos removeObjectAtIndex:self.currentPage];
                [photos insertObject:photo atIndex:0];
                self.photos = photos;
            }
            self.currentPage = 1;
            [self reloadData];
        }
    }
        
    if (alertView.tag == 20) {
        if (buttonIndex == 1) {
            NSInteger page = self.currentPage;
            if ([self.delegate respondsToSelector:@selector(photoBrowser:removePhotoAtIndexPath:)]) {
                [self.delegate photoBrowser:self removePhotoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:self.currentIndexPath.section]];
            }
            
            if (self.currentPage >= self.photos.count) {
                self.currentPage--;
            }
            
//            NSLog(@">>>>>>>>>>>%@",self.photos);
            if (self.photos.count > self.currentPage && self.dataSource != nil) {
                NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
                [photos removeObjectAtIndex:self.currentPage];
                self.photos = photos;
            }
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:self.currentIndexPath.section]];
            if (cell) {
                if([[[cell.contentView subviews] lastObject] isKindOfClass:[UIView class]]){
                    
                    [UIView animateWithDuration:.35 animations:^{
                        [[[cell.contentView subviews] lastObject] setAlpha:0.0];
                    } completion:^(BOOL finished) {
                        [self reloadData];
                    }];
                }
            }
            
            if (self.photos.count < 1)
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
        }
    }
    
    if (alertView.tag == 30)
    {}
}

#pragma mark - <PickerPhotoScrollViewDelegate>
- (void):(MLPhotoBrowserPhotoScrollView *)photoScrollView{
    
      if(self.isDetail)
      {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuoDetail" object:self.reloadIndex];
      }
    else
    {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuo" object:self.reloadIndex];
    }
   
    
    
    if (self.disMissBlock) {
        
        if (self.photos.count == 1) {
            self.currentPage = 0;
        }
        self.disMissBlock(self.currentPage);
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)isDataSourceElsePhotos{
    return self.dataSource != nil;
}
-(void)dismissMain
{
    if(self.isDetail)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuoDetail" object:self.reloadIndex];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuo" object:self.reloadIndex];
    }
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuo" object:self.reloadIndex];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShuoShuoDetail" object:self.reloadIndex];
    if (self.disMissBlock) {
        self.disMissBlock(self.currentPage);
    }
}
- (void)showToView{
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame = [UIScreen mainScreen].bounds;
    mainView.tag = 5555;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    UITapGestureRecognizer * tapMain = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMain)];
    [mainView addGestureRecognizer:tapMain];
    
    UIImageView *toImageView = nil;
    if(self.status == UIViewAnimationAnimationStatusZoom){//UIViewAnimationAnimationStatusZoom
        
        if ([self isDataSourceElsePhotos]) {
            toImageView = (UIImageView *)[[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] toView];
        }else{
            toImageView = (UIImageView *)[self.photos[self.currentIndexPath.row] toView];
        }
        
    }
    
    if (![toImageView isKindOfClass:[UIImageView class]] && self.status != UIViewAnimationAnimationStatusFade) {
        assert(@"error: need toView `UIImageView` class.");
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:imageView];
    mainView.clipsToBounds = YES;
    
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        if ([self isDataSourceElsePhotos]) {
            imageView.image = [[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] thumbImage];
        }else{
            imageView.image = [self.photos[self.currentIndexPath.row] thumbImage];
        }
    }else{
        imageView.image = toImageView.image;
    }
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.alpha = 0.0;
        imageView.frame = [self setMaxMinZoomScalesForCurrentBounds:imageView];
    }else if(self.status == UIViewAnimationAnimationStatusZoom){
        CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
        imageView.frame = tempF;
    }
    __weak typeof(self)weakSelf = self;
    self.disMissBlock = ^(NSInteger page){   // 点击消失的逻辑
        mainView.hidden = NO;
        mainView.alpha = 1.0;
        CGRect originalFrame = CGRectZero;
        [weakSelf dismissViewControllerAnimated:NO completion:^{
        }];
       
        
        // 不是淡入淡出
        if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
            
            if ([weakSelf isDataSourceElsePhotos]) {
                imageView.image = [(UIImageView *)[[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] toView] image];
            }else{
                imageView.image = [(UIImageView *)[weakSelf.photos[page] toView] image];
            }
            
            imageView.frame = [weakSelf setMaxMinZoomScalesForCurrentBounds:imageView];
            
            UIImageView *toImageView2 = nil;
            if ([weakSelf isDataSourceElsePhotos]) {
                toImageView2 = (UIImageView *)[[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] toView];
            }else{
                toImageView2 = (UIImageView *)[weakSelf.photos[page] toView];
            }
            originalFrame = [toImageView2.superview convertRect:toImageView2.frame toView:[weakSelf getParsentView:toImageView2]];
        }
        
        [UIView animateWithDuration:0.2 animations:^{  //消失时候的动画
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                imageView.alpha = 0.0;
                mainView.alpha = 0.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                if (self.isNewZoom == YES) {
                    imageView.alpha = 0.0;
                    mainView.alpha = 0.0;
                }else{
                    mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                    imageView.frame = originalFrame;
                }
            }
        } completion:^(BOOL finished) {
            imageView.alpha = 1.0;
            mainView.alpha = 1.0;
            [mainView removeFromSuperview];
            [imageView removeFromSuperview];
        }];
    };
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.status == UIViewAnimationAnimationStatusFade){
            // 淡入淡出
            imageView.alpha = 1.0;
        }else if(self.status == UIViewAnimationAnimationStatusZoom){
            imageView.frame = [self setMaxMinZoomScalesForCurrentBounds:imageView];
        }
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
        if (self.isHideOrNot) {
            mainView.hidden = YES;
            self.isHideOrNot = NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showImageSuccess" object:nil];
    }];
}
-(void)hideMainView:(id)obj
{
    UIView* view = (UIView*)obj;
    view.hidden = YES;
}
- (CGRect)setMaxMinZoomScalesForCurrentBounds:(UIImageView *)imageView{
    if (!([imageView isKindOfClass:[UIImageView class]]) || imageView.image == nil) {
        if (!([imageView isKindOfClass:[UIImageView class]])) {
            return imageView.frame;
        }
    }
    
    
    self.currentStr = [self.currentStr stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
    NSArray * array = [self.currentStr componentsSeparatedByString:@"_"];
    if (array.count<3) {
        return imageView.frame;
    }
    NSString * widthStr = [NSString stringWithFormat:@"%@",array[1]];
    NSString * secondStr = [NSString stringWithFormat:@"%@",array[2]];
    NSArray * array1 = [secondStr componentsSeparatedByString:@"_"];
    NSString * heightStr = [NSString stringWithFormat:@"%@",array1[0]];
    CGSize size = CGSizeMake(widthStr.floatValue, heightStr.floatValue);
    
    // Sizes
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = size;//imageView.image.size
    if (imageSize.width == 0 && imageSize.height == 0) {
        return imageView.frame;
    }
    
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = MAX(xScale, yScale);
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    CGRect frameToCenter = CGRectZero;
    if (xScale >= yScale) {
        frameToCenter = CGRectMake(0, 0, imageSize.width * maxScale, imageSize.height * maxScale);
        
    }else {
        if (minScale >= 3) {
            minScale = 3;
        }
        frameToCenter = CGRectMake(0, 0, imageSize.width * minScale, imageSize.height * minScale);
    }
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

@end
