//
//  WPPhotoAndVideoController.m
//  WP
//
//  Created by CC on 16/10/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhotoAndVideoController.h"
#import "MLPhotoBrowserPhoto.h"
#import "UIView+MLExtension.h"
#import "MLPhotoBrowserPhotoScrollView.h"
#import "ZacharyPlayManager.h"
#import "SDDemoItemView.h"
#import "SDLoopProgressView.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "MTTMessageEntity.h"
#import "VideoBrowser.h"
#import "LewVideoController.h"
#import "HJCActionSheet.h"
#import "WPSetMessageType.h"
#define shuoShuoVideo @"/shuoShuoVideo"

static NSInteger const ZLPickerPageCtrlH = 43;

static NSString *_cellIdentifier = @"collectionViewCell";
@interface WPPhotoAndVideoController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLPhotoPickerPhotoScrollViewDelegate,HJCActionSheetDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, copy) NSString * filePath;
@property (nonatomic, strong)UILabel *pageLabel;
@property (nonatomic, strong)UIImageView* backView;
@property (nonatomic, strong)UIImageView * downLoadBack;
@property (nonatomic, strong)UIView* bottomView;
@property (nonatomic, strong)UIButton*clickBtn;
@property (nonatomic, strong)SDDemoItemView*videoItem;//LewVideoController
@property (nonatomic, strong)LewVideoController *videoController;
@property (nonatomic, strong)UIScrollView * videoAndPhotoScroller;
@property (nonatomic, assign)NSUInteger firstInPage;
@property (nonatomic, assign)CGFloat NowContentX;
@property (nonatomic, assign) BOOL isNeedPlay;
@property (nonatomic, assign) BOOL isHideOrNot;
@end

@implementation WPPhotoAndVideoController
{
    NSProgress* videoprogress;
}
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.bottomView addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        NSString *widthVfl = @"H:|-0-[pageLabel]-0-|";
        NSString *heightVfl = @"V:[pageLabel(ZLPickerPageCtrlH)]-0-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageLabel);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(ZLPickerPageCtrlH)};
        
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];

    }
    return _pageLabel;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 43)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 20;
        flowLayout.itemSize = self.view.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView * collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH+20, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        collection.showsHorizontalScrollIndicator = NO;
        collection.showsVerticalScrollIndicator = NO;
        collection.pagingEnabled = YES;
        collection.dataSource = self;
        collection.backgroundColor = [UIColor clearColor];
        collection.bounces = YES;
        collection.delegate = self;
        [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];///UICollectionViewCell
        [self.view addSubview:collection];
        self.collectionView = collection;
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-20)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        [self.view addSubview:self.bottomView];
        self.pageLabel.hidden = NO;
        
    }
    return _collectionView;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = (NSInteger)scrollView.contentOffset.x / (scrollView.ml_width - 20);
    if (currentPage == self.videoAndPhotoArr.count - 1 && currentPage != self.currentPage && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    }
    self.currentPage = currentPage;
    NSLog(@"%lu",(unsigned long)self.currentPage);
    [self setPageLabelPage:currentPage];
    
    
    
    
    
//    [self.collectionView setContentOffset:CGPointMake(self.currentPage*(SCREEN_WIDTH+20), 0)];
    self.isNeedPlay = YES;
    [self.collectionView reloadData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_videoController.player pause];
    CGFloat nowX = self.collectionView.contentOffset.x;
    CGFloat maxX = (self.videoAndPhotoArr.count-1)*(SCREEN_WIDTH+20);
    if (nowX > maxX) {
        self.collectionView.contentOffset = CGPointMake((self.videoAndPhotoArr.count-1)*(SCREEN_WIDTH+20), 0);
        self.currentPage = self.videoAndPhotoArr.count;
        [_videoController.player play];
    }
    else
    {
        if (nowX < 0) {
            self.collectionView.scrollEnabled = NO;
            self.currentPage = 1;
            [_videoController.player play];
        }
        else
        {
          self.collectionView.scrollEnabled = YES;
        }
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [_videoController.player pause];
//    CGFloat nowX = self.collectionView.contentOffset.x;
//    int num = nowX/(SCREEN_WIDTH+20);
//    id objc = self.videoAndPhotoArr[num];
//    if (![objc isKindOfClass:[MLPhotoBrowserPhoto class]]) {
//        if (num != self.videoAndPhotoArr.count-1 && num != 0) {
//           [_videoController.player pause];
//        }
//    }
}
-(void)setPageLabelPage:(NSInteger)page{
//    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %d",((page + 1)>self.videoAndPhotoArr.count)?page:page+1, (int)self.videoAndPhotoArr.count];
}
#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoAndPhotoArr.count+1;//self.videoAndPhotoArr.count
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    for (UIView* view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.row == self.videoAndPhotoArr.count) {
        return cell ;
    }
     NSLog(@"%ld",(long)indexPath.item);
    
    
    self.clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickBtn.frame = CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.clickBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(clickBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    
    self.videoItem = [[SDDemoItemView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.videoItem.center = self.clickBtn.center;
    self.videoItem.progressViewClass = [SDLoopProgressView class];
    self.videoItem.hidden = YES;
    
    if (self.videoAndPhotoArr.count)
    {
        BOOL isRight = NO;
        CGFloat nowX = self.collectionView.contentOffset.x/(SCREEN_WIDTH+20);
        int nowx = self.collectionView.contentOffset.x/(SCREEN_WIDTH+20);
        if (nowX > nowx) {
            isRight = YES;
        }
        else if (nowX < nowx)
        {
            isRight = NO;
        }
        
        id objc = self.videoAndPhotoArr[indexPath.item];
        NSLog(@"%ld",(long)indexPath.item);
        
        if ([objc isKindOfClass:[MLPhotoBrowserPhoto class]])//图片
        {
            [_videoController.player pause];
            MLPhotoBrowserPhoto *photo = self.videoAndPhotoArr[indexPath.item];
            if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
                [[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            UIView *scrollBoxView = [[UIView alloc] init];
            scrollBoxView.frame = cell.bounds;
            
            if (indexPath.row == self.firstPage) {
                scrollBoxView.ml_y = cell.ml_y + 23;
            } else {
                scrollBoxView.ml_y = cell.ml_y;
            }
            
            [cell.contentView addSubview:scrollBoxView];
            MLPhotoBrowserPhotoScrollView *scrollView =  [[MLPhotoBrowserPhotoScrollView alloc] init];
            scrollView.backgroundColor = [UIColor clearColor];
            // 为了监听单击photoView事件
            scrollView.frame = [UIScreen mainScreen].bounds;
            scrollView.photoScrollViewDelegate = self;
            if (indexPath.row == self.firstPage) {
                scrollView.photo = nil;
                self.firstPage = -1;
            }
            else
            {
                   scrollView.photo = photo;
            }
            [scrollBoxView addSubview:scrollView];
            scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        else//视频
        {
            if (!self.isNeedPlay && !self.isFirst) {
                self.isFirst = NO;
                return cell;
            }
            self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH/4*3)/2, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
            self.backView.userInteractionEnabled = YES;
            [cell.contentView addSubview:self.backView];
            [cell.contentView addSubview:self.clickBtn];
            [cell.contentView addSubview:self.videoItem];
            
            BOOL isOrNot = [self isExitOrNot:self.videoAndPhotoArr[indexPath.row]];
            if (!isOrNot)//本地中没有下载，需要下载
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage * image = [self imageWithVideo:[NSURL URLWithString:self.videoAndPhotoArr[indexPath.row]]];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                          [self.backView setImage:image];
                        });
                        
                    }
                });
                NSString * string = self.videoAndPhotoArr[indexPath.row];
                NSArray * array = [string componentsSeparatedByString:@":"];
                //网络不好时本地中没有连接，点击播放本地的数据
                if (![array[0] isEqualToString:@"http"]) {
                    self.clickBtn.hidden = YES;
                    NSString * videoPath = self.videoAndPhotoArr[indexPath.row];
                    [self.videoController.playerLayer removeFromSuperlayer];
                    self.videoController = [LewVideoController videoWithContentFiled:videoPath];
                    self.videoController.playerLayer.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/4*3);
                    self.videoController.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    [self.backView.layer addSublayer:self.videoController.playerLayer];
                }
                else
                {
                    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     [self.backView setImage:[self imageWithVideo:[NSURL URLWithString:self.videoAndPhotoArr[indexPath.row]]]];
                    });
                    self.clickBtn.hidden = NO;
                }
            }
            else//本地有直接播放
            {
                    NSString * videoPath = [self getVideoPath:self.videoAndPhotoArr[indexPath.row]];
                    self.clickBtn.hidden = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.videoController = [LewVideoController videoWithContentFiled:videoPath];
                    self.videoController.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    self.videoController.playerLayer.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/4*3);
                    [self.backView.layer addSublayer:self.videoController.playerLayer];
                    });
            }

//            BOOL isOrNot = [self isExitOrNot:self.videoAndPhotoArr[indexPath.row]];
//            if (!isOrNot)//本地中没有下载，需要下载
//            {
//                [[ZacharyPlayManager sharedInstance] cancelAllVideo];
//                [self.backView setImage:[self imageWithVideo:[NSURL URLWithString:self.videoAndPhotoArr[indexPath.row]]]];
//                self.clickBtn.hidden = NO;
//            }
//            else//本地有直接播放
//            {
//                self.clickBtn.hidden = YES;
//               [self getContentStr:self.videoAndPhotoArr[indexPath.row]];
//            }
//
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickVideo)];
            [self.backView addGestureRecognizer:tap];
            
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
            [self.backView addGestureRecognizer:longPress];
      }
    }
    return cell;
}
-(void)longPressView:(UIGestureRecognizer*)gesture
{
    [self.videoController.player pause];
    if(gesture.state == UIGestureRecognizerStateBegan){
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给好友",@"收藏", nil];
        [sheet show];
    }
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.videoController.player pause];
    if (buttonIndex == 1) {//转发
//        self.navigationController.navigationBar.hidden = NO;
        NSDictionary * dic = @{@"url":self.videoAndPhotoArr[self.currentPage]};
//        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPSetMessageType upLoadVideo:self.videoAndPhotoArr[self.currentPage] success:^(NSString *video) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
            NSArray * array = [video componentsSeparatedByString:@","];
            self.navigationController.navigationBar.hidden = NO;
           [self tranmitMessage:array[0] andMessageType:DDMEssageLitterVideo andToUserId:@""];
        } failed:^(NSError *eror) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD createHUD:@"视频上传失败" View:self.view];
                [self.videoController.player play];
            });
            
        }];
    }
    else if (buttonIndex == 2)//收藏
    {
        CollectViewController *collect = [[CollectViewController alloc] init];
        self.navigationController.navigationBarHidden = NO;
        collect.collect_class = @"2";
        collect.user_id = @"";
        collect.content = @"";
        collect.img_url = @"";
        collect.vd_url = self.videoAndPhotoArr[self.currentPage];
        collect.jobid = @"";
        collect.url = @"";
        collect.isComeDetail = NO;
        //        collect.isFromChat = YES;
        [self.navigationController pushViewController:collect animated:YES];
    }
    else
    {
    }
}
#pragma mark 点击进行下载操作
-(void)clickBtnDown:(UIButton*)sender
{
    sender.hidden = YES;
    self.videoItem.hidden = NO;
    NSInteger inter = (self.currentPage == self.videoAndPhotoArr.count)?self.currentPage-1:self.currentPage;
    id obj = self.videoAndPhotoArr[inter];
    if ([obj isKindOfClass:[NSString class]])//下载视频
    {
        NSString * string = (NSString*)obj;
        [self downLoadVideo:string success:^(id response) {
            NSArray *specialUrlArr = [string componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
            NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            self.filePath = fileName1;
            [self reloadStart];
        } failed:^(NSError *error) {
        } progress:^(NSProgress *progreee) {
        }];
    }
    else//下载图片
    {
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"])
    {
        NSProgress * pro = (NSProgress*)object;
        NSString * progre = [NSString stringWithFormat:@"%.2f",pro.fractionCompleted];
        [self performSelectorOnMainThread:@selector(showProgress:) withObject:progre waitUntilDone:NO];
    }
}
-(void)showProgress:(NSString*)objc
{
    self.videoItem.progressView.progress = objc.floatValue;
}
-(void)downLoadVideo:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed progress:(void(^)(NSProgress*progreee))progress
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    //        [self downloadFileURL:path savePath:savePath fileName:fileName tag:1];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName1]) {
        return;
    }
    //<1>获取下载的文件的路径
    NSString * string = filePath;
    //<2>如果下载的文件路径中存在中文 不能转换成NSURL 所以必须转码
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //<3>将字符串网址转化成NSURL
    NSURL * url = [NSURL URLWithString:string];
    //<4>封装成请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //<5>创建下载管理者对象
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //参数是监控进度的变化 也就是KVO
    NSProgress * tempProgress = nil;
    //<6>创建下载任务
    /*
     1、请求对象的指针
     2、下载进度的对象指针
     3、下载的文件的存放的路径
     */
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:&tempProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSData * data = [NSData dataWithContentsOfURL:targetPath];
        [data writeToFile:fileName1 atomically:YES];
        if (data)
        {
            if (success) {
                success(data);
            }
        }
        else
        {
            NSError * error =  nil;
            if (failed) {
                failed(error);
            }
        }
        return targetPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",error.description);
    }];
    videoprogress = tempProgress;
    //    NSLog(@"下载：%f",videoProgress.fractionCompleted);
    //<8>开始下载
    [task resume];
    [videoprogress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
}
- (UIImage *)imageWithVideo:(NSURL *)vidoURL

{
    // 根据视频的URL创建AVURLAsset
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidoURL options:nil];
    // 根据AVURLAsset创建AVAssetImageGenerator对象
    AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset: asset];
    gen.appliesPreferredTrackTransform = YES;
    // 定义获取0帧处的视频截图
    CMTime time = CMTimeMake(0, 10);
    NSError *error = nil;
    CMTime actualTime;
    // 获取time处的视频截图
    CGImageRef  image = [gen  copyCGImageAtTime: time actualTime: &actualTime error:&error];
    // 将CGImageRef转换为UIImage
    UIImage *thumb = [[UIImage alloc] initWithCGImage: image];
    CGImageRelease(image);
    return  thumb;
}
-(BOOL)isExitOrNot:(NSString*)urlStr
{
    NSArray *specialUrlArr = [urlStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSFileManager * manger = [NSFileManager defaultManager];
   return [manger fileExistsAtPath:fileName1];
}
-(void)clickVideo
{
    
//    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
    [_videoController.player pause];
    [_videoController.playerLayer removeFromSuperlayer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPicture" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(NSString*)getVideoPath:(NSString*)videoStr
{
    NSArray *specialUrlArr = [videoStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    return fileName1;
}
-(void)getContentStr:(NSString*)string
{
    NSArray *specialUrlArr = [string componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    
    self.filePath = fileName1;
    [self reloadStart];
}
-(void)reloadStart
{
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance]startWithLocalPath:self.filePath WithVideoBlock:^(CGImageRef imageData, NSString *filePath) {
        if ([filePath isEqualToString:weakSelf.filePath]) {
            self.backView.layer.contents=(__bridge id _Nullable)(imageData);
        }
    }];
    
    [[ZacharyPlayManager sharedInstance]reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:weakSelf.filePath]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:self.filePath];
}
#pragma mark 单机图片时调用
- (void) pickerPhotoScrollViewDidSingleClick:(MLPhotoBrowserPhotoScrollView *)photoScrollView
{
    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPicture" object:nil];
    NSLog(@"%lu",(unsigned long)self.currentPage);
    if (self.currentPage)
    {
        int i = 1;
        while (i) {
            id obj = self.videoAndPhotoArr[(self.currentPage==self.videoAndPhotoArr.count)?(self.currentPage-1):self.currentPage];
            if (![obj isKindOfClass:[NSString class]]) {
                id obj = self.videoAndPhotoArr[self.firstInPage];
                if (![obj isKindOfClass:[MLPhotoBrowserPhoto class]]) {
                    [self dismissViewControllerAnimated:NO completion:^{
                    }];
                    return;
                }
                self.disMissBlock((self.currentPage==self.videoAndPhotoArr.count)?self.currentPage-1:self.currentPage);
                i = 0;
            }
            else
            {
                --self.currentPage;
            }
        }
    }
    else
    {
        self.disMissBlock(0);
    }
//    self.disMissBlock(self.currentPage-1);
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstInPage = self.firstPage;
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.currentPage*(SCREEN_WIDTH+20), 0)];
//    [self.videoAndPhotoScroller setContentOffset:CGPointMake(self.currentPage*(SCREEN_WIDTH+20), 0)];
    [self setPageLabelPage:self.currentPage];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendToFriend:) name:@"SENDIMAGETOWEIPINFRIENDS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collection:) name:@"SpecialImgCollect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(report:) name:@"SpecialImgRoport" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMainView:) name:@"loadImageSuccess" object:nil];
}
-(void)hideMainView:(NSNotification*)notification
{
    NSString * urlString = notification.object;
    if (urlString.length) {
        if (self.currentPage >= self.videoAndPhotoArr.count) {
            return;
        }
        MLPhotoBrowserPhoto *photo = self.videoAndPhotoArr[self.currentPage];
        if ([urlString isEqualToString:[NSString stringWithFormat:@"%@",photo.photoURL]]) {
            UIWindow * win = [UIApplication sharedApplication].keyWindow;
            UIView * view = (UIView*)[win viewWithTag:8765];
            view.hidden = YES;
            self.isHideOrNot = YES;
        }
    }
}
//-(void)hideMain:(UIView*)view
//{
//    view.hidden = YES;
//}
-(UIScrollView*)videoAndPhotoScroller
{
    if (!_videoAndPhotoScroller) {
        _videoAndPhotoScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH+20, SCREEN_HEIGHT)];
        _videoAndPhotoScroller.delegate = self;
        _videoAndPhotoScroller.bounces = NO;
        _videoAndPhotoScroller.contentSize = CGSizeMake(self.videoAndPhotoArr.count*(SCREEN_WIDTH+20), SCREEN_HEIGHT);
        [self.view addSubview:_videoAndPhotoScroller];
    }
    return _videoAndPhotoScroller;
}
-(NSString*)getOriginalStr:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
    NSArray * array = [string componentsSeparatedByString:@"_"];
    string = [NSString stringWithFormat:@"%@.png",array[0]];
    return string;
}
-(void)sendToFriend:(NSNotification*)notification
{
    self.navigationController.navigationBarHidden = NO;
    NSDictionary * dictionary = (NSDictionary*)notification.userInfo;
    MLPhotoBrowserPhoto * photo = dictionary[@"info"];
    NSString * photoUrl = [NSString stringWithFormat:@"%@",photo.photoURL];
    for (NSString* string  in self.videoPhotoOriginalArr) {
        
            NSString * imageStr = [self getOriginalStr:[NSString stringWithFormat:@"%@",string]];
            if ([imageStr isEqualToString:photoUrl]) {
                photoUrl = [NSString stringWithFormat:@"%@",string];
            }
    }
    
    photoUrl = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,photoUrl];
    photoUrl = [NSString stringWithFormat:@"%@%@",photoUrl,DD_MESSAGE_IMAGE_SUFFIX];
    [self tranmitMessage:photoUrl andMessageType:DDMessageTypeImage andToUserId:@""];
}
-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId
{//DDMessageTypeText
    
    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    person.fromChatNotCreat = self.fromChatNotCreat;
    person.dataSource = muarray;
    person.toUserId = userId;
    person.transStr = messageContent;
    switch (type) {
        case DDMessageTypeText:
            person.display_type = @"1";
            break;
        case DDMEssageMyWant:
            person.display_type = @"9";
            break;
        case DDMEssageMyApply:
            person.display_type = @"8";
            break;
        case DDMEssageSHuoShuo:
            person.display_type = @"11";
            break;
        case DDMessageTypeImage:
            person.display_type = @"2";
            break;
        case DDMessageTypeVoice:
            person.display_type = @"3";
            break;
        case DDMEssageMuchMyWantAndApply:
            person.display_type = @"10";
            break;
        case DDMEssageEmotion:
            person.display_type = @"1";
            break;
        case DDMEssagePersonalaCard:
            person.display_type = @"6";
            break;
        case DDMEssageLitterVideo:
            person.display_type = @"7";
            break;
        case DDMEssageLitterInviteAndApply:
            person.display_type = @"12";
            break;
        case DDMEssageLitteralbume:
            person.display_type = @"13";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
-(void)collection:(NSNotification*)notification
{
    MLPhotoBrowserPhoto *photo = notification.userInfo[@"info"];
    NSString *subStr = [photo.photoURL.absoluteString substringFromIndex:IPADDRESS.length];
    //    NSLog(@"%@----%@",photo.sid,subStr);
    CollectViewController *collect = [[CollectViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    collect.user_id = photo.user_id;
    collect.img_url = subStr;
    collect.collect_class = @"1";
//    collect.isFromChat = YES;
    [self.navigationController pushViewController:collect animated:YES];
}
-(void)report:(NSNotification*)notification
{
    MLPhotoBrowserPhoto *photo = notification.userInfo[@"info"];
    ReportViewController *collect = [[ReportViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    collect.speak_trends_id = photo.sid;
    collect.type = ReportTypeDynamice;
    [self.navigationController pushViewController:collect animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showPhotoVideo:(UIViewController*)vc
{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
        [CATransaction begin];
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        transition.duration=0.3;
        transition.fillMode=kCAFillModeBoth;
        transition.removedOnCompletion=YES;
        [[UIApplication sharedApplication] .keyWindow.layer addAnimation:transition forKey:@"transition"];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [CATransaction setCompletionBlock: ^ {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        }];
        [weakVc presentViewController:nav animated:NO completion:nil];
        [CATransaction commit];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.collectionView reloadData];
    self.navigationController.navigationBar.hidden = YES;
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNeedShow)
    {
       [self showToView];
        self.isNeedShow = NO;
    } 
}
-(void)tapMainView:(UITapGestureRecognizer*)gesture
{
    id objc = self.videoAndPhotoArr[self.currentPage];
    if ([objc isKindOfClass:[NSString class]]) {
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        return;
    }
    self.disMissBlock(self.currentPage);
}
- (void)showToView{
    
    id obj = self.videoAndPhotoArr[self.currentPage];
    if ([obj isKindOfClass:[NSString class]]) {//是视频时没有动画
        return;
    }
    
    UIView *mainView = [[UIView alloc] init];
    mainView.tag = 8765;
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame =[UIScreen mainScreen].bounds;// [UIScreen mainScreen].bounds
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    UITapGestureRecognizer * tapMainView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMainView:)];
    [mainView addGestureRecognizer:tapMainView];
    
    UIImageView *toImageView = nil;
    toImageView = (UIImageView *)[self.videoAndPhotoArr[self.currentPage] toView];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:imageView];
    mainView.clipsToBounds = YES;
    imageView.image = toImageView.image;
    CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
        imageView.frame = tempF;
    __weak typeof(self)weakSelf = self;
    self.disMissBlock = ^(NSInteger page){// 点击消失的逻辑
        mainView.hidden = NO;
        mainView.alpha = 1.0;
        CGRect originalFrame = CGRectZero;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        imageView.image = [(UIImageView *)[weakSelf.videoAndPhotoArr[page] toView] image];
        imageView.frame = [weakSelf setMaxMinZoomScalesForCurrentBounds:imageView];
        
        UIImageView *toImageView2 = nil;
        toImageView2 = (UIImageView *)[weakSelf.videoAndPhotoArr[page] toView];
        originalFrame = [toImageView2.superview convertRect:toImageView2.frame toView:[weakSelf getParsentView:toImageView2]];

        [UIView animateWithDuration:0.3 animations:^{//消失时候的动画
        mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        imageView.frame = originalFrame;
        } completion:^(BOOL finished) {
            imageView.alpha = 1.0;
            mainView.alpha = 1.0;
            [mainView removeFromSuperview];
            [imageView removeFromSuperview];
        }];
    };
   
    self.dsimssMain = ^(NSInteger page){
        if (mainView) {
            if (!mainView.hidden) {
                mainView.hidden = YES;
            }
        }
    };
    
    NSLog(@"%f======%f",imageView.size.width,imageView.size.height);
//     [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    [UIView animateWithDuration:0.3 animations:^{
    imageView.frame = [self setMaxMinZoomScalesForCurrentBounds:imageView];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

//-(void)hideMainView:(id)obj
//{
//    UIView* view = (UIView*)obj;
//    view.hidden = YES;
//}

- (CGRect)setMaxMinZoomScalesForCurrentBounds:(UIImageView *)imageView{
    if (!([imageView isKindOfClass:[UIImageView class]]) || imageView.image == nil) {
        if (!([imageView isKindOfClass:[UIImageView class]])) {
            return imageView.frame;
        }
    }
    self.currentStr = [self.currentStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
    NSArray * array = [self.currentStr componentsSeparatedByString:@"_"];
    NSString * widthStr = [NSString stringWithFormat:@"%@",array[1]];
    NSString * secondStr = array[2];
    NSArray * array1 = [secondStr componentsSeparatedByString:@"."];
    NSString * heightStr = [NSString stringWithFormat:@"%@",array1[0]];
    CGSize size;
    if (widthStr.floatValue && heightStr.floatValue) {
        size = CGSizeMake(widthStr.floatValue, heightStr.floatValue);
    }
    else//图片发送失败，本地没有网址
    {
        size = imageView.image.size;
    }
    
    // Sizes
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = size;//imageView.image.size
    if (imageSize.width == 0 && imageSize.height == 0) {
        return imageView.frame;
    }
    
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = MAX(xScale, yScale);
    // use minimum of these to allow the image to become fully visible
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    CGRect frameToCenter = CGRectZero;
    if (xScale >= yScale) {
        frameToCenter = CGRectMake(0, 0, imageSize.width * maxScale, imageSize.height * maxScale);
        
    }else {
        if (minScale >= 3) {
            minScale = 3;
        }
        frameToCenter = CGRectMake(0, 0, imageSize.width * minScale, imageSize.height * minScale);
    }
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
