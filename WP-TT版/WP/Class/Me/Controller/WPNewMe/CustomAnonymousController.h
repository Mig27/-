//
//  CustomAnonymousController.h
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
@protocol CustomAnonymousControllerDelegate<NSObject>
@optional
- (void)requestForData;
@end
@interface CustomAnonymousController : BaseViewController
@property (nonatomic ,weak)id<CustomAnonymousControllerDelegate>delegate;
@end
