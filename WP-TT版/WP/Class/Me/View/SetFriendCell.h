//
//  SetFriendCell.h
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrienDListModel.h"



@class SetFriendCell;

@protocol SetFriendCellDelegate <NSObject>

-(void)didSelectSetFriendCell:(SetFriendCell *)cell;

@end


@interface SetFriendCell : UITableViewCell
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic, strong)WPFriendModel *model;

@property (nonatomic, weak) id<SetFriendCellDelegate> delegate;

@end
