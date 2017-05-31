//
//  WPGroupAlumDetailViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/29.
//  Copyright © 2016年 WP. All rights reserved.
//  消息 --> 列表  --> 聊天详情页 ---> 群相册cell查看 -->群相册

#import "BaseViewController.h"
#import "GroupPhotoAlumModel.h"
#import "WPTitleView.h"
#import "ChattingModule.h"
@interface WPGroupAlumDetailViewController : BaseViewController

@property (nonatomic, strong) GroupPhotoAlumListModel *info;//GroupPhotoAlumModel
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, copy) NSString*groupId;//发消息的id
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, assign) BOOL isCommetFromAlum;
@property (nonatomic, assign) BOOL isFromAlbumNoti;
@property (nonatomic, copy) NSString * fromAlbumUserName;//群相册消息点击的人名
@property (nonatomic, copy) NSString * fromAlbumUserId;//群相册消息点击的人的id
@property (nonatomic, copy) NSString * fromAlbumCommentId;//消息的ID
@property (nonatomic, copy) NSString * fromAlbumComment;//回复的消息
@property (nonatomic, strong)WPTitleView* titleView;
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, assign) BOOL isNeedChat;
@property (nonatomic, assign) BOOL isBack;
@property (nonatomic, strong) ChattingModule * mouble;


@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, copy) NSString * scrollerStr;//滚动的位置
@property (nonatomic, assign) NSInteger currentIndex;     //当前页(0浏览，1评论，2赞)
@property (nonatomic, copy)  void(^deleteSuccessBlock)(NSIndexPath *index); /**< 删除成功回调 */
@property (nonatomic, copy) void (^praiseSuccessBlock)(NSIndexPath *index); /**< 点赞成功的回调 */
@property (nonatomic, copy) void (^commentSuccessBlock)(NSIndexPath *index); /**< 评论的回调 */

@end
