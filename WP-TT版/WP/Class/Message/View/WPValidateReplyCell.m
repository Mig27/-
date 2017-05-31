//
//  WPValidateReplyCell.m
//  WP
//
//  Created by Kokia on 16/5/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPValidateReplyCell.h"

@interface WPValidateReplyCell()

@property (nonatomic,strong) UILabel *msgLabel;
@property (nonatomic,strong) UILabel *nameLabel;

@end


@implementation WPValidateReplyCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPValidateReplyCell *cell; //这个cell没必要重用
    if (cell == nil) {
        cell = [[WPValidateReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    // Msg label
    UILabel *msgLabel = [[UILabel alloc] init];
    self.msgLabel = msgLabel;
    msgLabel.numberOfLines = 0;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.lineBreakMode = NSLineBreakByWordWrapping; // 感觉word换行 有的地方不够显示一个汉字 换行
    msgLabel.textColor = RGB(127, 127, 127);
    msgLabel.font = kFONT(12);
    [self.contentView addSubview:msgLabel];
    
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(17);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-17);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    
    
    
    
}


-(void)setMsgModel:(WPReplyListModel *)msgModel{
    _msgModel = msgModel;
    if ([msgModel.username isEqualToString:@"我"]) {
        NSString *name = @"我:";
        self.msgLabel.text = [NSString stringWithFormat:@"%@%@",name,msgModel.v_content];
    }else{
        NSString *name = [NSString stringWithFormat:@"%@:",msgModel.username];
        self.msgLabel.text = [NSString stringWithFormat:@"%@%@",name,msgModel.v_content];
    }
    
}


@end
