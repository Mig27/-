//
//  WPSearchMaximaCell.h
//  WP
//
//  Created by CBCCBC on 15/11/19.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSearchMaximaCell : UITableViewCell

@property (strong ,nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSObject *model;
@property (strong, nonatomic) void (^cellIndexPathClick)(NSIndexPath *path);
@property (strong, nonatomic) void (^detailBlock)(NSIndexPath *path);

+ (instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
