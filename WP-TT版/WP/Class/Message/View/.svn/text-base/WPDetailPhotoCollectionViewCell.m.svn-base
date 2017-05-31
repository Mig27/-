//
//  WPDetailPhotoCollectionViewCell.m
//  WP
//
//  Created by CC on 16/7/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDetailPhotoCollectionViewCell.h"

@interface WPDetailPhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation WPDetailPhotoCollectionViewCell
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


-(void)setModel:(NSDictionary *)dic{
//    _model = model;
    NSString *str =[IPADDRESS stringByAppendingString:dic[@"thumb_path"]];
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
