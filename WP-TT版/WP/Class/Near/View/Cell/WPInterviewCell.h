//
//  WPInterviewCell.h
//  WP
//
//  Created by CBCCBC on 15/9/17.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"
#import "WPInterviewModel.h"

@interface WPInterviewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) THLabel *titleLabel;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) WPInterviewListModel *model;

//-(void)setModel:(WPInterviewListModel *)model;

+(instancetype)cellWithCellectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
