//
//  DBTakeVideoVC.m
//  CustomVideoCapture
//
//  Created by dengbin on 15/1/15.
//  Copyright (c) 2015年 IUAIJIA. All rights reserved.
//

#import "DBTakeVideoVC.h"

#import <MediaPlayer/MediaPlayer.h>
#import "CTAssetsPickerController.h"
#import "WPJobViewController.h"
#import "WriteViewController.h"


#define MAX_VIDEO_DUR    10
#define COUNT_DUR_TIMER_INTERVAL  0.025
#define VIDEO_FOLDER    @"videos"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)


@interface DBTakeVideoVC ()<UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UIAlertViewDelegate>
{
    
    NSURL *_finashURL;
//    MPMoviePlayerController *_player;

    float   _float_totalDur;
    float   _float_currentDur;
    float   _play_total;
}
@property(nonatomic,strong)AVCaptureSession      *captureSession;
@property(nonatomic,strong)AVCaptureDeviceInput  *videoDeviceInput;
@property(nonatomic,strong)AVCaptureMovieFileOutput *movieFileOutput;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preViewLayer;//相机拍摄预览图层
@property(nonatomic,strong)UIView          *preview;
@property(nonatomic,strong)UIProgressView  *progressView;
@property(nonatomic,strong)NSTimer     *timer;
@property(nonatomic,strong)NSMutableArray     *files;
@property(nonatomic,strong)UIButton *recordBtn;//开始录制
@property(nonatomic,strong)UIButton *lead;     //导入
@property(nonatomic,strong)UIButton *dustbion; //删除
@property(nonatomic,strong)UIButton *start;    //开始
@property(nonatomic,strong)UIButton *stop;     //暂停
@property(nonatomic,strong)UIButton *delete;   //删除
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem2;
@property(nonatomic,strong) AVPlayerLayer *playerLayer;
@property(nonatomic,assign) CGFloat curProgress;
@property(nonatomic,strong) NSMutableArray *assets;
@property(nonatomic,strong) UIButton *rightBtn;  //导航栏右按钮
@property(nonatomic,strong) UIButton *leftBtn;   //导航栏左按钮
@property(nonatomic,strong) UIButton *titleView;     //标题相机
@property(nonatomic,strong) NSString *filePath;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) UIActivityIndicatorView *activity;

@property(nonatomic,unsafe_unretained)BOOL      isCameraSupported;
@property(nonatomic,unsafe_unretained)BOOL      isTorchSupported;
@property(nonatomic,unsafe_unretained)BOOL      isFrontCameraSupported;
@property(nonatomic,unsafe_unretained)BOOL      isPlay;
@property(nonatomic,unsafe_unretained)BOOL      isSkip;   //是否主动跳转到发布界面

@end

@implementation DBTakeVideoVC

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPlay = NO;
    self.isPlay = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self initNav];
    //创建视频存储目录
    [[self class] createVideoFolderIfNotExist];


    //用来存储视频路径 以便合成时使用
    self.files=[NSMutableArray array];
    
    //创建视频捕捉窗口
    [self initCapture];
    
    //创建视频播放
    [self initPlayer];
    
    //创建录像按钮
    [self initRecordButton];
    
    // Do any additional setup after loading the view.
}
- (void)initNav
{
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"small_backgound"] forBarMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
//    item1.tag = 1;
//    [item1 setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = item1;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 40, 64);
    [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _rightBtn.userInteractionEnabled = NO;
    _rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonClick)];
//    [item2 setTintColor:[UIColor whiteColor]];
//    item1.tag = 2;
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 40, 64);
    [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_leftBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    
    _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleView.frame = CGRectMake(0, 0, 27, 22);
    [_titleView setImage:[UIImage imageNamed:@"反拍"] forState:UIControlStateNormal];
    [_titleView setImage:[UIImage imageNamed:@"反拍点击效果"] forState:UIControlStateSelected];
    [_titleView addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleView;
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
}

- (void)rightBarButtonClick{
    NSLog(@"完成");
    [self.player pause];
    [self stopPlayTimer];
    UISaveVideoAtPathToSavedPhotosAlbum(self.filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    [self.takeVideoDelegate tackVideoBackWith:self.filePath andLength:self.time];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)leftBarButtonClick{
    NSLog(@"取消");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否取消录制?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    } else {
        [self.player pause];
        [self stopPlayTimer];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

//调前后摄像头
- (void)titleClick{
    NSLog(@"相机反转");
    AVCaptureDevice *currentDevice=[self.videoDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront)
    {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.videoDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput])
    {
        [self.captureSession addInput:toChangeDeviceInput];
        self.videoDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];

}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras)
    {
        if ([camera position]==position)
        {
            return camera;
        }
    }
    return nil;
}


-(void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetLow];

    
    AVCaptureDevice *frontCamera = nil;
    AVCaptureDevice *backCamera = nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == AVCaptureDevicePositionFront) {
            frontCamera = camera;
        } else {
            backCamera = camera;
        }
    }
    
    if (!backCamera) {
        self.isCameraSupported = NO;
        return;
    } else {
        self.isCameraSupported = YES;
        
        if ([backCamera hasTorch]) {
            self.isTorchSupported = YES;
        } else {
            self.isTorchSupported = NO;
        }
    }
    
    if (!frontCamera) {
        self.isFrontCameraSupported = NO;
    } else {
        self.isFrontCameraSupported = YES;
    }
    
    
    [backCamera lockForConfiguration:nil];
    if ([backCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [backCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    
    [backCamera unlockForConfiguration];
    
    self.videoDeviceInput =  [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    
    AVCaptureDeviceInput *audioDeviceInput =[AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
    
    [_captureSession addInput:_videoDeviceInput];
    [_captureSession addInput:audioDeviceInput];
    
    
    //output
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [_captureSession addOutput:_movieFileOutput];
    
    //preset
    _captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    //preview layer------------------
    self.preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_captureSession startRunning];
    
    
    
    self.preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + 6)];
    _preview.clipsToBounds = YES;
    [self.view addSubview:self.preview];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 6)];
    self.progressView.progress=0;
    [self.preview addSubview:self.progressView];
    
    
    self.preViewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.preview.layer addSublayer:self.preViewLayer];

}

-(void)initPlayer
{
    
    AVURLAsset *movieAsset    = [[AVURLAsset alloc]initWithURL:_finashURL options:nil];
    
    
    self.playerItem2 = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    [self.playerItem2 addObserver:self forKeyPath:@"status" options:0 context:NULL];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem2];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.preview.layer addSublayer:_playerLayer];
//    _playerLayer.hidden = YES;
    
    [self.player setAllowsExternalPlayback:YES];
    
}


-(void)initRecordButton
{
    CGFloat y = (SCREEN_HEIGHT - 70 - SCREEN_WIDTH - 67)/2 + SCREEN_WIDTH + 70 - 64;
    CGFloat width  = (SCREEN_WIDTH - 67)/2;
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordBtn.frame  = CGRectMake((SCREEN_WIDTH - 67)/2, y, 67, 67);
    [_recordBtn setImage:[UIImage imageNamed:@"录制"] forState:UIControlStateNormal];
    [_recordBtn setImage:[UIImage imageNamed:@"录制点击效果"] forState:UIControlStateSelected];
    _recordBtn.selected = NO;
    [_recordBtn addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordBtn];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity.center = CGPointMake(SCREEN_WIDTH/2, y + 67/2);
    
    [self.view addSubview:self.activity];
//    [self.activity startAnimating];
    [self.activity setHidesWhenStopped:YES];
    
    self.lead = [UIButton buttonWithType:UIButtonTypeCustom];
    _lead.frame = CGRectMake(0,y, width, 67);
    [_lead setImageEdgeInsets:UIEdgeInsetsMake(10, (width - 35)/2, 31, (width - 35)/2)];
    [_lead setTitleEdgeInsets:UIEdgeInsetsMake(46, -25, 6, 10)];
    [_lead setTitle:@"导入视频" forState:UIControlStateNormal];
    _lead.titleLabel.font = [UIFont systemFontOfSize:12];
    [_lead setImage:[UIImage imageNamed:@"视频2"] forState:UIControlStateNormal];
    [_lead setImage:[UIImage imageNamed:@"视频点击效果"] forState:UIControlStateHighlighted];
    [_lead addTarget:self action:@selector(leadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lead];
    
    self.delete = [UIButton buttonWithType:UIButtonTypeCustom];
    _delete.frame = CGRectMake(0, y, width, 67);
    [_delete setImage:[UIImage imageNamed:@"删除2"] forState:UIControlStateNormal];
    [_delete setImage:[UIImage imageNamed:@"删除点击效果"] forState:UIControlStateSelected];
    [_delete setImageEdgeInsets:UIEdgeInsetsMake(16, (width - 34)/2, 17, (width - 34)/2)];
    _delete.hidden = YES;
    [_delete addTarget:self action:@selector(deleteVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_delete];
    
    self.start = [UIButton buttonWithType:UIButtonTypeCustom];
    _start.frame = CGRectMake(width + 67, y, width, 67);
    [_start setImage:[UIImage imageNamed:@"播放点击效果"] forState:UIControlStateNormal];
//    [_start setImage:[UIImage imageNamed:@"播放点击效果"] forState:UIControlStateHighlighted];
    _start.userInteractionEnabled = NO;
    [_start setImageEdgeInsets:UIEdgeInsetsMake(16, (width - 34)/2, 17, (width - 34)/2)];
    [_start addTarget:self action:@selector(startPlayVideo) forControlEvents:UIControlEventTouchUpInside];
    _start.hidden = YES;
    [self.view addSubview:_start];
    
    self.stop = [UIButton buttonWithType:UIButtonTypeCustom];
    _stop.frame = CGRectMake(width + 67, y, width, 67);
    [_stop setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [_stop setImage:[UIImage imageNamed:@"暂停点击"] forState:UIControlStateHighlighted];
    [_stop setImageEdgeInsets:UIEdgeInsetsMake(16, (width - 34)/2, 17, (width - 34)/2)];
    [_stop addTarget:self action:@selector(stopPlayVideo) forControlEvents:UIControlEventTouchUpInside];
    _stop.hidden = YES;
    [self.view addSubview:_stop];
    
}

//导入视频
- (void)leadVideo
{
    NSLog(@"导入视频");
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    if (self.fileCount) {
        picker.maximumNumberOfSelection = _fileCount;
    }else{
       picker.maximumNumberOfSelection = 1;
    }
    
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets: %@",assets);
    [self performSelector:@selector(finishSelectVideoWith:) withObject:assets afterDelay:0.8];
}

- (void)finishSelectVideoWith:(NSArray *)assets
{
    [self.delegate sendBackVideoWith:assets];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//删除视频按钮
- (void)deleteVideo
{
    NSLog(@"删除视频");
    [self.files removeAllObjects];
    [_start setImage:[UIImage imageNamed:@"播放点击效果"] forState:UIControlStateNormal];
    _start.userInteractionEnabled = NO;
    _start.hidden = YES;
    _lead.hidden = NO;
    _delete.hidden = YES;
    [_rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _rightBtn.userInteractionEnabled = NO;
    self.progressView.progress = 0;
    _float_totalDur = 0;

}

//开始播放视频
- (void)startPlayVideo
{
    //播放结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerItem2];
    NSLog(@"开始播放视频");
    [self initPlayer];
    self.preViewLayer.hidden = YES;
    self.playerLayer.hidden = NO;
    self.recordBtn.selected = YES;
    self.recordBtn.userInteractionEnabled = NO;
    self.delete.selected = YES;
    self.delete.userInteractionEnabled = NO;
    _start.hidden = YES;
    _stop.hidden = NO;
    _titleView.selected = YES;
    _titleView.userInteractionEnabled = NO;
    [self.player play];
//    [SVProgressHUD showWithStatus:@"请稍等..."];
//    [self mergeAndExportVideosAtFileURLs:self.files];
}

//暂停播放
- (void)stopPlayVideo
{
    NSLog(@"暂停视频");
    [self.player pause];
    self.preViewLayer.hidden = NO;
    self.playerLayer.hidden = YES;
    self.playerLayer = nil;
    self.player = nil;
    [self stopPlayTimer];
    _stop.hidden = YES;
    _start.hidden = NO;
    self.recordBtn.selected = NO;
    self.recordBtn.userInteractionEnabled = YES;
    self.delete.selected = NO;
    self.delete.userInteractionEnabled = YES;
    _titleView.selected = NO;
    _titleView.userInteractionEnabled = YES;
    
}

-(void)play
{
//    DBPlayVideoVC *playVideoVC=[[DBPlayVideoVC alloc]init];
//    playVideoVC.fileURL=_finashURL;
////    [self.navigationController pushViewController:playVideoVC animated:YES];
//    [self.navigationController presentViewController:playVideoVC animated:YES completion:nil];
    
//        _player  = [[MPMoviePlayerController alloc] initWithContentURL:_finashURL];
//    
//        _player.scalingMode = MPMovieScalingModeAspectFit;
//    
//        [self.view addSubview:_player.view];
//    
//        [_player setFullscreen:YES animated:YES];
//        [_player prepareToPlay];
//        
//        [_player play];
    
    
    
}

#pragma mark - BtnClick

-(void)touchUp
{
     _lead.hidden = YES;
    _delete.hidden = NO;
    if (self.recordBtn.isSelected == YES) {
//        self.recordBtn.selected = NO;
        [self.activity startAnimating];
        self.recordBtn.userInteractionEnabled = NO;
        [_movieFileOutput stopRecording];
//        [_start setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
//        _start.userInteractionEnabled = YES;
//        _delete.selected = NO;
//        _delete.userInteractionEnabled = YES;
        [self stopCountDurTimer];
//        NSLog(@"######%@",self.files);
//        [SVProgressHUD showWithStatus:@"请稍等..."];
//        [self mergeAndExportVideosAtFileURLs:self.files];
//        [self mergeAndExportVideosAtFileURLs:self.files];
        [self performSelector:@selector(sureBtnClick) withObject:self afterDelay:1.5];
    } else {
        self.recordBtn.selected = YES;
        NSURL *fileURL = [NSURL fileURLWithPath:[[self class] getVideoSaveFilePathString]];
        [self.files addObject:fileURL];
//        NSLog(@"*****%@",self.files);
        [_start setImage:[UIImage imageNamed:@"播放点击效果"] forState:UIControlStateNormal];
        _start.userInteractionEnabled = NO;
        _delete.selected = YES;
        _delete.userInteractionEnabled = NO;
        _titleView.selected = YES;
        _titleView.userInteractionEnabled = NO;
        self.rightBtn.userInteractionEnabled = NO;
        _leftBtn.userInteractionEnabled = NO;
        [_movieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    }
//    if (self.isPlay) {
//        [SVProgressHUD showWithStatus:@"请稍等..."];
//        [self mergeAndExportVideosAtFileURLs:self.files];
//        return;
//    }
//    
//    self.isPlay = YES;

}
-(void)sureBtnClick
{
    
//    [SVProgressHUD showWithStatus:@"请稍等..."];
    [self mergeAndExportVideosAtFileURLs:self.files];
    
}
-(void)longTouch
{
    
}

#pragma mark - 获取视频大小及时长

//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path])
    {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}
//此方法可以获取视频文件的时长
- (CGFloat) getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

#pragma mark - 创建视频目录及文件


+ (NSString *)getVideoSaveFilePathString
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  //  NSString *path = [paths objectAtIndex:0];
    
    NSString *path =[NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];

    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    return fileName;
    
}

+ (BOOL)createVideoFolderIfNotExist
{
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *path =[NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];

    //[paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建图片文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}



#pragma mark - 加载视频完成
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (AVPlayerItemStatusReadyToPlay == self.player.currentItem.status)
        {
            // [self.player play];
            
            
            NSLog(@"准备播放");
            self.progressView.progress=0;
            [self startPlayTimer];
//            [self startCountDurTimer];
            //            NSLog(@"%lf",[self playableDuration]);
            //            [UIView animateWithDuration:[self playableDuration] animations:^{
            //
            //            }];
            
        }
    }
}

#pragma mark - 播放结束时
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    // Loop the video
    NSLog(@"播放完成");
    self.preViewLayer.hidden = NO;
    self.playerLayer.hidden = YES;
    self.playerLayer = nil;
    self.player = nil;
    _start.hidden = NO;
    _stop.hidden = YES;
    self.recordBtn.selected = NO;
    self.recordBtn.userInteractionEnabled = YES;
    self.delete.selected = NO;
    self.delete.userInteractionEnabled = YES;
    _titleView.selected = NO;
    _titleView.userInteractionEnabled = YES;
//    [self endPlay];//播放停止
    
    //        [self.player play];
    //    }else {
    //        mPlayer.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    //    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 合成文件
- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray
{
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    CMTime totalDuration = kCMTimeZero;
    
    //先去assetTrack 也为了取renderSize
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    
    
    for (NSURL *fileURL in fileURLArray)
    {
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        
        if (!asset) {
            continue;
        }
        NSLog(@"%@---%@",asset.tracks,[asset tracksWithMediaType:@"vide"]);
        
        [assetArray addObject:asset];
        
        
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:@"vide"] objectAtIndex:0];
        
        [assetTrackArray addObject:assetTrack];
        
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    }
    
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        //fix orientationissue
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        //data
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    //get save path
    NSString *filePath = [[self class] getVideoMergeFilePathString];
    
    NSURL *mergeFileURL = [NSURL fileURLWithPath:filePath];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _finashURL=mergeFileURL;
//            [SVProgressHUD dismiss];
//            [self initPlayer];
//
//            [self.player play];
                [_start setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
                _start.userInteractionEnabled = YES;
                _delete.selected = NO;
                _delete.userInteractionEnabled = YES;
            _recordBtn.selected = NO;
            _recordBtn.userInteractionEnabled = YES;
            [self.activity stopAnimating];
            _titleView.selected = NO;
            _titleView.userInteractionEnabled = YES;
            _leftBtn.userInteractionEnabled = YES;
            _rightBtn.userInteractionEnabled = YES;
//            [self play];
            //保存到相册
//            NSLog(@"******%@-------%@",filePath,_finashURL);
//            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            CGFloat time = [self getVideoLength:_finashURL];
            NSString *videoTime = [NSString stringWithFormat:@"%f",time];
            self.time = videoTime;
            self.filePath = filePath;
            if (self.isSkip) { //当时间拍完之后直接跳转
                [self rightBarButtonClick];
            }
            //            if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishMergingVideosToOutPutFileAtURL:)]) {
            //                [_delegate videoRecorder:self didFinishMergingVideosToOutPutFileAtURL:mergeFileURL];
            //            }
        });
    }];
}

+ (NSString *)getVideoMergeFilePathString
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSLog(@"",);
    NSString *path =[NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    // [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}
#pragma mark - 计时器操作

- (void)startCountDurTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)startPlayTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL target:self selector:@selector(onPlayTimer:) userInfo:nil repeats:YES];
}

- (void)onPlayTimer:(NSTimer *)timer
{
    _play_total+=COUNT_DUR_TIMER_INTERVAL;
    
    NSLog(@"%lf ----  %lf",_play_total,self.progressView.progress);
    
    self.progressView.progress = _play_total/MAX_VIDEO_DUR ;
    if (self.progressView.progress == self.curProgress) {
        [self stopPlayTimer];
    }
}

- (void)stopPlayTimer
{
    _play_total = 0;
    [self.timer invalidate];
    self.progressView.progress = self.curProgress;
    self.timer = nil;
}

- (void)onTimer:(NSTimer *)timer
{
    
    _float_totalDur+=COUNT_DUR_TIMER_INTERVAL;
    //当时长大于2秒的时候显示播放按钮
    if (_float_totalDur >= 2) {
        _start.hidden = NO;
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    }
    NSLog(@"%lf ----  %lf",_float_totalDur,self.progressView.progress);
    
    self.progressView.progress = _float_totalDur/MAX_VIDEO_DUR ;
    if(self.progressView.progress==1)
    {
        self.isSkip = YES;//在这里进行跳转到发布界面
        [self touchUp];
        self.recordBtn.userInteractionEnabled = NO;
//        [self performSelector:@selector(sureBtnClick) withObject:nil afterDelay:1];
        
    }
    
    
}
- (void)stopCountDurTimer
{
    [self.timer invalidate];
    self.curProgress = self.progressView.progress;
    self.timer = nil;
}

#pragma mark - AVCaptureFileOutputRecordignDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    [self startCountDurTimer];
    NSLog(@"didStartRecordingToOutputFileAtURL");

//    self.currentFileURL = fileURL;
//    
//    self.currentVideoDur = 0.0f;
//    [self startCountDurTimer];
//    
//    if ([_delegate respondsToSelector:@selector(videoRecorder:didStartRecordingToOutPutFileAtURL:)]) {
//        [_delegate videoRecorder:self didStartRecordingToOutPutFileAtURL:fileURL];
//    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    NSLog(@"%@",videoPath);
    
    NSLog(@"%@",error);
    
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{

    NSLog(@"didFinishRecordingToOutputFileAtURL---%lf",_float_totalDur);
//    self.totalVideoDur += _currentVideoDur;
//    NSLog(@"本段视频长度: %f", _currentVideoDur);
//    NSLog(@"现在的视频总长度: %f", _totalVideoDur);
//    
//    if (!error) {
//        SBVideoData *data = [[SBVideoData alloc] init];
//        data.duration = _currentVideoDur;
//        data.fileURL = outputFileURL;
//        
//        [_videoFileDataArray addObject:data];
//    }
//    
//    if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishRecordingToOutPutFileAtURL:duration:totalDur:error:)]) {
//        [_delegate videoRecorder:self didFinishRecordingToOutPutFileAtURL:outputFileURL duration:_currentVideoDur totalDur:_totalVideoDur error:error];
//    }
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
