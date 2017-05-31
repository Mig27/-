//
//  WPResumeDraftCell.h
//  WP
//
//  Created by Kokia on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPResumDraftListModel.h"

@interface WPResumeDraftCell : UITableViewCell


@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) WPResumDraftModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;  /** 当前cell的indexPath */

@property (nonatomic,assign) NSInteger numOfChoise;//选择删除的个数
@property (nonatomic, copy) void (^chooseActionBlock)(NSIndexPath *indexPath);

- (void)setModel:(WPResumDraftModel *)model isEdit:(BOOL)edit;

@end
