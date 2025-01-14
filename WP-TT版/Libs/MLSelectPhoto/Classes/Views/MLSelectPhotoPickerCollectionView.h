//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerCollectionView.h
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSelectPhotoAssets.h"

@class MLSelectPhotoPickerCollectionView;
// 展示状态
typedef NS_ENUM(NSUInteger, ZLPickerCollectionViewShowOrderStatus){
    ZLPickerCollectionViewShowOrderStatusTimeDesc = 0, // 升序
    ZLPickerCollectionViewShowOrderStatusTimeAsc // 降序
};

@class MLSelectPhotoPickerCollectionView;
@protocol ZLPhotoPickerCollectionViewDelegate <NSObject>
// 选择相片就会调用
- (void) pickerCollectionViewDidSelected:(MLSelectPhotoPickerCollectionView *) pickerCollectionView deleteAsset:(MLSelectPhotoAssets *)deleteAssets;

// 点击拍照就会调用
- (void)pickerCollectionViewDidCameraSelect:(MLSelectPhotoPickerCollectionView *) pickerCollectionView;

@end

@interface MLSelectPhotoPickerCollectionView : UICollectionView

@property (nonatomic , assign) ZLPickerCollectionViewShowOrderStatus status;
// 保存所有的数据
@property (nonatomic , strong) NSArray *dataArray;
// 保存选中的图片
@property (nonatomic , strong) NSMutableArray *selectAsstes;
// 最后保存的一次图片
@property (strong,nonatomic) NSMutableArray *lastDataArray;
// delegate
@property (nonatomic , weak) id <ZLPhotoPickerCollectionViewDelegate> collectionViewDelegate;
// 限制最大数
@property (nonatomic , assign) NSInteger minCount;
// 置顶展示图片
@property (assign,nonatomic) BOOL topShowPhotoPicker;
// 选中的索引值，为了防止重用
@property (nonatomic , strong) NSMutableArray *selectsIndexPath;
// 记录选中的值
@property (assign,nonatomic) BOOL isRecoderSelectPicker;
@property (nonatomic, assign) BOOL isOriginal;//原图

@property (nonatomic, copy)void(^didSelectedPhoto)(NSMutableArray*muarray,NSIndexPath*index);
@end
