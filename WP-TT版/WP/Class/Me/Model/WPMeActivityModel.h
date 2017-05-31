//
//  WPMeActivityModel.h
//  WP
//
//  Created by CBCCBC on 16/1/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@class WPMeActivityListModel;
@interface WPMeActivityModel : BaseModel

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong) NSArray<WPMeActivityListModel *> *list;
@property (nonatomic, copy) NSString *pageIndex;

@end
@interface WPMeActivityListModel : NSObject

@property (nonatomic, copy) NSString *address;/**< 地点 */
@property (nonatomic, copy) NSString *sign_id;/**< 报名ID */
@property (nonatomic, copy) NSString *show_img;/**< 主题图片 */
@property (nonatomic, copy) NSString *bigen_time;/**< 开始时间 */
@property (nonatomic, copy) NSString *game_id;/**< 活动ID */
@property (nonatomic, copy) NSString *title;/**< 互动主题 */
@property (nonatomic, copy) NSString *signCount;/**< 报名人数 */
@property (nonatomic, copy) NSString *sign_status;/**< 报名状态 */

@end

