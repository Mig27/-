//
//  WPSearchJobController.h
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPGetFriendInfoResult.h"

@interface WPSearchJobController : UIViewController

@property(nonatomic,copy) NSString *friendID;
@property(nonatomic,strong) WPGetFriendInfoResult *result;

@end
