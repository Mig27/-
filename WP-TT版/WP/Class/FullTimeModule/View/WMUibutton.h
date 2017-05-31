//
//  WMUibutton.h
//  WP
//
//  Created by CC on 17/2/25.
//  Copyright © 2017年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMUibutton : UIView

@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UIButton * switchButton;


- (instancetype) initWithFrame:(CGRect)frame withTitle:(NSString *)title buttonImageName:(NSString *)buttonImage;



//@interface HJCActionSheet : UIView
//
///**
// *  代理
// */
//@property (nonatomic, weak) id <HJCActionSheetDelegate> delegate;
//
///**
// *  创建对象方法
// */
//- (instancetype)initWithDelegate:(id<HJCActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;
//
//- (void)show;
@end
