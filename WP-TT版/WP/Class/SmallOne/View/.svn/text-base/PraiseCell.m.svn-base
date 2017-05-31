//
//  PraiseCell.m
//  WP
//
//  Created by 沈亮亮 on 15/8/12.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "PraiseCell.h"
#import "UIButton+WebCache.h"

@implementation PraiseCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buttons = [NSMutableArray array];
    }
    return self;
}

- (void)confignCellWith:(NSArray *)array
{
    CGFloat width = (SCREEN_WIDTH - 70)/6;
    CGFloat y1 = 10;
    CGFloat y2 = 10 + width + 6;
    CGFloat gap1 = width + 6 + 15 + 10;
    CGFloat gap2 = 15 + 10 + width + 6;
    CGFloat x = 10;
    CGFloat x1  = width + 10;
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dic = array[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
        [button sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
        button.frame = CGRectMake(x + (i%6)*x1, y1 + (i/6)*gap1, width, width);
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.tag = i + 1;
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(x + (i%6)*x1, y2 + (i/6)*gap2, width, 15)];
        name.text = dic[@"nick_name"];
        name.font = kFONT(10);
        name.numberOfLines = 1;
        name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:name];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
