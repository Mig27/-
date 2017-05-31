//
//  SPSelectMoreCell.m
//  WP
//
//  Created by CBCCBC on 15/10/18.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPSelectMoreCell.h"

@interface SPSelectMoreCell ()

@end

@implementation SPSelectMoreCell


- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(235, 235, 235)]];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, SCREEN_WIDTH-50, self.height)];
        self.titleLabel.font = kFONT(15);
        self.titleLabel.numberOfLines = 0;
        //        if (self.titleLabel.width > SCREEN_WIDTH/2) {
        //            self.titleLabel.font = [UIFont systemFontOfSize:15];
        //        }else{
        //            self.titleLabel.font = [UIFont systemFontOfSize:15];
        //        }
        //
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        [_button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        if (self.itemSelected) {
            [self selectClick:_button];
        }
        
        self.accessoryView = self.subImageView;
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(226, 226, 226);
//        [self addSubview:line];
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)selectClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.subImageView.image = [UIImage imageNamed:@"common_xuanzhong"];
        if (self.GetIndexPathBlock) {
            self.GetIndexPathBlock(self.tag);
        }
    }else{
        self.subImageView.image = [UIImage imageNamed:@"common_xuanze"];//xuanze_1
        if (self.SubIndexPathBlock) {
            self.SubIndexPathBlock(self.tag);
        }
    }
}

- (UIImageView *)subImageView
{
    if (!_subImageView) {
        _subImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_xuanze"]];//xuanze_1
    }
    return _subImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
