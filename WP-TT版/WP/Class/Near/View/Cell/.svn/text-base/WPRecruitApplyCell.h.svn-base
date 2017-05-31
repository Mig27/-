//
//  WPRecruitApplyCell.h
//  WP
//
//  Created by CBCCBC on 15/11/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPLabel.h"

@interface WPRecruitApplyCell : UITableViewCell

@property (copy, nonatomic) void (^ChooseCurrentRecruitApplyBlock)(NSInteger CellTag);

@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  SPLabel *nameLable;
@property (strong, nonatomic)  SPLabel *detailLable;
@property (strong, nonatomic)  SPLabel *timeLable;
@property (strong, nonatomic)  UIImageView *imageAgainst;
@property (strong, nonatomic)  UIButton *buttonArrow;
@property (strong, nonatomic)  NSObject *model;
@property (strong, nonatomic) NSIndexPath *path;
@property (strong, nonatomic) void (^cellIndexPathClick)(NSIndexPath *path);

//- (void)setModel:(WPInterviewListModel *)model;


+(instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
