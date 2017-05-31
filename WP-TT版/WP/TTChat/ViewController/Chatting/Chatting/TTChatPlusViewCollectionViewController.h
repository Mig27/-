//
//  TTChatPlusViewCollectionViewController.h
//  WP
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTBaseViewController.h"


@interface TTChatPlusViewCollectionViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic) NSInteger userId;

-(void)setShakeHidden;
@end



