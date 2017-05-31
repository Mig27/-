//
//  CreatCustom.m
//  BoYue
//
//  Created by Leejay on 14/12/8.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "CreatCustom.h"
#import "NSString+StringType.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "MacroDefinition.h"

@implementation CreatCustom

+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:aDeleagte cancelButtonTitle:cancelName otherButtonTitles:otherbuttonName, nil];
    [alert show];
    return alert;
}

+(BOOL)isNULL:(NSString *)str {
    if (str == nil || str == NULL || [str isEqualToString:@""] || [str isEqualToString:@"NULL"] || [str isEqualToString:@"null"]  || [str isEqualToString:@"(null)"]) {
        return true;
    }
    return false;
}

+(UIView *)creatUIViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}



+(CGRect)creatFrameWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height
{
    return  CGRectMake(orignalX, orignalY, SCREEN_WIDTH-2*orignalX, height);
}

+(void)createHUD:(NSString *)labelText View:(UIView *)view
{
//    CGSize size = [labelText getSizeWithFont:[UIFont systemFontOfSize:17] Width:SCREEN_WIDTH];    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.color = RGB(101, 101, 101);
    HUD.removeFromSuperViewOnHide = YES;
    HUD.labelText = labelText;
    [HUD hide:YES afterDelay:2];
}

//计算经纬度的方法
+ (double)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    
    double er = 6378137;
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);
    
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;//米
    
    return dist;
}



+ (BOOL)arrayISNull:(NSArray *)arr
{
    if (arr != nil && ![arr isKindOfClass:[NSNull class]] && arr.count != 0){
        return false;//不是空
    }else{
        return true;//是空
    }
}

+(CGFloat)returnVideoHeght:(CGFloat)width
{
    int height = 0;
    height = width*9/16;
    return height;
}

@end
