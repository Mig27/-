//
//  CYLSearchBar.m
//  CYLSearchViewController
//

//

#import "MCSearchBar.h"

@implementation MCSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)initWithCoder: (NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)sharedInit {
    self.backgroundColor = TEXTFIELD_BACKGROUNDC0LOR;
    self.placeholder = @"搜索";
    self.keyboardType = UIKeyboardTypeDefault;
    self.showsCancelButton = NO;
    // 删除UISearchBar中的UISearchBarBackground
    [self setBackgroundImage:[[UIImage alloc] init]];
    self.tintColor = APP_TINT_COLOR;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    return self;
}

@end
