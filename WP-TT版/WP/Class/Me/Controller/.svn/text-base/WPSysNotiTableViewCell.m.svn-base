//
//  WPSysNotiTableViewCell.m
//  WP
//
//  Created by CC on 17/2/4.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPSysNotiTableViewCell.h"

@implementation WPSysNotiTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 50)];
        self.backLabel.layer.cornerRadius = 5;
        self.backLabel.layer.borderColor = RGB(217, 217, 217).CGColor;
        self.backLabel.layer.borderWidth = 0.5;
        self.backLabel.clipsToBounds = YES;
        self.backLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backLabel];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
        self.titleLabel.font = kFONT(15);
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,30, 100, 10)];
        self.contentLabel.font = kFONT(12);
        //self.contentLabel.textColor = RGB(127, 127, 127);
        self.contentLabel.textColor = [UIColor blackColor];
        
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        
        
        
        
        self.backgroundColor = RGB(247, 247, 247);
    }
    return self;
}
-(void)setDictionary:(NSDictionary *)dictionary
{
    NSString * title = dictionary[@"title"];
    NSString * content = dictionary[@"remark"];
    CGSize titleSize =[title getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-4*12];
    CGSize contentSize = [content getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH-4*12];
    
    CGRect backRect = self.backLabel.frame;
    backRect.size.height = kHEIGHT(10)+titleSize.height+kHEIGHT(10)+contentSize.height+kHEIGHT(10);
    backRect.size.width = (titleSize.width>contentSize.width)?titleSize.width+2*12:contentSize.width+2*12;
    backRect.origin.x = (SCREEN_WIDTH-backRect.size.width)/2;
    self.backLabel.frame = backRect;
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect = CGRectMake((SCREEN_WIDTH-titleSize.width)/2,12,titleSize.width, titleSize.height);
    self.titleLabel.frame = titleRect;

    CGRect contentRect = self.contentLabel.frame;
    contentRect = CGRectMake((SCREEN_WIDTH-contentSize.width)/2, 12+10+titleSize.height, contentSize.width, contentSize.height);
    self.contentLabel.frame = contentRect;

    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
