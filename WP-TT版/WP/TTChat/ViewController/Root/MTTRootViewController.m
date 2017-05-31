//
//  MTTRootViewController.m
//  IOSDuoduo
//
//  Created by Michael Scofield on 2014-07-15.
//  Copyright (c) 2014 dujia. All rights reserved.
//

#import "MTTRootViewController.h"
#import "RecentUsersViewController.h"
#import "ContactsViewController.h"
#import "MTTMyViewController.h"
#import "FinderViewController.h"
#import "MTTLoginViewController.h"
#import "MTTSessionEntity.h"
#import <Masonry/Masonry.h>
#import "UIView+PointBadge.h"
#import "UITabBar+SubView.h"
#import "DDUserModule.h"
#import "UIAlertView+Block.h"
#import "DDClientState.h"
#import "WPMeController.h"
#import "WPNearController.h"
#import "WPEmployController.h"
#import "WPMessageController.h"
#import "WPDiscoverController.h"
#import "WPNavigationController.h"
#import "WPHotePositionController.h"
#import "WPTipModel.h"
#import "WPNetState.h"
#import "UITabBar+badge.h"
#import "WPShuoStaticData.h"
#import "WPLoginViewController1.h"
#import "WPRecruitApplyController.h"
#define shuoShuoVideo @"/shuoShuoVideo"
@interface MTTRootViewController ()<UITabBarControllerDelegate,UITabBarDelegate>
@property(assign) NSUInteger clickCount;
@property (nonatomic, copy) NSString *num;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;


@end

@implementation MTTRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//       [[NSNotificationCenter defaultCenter] removeObserver:self name:DDNotificationUserKickouted object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickOffUserNotification:) name:DDNotificationUserKickouted object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:DDNotificationLogout object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signChangeNotification:) name:DDNotificationUserSignChanged object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNoti:) name:@"INVITEGROUP" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadgage) name:@"badgageChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNoti) name:@"CHANGENOTIFICATIONCOUNT" object:nil];
        
    }
    return self;
}
#pragma mark 退出登录时移除通知
-(void)removeNoti
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:DDNotificationUserKickouted object:nil];
}
-(void)changeBadgage
{
  self.num = @"0";
}
-(void)groupNoti:(NSNotification*)noti
{
    NSDictionary * dci = noti.object;
//    if ([dci[@"count"] intValue] || [dci[@"sys_count"] intValue])
//    {
        NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
        self.viewControllers[1].tabBarItem.badgeValue = [self setTabbarBagValue:unreadcount+[dci[@"count"] integerValue]+[dci[@"sys_count"] intValue]];
        

        self.num = [NSString stringWithFormat:@"%d",[dci[@"count"] intValue]+[dci[@"sys_count"] intValue]];
//    }
}

#pragma mark 有网络时上传未完成的说说
-(void)uploadShuoAgain
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdSHUOSHUO"];
    if (array.count) {
        for (NSDictionary * dic in array) {
            
            //判断上传的是不是登录人的说说
            NSArray * keyArray = [dic allKeys];
            NSString * keyString = keyArray[0];
            NSArray * comArray = [keyString componentsSeparatedByString:@"-"];
            NSString * firstString = comArray[0];
            if (![firstString isEqualToString:kShareModel.userId]) {
                continue;
            }
            
            NSArray * array1 = [dic allValues];
            NSArray * array2 = array1[0];
            NSDictionary * dic = array2[1];
            NSString * imageCount = dic[@"imgCount"];
            NSString * videoCount = dic[@"videoCount"];
            int num = 0;
            if (imageCount.intValue) {//有图片
                num = 2;
            }
            else if (videoCount.intValue)
            {
                num = 3;
            }
            else
            {
                num = 1;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
                switch (num) {
                    case 1://文字
                    {
                        [WPHttpTool postWithURL:url params:array2[0] success:^(id json) {
                            //上传成功时删除本地说说
                            [self deleteShuo:json[@"guid"]];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadShuoSuccessAgain" object:nil];
                        } failure:^(NSError *error) {
                        }];
                    }
                        break;
                    case 2://图片
                    {
                        NSMutableArray * muarray = [NSMutableArray array];
                        NSArray * original_photos = dic[@"original_photos"];
                        for (int i = 0 ;i < original_photos.count;i++) {
                            NSDictionary * imageDic = original_photos[i];
                            NSString * media_address = imageDic[@"media_address"];
                            NSData * data = [NSData dataWithContentsOfFile:media_address];
                            WPFormData *formData = [[WPFormData alloc]init];
                            formData.data = data;
                            formData.name = [NSString stringWithFormat:@"photo%d",i+1];
                            formData.filename = [NSString stringWithFormat:@"photo%d.jpg",i+1];
                            formData.mimeType = @"application/octet-stream";
                            [muarray addObject:formData];
                        }
                        [WPHttpTool postWithURL:url params:array2[0] formDataArray:muarray success:^(id json) {
                            if ([json[@"status"] integerValue] == 1) {
                                //发布成功删除数据
                                [self deleteShuo:json[@"guid"]];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadShuoSuccessAgain" object:nil];
                            } else {
                            }
                        } failure:^(NSError *error) {
                        }];
                    }
                        break;
                    default://视频
                    {
                        NSArray * videoArray = dic[@"original_photos"];
                        NSDictionary * videoDic = videoArray[0];
                        NSString *media_address = videoDic[@"media_address"];
                        NSData * videoData = [NSData dataWithContentsOfFile:media_address];
                        
                        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
                        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
                        [manage POST:url parameters:array2[0] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            [formData appendPartWithFileData:videoData name:@"photo1" fileName:@"photo1.mp4" mimeType:@"video/quicktime"];
                        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            [self deleteShuo:dict[@"guid"]];
                            //发布成功若有视频则将数据保存在本地以便进入时使用
                            NSString * urlStr = dict[@"Url"];
                            if (urlStr.length)
                            {
                                urlStr = [IPADDRESS stringByAppendingString:urlStr];
                                NSArray * pathArray = [urlStr componentsSeparatedByString:@"/"];
                                NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
                                NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
                                NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
                                [videoData writeToFile:fileName1 atomically:YES];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadShuoSuccessAgain" object:nil];
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        }];

                    }
                        break;
                }
               
            });
        }
    }
    
    NSArray * myApply = [defaults objectForKey:@"UPLOAdMYAPPLY"];
    if (myApply.count) {
        for (NSDictionary * dic in myApply) {
            NSArray * keyArr = [dic allKeys];
            NSString * string = keyArr[0];
            NSArray * valueArr = [dic allValues];
            NSArray * array1 = valueArr[0];
            NSDictionary * dictionsry = array1[1];
            NSArray * dataArray = dictionsry[@"data"];
            NSDictionary * upDic = array1[0];//上传的json
            NSMutableArray * dataUpArray = [NSMutableArray array];
            for (int i = 0 ;i < dataArray.count;i++) {
                NSDictionary * dataDic = dataArray[i];
                WPFormData * formatter = [[WPFormData alloc]init];
                NSString * media_address = dataDic[@"media_address"];
                NSData * data = [NSData dataWithContentsOfFile:media_address];
                if (!data) {
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:media_address]];
                }
                BOOL isOrNot = [media_address hasSuffix:@".mp4"];
                formatter.data = data;
                formatter.name =  [NSString stringWithFormat:@"PhotoAddress%d",i];
                if (isOrNot) {
                    formatter.filename = [NSString stringWithFormat:@"PhotoAddress%d.mp4",i];
                    formatter.mimeType = @"video/quicktime";
                }
                else
                {
                    formatter.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
                    formatter.mimeType = @"image/png";
                }
                [dataUpArray addObject:formatter];
            }
            NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WPHttpTool postSingleWithURL:str params:upDic formDataArray:dataUpArray success:^(id json) {
                    if (![json[@"status"] integerValue]) {
                        [self deleteMyApply:[NSString stringWithFormat:@"%@",string]];
                        NSDictionary * dic = @{@"guid":json[@"guid"],@"resume_id":json[@"resume_id"],@"time":json[@"time"]};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadMyApplySuccess" object:dic];
                    }
                } failure:^(NSError * error) {
                }];
            });
        }
    }
    
    
    NSArray * myWantArray = [defaults objectForKey:@"UPLOAdMYWANT"];
    if (myWantArray.count) {
        for (NSDictionary * dic in myWantArray) {
            NSArray * keyArr = [dic allKeys];
            NSString * string = keyArr[0];
            NSArray * valueArr = [dic allValues];
            NSArray * array1 = valueArr[0];
            NSDictionary * dictionsry = array1[1];
            NSArray * dataArray = dictionsry[@"data"];
            NSDictionary * upDic = array1[0];//上传的json
            NSMutableArray * dataUpArray = [NSMutableArray array];
            for (int i = 0 ;i < dataArray.count;i++) {
                NSDictionary * dataDic = dataArray[i];
                WPFormData * formatter = [[WPFormData alloc]init];
                NSString * media_address = dataDic[@"media_address"];
                NSData * data = [NSData dataWithContentsOfFile:media_address];
                if (!data) {
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:media_address]];
                }
                BOOL isOrNot = [media_address hasSuffix:@".mp4"];
                formatter.data = data;
                formatter.name =  [NSString stringWithFormat:@"PhotoAddress%d",i];
                if (isOrNot) {
                    formatter.filename = [NSString stringWithFormat:@"PhotoAddress%d.mp4",i];
                    formatter.mimeType = @"video/quicktime";
                }
                else
                {
                    formatter.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
                    formatter.mimeType = @"image/png";
                }
                [dataUpArray addObject:formatter];
            }
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WPHttpTool postSingleWithURL:url params:upDic formDataArray:dataUpArray success:^(id json) {
                    if (![json[@"status"] integerValue]) {
                        [self deleteMyWant:[NSString stringWithFormat:@"%@",string]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
                        });
                    }
                } failure:^(NSError * error) {
                }];
            });
        }
    }
}

-(void)deleteMyWant:(NSString*)guid
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYWANT"];
    NSMutableArray *muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    for (NSDictionary * dic in array) {
        if (dic[guid])
        {
            NSArray * array = dic[guid];
            NSDictionary * diction = array[1];
            NSArray * dataArray = diction[@"data"];
            for (NSDictionary * dictionary  in dataArray) {
                NSString *media_address = dictionary[@"media_address"];
                [[NSFileManager defaultManager] removeItemAtPath:media_address error:nil];
            }
            [muarray removeObject:dic];
        }
    }
    array = [NSArray arrayWithArray:muarray];
    [defaults setObject:array forKey:@"UPLOAdMYWANT"];
    
}

-(void)deleteMyApply:(NSString*)guid
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYAPPLY"];
    NSMutableArray *muarray = [NSMutableArray new];
    [muarray addObjectsFromArray:array];
    for (NSDictionary * dic in array) {
        if (dic[guid])
        {
            NSArray * array = dic[guid];
            NSDictionary * diction = array[1];
            NSArray * dataArray = diction[@"data"];
            for (NSDictionary * dictionary  in dataArray) {
                NSString *media_address = dictionary[@"media_address"];
                [[NSFileManager defaultManager] removeItemAtPath:media_address error:nil];
            }
            [muarray removeObject:dic];
        }
    }
    array = [NSArray arrayWithArray:muarray];
    [defaults setObject:array forKey:@"UPLOAdMYAPPLY"];
}
-(void)deleteShuo:(NSString*)string
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdSHUOSHUO"];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    for (NSDictionary * dic  in array) {
        if (dic[string]) {
//            NSArray* array1 = dic[string];
//            NSDictionary * dicionary = array1[1];
//            NSArray * original_photos = dicionary[@"original_photos"];
//            NSString * videoCount = dicionary[@"videoCount"];
//            if (original_photos.count||videoCount.intValue) {//移除图片数据
//                for (NSDictionary * diction in original_photos) {
//                    NSString * media_address = diction[@"media_address"];
//                    [[NSFileManager defaultManager] removeItemAtPath:media_address error:nil];
//                }
//            }
            [muarray removeObject:dic];
        }
    }
    array = [NSArray arrayWithArray:muarray];
    [defaults setObject:array forKey:@"UPLOAdSHUOSHUO"];
}


-(void)receiveNoti
{
    //WPHotePositionController *contactVC1 =[WPHotePositionController new];
    self.selectedIndex = 1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti) name:@"RECEIVENOTIFICATION" object:nil];
    //网络状态变化时是否需要上传
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadShuoAgain) name:@"UPLOADSHUOSHUOAGAIN" object:nil];
    //进入时判断网络，上传未上传的数据
   NSString *netString = [[WPNetState shareNet] networkingStatesFromStatebar];
    if (netString.intValue) {
        [self uploadShuoAgain];
    }
    
    RecentUsersViewController *recentVC1= [RecentUsersViewController shareInstance];
    WPNavigationController *recentVC = [[WPNavigationController alloc] initWithRootViewController:recentVC1];
    UIImage* conversationSelected = [[UIImage imageNamed:@"tab_xiaoxi_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//tabbar_message_backgound
    recentVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"tab_xiaoxi"] selectedImage:conversationSelected];//tabbar_message
    recentVC.tabBarItem.tag=100;
    [recentVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(0, 172, 255) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];//RGB(26, 140, 242)
    recentVC.hidesBottomBarWhenPushed =YES;
    
    
    
    UIImage* contactSelected = [[UIImage imageNamed:@"tab_zhuye_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//tabbar_near_backgound
    WPHotePositionController *contactVC1 =[WPHotePositionController new];
    WPNavigationController *contactVC = [[WPNavigationController alloc] initWithRootViewController:contactVC1];
    contactVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_zhuye"] selectedImage:contactSelected];//tabbar_near
    contactVC.tabBarItem.tag=101;
    [contactVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(0, 172, 255) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    contactVC.hidesBottomBarWhenPushed =YES;
    
    
    
    UIImage* findSelected = [[UIImage imageNamed:@"tab_faxian_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//tabbar_discover_backgound
    WPDiscoverController *findVC1 =[[WPDiscoverController alloc] init];
    WPNavigationController *findVC = [[WPNavigationController alloc] initWithRootViewController:findVC1];
    findVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tab_faxian"] selectedImage:findSelected];//tabbar_discover
    findVC.tabBarItem.tag = 102;
    [findVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(0, 172, 255) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    findVC.hidesBottomBarWhenPushed =YES;
    
    
    
    UIImage* myProfileSelected = [[UIImage imageNamed:@"tab_quanzhi_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//tabbar_employ_backgound
    WPEmployController *myVC1 =[WPEmployController new];
    WPNavigationController *myVC = [[WPNavigationController alloc] initWithRootViewController:myVC1];
    myVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"全职" image:[UIImage imageNamed:@"tab_quanzhi"] selectedImage:myProfileSelected];//tabbar_employ
    myVC.tabBarItem.tag=103;
    [myVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(0, 172, 255) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    myVC.hidesBottomBarWhenPushed =YES;
    
    
    
    UIImage* meSelected = [[UIImage imageNamed:@"tab_geren_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//tabbar_me_backgound
    WPMeController *me1 =[WPMeController new];
    WPNavigationController *me = [[WPNavigationController alloc] initWithRootViewController:me1];
    me.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人" image:[UIImage imageNamed:@"tab_geren"] selectedImage:meSelected];//tabbar_me
    me.tabBarItem.tag=104;
    [me.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(0, 172, 255) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    me.hidesBottomBarWhenPushed =YES;
    
    
//    self.viewControllers=@[recentVC,contactVC,findVC,myVC,me];
    self.viewControllers=@[contactVC,recentVC,findVC,myVC,me];
    self.delegate=self;
    self.title=APP_NAME;
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = RGB(247, 247, 247);
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

#pragma mark - 新消息提醒
- (void)messageTip
{
    WPTipModel *model = [WPTipModel sharedManager];
    NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
    
    int num = model.ReMsgCount.intValue+model.jobMsgCount.intValue+model.ReSchoolCount.intValue+model.JobSchoolCount.intValue;
    if (self.num.intValue)
    {
        if (self.num.intValue>99) {
             [self.tabBar showBadgeOnItemIndex:1];
            self.viewControllers[1].tabBarItem.badgeValue = @"";
        }
        else
        {
           [self.tabBar hideBadgeOnItemIndex:1];
           self.viewControllers[1].tabBarItem.badgeValue = [self setTabbarBagValue:unreadcount+self.num.integerValue];
        }
       //self.viewControllers[0].tabBarItem.badgeValue = [self setTabbarBagValue:unreadcount+self.num.integerValue];
    }
    else
    {
//     self.viewControllers[0].tabBarItem.badgeValue = [self setTabbarBagValue:unreadcount];
        if (unreadcount > 99)
        {
            self.viewControllers[1].tabBarItem.badgeValue = nil;
            [self.tabBar showBadgeOnItemIndex:1];
        }
        else
        {
         self.viewControllers[1].tabBarItem.badgeValue = [self setTabbarBagValue:unreadcount];
        }
    }
    
    //发现
    self.viewControllers[2].tabBarItem.badgeValue = [self setTabbarBagValue:[model.speak integerValue]];
    if ([model.speak isEqualToString:@"0"] && model.avatar.length > 0) {
        [self.tabBar showBadgeOnItemIndex:2];
    } else {
        [self.tabBar hideBadgeOnItemIndex:2];
    }
    if (model.speak.intValue > 99) {
        self.viewControllers[2].tabBarItem.badgeValue = nil;
        [self.tabBar showBadgeOnItemIndex:2];
    }
    
    //全职
    if ((num < 1)&&((model.re_avatar.length>0)||(model.re_com_avatar.length>0)||(model.job_avatar.length>0)||(model.job_com_avatar.length>0)))
    {
        self.viewControllers[3].tabBarItem.badgeValue = nil;
        [self.tabBar showBadgeOnItemIndex:3];
    }
    else
    {
        [self.tabBar hideBadgeOnItemIndex:3];
    }
    if (num>=1) {
         [self.tabBar hideBadgeOnItemIndex:3];
        self.viewControllers[3].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num];
    }
    else
    {
        self.viewControllers[3].tabBarItem.badgeValue = nil;
    }
   
    if (num>99) {
        self.viewControllers[3].tabBarItem.badgeValue = nil;
        [self.tabBar showBadgeOnItemIndex:3];
    }
    
    //个人
    int PICount = model.re_UnReadCount.intValue+model.job_UnReadCount.intValue;
    if (PICount) {
        if (PICount<=99) {
            self.viewControllers[4].tabBarItem.badgeValue = [self setTabbarBagValue:PICount];
        }
        else
        {
            [self.tabBar showBadgeOnItemIndex:4];
        }
    }
    else
    {
       self.viewControllers[4].tabBarItem.badgeValue = nil;
        [self.tabBar hideBadgeOnItemIndex:4];
    }
    
}
- (NSString *)setTabbarBagValue:(NSInteger)count
{
    if (count !=0) {
        if (count > 99)
        {
            return @"···";//99+
        }
        else
        {
             return [NSString stringWithFormat:@"%ld",(long)count];
        }
    }else
    {
        //        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        return nil;
    }

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton =YES;
    self.navigationController.navigationBarHidden =NO;
    BOOL update = [TheRuntime.updateInfo[@"haveupdate"] boolValue];
    if (![MTTUtil isUseFunctionBubble] || update) {
        UIImageView *imgView =[self.tabBar tabBarButtonImageViewWithTitle:@"我"];
        [imgView showPointBadge:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    UIImageView *imgView =[self.tabBar tabBarButtonImageViewWithTitle:@"我"];
    BOOL update = [TheRuntime.updateInfo[@"haveupdate"] boolValue];
    if (![MTTUtil isUseFunctionBubble] || update) {
        UIView *pointBadgeView =[imgView pointBadgeView];
        if (![[self.tabBar.superview subviews] containsObject:pointBadgeView]) {
            CGRect rect =[imgView convertRect:pointBadgeView.frame toView:self.tabBar.superview];
            pointBadgeView.frame =rect;
            [self.tabBar.superview addSubview:pointBadgeView];
        }
    }
    else{
        [imgView removePointBadge:YES];
    }
}

#pragma mark -


#pragma mark - 退出登录和被踢登录 通知

-(void)logoutNotification:(NSNotification*)notification{

    [MTTUtil loginOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)kickOffUserNotification:(NSNotification*)notification
{
    //防止多次提醒
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDNotificationUserKickouted object:nil];
    DDClientState* clientState = [DDClientState shareInstance];
    clientState.userState = DDUserKickout;
    [[NSUserDefaults standardUserDefaults] setObject:@(false) forKey:@"autologin"];
    [MTTUtil loginOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changIsFrom" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"dismissRoot"];
    
    //清除静态数据
    WPShuoStaticData * dataShuo = [WPShuoStaticData shareShuoData];
    [dataShuo clearContent];
    
    WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
    login.isFromKick = YES;
    WPNavigationController *myVC = [[WPNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:myVC animated:YES completion:nil];
}

-(void)signChangeNotification:(NSNotification*)notification
{
    NSString *sign = [[notification object] objectForKey:@"sign"];
    NSString* uid = [[notification object] objectForKey:@"uid"];
    NSString* sessionId = [MTTUserEntity pbUserIdToLocalID:[uid integerValue]];
    [[DDUserModule shareInstance] getUserForUserID:sessionId Block:^(MTTUserEntity *user) {
        user.signature = sign;
    }];
    
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    [tabBar.items indexOfObject:item]
    
    if (item.tag ==100)
    {
        self.clickCount=self.clickCount+1;
        if (self.clickCount==2) {
            if ([[[RecentUsersViewController shareInstance].tableView visibleCells] count] > 0)
            {
                __block BOOL allStop = NO;
                [[RecentUsersViewController shareInstance].items enumerateObjectsUsingBlock:^(MTTSessionEntity *obj, NSUInteger idx, BOOL *stop) {
                    if (obj.unReadMsgCount) {
                        [[RecentUsersViewController shareInstance].tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        *stop = YES;
                        allStop = YES;
                    }
                }];
                if(!allStop){
                    [[RecentUsersViewController shareInstance].tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            self.clickCount=0;
        }
    }else{
        self.clickCount=0;
    }
}

#pragma mark - memory manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    self.navigationController.navigationBarHidden
}

-(void)dealloc{

    self.navigationController.interactivePopGestureRecognizer.delegate =nil;
}

@end
