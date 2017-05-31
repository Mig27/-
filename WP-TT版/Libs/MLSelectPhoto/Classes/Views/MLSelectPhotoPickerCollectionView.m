//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerCollectionView.m
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoPickerCollectionView.h"
#import "MLSelectPhotoPickerCollectionViewCell.h"
#import "MLPhotoPickerImageView.h"
#import "MLSelectPhotoPickerFooterCollectionReusableView.h"
#import "MLSelectPhotoCommon.h"
#import "WPPhotoSelectedBtn.h"
@interface MLSelectPhotoPickerCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) MLSelectPhotoPickerFooterCollectionReusableView *footerView;

// 判断是否是第一次加载
@property (nonatomic , assign , getter=isFirstLoadding) BOOL firstLoadding;

@end

@implementation MLSelectPhotoPickerCollectionView

#pragma mark -getter
- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    return _selectsIndexPath;
}

#pragma mark -setter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker){
        NSMutableArray *selectAssets = [NSMutableArray array];
        
        NSArray * array = [NSArray arrayWithArray:self.selectAsstes];
        NSArray * array1 = [NSArray arrayWithArray:self.dataArray];
        for (MLSelectPhotoAssets *asset in array) {
            for (MLSelectPhotoAssets *asset2 in array1) {
                if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
                    [selectAssets addObject:asset2];
                    break;
                }
            }
        }
        _selectAsstes = selectAssets;
    }
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        _selectAsstes = [NSMutableArray array];
    }
    return self;
}

#pragma mark -<UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MLSelectPhotoPickerCollectionViewCell *cell = [MLSelectPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    MLPhotoPickerImageView *cellImgView = [[MLPhotoPickerImageView alloc] initWithFrame:cell.bounds];
    cellImgView.maskViewFlag = YES;
    cellImgView.indexPath = indexPath;
    cellImgView.userInteractionEnabled = YES;
    cellImgView.contentMode = UIViewContentModeScaleAspectFill;
    cellImgView.tapTickImage= ^(NSIndexPath*index){
        if (self.topShowPhotoPicker && index.item == 0) {
            if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidCameraSelect:)]) {
                [self.collectionViewDelegate pickerCollectionViewDidCameraSelect:self];
            }
            return ;
        }
        if (!self.lastDataArray) {
            self.lastDataArray = [NSMutableArray array];
        }
        MLSelectPhotoPickerCollectionViewCell *cell = (MLSelectPhotoPickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:index];
        MLSelectPhotoAssets *asset = self.dataArray[index.row];
        asset.isSelected = !asset.isSelected;
        asset.isThumbOrOrginal = self.isOriginal;
        MLPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
        // 如果没有就添加到数组里面，存在就移除
        if (pickerImageView.isMaskViewFlag) {
            [self.selectsIndexPath removeObject:@(index.row)];
            [self.selectAsstes removeObject:asset];
            [self.lastDataArray removeObject:asset];
        }else{
            // 1 判断图片数超过最大数或者小于0
            NSUInteger minCount = (self.minCount < 0) ? KPhotoShowMaxCount :  self.minCount;
            if (self.selectAsstes.count >= minCount) {
                NSString *format = [NSString stringWithFormat:@"最多剩余只能选择%zd张图片",minCount];
                if (minCount == 0) {
                    format = [NSString stringWithFormat:@"您已经选满了图片呦."];
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                [alertView show];
                MLSelectPhotoAssets *asset = self.dataArray[index.row];
                asset.isSelected = NO;
                return ;
            }
            [self.selectsIndexPath addObject:@(indexPath.row)];
            [self.selectAsstes addObject:asset];
            [self.lastDataArray addObject:asset];
        }
        // 告诉代理现在被点击了!
        if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected: deleteAsset:)]) {
            if (pickerImageView.isMaskViewFlag) {
                // 删除的情况下
                [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
            }else{
                [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
            }
        }
        pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[MLPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
    
    };
//    WPPhotoSelectedBtn *  photoBtn = [[WPPhotoSelectedBtn alloc]initWithFrame:CGRectMake(self.bounds.size.width - 22, 4, 18, 18)];
//    photoBtn.indexPath = indexPath;
//    photoBtn.backgroundColor = [UIColor redColor];
//    photoBtn.clickPhotoSelectedBtn = ^(NSIndexPath*index){
//        NSLog(@"点击了图片");
//    };
    
    
    if(indexPath.item == 0 && self.topShowPhotoPicker){
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        imageView.tag = indexPath.item;
        imageView.image = [UIImage imageNamed:MLSelectPhotoSrcName(@"camera")];
    }else{
        
        // 需要记录选中的值的数据
        if (self.isRecoderSelectPicker) {
            for (MLSelectPhotoAssets *asset in self.selectAsstes) {
                if ([asset.asset.defaultRepresentation.url isEqual:[self.dataArray[indexPath.item] asset].defaultRepresentation.url]) {
                    [self.selectsIndexPath addObject:@(indexPath.row)];
                }
            }
        }
//        [cell.contentView addSubview:photoBtn];
        
        [cell.contentView addSubview:cellImgView];
        
//        if (self.selectsIndexPath.count) {
//            NSIndexPath * index = self.selectsIndexPath[0];
//            NSLog(@"%ld=====%ld",(long)indexPath.row,(long)index.row);
//        }
        
        
        cellImgView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
        MLSelectPhotoAssets *asset = self.dataArray[indexPath.item];
        cellImgView.isVideoType = asset.isVideoType;
        if ([asset isKindOfClass:[MLSelectPhotoAssets class]]) {
            cellImgView.image = asset.thumbImage;
        }
    }
    return cell;
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MLSelectPhotoAssets *asset = self.dataArray[indexPath.row];
    if (asset.isSelected) {
        NSLog(@"11111111");
    }
    else
    {
        NSLog(@"000000000");
    }
    
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:self.dataArray];
    if (self.didSelectedPhoto) {
        self.didSelectedPhoto(muarray,indexPath);
    }
    
//    if (self.topShowPhotoPicker && indexPath.item == 0) {
//        if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidCameraSelect:)]) {
//            [self.collectionViewDelegate pickerCollectionViewDidCameraSelect:self];
//        }
//        return ;
//    }
//    if (!self.lastDataArray) {
//        self.lastDataArray = [NSMutableArray array];
//    }
//    MLSelectPhotoPickerCollectionViewCell *cell = (MLSelectPhotoPickerCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
//    MLSelectPhotoAssets *asset = self.dataArray[indexPath.row];
//    MLPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
//    // 如果没有就添加到数组里面，存在就移除
//    if (pickerImageView.isMaskViewFlag) {
//        [self.selectsIndexPath removeObject:@(indexPath.row)];
//        [self.selectAsstes removeObject:asset];
//        [self.lastDataArray removeObject:asset];
//    }else{
//        // 1 判断图片数超过最大数或者小于0
//        NSUInteger minCount = (self.minCount < 0) ? KPhotoShowMaxCount :  self.minCount;
//        if (self.selectAsstes.count >= minCount) {
//            NSString *format = [NSString stringWithFormat:@"最多剩余只能选择%zd张图片",minCount];
//            if (minCount == 0) {
//                format = [NSString stringWithFormat:@"您已经选满了图片呦."];
//            }
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//            [alertView show];
//            return ;
//        }
//        [self.selectsIndexPath addObject:@(indexPath.row)];
//        [self.selectAsstes addObject:asset];
//        [self.lastDataArray addObject:asset];
//    }
//    // 告诉代理现在被点击了!
//    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected: deleteAsset:)]) {
//        if (pickerImageView.isMaskViewFlag) {
//            // 删除的情况下
//            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
//        }else{
//            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
//        }
//    }
//    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[MLPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
}

#pragma mark 底部View
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MLSelectPhotoPickerFooterCollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        MLSelectPhotoPickerFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
        self.footerView = footerView;
    }else{
        
    }
    return reusableView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 时间置顶的话
    if (self.status == ZLPickerCollectionViewShowOrderStatusTimeDesc) {
        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
            // 滚动到最底部（最新的）
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            // 展示图片数
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 100);
            self.firstLoadding = YES;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
