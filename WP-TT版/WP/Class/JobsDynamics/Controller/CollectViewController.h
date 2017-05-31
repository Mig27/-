//
//  CollectViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//  收藏列表页

#import "BaseViewController.h"
#import "IMBaseDefine.pb.h"
@protocol CollectViewControllerDelegate <NSObject>
@optional
- (void)isAlready;
@end
@interface CollectViewController : BaseViewController
@property (nonatomic, weak) id<CollectViewControllerDelegate>delegate;

@property (nonatomic ,assign) BOOL isCheck;
@property (nonatomic, assign) BOOL isFromChat;//从聊天界面来
@property (nonatomic, assign) BOOL isCollectionFromChat;//从聊天界面收藏
@property (nonatomic, assign) BOOL isCollectionFromChatMuch;//聊天界面的批量收藏
@property (nonatomic, strong) NSArray *collectionFromMuchArray;
@property(assign)SessionType sessionType;
@property (nonatomic ,strong) NSString *controller;
@property (nonatomic, strong) NSString *collect_class;  /**< 收藏的类别, 0文字 1图片 2视频 3音频 4动态 5招聘 6求职 7URL链接 8名片 9群相册*/
@property (nonatomic, strong) NSString *user_id;   /**< 被收藏人的id */
@property (nonatomic, strong) NSString *content;   /**< 文字内容 */
@property (nonatomic, strong) NSString *img_url;   /**< 图片地址 */
@property (nonatomic, strong) NSString *vd_url;    /**< 视频地址 */
@property (nonatomic, strong) NSDictionary *dynamicInfo; /**< 分享的动态 */
@property (nonatomic, strong) NSString *jobid;     /**< 分享的招聘或者求职 */
@property (nonatomic, strong) NSString *url;       /**< Url地址 */
@property (nonatomic, strong) NSString *companys;   /**< 公司名称 */
@property (nonatomic, strong) NSString *titles;     /**< 标题 */
@property (nonatomic, assign) BOOL isComeDetail;   /**< 收藏的说说是否来自详情 */
@property (nonatomic, strong) NSString * titleArray;  /**< 批量收藏字符串组 */
@property (nonatomic, strong) NSString *shareStr;
@property (nonatomic, copy) NSString * isHeBing;
@property (nonatomic, copy) NSString * col3;
@property (nonatomic, copy) NSString * col4;

@property (nonatomic, strong)NSDictionary * muchDic;

@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *collectionUrl;
@property (nonatomic, copy) NSString *collectionFlag;

@property (nonatomic, copy) NSString * wpNumber;//唯品号

@property (nonatomic ,strong) NSString *collectionIDs;

@property (nonatomic, strong) void (^collectSuccessBlock)(); /**< 收藏成功 */

@end
