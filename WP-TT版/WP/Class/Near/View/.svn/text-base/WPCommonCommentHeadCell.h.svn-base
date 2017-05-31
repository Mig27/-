//
//  WPCommonCommentHeadCell.h
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPResumeMessageModel.h"

@interface WPCommonCommentHeadCell : UITableViewCell
@property (nonatomic ,strong) WPResumeCheckMessageModel *model;
@property (nonatomic, copy) void (^ReplyBlock)(NSInteger number);
@property (nonatomic, copy) void (^UserInfoBlock)(NSString *userId, NSString *userName);
@property(nonatomic, strong)UILabel*line;

+ (CGFloat)cellHeight:(NSString *)string;
//- (BOOL)becomeFirstResponder;
@end
