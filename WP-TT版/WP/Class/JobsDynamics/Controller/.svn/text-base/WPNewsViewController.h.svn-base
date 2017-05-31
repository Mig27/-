//
//  WPNewsViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "ChattingModule.h"

typedef NS_ENUM(NSInteger,NewsType) {
    NewsTypeDynamic, //工作圈
    NewsTypeGroup,   //群组
    NewsTypeInvite,  // 招聘
    NewsTypeResume,  //求职
    NewsTypeSchoolInvite, //校园招聘
    NewsTypeSchoolResume, //校园求职
};

@interface WPNewsViewController : BaseViewController

@property (nonatomic, assign) BOOL isComeFromePersonal;
@property (nonatomic, copy) void (^readOverBlock)();
@property (nonatomic, assign) NewsType type;
@property (nonatomic, assign) BOOL isFromAmblu;
@property (nonatomic, copy) NSString*groupId;
@property (nonatomic, copy) NSString * gid;
@property (nonatomic, strong)ChattingModule * mouble;

@end
