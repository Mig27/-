//
//  WPInterviewListCell.h
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPUserListModel.h"
#import "DefaultParamsModel.h"

@protocol MyResumeCellDelegate <NSObject>

- (void)didEditItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyResumeCell : UICollectionViewCell

@property (assign, nonatomic) id <MyResumeCellDelegate> delegate;

+ (instancetype)cellectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;
- (void)initWithSubViews:(NSIndexPath *)indexPath;
- (void)updateData:(DefaultParamsModel *)model;
+ (CGFloat)getCellHeight;

@end
