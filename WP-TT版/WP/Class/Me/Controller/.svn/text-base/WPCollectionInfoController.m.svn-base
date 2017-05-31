//
//  WPCollectionInfoController.m
//  WP
//
//  Created by CBCCBC on 16/4/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCollectionInfoController.h"
#import "WPTopLineView.h"
#import "VideoBrowser.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "RSCopyLabel.h"
#import "YYShareManager.h"
#import "ShareEditeViewController.h"
#import "WPMySecurities.h"
#import "HJCActionSheet.h"
#import "CollectViewController.h"
#import "ChattingMainViewController.h"
#import "ZacharyPlayManager.h"
#import "WPDownLoadVideo.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#define photoWidth (SCREEN_WIDTH==320)?74:((SCREEN_WIDTH==375)?79:86)
#define videoWidth (SCREEN_WIDTH==320)?112:((SCREEN_WIDTH==375)?131:145)
#define shuoShuoVideo @"/shuoShuoVideo"
@interface WPCollectionInfoController ()<UIGestureRecognizerDelegate,HJCActionSheetDelegate,CollectViewControllerDelegate>
{
    CGFloat bottom;
}
@property (nonatomic ,strong)WPTopLineView *topLine;
@property (nonatomic ,strong)UILabel *bottomLine;
@property (nonatomic ,strong)RSCopyLabel *bodyLabel;
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UIButton*rightButton;
@end

@implementation WPCollectionInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self.view addSubview:self.topLine];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage) name:@"reloadShuoShuo" object:nil];
    
}
-(void)changeImage
{
//    NSString * url = [NSString string];
//    url = self.dic[@"img_url"][0][@"small_address"];
//    NSArray * imageArray = [url componentsSeparatedByString:@":"];
//    if (![imageArray[0] isEqualToString:@"http"]) {
//        url = [NSString stringWithFormat:@"%@%@",IPADDRESS,url];
//    }
//    url = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
//    url = [url stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
    //插入thumbd_
//    NSArray * joinArray = [url componentsSeparatedByString:@"/"];
//    NSMutableArray * muarray = [NSMutableArray array];
//    [muarray addObjectsFromArray:joinArray];
//    NSString * lastStr = joinArray[joinArray.count-1];
//    lastStr = [NSString stringWithFormat:@"thumbd_%@",lastStr];
//    [muarray replaceObjectAtIndex:joinArray.count-1 withObject:lastStr];
//    url = [muarray componentsJoinedByString:@"/"];
    
//    NSString * localStr = [self localUrl:url];
//    if (localStr.length) {
//        NSData * data = [NSData dataWithContentsOfFile:localStr];
//        [self.imageView setImage:[UIImage imageWithData:data]];
//    }
}

- (void)initNav{
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =self.isFromChat?[[UIBarButtonItem alloc]initWithCustomView:self.rightButton]:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightButton.frame = CGRectMake(0, 0, 45, 45);
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
#pragma mark 点击发送
-(void)rightBarButtonItemAction:(UIButton*)sender
{
    NSString * classN = [NSString stringWithFormat:@"%@",self.dic[@"classN"]];
    switch (classN.intValue) {
        case 0://文字
        {
            NSString * string = [NSString stringWithFormat:@"%@",self.dic[@"content"]];
            NSString *description1 = [WPMySecurities textFromBase64String:string];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (!description3.length) {
                description3 = string;
            }
            
            NSArray * array = @[description3];
            [[ChattingMainViewController shareInstance] sendTextFromCollection:array];
        }
            break;
        case 1://图片
        {
            NSString * urlStr = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];
            [[ChattingMainViewController shareInstance] sendPhototFromCollection:urlStr];
        }
            break;
        case 2://视频
        {
            NSString * urlStr = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
            [[ChattingMainViewController shareInstance] sendVideoFromCollection:urlStr];
        }
            break;
        case 3://音频
            
            break;
            
        default:
            break;
    }
    NSArray * array = self.navigationController.viewControllers;
    [self.navigationController popToViewController:array[array.count-4] animated:YES];
}
- (void)rightBtnClick
{
//    [YYShareManager newShareWithTitle:@"这是title" url:nil action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends)
//        {
//            NSLog(@"分享到微聘好友");
//        }
//        if (type == YYShareManagerTypeWorkLines) {
//            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
////            share.shareInfo = self.defaultDataSource[0];
//            share.shareSuccessedBlock = ^(id json){
//            };
//            [self.navigationController pushViewController:share animated:YES];
//        }
//    } status:^(UMSResponseCode status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
//    }];
    
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"转发",@"转移",@"删除", nil];
    [sheet show];
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {//转移
        
    [self transformToAnotherCategory];
    }
    if (buttonIndex == 1) {//转发
        [self sendToOtherPeople];
    }
    if (buttonIndex == 3) {//删除
        [self deleteCollecton];
    }
}
#pragma mark 转移
-(void)transformToAnotherCategory
{
   
    CollectViewController *VC = [[CollectViewController alloc]init];
    VC.collectionIDs = [NSString stringWithFormat:@"%@",self.dic[@"id"]];
        if (VC.collectionIDs) {
            VC.delegate = self;
            VC.controller = @"WPCollectionController";
            [self.navigationController pushViewController:VC animated:YES];
        }
}
#pragma mark 转移成功的代理
- (void)isAlready
{
    [MBProgressHUD createHUD:@"转移成功！" View:self.view];
    if (self.transSuccess) {
        self.transSuccess();
    }
    //转移成功发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"transFromSuccsee" object:nil];
}
#pragma mark  转发
-(void)sendToOtherPeople
{
    NSString * classN = self.dic[@"classN"];
    switch (classN.intValue) {
        case 0://文字
        {
            NSString * string = [NSString stringWithFormat:@"%@",self.dic[@"content"]];
            NSString *description1 = [WPMySecurities textFromBase64String:string];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (!description3.length)
            {
                description3 = string;
            }
           
            [self tranmitMessage:string andMessageType:DDMessageTypeText andToUserId:@""];
            
        }
            break;
        case 1://图片
        {
            if (self.isFromChat)
            {
                NSString * urlStr = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];
                [[ChattingMainViewController shareInstance] sendPhototFromCollection:urlStr];
            }
            else
            {
                NSString * urlStr = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];
                urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
                urlStr = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,urlStr];
                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,DD_MESSAGE_IMAGE_SUFFIX];
                [self tranmitMessage:urlStr andMessageType:DDMessageTypeImage andToUserId:@""];
            }
        }
            break;
        case 2://视频
            if (self.isFromChat)
            {
                NSString * urlStr = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
                [[ChattingMainViewController shareInstance] sendVideoFromCollection:urlStr];
            }
            else
            {
                NSString * urlStr = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
                [self tranmitMessage:urlStr andMessageType:DDMEssageLitterVideo andToUserId:@""];
            }
            break;
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
        case DDMEssageAcceptApply:
            person.display_type = @"14";
            break;
        case DDMEssageMuchCollection:
            person.display_type = @"15";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
#pragma mark 删除
-(void)deleteCollecton
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action":@"delColl",
                                                                                  @"user_id":kShareModel.userId,
                                                                                  @"username":kShareModel.username,
                                                                                  @"password":kShareModel.password,
                                                                                  @"collid":self.dic[@"id"],
                                                                                  @"my_user_id":kShareModel.userId}];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/collection_new.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"1"]) {//成功
            [MBProgressHUD createHUD:@"删除成功！" View:self.view];
            if (self.deleteSuccess) {
                self.deleteSuccess();
            }
        }
        else
        {
          [MBProgressHUD createHUD:@"删除失败！" View:self.view];
        }
    } failure:^(NSError *error) {
         [MBProgressHUD createHUD:@"删除失败！" View:self.view];
    }];
  
}
- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.topLine.dic = dic;
    bottom = self.topLine.bottom;
    NSString *classN = dic[@"classN"];
    if ([classN isEqualToString:@"0"]) {                // 添加文字信息
        
        [self.view addSubview:self.bodyLabel];
        
        NSString  * str = [NSString stringWithFormat:@"%@",dic[@"content"]];
        NSString *description1 = [WPMySecurities textFromBase64String:str];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        if (!description3.length) {
            description3 = str;
        }
        
        [self setContentToBodyLabelWithContent:description3];
    }else if ([classN isEqualToString:@"1"]||[classN isEqualToString:@"2"]){           // 添加图片信息，视频
        
        [self.view addSubview:self.imageView];

    }else if ([classN isEqualToString:@"3"]){           // 添加语音信息
        
        
    }else if ([classN isEqualToString:@"4"]){
        
    }
    [self.view addSubview:self.bottomLine];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        NSString * videoUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.dic[@"url"][0]objectForKey:@"small_address"]];
        NSFileManager * fileManger = [NSFileManager defaultManager];
        NSArray *specialUrlArr = [videoUrl componentsSeparatedByString:@"/"];
        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
        NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
        NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
        BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
        CGFloat width ;
        NSString *classN = self.dic[@"classN"];
        if ([classN isEqualToString:@"1"]) {
            width = photoWidth;
        }else{
            width = videoWidth/3*4;
        }
        if (isOrNot)//本地有视频直接播放
        {
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), bottom, width, videoWidth)];
            self.imageView.userInteractionEnabled = YES;
//            playBtn.hidden = YES;
            self.fileStr = fileName1;
            [self reloadStart];
            bottom = self.imageView.bottom;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            tap.numberOfTapsRequired = 1;
            [self.imageView addGestureRecognizer:tap];
        }
        else//本地无视频时
        {
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), bottom, width, width)];
            self.imageView.userInteractionEnabled = YES;
            if (![classN isEqualToString:@"1"]) {
                self.imageView.frame = CGRectMake(kHEIGHT(10), bottom, width, videoWidth);
            }
            
            NSString *url = [NSString string];
            
            if (![classN isEqualToString:@"1"]) {
                NSString * small_address = [NSString stringWithFormat:@"%@",self.dic[@"url"][0][@"small_address"]];
                small_address = [small_address stringByReplacingOccurrencesOfString:@"mp4" withString:@"png"];
                NSArray * arr = [small_address componentsSeparatedByString:@"/"];
                NSString * lastStr = arr[arr.count-1];
                lastStr = [@"thumb_" stringByAppendingString:lastStr];
                NSMutableArray * muArr = [NSMutableArray array];
                [muArr addObjectsFromArray:arr];
                [muArr removeLastObject];
                [muArr insertObject:lastStr atIndex:muArr.count];
                NSString * imageUr = [muArr componentsJoinedByString:@"/"];
                url = imageUr;
            }
            else
            {
              url = self.dic[@"img_url"][0][@"small_address"];
            }
            
            
            NSArray * imageArray = [url componentsSeparatedByString:@":"];
            if (![imageArray[0] isEqualToString:@"http"]) {
                url = [NSString stringWithFormat:@"%@%@",IPADDRESS,url];
            }
           
            
            //插入thumbd_
//            NSArray * joinArray = [url componentsSeparatedByString:@"/"];
//            NSMutableArray * muarray = [NSMutableArray array];
//            [muarray addObjectsFromArray:joinArray];
//            NSString * lastStr = joinArray[joinArray.count-1];
//            lastStr = [NSString stringWithFormat:@"thumbd_%@",lastStr];
//            [muarray replaceObjectAtIndex:joinArray.count-1 withObject:lastStr];
//            url = [muarray componentsJoinedByString:@"/"];
            url = [url stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
            url = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
//            NSString * localStr = [self localUrl:url];
//            if (localStr.length)
//            {
//                NSData * data = [NSData dataWithContentsOfFile:localStr];
//                self.imageView.image = [UIImage imageWithData:data];
//            }
//            else
//            {
                url = [self getImageStr:url];
              [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"head_default"]];
//            }
            
            
//            [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"head_default"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            tap.numberOfTapsRequired = 1;
            [self.imageView addGestureRecognizer:tap];
            if ([classN isEqualToString:@"2"]) {
                UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                playBtn.frame = CGRectMake(0, 0, width, videoWidth);
                [playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
                [playBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.imageView addSubview:playBtn];
            }
            bottom = self.imageView.bottom;
        }

        
//        CGFloat width ;
//        NSString *classN = self.dic[@"classN"];
//        if ([classN isEqualToString:@"1"]) {
//            width = photoWidth;
//        }else{
//            width = videoWidth/3*4;
//        }
//        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), bottom, width, width)];
//        self.imageView.userInteractionEnabled = YES;
//        if (![classN isEqualToString:@"1"]) {
//            self.imageView.frame = CGRectMake(kHEIGHT(10), bottom, width, videoWidth);
//        }
//
//        NSString *url = self.dic[@"img_url"][0][@"small_address"];
//        NSArray * imageArray = [url componentsSeparatedByString:@":"];
//        if ([imageArray[0] isEqualToString:@"http"]) {
//            
//        }
//        else
//        {
//            url = [NSString stringWithFormat:@"%@%@",IPADDRESS,url];
//        }
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"head_default"]];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        tap.numberOfTapsRequired = 1;
//        [self.imageView addGestureRecognizer:tap];
//        if ([classN isEqualToString:@"2"]) {
//            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            playBtn.frame = CGRectMake(0, 0, width, videoWidth);
//            [playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
//            [playBtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.imageView addSubview:playBtn];
//        }
//        bottom = self.imageView.bottom;
    }
    return _imageView;
}
-(NSString*)getImageStr:(NSString*)imageStr
{
    
    NSArray * array = [imageStr componentsSeparatedByString:@"/"];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    NSString *lastStr = array[array.count-1];
    lastStr = [@"thumb_" stringByAppendingString:lastStr];
    [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
    imageStr = [muarray componentsJoinedByString:@"/"];
    return imageStr;
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
-(void)reloadStart
{
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance]startWithLocalPath:self.fileStr WithVideoBlock:^(CGImageRef imageData, NSString *filePath) {
        if ([filePath isEqualToString:weakSelf.fileStr]) {
            self.imageView.layer.contents=(__bridge id _Nullable)(imageData);
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

- (void)tapAction:(UITapGestureRecognizer *)tap
{
     NSString *classN = self.dic[@"classN"];
    if ([classN isEqualToString:@"2"])
    {
        [self videoClick:nil];
    }
    else
    {
        NSString * string = [NSString stringWithFormat:@"%@",[self.dic[@"img_url"][0] objectForKey:@"small_address"]];
        NSArray * firstArr = [string componentsSeparatedByString:@":"];
        if (![firstArr[0] isEqualToString:@"http"])
        {
            string = [NSString stringWithFormat:@"%@%@",IPADDRESS,string];
        }
        NSArray * array = [string componentsSeparatedByString:@"/"];
        NSString * string1 = [NSString stringWithFormat:@"%@",array[array.count-1]];
        NSArray * array1 = [string1 componentsSeparatedByString:@"_"];
        NSMutableArray * muArray = [NSMutableArray array];
        [muArray addObjectsFromArray:array1];
        [muArray removeFirstObject];
        NSMutableArray * muarray = [NSMutableArray array];
        for (int i = 0 ; i < 4; i++)
        {
            [muarray addObject:array[i]];
        }
        [muarray addObject:muArray[0]];
        NSString * urlStr = [muarray componentsJoinedByString:@"/"];
        
        NSString *url = [IPADDRESS stringByAppendingString:urlStr];
        NSArray * imageArray = [string componentsSeparatedByString:@":"];
        if ([imageArray[0] isEqualToString:@"http"])
        {
            url = string;
        }
        url = [url stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        photo.sid = self.dic[@"user_id"];
        photo.toView = self.imageView;
        
        
        MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
        // 缩放动画
        photoBrowser.status = UIViewAnimationAnimationStatusZoom;
        photoBrowser.photos = @[photo];
        photoBrowser.isNeedShow = YES;
        photoBrowser.currentStr = url;
        // 当前选中的值
        photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        // 展示控制器
        [photoBrowser showPickerVc:self];
    }
    
//            NSString * string = [NSString stringWithFormat:@"%@",[self.dic[@"img_url"][0] objectForKey:@"small_address"]];
//            NSArray * array = [string componentsSeparatedByString:@"/"];
//            NSString * string1 = [NSString stringWithFormat:@"%@",array[array.count-1]];
//            NSArray * array1 = [string1 componentsSeparatedByString:@"_"];
//            NSMutableArray * muArray = [NSMutableArray array];
//            [muArray addObjectsFromArray:array1];
//            [muArray removeFirstObject];
//    
//            NSMutableArray * muarray = [NSMutableArray array];
//            for (int i = 0 ; i < 4; i++) {
//                [muarray addObject:array[i]];
//            }
//            [muarray addObject:muArray[0]];
//            NSString * urlStr = [muarray componentsJoinedByString:@"/"];
//   
//    NSString *url = [IPADDRESS stringByAppendingString:urlStr];
//    NSArray * imageArray = [string componentsSeparatedByString:@":"];
//    if ([imageArray[0] isEqualToString:@"http"]) {
//        url = string;
//    }
//    
//    
//    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
//    photo.photoURL = [NSURL URLWithString:url];
//    photo.sid = self.dic[@"user_id"];
//    photo.toView = self.imageView;
//    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//    // 缩放动画
//    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
//    photoBrowser.photos = @[photo];
//    photoBrowser.isNeedShow = YES;
//    photoBrowser.hideCollection = YES;
//    // 当前选中的值
//    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    // 展示控制器
//    [photoBrowser showPickerVc:self];
}

- (void)videoClick:(UIButton*)sender
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.dic[@"url"][0]objectForKey:@"small_address"]];
    NSArray * urlArray = [urlString componentsSeparatedByString:@":"];
    if ([urlArray[0] isEqualToString:@"http"]) {
        urlString = [NSString stringWithFormat:@"%@",[self.dic[@"url"][0]objectForKey:@"small_address"]];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.dic[@"url"][0]objectForKey:@"small_address"]];
    }
    
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray *specialUrlArr = [urlString componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
    if (!isOrNot) {
        sender.hidden = YES;
        WPDownLoadVideo * downLoad = [[WPDownLoadVideo alloc]init];
        [downLoad downLoadVideo:urlString success:^(id response) {
            self.fileStr = fileName1;
            [self reloadStart];
        } failed:^(NSError *error) {
            //        sender.hidden = NO;
        } progress:^(NSProgress *progreee) {
            
        }];
        
    }
    else
    {
        VideoBrowser *video = [[VideoBrowser alloc] init];
        NSString * string = [NSString stringWithFormat:@"%@",[self.dic[@"url"][0]objectForKey:@"small_address"]];
        NSArray * array = [string componentsSeparatedByString:@":"];
        if ([array[0] isEqualToString:@"http"]) {
            video.videoUrl = [NSString stringWithFormat:@"%@",[self.dic[@"url"][0]objectForKey:@"small_address"]];
        }
        else
        {
            video.videoUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.dic[@"url"][0]objectForKey:@"small_address"]];
        }
//        [video show];
        [video showPickerVc:self];
    }
    

//    VideoBrowser *video = [[VideoBrowser alloc] init];
//    NSString * string = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.dic[@"url"][0]objectForKey:@"small_address"]];
//    NSArray * array = [string componentsSeparatedByString:@":"];
//    if ([array[0] isEqualToString:@"http"]) {
//      video.videoUrl = [NSString stringWithFormat:@"%@",[self.dic[@"url"][0]objectForKey:@"small_address"]];
//    }
//    else
//    {
//    video.videoUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.dic[@"url"][0]objectForKey:@"small_address"]];
//    }
//    [video show];
}

- (void)setContentToBodyLabelWithContent:(NSString *)content
{
    NSString *description1 = [content stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    
    if (content.length<1)return;
    CGSize size = [description3 getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)];
    
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:description3];
//    NSArray *array = [content componentsSeparatedByString:@":"];
//    if (array.count > 1) {
//        NSString *string = array[0];
//        [AttributedStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, string.length)];
//        
//    }
    self.bodyLabel.frame = CGRectMake(kHEIGHT(10), self.topLine.bottom , SCREEN_WIDTH-kHEIGHT(20), size.height);
    self.bodyLabel.text = description3;
    bottom = self.bodyLabel.bottom;
}

- (RSCopyLabel *)bodyLabel
{
    if (!_bodyLabel) {
        self.bodyLabel = [[RSCopyLabel alloc]init];
        self.bodyLabel.font = kFONT(14);
        self.bodyLabel.numberOfLines = 0;
        self.bodyLabel.type = YES;
        self.bodyLabel.dic = @{@"speak_comment_content":self.dic[@"content"]};
        self.bodyLabel.userInteractionEnabled = YES;
        NSString *content = self.dic[@"content"];
        NSString *description1 = [content stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        
        if (content.length<1){
            
            CGSize size = [description3 getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)];
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:description3];
            NSArray *array = [content componentsSeparatedByString:@":"];
            if (array.count > 1) {
                NSString *string = array[0];
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, string.length)];
                
            }
            self.bodyLabel.frame = CGRectMake(kHEIGHT(10), self.topLine.bottom , SCREEN_WIDTH-kHEIGHT(20), size.height);
            self.bodyLabel.attributedText = AttributedStr;
            bottom = self.bodyLabel.bottom;
        }
    }
    return _bodyLabel;
}

//- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
//{
//    
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        
//        [self.bodyLabel becomeFirstResponder];
//        
//        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        [menuController setMenuVisible:NO];
//        
//        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"转移" action:@selector(menuItem1:)];
//        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(menuItem2:)];
//        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem3:)];
//        [menuController setMenuItems:@[menuItem1,menuItem2,menuItem3]];
//        
//        [menuController setTargetRect:self.bodyLabel.frame inView:self.view];
//        
//        [menuController setMenuVisible:YES animated:YES];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
//    }
//}

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.bodyLabel.backgroundColor = [UIColor whiteColor];
}

- (void)itemAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.bodyLabel.text;
}


- (UILabel *)bottomLine
{
    if (!_bottomLine) {
        NSArray *times = [_dic[@"add_time"] componentsSeparatedByString:@" "];
        NSString *string = [NSString stringWithFormat:@"收藏于 %@",times[0]];
        CGSize size = [string getSizeWithFont:FUCKFONT(12) Height:20];
        self.bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(10), bottom+kHEIGHT(10), size.width, size.height)];
        self.bottomLine.text = string;
        self.bottomLine.font = kFONT(12);
        self.bottomLine.textColor = RGB(127, 127, 127);
    }
    return _bottomLine;
}

- (WPTopLineView *)topLine
{
    if (!_topLine) {
        self.topLine = [[WPTopLineView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(42))];
    }
    return _topLine;
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
