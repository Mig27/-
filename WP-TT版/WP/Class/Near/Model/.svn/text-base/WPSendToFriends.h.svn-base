//
//  WPSendToFriends.h
//  WP
//
//  Created by CC on 16/11/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPNewResumeModel.h"
#import "NearPersonalController.h"
#import "LinkManModel.h"
@interface WPSendToFriends : NSObject
@property (nonatomic, strong)WPNewResumeListModel*model;
@property (nonatomic, strong)NearPersonalListModel*personalModel;
@property (nonatomic, strong)LinkManListModel*personalInfoModel;

@property (nonatomic, assign)BOOL isRecuilist;//1招聘0求职
@property (nonatomic, strong)NSDictionary* muchDic;//求职招聘界面多个发送
@property (assign, nonatomic) WPMainPositionType type;
@property (nonatomic, strong) NSArray * selectedArray;

@property (nonatomic, strong) NSMutableArray * muchArray;
-(NSString*)shareToOtherPeople:(BOOL)singleOrNot;
-(NSString*)shareShuoShuo:(NSArray*)array;//分享说说
-(void)sendToFriendsMuch:(void(^)(NSArray*,NSArray*,NSString*))sendSuccess;//获取的发送人,发送的内容，发送对象的id
-(void)sendeToWeiPinFriends:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess;
//从面试中发送多个
-(void)sendeMuchFromMianshiToWeiPinFriends:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess;

//从职场说说界面发送说说给好友
-(void)sendShuoShuoToFriends:(NSDictionary*)sendDic success:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess;
//从面试招聘的查看中分享
-(NSString*)shareDetailFromZhaopinOrQiuZhiandImage:(NSString*)iageStr;
//从说说详情中发送给好友
-(void)sendShuoShuoToWeiPinFriendsFromDetail:(NSDictionary*)dictionary success:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess;
-(void)sendPersonalCard:(LinkManListModel*)model success:(void(^)(NSArray*,NSString*,NSString*,NSString*))sendSuccess;
@end
