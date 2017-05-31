//
//  ConditionCell.h
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,assign) BOOL btnIsSelect;

@end
