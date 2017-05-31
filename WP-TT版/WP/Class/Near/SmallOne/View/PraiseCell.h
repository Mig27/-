//
//  PraiseCell.h
//  WP
//
//  Created by 沈亮亮 on 15/8/12.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *buttons;

- (void)confignCellWith:(NSArray *)array;

@end
