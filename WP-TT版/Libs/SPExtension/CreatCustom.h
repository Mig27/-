//
//  CreatCustom.h
//  BoYue
//
//  Created by Leejay on 14/12/8.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PI 3.1415926

@interface CreatCustom : NSObject

/**AlertView*/
+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName;

/**判断输入是否为空*/
+(BOOL)isNULL:(NSString *)str;
/**返回视图的Frame和背景颜色*/
+(UIView *)creatUIViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor;


/**返回距离左右边框等距的Frame*/
+(CGRect)creatFrameWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height;
/**返回简单地HUD信息*/
+(void)createHUD:(NSString *)labelText View:(UIView *)view;

/**计算经纬度的方法*/
+ (double)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;
/**根据字符串的指定长度动态改变Label的Frame*/

/**判断数组是否为空*/
+ (BOOL)arrayISNull:(NSArray *)arr;

/**根据指定宽度返回16:9的高度值*/
+(CGFloat)returnVideoHeght:(CGFloat)width;
@end
