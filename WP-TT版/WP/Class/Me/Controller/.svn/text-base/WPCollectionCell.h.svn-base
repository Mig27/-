//
//  WPCollectionCell.h
//  WP
//
//  Created by CBCCBC on 16/4/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "WPCollectionModel.h"
#import "WPApplyView.h"
@protocol WPCollectionCellDelegate <NSObject>
- (void)selectedOfbuttonChanged;
@end
@interface WPCollectionCell : UITableViewCell
@property (nonatomic ,strong)NSDictionary *info;
@property (nonatomic ,assign)BOOL select;

@property (nonatomic, copy) NSString * firstStr;
@property (nonatomic, copy) NSString * secondStr;

@property (nonatomic, strong)UIButton *selectbtn;
@property (nonatomic ,assign)WPCollectionModel *model;
@property (nonatomic, strong)NSIndexPath * indexpath;
@property (nonatomic, assign)BOOL isFromChat;
@property (nonatomic, copy) void (^clickBtn)(NSIndexPath*indexpath,UIButton*sender);

@property (nonatomic, copy) void (^clickImageAndVideo)(NSIndexPath*indexpath);
@property (nonatomic ,strong)id<WPCollectionCellDelegate>delegate;
- (CGFloat)getCellHeight;
@end
