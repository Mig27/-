//
//  PraisePersonView.h
//  WP
//
//  Created by 沈亮亮 on 16/3/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraisePersonView : UIView

@property (nonatomic, strong) NSArray *praiseArr; /**< 点赞的数组 */

@property (nonatomic, strong) NSString *praiseCount; /**< 点赞的人数 */

+ (CGFloat)calculateHeightWithInfo:(NSArray *)arr; /**< 返回高度 */


@end
