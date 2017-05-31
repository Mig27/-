
#import "WPSearchBar.h"

@interface WPSearchBar () <UITextFieldDelegate>

@end

@implementation WPSearchBar

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WPColor(255, 255, 255);
        UIImageView* iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_one"]];
        iconView.contentMode = UIViewContentModeCenter;
       // self.leftView = iconView;
        self.leftView = iconView;
        //self.leftViewMode = UITextFieldViewModeAlways;
        self.iconView = iconView;

        self.font = [UIFont systemFontOfSize:12];
        self.clearButtonMode = UITextFieldViewModeAlways;

        NSMutableDictionary* attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attrs];
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (void)textFieldDidChange:(id)sender
{
//    UITextField* field = (UITextField*)sender;
   // (field.text.length != 0) ? [self.iconView setHidden:YES] : [self.iconView setHidden:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(0, 0, 30, self.frame.size.height);
}

@end
