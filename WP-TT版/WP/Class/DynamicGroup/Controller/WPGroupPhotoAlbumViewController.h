//
//  WPGroupPhotoAlbumViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"
#import "WPTitleView.h"
#import "ChattingModule.h"
@interface WPGroupPhotoAlbumViewController : BaseViewController

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, assign) BOOL isOwner;  /**< 是否是群主 */

@property (nonatomic, copy)NSString * groupId;
@property (nonatomic, assign)BOOL  isNeedChat;
@property (nonatomic, copy)NSString * numberOfClume;
@property (nonatomic, strong)WPTitleView * titleView;
@property (nonatomic, strong)ChattingModule*mouble;
@end
