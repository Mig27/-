//
//  GroupMemeberButton.m
//  WP
//
//  Created by 沈亮亮 on 16/5/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupMemeberButton.h"
#import <UIButton+WebCache.h>
#import "WPDownLoadVideo.h"
@implementation GroupMemeberButton

- (instancetype)initWithFrame:(CGRect)frame model:(GroupMemberListModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.modelInfo = model;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    CGSize businessSize = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat width = (SCREEN_WIDTH - 18*5)/4;
    CGFloat titleLabelHeght = businessSize.height;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width, width);
    NSString *url = [IPADDRESS stringByAppendingString:self.modelInfo.avatar];
    
    NSArray * pathArray = [url componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    if (data) {
        [button setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }
    else
    {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [down downLoadImage:url success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setBackgroundImage:[UIImage imageWithData:response] forState:UIControlStateNormal];
                });
            } failed:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setBackgroundImage:[UIImage imageNamed:@"small_cell_person"] forState:UIControlStateNormal];
                });
            }];
        });
        
    }
    
    
    
//    [button sd_setBackgroundImageWithURL:URLWITHSTR(url) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    [self addSubview:button];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom + 8, width, titleLabelHeght)];
    nickName.font = kFONT(12);
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.text = self.modelInfo.remark_name.length?self.modelInfo.remark_name:self.modelInfo.nick_name;
    [self addSubview:nickName];
    
}

- (void)iconBtnClick
{
    if (self.iconClick) {
        self.iconClick(self.modelInfo.user_id);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
