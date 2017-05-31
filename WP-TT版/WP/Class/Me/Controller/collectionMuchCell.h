//
//  collectionMuchCell.h
//  WP
//
//  Created by CC on 16/9/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionMuchLabel.h"
#import "WPDDChatVideo.h"
@interface collectionMuchCell : UITableViewCell
@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * positionLabel;
@property (nonatomic, strong)UILabel * companyLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UIImageView * backVideoImageView;

@property (nonatomic, strong)collectionMuchLabel * collectionLabel;
@property (nonatomic, strong)UILabel * copycopyLabel;
@property (nonatomic, strong)NSDictionary * detailDic;

@property (nonatomic, strong)UIView * personalCardView;
@property (nonatomic, strong)UIImageView * backImageView;
@property (nonatomic, strong)NSIndexPath * indexpath;
@property (nonatomic, strong)WPDDChatVideo * video;
@property (nonatomic, strong)UIButton * videoBtn;
@property (nonatomic, copy)void (^clickBackView)(NSIndexPath*indexpath);
@property (nonatomic, copy)void (^clickImage)(NSIndexPath*indexpath,UIImageView*imageview);
@property (nonatomic, copy)void (^clickVideoBtn)(NSIndexPath*indepath);
@property (nonatomic, copy) NSString * fileStr;
@end
