//
//  AppDelegate.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "AppDelegate.h"
#import "WPMainController.h"
#import "WPLoginViewController.h"
#import "WPNavigationController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LinkmanInfoModel.h"
#import "correctLocation.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "LoginModel.h"
#import "WPTipModel.h"
#import "MTTLoginViewController.h"
#import "ChattingMainViewController.h"
#import "DDClientStateMaintenanceManager.h"
#import "SessionModule.h"
#import "NSDictionary+Safe.h"
#import "WPLoginViewController1.h"
#import "MTTRootViewController.h"
#define BuglyAppId @"900011590"
#import <UMSocialCore/UMSocialCore.h>
#import "JPUSHService.h"
#ifdef  NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "RSSocketClinet.h"
@interface AppDelegate ()<CLLocationManagerDelegate,JPUSHRegisterDelegate>
{
    CLLocationManager *_locationManager;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, copy)NSString* notiCount;
@property (nonatomic, assign)NSInteger groupCount;

@end

@implementation AppDelegate
// FIXME: 改回启动时间3秒
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ============ Teamtalk ==================================
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"notShowDisconnect"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notShowDisconnect"];
    }
    //启动页出现时间
    
    [NSThread sleepForTimeInterval:0];
    [DDClientStateMaintenanceManager shareInstance];
    [RuntimeStatus instance];
    
    //获取通讯录
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self address];
    });
    
    //极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
       // 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
       // categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
//            NSLog(@"registrationID获取成功：%@",registrationID);
            //只能在主线程中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
                LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:dictionary];
                WPShareModel* model= [WPShareModel sharedModel];
                model.dic=loginModel.list[0];
                NSString * string = [NSString stringWithFormat:@"0^%@^%@^123456",model.dic[@"userid"],registrationID];
                
                RSSocketClinet *socketClinet = [RSSocketClinet sharedSocketClinet];
                socketClinet.loginString = string;
                //socket连接前先断开连接以免之前socket连接没有断开导致闪退
                [socketClinet cutOffSocket];
                socketClinet.disConnectResaon = SocketDidDisConnectReasonByServer;
                [socketClinet connectServer];
            });
        }
        else{
            //NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

    [MAMapServices sharedServices].apiKey = @"eb9761d4882a35c670410b580bfa2a50";
   
#pragma mark - Bugly
    //bugly
   //  [[CrashReporter sharedInstance] enableLog:YES];
//    [[CrashReporter sharedInstance] installWithAppId:BuglyAppId];
    
#pragma mark - UMengShare
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAppkey];
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9a900ddea2978aaf" appSecret:@"b87941834e96d62bc8d22fef37aa21f6" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105053734"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //设置新浪的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2218584927"  appSecret:@"95758cac4d0c892cf8d8eb3b566fd96f" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //定位
     [self setupLocationManager];
   
    
    application.statusBarHidden = NO;
    self.window.backgroundColor=[UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //初始化根控制器
    [self initBaseController];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark 获取通讯录权限
- (void)address
{
    //dataSource = [[NSMutableArray alloc] init];
    //NSMutableArray *contactsdata= [[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
   
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        LinkmanInfoModel *addressBook = [[LinkmanInfoModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.telephone = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}


-(void)getGroupInvit
{
    NSDictionary * dictionary = @{@"action":@"get_groupMemCount",@"user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/msgcount.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
        self.notiCount = [NSString stringWithFormat:@"%ld",[json[@"count"] integerValue]+[json[@"sys_count"] integerValue]];
        NSString * content = [NSString stringWithFormat:@"%@",json[@"content"]];
        if (content.length)
        {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"INVITEGROUP" object:json];
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"INVITEGROUP" object:json];
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 请求消息提醒
- (void)requestMessageTips
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/msg/msgcount.ashx"];
    NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
    LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:dictionary];
    WPShareModel* model=[WPShareModel sharedModel];
    model.dic=loginModel.list[0];
    model.userId = model.dic[@"userid"];
    model.username = model.dic[@"user_name"];
    model.nick_name = model.dic[@"nick_name"];
    NSDictionary *params = @{@"action" : @"get_count",
                             @"user_id" : model.userId,
                             @"user_name" : model.username,
                             @"password":kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        WPTipModel *model = [WPTipModel sharedManager];
        model = [WPTipModel mj_objectWithKeyValues:json];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GlobalMessageTip" object:nil];
        if ([json[@"status"] isEqualToString:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_user_kick_out" object:nil];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)initBaseController{
    //设置引导界面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
//  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {//不是第一次登陆
        // 获得队列
        dispatch_queue_t queue = dispatch_get_main_queue();
        // 创建一个定时器(dispatch_source_t本质还是个OC对象)
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
        // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
        // 何时开始执行第一个任务
        // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, start, interval, 0);
        // 设置回调
        dispatch_source_set_event_handler(self.timer, ^{
            [self requestMessageTips];
            [self getGroupInvit];
        });
        // 启动定时器
        dispatch_resume(self.timer);

    
//    }
    NSString * isFirstOrNot = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOrNot"];
    if (![isFirstOrNot isEqualToString:@"1"]) {//第一次安装
        WPLoginViewController* root=[[WPLoginViewController alloc] init];
        WPNavigationController* nav=[[WPNavigationController alloc] initWithRootViewController:root];
        self.window.rootViewController = nav;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FIRSTLOADSESSION"];
    }
    else
    {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {//退出账号再次登陆
        WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
         WPNavigationController* nav=[[WPNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = nav;
    }else{
        //直接进入
        NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
        LoginModel *loginModel = [LoginModel objectWithKeyValues:dictionary];
        WPShareModel* model=[WPShareModel sharedModel];
        model.dic=loginModel.list[0];
        model.userId = model.dic[@"userid"];
        model.username = model.dic[@"user_name"];
        model.nick_name = model.dic[@"nick_name"];
        model.password = [USER_DEFAULT objectForKey:@"LOGINPASSWORD"];
        MTTRootViewController* vc=[[MTTRootViewController alloc] init];
        self.window.rootViewController = vc;
    }
  }
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (void)setupLocationManager{
    //定位管理器
    _geoCoder = [[CLGeocoder alloc] init];
    _locationManager=[[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的定位还没有开启,请在 设置-隐私 中打开定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        //        return;
    } else {
        if (SYSTEM_VERSION >= 8.0) {
            //如果没有授权则请求用户授权
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                //设置代理
                _locationManager.delegate = self;
                //设置定位精度
                _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//kCLLocationAccuracyNearestTenMeters
                //定位频率,每隔多少米定位一次
                CLLocationDistance distance = 50.f;//十米定位一次
                _locationManager.distanceFilter = distance;
                //启动跟踪定位
                if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [_locationManager startUpdatingLocation];
                }
//                [_locationManager startUpdatingLocation];
            }
        } else {
            _locationManager.delegate = self;
            //设置定位精度
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//kCLLocationAccuracyNearestTenMeters
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance = 50.f;//十米定位一次
            _locationManager.distanceFilter = distance;
            //启动跟踪定位
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager startUpdatingLocation];
            }
//            [_locationManager startUpdatingLocation];
        }
    }
}
-(void)applicationDidBecomeActive:(UIApplication *)application
{
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"notShowDisconnect"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notShowDisconnect"];
//    }
    
    
   
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出最后个位置
    
    CLLocation *sureLocation = [correctLocation transformToMars:location];
    
    CLLocationCoordinate2D coordinate = sureLocation.coordinate;//位置坐标
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [user setObject:longitude forKey:@"longitude"];
    [user setObject:latitude forKey:@"latitude"];
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark 根据坐标取得地名
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary[@"FormattedAddressLines"][0]);
//        NSLog(@"\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n%@\n%@\n%@",
//                    placemark.country,
//                    placemark.postalCode,
//                    placemark.ISOcountryCode,
//                    placemark.administrativeArea,
//                    placemark.subAdministrativeArea,
//                    placemark.locality,
//                    placemark.subLocality,
//                    placemark.thoroughfare,
//                    placemark.subThoroughfare,
//              placemark.name,
//              placemark.inlandWater,
//              placemark.ocean);
        NSArray *location = [[NSArray alloc] initWithObjects:placemark.administrativeArea,placemark.locality,placemark.subLocality, nil];
        NSString *area = [location componentsJoinedByString:@"|"];
        NSArray * detailArray = [[NSArray alloc]initWithObjects:placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality, nil];
        NSString * areaStr = [detailArray componentsJoinedByString:@""];
        //将定位的省市保存
        if (detailArray.count)
        {
           [[NSUserDefaults standardUserDefaults] setObject:detailArray[2] forKey:@"localCity"];
            [[NSUserDefaults standardUserDefaults] setObject:detailArray[1] forKey:@"localPrivince"];
        }
        NSString * allString = placemark.addressDictionary[@"FormattedAddressLines"][0];
        NSString *adress = [NSString stringWithFormat:@"%@",placemark.addressDictionary[@"FormattedAddressLines"][0]];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:area forKey:@"area"];
        NSRange range = [adress rangeOfString:@"省"];
        if (range.length >0) {
            NSString *subString = [adress substringFromIndex:range.location + 1];
            [user setObject:subString forKey:@"adress"];
            [user setObject:[allString stringByReplacingOccurrencesOfString:areaStr withString:@""] forKey:@"detailAdress"];
        }
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
-(void)removeNotExitGroup
{
    //请求不存在的群组的id
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSString * sessionStr = nil;
    for (MTTSessionEntity * sesion in array)
    {
        if (sesion.sessionType == SessionTypeSessionTypeGroup)
        {
            if (sessionStr.length)
            {
                sessionStr = [NSString stringWithFormat:@"%@,%@",sessionStr,[sesion.sessionID componentsSeparatedByString:@"_"][1]];
            }
            else
            {
                sessionStr = [NSString stringWithFormat:@"%@",[sesion.sessionID componentsSeparatedByString:@"_"][1]];
            }
        }
    }
    NSDictionary * dic = @{@"action":@"groupIsDel",@"GroupID":sessionStr};
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/getmsg.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * unExitStr = json[@"List"];
        NSArray * unExitArray = [unExitStr componentsSeparatedByString:@","];
        for (NSString * sessionID in unExitArray)
        {
            if (sessionID.length)
            {
                [[SessionModule instance] removeSessionById:[NSString stringWithFormat:@"group_%@",sessionID] succecc:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //========== 当应用进入后台， 记录未读消息 显示badge  =============//sys_count
    NSUInteger count = [[SessionModule instance] getAllUnreadMessageCount];
    count += self.notiCount.integerValue;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"enterBackGround"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"myApply"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"myWant"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"scrollerY"];
    
//    if ([[SessionModule instance]getAllUnreadMessageCount] == 0) {
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    }else{
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[SessionModule instance]getAllUnreadMessageCount]];
//    }
    
//    RSSocketClinet *socketClinet = [RSSocketClinet sharedSocketClinet];
//    [socketClinet cutOffSocket];
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSString *deviceTokenStr = [[[[deviceToken description]  stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
//                                stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
//    NSString *dt = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    NSString *dn = [dt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    TheRuntime.pushToken= [dn stringByReplacingOccurrencesOfString:@" " withString:@""];
//    TheRuntime.pushToken = deviceTokenStr;
    [JPUSHService registerDeviceToken:deviceToken];
}

//注册推送失败
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"获取令牌失败:  %@",error_str);
}
// 处理推送消息
//点击推送的横幅处理数据
//iOS10
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
//    completionHandler();
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVENOTIFICATION" object:nil];
//    
//}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    completionHandler();
     [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVENOTIFICATION" object:nil];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVENOTIFICATION" object:nil];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVENOTIFICATION" object:nil];
       UIApplicationState state =application.applicationState;
    if (state != UIApplicationStateBackground) {
        return;
    }
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVENOTIFICATION" object:nil];
    
//    if ( state != UIApplicationStateBackground) {
//        return;
//    }
//    NSString *jsonString = [userInfo safeObjectForKey:@"custom"];
//    NSData* infoData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
//    NSInteger from_id =[[info safeObjectForKey:@"from_id"] integerValue];
//    SessionType type = (SessionType)[[info safeObjectForKey:@"msg_type"] integerValue];
//    NSInteger group_id =[[info safeObjectForKey:@"group_id"] integerValue];
//    if (from_id) {
//       NSInteger sessionId = type==1?from_id:group_id;
//        MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:[MTTUtil changeOriginalToLocalID:(UInt32)sessionId SessionType:(int)type] type:type] ;
//        [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
//    }
}


@end
