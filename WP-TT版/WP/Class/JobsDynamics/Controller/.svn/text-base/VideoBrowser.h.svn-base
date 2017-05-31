//
//  VideoBrowser.h
//  WP
//
//  Created by 沈亮亮 on 15/7/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTMessageEntity.h"
@interface VideoBrowser : UIViewController

@property (nonatomic,strong) NSString *videoUrl; //视频的url
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *vd_url;

@property (nonatomic, strong)NSMutableArray * videoArray;
@property (nonatomic, strong)NSArray * allArray;

@property (nonatomic, assign) BOOL hideDown;
@property (nonatomic, assign) int currentPosition;
@property (nonatomic ,assign) BOOL isNetOrNot;
@property (nonatomic, assign) BOOL isCreat;
@property (nonatomic, assign) BOOL addLongPress;

- (void)show;
- (void)showPickerVc:(UIViewController *)vc;
@end
