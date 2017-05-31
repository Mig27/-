//
//  YYAlertManager.m
//  WP
//
//  Created by CBCCBC on 16/1/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "YYAlertManager.h"
#import "UIImageView+WebCache.h"
#import "WPRecruitModel.h"
#import "WPNewResumeModel.h"

typedef NS_ENUM(NSInteger, YYAlertManagerActionType) {
    YYAlertManagerTypeCancel = 100,
    YYAlertManagerTypeSend,
};

@interface YYAlertManager ()

@property (copy, nonatomic) void (^YYAlertManagerActionBlock)();

@property (strong, nonatomic) NSArray *messages;

@end

@implementation YYAlertManager

+ (void)messages:(NSArray *)messages action:(void (^)())action{
    
    YYAlertManager *manager = [[YYAlertManager alloc]initWithMessage:messages];
    [WINDOW addSubview:manager];
    [manager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WINDOW);
    }];
    
    manager.YYAlertManagerActionBlock = ^(){
        if (action) {
            action();
        }
    };
}

- (id)initWithMessage:(NSArray *)messages{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.messages = messages;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = RGBA(0, 0, 0, 0.5);
        }];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.2];
        
    }
    return self;
}

- (void)delay{
    [self initWithSubViews];
}

- (void)initWithSubViews{
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 10;
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.height.equalTo(@(kHEIGHT(150)));
        make.width.equalTo(@(kHEIGHT(250)));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [self setTitle:self.messages];
    titleLabel.font = kFONT(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backgroundView);
        make.top.equalTo(backgroundView).offset(20);
        make.height.equalTo(@20);
    }];
    
    UIImageView *headImageView = [UIImageView new];
    [backgroundView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(backgroundView).offset(kHEIGHT(10));
        make.width.height.equalTo(@(kHEIGHT(43)));
    }];
    
    [self setSubImageViews:headImageView array:self.messages];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.font = kFONT(11);
    contentLabel.textColor = RGB(127, 127, 127);
    contentLabel.text = [self setContentLabelText:self.messages];
    [backgroundView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(kHEIGHT(10));
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.right.equalTo(backgroundView).offset(kHEIGHT(10));
        make.bottom.equalTo(headImageView);
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = RGB(226, 226, 226);
    [backgroundView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backgroundView);
        make.top.equalTo(headImageView.mas_bottom).offset(20);
        make.height.equalTo(@(0.5));
    }];
    
    UIButton *cancelButton = [UIButton new];
    cancelButton.tag = YYAlertManagerTypeCancel;
    [cancelButton normalTitle:@"取消" Color:RGB(0, 0, 0) Font:kFONT(15)];
    [cancelButton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(alertAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancelButton];
    
    UIButton *sendButton = [UIButton new];
    sendButton.tag = YYAlertManagerTypeSend;
    [sendButton normalTitle:@"发送" Color:RGB(10, 110, 210) Font:kFONT(15)];
    [sendButton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(alertAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:sendButton];
    
    UILabel *lines = [UILabel new];
    lines.backgroundColor = RGB(226, 226, 226);
    [backgroundView addSubview:lines];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView);
        make.top.equalTo(line.mas_bottom);
        make.width.equalTo(backgroundView).multipliedBy(0.5);
        make.height.equalTo(@(kHEIGHT(38)));
    }];
    
    [lines mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right);
        make.top.bottom.equalTo(cancelButton);
        make.width.equalTo(@(0.5));
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView);
        make.left.equalTo(lines.mas_right);
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(@(kHEIGHT(38)));
    }];
    
    
}

- (NSString *)setTitle:(NSArray *)array{
    
    NSString *title = @"";
    if (array.count == 1) {
        WPNewResumeListModel *model = self.messages[0];
        if (model.type == WPMainPositionTypeInterView) {
            title = [NSString stringWithFormat:@"%@的求职简历",model.name];
        }else{
            title = [NSString stringWithFormat:@"%@的招聘简历",model.enterpriseName];
        }
    }
    if (array.count == 2) {
        
        NSString *name = @"";
        for (int i = 0; i < array.count; i++) {
            WPNewResumeListModel *model = self.messages[i];
            if (model.type == WPMainPositionTypeInterView) {
                name = [NSString stringWithFormat:@"%@、",model.name];
            }else{
                name = [NSString stringWithFormat:@"%@、",model.enterpriseName];
            }
        }
        
        WPNewResumeListModel *model = self.messages[0];
        if (model.type == WPMainPositionTypeInterView) {
            title = [NSString stringWithFormat:@"%@的求职简历",name];
        }else{
            title = [NSString stringWithFormat:@"%@的招聘简历",name];
        }
    }
    
    if (array.count > 2) {
        
        NSString *name = @"";
        for (int i = 0; i < 2; i++) {
            WPNewResumeListModel *model = self.messages[i];
            if (model.type == WPMainPositionTypeInterView) {
                name = [NSString stringWithFormat:@"%@%@、",name,model.name];
            }else{
                name = [NSString stringWithFormat:@"%@%@、",name,model.enterpriseName];
            }
        }
        
        WPNewResumeListModel *model = self.messages[0];
        if (model.type == WPMainPositionTypeInterView) {
            title = [NSString stringWithFormat:@"%@等%@人的求职简历",[name substringToIndex:name.length-1],@(self.messages.count)];
        }else{
            title = [NSString stringWithFormat:@"%@等%@人的招聘简历",[name substringToIndex:name.length-1],@(self.messages.count)];
        }
    }
    
    return title;
}

- (void)setSubImageViews:(UIImageView *)superView array:(NSArray *)array{
    if (self.messages.count == 1) {
        
        WPNewResumeListModel *model = self.messages[0];
        
        if (model.type == WPMainPositionTypeInterView) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
            [superView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
            [superView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        }
    }
    
    if (self.messages.count == 2) {
        
        for (int i = 0; i < self.messages.count; i++) {
            
            UIImageView *subImageView = [UIImageView new];
            subImageView.layer.masksToBounds = YES;
            subImageView.layer.cornerRadius = 2.5;
            [superView addSubview:subImageView];
            [subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                (i == 0?make.top.equalTo(superView):make.top.equalTo(superView.mas_centerY));
                (i == 0?make.left.equalTo(superView):make.left.equalTo(superView.mas_centerX));
                make.width.height.equalTo(superView).multipliedBy(0.5);
            }];
            WPNewResumeListModel *model = self.messages[i];
            if (model.type == WPMainPositionTypeInterView) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
                [subImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            }
            if (model.type == WPMainPositionTypeRecruit) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
                [subImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            }
        }
    }
    
    if (self.messages.count == 3) {
        
        UIView *lastView = nil;
        for (int i = 0; i < 3; i++) {
            
            UIImageView *subImageView = [UIImageView new];
            subImageView.layer.masksToBounds = YES;
            subImageView.layer.cornerRadius = 2.5;
            [superView addSubview:subImageView];
            [subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(superView).multipliedBy(0.5);
                
                if (i == 0) {
                    make.top.equalTo(superView);
                    make.centerX.equalTo(superView.mas_centerX);
                }
                if (i == 1) {
                    make.top.equalTo(lastView.mas_bottom);
                    make.left.equalTo(superView);
                }
                if (i == 2) {
                    make.top.equalTo(lastView.mas_top);
                    make.left.equalTo(lastView.mas_right);
                }
            }];
            
            lastView = subImageView;
            
            WPNewResumeListModel *model = self.messages[i];
            
            if (model.type == WPMainPositionTypeInterView) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
                [subImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            }
            if (model.type == WPMainPositionTypeRecruit) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
                [subImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            }
        }
    }
    
    if (self.messages.count > 3) {
        
        UIView *lastView = nil;
        for (int i = 0; i < 4; i++) {
            
            UIImageView *subImageView = [UIImageView new];
            subImageView.layer.masksToBounds = YES;
            subImageView.layer.cornerRadius = 2.5;
            [superView addSubview:subImageView];
            [subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(superView).multipliedBy(0.5);
                
                if (i == 0) {
                    make.top.left.equalTo(superView);
                }
                if (i == 1) {
                    make.top.equalTo(superView);
                    make.left.equalTo(lastView.mas_right);
                }
                if (i == 2) {
                    make.top.equalTo(lastView.mas_bottom);
                    make.left.equalTo(superView);
                }
                if (i == 3) {
                    make.top.equalTo(lastView);
                    make.left.equalTo(lastView.mas_right);
                }
                
            }];
            
            lastView = subImageView;
            
            WPNewResumeListModel *model = self.messages[i];

            if (model.type == WPMainPositionTypeInterView) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
                [subImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            }
            if (model.type == WPMainPositionTypeRecruit) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
                [subImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            }
        }
    }
}

- (NSString *)setContentLabelText:(NSArray *)array{
    
    NSString *contentTitle = @"";
    for (int i = 0; i < self.messages.count; i++) {
        WPNewResumeListModel *model = self.messages[i];
        if (model.type == WPMainPositionTypeInterView) {
            NSString *position = [NSString stringWithFormat:@"%@：求职%@",model.name,model.HopePosition];
            contentTitle = [NSString stringWithFormat:@"%@%@\n",contentTitle,position];
        }
        if (model.type == WPMainPositionTypeRecruit) {
            NSString *position = [NSString stringWithFormat:@"%@：招聘%@",model.enterpriseName,model.jobPositon];
            contentTitle = [NSString stringWithFormat:@"%@%@\n",contentTitle,position];
        }
    }
    return contentTitle;
}

- (void)alertAction:(UIButton *)sender{
    
    if (sender.tag == YYAlertManagerTypeCancel) {
        [self removeFromSuperview];
    }
    
    if (sender.tag == YYAlertManagerTypeSend) {
        if (self.YYAlertManagerActionBlock) {
            self.YYAlertManagerActionBlock();
        }
    }
}

@end
