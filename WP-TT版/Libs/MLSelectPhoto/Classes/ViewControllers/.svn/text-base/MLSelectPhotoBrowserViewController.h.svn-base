//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  MLSelectPhotoBrowserViewController.h
//  MLSelectPhoto
//
//  Created by 张磊 on 15/4/23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MLSelectPhotoBroswerComeType) {
    MLSelectPhotoBroswerComeTypeDynamic,
    MLSelectPhotoBroswerComeTypeGroup,
};

@interface MLSelectPhotoBrowserViewController : UIViewController
// 展示的图片 MLSelectAssets
@property (strong,nonatomic) NSMutableArray *photos;
// 长按图片弹出的UIActionSheet
@property (strong,nonatomic) UIActionSheet *sheet;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;
// 是否为照片预览,若是,则在又上缴添加删除按钮
@property (nonatomic, assign) BOOL isPreView;
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, assign) BOOL isRegist;
@property (nonatomic, assign) BOOL isBrowers;//是否是预览
@property (nonatomic, strong) NSIndexPath*browersIndex;  //进入滚动查看的所点击的图片下标
@property (nonatomic, assign) BOOL isOriginal;
@property (nonatomic, assign) int sendNum;


//返回更新相册
@property (nonatomic, assign) MLSelectPhotoBroswerComeType comeType;
@property (nonatomic, copy) void(^needUpdataAssestBlock)(NSMutableArray *assets);   //设为首页 / 设为图像 / 删除更新
@property (nonatomic, copy) void(^backChoisePhoto)(NSMutableArray*muarray);
@property (nonatomic, copy) void(^backOriginalPhoto)(BOOL isOrNot);
@property (nonatomic, copy) void(^choiseImage)(NSIndexPath*index,BOOL isChoise);


//新的预览图片模式
@property (nonatomic, copy) void(^takePictureByCameraBlock)(NSUInteger clickNum);   //拍照
@property (nonatomic, copy) void(^takePictureByAlbumBlock)(NSUInteger clickNum);   //从手机选择
@property (nonatomic, copy) void(^savePictureToAlbumBlock)(NSUInteger clickNum);   //保存图片


@end
