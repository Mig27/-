

#import "WPNavigationController.h"

@interface WPNavigationController ()

@end

@implementation WPNavigationController


+ (void)initialize
{
    [self setupNavBarTheme];
    [self setupBarButtonItemTheme];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem* item = [UIBarButtonItem appearance];

    if (!iOS7) {
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
   
    NSMutableDictionary* textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = iOS7 ? [UIColor blackColor] : [UIColor grayColor];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
//    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:iOS7 ? 14 : 12];
    textAttrs[UITextAttributeFont] = kFONT(14);

    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
}

+ (void)setupNavBarTheme
{
    UINavigationBar* navBar = [UINavigationBar appearance];
    if (!iOS7) {
       // [navBar setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[UIImage new]];
    NSMutableDictionary* textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont] = kFONT(16);
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [navBar setTitleTextAttributes:textAttrs];
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
//    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
//        
//        viewController.navigationItem.backBarButtonItem =[self createBackButton];
//        
//    }
}



-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton

{
    return [[UIBarButtonItem alloc]
            
            initWithTitle:@"返回"
            
            style:UIBarButtonItemStyleBordered
            
            target:self 
            
            action:@selector(popself)];
}

@end
