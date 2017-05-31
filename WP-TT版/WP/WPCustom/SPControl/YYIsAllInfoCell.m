//
//  YYIsAllInfoCell.m
//  WP
//
//  Created by CBCCBC on 16/2/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "YYIsAllInfoCell.h"

@implementation YYIsAllInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headImageView = ({
        
            UIImageView *imageView = [UIImageView new];
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(30), kHEIGHT(30)));
                make.left.offset(kHEIGHT(10));
                make.centerY.equalTo(self);
            }];
            
            imageView;
        });
        
        _titleLabel = ({
            
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            label.font = kFONT(12);
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_headImageView);
                make.left.equalTo(_headImageView.mas_right).offset(10);
                make.width.lessThanOrEqualTo(self);
                make.height.equalTo(_headImageView).dividedBy(2);
            }];
            label;
        });
        
        _detailLabel = ({
            UILabel *label = [UILabel new];
            label.font = kFONT(10);
            label.textColor = RGB(127, 127, 127);
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom);
                make.left.equalTo(_headImageView.mas_right).offset(10);
                make.width.lessThanOrEqualTo(self);
                make.height.equalTo(_headImageView).dividedBy(2);
            }];
            label;
        });
        
        self.selecImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(15)-kHEIGHT(10), (self.height-kHEIGHT(15))/2, kHEIGHT(15), kHEIGHT(15))];
        self.selecImage.image = [UIImage imageNamed:@"common_xuanzhong"];
        self.selecImage.hidden = YES;
        [self.contentView addSubview:self.selecImage];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
