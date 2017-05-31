//
//  MRTabBarButton.m
//  Weibo
//
//  Created by Asuna on 15/5/18.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import "WPTabBarButton.h"
#import "WPBadgeButton.h"

@interface WPTabBarButton()
@property(nonatomic,weak) WPBadgeButton *badgeButton;
@end

@implementation WPTabBarButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

        self.titleLabel.font = [UIFont systemFontOfSize:11];

        [self setTitleColor:IWTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:IWTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
        
        if (!iOS7) {
            [self setBackgroundImage:[UIImage imageWithName:@"tabbar_slider"] forState:UIControlStateSelected];
        }
        
        WPBadgeButton *badgeButton = [[WPBadgeButton alloc] init];
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.frame.size.width;
    CGFloat imageH = self.frame.size.height * 0.6;
    return CGRectMake(imageX, imageY+3, imageW, imageH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.frame.size.height * 0.6;
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * 0.4-5;
    return CGRectMake(titleX, titleY+2, titleW, titleH);
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    CGFloat badgeY = 5;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 10;
    CGRect  badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
}
@end
