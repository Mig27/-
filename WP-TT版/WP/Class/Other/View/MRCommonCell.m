//
//  MRCommonCell.m
//  闵瑞微博
//
//  Created by Asuna on 15/4/21.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import "MRCommonCell.h"
#import "MRCommonArrowItem.h"
#import "MRCommonSwitchItem.h"
#import "MRCommonLabelItem.h"
#import "MRCommonCheckItem.h"
#import "WPBadgeButton.h"
#import "UIImage+MR.h"
@interface MRCommonCell()
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *rightArrow;
/**
 *  打钩
 */
@property (strong, nonatomic) UIImageView *rightCheck;
/**
 *  右边的提醒数字
 */
@property (strong, nonatomic) WPBadgeButton *rightBadgeButton;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch *rightSwitch;
/**
 *  标签
 */
@property (strong, nonatomic) UILabel *rightLabel;

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation MRCommonCell
#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UIImageView *)rightCheck
{
    if (_rightCheck == nil) {
        self.rightCheck = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_checkmark"]];
    }
    return _rightCheck;
}

- (WPBadgeButton *)rightBadgeButton
{
    if (_rightBadgeButton == nil) {
        self.rightBadgeButton = [[WPBadgeButton alloc] init];
    }
    return _rightBadgeButton;
}

- (UISwitch *)rightSwitch
{
    if (_rightSwitch == nil) {
        self.rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    MRCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MRCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1.设置文字的字体
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // 2.设置cell的背景
        // backgroundView的优先级 > backgroundColor
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        self.backgroundView = [[UIImageView alloc] init];
    }
    return self;
}

#pragma mark - setter
- (void)setItem:(MRCommonItem *)item
{
    _item = item;
    
    // 1.设置图标
    self.imageView.image = [UIImage imageWithName:item.icon];
    
    // 2.设置标题
    self.textLabel.text = item.title;
    
    // 3.设置子标题
    self.detailTextLabel.text = item.subttile;
    
    // 4.设置右边显示的控件
    [self setupRightView];
}

/**
 *  设置右边显示的控件
 */
- (void)setupRightView
{
    if (self.item.badgeValue) {
        // 显示提醒数字
        self.rightBadgeButton.badgeValue = self.item.badgeValue;
        self.accessoryView = self.rightBadgeButton;
    } else if ([self.item isKindOfClass:[MRCommonArrowItem class]]) {
        // 显示箭头
        self.accessoryView = self.rightArrow;
    } else if ([self.item isKindOfClass:[MRCommonSwitchItem class]]) {
        // 显示开关
        self.accessoryView = self.rightSwitch;
    } else if ([self.item isKindOfClass:[MRCommonLabelItem class]]) {
        // 显示label
        self.accessoryView = self.rightLabel;
        
        // 设置label的文字
        MRCommonLabelItem *labelItem = (MRCommonLabelItem *)self.item;
        self.rightLabel.text = labelItem.text;
        
        // 计算尺寸
        CGSize size =     [labelItem.text sizeWithAttributes:@{NSFontAttributeName:self.rightLabel.font}];
        self.rightLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    } else if ([self.item isKindOfClass:[MRCommonCheckItem class]]) {
        // 显示打钩
        MRCommonCheckItem *checkItem = (MRCommonCheckItem *)self.item;
        if (checkItem.isChecked) {
            self.accessoryView = self.rightCheck;
        } else {
            self.accessoryView = nil;
        }
    } else { // 右边不需要显示任何东西
        self.accessoryView = nil;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    // 1.取出背景view
    UIImageView *bg = (UIImageView *)self.backgroundView;
    UIImageView *selectedBg = (UIImageView *)self.selectedBackgroundView;
    
    // 2.根据cell显示的具体位置, 来设置背景view显示的图片
    // 获得cell这组的总行数
    int totalRows = (int)[self.tableView numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        bg.image = [UIImage resizableImage:@"common_card_background"];
        selectedBg.image = [UIImage resizableImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        bg.image = [UIImage resizableImage:@"common_card_top_background"];
        selectedBg.image = [UIImage resizableImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        bg.image = [UIImage resizableImage:@"common_card_bottom_background"];
        selectedBg.image = [UIImage resizableImage:@"common_card_bottom_background_highlighted"];
    } else {
        bg.image = [UIImage resizableImage:@"common_card_middle_background"];
        selectedBg.image = [UIImage resizableImage:@"common_card_middle_background_highlighted"];
    }
}

#pragma mark - 为了拦截frame的设置, 在这里统一设置所有cell的frame
- (void)setFrame:(CGRect)frame
{
    if (iOS7) {
        //        frame.origin.y -= 25; // 让所有cell的y值减少25
    } else {
        frame.origin.x = -10;
        frame.size.width += 20;
    }
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整子标题的x值
    self.detailTextLabel.frame = CGRectMake( CGRectGetMaxX(self.textLabel.frame) + 10, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
   ;
}

@end
