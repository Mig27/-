//
//  WPCompanyBriefController.h
//  WP
//
//  Created by CBCCBC on 15/12/16.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

@protocol WPCompanyBriefDelegate <NSObject>

- (void)getCompanyBrief:(NSArray *)briefArray;

@end

@interface WPCompanyBriefController : BaseViewController

@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) id <WPCompanyBriefDelegate> delegate;

@end
