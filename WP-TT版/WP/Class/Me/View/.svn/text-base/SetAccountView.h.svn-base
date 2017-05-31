//
//  SetAccountView.h
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetAccountViewDelgate <NSObject>
- (void)timeToFinishEditingWithSelected:(BOOL)selected;
@end

@interface SetAccountView : UIView

@property (nonatomic, strong)UITextField *textField;
@property (nonatomic ,weak)id<SetAccountViewDelgate>delegate;
@end
