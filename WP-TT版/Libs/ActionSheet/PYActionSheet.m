//
//  WPActionSheet.m
//  test
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "PYActionSheet.h"
#import "MacroDefinition.h"

#import "NSString+StringType.h"

#define StartColor [UIColor clearColor]
#define EndColor RGBA(0, 0, 0, 0.5)

@interface PYActionSheet ()

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) NSInteger viewHeight;
@property (assign, nonatomic) CGFloat top;

@property (copy, nonatomic) void (^touchToHide)();

@property (nonatomic, copy) void (^WPActionSheetPrivateBlock)(NSInteger number);

@end

@implementation PYActionSheet

-(instancetype)initWithOtherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top actions:(WPActionSheetType) type{
    self = [super initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    if (self) {
        _viewHeight = kHEIGHT(43)*otherTitles.count+kHEIGHT(43)+6;
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, -_viewHeight, SCREEN_WIDTH,_viewHeight)];
        _top = top;
        _view.backgroundColor = RGB(235, 235, 235);
        [self addSubview:_view];
        
        for (int i = 0; i < otherTitles.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*kHEIGHT(43), SCREEN_WIDTH, kHEIGHT(43))];
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
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-size.width-20)/2,kHEIGHT(43)/2-10, 20, 20)];
                imageV.image = [UIImage imageNamed:imageNames[i]];
                [button addSubview:imageV];
                
                label.frame = CGRectMake(imageV.right+10, kHEIGHT(43)/2-10, 100, 20);
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.frame = CGRectMake(0, kHEIGHT(43)/2-10, SCREEN_WIDTH, 20);
                label.textAlignment = NSTextAlignmentCenter;
            }
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, button.width, 0.5)];
            line.backgroundColor = RGB(235, 235, 235);
            [button addSubview:line];
        }
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.tag = 0;
        cancelBtn.frame = CGRectMake(0, kHEIGHT(43)*otherTitles.count+6, SCREEN_WIDTH, kHEIGHT(43));
        //[cancelBtn setImage:[UIImage imageNamed:@"menu_cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = kFONT(15);
        [cancelBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(ButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:cancelBtn];
        
        if (type) {
            self.WPActionSheetPrivateBlock = ^(NSInteger number){
                type(number);
            };
        }
        
    }
    return self;
}

-(void)ButtonCLick:(UIButton *)sender
{
    if (self.WPActionSheetPrivateBlock) {
        self.WPActionSheetPrivateBlock(sender.tag);
    }
    
    [self hideFromView:self.superview];
    if (self.touchToHide) {
        self.touchToHide();
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

-(void)hideFromView:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = StartColor;
        _view.top = -_viewHeight;;
    }];
    [self performSelector:@selector(delay) withObject:self afterDelay:0.3];
}

-(void)delay
{
    self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchToHide) {
        self.touchToHide();
    }
    [self hideFromView:self.superview];
}

+(void)superView:(UIView *)superView otherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top actions:(WPActionSheetType) type touchBlock:(void (^)())touchBlock{
    PYActionSheet *actionSheet = [[PYActionSheet alloc]initWithOtherButtonTitle:otherTitles imageNames:imageNames top:top actions:type];
    [actionSheet showInView:superView];
    if (touchBlock) {
        actionSheet.touchToHide = ^(){
            touchBlock();
        };
    }
}

+(void)removeFromsuperView:(UIView *)superView{
    for (UIView *view  in superView.subviews) {
        if ([view isKindOfClass:[PYActionSheet class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
