//
//  WPGroupInformationCell3.h
//  WP
//
//  Created by 沈亮亮 on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPGroupInformationCell3 : UITableViewCell

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) BOOL isNick;       /**< 是否是昵称 */
@property (nonatomic, assign) BOOL isCloaking;   /**< 是否是隐身 */
@property (nonatomic, strong) NSString *itemStr;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *isOn;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, copy) void (^switchActionBlock)(NSIndexPath *index,NSString *statue);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeightIscloaking:(BOOL)cloaking;

@end
