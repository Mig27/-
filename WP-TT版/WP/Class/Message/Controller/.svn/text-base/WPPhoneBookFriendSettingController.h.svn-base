//
//  WPPhoneBookFriendSettingController.h
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkManModel.h"
@interface WPPhoneBookFriendSettingController : UIViewController

@property (nonatomic, copy) NSString *friendID;
@property (nonatomic, assign) NewRelationshipType newType;
@property (nonatomic, copy) NSString *comeFromVc;  //通讯录  新的好友
@property (nonatomic, strong)LinkManListModel*personalModel;
@property (nonatomic, strong) NSIndexPath *ccindex;
@property (nonatomic, copy) void (^refreshData)(NSIndexPath*indexpath);
-(void)sendeMessageAboutRemove:(NSString*)sendUser and:(NSString*)type;
@end
