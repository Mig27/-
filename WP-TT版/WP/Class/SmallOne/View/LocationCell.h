//
//  LocationCell.h
//  WP
//
//  Created by 沈亮亮 on 15/7/30.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *locationLabel;

- (void)setLocationWith:(NSDictionary *)dic;

@end
