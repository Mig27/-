//
//  WPWiFiSetCell.h
//  WP
//
//  Created by CC on 16/9/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WPWiFiSetCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, copy)NSString * nameStr;
@property (nonatomic, copy)NSString * wifiStr;

@end
