//
//  WPHotFooterCell.h
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPHotFooterCell : UICollectionViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIButton *titleButton;
@property (assign, nonatomic) BOOL isFoot;
@property (copy, nonatomic) void (^checkAllData)(NSIndexPath *indexPath,BOOL selected);

@end
