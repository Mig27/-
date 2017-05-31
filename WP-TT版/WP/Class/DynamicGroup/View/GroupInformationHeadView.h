//
//  GroupInformationHeadView.h
//  WP
//
//  Created by 沈亮亮 on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupInformationModel.h"

@interface GroupInformationHeadView : UIView

@property (nonatomic, strong) GroupInformationListModel *model;

- (instancetype)initWithFrame:(CGRect)frame andModel:(GroupInformationListModel *)model;

- (void)resetWith:(GroupInformationListModel *)model;

@end
