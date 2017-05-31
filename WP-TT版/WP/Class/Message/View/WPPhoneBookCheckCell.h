//
//  WPPhoneBookCheckCell.h
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPhoneBookFriendCategoryModel.h"

typedef void (^checkboxBlock)();

@protocol WPPhoneBookCheckCellDelegate <NSObject>

@optional
- (void)editTypeId:(NSString *)typeId andeditValue:(NSString *)value;
@end


@interface WPPhoneBookCheckCell : UITableViewCell

@property (nonatomic ,assign)BOOL needSelect;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong) WPPhoneBookFriendCategoryModel *model;
@property (nonatomic , strong)UITextField *titleLabel;
@property (nonatomic,weak)id <WPPhoneBookCheckCellDelegate> delegate;
@property (nonatomic,strong)UIButton *button;

@property (nonatomic,copy) checkboxBlock checkboxBlock;


@end
