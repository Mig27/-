//
//  WPGroupSettingViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"
#import "MTTSessionEntity.h"
#import "ChattingModule.h"
@interface WPGroupSettingViewController : BaseViewController

@property (nonatomic, assign) NSString *gtype;
@property (nonatomic, strong) GroupInformationListModel *inforModel;
@property (nonatomic, copy) NSString * groupId;
@property (nonatomic, strong)NSArray * memberArray;
@property (nonatomic, assign)BOOL isFromZhiChang;
@property (nonatomic, copy) NSString*albumID;//群相册id

@property (nonatomic, assign)BOOL isFromGroup;
@property (nonatomic, strong)ChattingModule * mouble;
@property (nonatomic, copy) void (^traneFormSuccess)();
@property (nonatomic, strong) MTTSessionEntity*groupSession;
@end
