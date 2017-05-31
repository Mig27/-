//
//  DynamicBottomView.m
//  WP
//
//  Created by 沈亮亮 on 16/3/16.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈的底部，用来显示赞，分享，评论

#import "DynamicBottomView.h"
#import "PraisePersonView.h"
#import "SharePersonView.h"
#import "CommentListView.h"
#import "NewCommentListView.h"

@interface DynamicBottomView ()

@end

@implementation DynamicBottomView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.dynamicInfo) {
        return;
    }
//    self.backgroundColor = [UIColor yellowColor];
    PraisePersonView *praiseView = [[PraisePersonView alloc] init];
    SharePersonView *shareView = [[SharePersonView alloc] init];
    
//    CommentListView *discussView = [[CommentListView alloc] init];
    NewCommentListView *discussView = [[NewCommentListView alloc] init];
    discussView.discussIndex = self.indexPath;
    discussView.discussInfo = self.dynamicInfo;
    
    [self addSubview:praiseView];
    [self addSubview:shareView];
    [self addSubview:discussView];
    
    CGFloat praiseH = [PraisePersonView calculateHeightWithInfo:self.dynamicInfo[@"praiseUser"]];
    CGFloat shareH = [SharePersonView calculateHeightWithInfo:self.dynamicInfo[@"shareUser"]];
//    CGFloat discussH = [CommentListView calculateHeightWithInfo:self.dynamicInfo[@"DiscussUser"] andCount:self.dynamicInfo[@"speak_trends_person"]];
    CGFloat discussH = [NewCommentListView calculateHeightWithInfo:self.dynamicInfo[@"DiscussUser"] andCount:self.dynamicInfo[@"speak_trends_person"]];
    
    if (praiseH == 0 && shareH == 0 && discussH == 0) {
        return;
    } else if (praiseH != 0 && shareH == 0 && discussH == 0) {
        
        praiseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, praiseH);
        praiseView.praiseArr = self.dynamicInfo[@"praiseUser"];
        praiseView.praiseCount = self.dynamicInfo[@"speak_praise_count"];
        
    } else if (praiseH == 0 && shareH != 0 && discussH ==0) {
        
        shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, shareH);
        shareView.shareArr = self.dynamicInfo[@"shareUser"];
        shareView.shareCount = self.dynamicInfo[@"shareCount"];
        
    } else if (praiseH == 0 && shareH == 0 && discussH != 0) {
        
        discussView.frame = CGRectMake(0, 0, SCREEN_WIDTH, discussH);
        discussView.discussArr = self.dynamicInfo[@"DiscussUser"];
        discussView.discussCount = self.dynamicInfo[@"speak_trends_person"];
        
    } else if (praiseH !=0 && shareH != 0 && discussH ==0) {
        
        praiseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, praiseH);
        praiseView.praiseArr = self.dynamicInfo[@"praiseUser"];
        praiseView.praiseCount = self.dynamicInfo[@"speak_praise_count"];
        
        shareView.frame = CGRectMake(0, praiseView.bottom + kHEIGHT(10), SCREEN_WIDTH, shareH);
        shareView.shareArr = self.dynamicInfo[@"shareUser"];
        shareView.shareCount = self.dynamicInfo[@"shareCount"];
        
    } else if (praiseH != 0 && shareH == 0 && discussH != 0) {
        
        praiseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, praiseH);
        praiseView.praiseArr = self.dynamicInfo[@"praiseUser"];
        praiseView.praiseCount = self.dynamicInfo[@"speak_praise_count"];
        
        discussView.frame = CGRectMake(0, praiseView.bottom + kHEIGHT(10), SCREEN_WIDTH, discussH);
        discussView.discussArr = self.dynamicInfo[@"DiscussUser"];
        discussView.discussCount = self.dynamicInfo[@"speak_trends_person"];

    } else if (praiseH ==0 && shareH != 0 && discussH != 0) {
        
        shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, shareH);
        shareView.shareArr = self.dynamicInfo[@"shareUser"];
        shareView.shareCount = self.dynamicInfo[@"shareCount"];
        
        discussView.frame = CGRectMake(0, shareView.bottom + kHEIGHT(10), SCREEN_WIDTH, discussH);
        discussView.discussArr = self.dynamicInfo[@"DiscussUser"];
        discussView.discussCount = self.dynamicInfo[@"speak_trends_person"];

    } else {
        
        praiseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, praiseH);
        praiseView.praiseArr = self.dynamicInfo[@"praiseUser"];
        praiseView.praiseCount = self.dynamicInfo[@"speak_praise_count"];
        
        shareView.frame = CGRectMake(0, praiseView.bottom + kHEIGHT(10), SCREEN_WIDTH, shareH);
        shareView.shareArr = self.dynamicInfo[@"shareUser"];
        shareView.shareCount = self.dynamicInfo[@"shareCount"];
  
        discussView.frame = CGRectMake(0, shareView.bottom + kHEIGHT(10), SCREEN_WIDTH, discussH);
        discussView.discussArr = self.dynamicInfo[@"DiscussUser"];
        discussView.discussCount = self.dynamicInfo[@"speak_trends_person"];
    }

}

+ (CGFloat)calculateHeightWithInfo:(NSDictionary *)info
{
    //分别计算赞，分享，评论的高度
    CGFloat praiseH = [PraisePersonView calculateHeightWithInfo:info[@"praiseUser"]];
    CGFloat shareH = [SharePersonView calculateHeightWithInfo:info[@"shareUser"]];
    CGFloat discussH = [NewCommentListView calculateHeightWithInfo:info[@"DiscussUser"] andCount:info[@"speak_trends_person"]];
    if (praiseH == 0 && shareH == 0 && discussH == 0) {
        return 0;
    } else if (praiseH != 0 && shareH == 0 && discussH == 0) {
        return praiseH;
    } else if (praiseH == 0 && shareH != 0 && discussH ==0) {
        return shareH;
    } else if (praiseH == 0 && shareH == 0 && discussH != 0) {
        return discussH;
    } else if (praiseH !=0 && shareH != 0 && discussH ==0) {
        return praiseH + shareH + kHEIGHT(10);
    } else if (praiseH != 0 && shareH == 0 && discussH != 0) {
        return praiseH + discussH + kHEIGHT(10);
    } else if (praiseH ==0 && shareH != 0 && discussH != 0) {
        return shareH + discussH + kHEIGHT(10);
    } else {
        return shareH + praiseH + discussH + 2*kHEIGHT(10);
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
