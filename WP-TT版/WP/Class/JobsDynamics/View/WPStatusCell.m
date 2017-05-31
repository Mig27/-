//
//  WPStatusCell.m
//  WP
//
//  Created by 沈亮亮 on 15/6/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPStatusCell.h"
#import "WPStatus.h"
#import "WPStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "WPStatusView.h"

@interface WPStatusCell()


@end

@implementation WPStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    WPStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WPStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTopView];
        
    }
    return self;
}


- (void)setupTopView
{
    self.selectedBackgroundView = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    
    WPStatusView *topView = [[WPStatusView alloc] init];
   
    //6.11
    [self.contentView addSubview:topView];
    self.topView = topView;
}

- (void)setFrame:(CGRect)frame
{
    //frame.size.width -= 2 * WPStatusTableBorder;
    //frame.size.height -= WPStatusTableBorder;
    [super setFrame:frame];
}

#pragma mark - 数据的设置
- (void)setStatusFrame:(WPStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    [self setupTopViewData];
    
}

- (void)setupTopViewData
{
    self.topView.frame = self.statusFrame.topViewF;
    self.topView.statusFrame = self.statusFrame;
}



@end
