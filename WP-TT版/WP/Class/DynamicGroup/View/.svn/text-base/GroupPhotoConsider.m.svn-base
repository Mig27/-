//
//  GroupPhotoConsider.m
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupPhotoConsider.h"
#import "UIImage+MR.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "RSPhotoView.h"
#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "NewDetailViewController.h"

@interface GroupPhotoConsider ()

@property (nonatomic,strong)NSMutableArray *imageViews;
@property (nonatomic,strong)UIImageView *placeImage;
@property (nonatomic, strong) RSPhotoView *longTouchView;   /**< 长按的view */

@end

@implementation GroupPhotoConsider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.dicInfo) {
        return;
    }
    self.imageViews = [NSMutableArray array];
    
    NSInteger count = [self.dicInfo.PhotoList count];
//    if (count>0) {
//        for (int i = 0; i < count; i++) {
//            NSString *urlStr = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]];
//            [self.imageViews addObject:urlStr];
//        }
//        
//    }
//    
//    NSInteger videoCount = [self.dicInfo[@"videoCount"] integerValue];
//    
//    NSInteger index = [self.dicInfo[@"small_photos"] count];
    //    CGFloat width = kHEIGHT(76);
    CGFloat width;
    CGFloat videoWidth;
    if (SCREEN_WIDTH == 320) {
        width = 74;
        videoWidth = 140;
    } else if (SCREEN_WIDTH == 375) {
        width = 79;
        videoWidth = 164;
    } else {
        width = 86;
        videoWidth = 172;
    }
    CGFloat line = 3;
    //    CGFloat y1 = 8;
    CGFloat y1 = 0;
    CGFloat x;
    x = kHEIGHT(10) + kHEIGHT(37) + 10;
    
//    if (videoCount == 1) {
//        NSString *specialUrl = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][0][@"media_address"]];
//        NSLog(@"有视频---%@",specialUrl);
//        self.videoUrl = specialUrl;
//        RSPhotoView *video = [[RSPhotoView alloc] initWithFrame:CGRectMake(x, y1, videoWidth, videoWidth)];
//        video.tag = -1;
//        NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][0][@"small_address"]];
//        [video sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
//        //                }
//        //        video.clipsToBounds = YES;
//        video.userInteractionEnabled = YES;
//        video.contentMode = UIViewContentModeScaleAspectFill;
//        video.clipsToBounds = YES;
//        //        video.contentMode = UIViewContentModeScaleToFill;
//        [self addSubview:video];
//        
//        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //        if (self.condiderType == ConsiderLayoutTypeSpecial) {
//        //            playBtn.frame = CGRectMake(x, y1, 0.625*SCREEN_WIDTH, 0.625*SCREEN_WIDTH);
//        //        } else {
//        playBtn.frame = CGRectMake(x, y1, videoWidth, videoWidth);
//        //        }
//        [playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
//        [playBtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
//        playBtn.enabled = NO;
//        playBtn.userInteractionEnabled = YES;
//        [self addSubview:playBtn];
//        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoClick)];
//        [video addGestureRecognizer:tap1];
//        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        recognizer.minimumPressDuration = 0.5;
//        [video addGestureRecognizer:recognizer];
//        
//        
//        return;
//    }
    
    if (count != 4 && count != 0) {
        for (int i=0; i < count; i++) {
            RSPhotoView *imageView = [[RSPhotoView alloc] init];
            imageView.tag = i + 1;
            imageView.userInteractionEnabled  = YES;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tap1];
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            recognizer.minimumPressDuration = 0.5;
            [imageView addGestureRecognizer:recognizer];
            //            NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]];
            GroupPhotoListModel *model = self.dicInfo.PhotoList[i];
            NSString *url = [IPADDRESS stringByAppendingString:model.original_path];
            imageView.frame = CGRectMake(x + (width + line)*(i%3), y1 + (width + line)*(i/3), width, width);
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:imageView];
            
        }
    } else if (count == 4) {
        for (int i = 0; i< count; i++) {
            RSPhotoView *imageView = [[RSPhotoView alloc] init];
            imageView.tag = i + 1;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tap2];
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            recognizer.minimumPressDuration = 0.5;
            [imageView addGestureRecognizer:recognizer];
            //            NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]];
            GroupPhotoListModel *model = self.dicInfo.PhotoList[i];
            NSString *url = [IPADDRESS stringByAppendingString:model.original_path];
            imageView.frame = CGRectMake(x + (width + line)*(i%2), y1 + (width + line)*(i/2), width, width);
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self addSubview:imageView];
        }
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //        CopyCell *cell = (CopyCell *)recognizer.view;
        RSPhotoView *imageV = (RSPhotoView *)recognizer.view;
        self.longTouchView = imageV;
        //        NSLog(@"%@",NSStringFromCGRect(imageV.frame));
        //        imageV.backgroundColor = RGBA(226, 226, 226, 0.5);
        [imageV becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        //        [menuController setMenuVisible:NO];
        //设置菜单
        //        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuItem3:)];
//        if (self.isFromColume)
//        {
          [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2, nil]];
//        }
//        else
//        {
//         [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2,menuItem3, nil]];
//        }
        
//        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2,menuItem3, nil]];
        //设置菜单栏位置
        [menuController setTargetRect:imageV.frame inView:imageV.superview];
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
    
}

#pragma mark - 收藏
- (void)menuItem2:(id)sender
{
       NSInteger touchTag = self.longTouchView.tag;
       GroupPhotoListModel *model = self.dicInfo.PhotoList[touchTag - 1];
        NSDictionary *userInfo = @{@"collect_class" : @"1",
                                   @"user_id" : self.dicInfo.created_user_id,
                                   @"content" : @"",
                                   @"img_url" : model.thumb_path,
                                   @"vd_url" : @"",
                                   @"jobid" : @"",
                                   @"url" : @""};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alumCollect" object:nil userInfo:userInfo];
//    }
    
}

#pragma mark - 举报
- (void)menuItem3:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"alumReport" object:nil userInfo:@{@"sid" : self.dicInfo.albumnId}];
    
}

-(void)WillHideMenu:(id)sender
{
    
}


- (void)tapImage:(UITapGestureRecognizer *)tap{
    UIViewController *controller = [self viewController];
    //    NSLog(@"%@",controller);
    if ([[controller class] isEqual:[NewDetailViewController class]]) {
        //        NSLog(@"yes");
        NewDetailViewController *detail = (NewDetailViewController *)controller;
        [detail keyBoardDismiss];
    }
    
    NSInteger count = self.dicInfo.PhotoList.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        
        GroupPhotoListModel *model = self.dicInfo.PhotoList[i];
        NSString *url = [IPADDRESS stringByAppendingString:model.original_path];

        //        MJPhoto *photo = [[MJPhoto alloc] init];
        //        photo.sid = self.dicInfo[@"sid"];
        //        photo.url = [NSURL URLWithString:url];
        //        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        //        photo.srcImageView = imageV;
        //        [photos addObject:photo];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
//        photo.sid = self.dicInfo[@"user_id"];
        photo.toView = imageV;
        [photos addObject:photo];
    }
    
//    //    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
//    //    brower.currentPhotoIndex = tap.view.tag - 1;
//    //    brower.photos = photos;
//    //    [brower show];
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    photoBrowser.currentStr = [IPADDRESS stringByAppendingString:[self.dicInfo.PhotoList[tap.view.tag-1] original_path]];
//    photoBrowser.reloadIndex = self.index;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tap.view.tag - 1 inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:[self viewController]];
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
