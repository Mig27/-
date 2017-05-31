//
//  CustomAlertView.h
//  TruckFriends
//
//  Created by summer on 14/11/4.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegete <NSObject>

-(void)customAlertViewDidSelectedItemCount:(NSInteger)count Item:(NSString *)item;

@end
@interface CustomAlertView : UIView
-(id)initWithTopTitle:(NSString *)topTitle ItemArr:(NSArray *)itemArr SuperView:(UIView *)superView SelectedCount:(NSInteger)selectedCount;

@property(nonatomic,assign)id<CustomAlertViewDelegete>delegate;
-(void)show;
-(void)hide;
@end
