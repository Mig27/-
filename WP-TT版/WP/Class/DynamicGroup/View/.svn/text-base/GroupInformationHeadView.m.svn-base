//
//  GroupInformationHeadView.m
//  WP
//
//  Created by 沈亮亮 on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupInformationHeadView.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "WPDownLoadVideo.h"
@interface GroupInformationHeadView ()

@end

@implementation GroupInformationHeadView

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    if (!self.model) {
        return;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame andModel:(GroupInformationListModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackGroundColor;
        self.model = model;
        [self createUI];
    }
    return self;
}

- (void)resetWith:(GroupInformationListModel *)model
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.model = model;
    [self createUI];
}

- (void)createUI
{
//    NSLog(@"^^^%@",self.model.iconList);
    NSInteger count = self.model.iconList.count;
    CGFloat width = (SCREEN_WIDTH - 5*kHEIGHT(10))/4;
    CGFloat y = 15;
    CGFloat line = kHEIGHT(10);
    CGFloat x;
    if (count == 1) {
        x = (SCREEN_WIDTH - width)/2;
    } else if (count == 2) {
        x = width + 2*kHEIGHT(10);
    } else if (count == 3) {
        x = (SCREEN_WIDTH - width)/2 - width - kHEIGHT(10);
    } else {
        x = kHEIGHT(10);
    }
    for (int i = 0; i<self.model.iconList.count; i++) {
        UIImageView *iconBtn = [[UIImageView alloc] init];
        iconBtn.frame = CGRectMake(x + (width + line)*(i%4), y + (width + line)*(i/4), width, width);
        iconBtn.clipsToBounds = YES;
        iconBtn.layer.cornerRadius = 5;
        iconBtn.tag = i + 1;
        iconBtn.userInteractionEnabled = YES;
        iconBtn.contentMode = UIViewContentModeScaleAspectFill;
        iconListModel *model = self.model.iconList[i];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [iconBtn addGestureRecognizer:tap2];
        NSString *url = [IPADDRESS stringByAppendingString:model.original_path];

        NSArray * pathArray = [url componentsSeparatedByString:@"/"];
        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
        NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
        NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
        NSData * data = [NSData dataWithContentsOfFile:fileName1];
        if (data) {
            iconBtn.image = [UIImage imageWithData:data];
        }
        else
        {
            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [down downLoadImage:url success:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        iconBtn.image = [UIImage imageWithData:response];
                    });
                } failed:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        iconBtn.image = [UIImage imageNamed:@"placeImage"];
                    });
                }];
            });
            
        }
        
        
        
        //[iconBtn sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        [self addSubview:iconBtn];
    }
}


- (void)tapImage:(UITapGestureRecognizer *)tap{
    
    NSInteger count = [self.model.iconList count];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        iconListModel *model = self.model.iconList[i];
        NSString *url = [IPADDRESS stringByAppendingString:model.original_path];
//        NSLog(@"%@",url);
        //        MJPhoto *photo = [[MJPhoto alloc] init];
        //        photo.sid = self.dicInfo[@"sid"];
        //        photo.url = [NSURL URLWithString:url];
        //        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        //        photo.srcImageView = imageV;
        //        [photos addObject:photo];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        photo.toView = imageV;
        [photos addObject:photo];
    }
    
    //    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //    brower.currentPhotoIndex = tap.view.tag - 1;
    //    brower.photos = photos;
    //    [brower show];
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    photoBrowser.currentStr = [IPADDRESS stringByAppendingString:[self.model.iconList[tap.view.tag - 1] original_path]];
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tap.view.tag - 1 inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:[self viewController]];
//    [photoBrowser show];
    
}

#pragma mark - 获取view所在的控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
