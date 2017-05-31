

#import <UIKit/UIKit.h>
typedef void (^CHTumblrMenuViewSelectedBlock)(void);


@interface CHTumblrMenuView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, readonly)UIImageView *backgroundImgView;
- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block;
- (void)show;
@end
