//
//  GroupCommentCell.h
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
#import "GroupPhotoAlumModel.h"

@interface GroupCommentCell : UITableViewCell

@property (nonatomic, strong) MLLinkLabel *commentLabel;
@property (nonatomic, strong) CommentListModel *dic;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *discussIndexPath;
//@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSIndexPath *currentIndex;  /**< 当前cell的indexPath */

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeightWithIndex:(NSIndexPath *)index andDatasource:(NSArray *)data;


@end
