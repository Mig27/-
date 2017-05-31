//
//  VideoBrowser.m
//  WP
//
//  Created by 沈亮亮 on 15/7/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "VideoBrowser.h"
#import "LewVideoController.h"
#import "HJCActionSheet.h"
#import "CollectViewController.h"
#import "ReportViewController.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "MTTMessageEntity.h"
#import "WPDownLoadVideo.h"
#import "WPSetMessageType.h"
#define shuoShuoVideo @"/shuoShuoVideo"
@interface VideoBrowser ()<LewVideoControllerDelegate,HJCActionSheetDelegate>

@property (nonatomic, strong)LewVideoController *videoController;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, assign)BOOL needDown;

@end

@implementation VideoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    
    if (self.isNetOrNot) {
        [MBProgressHUD showMessage:@"" toView:self.view];
       _videoController = [LewVideoController videoControllerWithNetURL:[NSURL URLWithString:self.videoUrl]];
    }
    else
    {
        
      _videoController = [LewVideoController videoWithContentFiled:self.videoUrl];
    }
//    _videoController = [LewVideoController videoControllerWithNetURL:[NSURL URLWithString:self.videoUrl]];
    _videoController.isCreat = self.isCreat;
    _videoController.isNetOrNot = self.isNetOrNot;
     _videoController.delegate = self;
    _videoController.playerLayer.frame = CGRectMake(0,(SCREEN_HEIGHT - SCREEN_WIDTH/4*3)/2,SCREEN_WIDTH,SCREEN_WIDTH/4*3);
    _videoController.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_videoController.playerLayer];
    
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT + SCREEN_WIDTH)/2 + 20, SCREEN_WIDTH, 15)];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = @"轻触退出播放";
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.tipLabel];
    self.tipLabel.hidden = YES;
    
    if (!self.isCreat) {
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longTap.minimumPressDuration = 0.5;
        [self.view addGestureRecognizer:longTap];
       }
    if (self.isCreat && self.addLongPress) {
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longTap.minimumPressDuration = 0.5;
        [self.view addGestureRecognizer:longTap];
    }
    
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self.view addGestureRecognizer:singleTap];
    
    
//    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//    longTap.minimumPressDuration = 0.5;
//    [self.view addGestureRecognizer:longTap];
//    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:singleTap];
    
//    UISwipeGestureRecognizer * rightSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipVideo:)];
//    [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:rightSwip];
//    
//    UISwipeGestureRecognizer * leftSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipVideo:)];
//    [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:leftSwip];
//    
    [self videoarrayValue];
    

}
-(void)videoarrayValue
{
    for (id objc in self.allArray) {
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * message = (MTTMessageEntity*)objc;
            if (message.msgContentType == DDMEssageLitterVideo) {
                NSString * contentStr = message.msgContent;
                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dicti = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if (dicti)
                {
                    
                }
                else
                {
                    [self.videoArray addObject:[NSString stringWithFormat:@"%@%@",IPADDRESS,contentStr]];
                }
            }
        }
    }
    
    for (int i = 0; i<self.videoArray.count; i++) {
        NSString * string = self.videoArray[i];
        if ([string isEqualToString:self.videoUrl]) {
            self.currentPosition = i;
        }
    }
}
-(NSMutableArray*)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
//-(void)setAllArray:(NSArray *)allArray
//{
//    for (id objc in allArray) {
//        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
//            MTTMessageEntity * message = (MTTMessageEntity*)objc;
//            if (message.msgContentType == DDMEssageLitterVideo) {
//                NSString * contentStr = message.msgContent;
//                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary * dicti = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                if (dicti)
//                {
//                    
//                }
//                else
//                {
//                    [self.videoArray addObject:[NSString stringWithFormat:@"%@%@",IPADDRESS,contentStr]];
//                }
//            }
//        }
//    }
//}
-(void)swipVideo:(UISwipeGestureRecognizer*)gesture
{
    if (!self.videoArray.count) {
        return;
    }
    
    if (_currentPosition == 0 && gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        return;
    }
    
    if (_currentPosition == self.videoArray.count-1 && gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        return;
    }
    [_videoController cancel];
    [_videoController.playerLayer removeFromSuperlayer];
    
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        --_currentPosition;
        self.videoUrl = [NSString stringWithFormat:@"%@",self.videoArray[_currentPosition]];
        
    }
   if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        ++_currentPosition;
        self.videoUrl = [NSString stringWithFormat:@"%@",self.videoArray[_currentPosition]];
    }
    _videoController = [LewVideoController videoControllerWithNetURL:[NSURL URLWithString:self.videoUrl]];
    _videoController.delegate = self;
    _videoController.playerLayer.frame = CGRectMake(0,(SCREEN_HEIGHT - SCREEN_WIDTH/4*3)/2,SCREEN_WIDTH,SCREEN_WIDTH/4*3);
    _videoController.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_videoController.playerLayer];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self.videoController.player play];
    
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.videoController.player pause];
}
- (void)longPress:(UILongPressGestureRecognizer *)gesture{
    //    NSLog(@"长按");
    if(gesture.state == UIGestureRecognizerStateBegan){
        if (self.hideDown) {
            return;
        }
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给好友",@"收藏", nil];
        // 2.显示出来
        [sheet show];
        
    }
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
    
    //转发时将视频下载到本地
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        if (self.needDown) {
            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
            [down downLoadVideo:self.videoUrl success:^(id response) {
            } failed:^(NSError *error) {
            } progress:^(NSProgress *progreee) {
                
            }];
        }
    });
   
}

-(BOOL)isExitOrNot
{
    NSArray * pathArray = [self.videoUrl componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName1]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(NSString*)getLocalPath
{
    NSArray * pathArray = [self.videoUrl componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    return fileName1;
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.navigationController.navigationBar.hidden = NO;
        
        BOOL isOrNot = [self isExitOrNot];
        if (isOrNot)//本地中有数据需要从新上传
        {
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            [WPSetMessageType upLoadVideo:self.videoUrl success:^(NSString *video) {
                [MBProgressHUD hideHUDForView:self.view];
                NSArray * array = [video componentsSeparatedByString:@","];
                NSDictionary * dic = @{@"url":[NSString stringWithFormat:@"%@%@",IPADDRESS,array[0]]};
                NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                NSString * content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
               [self tranmitMessage:content andMessageType:DDMEssageLitterVideo andToUserId:@""];
            } failed:^(NSError *eror) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD createHUD:@"视频上传失败" View:self.view];
            }];
        }
        else
        {
            self.needDown = YES;
            NSDictionary * dic = @{@"url":self.videoUrl};
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString * content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self tranmitMessage:content andMessageType:DDMEssageLitterVideo andToUserId:@""];
        }
        
        
//        NSDictionary * dic = @{@"url":self.videoUrl};
//        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//        NSString * content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        [self tranmitMessage:content andMessageType:DDMEssageLitterVideo andToUserId:@""];
    }
    else if (buttonIndex == 2)//收藏
    {
        CollectViewController *collect = [[CollectViewController alloc] init];
        self.navigationController.navigationBarHidden = NO;
        collect.collect_class = @"2";
        collect.user_id = self.user_id;
        collect.content = @"";
        collect.img_url = self.img_url;
        collect.vd_url = self.vd_url;
        collect.jobid = @"";
        collect.url = @"";
        collect.isComeDetail = NO;
        
        [self.navigationController pushViewController:collect animated:YES];
    }
    else
    {
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
        [_videoController cancel];
//        [self.navigationController.view removeFromSuperview];
//    
//        [self.navigationController removeFromParentViewController];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    [window addSubview:nav.view];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [window.rootViewController addChildViewController:nav];
}
#pragma mark - 展示控制器
- (void)showPickerVc:(UIViewController *)vc{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
        //        [weakVc presentViewController:nav animated:NO completion:nil];
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
#pragma mark - delegate
- (void)LewVideoPlayingWithCurrentTime:(CMTime)currentTime{
    CGFloat progress = CMTimeGetSeconds(currentTime)/CMTimeGetSeconds(_videoController.videoDuration);
//        NSLog(@"1111");
//        NSLog(@"播放百分比 : %f scal:%d",progress,currentTime.timescale);
    if (progress == 1) {
        [_videoController seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
            if (finished) {
                self.tipLabel.hidden = NO;
                [_videoController play];
            }
        }];
    }
    //    _progressView.progress = progress;
}
- (void)lewVideoReadyToPlay{
    [MBProgressHUD hideHUDForView:self.view];
    [_videoController play];
}
- (void)lewVideoLoadedProgress:(CGFloat)progress{
    //    NSLog(@"视频加载进度： %@",@(progress));
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [_videoController cancel];
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
