//
//  WPSmallCell.h
//  WP
//
//  Created by Asuna on 15/5/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPSmallCell;
@protocol WPSmallCellDelegate <NSObject>

@optional
-(void)clickKeyboard:(WPSmallCell*)smallCell;

@end

@interface WPSmallCell : UITableViewCell
@property (nonatomic,weak) id<WPSmallCellDelegate> delegate;
- (IBAction)buttonClick:(UIButton *)sender;
+ (instancetype)cellWithTableView:(UITableView*)tableView;
+ (CGFloat)rowHeight;
@end
