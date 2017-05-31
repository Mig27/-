//
//  WPFriendCell.m
//  WP
//
//  Created by CBCCBC on 15/9/16.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPFriendCell.h"

#import "MacroDefinition.h"

@implementation WPFriendCell

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
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, 0, 200, self.height)];
    _titleLabel.font = GetFont(15);
    [self.contentView addSubview:_titleLabel];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    self.accessoryView = rightImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
