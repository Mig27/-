//
//  WPCompanysCell.h
//  WP
//
//  Created by CBCCBC on 15/10/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCompanyModel.h"
#import "WPPersonListModel.h"
#import "THLabel.h"
#import "WPCompanysModel.h"

@interface WPCompanysCell : UITableViewCell
@property (nonatomic, strong) CompanyModel *companyModel;
@property (strong, nonatomic) WPCompanyListDetailModel *listModel;
@property (nonatomic ,strong) WPPersonModel *personModel;

@property (copy, nonatomic) void (^ChooseCurrentCompanyForResumeBlock)(NSInteger CellTag);

+(instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) THLabel *editLabel;
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, assign) BOOL isHideChoise;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) BOOL choiseCompany;
@end
