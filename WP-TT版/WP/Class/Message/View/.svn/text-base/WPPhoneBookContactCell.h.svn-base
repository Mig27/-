//
//  WPPhoneBookContactCell.h
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPhoneBookContactDetailModel.h"


@interface WPPhoneBookContactCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) WPPhoneBookContactDetailModel *contactModel;

@property (nonatomic ,assign)BOOL needSelect;//根据他判断是否显示复选框

@property (nonatomic,strong)UIButton *button;  //复选框
-(void)model:(WPPhoneBookContactDetailModel*)model selected:(NSString*)userID;
@end
