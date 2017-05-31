//
//  WPPersonalResumeListCell.h
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearPersonalController.h"
#import "WPNewResumeModel.h"

typedef void (^coverClickBlock)();
typedef void (^bottomCoverBlock)();

@interface WPPersonalResumeListCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *positionAndCompanyLabel;
@property (strong, nonatomic)  UIImageView *contentImageView;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UILabel *contentDetailLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UIButton *cover;
@property (strong, nonatomic)  UIButton *bottomCover;

@property (strong, nonatomic)  NSIndexPath *indexPath;
@property (copy, nonatomic) void (^contentActionBlock)(NSIndexPath *indexPath);
@property (copy, nonatomic) coverClickBlock coverClickBlock;
@property (copy, nonatomic) bottomCoverBlock bottomCoverBlock;
@property (nonatomic, strong) WPNewResumeListModel * resumeModel;
@property (nonatomic, strong) WPNewResumeModel * model;
@property (nonatomic, assign) BOOL isRecruit;

+ (CGFloat)cellHeight;

@end
