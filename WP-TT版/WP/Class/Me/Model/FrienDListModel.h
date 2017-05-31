//
//  FrienDListModel.h
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"

@class WPFriendModel;
@interface FrienDListModel : BaseModel
@property (nonatomic, strong) NSArray<WPFriendModel *> *list;
@end
@interface WPFriendModel : NSObject
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, copy) NSString *canSelect; // 是否可选
@property (nonatomic, copy) NSString *user_id;//": "用户ID",
@property (nonatomic, copy) NSString *friend_id;//": "好友ID",
@property (nonatomic, copy) NSString *user_name;//": "用户名",
@property (nonatomic, copy) NSString *nick_name;//": "用户昵称",
@property (nonatomic, copy) NSString *avatar;//": "头像",
@property (nonatomic, copy) NSString *post_remark;//": "请求备注",
@property (nonatomic, copy) NSString *fuser_time;//": "请求时间",
@property (nonatomic, copy) NSString *add_time;///**< 草稿ID */
@property (nonatomic, copy) NSString *is_friend;  // 1好友 0陌生人

@property (nonatomic, copy) NSString *add_fuser_state;
@property (nonatomic, copy) NSString *form_state;
@property (nonatomic, copy) NSString *ftypeid;
@property (nonatomic, copy) NSString *is_fcircle;
@property (nonatomic, copy) NSString *wp_id;



//"add_fuser_state" = 0;
//avatar = "/upload/201605/27/201605271528308376.jpg";
//"form_state" = 2;
//"friend_id" = 359;
//ftypeid = 66;
//"ftypeid" = False;
//"is_fcircle" = False;
//"is_fjob" = False;
//"is_fresume" = False;
//"is_job" = False;
//"is_read" = 0;
//"is_resume" = False;
//"is_shield" = True;
//"nick_name" = "\U8748\U8748";
//"post_remark" = "\U8748\U8748\U98de";
//"user_id" = 215;
//"wp_id" = 13555555555;

@property (strong,nonatomic) ChineseString *chineseString;

@end
