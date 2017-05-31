//
//  DefultAnonymousController.h
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
@protocol DefultAnonymousControllerDelegate<NSObject>
@optional
- (void)requestForData;
@end

@interface DefultAnonymousController : BaseViewController
@property (nonatomic ,weak)id<DefultAnonymousControllerDelegate>delegate;
@end
