//
//  WorkTableViewCell.h
//  WP
//
//  Created by 沈亮亮 on 15/7/6.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageConsider.h"
#import "FunctionView.h"
#import "WPButton.h"
#import "WPControl.h"
#import "WPNicknameLabel.h"
#import "ShareResume.h"
#import "ShareDynamic.h"
#import "DynamicBottomView.h"
#import "RSCopyLabel.h"
#import "MLLinkLabel.h"
#import "WPDDChatVideo.h"
#import "modeView.h"
typedef enum : NSUInteger{
    CellLayoutTypeNormal,       //正常的布局
    CellLayoutTypeSpecial,      //特殊的布局
}CellLayoutType;

typedef enum : NSUInteger{
    WorkCellTypeNormal,       //正常的布局
    WorkCellTypeSpecial,      //特殊的布局
}WorkCellType;

@protocol refreshData <NSObject>

- (void)refreshDataWith:(NSString *)statue;

@end

//@class WorkTableViewCell;
//@protocol commentDelegate <NSObject>
//
//- (void)commentWithInfo:(NSDictionary *)dic andObj:(WorkTableViewCell *)cell;
//
//@end

@interface WorkTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, strong) modeView*screenBtn;
@property (nonatomic, strong) UIView *backView;//后面的背景
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) WPButton *iconBtn;
@property (nonatomic, strong) MLLinkLabel *nickName;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *businessLabel;
@property (nonatomic, strong) RSCopyLabel *descriptionLabel;
@property (nonatomic, strong) imageConsider *photos;  //照片墙
@property (nonatomic, strong) ShareResume *resume;    //分享的简历，招聘
@property (nonatomic, strong) ShareDynamic *dynamic;  //分享的说说
@property (nonatomic, strong) DynamicBottomView *bottomView; /**< 底部显示赞，分享，评论的详情 */
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) RSClikcButton *dustbinBtn;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) WPButton *functionBtn;
@property (nonatomic, strong) NSDictionary *dicInfo;
@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, assign) CGFloat y;//起始坐标
@property (nonatomic, strong) UIImageView *functionImage;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *allTetBtn;//全文按钮
@property (nonatomic, strong) UIView * whiteBackView;
@property (nonatomic, copy) void (^clickAllTextBtn)(NSIndexPath*indecpath,UIButton*sender);
@property (nonatomic, strong) NSArray*choiseArray;

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) FunctionView *f;
//@property (nonatomic, assign) id<commentDelegate>delegate;
@property (nonatomic, strong) NSDictionary *myDic;
@property (nonatomic, strong) WPControl *iconControl;

@property (nonatomic,assign) CellLayoutType cellType;
@property (nonatomic,assign) WorkCellType type;

@property (nonatomic, strong) RSClikcButton *praiseBtn;
@property (nonatomic, strong) RSClikcButton *commentBtn;

@property (nonatomic, strong) UIButton*threeBtn;
@property (nonatomic, strong)WPDDChatVideo*video;
@property (nonatomic, assign) BOOL workNetState;//根据网络状态判断是否自动播放；

@property (nonatomic,assign) BOOL is_praise;
@property (nonatomic,assign) id<refreshData> delegate2;
@property (nonatomic,assign)BOOL isNeedMore;
@property (nonatomic,assign)BOOL isFromDetail;

@property (nonatomic, copy) NSString * filePath;
@property (nonatomic, strong) NSIndexPath *indexPath;  /**< 当前cell的indexPath */
@property (nonatomic, copy) void (^praiseActionBlock)(NSIndexPath *indexPaht); /**< 赞 */
@property (nonatomic, copy) void (^commentActionBlock)(NSIndexPath *indexPaht); /**< 评论 */
@property (nonatomic, copy) void (^shareActionBlock)(NSIndexPath *indexPaht);  /**< 分享 */
@property (nonatomic, copy) void (^deleteActionBlock)(NSIndexPath *indexPaht);  /**< 删除 */
@property (nonatomic, copy) void (^checkActionBlock)(NSIndexPath *indexPath); /**< 查看个人主页 */
@property (nonatomic, copy) void (^clickShareResume)(NSIndexPath *indexPath);/**<点击分享的简历和招聘*/

@property (nonatomic, copy) void (^clickThreeButton)(NSIndexPath*indexpath);

- (void)confineCellwithData:(NSDictionary *)dic;

//- (void)commentBtnClick;


@end
