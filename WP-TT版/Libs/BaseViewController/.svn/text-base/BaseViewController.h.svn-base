//
//  BaseViewController.h
//  BoYue
//
//  Created by Spyer on 14/12/2.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

#import "MacroDefinition.h"

#import "UIButton+Extension.h"
#import "UILabel+Extension.h"
#import "TouchScrollView.h"
#import "TouchTableView.h"


typedef void (^DealsSuccessBlock)(NSArray *datas,int more);
typedef void (^DealsErrorBlock)(NSError *error);

typedef void (^MButtonBlock)(NSInteger tag);

typedef NS_ENUM(NSInteger, MNavigationItemType) {
    MNavigationItemTypeTitle,
    MNavigationItemTypeRight = 3,
};

typedef NS_ENUM(NSInteger, PushType) {
    Present = 101,
    Push = 102,
};

@interface BaseViewController : UIViewController  <UITextFieldDelegate,UITextViewDelegate>

{
    MButtonBlock mbuttonBlock;
}

-(void)layoutSubViews;

-(void)createBackButtonWithPushType:(PushType)pushType;

-(void)createNavigationItemWithMNavigatioItem:(MNavigationItemType)itemType title:(NSString *)title;

//-(void)swipe:(UISwipeGestureRecognizer *)sender;

//block
//-(void)setButtonAction:(MButtonBlock)ablock;

-(void)rightButtonAction:(UIButton *)sender;

-(void)backToFromViewController:(UIButton *)sender;

@end
