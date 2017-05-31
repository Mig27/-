//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

@protocol SPPhotoBrowserDelegate;
@interface SPPhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, assign) id<SPPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

// 显示
- (void)show;
@end

@protocol SPPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
//- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser photosArr:(NSArray *)photosArray;
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index;
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index;
@end