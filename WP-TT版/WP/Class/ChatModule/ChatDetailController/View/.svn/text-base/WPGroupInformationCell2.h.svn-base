//
//  WPGroupInformationCell2.h
//  WP
//
//  Created by 沈亮亮 on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPGroupInformationCell2 : UITableViewCell

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;
@property (nonatomic, strong) UIImageView *imageV4;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, copy) void (^addNewMemberBlock)(); /**< 添加新成员 */

- (void)setPhotoWith:(NSArray *)arr andCount:(NSString *)count item:(NSString *)item isAvatar:(BOOL)isAvatar;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
