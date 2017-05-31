//
//  shuoShuoVodeoClick.m
//  WP
//
//  Created by CC on 16/9/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "shuoShuoVodeoClick.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "WPDDChatVideo.h"
@interface shuoShuoVodeoClick ()
@property (nonatomic, strong)UIImageView * videoImage;
@property (nonatomic, strong)WPDDChatVideo * video;
@end

@implementation shuoShuoVodeoClick

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickFish)];
//    self.title = @"哈哈小视频";
}
-(void)clickFish
{
    [_video.player pause];
    NSArray * viewArray = self.navigationController.viewControllers;
    NSLog(@"%@",viewArray);
    self.takeVideoDelegate = viewArray[viewArray.count-3];
    if (self.takeVideoDelegate && [self.takeVideoDelegate respondsToSelector:@selector(tackVideoBackWith: andLength:)]) {
        [self.takeVideoDelegate tackVideoBackWith:self.filePath andLength:self.time];
    }
    [self.navigationController popToViewController:viewArray[viewArray.count-3] animated:YES];
}

-(void)creatUI
{
//    self.videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+60, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
//    self.videoImage.image = [[self class] getImage:self.filePath];;
//    [self.view addSubview:self.videoImage];
//   
//    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)];
//    [self.videoImage addGestureRecognizer:tap];
    
    _video = [WPDDChatVideo videoWithUrl:self.fileUrl];
    _video.playerLayer.frame = CGRectMake(0, 64+60,SCREEN_WIDTH,SCREEN_WIDTH/4*3);
    _video.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _video.player.volume = 5;
    [self.view.layer addSublayer:_video.playerLayer];
    
    UIButton * clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0, 60+64, SCREEN_WIDTH, SCREEN_WIDTH/4*3);
    [self.view addSubview:clickBtn];
    [clickBtn setImage:[UIImage imageNamed:@"shipin_zanting_b"] forState:UIControlStateSelected];
    [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)clickBtn:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_video.player pause];
    }
    else
    {
        [_video.player play];
    }
}

#pragma mark  获取本地视频的图片
+(UIImage *)getImage:(NSString *)videoURL

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
#pragma mark 点击图片
-(void)clickImage
{

}
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
