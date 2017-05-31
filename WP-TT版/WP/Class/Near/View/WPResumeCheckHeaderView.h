//
//  WPResumeCheckHeaderView.h
//  WP
//
//  Created by CBCCBC on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearPersonalController.h"

@interface WPResumeCheckHeaderView : UIView
@property (nonatomic ,strong)UIView *sportLine;
@property (nonatomic ,strong)NSArray *buttonArr;
@property (nonatomic ,strong)NearPersonalListModel *model;
@property (nonatomic ,assign)BOOL isRecruit;
@property (nonatomic ,strong)UIButton *contentButton;
@property (nonatomic ,strong)UIButton *browseBtn;
@property (nonatomic ,strong)UIButton *messageBtn;
@property (nonatomic ,strong)UIButton *shareBtn;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
