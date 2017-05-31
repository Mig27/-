//
//  WPDetailCell.m
//  WP
//
//  Created by Asuna on 15/5/28.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPDetailCell.h"

@interface WPDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation WPDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)setDetailModel:(WPDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self.iconView.layer setMasksToBounds:YES];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.image = [UIImage imageNamed:detailModel.icon];
    
    self.nameLable.text = detailModel.name;
    self.detailLable.text = detailModel.detail;
    self.timeLable.text = detailModel.time;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString* ID = @"DetailCell";
    WPDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WPDetailCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

+ (CGFloat)rowHeight
{
    return 65;
}
@end
