//
//  NewCommentCell.h
//  WP
//
//  Created by 沈亮亮 on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"

@interface NewCommentCell : UITableViewCell

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) MLLinkLabel *titleLabel;
@property (nonatomic, strong) MLLinkLabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSIndexPath *currentIndex;  /**< 当前cell的indexPath */
@property (nonatomic, copy)  void (^iconClickBlock)(NSIndexPath *index); /**< 头像点击回调 */
@property (nonatomic, copy)  void (^nickNameClickBlock)(NSIndexPath *index); /**< 名字点击回调 */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeightWith:(NSDictionary *)dic;

@end
