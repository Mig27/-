//
//  NewDetailViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/2/24.
//  Copyright © 2016年 WP. All rights reserved.
//  发现 --> 话题 --> 列表 --> 点击cell 进如详情

#import "BaseViewController.h"
#import "UIMessageInputView.h"
#import "WPTitleView.h"
typedef NS_ENUM(NSInteger,DetailJumpTo) {
    DetailJumpToShare = 1,
    DetailJumpToComment,
    DetailJumpToApply
};

@interface NewDetailViewController : BaseViewController
@property (nonatomic, strong)WPTitleView*titleView;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSIndexPath *clickIndex; /**< 点击的cell的当前行 */
@property (nonatomic, assign) BOOL isCommentFromDynamic; /**< 是否来之工作圈的评论 */
@property (nonatomic, assign) BOOL isShare; /**< 是否是点分享进来 */
@property (nonatomic, assign) BOOL isFromCollection;/**< 是否是从收藏中进来的 */
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, strong) NSDictionary*chatDic;
@property (nonatomic, copy)  void(^deleteSuccessBlock)(NSIndexPath *index); /**< 删除成功回调 */
@property (nonatomic, copy) void (^praiseSuccessBlock)(NSIndexPath *index,NSString *sid); /**< 点赞成功的回调 */
@property (nonatomic, copy) void (^commentSuccessBlock)(NSIndexPath *index,NSString *sid); /**< 评论的回调 */
@property (nonatomic, copy) void (^shareSuccessBlock)(NSIndexPath *index,NSString *sid); /**< 分享的回调 */
@property (nonatomic, copy) void (^deleteComentBlock)();//删除评论成功

/**评论 键盘 */
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, assign) DetailJumpTo jumpType;
@property (nonatomic, strong) NSString *destination_id; //要调到位置的id
@property (nonatomic, strong) NSString *nickName;       //要回复的人的名字

- (void)keyBoardDismiss;

@end
