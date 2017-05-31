//
//  WPDontSeeHisRecruitParam.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPDontSeeHisRecruitParam : NSObject

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *friend_id;
@property (nonatomic, copy) NSString *type;  //0可以看 1不可以看
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
