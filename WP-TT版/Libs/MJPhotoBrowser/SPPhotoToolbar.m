//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "SPPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+MJ.h"
#import "MacroDefinition.h"
@interface SPPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_deleteImageBtn;
    UITextView *_textView;
}
@end

@implementation SPPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
//        if (!_indexLabel) {
//            
////            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
////            view.backgroundColor = RGBA(0, 0, 0, 0.5);
////            [self addSubview:view];
//            
//            _indexLabel = [[UILabel alloc] init];
//            _indexLabel.font = [UIFont boldSystemFontOfSize:20];
//            _indexLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(49));
//            _indexLabel.backgroundColor = [UIColor clearColor];
//            _indexLabel.textColor = [UIColor whiteColor];
//            _indexLabel.textAlignment = NSTextAlignmentCenter;
//            _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            [self addSubview:_indexLabel];
//        }
    }
//    if (!_textView) {
    
        // 保存图片按钮
        CGFloat btnWidth = kHEIGHT(49);
        _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveImageBtn.frame = CGRectMake(10, 0, btnWidth, btnWidth);
        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//        [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
        [_saveImageBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_saveImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveImageBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveImageBtn];
        
        // 保存图片按钮
        _deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteImageBtn.frame = CGRectMake(SCREEN_WIDTH-90, 0, 80, kHEIGHT(49));
        _deleteImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [_deleteImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//        [_deleteImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
        [_deleteImageBtn setTitle:@"设为首图" forState:UIControlStateNormal];
//        [_deleteImageBtn setBackgroundColor:[UIColor blackColor]];
        [_deleteImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleteImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteImageBtn];
        
//        _textView = [[UITextView alloc] init];
//        [_textView setFrame:CGRectMake(0, 0, 320, 50)];
//        _textView.backgroundColor = [UIColor clearColor];
//        _textView.editable = NO;
//        _textView.textAlignment = NSTextAlignmentLeft;
//        _textView.textColor = [UIColor whiteColor];
//        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [self addSubview:_textView];
//    }
}

- (void)saveImage
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
    if ([self.delegate respondsToSelector:@selector(changeCurrentImageWithFirstImage)]) {
        [self.delegate changeCurrentImageWithFirstImage];
    }
}

- (void)deleteImage{
    
    if ([self.delegate respondsToSelector:@selector(currentPhotoViewWillDelete)]) {
        [self.delegate currentPhotoViewWillDelete];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        photo.save = YES;
//        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    
//    MJPhoto *photo = _photos[_currentPhotoIndex];
//    [_textView setText:photo.photoDescription];
    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

@end
