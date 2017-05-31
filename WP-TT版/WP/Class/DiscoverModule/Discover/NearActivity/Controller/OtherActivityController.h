//
//  OtherActivityController.h
//  WP
//
//  Created by 沈亮亮 on 15/10/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//typedef void (^DealsSuccessBlock)(NSArray *datas,int more);
//typedef void (^DealsErrorBlock)(NSError *error);

@interface OtherActivityController : BaseViewController

@property (nonatomic,strong) NSString *game_type;
@property (nonatomic,strong) NSString *titleStr;

@end
