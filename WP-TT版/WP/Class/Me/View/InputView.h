//
//  InputView.h
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView
@property (nonatomic ,strong)UITextField *textField;
- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeholder;
@end
