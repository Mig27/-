//
//  DDVideoCell.m
//  WP
//
//  Created by CC on 16/8/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DDVideoCell.h"
#import "NSDictionary+JSON.h"
#import "DDMessageSendManager.h"
#import "SessionModule.h"
#import "MTTDatabaseUtil.h"
#import "ZacharyPlayManager.h"
#define shuoShuoVideo @"/shuoShuoVideo"
#import "MTTPhotosCache.h"
#import "WPDownLoadVideo.h"
#import "DDSendPhotoMessageAPI.h"

@implementation DDVideoCell
{
    NSProgress* videoprogress;
}
@synthesize videoProgress;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHEIGHT(177), kHEIGHT(132))];//212->132
        self.backView.layer.cornerRadius = 5;
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.clipsToBounds = YES;
        self.backView.userInteractionEnabled = YES;
        self.backView.image = [UIImage imageWithName:@"shipin_shibai"];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView:)];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBack:)];
        longPress.minimumPressDuration = 0.5;
        [self.backView addGestureRecognizer:longPress];
//        [self.backView addGestureRecognizer:tap];
        [self.contentView addSubview:self.backView];
        
        
        self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.videoBtn.frame = CGRectMake(0, 0, kHEIGHT(177), kHEIGHT(132));
        [self.videoBtn addTarget:self action:@selector(clickVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
//        self.videoBtn.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.videoBtn];
        self.videoBtn.hidden = YES;
//        if (self.isMore) {
//            self.videoBtn.enabled = NO;
//            self.videoBtn.userInteractionEnabled = YES;
//        }
//        else
//        {
//            self.videoBtn.enabled = YES;
//            self.videoBtn.userInteractionEnabled = NO;
//        }
        
        
//        self.videoBtn.backgroundColor = [UIColor redColor];
//        self.videoBtn.userInteractionEnabled = NO;
      
        
//        self.videoPro = [[SDLoopProgressView alloc]init];
//        self.videoPro.center = self.videoBtn.center;
//        self.videoPro.hidden = YES;
//        [self.backView addSubview:self.videoPro];
        
        
        self.videoItem = [[SDDemoItemView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.videoItem.center = self.videoBtn.center;
        self.videoItem.progressViewClass = [SDLoopProgressView class];
        self.videoItem.hidden = YES;
//        UITapGestureRecognizer * tapVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickVideoBtn:)];
//        [self.videoItem addGestureRecognizer:tapVideo];
        [self.backView addSubview:self.videoItem];
        UITapGestureRecognizer * tapVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView:)];
        [self.bubbleImageView addGestureRecognizer:tapVideo];
        
        
//        self.downActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        self.downActivity.hidesWhenStopped = YES;
//        CGPoint center = self.backView.center;
//        self.downActivity.center = center;
//        [self.backView addSubview:self.downActivity];
    }
    return  self;
}

#pragma mark 点击播放按钮下载视频

-(void)clickVideoBtn:(id)sender
{
    UIButton * button;
    if ([sender isKindOfClass:[UIButton class]]) {
       button  = (UIButton*)sender;
        button.hidden = YES;
    }
    else
    {
        self.videoBtn.hidden = YES;
    }
    self.videoItem.hidden = NO;
    self.backView.userInteractionEnabled = NO;
    [self downLoadVideo:self.videoString success:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView:)];
            [self.backView addGestureRecognizer:tap];
            
            NSArray *specialUrlArr = [self.videoString componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
            NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            self.filePath = fileName1;
            [self reloadStart];
            
        });
        
//        NSArray *specialUrlArr = [self.videoString componentsSeparatedByString:@"/"];
//        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
//        NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
//        NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
//        self.filePath = fileName1;
//        [self reloadStart];
    } failed:^(NSError *error) {
        if ([sender isKindOfClass:[UIButton class]]) {
           button.hidden = NO;
        }
        else
        {
            self.videoBtn.hidden = NO;
        }
       
    
//        [self startAnimationAc:NO];
    } progress:^(NSProgress *progreee) {
        
    }];
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
//        NSLog(@"%@",error.description);
    }];
    videoprogress = tempProgress;
//    NSLog(@"下载：%f",videoProgress.fractionCompleted);
    //<8>开始下载
    [task resume];
    [videoprogress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress * pro = (NSProgress*)object;
        NSString * progre = [NSString stringWithFormat:@"%.2f",pro.fractionCompleted];
        [self performSelectorOnMainThread:@selector(showProgress:) withObject:progre waitUntilDone:NO];
    }
}
-(void)showProgress:(NSString*)objc
{
    self.videoItem.progressView.progress = objc.floatValue;
    
//    if (objc.floatValue == 1.00) {
//        self.videoItem.progressView.progress = 0;
//        self.vide
//    }

}
-(void)longPressBack:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.bubbleImageView showTheMenu];
    }
}
-(void)setBackViewImage:(NSString*)contentStr
{
   NSDictionary * dic = [NSDictionary initWithJsonString:contentStr];
    if (!dic)
    {
        
    }
    else
    {
    
    }
}
-(void)clickBackView:(id)sender
{
    
    if (self.clickBack) {
        self.clickBack(self.indexPath);
    }
}
- (void)clickTheSendAgain:(MenuImageView*)imageView
{
    //子类去继承
    if (self.sendAgain)
    {
        self.sendAgain();
    }
}
-(void)sendVideoAgain:(MTTMessageEntity*)message success:(void(^)(NSString*,MTTMessageEntity*))Success
{
    if (self.isBlackNameOrNot || self.isDeleteOrNot)
    {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":self.isBlackNameOrNot?@"8":@"9",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username,
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *blackMessage =[MTTMessageEntity makeMessage:contentStr session:message.sessionId MsgType:msgContentType];
        Success(@"1",blackMessage);
        return;
    }
    
    NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
    NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * doic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
    
    if (doic.count == 1 && doic[@"local"]) {
        NSString * filePath = doic[@"local"];
        [[DDSendPhotoMessageAPI sharedPhotoCache] uploadVideo:filePath success:^(NSString *videoUrl) {
            NSArray * array = [videoUrl componentsSeparatedByString:@","];
            videoUrl = [NSString stringWithFormat:@"%@",array[0]];
            
            //将视频数据存在链接下
            [self downLoadVideo:[IPADDRESS stringByAppendingString:videoUrl] success:^(id response) {
            } failed:^(NSError *error) {
            } progress:^(NSProgress *progreee) {
                
            }];
                
            //将图片数据存储
            NSString *videoStr = [IPADDRESS stringByAppendingString:videoUrl];
            UIImage * image = [self imageWithVideo:[NSURL URLWithString:videoStr]];
            [[MTTPhotosCache sharedPhotoCache] storePhoto:UIImageJPEGRepresentation(image, 1.0) forKey:videoUrl toDisk:YES];
    
            
            message.state=DDMessageSending;
            NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:contentDic];
            [muDic setValue:[IPADDRESS stringByAppendingString:videoUrl] forKey:DD_IMAGE_URL_KEY];
            
            NSData * dicData = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentString = [[NSString alloc]initWithData:dicData encoding:NSUTF8StringEncoding];
            message.msgContent = contentString;
            [self sendMessage:message andGroup:[message isGroupMessage] success:^(NSString *string, MTTMessageEntity *mess) {
                Success(string, mess);
            }];
        } failure:^(id error) {
            message.state = DDMessageSendFailure;
            [self showSendFailure];
//            NSData * videoData = [NSData dataWithContentsOfFile:filePath];
//            [videoData writeToFile:filePath atomically:YES];
//            message.msgContent = contentStr;
//            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//            }];
        }];
    }
    else
    {
        NSDictionary * dictionary = @{@"content":doic,@"display_type":@"7"};
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * conten = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        message.msgContent = conten;
        BOOL isGroup = [message isGroupMessage];
        [self sendMessage:message andGroup:isGroup success:^(NSString *string, MTTMessageEntity *mess) {
            Success(string,mess);
        }];
    }
    
    
    
//    NSDictionary * dictionary = @{@"content":doic,@"display_type":@"7"};
//    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * conten = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    message.msgContent = conten;
//    
//    BOOL isGroup = [message isGroupMessage];
//    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:[[SessionModule instance] getSessionById:message.sessionId]  completion:^(MTTMessageEntity* theMessage,NSError *error) {
//        Success(@"0",nil);
//        if (error) {
//            [self showSendFailure];
//            message.state = DDMessageSendFailure;
//            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//                if (result)
//                {
//                    [self showSendFailure];
//                }
//            }];
//        }
//        else
//        {
//            message.state = DDmessageSendSuccess;
//            [self showSendSuccess];
//            //刷新DB
//            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//                if (result)
//                {
//                    [self showSendSuccess];
//                }
//            }];
//        }
//    } Error:^(NSError *error) {
//        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//            if (result)
//            {
//                [self showSendFailure];
//            }
//        }];
//        
//    }];
}

-(void)sendMessage:(MTTMessageEntity*)message andGroup:(BOOL)group success:(void(^)(NSString*,MTTMessageEntity*))succe
{
    [[DDMessageSendManager instance] sendMessage:message isGroup:group Session:[[SessionModule instance] getSessionById:message.sessionId]  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        succe(@"0",nil);
        if (error) {
            [self showSendFailure];
            message.state = DDMessageSendFailure;
//            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//                if (result)
//                {
                    [self showSendFailure];
//                }
//            }];
        }
        else
        {
            message.state = DDmessageSendSuccess;
            [self showSendSuccess];
            //刷新DB
//            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//                if (result)
//                {
                    [self showSendSuccess];
//                }
//            }];
        }
    } Error:^(NSError *error) {
//        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//            if (result)
//            {
                [self showSendFailure];
//            }
//        }];
        
    }];
}
-(void)setIsChioseOrNot:(BOOL)isChioseOrNot
{
    if (isChioseOrNot) {
        self.videoBtn.enabled = NO;
    }
    else
    {
        self.videoBtn.enabled = YES;
    }
}
- (void)setContent:(MTTMessageEntity*)content
{
    [super setContent:content];
    [self.choiseBtn removeFromSuperview];
    [self.contentView addSubview:self.choiseBtn];
    UIImage* bubbleImage = nil;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            bubbleImage = [UIImage imageNamed:@"pictureLeftBubble"];//self.leftConfig.picBgImage
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:self.leftConfig.imgStretchy.left topCapHeight:self.leftConfig.imgStretchy.top];
        }
            break;
        case DDBubbleRight:
        {
            bubbleImage = [UIImage imageNamed:@"picturerightBubble"];//self.rightConfig.picBgImage
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:self.rightConfig.imgStretchy.left topCapHeight:self.rightConfig.imgStretchy.top];
        }
        default:
            break;
    }
    [self.bubbleImageView setImage:bubbleImage];
    [self.contentView bringSubviewToFront:self.bubbleImageView];
  
    
    switch (self.location) {
        case DDBubbleLeft://别人发的需要先加载在播放
//            self.videoBtn.hidden = YES;
            [self showOtherVideo:content];
            break;
        case DDBubbleRight://自己发的自动播放
            self.videoBtn.hidden = YES;
            [self showMyVideo:content];
            break;
        default:
            break;
    }
    
    if (!self.videoBtn.hidden) {
        [self.contentView bringSubviewToFront:self.videoBtn];
        [self.videoBtn addTarget:self action:@selector(clickVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)showOtherVideo:(MTTMessageEntity*)content
{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSDictionary * dic = [NSDictionary initWithJsonString:content.msgContent];
    NSString * videoPath = [NSString string];
    if (!dic)
    {
        NSString * contentStr =content.msgContent;
        if ([contentStr hasSuffix:@".mp4"]) {
            videoPath = contentStr;
        }
    }
    else
    {
        if (dic[DD_IMAGE_LOCAL_KEY])//本地有图片
        {
            NSString * content = dic[DD_IMAGE_URL_KEY];
            if ([dic[DD_IMAGE_URL_KEY] length]) {
                videoPath = content;
            }
            else
            {
                NSString * str = dic[DD_IMAGE_LOCAL_KEY];
                videoPath = str;
            }
        }
        else//本地无图片
        {
            if (dic.count == 1)
            {
                NSString * string = [dic[@"content"] length]?dic[@"content"]:dic[@"url"];
                videoPath = string;
            }
        }
    }
    NSArray * videoArr = [videoPath componentsSeparatedByString:@":"];
    NSString * string = videoArr[0];
    if (![string isEqualToString:@"http"]) {
        videoPath = [IPADDRESS stringByAppendingString:videoPath];
    }
    self.videoString = videoPath;
    NSArray *specialUrlArr = [videoPath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
    if (isOrNot) {//本地有视频就自动播放
        self.videoBtn.hidden = YES;
        self.filePath = fileName1;
        [self reloadStart];
        
       UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackView:)];
        [self.backView addGestureRecognizer:tap];
//        [self.contentView addSubview:self.backView];

    }
    else//本地无视频需要先下载
    {
        self.videoBtn.hidden = NO;
        [self.backView setImage:[UIImage imageNamed:@""]];
        [self.backView setBackgroundColor:RGB(235, 235, 235)];
        
        
        
        videoPath = [videoPath stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"];
        NSArray * array = [videoPath componentsSeparatedByString:@"/"];
        NSMutableArray * muarray = [NSMutableArray array];
        [muarray addObjectsFromArray:array];
        NSString * lastStr = array[array.count-1];
        lastStr = [@"thumb_" stringByAppendingString:lastStr];
        [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
        videoPath = [muarray componentsJoinedByString:@"/"];
        NSString * imageString = [self localUrl:videoPath];
        if (imageString.length)
        {
            NSData * data = [NSData dataWithContentsOfFile:imageString];
            [self.backView setImage:[UIImage imageWithData:data]];
        }
        else
        {
          dispatch_async(dispatch_get_global_queue(0, 0), ^{
              WPDownLoadVideo * load = [[WPDownLoadVideo alloc]init];
              [load downLoadImage:videoPath success:^(id response) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self.backView setImage:[UIImage imageWithData:response]];
                  });
              } failed:^(NSError *error) {
              }];
          });
            
        }
//        //获取视频第一帧
//        NSURL * imageUrl = [NSURL URLWithString:videoPath];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                UIImage * videoImage = [self imageWithVideo:imageUrl];
//                if (videoImage) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.backView setImage:videoImage];
//                    });
//                }
//        });
    }
}
-(NSString * )localUrl:(NSString*)urlStr
{
    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
    NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,array[array.count-1]];
    NSFileManager * mager = [NSFileManager defaultManager];
    if ([mager fileExistsAtPath:fileName])
    {
        return fileName;
    }
    else
    {
        return @"";
    }
}
- (UIImage *)imageWithVideo:(NSURL *)vidoURL

{
    // 根据视频的URL创建AVURLAsset
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidoURL options:nil];
    // 根据AVURLAsset创建AVAssetImageGenerator对象
    AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset: asset];
    gen.appliesPreferredTrackTransform = YES;
    // 定义获取0帧处的视频截图
    CMTime time = CMTimeMake(0,0.1);
    NSError *error = nil;
    CMTime actualTime;
    // 获取time处的视频截图
    CGImageRef  image = [gen  copyCGImageAtTime: time actualTime: &actualTime error:&error];
    // 将CGImageRef转换为UIImage
    UIImage *thumb = [[UIImage alloc] initWithCGImage: image];
    CGImageRelease(image);
    return  thumb;
}
-(void)showMyVideo:(MTTMessageEntity*)content
{
    NSDictionary * dic = [NSDictionary initWithJsonString:content.msgContent];
    if (!dic)
    {
        NSString * contentStr =content.msgContent;
        if ([contentStr hasSuffix:@".mp4"]) {
            NSData * imageData =  [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:contentStr];
            [self.backView setImage:[UIImage imageWithData:imageData]];
            [self getContentStr:contentStr];
        }
    }
    else
    {
        if (dic[DD_IMAGE_LOCAL_KEY])//本地有图片
        {
            NSString * content = dic[DD_IMAGE_URL_KEY];
            if ([dic[DD_IMAGE_URL_KEY] length]) {
                NSData * imageData =  [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:content];
                [self.backView setImage:[UIImage imageWithData:imageData]];
                [self getContentStr:content];
            }
            else
            {
                NSString * str = dic[DD_IMAGE_LOCAL_KEY];
                NSData * data = [NSData dataWithContentsOfFile:str];
                self.filePath = str;
                [self reloadStart];
            }
        }
        else//本地无图片
        {
            if (dic.count == 1)
            {
                NSString * string = [dic[@"content"] length]?dic[@"content"]:dic[@"url"];
                NSData * imageData =  [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:string];
                [self.backView setImage:[UIImage imageWithData:imageData]];
                [self getContentStr:string];
            }
            
        }
    }
}
-(void)getContentStr:(NSString*)string
{
    NSArray *specialUrlArr = [string componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    self.filePath = fileName1;
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    
    
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

- (float)contentUpGapWithBubble
{
    return kHEIGHT(66.5);
}

- (float)contentDownGapWithBubble
{
    return kHEIGHT(66.5);
}

- (float)contentLeftGapWithBubble
{
    return kHEIGHT(88.5);
}

- (float)contentRightGapWithBubble
{
    return kHEIGHT(88.5);//106->66.5
}
- (float)cellHeightForMessage:(MTTMessageEntity*)message
{
    return kHEIGHT(133);//213->133
}
- (void)layoutContentView:(MTTMessageEntity*)content
{
   
    
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(0);//7
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
//                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177)-8, kHEIGHT(132)-2));//212->133
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177), kHEIGHT(133)));
            }];
            
            [self.videoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(0);//7
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
                //                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177)-8, kHEIGHT(132)-2));//212->133
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177), kHEIGHT(133)));
            }];
        }
            break;
        case DDBubbleRight:
        {
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(0);
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
//                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177)-8, kHEIGHT(132)-2));
                 make.size.mas_equalTo(CGSizeMake(kHEIGHT(177), kHEIGHT(133)));
            }];
            
            [self.videoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImageView.mas_left).offset(0);
                make.top.equalTo(self.bubbleImageView.mas_top).offset(0);
                //                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177)-8, kHEIGHT(132)-2));
                make.size.mas_equalTo(CGSizeMake(kHEIGHT(177), kHEIGHT(133)));
            }];
        }
        default:
            break;
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)dealloc
{
  [[ZacharyPlayManager sharedInstance]cancelAllVideo];
}
@end

