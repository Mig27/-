//
//  WPCompanyInfoController.h
//  WP
//
//  Created by CBCCBC on 15/10/18.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol WPCompanyInfoDelegate <NSObject>

- (void)WPCompanyInfoDelegate:(NSObject *)model;

@end

@interface WPCompanyInfoController : BaseViewController

@property (copy, nonatomic) NSString *subId;
@property (strong, nonatomic) NSObject *model;
@property (assign, nonatomic) id <WPCompanyInfoDelegate>delegate;

@end
