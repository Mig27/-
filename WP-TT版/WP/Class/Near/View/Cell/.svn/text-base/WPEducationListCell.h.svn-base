//
//  WPEducationListCell.h
//  WP
//
//  Created by CBCCBC on 15/12/30.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPEducationListCellModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface WPEducationListCell : UITableViewCell
@property (nonatomic ,assign)BOOL edit;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^SelectedItemBlock)(NSIndexPath *indexPath,BOOL isSelected);

- (void)updateName:(NSString *)name Info:(NSString *)info isSelected:(BOOL)isSelected;

@end
