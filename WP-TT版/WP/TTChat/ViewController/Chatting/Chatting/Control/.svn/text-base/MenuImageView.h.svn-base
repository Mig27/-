//
//  DDMenuImageView.h
//  IOSDuoduo
//
//  Created by 独嘉 on 14-6-12.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuImageView;
typedef NS_ENUM(NSUInteger, DDImageShowMenu)
{
    DDShowEarphonePlay                      = 1,        //听筒播放
    DDShowSpeakerPlay                       = 1 << 1,   //扬声器播放
    DDShowSendAgain                         = 1 << 2,   //重发
    DDShowCopy                              = 1 << 3,   //复制
    DDShowPreview                           = 1 << 4,   //图片预览
    DDShowMore                              = 1 << 5,   //更多
    DDShowtransferText                      = 1 << 6,   //转文字
    DDShowRevoke                            = 1 << 7,   //撤回
    DDShowDelete                            = 1 << 8,   //删除
    DDShowTransmit                          = 1 << 9,   //转发
    DDShowCollect                           = 1 << 10,  //收藏
    DDShowAdd                               = 1 << 11,  //添加
    DDShowLookup                            = 1 << 12   //查看                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
};

@protocol MenuImageViewDelegate <NSObject>

- (void)clickTheCopy:(MenuImageView*)imageView;         /**< 复制 */
- (void)clickTheEarphonePlay:(MenuImageView*)imageView; /**< 听筒 */
- (void)clickTheSpeakerPlay:(MenuImageView*)imageView;  /**< 扬声器 */
- (void)clickTheSendAgain:(MenuImageView*)imageView;    /**< 重发 */
- (void)clickThePreview:(MenuImageView*)imageView;      /**< 图片预览 */
- (void)clickTheTransmit:(MenuImageView *)imageView;    /**< 转发 */
- (void)clickTheCollect:(MenuImageView *)imageView;     /**< 收藏 */
- (void)clickTheDelete:(MenuImageView *)imageView;      /**< 删除 */
- (void)clickTheMore:(MenuImageView *)imageView;        /**< 更多 */

- (void)tapTheImageView:(MenuImageView*)imageView;

@end

@interface MenuImageView : UIImageView
@property (nonatomic,assign)id<MenuImageViewDelegate> delegate;
@property (nonatomic,assign)DDImageShowMenu showMenu;

- (void)showTheMenu;
@end
