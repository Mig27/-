//
//  BackgroundButton.h
//  test
//
//  Created by CBCCBC on 15/9/16.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPActionSheetDelegate <NSObject>

-(void)SPActionSheetDelegate;

@end

@interface SPActionSheet : UIView

@property (assign, nonatomic) id <SPActionSheetDelegate> delegate;

-(instancetype)initWithTitle:(NSString *)title delegate:(id<SPActionSheetDelegate>)delegate;
-(void)show;

@end
