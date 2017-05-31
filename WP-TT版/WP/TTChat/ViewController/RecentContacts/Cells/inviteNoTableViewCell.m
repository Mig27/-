//
//  inviteNoTableViewCell.m
//  WP
//
//  Created by CC on 16/9/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "inviteNoTableViewCell.h"
#import "DDGroupModule.h"
#import "NSDate+DDAddition.h"
@implementation inviteNoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [UIImageView new];
        _iconImage.image = [UIImage imageNamed:@"xiaoxi_qunxiaoxi"];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [UILabel new];
        _nameLabel.text = @"群通知";
        _nameLabel.textColor = RGB(90, 110, 150);
        [_nameLabel setFont:systemFont(17)];
        [self.contentView addSubview:_nameLabel];
        
        _joinLabel = [UILabel new];
        [_joinLabel setFont:systemFont(14)];
        _joinLabel.text = @"呵呵申请加入交流群";
//        [_joinLabel setTextColor:TTGRAY];
        [_joinLabel setTextColor:RGB(127, 127, 127)];
        [self.contentView addSubview:_joinLabel];
        
        _dateLabel = [UILabel new];
        _dateLabel.text = @"前天";
        [_dateLabel setFont:systemFont(12)];
        [_dateLabel setTextColor:RGB(170, 170, 170)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        
        
        _unReadMessage = [UILabel new];
        _unReadMessage.text = @"99";
        [_unReadMessage setBackgroundColor:RGB(242, 49, 54)];
        [_unReadMessage setClipsToBounds:YES];
        [_unReadMessage.layer setCornerRadius:9];
        [_unReadMessage setTextColor:[UIColor whiteColor]];
        [_unReadMessage setFont:systemFont(12)];
        [_unReadMessage setTextAlignment:NSTextAlignmentCenter];
        _unReadMessage.hidden = YES;
        [self.contentView addSubview:_unReadMessage];
        
        
        
        UILabel * line = [UILabel new];
        line.backgroundColor = RGB(235, 235, 235);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(kHEIGHT(12));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImage.mas_right).offset(kHEIGHT(12));
            make.right.mas_equalTo(self.contentView).offset(-70);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(17);
        }];
        [_joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImage.mas_right).offset(kHEIGHT(12));
            make.right.mas_equalTo(self.contentView).offset(-kHEIGHT(10));//-70
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-kHEIGHT(10));
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(60);
        }];
        
        
        [_unReadMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.top.mas_equalTo(2);
            make.right.equalTo(_iconImage.mas_right).offset(9);
        }];
    }
    return self;
}
-(void)setGroupDictionary:(NSDictionary *)groupDictionary isOr:(BOOL)isOrNot
{
    isOrNot?_nameLabel.text = @"群通知":(_nameLabel.text = @"快捷招聘");
    isOrNot?(_iconImage.image = [UIImage imageNamed:@"xiaoxi_qunxiaoxi"]):(_iconImage.image = [UIImage imageNamed:@"xiaoxi_kuaipintuandui"]);
    _dateLabel.text = isOrNot?groupDictionary[@"add_time"]:groupDictionary[@"sys_add_time"];
    _joinLabel.text = isOrNot?groupDictionary[@"content"]:groupDictionary[@"sys_remark"];
    NSString * string =isOrNot?groupDictionary[@"content"]:groupDictionary[@"sys_remark"];
    if (!string.length) {
        _joinLabel.text = @"暂无新消息";
    }
    _unReadMessage.text =isOrNot?groupDictionary[@"count"]:groupDictionary[@"sys_count"];
    NSString * timeStr =isOrNot?groupDictionary[@"add_time"]:groupDictionary[@"sys_add_time"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * timeDate = [formatter dateFromString:timeStr];
    NSString* dateString = [timeDate transformToFuzzyDate];
    _dateLabel.text = dateString;
}
-(void)setUnReadNum:(NSString *)unReadNum
{
    if (unReadNum.intValue >99) {
      _unReadMessage.text = @"99+";
    }
    else
    {
      _unReadMessage.text = unReadNum;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_unReadMessage setBackgroundColor:RGB(242, 49, 54)];
    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:NO];
   [_unReadMessage setBackgroundColor:RGB(242, 49, 54)];
}

@end
