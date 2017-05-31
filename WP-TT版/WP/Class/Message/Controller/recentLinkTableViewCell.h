//
//  recentLinkTableViewCell.h
//  WP
//
//  Created by CC on 16/8/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTSessionEntity.h"
@interface recentLinkTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UIImageView*iconImage;
@property (nonatomic, strong)UIImageView*rightImage;
@property (nonatomic, strong)UIButton * groupBtn;
-(void)setNameAndImage:(MTTSessionEntity*)session;
-(void)resetNamelLabel:(BOOL)isFirst;
@end
