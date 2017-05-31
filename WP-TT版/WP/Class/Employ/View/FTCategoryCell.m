//
//  FTCategoryCell.m
//  WP
//
//  Created by CBCCBC on 15/11/17.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "FTCategoryCell.h"
#import "SPLabel.h"

#define CellHeight kHEIGHT(43)

@interface FTCategoryCell ()

@end

@implementation FTCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
        _contentlabel = [[SPLabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, CellHeight)];
        _contentlabel.font = kFONT(14);
//        [_contentlabel setVerticalAlignment:VerticalAlignmentMiddle];
        _contentlabel.verticalAlignment = VerticalAlignmentMiddle;
        [self addSubview:_contentlabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        self.accessoryView = imageView;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
