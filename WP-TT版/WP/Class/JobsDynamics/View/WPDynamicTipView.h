//
//  WPDynamicTipView.h
//  WP
//
//  Created by 沈亮亮 on 16/4/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPBadgeButton.h"

@interface WPDynamicTipView : UIView

@property (nonatomic, strong) UIImageView *iconImageView; /**< 头像 */
@property (nonatomic, strong) WPBadgeButton *badgBtn;     /**< 小红点 */
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) void (^clickBlock)();       /**< 点击回调 */

- (void)configeWith:(NSString *)avatar count:(NSString *)count;

@end
