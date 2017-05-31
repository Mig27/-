//
//  WPPhotoAndVideoController.h
//  WP
//
//  Created by CC on 16/10/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPhotoBrowserViewController.h"
@interface WPPhotoAndVideoController : UIViewController
@property (nonatomic, strong)NSArray * videoAndPhotoArr;//存放图片和视频
@property (nonatomic, strong)NSArray * videoPhotoOriginalArr;//存放原始的图片转发时用
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger firstPage;
@property (nonatomic, assign) NSUInteger dismissPage;
@property (nonatomic, strong) NSString * currentStr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isNeedShow;
@property (nonatomic, copy) void(^disMissBlock)(NSInteger page);
@property (nonatomic, copy) void(^dsimssMain)(NSInteger page);
@property (nonatomic, assign) BOOL fromChatNotCreat;
@property (nonatomic, assign) BOOL isNewZoom;
@property (assign,nonatomic) UIViewAnimationAnimationStatus status;
-(void)showPhotoVideo:(UIViewController*)vc;

@end
