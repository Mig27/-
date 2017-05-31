//
//  GroupNoticeCell.h
//  WP
//
//  Created by 沈亮亮 on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupNoticeModel.h"

@interface GroupNoticeCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;        /**< 背景 */
@property (nonatomic, strong) UILabel *titleLabel;     /**< 标题 */
@property (nonatomic, strong) UIImageView *photoImage; /**< 图片 */
@property (nonatomic, strong) UILabel *contentText;    /**< 文字内容 */
@property (nonatomic, strong) UILabel *infoLabel;      /**< 发布人，发布时间 */
@property (nonatomic, strong) UILabel *moreLabel;      /**< 详情是显示全部的文字 */
@property (nonatomic, strong) UIButton *dustbinBtn;    /**< 删除按钮 */
@property (nonatomic, assign) BOOL isDetail;           /**< 是否是详情 */
@property (nonatomic, assign) BOOL isOwner;            /**< 是否是群主 */
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, copy) void (^deleteBlock)(NSIndexPath *index);
@property (nonatomic, strong) GroupNoticeListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)calculateHeightWithInfo:(GroupNoticeListModel *)model isDetail:(BOOL)isDetail;


@end
