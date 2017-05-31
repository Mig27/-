//
//  WPGroupNoticeViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"
#import "ChattingModule.h"
@interface WPGroupNoticeViewController : BaseViewController

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, strong) NSString *gtype;
@property (nonatomic, copy) NSString * groupId;
@property (nonatomic, strong)ChattingModule*mouble;

@end
