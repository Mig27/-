//
//  WPNewResumeCell.h
//  WP
//
//  Created by CBCCBC on 16/6/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
#import "WPButton.h"
#import "DynamicNewsModel.h"
#import "WPNewsViewController.h"
@interface WPNewResumeCell : UITableViewCell

@property (nonatomic, strong) WPButton *iconBtn;       /**< 头像 */
@property (nonatomic, strong) MLLinkLabel *nameLabel;  /**< 昵称 */
@property (nonatomic, strong) UILabel *commentLabel;   /**< 评论的内容 */
@property (nonatomic, strong) UIImageView *praiseImage;/**< 赞 */
@property (nonatomic, strong) UILabel *timeLabel;      /**< 时间 */
@property (nonatomic, strong) UIImageView *photoImage; /**< 动态图片 */
//@property (nonatomic, strong) UILabel *dynamicLabel;   /**< 动态内容 */
@property (nonatomic, strong) DynamicNewsListModel *model;
@property (nonatomic, assign) NewsType type;
@property (nonatomic, strong) NSIndexPath*index;
@property (nonatomic, copy) void(^clickPhoto)(NSIndexPath*index);


+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeightWithModel:(DynamicNewsListModel *)model;

@end
