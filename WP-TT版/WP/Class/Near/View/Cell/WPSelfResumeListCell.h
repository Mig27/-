//
//  WPSelfResumeListCell.h
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSelfResumeListCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *positionAndCompanyLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UIButton *sysMessageBtn;
@property (strong, nonatomic)  UILabel *applyNumberLabel;
@property (strong, nonatomic)  UILabel *messageNumberLabel;
@property (strong, nonatomic)  UILabel *glanceNumberLabel;
@property (strong, nonatomic)  NSIndexPath *indexPath;
@property (copy, nonatomic) void (^contentActionBlock)(NSIndexPath *indexPath);

@property (copy, nonatomic) void (^NearMeBlock)(NSInteger tag);
@property (copy, nonatomic) void (^DidSelectedBlock)(NSInteger tag);
@property (copy, nonatomic) void (^NearCheckBlock)(NSInteger tag,NSInteger operationNum);
@property (copy, nonatomic) void (^NearOperationBlock)(NSInteger tag,NSInteger operationNum);

+ (CGFloat)cellHeight;

@end
