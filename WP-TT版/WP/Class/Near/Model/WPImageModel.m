//
//  WPImageModel.m
//  WP
//
//  Created by CBCCBC on 16/3/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPImageModel.h"

@implementation WPImageModel

- (instancetype)initWithImage:(UIImage *)image
{
    if ([super init]) {
        self.image = image;
        self.isChange = YES;
    }
    return self;
}

@end
