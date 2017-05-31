//
//  WPShareModel.h
//  WP
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndustryModel.h"

@interface WPShareModel : NSObject

@property (nonatomic,copy) NSString* photoStr;
@property (nonatomic,copy) NSString* usernameStr;
@property (nonatomic,copy) NSString* sexStr;
@property (nonatomic,copy) NSString* birthdayStr;
@property (nonatomic,copy) NSString* phoneNumberStr;
@property (nonatomic,copy) NSString* passWordStr;
@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic,strong) IndustryModel* industryModel;
@property (nonatomic,strong) IndustryModel* positionModel;
@property (nonatomic,strong) IndustryModel* addressModel;


@property (nonatomic,copy) NSMutableArray* addressArr;
@property (nonatomic,copy) NSMutableArray* positionArr;
@property (nonatomic,copy) NSMutableArray* industryArr;

@property (nonatomic,copy) NSString* industryNameStr;
@property (nonatomic,copy) NSString* positionNameStr;
@property (nonatomic,copy) NSString* cityNameStr;

@property (nonatomic,copy) NSString* industryAction;
@property (nonatomic,copy) NSString* positionAction;
@property (nonatomic,copy) NSString* addressAction;

@property (nonatomic,assign) NSInteger btn1;
@property (nonatomic,assign) NSInteger btn2;
@property (nonatomic,assign) NSInteger btn3;

//查看全部热门职位
@property (nonatomic,strong) NSMutableArray* positionArray;

//行业分类
@property (nonatomic,strong) NSMutableArray* industryArray;
//登陆存储
@property (nonatomic,strong) NSMutableDictionary* dic;
@property (nonatomic,strong) NSString *username; //用户名
@property (nonatomic,strong) NSString *password; //密码
@property (nonatomic,strong) NSString *userId; //用户ID
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) NSArray *items;


//添加手机好友
@property (nonatomic,strong) NSMutableArray* mobileArr;
@property (nonatomic,assign,getter=isShow)BOOL show;  //yes 不显示了


@property (nonatomic,assign)BOOL speakMode;//听筒和扬声器模式

//@property (nonatomic,strong) NSString* nameString;


/** 是否是 预览界面*/
//@property (nonatomic,assign) BOOL isResumePreveiw;

+ (WPShareModel*)sharedModel;

@end
