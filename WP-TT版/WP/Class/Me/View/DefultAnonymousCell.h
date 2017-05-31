//
//  DefultAnonymousCell.h
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnonymousModel.h"
typedef void (^choosingblock)(AnonymousModel *model);

@interface DefultAnonymousCell : UITableViewCell
@property (nonatomic ,copy)choosingblock choosingblock;
@property (nonatomic ,strong)AnonymousModel *model;
@property (nonatomic ,strong)UIButton *button;
@end
