//
//  WPSelectButton.h
//  WP
//
//  Created by 沈亮亮 on 15/10/12.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSelectButton : UIView

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *readDot; //小红点
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isHideOrNot;

- (void)setLabelText:(NSString *)text;

@end
