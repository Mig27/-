//
//  commentView.h
//  WP
//
//  Created by 沈亮亮 on 15/6/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol commentViewDelegate <NSObject>

@optional
-(void)comment:(int)tag;
-(void)good:(int)tag;

@end

@interface commentView : UIView

@property (nonatomic,weak) id<commentViewDelegate> delegate;
@property (nonatomic,strong) UIButton *buttonComment;
@property (nonatomic,strong) UIButton *buttonGood;
@end
