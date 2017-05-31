

#import <UIKit/UIKit.h>
#import "WPTabBarButton.h"

@class WPTabBar;
@protocol WPTabBarDelegate <NSObject>

@optional
- (void)tabBar:(WPTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

@end

@interface WPTabBar : UIView

@property(nonatomic,strong) WPTabBarButton *selectedButton;

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
//- (void)buttonClick:(WPTabBarButton *)button;
- (void)jumpTo:(WPTabBarButton *)index;
@property (nonatomic, weak) id<WPTabBarDelegate> delegate;
@end
