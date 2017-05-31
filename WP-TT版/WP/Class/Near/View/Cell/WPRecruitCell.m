//
//  WPRecruitCell.m
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRecruitCell.h"
#import "UIImageView+WebCache.h"

#define CellHeight SCREEN_WIDTH/4

#define ImageHeight 43

@implementation WPRecruitCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(0, 0, 0)]];
        self.backgroundColor = RGB(226, 226, 226);
//        self.layer.borderColor = RGB(226, 226, 226).CGColor;
//        self.layer.borderWidth = 0.25;
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
        _headImageView.image = [UIImage imageNamed:@"defaultHead"];
        [self addSubview:_headImageView];
        
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CellHeight-8-18, 8, 18, 18)];
        _selectedImageView.hidden = YES;
        [self addSubview:_selectedImageView];
        
    }
    return self;
}

+(instancetype)cellWithCellectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"WPRecruitCell";
    WPRecruitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

-(void)setModel:(WPRecruitListModel *)model
{
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
    [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    _selectedImageView.image = [UIImage imageNamed:model.isSelected?@"userinfo_selected":@"userinfo_unselected"];
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
