//
//  GetValidationView.h
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetValidationView : UIView
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic ,strong)id taget;
@property (nonatomic ,assign)SEL action;
- (void)setTaget:(id)taget action:(SEL)action;
@end
