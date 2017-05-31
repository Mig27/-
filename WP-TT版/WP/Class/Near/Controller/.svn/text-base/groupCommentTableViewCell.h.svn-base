//
//  groupCommentTableViewCell.h
//  WP
//
//  Created by CC on 16/9/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicNewsModel.h"
#import "WPButton.h"
#import "MLLinkLabel.h"
@interface groupCommentTableViewCell : UITableViewCell
@property (nonatomic, strong)DynamicNewsListModel*model;
@property (nonatomic, strong) WPButton *iconBtn;       /**< 头像 */
@property (nonatomic, strong) MLLinkLabel *nameLabel;  /**< 昵称 */
@property (nonatomic, strong) UILabel *commentLabel;   /**< 评论的内容 */
@property (nonatomic, strong) UIImageView *praiseImage;/**< 赞 */
@property (nonatomic, strong) UILabel *timeLabel;      /**< 时间 */
@property (nonatomic, strong) UIImageView *photoImage; /**< 动态图片 */
@property (nonatomic, strong)NSIndexPath*index;
@property (nonatomic, copy) void(^clickIcon)(NSIndexPath*index);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)rowHeightWithModel:(DynamicNewsListModel *)model;
@end
