
#import "WPBadgeButton.h"
#import "UIImage+MR.h"
@implementation WPBadgeButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:[UIImage resizedImageWithName:@"discover_badgebutton"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}



- (void)setBadgeValue:(NSString *)badgeValue
{
   
    _badgeValue = [badgeValue copy];
    
    if (badgeValue) {
        self.hidden = NO;
        if (self.fontSize) {
            self.titleLabel.font = kFONT(self.fontSize);
        }
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1) {
            CGSize badgeSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
            badgeW = badgeSize.width + 10;
        }
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame = frame;
    } else {
        self.hidden = YES;
    }
}

@end
