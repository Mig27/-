//
//  WPPersonalAlbumCell.m
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonalAlbumCell.h"

@interface WPPersonalAlbumCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WPPersonalAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.autoresizesSubviews = YES;
        [self imageView];
    }
    
    return self;
}


-(void)setModel:(WPGlobalPhotoModel *)model{
    _model = model;
    NSString *str =[IPADDRESS stringByAppendingString:model.thumb_path];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:NULLNAME]];
}



- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}



@end
