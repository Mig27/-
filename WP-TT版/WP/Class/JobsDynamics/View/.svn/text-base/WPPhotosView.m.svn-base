//
//  WPPhotosView.m
//  WP
//
//  Created by Asuna on 15/6/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPhotosView.h"
#import "WPPhoto.h"
#import "WPPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MR.h"

@interface WPPhotosView()
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation WPPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i<9; i++) {
            WPPhotoView *photoView = [[WPPhotoView alloc] init];
            photoView.userInteractionEnabled = YES;
            photoView.tag = i;
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
            [self addSubview:photoView];
        }
    }
    
    return self;
}

- (void)photoTap:(UITapGestureRecognizer *)recognizer
{
    int count = (int)self.photos.count;
    
    if (count > 9) {
        count = 9;
    }
    //1.新建一个数组用来保存MJPhoto
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        //2.初始化一个MJPhoto
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        //3.将图片放入MJPhoto的srcImageView中
        mjphoto.srcImageView = self.subviews[i];
        
        WPPhoto *iwphoto = self.photos[i];
        NSString *photoUrl = iwphoto.media_address;
        //4.设置MJPhoto的URL
        mjphoto.url = [NSURL URLWithString:photoUrl];
        //5.将MJPhoto添加到数组中
        [myphotos addObject:mjphoto];
    }
    
    //6.建立MJPhotoBrowser的类
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //7.设置当前打开的photo所在的索引
    browser.currentPhotoIndex = recognizer.view.tag;
    //8.将myphotos数组赋值给browser
    browser.photos = myphotos;
    //9.显示browser
    [browser show];
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    for (int i = 0; i<self.subviews.count; i++) {
        
        WPPhotoView *photoView = self.subviews[i];
        
          if(i < photos.count){
        
            photoView.hidden = NO;
            
            photoView.photo = photos[i];
            
            int maxColumns = (photos.count == 4) ? 2 : 3;
            int col = i % maxColumns;
            int row = i / maxColumns;
            CGFloat photoX = col * (WPPhotoW + WPPhotoMargin);
            CGFloat photoY = row * (WPPhotoH + WPPhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, WPPhotoW, WPPhotoH);
            

            if (photos.count == 1) {
                //WPPhoto *photoes = photos[0];
                
                //NSString *strPath = [IPADDRESS stringByAppendingString:photoes.media_address];
                //[self.imageView setImageWithURL:[NSURL URLWithString:strPath]];// placeholderImage:[UIImage imageWithName:@"small_cell_person"]];
                CGFloat width = photoView.image.size.width;
                CGFloat height = photoView.image.size.height;
                if (width >height) {
                    CGFloat scaleOne = width/200;
                    width = 200;
                    height = height/scaleOne;
                } else {
                    CGFloat scaleTwo = height/200;
                    height = 200;
                    width = width/scaleTwo;
                }
                
                photoView.image = [UIImage reSizeImage:photoView.image toSize:CGSizeMake(width, height)];
                self.image = photoView.image;
                photoView.frame = CGRectMake(photoX, photoY, width, height);
                //photoView.contentMode = UIViewContentModeRedraw;
                //photoView.clipsToBounds = YES;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;
            }
        } else {
            photoView.hidden = YES;
        }
    }
}

- (CGSize)photosViewSizeWithPhotosCount:(int)count
{
    
    if (count == 1) {
        return CGSizeMake(200, 200);
    }

    int maxColumns = (count == 4) ? 2 : 3;
    int rows = (count + maxColumns - 1) / maxColumns;
    CGFloat photosH = rows * WPPhotoH + (rows - 1) * WPPhotoMargin;
    
    int cols = (count >= maxColumns) ? maxColumns : count;
    CGFloat photosW = cols * WPPhotoW + (cols - 1) * WPPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
