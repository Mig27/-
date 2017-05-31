//
//  WPActionSheet.m
//  test
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "WPActionSheet.h"
#import "MacroDefinition.h"

#import "NSString+StringType.h"

#define StartColor [UIColor clearColor]
#define EndColor RGBA(0, 0, 0, 0.5)

@interface WPActionSheet ()

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) NSInteger viewHeight;
@property (assign, nonatomic) CGFloat top;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) void (^WPActionSheetPrivateBlock)(NSInteger number);

@end

@implementation WPActionSheet

-(instancetype)initWithDelegate:(id<WPActionSheet>)delegate otherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top
{
    self = [super initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    if (self) {
        _viewHeight = kHEIGHT(43)*otherTitles.count+kHEIGHT(43)+6;
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, -_viewHeight, SCREEN_WIDTH,_viewHeight)];
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
        _bottomView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_bottomView addGestureRecognizer:tap];
        self.delegate = delegate;
        _top = top;
        _view.backgroundColor = RGB(235, 235, 235);
        [self addSubview:_view];
        
        for (int i = 0; i < otherTitles.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*kHEIGHT(43), self.width, kHEIGHT(43))];
            [button addTarget:self action:@selector(ButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            button.tag = i+1;
            [_view addSubview:button];
            
//            UILabel *label = [[UILabel alloc]init];
//            label.text = otherTitles[i];
//            label.font = kFONT(15);
//            [button addSubview:label];
            
//            CGSize size = [otherTitles[i] getSizeWithFont:FUCKFONT(15) Height:20];
           
            [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateHighlighted];
            [button setTitle:[NSString stringWithFormat:@"  %@",otherTitles[i]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
            button.titleLabel.font = kFONT(15);
//            if (imageNames.count > 0) {
//                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-size.width-20)/2, kHEIGHT(43)/2-10, 20, 20)];
//                imageV.image = [UIImage imageNamed:imageNames[i]];
//                [button addSubview:imageV];
//                
//                label.frame = CGRectMake(imageV.right+10, kHEIGHT(43)/2-10, 100, 20);
//                label.textAlignment = NSTextAlignmentLeft;
//            }else{
//                label.frame = CGRectMake(0, kHEIGHT(43)/2-10, self.width, 20);
//                label.textAlignment = NSTextAlignmentCenter;
//            }
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, button.width, 0.5)];
            line.backgroundColor = RGB(235, 235, 235);
            [button addSubview:line];
        }
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.tag = 0;
        cancelBtn.frame = CGRectMake(0, kHEIGHT(43)*otherTitles.count+6, self.width, kHEIGHT(43));
        //[cancelBtn setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        cancelBtn.titleLabel.font = kFONT(15);
        [cancelBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(ButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:cancelBtn];
        
    }
    return self;
}

- (void)tap
{
    [self.delegate WPActionSheet:self clickedButtonAtIndex:-1];
    [self hideFromView:self.superview];
}

-(instancetype)initWithOtherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top actions:(WPActionSheetType) type{
    self = [super initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT-top)];
    if (self) {
        _viewHeight = kHEIGHT(43)*otherTitles.count+kHEIGHT(43)+6;
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, -_viewHeight, SCREEN_WIDTH,_viewHeight)];
        _top = top;
        _view.backgroundColor = RGB(235, 235, 235);
        [self addSubview:_view];
        
        for (int i = 0; i < otherTitles.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*kHEIGHT(43), self.width, kHEIGHT(43))];
            [button addTarget:self action:@selector(ButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            button.tag = i+1;
            [_view addSubview:button];
            
            UILabel *label = [[UILabel alloc]init];
            label.text = otherTitles[i];
            label.font = kFONT(15);
            [button addSubview:label];
            
            CGSize size = [otherTitles[i] getSizeWithFont:FUCKFONT(15) Height:20];
            
            if (imageNames.count > 0) {
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-size.width-20)/2, kHEIGHT(43)/2-10, 20, 20)];
                imageV.image = [UIImage imageNamed:imageNames[i]];
                [button addSubview:imageV];
                
                label.frame = CGRectMake(imageV.right+10, kHEIGHT(43)/2-10, 100, 20);
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.frame = CGRectMake(0, kHEIGHT(43)/2-10, self.width, 20);
                label.textAlignment = NSTextAlignmentCenter;
            }
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, button.width, 0.5)];
            line.backgroundColor = RGB(235, 235, 235);
            [button addSubview:line];
        }
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.tag = 0;
        cancelBtn.frame = CGRectMake(0, kHEIGHT(43)*otherTitles.count+6, self.width, kHEIGHT(43));
        //[cancelBtn setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = kFONT(15);
        [cancelBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(ButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:cancelBtn];
        
        WS(ws);
        if (type) {
            self.WPActionSheetPrivateBlock = ^(NSInteger number){
                [ws hideFromView:ws.superview];
                type(number);
            };
        }
    }
    return self;
}

-(void)ButtonCLick:(UIButton *)sender
{
    if (sender.tag != 0) {
        if (self.delegate) {
            [self hideFromView:self.superview];
//            [self.delegate WPActionSheetAtIndex:sender.tag];
            [self.delegate WPActionSheet:self clickedButtonAtIndex:sender.tag];
        }
    }else{
        [self.delegate WPActionSheet:self clickedButtonAtIndex:-1];
        [self hideFromView:self.superview];
    }
    if (self.touchToHide) {
        self.touchToHide();
    }
    if (self.WPActionSheetPrivateBlock) {
        self.WPActionSheetPrivateBlock(sender.tag);
    }
}
-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    self.frame = CGRectMake(0, _top, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.backgroundColor = StartColor;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = EndColor;
        _view.top = 0;
    }];
}

- (void)showInViewSpecial:(UIView *)view
{
    [view addSubview:self];
    self.frame = CGRectMake(0, _top, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:_bottomView];
    _bottomView.backgroundColor = StartColor;
    self.backgroundColor = StartColor;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = EndColor;
        _bottomView.backgroundColor = EndColor;
        _view.top = 0;
    }];

}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    self.frame = CGRectMake(0, _top, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.backgroundColor = StartColor;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = EndColor;
        _view.top = 0;
    }];
}

-(void)hideFromView:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = StartColor;
        _bottomView.backgroundColor = StartColor;
        _view.top = -_viewHeight;;
    }];
    [self performSelector:@selector(delay) withObject:self afterDelay:0.3];
}

-(void)delay
{
    self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [_bottomView removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchToHide) {
        self.touchToHide();
    }
    [self.delegate WPActionSheet:self clickedButtonAtIndex:-1];
    [self hideFromView:self.superview];
}

+(void)superView:(UIView *)superView otherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top actions:(WPActionSheetType) type{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithOtherButtonTitle:otherTitles imageNames:imageNames top:top actions:type];
    [actionSheet showInView:superView];
}

+(void)removeFromsuperView:(UIView *)superView{
    for (UIView *view  in superView.subviews) {
        if ([view isKindOfClass:[WPActionSheet class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
