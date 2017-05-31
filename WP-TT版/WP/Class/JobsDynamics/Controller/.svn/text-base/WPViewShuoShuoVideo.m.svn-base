//
//  WPViewShuoShuoVideo.m
//  WP
//
//  Created by CC on 16/11/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPViewShuoShuoVideo.h"
#import "ZacharyPlayManager.h"
#import "HJCActionSheet.h"
#import "CollectViewController.h"
#import "MTTMessageEntity.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "WPNavigationController.h"
#import "LewVideoController.h"
#define shuoShuoVideo @"/shuoShuoVideo"
@interface WPViewShuoShuoVideo ()<HJCActionSheetDelegate>
@property (nonatomic, strong)UIView*videoView;
@property (nonatomic, copy) NSString * fileStr;//videoController
@property (nonatomic , strong)LewVideoController *videoController;
@end

@implementation WPViewShuoShuoVideo


- (void)showPickerVc:(UIViewController *)vc{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
//        [weakVc presentViewController:nav animated:NO completion:nil];
        
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVideoView)];
    [backView addGestureRecognizer:tap];
    
    NSArray *specialUrlArr = [self.videoStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    [self.view addSubview:self.videoView];

    
    [_videoController.playerLayer removeFromSuperlayer];
    _videoController = [LewVideoController videoWithContentFiled:fileName1];
    _videoController.playerLayer.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/4*3);
    _videoController.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.videoView.layer addSublayer:_videoController.playerLayer];
    
    
    
//    [self reloadStart];
}
-(void)reloadStart
{
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance]startWithLocalPath:self.fileStr WithVideoBlock:^(CGImageRef imageData, NSString *filePath) {
        if ([filePath isEqualToString:weakSelf.fileStr]) {
            self.videoView.layer.contents=(__bridge id _Nullable)(imageData);
        }
    }];
    
    [[ZacharyPlayManager sharedInstance]reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:weakSelf.fileStr]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:self.fileStr];
}
-(UIView*)videoView
{
    if (!_videoView)
    {
        _videoView = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH/4*3)/2, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
        _videoView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVideoView)];
        [_videoView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.5;
        [_videoView addGestureRecognizer:longPress];
    }
    return _videoView;
}

-(void)longPress:(UIGestureRecognizer*)gesture
{
    [self.videoController.player pause];
    if(gesture.state == UIGestureRecognizerStateBegan){
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给好友",@"收藏", nil];
        // 2.显示出来
        [sheet show];
    }
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.navigationController.navigationBar.hidden = NO;
        NSDictionary * dic = @{@"url":self.videoStr};
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self tranmitMessage:content andMessageType:DDMEssageLitterVideo andToUserId:@""];
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
//        collect.isFromChat = YES;
        [self.navigationController pushViewController:collect animated:YES];
    }
    else
    {
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
}
-(void)tapVideoView
{
    [self.videoController.player pause];
    
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
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    [CATransaction commit];
//    [self.navigationController.view removeFromSuperview];
//    [self.navigationController removeFromParentViewController];
}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    [window addSubview:nav.view];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [window.rootViewController addChildViewController:nav];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.videoController.player play];
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
//-(void)viewWillDisappear:(BOOL)animated
//{
////    self.navigationController.navigationBarHidden = NO;
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
