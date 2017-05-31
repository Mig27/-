//
//  WPResumeUserCell.h
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPResumeUserListModel.h"
#import "WPResumeUserInfoModel.h"
@interface WPResumeUserCell : UITableViewCell


@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) WPResumeUserInfoModel *model;

@property (nonatomic, assign) BOOL isReume; /**< 是否是简历 */

@property (nonatomic, copy) void (^chooseActionBlock)(NSInteger cellTag);

@end
