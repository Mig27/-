//
//  WPResumeCheckHeaderView.m
//  WP
//
//  Created by CBCCBC on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeCheckHeaderView.h"
#import "SPLabel.h"
#import "NearInterViewController.h"
@interface WPResumeCheckHeaderView ()

@property (nonatomic ,strong)UIImageView *iconImageView;
@property (nonatomic ,strong)SPLabel *titleLabel;
@property (nonatomic ,strong)SPLabel *contentLabel;
@property (nonatomic ,strong)SPLabel *timeLabel;

@property (nonatomic ,strong)UIView *line;
@property (nonatomic ,strong)UIView *bottomLine;

@end

@implementation WPResumeCheckHeaderView

- (void)setModel:(NearPersonalListModel *)model
{
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.timeLabel.text = [model.updateTime stringByAppendingString:@"更新"];
    self.titleLabel.text = model.position;
    
    self.contentLabel.text = _isRecruit?model.enterprise_name:[NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.nike_name,model.sex,model.age,model.education,model.worktime];
    
    CGSize size = [self.timeLabel.text getSizeWithFont:FUCKFONT(10) Height:kHEIGHT(43)/3*2];
//    CGSize size = [self.timeLabel.text getSizeWithFont:FUCKFONT(10) Height:self.titleLabel.height];
    
    self.titleLabel.frame = CGRectMake(self.iconImageView.right + 10, kHEIGHT(10), SCREEN_WIDTH-self.iconImageView.right - 10-size.width-15, kHEIGHT(43)/3*2);
    
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - size.width-10, kHEIGHT(10), size.width, kHEIGHT(43)/3*2);
    [self.browseBtn setTitle:[NSString stringWithFormat:@"浏览   %@",model.ranking] forState:UIControlStateNormal];
    [self.shareBtn setTitle: [NSString stringWithFormat:@"分享   %@",model.shareCount] forState:UIControlStateNormal];
    [self.messageBtn setTitle: [NSString stringWithFormat:@"留言   %@",model.comcount] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.contentButton];
        [self.contentButton addSubview:self.iconImageView];
        [self.contentButton addSubview:self.titleLabel];
        [self.contentButton addSubview:self.contentLabel];
        [self.contentButton addSubview:self.timeLabel];
        [self addSubview:self.line];
        [self addSubview:self.browseBtn];
        [self addSubview:self.messageBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.bottomLine];
        [self addSubview:self.sportLine];
    }
    return self;
}

- (void)goToResumeAgain
{
   
}

- (UIButton *)contentButton
{
    if (!_contentButton) {
        self.contentButton = [UIButton new];
        [self.contentButton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
//        [self.contentButton addTarget:self action:@selector(goToResumeAgain) forControlEvents:UIControlEventTouchUpInside];
        self.contentButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(63));
    }
    return _contentButton;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.image = [UIImage imageNamed:@""];
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.bounds = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
        CGFloat center = kHEIGHT(43)/2+kHEIGHT(10);
        self.iconImageView.center = CGPointMake(center, center);
    }
    return _iconImageView;
}

- (SPLabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[SPLabel alloc]init];
        self.titleLabel.text = @"";
        self.titleLabel.font = kFONT(15);
        
        CGSize size = [self.timeLabel.text getSizeWithFont:FUCKFONT(10) Height:self.titleLabel.height];
        
        self.titleLabel.frame = CGRectMake(self.iconImageView.right + 10, kHEIGHT(10), SCREEN_WIDTH-self.iconImageView.right - 10-size.width-20, kHEIGHT(43)/3*2);
    }
    return _titleLabel;
}

- (SPLabel *)contentLabel
{
    if (!_contentLabel) {
        self.contentLabel = [[SPLabel alloc]init];
        self.contentLabel.text = @"";
        self.contentLabel.textColor = RGB(127, 127, 127);
        self.contentLabel.font = kFONT(12);
        self.contentLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom, SCREEN_WIDTH-self.titleLabel.left, kHEIGHT(43)/3);
    }
    return _contentLabel;
}


- (SPLabel *)timeLabel
{
    if (!_timeLabel) {
        self.timeLabel = [[SPLabel alloc]init];
        self.timeLabel.textColor = RGB(170, 170, 170);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = kFONT(10);
        self.timeLabel.text = @"";
//        self.timeLabel.backgroundColor = [UIColor redColor];
        CGSize size = [self.timeLabel.text getSizeWithFont:FUCKFONT(10) Height:self.titleLabel.height];
        self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-10-size.width, self.titleLabel.top, size.width, self.titleLabel.height);
    }
    return _timeLabel;
}

- (UIView *)line
{
    if (!_line) {
        self.line = [[UIView alloc]init];;
        self.line.backgroundColor = RGB(235, 235, 235);
        self.line.frame = CGRectMake(0, self.contentButton.bottom, SCREEN_WIDTH, 8);
    }
    return _line;
}

- (UIButton *)browseBtn
{
    if (!_browseBtn) {
        self.browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.browseBtn.titleLabel.font = kFONT(12);
        self.browseBtn.backgroundColor = [UIColor whiteColor];
        self.browseBtn.selected = YES;
        self.browseBtn.tag = 1;
        [self.browseBtn setTitle:@"浏览" forState:UIControlStateNormal];
        [self.browseBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [self.browseBtn setTitleColor:RGB(90, 110, 150) forState:UIControlStateSelected];
        self.browseBtn.frame = CGRectMake(0, self.line.bottom, SCREEN_WIDTH/3, kHEIGHT(36));
        [self.browseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _browseBtn;
}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.titleLabel.font = kFONT(12);
        self.shareBtn.backgroundColor = [UIColor whiteColor];
        [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        self.shareBtn.tag = 2;
        [self.shareBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [self.shareBtn setTitleColor:RGB(90, 110, 150) forState:UIControlStateSelected];
        self.shareBtn.frame = CGRectMake(self.browseBtn.right, self.line.bottom, SCREEN_WIDTH/3, kHEIGHT(36));
        [self.shareBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)messageBtn
{
    if (!_messageBtn) {
        self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.messageBtn.titleLabel.font = kFONT(12);
        self.messageBtn.backgroundColor = [UIColor whiteColor];
        [self.messageBtn setTitle:@"留言" forState:UIControlStateNormal];
        self.messageBtn.tag = 3;
        [self.messageBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [self.messageBtn setTitleColor:RGB(90, 110, 150) forState:UIControlStateSelected];
        self.messageBtn.frame = CGRectMake(self.shareBtn.right, self.line.bottom, SCREEN_WIDTH/3, kHEIGHT(36));
        [self.messageBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

- (void)buttonAction:(UIButton *)sender
{
    for (UIButton *button in self.buttonArr) {
        if (button == sender) {
            sender.selected = YES;
            self.sportLine.frame = CGRectMake(sender.left, sender.bottom-2, SCREEN_WIDTH/3, 2);
        }else{
            button.selected = NO;
        }
    }
}

- (NSArray *)buttonArr
{
    if (!_buttonArr) {
        self.buttonArr = @[self.browseBtn,self.messageBtn,self.shareBtn];
    }
    return _buttonArr;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.messageBtn addTarget:target action:action forControlEvents:controlEvents];
    [self.browseBtn addTarget:target action:action forControlEvents:controlEvents];
    [self.shareBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        self.bottomLine = [UIView new];
        self.bottomLine.backgroundColor = RGB(226, 226, 226);
        self.bottomLine.frame = CGRectMake(0, self.messageBtn.bottom-0.5, SCREEN_WIDTH, 0.5);
    }
    return _bottomLine;
}

- (UIView *)sportLine
{
    if (!_sportLine) {
        self.sportLine = [UIView new];
        self.sportLine.backgroundColor = RGB(90, 110, 150);
        self.sportLine.frame = CGRectMake(SCREEN_WIDTH*2/3, self.messageBtn.bottom-2, SCREEN_WIDTH/3, 2);
    }
    return _sportLine;
}

@end
