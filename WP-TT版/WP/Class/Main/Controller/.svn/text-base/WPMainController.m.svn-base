
#import "WPMainController.h"

#import "WPMeController.h"
#import "WPNearController.h"
#import "WPEmployController.h"
#import "WPMessageController.h"
#import "WPDiscoverController.h"
#import "WPTabBar.h"
#import "WPNavigationController.h"
#import "WPHotePositionController.h"
#import "RecentUsersViewController.h"
#import "MTTSessionEntity.h"
#import "DDClientState.h"
#import "UIAlertView+Block.h"
#import "WPLoginViewController1.h"
@interface WPMainController ()<WPTabBarDelegate,UITabBarDelegate>

@property(assign) NSUInteger clickCount;

@end

@implementation WPMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickOffUserNotification:) name:DDNotificationUserKickouted object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:DDNotificationLogout object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signChangeNotification:) name:DDNotificationUserSignChanged object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    // Do any additional setup after loading the view.
//    
//    // 初始化tabbar
////    [self setupTabbar];
////    
////    // 初始化所有的子控制器
////    [self setupAllChildViewControllers];
//    
//    
//    [self createViewControllers];
//    [self createTabBarItems];
//    
//    //设置导航看主题  背景
//    //UINavigationBar *navBar = [UINavigationBar appearance];
//    //[navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
//    //[navBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
//    //用default;
//    //设置导航看主题  字体
//   // NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//   // dict[NSForegroundColorAttributeName] = [UIColor blackColor];
//    //[navBar setTitleTextAttributes:dict];    //设置导航看主题  字体
//   //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

}

//-(void)viewWillLayoutSubviews{
//    
//    [super viewWillLayoutSubviews];
//    
//    for (UIView *child in self.tabBar.subviews) {
//        
//        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            
//            [child removeFromSuperview];
//            
//        }
//        
//    }
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated
//
//{
//    
//    // 删除系统自动生成的UITabBarButton
//    
//    for (UIView *child in self.tabBar.subviews) {
//        
//        if ([child isKindOfClass:[UIControl class]]) {
//            
//            [child removeFromSuperview];
//            
//        }
//        
//    }
//    
//    [super viewWillAppear:animated];
//    
//}


//- (void)setupTabbar
//{
//    WPTabBar *customTabBar = [[WPTabBar alloc] init];
//    customTabBar.frame = self.tabBar.bounds;
//    customTabBar.delegate = self;
//    [self.tabBar addSubview:customTabBar];
//    self.customTabBar = customTabBar;
//}
//
//- (void)tabBar:(WPTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
//{
//    self.selectedIndex = to;
//}
//
//- (void)createTabBarItems
//{
//    //被选择状态的图片
//    NSArray *selectArray = @[@"tab_xiaoxi_pre",@"tab_hangye_pre",@"tab_faxian_pre",@"tab_quanzhi_pre",@"tab_geren_pre"];
//    //选择状态的图片
//    NSArray *unSelectarray = @[@"tab_xiaoxi",@"tab_hangye",@"tab_faxian",@"tab_quanzhi",@"tab_geren"];
//    //文字
//    NSArray *titleArray = @[@"消息",@"行业",@"发现",@"全职",@"个人"];
//    //获取所有的item
//    NSArray *allItems = self.tabBar.items;
//    for (int i = 0; i < allItems.count; i++) {
//        UITabBarItem *item = allItems[i];
//        UIImage *selectImage = [UIImage imageNamed:selectArray[i]];
//        UIImage *unselectImage = [UIImage imageNamed:unSelectarray[i]];
//        item = [item initWithTitle:titleArray[i] image:unselectImage selectedImage:selectImage];
//    }
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:IWTabBarButtonTitleColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:11.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:IWTabBarButtonTitleSelectedColor, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:11.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
//}
//
//- (void)createViewControllers
//{
////    WPMessageController *message = [[WPMessageController alloc]init];
////    message.title = @"消息";
////    WPNavigationController *nc1 = [[WPNavigationController alloc] initWithRootViewController:message];
//    RecentUsersViewController *message = [[RecentUsersViewController alloc] init];
////    message.title = @"消息";
//    WPNavigationController *nc1 = [[WPNavigationController alloc] initWithRootViewController:message];
//    
//    WPHotePositionController *near = [[WPHotePositionController alloc]init];
//    near.title = @"行业";
//    WPNavigationController *nc2 = [[WPNavigationController alloc] initWithRootViewController:near];
//    
//    WPDiscoverController *discover = [[WPDiscoverController alloc]init];
//    discover.title = @"发现";
//    WPNavigationController *nc3 = [[WPNavigationController alloc] initWithRootViewController:discover];
//    
//    WPEmployController *employ = [[WPEmployController alloc]init];
//    employ.title = @"全职";
//    WPNavigationController *nc4 = [[WPNavigationController alloc] initWithRootViewController:employ];
//    
//    WPMeController *me = [[WPMeController alloc]init];
//    me.title = @"个人";
//    WPNavigationController *nc5 = [[WPNavigationController alloc] initWithRootViewController:me];
//    
//    self.viewControllers = @[nc1,nc2,nc3,nc4,nc5];
//}
//
//
//- (void)setupAllChildViewControllers
//{
//    
//    WPMessageController *message = [[WPMessageController alloc]init];
////    message.tabBarItem.badgeValue = @"1";
//    [self setupChildViewController:message title:@"消息" imageName:@"tab_xiaoxi" selectedImageName:@"tab_xiaoxi_pre"];//tabbar_message//tabbar_message_backgound
//    
//    
//    WPHotePositionController *near = [[WPHotePositionController alloc]init];
////    near.tabBarItem.badgeValue = @"15";
//    [self setupChildViewController:near title:@"行业" imageName:@"tab_hangye" selectedImageName:@"tab_hangye_pre"];//tabbar_near////tabbar_near_backgound
//    
//    WPDiscoverController *discover = [[WPDiscoverController alloc]init];
//   
//    [self setupChildViewController:discover title:@"发现" imageName:@"tab_faxian" selectedImageName:@"tab_faxian_pre"];//tabbar_discover//tabbar_discover_backgound
//    
//    WPEmployController *employ = [[WPEmployController alloc]init];
//    
//    [self setupChildViewController:employ title:@"全职" imageName:@"tab_quanzhi" selectedImageName:@"tab_quanzhi_pre"];//tabbar_employ//tabbar_employ_backgound
//    
//    WPMeController *me = [[WPMeController alloc]init];
//    
//    [self setupChildViewController:me title:@"个人" imageName:@"tab_geren" selectedImageName:@"tab_geren_pre"];//tabbar_me//tabbar_me_backgound
//    
//}
//
//- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
//{
//    
////    UIImage* findSelected = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//tabbar_discover_backgound
////    WPNavigationController *findVC = [[WPNavigationController alloc] initWithRootViewController:childVc];
////    findVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:findSelected];//tabbar_discover
////    findVC.tabBarItem.tag = 102;
////    [findVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(26, 140, 242) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
////    findVC.hidesBottomBarWhenPushed =YES;
////    [self addChildViewController:findVC];
////    self.tabBar.translucent = NO;
////    self.tabBar.barTintColor = RGB(247, 247, 247);
////    [self.customTabBar addTabBarButtonWithItem:findVC.tabBarItem];
//    
//    childVc.title = title;
//    childVc.tabBarItem.image = [[UIImage imageWithName:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
//    if (iOS7) {
//        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    } else {
//        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
//    WPNavigationController *nav = [[WPNavigationController alloc] initWithRootViewController:childVc];
//    [self addChildViewController:nav];
//    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
//}
//
//#pragma mark - 退出登录和被踢登录 通知
//
//-(void)logoutNotification:(NSNotification*)notification{
//    [MTTUtil loginOut];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//-(void)kickOffUserNotification:(NSNotification*)notification
//{
//    DDClientState* clientState = [DDClientState shareInstance];
//    clientState.userState = DDUserKickout;
////    [[NSUserDefaults standardUserDefaults] setObject:@(false) forKey:@"autologin"];
//    [MTTUtil loginOut];
////    [self.navigationController popToRootViewControllerAnimated:YES];
//    UIAlertView *alert =[UIAlertView alertWithTitle:@"提示" message:@"该账号已在其他地方登录!请检查账号是否安全!" buttonIndex:^(NSInteger index){
//
//        WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
//        WPNavigationController * navc = [[WPNavigationController alloc]initWithRootViewController:login];
//        login.isFromQuit = YES;
//        [self presentViewController:navc animated:YES completion:NULL];
//    } cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//}
//- (UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    
//    return result;
//}
//-(void)signChangeNotification:(NSNotification*)notification
//{
////    NSString *sign = [[notification object] objectForKey:@"sign"];
////    NSString* uid = [[notification object] objectForKey:@"uid"];
////    NSString* sessionId = [MTTUserEntity pbUserIdToLocalID:[uid integerValue]];
////    [[DDUserModule shareInstance] getUserForUserID:sessionId Block:^(MTTUserEntity *user) {
////        user.signature = sign;
////    }];
//    
//}
//
//#pragma mark - UITabBarDelegate
//
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    //    [tabBar.items indexOfObject:item]
//    
//    if (item.tag ==100)
//    {
//        self.clickCount=self.clickCount+1;
//        if (self.clickCount==2) {
//            if ([[[RecentUsersViewController shareInstance].tableView visibleCells] count] > 0)
//            {
//                __block BOOL allStop = NO;
//                [[RecentUsersViewController shareInstance].items enumerateObjectsUsingBlock:^(MTTSessionEntity *obj, NSUInteger idx, BOOL *stop) {
//                    if (obj.unReadMsgCount) {
//                        [[RecentUsersViewController shareInstance].tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                        *stop = YES;
//                        allStop = YES;
//                    }
//                }];
//                if(!allStop){
//                    [[RecentUsersViewController shareInstance].tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                }
//            }
//            self.clickCount=0;
//        }
//        
//    }else{
//        self.clickCount=0;
//    }
//    
//}


@end
