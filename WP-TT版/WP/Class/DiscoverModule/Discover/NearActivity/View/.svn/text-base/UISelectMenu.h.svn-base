//
//  UISelectMenu.h
//  WP
//
//  Created by 沈亮亮 on 15/10/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"

@class UISelectMenu;
@protocol UISelectMenuDelegate <NSObject>

-(void)UISelectDelegate:(IndustryModel *)model selectMenu:(UISelectMenu *)menu;

@end

@interface UISelectMenu : UIView<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id <UISelectMenuDelegate> delegate;
@property (assign, nonatomic) BOOL isArea;
@property (copy, nonatomic) void (^touchHide)();

/**
 *  通过给定的网络地址和参数格式进行网络请求
 *
 *  @param urlStr 请求地址
 *  @param params 上传参数
 */
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params;

/**
 * 本地数据操作
 *
 *  @param arr 给定的数组数据
 */
-(void)setLocalData:(NSArray *)arr;

/**
 *  移除视图
 */
-(void)remove;

@end
