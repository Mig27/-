//
//  WPCompanyInforMationView.h
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCompanyListModel.h"

@interface WPCompanyInforMationView : UIView

@property (nonatomic ,strong)NSMutableArray *items;
@property (nonatomic ,strong)WPCompanyListModel *model;

- (WPCompanyListModel *)upDateModel;

@end
