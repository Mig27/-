//
//  CCAlertView.m
//  YipaiShop
//
//  Created by chenchao on 15/12/21.
//  Copyright © 2015年 Yipai. All rights reserved.
//

#import "CCAlertView.h"

#define iOS8_0 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0

@interface CCAlertView()<UIAlertViewDelegate>
{
    // 这里定义的是成员变量  只能在当前类中访问  外部是无法访问的
    NSMutableArray *_arrayTitles;
    NSMutableArray *_arrayActions;
}
// 这里定义的是属性  外部也是可以访问的啊 还有生成了getter  setter 方法
// ios8 之后使用的是UIAlertController 所以需要使用该类的ViewController
@property (nonatomic,weak) UIViewController *sender;


@end

@implementation CCAlertView

//重写该方法，保证该对象不会被释放；不如被释放了  iOS8以下的UIAlertView的回调时候会崩溃
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    static CCAlertView *_shareAlertView = nil;
    dispatch_once(&onceToken, ^{
        if (_shareAlertView == nil) {
            _shareAlertView = [super allocWithZone:zone];
        }
    });
    return _shareAlertView;
}

//after memory for it has been allocated. alloc内存分配之前所做的操作
-(instancetype)init{
    if (self = [super init]) {
        //初始化工作  实力化两个可变数组
        _arrayActions = [NSMutableArray array];
        _arrayTitles = [NSMutableArray array];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    if ([self init]) {
        _title = title;
        _message = message;
    }
    return self;
}

-(void)setTitle:(NSString *)title message:(NSString *)message{
    _title = title;
    _message = message;
}


-(void)addBtnTitle:(NSString *)title action:(ClickAction)action{
    [_arrayTitles addObject:title];
    [_arrayActions addObject:action];
}

-(void)showAlertWithSender:(UIViewController *)sender{
    if (_arrayTitles.count == 0) {
        return;
    }
    self.sender = sender;
    if (iOS8_0) {
        [self showAlertController];
    }else{
        [self showAlertView];
    }
}

-(void)showAlertController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < _arrayTitles.count; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:_arrayTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ClickAction ac = _arrayActions[i];
            ac();
        }];
        [alert addAction:action];
    }
    if (_sender) {
        [_sender showDetailViewController:alert sender:nil];
    }
}

-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title message:_message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in _arrayTitles) {
        [alert addButtonWithTitle:title];
    }
    [alert show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    ClickAction action = _arrayActions[buttonIndex];
    action();
}

@end

