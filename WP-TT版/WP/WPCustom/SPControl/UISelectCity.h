//
//  UISelectCity.h
//  test
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"

@protocol UISelectDelegate <NSObject>
//区域的代理
-(void)UISelectDelegate:(IndustryModel *)model;
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model;
//职位的代理
- (void)uiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model;

@end

@class SPIndexPath;
@interface UISelectCity : UIView <UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id <UISelectDelegate> delegate;
@property (assign, nonatomic) BOOL isArea;  
@property (assign, nonatomic) BOOL isIndusty;
@property (nonatomic, assign) BOOL isResume; /**< 是否是全职模块 */
@property (copy, nonatomic) void (^touchHide)();
@property (copy, nonatomic) NSString * localName;//定位地点的名称
@property (copy, nonatomic) NSString * localID;//定位地点的ID
@property (copy, nonatomic) NSString *localFatherId;
@property (copy, nonatomic) NSString *localFatherName;
@property (assign, nonatomic) BOOL isCity;
@property (assign, nonatomic) BOOL isPosition;
@property (assign, nonatomic) BOOL isHiden;//是否隐藏定位图标
@property (strong, nonatomic) UILabel * lineLabel;
@property (nonatomic, assign) BOOL isNew;//陌生人发布
@property (nonatomic, assign) BOOL isFriend;//好友发布
@property (nonatomic, assign) BOOL isWelafer;//选择福利
@property (nonatomic, assign)BOOL isFromHangYe;
@property (strong, nonatomic) UIButton* bottomBtn;
@property (nonatomic, copy)void(^clickBottomBtn)(NSArray*array);
/**
 *  通过给定的网络地址和参数格式进行网络请求
 *
 *  @param urlStr 请求地址
 *  @param params 上传参数
 */
//区域的请求数据
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params citySelectedindex:(SPIndexPath*)selectedIndexPath;

-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params;
//职位的请求数据
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(SPIndexPath *)selectedIndexPath;

/**
 * 本地数据操作
 *
 *  @param arr 给定的数组数据
 */
-(void)setLocalData:(NSArray *)arr;

-(void)setLocalData:(NSArray *)arr selectedIndex:(NSInteger)selectedIndex;

/**
 *  移除视图
 */
-(void)remove;




@end

@interface SPIndexPath : NSObject

@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;

@end
