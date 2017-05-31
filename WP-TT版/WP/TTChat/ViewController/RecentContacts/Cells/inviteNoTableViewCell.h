//
//  inviteNoTableViewCell.h
//  WP
//
//  Created by CC on 16/9/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inviteNoTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *joinLabel;
@property (nonatomic, strong)UIImageView * iconImage;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *unReadMessage;
@property (nonatomic, strong)NSString*unReadNum;
@property (nonatomic, strong)NSDictionary*groupDictionary;
-(void)setGroupDictionary:(NSDictionary *)groupDictionary isOr:(BOOL)isOrNot;
@end
