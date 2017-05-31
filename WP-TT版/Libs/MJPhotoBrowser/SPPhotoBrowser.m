//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "SPPhotoBrowser.h"
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import "SPPhotoToolbar.h"
#import "WPNavigationController.h"


#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface SPPhotoBrowser () <MJPhotoViewDelegate,MJPhotoToolbarDelegate,UIAlertViewDelegate>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    SPPhotoToolbar *_toolbar;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    UIImageView *navBarHairlineImageView;
}
@end

@implementation SPPhotoBrowser

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
////     隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
//        navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
    
    [self initNav];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
////    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
}
//- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
//    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
//        return (UIImageView *)view;
//    }
//    for (UIView *subview in view.subviews) {
//        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
//        if (imageView) {
//            return imageView;
//        }
//    }
//    return nil;
//}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    navBarHairlineImageView.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    navBarHairlineImageView.hidden = NO;
//}
-(void)initNav
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    //    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    back.tag = pushType;
//    backTag = pushType;
    [back addTarget:self action:@selector(backToFromViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    self.title = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.currentPhotoIndex,(unsigned long)self.photos.count];
}
-(void)backToFromViewController:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)show
{
//    WPNavigationController * nave = [[WPNavigationController alloc]initWithRootViewController:self];;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];

    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}
#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = kHEIGHT(49);
    CGFloat barY = SCREEN_HEIGHT - barHeight;
    _toolbar = [[SPPhotoToolbar alloc] init];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.frame = CGRectMake(0, barY, SCREEN_WIDTH, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.delegate = self;
    _toolbar.photos = _photos;
    [self.view addSubview:_toolbar];
    
    [self updateTollbarState];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
//    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
//    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoToolbar删除图片的代理
- (void)currentPhotoViewWillDelete{
    if (_photos.count == 1) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留一张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除图片?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 1000;
//        [alert show];
        
        if ([self.delegate respondsToSelector:@selector(photoBrowser:deleteImageAtIndex:)]) {
            [self.delegate photoBrowser:self deleteImageAtIndex:_currentPhotoIndex];
        }
        
        CGRect frame = self.view.bounds;
        frame.origin.x -= kPadding;
        frame.size.width += (2 * kPadding);
        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_photos];
        [arr removeObjectAtIndex:_currentPhotoIndex];
        MJPhotoView *view = [_photoScrollView viewWithTag:kPhotoViewTagOffset+_currentPhotoIndex];
        [view removeFromSuperview];
        if (arr.count) {
            [self setPhotos:arr];
            _currentPhotoIndex =(_currentPhotoIndex != 0)?(_currentPhotoIndex-1):_currentPhotoIndex;
            _photoScrollView.contentSize = CGSizeMake(frame.size.width * arr.count, 0);
            _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
            _toolbar.photos = arr;
            [self updateTollbarState];
            [self showPhotos];
        }else{
            [self photoViewDidEndZoom:nil];
        }
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            
        }
        else
        {
//            if ([self.delegate respondsToSelector:@selector(photoBrowser:deleteImageAtIndex:)]) {
//                [self.delegate photoBrowser:self deleteImageAtIndex:_currentPhotoIndex];
//            }
//            
//            CGRect frame = self.view.bounds;
//            frame.origin.x -= kPadding;
//            frame.size.width += (2 * kPadding);
//            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_photos];
//            [arr removeObjectAtIndex:_currentPhotoIndex];
//            MJPhotoView *view = [_photoScrollView viewWithTag:kPhotoViewTagOffset+_currentPhotoIndex];
//            [view removeFromSuperview];
//            if (arr.count) {
//                [self setPhotos:arr];
//                _currentPhotoIndex =(_currentPhotoIndex != 0)?(_currentPhotoIndex-1):_currentPhotoIndex;
//                _photoScrollView.contentSize = CGSizeMake(frame.size.width * arr.count, 0);
//                _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
//                _toolbar.photos = arr;
//                [self updateTollbarState];
//                [self showPhotos];
//            }else{
//                [self photoViewDidEndZoom:nil];
//            }
        }
    }
}
- (void)changeCurrentImageWithFirstImage{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:coverImageAtIndex:)]) {
        [self.delegate photoBrowser:self coverImageAtIndex:_currentPhotoIndex];
    }
//    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_photos];
//    MJPhoto *photo = _photos[_currentPhotoIndex];
//    [arr removeObjectAtIndex:_currentPhotoIndex];
//    [arr insertObject:photo atIndex:0];
//    MJPhotoView *view = [_photoScrollView viewWithTag:kPhotoViewTagOffset+_currentPhotoIndex];
//    [view removeFromSuperview];
//    [self setPhotos:arr];
//    _currentPhotoIndex = 0;
//    _toolbar.photos = arr;
//    [_photoScrollView setContentOffset:CGPointMake(0, 0)];
//    [self updateTollbarState];
//    [self showPhotos];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
//    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
//    self.view.backgroundColor = [UIColor clearColor];
//    
//    // 移除工具条
//    [_toolbar removeFromSuperview];
//    UIGestureRecognizer * recoginze = photoView.gestureRecognizers;
//    UITapGestureRecognizer * tap;
//    for (UIGestureRecognizer * recoginze in photoView.gestureRecognizers) {
//        if ([recoginze isKindOfClass:[UITapGestureRecognizer class]]) {
//            tap = (UITapGestureRecognizer*)recoginze;
//        }
//    }
//    if (tap.numberOfTapsRequired == 2) {
//        
//    }
//    else
//    {
//        _toolbar.hidden = !_toolbar.hidden;
//        self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
//    }
    
    NSLog(@"hahahah");
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//    if ([self.delegate respondsToSelector:@selector(photoBrowser:photosArr:)]) {
//        [self.delegate photoBrowser:self photosArr:_photos];
//    }
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
//    if (_photos.count == 1) {
//        [self showPhotoViewAtIndex:0];
//        return;
//    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSUInteger)index
{
    
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.singleTapBlock = ^(){
            _toolbar.hidden = !_toolbar.hidden;
            self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
        };
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    if (photoViewFrame.origin.y != -64 && photoViewFrame.origin.y != 0) {
        photoViewFrame.origin.y = -64;
    }
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.frame = photoViewFrame;
//    photoView.backgroundColor = [UIColor redColor];
//    CGRect rect = photoView.frame;
////    rect.origin.y = -22;
//    photoView.frame = rect;
    
    photoView.tag = kPhotoViewTagOffset + index;
    MJPhoto *photo = _photos[index];
    photoView.photo = photo;
//    photoView.userInteractionEnabled = NO;
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    tap.delaysTouchesBegan = YES;
//    [photoView addGestureRecognizer:tap];
//    
//    UITapGestureRecognizer * Doubletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhotoDouble)];
//    Doubletap.numberOfTapsRequired = 2;
//    Doubletap.numberOfTouchesRequired = 1;
//    [photoView addGestureRecognizer:Doubletap];
//    
//    [tap requireGestureRecognizerToFail:Doubletap];
    
    [self loadImageNearIndex:index];
}
#pragma mark 点击一次图片
-(void)clickPhoto
{
//    _toolbar.hidden = !_toolbar.hidden;
//    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
}
#pragma mark 点击两次图片
-(void)clickPhotoDouble
{
  
}
#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSUInteger)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
//        photoView.delegate = self;
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    self.title = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_currentPhotoIndex+1,self.photos.count];
//    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
    [self updateTollbarState];
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"gagagagagag");
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    _toolbar.hidden = !_toolbar.hidden;
//    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
//}
@end
