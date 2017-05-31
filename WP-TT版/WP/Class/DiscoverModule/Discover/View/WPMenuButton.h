//
//  WPMenuButton.h
//  WP
//
//  Created by Kokia on 16/5/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMenuButton : UIButton

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIImageView *image;

- (void)setLabelText:(NSString *)text;
@end
