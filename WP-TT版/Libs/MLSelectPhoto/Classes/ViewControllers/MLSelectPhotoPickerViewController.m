//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoNavigationViewController.h"
#import "MLSelectPhotoPickerGroupViewController.h"
#import "MLSelectPhotoCommon.h"
#import "MLSelectPhotoAssets.h"

@interface MLSelectPhotoPickerViewController ()
@property (nonatomic , weak) MLSelectPhotoPickerGroupViewController *groupVc;
@end

@implementation MLSelectPhotoPickerViewController



#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init Action
- (void) createNavigationController{
    MLSelectPhotoPickerGroupViewController *groupVc = [[MLSelectPhotoPickerGroupViewController alloc] init];
    groupVc.isFromChat = self.isFromChat;
    MLSelectPhotoNavigationViewController *nav = [[MLSelectPhotoNavigationViewController alloc] initWithRootViewController:groupVc];
    nav.view.frame = self.view.bounds;
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    self.groupVc = groupVc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self createNavigationController];
    }
    return self;
}

- (void)setSelectPickers:(NSArray *)selectPickers{
    _selectPickers = selectPickers;
    self.groupVc.selectAsstes = selectPickers;
}

- (void)setStatus:(PickerViewShowStatus)status{
    _status = status;
    self.groupVc.status = status;
}

- (void)setMinCount:(NSInteger)minCount{
    if (minCount <= 0) return;
    _minCount = minCount;
    self.groupVc.minCount = minCount;
}

#pragma mark - 展示控制器
- (void)show{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[[[UIApplication sharedApplication].windows lastObject] rootViewController] presentViewController:self animated:YES completion:nil];
}

- (void) addNotification{
    // 监听异步done通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:PICKER_TAKE_DONE object:nil];
    });
}

- (void) done:(NSNotification *)note{
    NSArray *selectArray =  note.userInfo[@"selectAssets"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(pickerViewControllerDoneAsstes:)]) {
            [self.delegate pickerViewControllerDoneAsstes:selectArray];
        }else if (self.callBack){
            self.callBack(selectArray);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
//        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (void)setTopShowPhotoPicker:(BOOL)topShowPhotoPicker{
    _topShowPhotoPicker = topShowPhotoPicker;
    self.groupVc.topShowPhotoPicker = topShowPhotoPicker;
}

- (void)setDelegate:(id<ZLPhotoPickerViewControllerDelegate>)delegate{
    _delegate = delegate;
    self.groupVc.delegate = delegate;
}

#pragma mark - 通过传入一个图片对象（MLSelectPhotoAssets/ALAsset）获取一张缩略图
+ (UIImage *)getImageWithImageObj:(id)imageObj{
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    }else if ([imageObj isKindOfClass:[ALAsset class]]){
        @autoreleasepool {
            ALAsset *asset = (ALAsset *)imageObj;
            return [UIImage imageWithCGImage:[asset thumbnail]];
        }
    }else if ([imageObj isKindOfClass:[MLSelectPhotoAssets class]]){
        MLSelectPhotoAssets * asset = (MLSelectPhotoAssets*)imageObj;
        if (asset.isThumbOrOrginal)
        {
           return [imageObj originImage];
        }
        else
        {
          return [imageObj thumbImage];
        }
//        return [imageObj thumbImage];
    }
    return image;
}

+ (UIImage *) getOrgImageWithImageObj:(id)imageObj{
    NSLog(@"这个方法没有实现！");
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    }else if ([imageObj isKindOfClass:[ALAsset class]]){
        @autoreleasepool {
            ALAsset *asset = (ALAsset *)imageObj;
            return [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        }
    }else if ([imageObj isKindOfClass:[MLSelectPhotoAssets class]]){
        return [imageObj originImage];
    }
    return image;
    return nil;
}

@end
