//
//  WPNewResumeHeaderView.h
//  WP
//
//  Created by CBCCBC on 16/6/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPBadgeButton.h"

@interface WPNewResumeHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *iconImageView; /**< 头像 */
@property (nonatomic, strong) WPBadgeButton *badgBtn;     /**< 小红点 */
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) void (^clickBlock)();       /**< 点击回调 */

- (void)configeWith:(NSString *)avatar count:(NSString *)count;

@end
