//
//  WPPhotoView.m
//  WP
//
//  Created by Asuna on 15/6/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPhotoView.h"
#import "WPPhoto.h"
#import "UIImageView+WebCache.h"

@interface WPPhotoView()

@property (nonatomic,weak) UIImageView *gifView;

@end

@implementation WPPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        UIImage *image = [UIImage imageWithName:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

- (void)setPhoto:(WPPhoto *)photo
{
    _photo = photo;
    NSString *strPath = [IPADDRESS stringByAppendingString:photo.media_address];

    //self.gifView.hidden = ![strPath hasSuffix:@"gif"];
    self.gifView.hidden = YES;
    [self sd_setImageWithURL:[NSURL URLWithString:strPath] placeholderImage:[UIImage imageWithName:@"small_cell_person"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}

@end
