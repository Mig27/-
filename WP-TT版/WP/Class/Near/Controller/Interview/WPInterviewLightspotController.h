//
//  WPInterviewLightspotController.h
//  WP
//
//  Created by CBCCBC on 15/12/14.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

@protocol WPInterviewLightspotDelegate <NSObject>

- (void)getLightspotWithConstant:(NSString *)constant content:(NSString *)contents;

@end

@interface WPInterviewLightspotController : BaseViewController

@property (nonatomic,strong) NSMutableArray *objects;         // 用来存放活动详情的相关数据
@property (nonatomic, copy) NSString *buttonString;
@property (nonatomic,copy) NSString *lightStr; //用来存放亮点描述
@property (nonatomic, assign) id <WPInterviewLightspotDelegate> delegate;

@end
