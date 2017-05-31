//
//  CustomAlertView.m
//  TruckFriends
//
//  Created by summer on 14/11/4.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "CustomAlertView.h"
#import "CreatCustom.h"

#import "UIImage+ImageType.h"
#import "MacroDefinition.h"

@implementation CustomAlertView
{
    UIView *_superView;
}

-(id)initWithTopTitle:(NSString *)topTitle ItemArr:(NSArray *)itemArr SuperView:(UIView *)superView SelectedCount:(NSInteger)selectedCount
{
    self = [super initWithFrame:superView.window.frame];
    _superView = superView;
    if (self)
    {
        UIView *alertView = [self creatAlertViewWithTopTitle:topTitle ItemArr:itemArr SuperView:superView SelectedCount:selectedCount];
        [self addSubview:alertView];
    }
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    return self;
}
-(void)show
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [_superView.window addSubview:self];
    [UIView commitAnimations];
    
}

-(void)hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [self removeFromSuperview];
    [UIView commitAnimations];
}
-(UIView *)creatAlertViewWithTopTitle:(NSString *)topTitle ItemArr:(NSArray *)itemArr SuperView:(UIView *)superView SelectedCount:(NSInteger)selectedCount
{
    CGFloat topHeight = 50;
    CGFloat commonHeight = 40;
    CGFloat alertViewHeight = topHeight+commonHeight*itemArr.count;
    
    UIView *alertView = [CreatCustom creatUIViewWithFrame:[CreatCustom creatFrameWithOrignalX:30 OrignalY:(self.height-alertViewHeight)/2 Height:alertViewHeight] BackgroundColor:[UIColor whiteColor]];
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, (alertView.width-15*2), topHeight)];
    topLabel.text = topTitle;
    topLabel.textColor = DefaultControlColor;
    topLabel.font = [UIFont systemFontOfSize:15];
    [alertView addSubview:topLabel];
    
    UIView *segmentView = [CreatCustom creatUIViewWithFrame:CGRectMake(0, topLabel.height-0.5, topLabel.width, 0.5) BackgroundColor:[UIColor lightGrayColor]];
    [topLabel addSubview:segmentView];
    for (int i=0; i<itemArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, topLabel.bottom+commonHeight*i, topLabel.width, commonHeight);
        [btn setTitle:[itemArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[itemArr objectAtIndex:i] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage creatUIImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage creatUIImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.tag = i+100;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:btn];
        if (i==selectedCount)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width-16-5, (btn.height-16)/2, 16, 16)];
            imageView.image = [UIImage imageNamed:@"me_duig"];
            [btn addSubview:imageView];
        }
        if (i<itemArr.count-1)
        {
            UIView *btnSegment = [CreatCustom creatUIViewWithFrame:CGRectMake(0, btn.height-0.5, btn.width,0.5) BackgroundColor:[UIColor lightGrayColor]];
            [btn addSubview:btnSegment];
        }
        
    }
    return alertView;
}

-(void)buttonAction:(UIButton *)sender
{
    [self.delegate customAlertViewDidSelectedItemCount:sender.tag-100 Item:sender.titleLabel.text];
    [self hide];
    
}

@end
