//
//  WPPersonalAlbumCell.h
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPGlobalPhotoModel.h"

@class WPPersonalAlbumCell;

@protocol WPPersonalAlbumCellDelegate <NSObject>
@optional

- (void)didSelectItemViewCell:(WPPersonalAlbumCell *)assetsCell;


@end


@interface WPPersonalAlbumCell : UICollectionViewCell

@property (nonatomic, weak) id<WPPersonalAlbumCellDelegate>  delegate;
@property (nonatomic,strong) WPGlobalPhotoModel *model;

@end
