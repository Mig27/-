//
//  WPStrangerCell.m
//  WP
//
//  Created by CBCCBC on 15/9/16.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPStrangerCell.h"

#import "MacroDefinition.h"

@implementation WPStrangerCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.height/2-10, self.height/2-10, 20, 20)];
    [self.contentView addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, 0, 70, self.height)];
    _titleLabel.textColor = RGB(154, 154, 154);
    _titleLabel.font = GetFont(15);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, 0, self.width-_titleLabel.right, self.height)];
    _contentLabel.font = GetFont(15);
    [self.contentView addSubview:_contentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
