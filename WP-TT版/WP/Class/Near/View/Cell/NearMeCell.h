//
//  NearMeCell.h
//  WP
//
//  Created by CBCCBC on 15/9/25.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton1.h"

@interface NearMeCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel1;
@property (strong, nonatomic) UILabel *positionLabel1;
@property (strong, nonatomic) UILabel *companyLabel1;

@property (nonatomic ,strong) NSString *time;
@property (strong, nonatomic) UILabel *contentLabel1;
@property (strong, nonatomic) UIImageView *headImageView1;
@property (strong, nonatomic) UIImageView *contentImageView1;
@property (strong, nonatomic) UILabel *contentDetailLabel1;
@property (nonatomic ,strong) UIButton *deleteBtn;


//@property (strong, nonatomic) UIButton *messageLabel1;
//@property (strong, nonatomic) UIButton *applyLabel1;
//@property (strong, nonatomic) UIButton *broweLabel1;
//@property (strong, nonatomic) UIButton *shareLabel;
//@property (strong, nonatomic) UIButton *sysButton1;

//@property (strong, nonatomic) SPButton1 *delButton1;
//@property (strong, nonatomic) SPButton1 *editButton1;
//@property (strong, nonatomic) SPButton1 *refButton1;
@property (strong, nonatomic) SPButton1 *downButton1;
@property (nonatomic, strong) UILabel*signLabel;
//@property (strong, nonatomic) SPButton1 *upButton1;

@property (strong, nonatomic) UILabel *line;

@property (copy, nonatomic) void (^NearMeBlock)(NSInteger tag);
@property (copy, nonatomic) void (^NearOperationBlock)(NSInteger tag,NSInteger operationNum);
@property (copy, nonatomic) void (^clickHeadImage)();
@property (copy, nonatomic) void (^clickName)();

+ (CGFloat)cellHeight;

@end
