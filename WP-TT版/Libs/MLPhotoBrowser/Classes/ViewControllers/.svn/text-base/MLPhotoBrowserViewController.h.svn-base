//
//  MLPhotoBrowserViewController.h
//  MLPhotoBrowser
//
//  Created by 张磊 on 14-11-14.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserCustomToolBarView.h"

// 点击图片浏览器,浏览时的动画
typedef NS_ENUM(NSUInteger, UIViewAnimationAnimationStatus) {
    UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
    UIViewAnimationAnimationStatusFade, // 淡入淡出
    UIViewAnimationAnimationStatusNotAnimation, // 没有动画
};

@class MLPhotoBrowserViewController;
@protocol MLPhotoBrowserViewControllerDataSource <NSObject>

@optional
/**
 *  有多少组
 */
- (NSInteger) numberOfSectionInPhotosInPhotoBrowser:(MLPhotoBrowserViewController *)photoBrowser;

@required
/**
 *  每个组多少个图片
 */
- (NSInteger) photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section;
/**
 *  每个对应的IndexPath展示什么内容
 */
- (MLPhotoBrowserPhoto *)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser photoAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol MLPhotoBrowserViewControllerDelegate <NSObject>
@optional
/**
 *  准备删除那个图片
 *
 *  @param index        要删除的索引值
 */
- (BOOL)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser willRemovePhotoAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  删除indexPath对应索引的图片
 *
 *  @param indexPath        要删除的索引值
 */
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  设置indexPath对应的图片为封面
 *
 *  @param indexPath    要设置的索引值
 */
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  滑动结束的页数
 *
 *  @param page         滑动的页数
 */
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser didCurrentPage:(NSUInteger)page;
/**
 *  滑动开始的页数
 *
 *  @param page         滑动的页数
 */
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser willCurrentPage:(NSUInteger)page;

/**
 *  点击每个Item时候调用
 */
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser photoDidSelectView:(UIView *)scrollBoxView atIndexPath:(NSIndexPath *)indexPath;

/**
 *  返回用户自定义的toolBarView(类似tableView FooterView)
 *
 *  @return 返回用户自定义的toolBarView
 */
- (MLPhotoBrowserCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(MLPhotoBrowserViewController *)photoBrowser;

@end

@interface MLPhotoBrowserViewController : UIViewController
// @require
// 数据源/代理
@property (weak,nonatomic) id<MLPhotoBrowserViewControllerDataSource> dataSource;
@property (weak,nonatomic) id<MLPhotoBrowserViewControllerDelegate> delegate;
// 当前提供的组
@property (strong,nonatomic) NSIndexPath *currentIndexPath;
@property (nonatomic, assign)NSUInteger firstPage;
@property (nonatomic, strong)NSIndexPath*reloadIndex;
// @optional
// 传入photos, 可以省略数据源 @[MLPhotoBrowserPhoto,MLPhotoBrowserPhoto,...]
@property (strong,nonatomic) NSArray *photos;
// 是否可以编辑（删除照片）
@property (assign,getter=isEditing,nonatomic) BOOL editing;
// 动画status (放大缩小/淡入淡出/旋转)
@property (assign,nonatomic) UIViewAnimationAnimationStatus status;
// 长按保存图片会调用sheet
@property (strong,nonatomic) UIActionSheet *sheet;
@property (nonatomic, assign) BOOL isNeedShow;
@property (nonatomic, assign) BOOL isGroup;

@property (nonatomic, copy) NSString*currentStr;

//先方法后渐隐  只在H5里面实现
@property (nonatomic, assign) BOOL isNewZoom;
@property (nonatomic, assign) BOOL hideCollection;
@property (nonatomic, assign) BOOL isDetail;
// @function
// 展示控制器
- (void)showPickerVc:(UIViewController *)vc;
- (void)show;
// 刷新数据
- (void)reloadData;
@end
