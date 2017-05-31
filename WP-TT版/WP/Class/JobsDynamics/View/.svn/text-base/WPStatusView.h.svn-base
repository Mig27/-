//
//  WPStatusView.h
//  WP
//
//  Created by 沈亮亮 on 15/6/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WPStatusFrame;
@class WPPhotosView;
@class commentView;

@protocol WPStatusViewDelegate <NSObject>

@optional
-(void)deleteDataCell:(int)tag;

@end

@interface WPStatusView : UIImageView
@property (nonatomic,strong) WPStatusFrame *statusFrame;
@property (nonatomic, weak) id<WPStatusViewDelegate> delegate;

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UIButton* buttonView;

@property (nonatomic, weak) UILabel* positionLabel;
@property (nonatomic, weak) UIImageView* lineImage;
@property (nonatomic, weak) UILabel* companyLable;
@property (nonatomic, weak) UIImageView* lineTwoImage;

@property (nonatomic, weak) UILabel* contentLabel;
@property (nonatomic, weak) WPPhotosView* photosView;
@property (nonatomic, weak) UIImageView* addressImage;
@property (nonatomic, weak) UILabel* addressName;
@property (nonatomic, weak) UIImageView* lineThreeImage;

@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UIImageView* lineFourImage;
@property (nonatomic, weak) UIButton* rubbishbutton;
@property (nonatomic, weak) UIButton* commentButton;
@property (nonatomic, weak) UIButton* goodButton;
@property (nonatomic, weak) UIButton* sendButton;

@property (nonatomic, strong) commentView* theCommentView;
@end
