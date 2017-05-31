//
//  WPNewFullSearchCell.h
//  WP
//
//  Created by CBCCBC on 16/1/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPNewFullSearchCell : UICollectionViewCell

@property (strong ,nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSObject *model;

- (void)exchangeSubViewFrame:(BOOL)isEdit;

@end
