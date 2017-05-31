//
//  WPRecruitCell.h
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"
#import "WPRecruitModel.h"

@interface WPRecruitCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) WPRecruitListModel *model;
//-(void)setModel:(WPRecruitListModel *)model;

+(instancetype)cellWithCellectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
