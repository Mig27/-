//
//  WPViewShuoShuoVideo.h
//  WP
//
//  Created by CC on 16/11/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPViewShuoShuoVideo : BaseViewController
@property (nonatomic, copy)NSString*videoStr;
@property (nonatomic, copy)NSString*user_id;
@property (nonatomic, copy)NSString*img_url;
@property (nonatomic, copy)NSString*vd_url;
- (void)show;
- (void)showPickerVc:(UIViewController *)vc;
@end
