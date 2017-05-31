//
//  YYShareManager.h
//  WP
//
//  Created by CBCCBC on 16/1/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialSinaHandler.h"


typedef NS_ENUM(NSInteger,YYShareManagerType) {
    YYShareManagerTypeWeiPinFriends = 20,
    YYShareManagerTypeWorkLines,
    YYShareManagerTypeWeChatFriends,
    YYShareManagerTypeWeChatSessions,
    YYShareManagerTypeQQFriends,
    YYShareManagerTypeQzones,
    YYShareManagerTypeSina,
    YYShareManagerTypeCollect,
    YYShareManagerTypeReport,
};

typedef NS_ENUM(NSInteger,YYShareType){
    YYShareShuoShuo = 60,//说说
    YYShareOneApply,//单个招聘
    YYShareOneEmploy,//单个求职
    YYShareMuchApply,//多个招聘
    YYShareMuchEmploy,//多个求职
};


@interface YYShareManager : UIView//<UMSocialUIDelegate>
@property (nonatomic, copy)NSString * shareContent;
@property (nonatomic, copy)NSString * imageStr;


//+(void)shareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSResponseCode status))status;
//
//+(void)newShareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSResponseCode status))status;
+(void)shareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSocialShareResponse*response))Response;

+(void)newShareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSocialShareResponse*response))Response;

@end

@interface YYShareOperation : NSObject

//+(void)shareToPlatform:(NSString *)platform title:(NSString *)title url:(NSString *)url content:(NSString*)contentStr imageStr:(NSString*)imageString presentController:(UIViewController *)controller status:(void(^)(UMSResponseCode status))status;
//+(void)shareToSina:(NSString *)platform title:(NSString *)title url:(NSString *)url content:(NSString*)contentStr imageStr:(NSString*)imageString delete:(id)delete presentController:(UIViewController *)controller status:(void(^)(UMSResponseCode status))status;


+(void)shareToPlatform:(UMSocialPlatformType)platform title:(NSString *)title url:(NSString *)url content:(NSString*)contentStr imageStr:(NSString*)imageString presentController:(UIViewController *)controller status:(void(^)(UMSocialShareResponse*response))Response;

+(void)shareToSina:(NSString *)platform title:(NSString *)title url:(NSString *)url content:(NSString*)contentStr imageStr:(NSString*)imageString delete:(id)delete presentController:(UIViewController *)controller status:(void(^)(UMSocialShareResponse*response))Response;
@end
