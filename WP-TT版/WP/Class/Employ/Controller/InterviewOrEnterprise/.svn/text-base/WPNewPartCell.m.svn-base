//
//  WPNewPartCell.m
//  WP
//
//  Created by CBCCBC on 16/1/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewPartCell.h"
#import "UIImageView+WebCache.h"
#import "WPInterviewModel.h"
#import "WPNewResumeController.h"
#import "WPNewResumeModel.h"

#define CellHeight (SCREEN_WIDTH-2)/4

@implementation WPNewPartCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(0, 0, 0)]];
        self.backgroundColor = RGB(226, 226, 226);
        
        int width = 0;
        if (SCREEN_WIDTH == 320) {
            width = 320;
        }
        if (SCREEN_WIDTH == 375) {
            width = 376;
        }
        if (SCREEN_WIDTH == 414) {
            width = 416;
        }
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width/4-0.5, width/4-0.5)];
        _headImageView.image = [UIImage imageNamed:@"0.jpg"];
        [self addSubview:_headImageView];
        
        _titleLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, _headImageView.height-20, _headImageView.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = kShadowColor1;
        _titleLabel.shadowOffset = kShadowOffset;
        _titleLabel.shadowBlur = kShadowBlur;
        _titleLabel.text = @"求职信息";
        _titleLabel.font = kFONT(10);
        [_headImageView addSubview:_titleLabel];
        
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CellHeight-8-18, 8, 18, 18)];
        _selectedImageView.hidden = YES;
        [self addSubview:_selectedImageView];
    }
    return self;
}

-(void)setModel:(NSObject *)model
{
    WPNewResumeListModel *listModel = (WPNewResumeListModel *)model;
    if (listModel.type == WPMainPositionTypeInterView) {
        WPInterviewListModel *listModel = (WPInterviewListModel *)model;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.titleLabel.text = listModel.HopePosition;
        _selectedImageView.image = [UIImage imageNamed:listModel.isSelected?@"common_xuanzhong":@"common_xuanze"];
    }
    if (listModel.type == WPMainPositionTypeRecruit) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
        [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        
        _selectedImageView.image = [UIImage imageNamed:listModel.isSelected?@"common_xuanzhong":@"common_xuanze"];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _headImageView.alpha = .3f;
    }else {
        _headImageView.alpha = 1.f;
    }
}


@end
