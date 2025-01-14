//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPhotoToolbarDelegate <NSObject>

- (void)currentPhotoViewWillDelete;
- (void)changeCurrentImageWithFirstImage;

@end

@interface SPPhotoToolbar : UIView
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic, assign) id <MJPhotoToolbarDelegate> delegate;
@end
