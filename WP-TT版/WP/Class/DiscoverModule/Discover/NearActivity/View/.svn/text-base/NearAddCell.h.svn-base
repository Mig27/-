//
//  NearAddCell.h
//  WP
//
//  Created by 沈亮亮 on 15/10/14.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSegmentControl.h"
#import "WPLightSport.h"
typedef NS_ENUM(NSInteger,NearAddCellType) {
    NearAddCellTypeOne,
    NearAddCellTypeTwo,
};

@interface NearAddCell : UITableViewCell

@property (nonatomic, assign) NearAddCellType type;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIImageView * rightImage;
@property (nonatomic,strong) RSSegmentControl *segment;
@property (nonatomic,strong) UITextField * TextField;


@property (nonatomic, strong) UILabel * contentLabel;
//@property (nonatomic, strong) UILabel * placeHolderLabel;





@property (copy,nonatomic) void(^selectType)(NSInteger type);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
