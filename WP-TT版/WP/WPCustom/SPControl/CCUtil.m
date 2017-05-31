//
//  CCUtil.m
//  YipaiShop
//
//  Created by iOS on 15/12/1.
//  Copyright © 2015年 Yipai. All rights reserved.
//

#import "CCUtil.h"

@implementation CCUtil

+(AFHTTPRequestOperationManager *)shareAFNMgrInstance{
    static dispatch_once_t pred;
    static AFHTTPRequestOperationManager *mgr;
    dispatch_once(&pred, ^{
        mgr = [AFHTTPRequestOperationManager manager];
        //设置网络请求超时时间
        mgr.requestSerializer.timeoutInterval = 15;
        //申明返回的结果是json类型
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];


//        [mgr.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    });
    return mgr;
}

+(NSString *)transformFenToYuan:(NSString *)str{
    float value = [str floatValue];
    float yjf = value/100;
    NSString *str1 = [NSString stringWithFormat:@"%.2f",yjf];
    return str1;
}

+(NSString *)transToFormatterTimeWithHaomiao:(NSString *)haomiao{
    long long time =[haomiao doubleValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:d];
}

+(NSString *)transToDeatailFormatterTimeWithHaomiao:(NSString *)haomiao{
    long long time =[haomiao doubleValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    return [dateFormatter stringFromDate:d];
}

@end
