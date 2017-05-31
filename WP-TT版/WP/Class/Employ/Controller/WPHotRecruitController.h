//
//  WPComputerController.h
//  WP
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPHotRecruitController : BaseViewController

@property (copy, nonatomic) NSString *hotArea;/**< 热门专区 */
@property (copy, nonatomic) NSString *hotPosition;/**< 热门职位 */
@property (assign, nonatomic) BOOL isNear;/**< 是否为附近的职位 */

@end
