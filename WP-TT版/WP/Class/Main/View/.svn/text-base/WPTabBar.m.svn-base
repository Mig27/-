
#import "WPTabBar.h"
#import "WPTabBarButton.h"
@interface WPTabBar()

@end

@implementation WPTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
        }
        
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    WPTabBarButton *button = [[WPTabBarButton alloc] init];
    [self addSubview:button];
    
    button.item = item;
    

    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(WPTabBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
//    WPTabBarButton *newbutton = (WPTabBarButton *)[self viewWithTag:3];
//    newbutton.selected = YES;
//    self.selectedButton = newbutton;
    self.selectedButton = button;
}

- (void)jumpTo:(WPTabBarButton *)index
{
    self.selectedButton.selected = NO;
//    WPTabBarButton *button = (WPTabBarButton *)[self viewWithTag:index];
    index.selected = YES;
    self.selectedButton = index;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.subviews.count; index++) {

        WPTabBarButton *button = self.subviews[index];
        
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        button.tag = index;
//        if (index == 0) {
//            self.selectedButton = button;
//        }
    }
}

@end
