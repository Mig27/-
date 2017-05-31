//
//  YYShareManager.m
//  WP
//
//  Created by CBCCBC on 16/1/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "YYShareManager.h"
//#import "ShareOperation.h"
//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocialSnsService.h"
@class YYShareOperation;

#define INT_SHARE_SIZE(x) ((SCREEN_WIDTH == 320)?(x):((SCREEN_WIDTH == 375)?(1.17*(x)):(1.29*(x))))
#define SHARE_SIZE(x) lroundf(INT_SHARE_SIZE(x))

static  NSTimeInterval const timeInterval = 0.3;
static NSInteger const backgroundTag = 100;

@interface YYShareManager ()

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) void (^shareActionTypeBlock)(YYShareManagerType actionType);
//@property (copy, nonatomic) void (^shareStatusBlock)(UMSResponseCode shareStatus);
@property (copy, nonatomic) void (^shareResponseBlock)(UMSocialShareResponse*response);

@end

@interface YYShareOperation ()
@property (copy, nonatomic)NSString * imageString;
@end

@implementation YYShareManager

+(void)shareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSocialShareResponse*response))Response
{
    YYShareManager *manager = [[YYShareManager alloc]initWith:NO];
    NSArray * array = [title componentsSeparatedByString:@"|"];
    manager.title = array[0];
    manager.shareContent = array[1];
    manager.imageStr = array[2];
    manager.url = url;
    [WINDOW addSubview:manager];
    
    [manager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WINDOW);
    }];
    
    manager.shareActionTypeBlock = ^(YYShareManagerType type){
        if (actionType) {
            actionType(type);
        }
    };
    
    manager.shareResponseBlock = ^(UMSocialShareResponse*response){
        Response(response);
    };
}

+(void)newShareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSocialShareResponse*response))Response
{
    YYShareManager *manager = [[YYShareManager alloc]initWith:YES];
    NSArray * titleArr = [title componentsSeparatedByString:@"|"];
    manager.title = titleArr[0];
    manager.shareContent = titleArr[1];
    manager.imageStr = titleArr[2];
    manager.url = url;
    [WINDOW addSubview:manager];
    
    [manager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WINDOW);
    }];
    
    manager.shareActionTypeBlock = ^(YYShareManagerType type){
        if (actionType) {
            actionType(type);
        }
    };
    
    manager.shareResponseBlock = ^(UMSocialShareResponse*response){
        Response(response);
    };
}

//不带收藏举报的
//+(void)shareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSResponseCode status))status;
//{
//    
//    YYShareManager *manager = [[YYShareManager alloc]initWith:NO];
//    NSArray * array = [title componentsSeparatedByString:@"|"];
//    manager.title = array[0];
//    manager.shareContent = array[1];
//    manager.imageStr = array[2];
//    manager.url = url;
//    [WINDOW addSubview:manager];
//    
//    [manager mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(WINDOW);
//    }];
//    
//    manager.shareActionTypeBlock = ^(YYShareManagerType type){
//        if (actionType) {
//            actionType(type);
//        }
//    };
//    
//    manager.shareStatusBlock = ^(UMSResponseCode shareStatus){
//        if (status) {
//            status(shareStatus);
//        }
//    };
//}
//
//#pragma mark - 带收藏举报的
//+(void)newShareWithTitle:(NSString *)title url:(NSString *)url action:(void(^)(YYShareManagerType type))actionType status:(void(^)(UMSResponseCode status))status
//{
//    YYShareManager *manager = [[YYShareManager alloc]initWith:YES];
//    NSArray * titleArr = [title componentsSeparatedByString:@"|"];
//    manager.title = titleArr[0];
//    manager.shareContent = titleArr[1];
//    manager.imageStr = titleArr[2];
//    manager.url = url;
//    [WINDOW addSubview:manager];
//    
//    [manager mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(WINDOW);
//    }];
//    
//    manager.shareActionTypeBlock = ^(YYShareManagerType type){
//        if (actionType) {
//            actionType(type);
//        }
//    };
//    
//    manager.shareStatusBlock = ^(UMSResponseCode shareStatus){
//        if (status) {
//            status(shareStatus);
//        }
//    };
//
//}

- (void)shareTypeActions:(UIButton *)sender{
    
    if (self.shareActionTypeBlock) {
        self.shareActionTypeBlock(sender.tag);
    }
    
    if (sender.tag == YYShareManagerTypeWeiPinFriends) {

    }
    if (sender.tag == YYShareManagerTypeWorkLines) {
        
    }
    
    //微信好友
    if (sender.tag == YYShareManagerTypeWeChatFriends) {

//        [YYShareOperation shareToPlatform:UMShareToWechatSession title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSResponseCode status) {
//            if (self.shareStatusBlock) {
//                self.shareStatusBlock(status);
//            }
//        }];

        
        [YYShareOperation shareToPlatform:UMSocialPlatformType_WechatSession title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSocialShareResponse *response) {
        }];
    }
    
    //微信朋友圈
    if (sender.tag == YYShareManagerTypeWeChatSessions) {
//        [YYShareOperation shareToPlatform:UMShareToWechatTimeline title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSResponseCode status) {
//            if (self.shareStatusBlock) {
//                self.shareStatusBlock(status);
//            }
//        }];
        
        [YYShareOperation shareToPlatform:UMSocialPlatformType_WechatTimeLine title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSocialShareResponse *response) {
        }];
        
    }
    if (sender.tag == YYShareManagerTypeQQFriends) {//点击QQ好友分享
//        [YYShareOperation shareToPlatform:UMShareToQQ title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSResponseCode status) {
//            if (self.shareStatusBlock) {
//                self.shareStatusBlock(status);
//            }
//        }];
        
        
        [YYShareOperation shareToPlatform:UMSocialPlatformType_QQ title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSocialShareResponse *response) {
        }];
    }
    if (sender.tag == YYShareManagerTypeQzones) {//点击QQ空间分享
//        [YYShareOperation shareToPlatform:UMShareToQzone title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSResponseCode status) {
//            if (self.shareStatusBlock) {
//                self.shareStatusBlock(status);
//            }
//        }];
        
        [YYShareOperation shareToPlatform:UMSocialPlatformType_Qzone title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSocialShareResponse *response) {
        }];
    }
    //新浪微博
    if (sender.tag == YYShareManagerTypeSina) {
//        [YYShareOperation shareToPlatform:UMShareToSina title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSResponseCode status) {
//            if (self.shareStatusBlock) {
//                self.shareStatusBlock(status);
//            }
//        }];
        
        
        [YYShareOperation shareToPlatform:UMSocialPlatformType_Sina  title:self.title url:self.url content:self.shareContent imageStr:self.imageStr presentController:[self viewController] status:^(UMSocialShareResponse *response) {
        }];
    }
    
    [self remove];
}
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//  
//}


- (void)cancelActions:(UIButton *)sender{
    [self remove];
}

- (void)remove{
    [UIView animateWithDuration:timeInterval animations:^{
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [self viewWithTag:backgroundTag];
        view.top = SCREEN_HEIGHT;
    }];
    
    [self performSelector:@selector(delay) withObject:nil afterDelay:timeInterval];
}

-(void)delay{
    [self removeFromSuperview];
}


- (id)initWith:(BOOL)isSpeical{
    
    self = [super init];
    if (self) {
        if (isSpeical) { //需要收藏和举报
        
            [UIView animateWithDuration:timeInterval animations:^{
                self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            }];
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 2*116+5+kHEIGHT(43))];//SHARE_SIZE(92)->110
            backView.backgroundColor = [UIColor whiteColor];
            backView.tag = backgroundTag;
            [self addSubview:backView];
            
            UIScrollView *shareView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 116+5)];//SHARE_SIZE(92)->110
            shareView.backgroundColor = RGB(235, 235, 235);
            shareView.showsHorizontalScrollIndicator = NO;
            shareView.showsVerticalScrollIndicator = NO;
            [backView addSubview:shareView];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 116+5, SCREEN_WIDTH, 0.5)];//SHARE_SIZE(92)->110
            line.backgroundColor = RGB(226, 226, 226);
            [backView addSubview:line];
            
            UIScrollView *collectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 116 + 0.5+5, SCREEN_WIDTH, 116)];//SHARE_SIZE(92)->110
            collectView.backgroundColor = RGB(235, 235, 235);
            collectView.showsHorizontalScrollIndicator = NO;
            [backView addSubview:collectView];
            
            NSArray *imageNames = @[@"fenxiang_haoyou",@"fenxiang_zhichangshuoshuo",@"fenxiang_weixin",@"fenxiang_pengyouquan",@"fenxiang_QQ",@"fenxiang_QQkongjian",@"fenxiang_xinlang"];
            NSArray * imagePre = @[@"fenxiang_haoyou_pre",@"fenxiang_zhichangshuoshuo_pre",@"fenxiang_weixin_pre",@"fenxiang_pengyouquan_pre",@"fenxiang_QQ_pre",@"fenxiang_QQkongjian_pre",@"fenxiang_xinlang_pre"];
            NSArray *titles = @[@"发送给好友",@"分享到话题",@"分享到微信",@"分享到朋友圈",@"分享到QQ",@"分享到QQ空间",@"分享到新浪"];
            
            NSArray *reportAndCollect = @[@"fenxiang_shoucang",@"fenxiang_jubao"];
            NSArray * reportImagePre = @[@"fenxiang_shoucang_pre",@"fenxiang_jubao_pre"];
            NSArray *title = @[@"收藏",@"举报"];
            
            UIView *lastView = nil;
            for (int i = 0; i < 7; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat left = lastView ? lastView.right+20 : 16;//16->20
                
                button.frame = CGRectMake(left, 20, 60, 60);//SHARE_SIZE(44)->60
                button.tag = YYShareManagerTypeWeiPinFriends+i;
                [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:imagePre[i]] forState:UIControlStateHighlighted];
//                [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(shareTypeActions:) forControlEvents:UIControlEventTouchUpInside];
                [shareView addSubview:button];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.left-10, button.bottom+6, button.width+20, 15)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = kFONT(10);
                label.text = titles[i];
                label.textColor = RGB(127, 127, 127);
                [shareView addSubview:label];
                
                lastView = button;
            }
            
            shareView.contentSize = CGSizeMake(lastView.right+20, 116);//16->20   SHARE_SIZE(92)->116
            
            UIView *lastView2 = nil;
            for (int i = 0; i < 2; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat left = lastView2 ? lastView2.right+20 : 16;//16->20
                
                button.frame = CGRectMake(left, 20, 60,60 );//16->20//SHARE_SIZE(44)->60
                button.tag = YYShareManagerTypeCollect+i;
                [button setImage:[UIImage imageNamed:reportAndCollect[i]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:reportImagePre[i]] forState:UIControlStateHighlighted];
//                [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(shareTypeActions:) forControlEvents:UIControlEventTouchUpInside];
                [collectView addSubview:button];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.left-10, button.bottom+6, button.width+20, 15)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = kFONT(10);
                label.text = title[i];
                label.textColor = RGB(127, 127, 127);
                [collectView addSubview:label];
                
                lastView2 = button;
            }

            collectView.contentSize = CGSizeMake(lastView2.right+20, 116);//16->20  SHARE_SIZE(92)->116
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.backgroundColor = [UIColor whiteColor];
            cancelButton.frame = CGRectMake(0, collectView.bottom, SCREEN_WIDTH, kHEIGHT(43));
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = kFONT(15);
            [cancelButton addTarget:self action:@selector(cancelActions:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:cancelButton];
            
            
            [UIView animateWithDuration:timeInterval animations:^{
                backView.top = SCREEN_HEIGHT - backView.height;
            }];
            
        } else { //不需要收藏和举报
            [UIView animateWithDuration:timeInterval animations:^{
                self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            }];
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 116+kHEIGHT(43)+5)];
            backView.backgroundColor = [UIColor whiteColor];
            backView.tag = backgroundTag;
            [self addSubview:backView];
            
            UIScrollView *shareView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 116+5)];
            shareView.backgroundColor = RGB(235, 235, 235);
            shareView.showsHorizontalScrollIndicator = NO;
            [backView addSubview:shareView];
            
            NSArray *imageNames = @[@"fenxiang_haoyou",@"fenxiang_zhichangshuoshuo",@"fenxiang_weixin",@"fenxiang_pengyouquan",@"fenxiang_QQ",@"fenxiang_QQkongjian",@"fenxiang_xinlang"];
            NSArray * imagePre = @[@"fenxiang_haoyou_pre",@"fenxiang_zhichangshuoshuo_pre",@"fenxiang_weixin_pre",@"fenxiang_pengyouquan_pre",@"fenxiang_QQ_pre",@"fenxiang_QQkongjian_pre",@"fenxiang_xinlang_pre"];
            NSArray *titles = @[@"发送给好友",@"分享到话题",@"分享到微信",@"分享到朋友圈",@"分享到QQ",@"分享到QQ空间",@"分享到新浪"];
            
            UIView *lastView = nil;
            for (int i = 0; i < 7; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat left = lastView ? lastView.right+20 : 16;//16->20
                
                button.frame = CGRectMake(left, 20,60, 60);
                button.tag = YYShareManagerTypeWeiPinFriends+i;
                [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:imagePre[i]] forState:UIControlStateHighlighted];
//                [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(shareTypeActions:) forControlEvents:UIControlEventTouchUpInside];
                [shareView addSubview:button];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.left-10, button.bottom+6, button.width+20, 15)];
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.left, button.bottom+6, button.width, 15)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = kFONT(10);
                label.text = titles[i];
                label.textColor = RGB(127, 127, 127);
                [shareView addSubview:label];
                
                lastView = button;
            }
            
            shareView.contentSize = CGSizeMake(lastView.right+20, 116+5);
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.backgroundColor = [UIColor whiteColor];
            cancelButton.frame = CGRectMake(0, shareView.bottom, SCREEN_WIDTH, kHEIGHT(43));
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = kFONT(15);
            [cancelButton addTarget:self action:@selector(cancelActions:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:cancelButton];
            [UIView animateWithDuration:timeInterval animations:^{
                backView.top = SCREEN_HEIGHT - backView.height;
            }];
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self remove];
}

@end

@implementation YYShareOperation 

+(void)shareToPlatform:(UMSocialPlatformType)platform title:(NSString *)title url:(NSString *)url content:(NSString*)contentStr imageStr:(NSString*)imageString presentController:(UIViewController *)controller status:(void(^)(UMSocialShareResponse*response))Response
{

    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:contentStr thumImage:shareImage];
    //设置网页地址
    shareObject.webpageUrl =url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (error.code == 2009) {
                return ;
            }
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            //分享说说成功时要有提示
            NSString * string = @"speak_id";
            if ([url containsString:string]) {
                NSArray * array = [url componentsSeparatedByString:@"="];
                NSString *idString = array[array.count-1];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSDictionary * dic = @{@"action":@"shareSpeak",@"jobid":idString,@"user_id":kShareModel.userId};
                    NSString * urlStr = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
                    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
                    } failure:^(NSError *error) {
                    }];
                });
            }
            
            
            UMSocialShareResponse*response = nil;
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                response = resp;
            }else{
                response = [[UMSocialShareResponse alloc]init];
                response.message = @"分享成功";
            }
            Response(response);
        }
    }];
}
//+(void)shareToPlatform:(NSString *)platform title:(NSString *)title url:(NSString *)url content:(NSString*)contentStr imageStr:(NSString*)imageString presentController:(UIViewController *)controller status:(void(^)(UMSResponseCode status))status
//{
//    
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"SHARETOOTHERSUCCESS" object:nil];
//    UIImageView * imageView = [[UIImageView alloc]init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
//    UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];//图层 14
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
//    [UMSocialData defaultData].extConfig.qqData.url = url;
//    [UMSocialData defaultData].extConfig.qzoneData.url = url;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
//    [UMSocialData defaultData].extConfig.qqData.title = title;
//    [UMSocialData defaultData].extConfig.qzoneData.title = title;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = title;
//    
//    //contentStr
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[platform] content:contentStr image:shareImage location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity * response){
//        if (status) {
//            status(response.responseCode);
//        }
//        if (response.responseCode == UMSResponseCodeSuccess) {
//        } else if(response.responseCode != UMSResponseCodeCancel) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
//}
@end


