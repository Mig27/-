//
//  GroupPhotoAlumCell.h
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPhotoConsider.h"
#import "GroupBottomView.h"
#import "RSCopyLabel.h"
#import "MLLinkLabel.h"
#import "WPButton.h"
#import "GroupPhotoAlumModel.h"
#import "GroupAlbumCommentAndPraise.h"
@interface GroupPhotoAlumCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;//后面的背景
@property (nonatomic, strong) WPButton *iconBtn;
@property (nonatomic, strong) MLLinkLabel *nickName;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *businessLabel;
@property (nonatomic, strong) RSCopyLabel *descriptionLabel;
@property (nonatomic, strong) GroupPhotoConsider *photos;  //照片墙
@property (nonatomic, strong) GroupBottomView *bottomView; /**< 底部显示赞，评论的详情 */
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *dustbinBtn;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton*twoBtn;

@property (nonatomic, strong) UIButton *allTextBtn;
@property (nonatomic, strong) NSArray * choiseArray;
@property (nonatomic, assign) BOOL isDetailInfo;

@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic,assign)BOOL isNeedMore;
@property (nonatomic,assign)BOOL isOwner;
@property (nonatomic, strong) NSIndexPath *indexPath;  /**< 当前cell的indexPath */
@property (nonatomic, copy) void (^praiseActionBlock)(NSIndexPath *indexPaht); /**< 赞 */
@property (nonatomic, copy) void (^commentActionBlock)(NSIndexPath *indexPaht); /**< 评论 */
@property (nonatomic, copy) void (^deleteActionBlock)(NSIndexPath *indexPaht);  /**< 删除 */
@property (nonatomic, copy) void (^checkActionBlock)(NSIndexPath *indexPath); /**< 查看个人主页 */
@property (nonatomic, copy) void (^clickTwoBtn)(NSIndexPath*indexpath);


@property (nonatomic, copy) void (^clickAllTextBtn)(NSIndexPath*indexpath,UIButton*sender);/**< 点击全文 */
@property (nonatomic, strong) GroupPhotoAlumListModel *dic;
@property (nonatomic, assign) BOOL isFromColume;//从群相册中来

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)calculateHeightWithInfo:(GroupPhotoAlumListModel *)dic isDetail:(BOOL)isDetail;

@end
