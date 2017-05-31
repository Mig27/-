//
//  NearPersonalCell.h
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^coverClickBlock)();

@interface NearPersonalCell : UITableViewCell

@property (copy, nonatomic) void (^attentionBlock)();
@property (copy, nonatomic) void (^clickDetail)(NSIndexPath*indexpath);

@property (strong, nonatomic)  UIImageView *headImageView1;
@property (strong, nonatomic)  UILabel *nameLabel1;
@property (strong, nonatomic)  UILabel *positionLabel1;
@property (strong, nonatomic)  UILabel *companyLabel1;

@property (strong, nonatomic)  UIImageView *contentImageView1;

@property (strong, nonatomic)  UILabel *contentLabel1;

@property (strong, nonatomic)  UILabel *contentDetailLabel1;

@property (strong, nonatomic)  UILabel *timeLabel1;

@property (strong, nonatomic)  UILabel *messageLabel1;

@property (strong, nonatomic)  UILabel *applyLabel1;

@property (strong, nonatomic)  UILabel *broweLabel1;

@property (strong, nonatomic)  UIButton *sysButton1;

@property (strong, nonatomic) UILabel *line;

@property (strong, nonatomic) UIButton *attentionBtn1;

@property (strong, nonatomic) UIButton *topCover; //透明遮罩按钮 点击进入个人资料

@property (copy, nonatomic) coverClickBlock coverClickBlock;

@property (copy, nonatomic) void (^NearPersonalBlock)(NSInteger tag);

@property (strong, nonatomic) NSIndexPath*indexPath;

+ (CGFloat)cellHeight;

@end
