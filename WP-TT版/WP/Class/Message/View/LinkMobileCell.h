//
//  LinkMobileCell.h
//  WP
//
//  Created by 沈亮亮 on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkMobileModel.h"


typedef void(^acceptActionBlock)(NSString *friendID);

@interface LinkMobileCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UILabel *valiLabel;

@property (nonatomic, strong) acceptActionBlock acceptActionBlock;

@property (nonatomic, strong) LinkMobileListModel *model;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic,copy) void(^opertionAddBlock)(NSIndexPath *indexPath,NSString *title);
@property (nonatomic, assign) BOOL isMobile;/**< 是否是手机联系人 */
@property (nonatomic, copy)void (^clickAccept)(NSString * friendId, NSIndexPath* index);
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
