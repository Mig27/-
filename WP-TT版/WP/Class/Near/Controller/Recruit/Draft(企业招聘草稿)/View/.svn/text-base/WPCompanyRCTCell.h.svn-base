//
//  WPCompanyRCTCell.h
//  WP
//
//  Created by Kokia on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WPCompanyListDetailModel;

@interface WPCompanyRCTCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) WPCompanyListDetailModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;  /** 当前cell的indexPath */

@property (nonatomic, copy) void (^chooseActionBlock)(NSIndexPath *indexPath);

- (void)setModel:(WPCompanyListDetailModel *)model isEdit:(BOOL)edit;@end
