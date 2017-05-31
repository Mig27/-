//
//  ShareOperation.m
//  WP
//
//  Created by 沈亮亮 on 15/12/31.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ShareOperation.h"
#import "AppDelegate.h"
//#import "UMSocialControllerService.h"

@implementation ShareOperation

//+(void)shareToPlatform:(NSString *)platform presentController:(UIViewController *)controller status:(void(^)(UMSResponseCode status))status
//{
//    NSString *shareText = @"我是微聘，希望大家能够喜欢！ http://www.umeng.com/social";
//    UIImage *shareImage = [UIImage imageNamed:@"图层 14"];
//    
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[platform] content:shareText image:shareImage location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity * response){
//        
//        if (status) {
//            status(response.responseCode);
//        }
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        } else if(response.responseCode != UMSResponseCodeCancel) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
//}
+(void)shareToPlatform:(UMSocialPlatformType)platform presentController:(UIViewController *)controller status:(void(^)(UMSocialShareResponse*status))status
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UIImage imageNamed:@"icon"]]]];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"快捷招聘" descr:@"我是快聘，希望大家能够喜欢!" thumImage:[UIImage imageNamed:@"icon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://www.umeng.com/social";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//             UMSocialShareResponse *resp = data;
                
            }else{
                
            }
        }
    }];
}
@end
