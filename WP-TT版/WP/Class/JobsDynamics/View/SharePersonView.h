//
//  SharePersonView.h
//  WP
//
//  Created by 沈亮亮 on 16/3/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePersonView : UIView

@property (nonatomic, strong) NSArray *shareArr; /**< 分享的数组 */

@property (nonatomic, strong) NSString *shareCount; /**< 分享的人数 */

+ (CGFloat)calculateHeightWithInfo:(NSArray *)arr; /**< 返回高度 */

@end
