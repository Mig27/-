//
//  SAYPhotoManagerViewController.m
//  CampusJobV2
//
//  Created by school51 on 15/4/1.
//  Copyright (c) 2015年 noworrry. All rights reserved.
//

#import "SAYVideoManagerViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import <BlocksKit+UIKit.h>
//#import <ReactiveCocoa.h>
#import "WPHttpTool.h"
#import "WPActionSheet.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "MLSelectPhotoAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "UIButton+WebCache.h"
#import "SPPhotoAsset.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DBTakeVideoVC.h"
#import "CTAssetsPickerController.h"
#import "VideoBrowser.h"
#import "WPCompanyListModel.h"

@interface SAYVideoManagerViewController ()<UIActionSheetDelegate,WPActionSheet,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,callBackVideo,takeVideoBack>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;
@property (strong, nonatomic) UIScrollView *photoScroll;
@property (strong, nonatomic) UIScrollView *videoScroll;

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *label1;

@end

@implementation SAYVideoManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册";
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.data = [NSMutableArray array];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 64+10, SCREEN_WIDTH, 20)];
    _label.text = @"照片";
    _label.textColor = RGB(153, 153, 153);
    _label.font = kFONT(15);
    [self.view addSubview:_label];
    
    self.photoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _label.bottom+10, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
    //    _photoScroll.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.photoScroll];
    
    //    _photoScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 300);
    
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.photoScroll.bottom, SCREEN_WIDTH, 20)];
    _label1.text = @"视频";
    _label1.font = kFONT(15);
    _label1.textColor = RGB(153, 153, 153);
    [self.view addSubview:_label1];
    
    self.videoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _label1.bottom, SCREEN_WIDTH, SCREEN_WIDTH/4)];
    //    _videoScroll.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.videoScroll];
    
    //    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelbtn.frame = CGRectMake(0, 0, 30, 20);
    //    cancelbtn.backgroundColor = [UIColor redColor];
    //    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
//    back.tag = pushType;
//    backTag = pushType;
    [back addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
//    self.navigationItem.leftBarButtonItem = item;
    
    CGFloat width = (SCREEN_WIDTH - 5*5)/4;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5+width-20+30+64, width, 20)];
    _titleLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    _titleLabel.text = @"封面";
    _titleLabel.font = kFONT(10);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:_titleLabel];
    
    [self startLoadData];
}

-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)getImageFromVideo:(id)video
{
    UIImage *image = [[UIImage alloc]init];
    if ([video isKindOfClass:[NSString class]]) {
        image = [UIImage getImage:video];
    }else{
        ALAsset *asset = video;
        image = [UIImage imageWithCGImage:asset.thumbnail];
    }
    return image;
}

- (void)startLoadData
{
    if (self.arr.count > 0) {
        _newPhotolist = [[NSMutableArray alloc]initWithArray:self.arr];
    }else{
        _newPhotolist = [[NSMutableArray alloc]init];
        _label.height = 0;
        _titleLabel.hidden = YES;
    }
    [self updatephotoScroll];
    
    if (self.videoArr.count > 0) {
        _newVideolist = [[NSMutableArray alloc]initWithArray:self.videoArr];
    }else{
        _newVideolist = [[NSMutableArray alloc]init];
        _label1.hidden = YES;
    }
    
    [self updateVideoScroll];
}

- (void)updatephotoScroll
{
    CGFloat width = (SCREEN_WIDTH - 5*5)/4;
    for (int i=0; i< _newPhotolist.count; i++) {
        CGFloat y = i/4*(width + 5) + 5;
        CGFloat x = i%4*(width + 5) + 5;
        UIButton *dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dragBtn.frame = CGRectMake(x, y, width, width);
//        UIImage *image = [self getImageFromVideo:_newPhotolist[i]];
        if ([_newPhotolist[i] isKindOfClass:[SPPhotoAsset class]]) {
            [dragBtn setImage:[_newPhotolist[i] thumbImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] thumb_path]]];
            [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
//        [dragBtn setBackgroundImage:image forState:UIControlStateNormal];
//        [dragBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        dragBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        dragBtn.layer.cornerRadius = 5;
//        dragBtn.clipsToBounds = YES;
        dragBtn.tag = 100 + i;
        [dragBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photoScroll addSubview:dragBtn];
    }
    
    _photoScroll.top = _label.bottom;
    if (_newPhotolist.count == 0) {
        _photoScroll.height = _newPhotolist.count/4*(width+5);
        _label1.top = _photoScroll.bottom;
    }else{
        if (_newPhotolist.count%4==0) {
            _photoScroll.height = _newPhotolist.count/4*(width+5);
        }else{
            _photoScroll.height = (_newPhotolist.count/4+1)*(width+5);
        }
        _label1.top = _photoScroll.bottom+10;
    }
    _videoScroll.top = _label1.bottom;
    
    [_photoScroll bringSubviewToFront:_titleLabel];
}

- (void)updateVideoScroll
{
    for (UIView *view in self.videoScroll.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = (SCREEN_WIDTH - 5*5)/4;
    for (int i=0; i< _newVideolist.count; i++) {
        CGFloat y = i/4*(width + 5) + 5;
        CGFloat x = i%4*(width + 5) + 5;
        UIButton *dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dragBtn.frame = CGRectMake(x, y, width, width);
        //        [dragBtn setBackgroundImage:_newVideolist[i] forState:UIControlStateNormal];
        //        [dragBtn setBackgroundImage:_newVideolist[i] forState:UIControlStateHighlighte d];
        //        [dragBtn setImage:_newPhotolist[i] forState:UIControlStateNormal];
        dragBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        dragBtn.layer.cornerRadius = 5;
//        dragBtn.clipsToBounds = YES;
        dragBtn.tag = 300 + i;
        [dragBtn addTarget:self action:@selector(VonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoScroll addSubview:dragBtn];
        
        if ([_newVideolist[i] isKindOfClass:[NSString class]]) {
            [dragBtn setImage:[UIImage getImage:_newVideolist[i]] forState:UIControlStateNormal];
        }else if([_newVideolist[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = _newVideolist[i];
            [dragBtn setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newVideolist[i] thumb_path]]];
            [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(dragBtn.width/2-10,dragBtn.width/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [dragBtn addSubview:subImageV];
    }
    
    if (_newPhotolist.count==0&&_newVideolist.count==0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, 20)];
        label.text = @"暂无照片或视频";
        label.textColor = RGB(0, 0, 0);
        label.font = kFONT(15);
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [self.view bringSubviewToFront:label];
    }
}

- (void)onTap
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
    [actionSheet showInView:self.view];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        [self fromCamera];
    }
    if (buttonIndex == 1) {
        [self fromAlbums];
    }
}

- (void)fromCamera {
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.takeVideoDelegate = self;
    [self.navigationController pushViewController:tackVedio animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)fromAlbums {

//    NSLog(@"导入视频");
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 8-_newPhotolist.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [_newPhotolist addObjectsFromArray:array];
    [self updatephotoScroll];
}
//录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [_newPhotolist addObject:filePaht];
    [self updatephotoScroll];
}
//直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [_newPhotolist addObjectsFromArray:assets];
    [self updatephotoScroll];
}

#pragma mark - 点击浏览图片
- (void)onBtnClick:(UIButton *)sender
{
//    NSLog(@"观看视频");
//    if ([_newPhotolist[sender.tag-100] isKindOfClass:[NSString class]]) {
//        NSURL *url = [NSURL fileURLWithPath:_newPhotolist[sender.tag-100]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    } else {
//        ALAsset *asset = _newPhotolist[sender.tag-100];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    }
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _newPhotolist.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([_newPhotolist[i] isKindOfClass:[SPPhotoAsset class]]) {
            photo.image = [_newPhotolist[i] originImage];
        }else{
            photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] original_path]]];
        }
//        photo.image = _newPhotolist[i];
        photo.srcImageView = [(UIButton *)[_photoScroll viewWithTag:100+i] imageView];
        [arr addObject:photo];
    }
//PhotoVideo
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.currentPhotoIndex = sender.tag-100;
    brower.photos = arr;
    [brower show];
    
}

- (void)onPlaybackFinished
{
//    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark 点击 查看视频
- (void)VonBtnClick:(UIButton *)sender
{
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.isCreat = YES;
//    NSLog(@"查看视频");
    if ([_newVideolist[sender.tag-300] isKindOfClass:[NSString class]]) {
        video.isNetOrNot = NO;
        video.videoUrl = _newVideolist[sender.tag-300];
//        NSURL *url = [NSURL fileURLWithPath:_newVideolist[sender.tag-300]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else if([_newVideolist[sender.tag-300] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = _newVideolist[sender.tag-300];
        video.isNetOrNot = NO;
        video.videoUrl = [NSString stringWithFormat:@"%@",asset.defaultRepresentation.url];
//        ALAsset *asset = _newVideolist[sender.tag-300];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        video.isNetOrNot = YES;
        video.videoUrl =[IPADDRESS stringByAppendingString:[_newVideolist[sender.tag-300] original_path]];
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newVideolist[sender.tag-300] original_path]]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    [video showPickerVc:self];
    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
}

//- (void)onPlaybackFinished
//{
//    NSLog(@"onPlaybackFinished");
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//}

-(void)deleteVideoClick:(UIButton *)sender
{
    _deleteIndex = sender.tag - 200;
    [self deletePhoto];
}

- (void)deletePhoto
{
    UIButton *btnSecleted = (UIButton *)[_photoScroll viewWithTag:_deleteIndex + 100];
    _dragToPoint = btnSecleted.center;
    
    [btnSecleted removeFromSuperview];
    
    __block NSMutableArray * bnewAlbumlist = _newPhotolist;
    __block UIScrollView * bphotoScrol = _photoScroll;
    //把删除按钮的下一个按钮移动到记录的删除按钮的位置，并把下一按钮的位置记为新的_toFrame，并把view的tag值-1,依次处理
    [UIView animateWithDuration:0.3 animations:^
     {
         for (int i = (int)_deleteIndex + 1; i < bnewAlbumlist.count; i ++)
         {
             UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
             _dragFromPoint = dragBu.center;
             dragBu.center = _dragToPoint;
             _dragToPoint = _dragFromPoint;
             dragBu.tag --;
         }
         
     } completion:^(BOOL finished) {
         //移动完成之后,才能从_newAlbumlist列表中移除要删除按钮的数据
         [bnewAlbumlist removeObjectAtIndex:_deleteIndex];
//         NSLog(@">>>>>>>>>>>>>%@",_newPhotolist);
         for (UIView *btn in _photoScroll.subviews) {
             [btn removeFromSuperview];
         }
         [self updatephotoScroll];
     }];
}

- (void)handlePanGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self dragTileBegan:recognizer];
            [self startShake:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self dragTileMoved:recognizer];
            break;//开始时忘记加break，一直执行结束方法
        }
        case UIGestureRecognizerStateEnded:
        {
            [self dragTileEnded:recognizer];
            [self stopShake:recognizer.view];
            break;
        }
        default:
            break;
    }
}

- (void)dragTileBegan:(UIGestureRecognizer *)recognizer
{
    //把要移动的视图放在顶层
    [_photoScroll bringSubviewToFront:recognizer.view];
    
    _dragFromPoint = recognizer.view.center;
}

#pragma mark - 拖动晃动
- (void)startShake:(UIView* )imageV
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}

- (void)dragTileMoved:(UIGestureRecognizer *)recognizer
{
    CGPoint locationPoint = [recognizer locationInView:_photoScroll];
    recognizer.view.center = locationPoint;
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIImageView *)recognizer.view];
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIView *)tileView
{
    for (UIButton *item in _photoScroll.subviews)
    {
        //移动到另一个按钮的区域，判断需要移动按钮的位置
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView )
        {
            
            //开始的位置
            NSInteger fromIndex = tileView.tag - 100;
            //需要移动到的位置
            NSInteger toIndex = (item.tag - 100)>0?(item.tag - 100):0;
//            NSLog(@"从位置%d移动到位置%d",(int)fromIndex, (int)toIndex);
            [self dragMoveFromIndex:fromIndex ToIndex:toIndex withView:tileView];
        }
    }
    [_photoScroll bringSubviewToFront:_titleLabel];
}

- (void)dragMoveFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex withView:(UIView *)tileView
{
    //局部变量是不能在闭包中发生改变的，所以需要把_dragFromPoint，_dragToPoint定义成全局变量
    __block NSMutableArray * bnewAlbumlist = _newPhotolist;
    __block UIScrollView * bphotoScrol = _photoScroll;
    NSDictionary * moveDict = [bnewAlbumlist objectAtIndex:fromIndex];
    [bnewAlbumlist removeObjectAtIndex:fromIndex];
    [bnewAlbumlist insertObject:moveDict atIndex:toIndex];
    //向前移动
    if (fromIndex > toIndex)
    {
        //把移动相册的上一个相册移动到记录的移动相册的位置，并把上一相册的位置记为新的_dragFromPoint，并把view的tag值+1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            
            for (int i = (int)fromIndex - 1; i >= toIndex; i--)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag ++;
            }
            tileView.tag = 100 + toIndex;
        }];
    }
    //向后移动
    else
    {
        //把移动相册的下一个相册移动到记录的移动相册的位置，并把下一相册的位置记为新的_dragFromPoint，并把view的tag值-1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = (int)fromIndex + 1; i <= toIndex; i++)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag --;
            }
            tileView.tag = 100 + toIndex;
        }];
    }
}
- (void)dragTileEnded:(UIGestureRecognizer *)recognizer
{
    //    [UIView animateWithDuration:0.2f animations:^{
    //        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        recognizer.view.alpha = 1.f;
    //    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    _isDragTileContainedInOtherTile = NO;
//    NSLog(@"*******%@",_newPhotolist);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
