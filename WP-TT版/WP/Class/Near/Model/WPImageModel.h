//
//  WPImageModel.h
//  WP
//
//  Created by CBCCBC on 16/3/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WPImageModel : NSObject

@property (nonatomic ,strong)UIImage *image;
@property (nonatomic ,assign)BOOL isChange;

- (instancetype)initWithImage:(UIImage *)image;

@end
