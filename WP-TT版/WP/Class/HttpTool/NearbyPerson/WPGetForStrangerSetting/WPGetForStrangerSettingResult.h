//
//  WPGetForStrangerSettingResult.h
//  WP
//
//  Created by CC on 16/6/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGetForStrangerSettingResult : NSObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *is_circle;
@property (nonatomic, copy) NSString *status; //0表示成功1表示失败
@property (nonatomic, copy) NSString *is_resume;
@property (nonatomic, copy) NSString *is_job; //True



@end
