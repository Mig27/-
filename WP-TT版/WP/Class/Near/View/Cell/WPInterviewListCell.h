//
//  WPInterviewListCell.h
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPDraftListModel.h"
#import "THLabel.h"
@protocol WPInterviewListCellDelegate <NSObject>

- (void)didEditItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WPInterviewListCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *label;
@property (assign, nonatomic) id <WPInterviewListCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) THLabel *editLabel;



/**
 *  初始化一个对象
 *
 *  @param collectionView 当前CollectionView
 *  @param indexPath      当前所在IndexPath
 *
 *  @return 返回WPInterviewListCell对象
 */
+ (instancetype)cellectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;
/**
 *  初始化子视图
 *
 *  @param indexPath 当前所在IndexPath
 */
- (void)initWithSubViews:(NSIndexPath *)indexPath;
/**
 *  更新当前Cell数据
 *
 *  @param model 数据源Model
 */
- (void)updateData:(WPDraftListContentModel *)model;
/**
 *  计算Cell高度
 *
 *  @return CellHeight
 */
+ (CGFloat)getCellHeight;

@end
