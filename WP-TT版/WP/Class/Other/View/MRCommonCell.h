//
//  MRCommonCell.h
//  闵瑞微博
//
//  Created by Asuna on 15/4/21.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRCommonItem;
@interface MRCommonCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MRCommonItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
