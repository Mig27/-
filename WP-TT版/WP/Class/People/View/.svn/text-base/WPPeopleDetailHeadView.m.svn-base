//
//  WPPeopleDetailHeadView.m
//  WP
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleDetailHeadView.h"

@implementation WPPeopleDetailHeadView

{
    UIImageView *_backImage;
    UIImageView *_personImage;
    UILabel *_nameLabel;
    UILabel *_numLabel;
    UILabel *_photoLabel;
    UIImageView *_photoImage1;
    UIImageView *_photoImage2;
    UIImageView *_photoImage3;
    UIImageView *_photoImage4;
    UIButton *_midButton1;
    UIButton *_midButton2;
    UIButton *_midButton3;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        


        
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 180)];
        _backImage.image = [UIImage imageNamed:@"small_cell_picture"];
        [self addSubview:_backImage];
        
        _personImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 110, 64, 64)];
        _personImage.image = [UIImage imageNamed:@"near_cell_two"];
        _personImage.layer.cornerRadius = 10;
        [self addSubview:_personImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 140, 150, 15)];
        _nameLabel.text = @"名称：IMAGE";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = RGBColor(255, 255, 255);
        [self addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 155, 150, 15)];
        _numLabel.text = @"微聘号：STX1234";
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textColor = RGBColor(255, 255, 255);
        [self addSubview:_numLabel];
        
        
        _photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 185, kScreenW, kScreenW/5)];
        _photoLabel.text = @"个人相册";
        _photoLabel.font = [UIFont systemFontOfSize:15];
        _photoLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_photoLabel];
        
        _photoImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/5, 185, kScreenW/5, kScreenW/5)];
        _photoImage1.image = [UIImage imageNamed:@"near_cell_one"];
        [self addSubview:_photoImage1];
        
        _photoImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/5*2, 185, kScreenW/5, kScreenW/5)];
        _photoImage2.image = [UIImage imageNamed:@"near_cell_two"];
        [self addSubview:_photoImage2];
        
        _photoImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/5*3, 185, kScreenW/5, kScreenW/5)];
        _photoImage3.image = [UIImage imageNamed:@"near_cell_three"];
        [self addSubview:_photoImage3];
        
        _photoImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/5*4, 185, kScreenW/5, kScreenW/5)];
        _photoImage4.image = [UIImage imageNamed:@"near_cell_four"];
        [self addSubview:_photoImage4];

    }
    return self;
}



@end
