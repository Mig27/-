//
//  WPMeApplyCell.h
//  WP
//
//  Created by CBCCBC on 16/1/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignListModel.h"
#import "SPLabel.h"
@class  WPMeGrablistModel;
@interface WPMeApplyCell : UITableViewCell
@property (nonatomic ,strong) SignModel *model;
@property (nonatomic, strong) WPMeGrablistModel *listModel;
@property (nonatomic, assign)BOOL isEdit;//是否编辑
@property (nonatomic, copy)void (^choiseCell)(NSIndexPath*indesPath);
@property (nonatomic, strong)NSIndexPath * indexPath;

@property (nonatomic, strong) SPLabel * titleLabel;
@property (nonatomic, strong) SPLabel * contentLabel;
@property (nonatomic, strong) SPLabel * timeLabel;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIButton * choiseBtn;

-(void)setModel:(SignModel *)model andEdit:(BOOL)edit;
-(void)setListModel:(WPMeGrablistModel *)listModel andEdit:(BOOL)edit;
@end
