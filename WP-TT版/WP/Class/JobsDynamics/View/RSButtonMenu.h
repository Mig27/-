//
//  RSButtonMenu.h
//  WP
//
//  Created by 沈亮亮 on 15/11/4.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"

@class RSButtonMenu;
@protocol RSButtonMenuDelegate <NSObject>

-(void)RSButtonMenuDelegate:(id)model selectMenu:(RSButtonMenu *)menu selectIndex:(NSInteger)index;

@end

@interface RSButtonMenu : UIView

@property (assign, nonatomic) id <RSButtonMenuDelegate> delegate;
@property (assign, nonatomic) BOOL isArea;
@property (nonatomic, assign) BOOL isGroupCreate;
@property (nonatomic,assign) BOOL isFromGroup;//从职场群组中点击行业
@property (copy, nonatomic) void (^touchHide)();
@property (nonatomic, copy) NSString * imageString;//图片
@property (nonatomic, assign)BOOL isFriend;//小红点
@property (nonatomic, assign)BOOL isNew;//新说说红点

/**
 * 本地数据操作
 *
 *  @param arr 给定的数组数据
 */
-(void)setLocalData:(NSArray *)arr;

-(void)setLocalTime:(NSArray *)arr andSelectTime:(NSString *)time;

/**
 *  记录当前行的本地数据操作
 *
 *  @param arr   给定的数组数据
 *  @param index 上一次选中的选项
 */
- (void)setNewLocalData:(NSArray *)arr andSelectIndex:(NSInteger)index;

- (void)setLocalType:(NSArray *)arr andSelectIndex:(NSInteger)index;


/**
 *  请求的网络数据
 *
 *  @param urlStr        url
 *  @param params        参数
 *  @param selectedIndex 上次选择的行数
 */
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(NSInteger)selectedIndex;

/**
 *  非工作圈请求网络数据
 *
 *  @param urlStr        url
 *  @param params        参数
 *  @param selectedIndex 上次选择的行数
 */
- (void)newSetUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(NSInteger)selectedIndex;

/**
 *  移除视图
 */
-(void)remove;


@end
