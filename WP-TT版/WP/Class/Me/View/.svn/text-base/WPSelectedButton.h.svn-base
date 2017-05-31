//
//  WPSelectedButton.h
//  WP
//
//  Created by CBCCBC on 16/3/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSelectedButton : UIView

@property (nonatomic ,strong)UIButton *selected;
@property (nonatomic ,strong)UIButton *delete;
@property (nonatomic ,strong)UILabel * numLabel;

@property (nonatomic,assign)SEL deleteAction;
@property (nonatomic,assign)id deleteTarget;

@property (nonatomic,assign)SEL selectedAction;
@property (nonatomic,assign)id selectedTarget;


- (void)setDeleteTarget:(id)deleteTarget deleteAction:(SEL)deleteAction;

- (void)setSelectedTarget:(id)selectedTarget selectedAction:(SEL)selectedAction;

@end
