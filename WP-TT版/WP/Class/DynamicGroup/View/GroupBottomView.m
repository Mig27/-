//
//  GroupBottomView.m
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupBottomView.h"
#import "GroupPraiseView.h"
#import "GroupCommentListView.h"

@interface GroupBottomView ()

@end

@implementation GroupBottomView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.dynamicInfo) {
        return;
    }
    //    self.backgroundColor = [UIColor yellowColor];
    GroupPraiseView *praiseView = [[GroupPraiseView alloc] init];

    GroupCommentListView *discussView = [[GroupCommentListView alloc] init];
    discussView.discussIndex = self.indexPath;
    discussView.discussInfo = self.dynamicInfo;
    
    [self addSubview:praiseView];
    [self addSubview:discussView];
    
    CGFloat praiseH = [GroupPraiseView calculateHeightWithInfo:self.dynamicInfo.PraiseList];
    CGFloat discussH = [GroupCommentListView calculateHeightWithInfo:self.dynamicInfo.CommentList andCount:self.dynamicInfo.commentCount];
    
    if (praiseH == 0 &&  discussH == 0) {
        return;
    } else if (praiseH != 0 && discussH == 0) {
        
        praiseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, praiseH);
        praiseView.praiseArr = self.dynamicInfo.PraiseList;
        praiseView.praiseCount = self.dynamicInfo.praiseCount;
        
    } else if (praiseH == 0 && discussH != 0) {
        
        discussView.frame = CGRectMake(0, 0, SCREEN_WIDTH, discussH);
        discussView.discussArr = self.dynamicInfo.CommentList;
        discussView.discussCount = self.dynamicInfo.commentCount;
        
    } else if (praiseH != 0 && discussH != 0) {
        
        praiseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, praiseH);
        praiseView.praiseArr = self.dynamicInfo.PraiseList;
        praiseView.praiseCount = self.dynamicInfo.praiseCount;
        
        discussView.frame = CGRectMake(0, praiseView.bottom + kHEIGHT(10), SCREEN_WIDTH, discussH);
        discussView.discussArr = self.dynamicInfo.CommentList;
        discussView.discussCount = self.dynamicInfo.commentCount;
    }
}

+ (CGFloat)calculateHeightWithInfo:(GroupPhotoAlumListModel *)info
{
    //分别计算赞，分享，评论的高度
    CGFloat praiseH = [GroupPraiseView calculateHeightWithInfo:info.PraiseList];
    CGFloat discussH = [GroupCommentListView calculateHeightWithInfo:info.CommentList andCount:info.commentCount];
    if (praiseH == 0 && discussH == 0) {
        return 0;
    } else if (praiseH != 0 && discussH == 0) {
        return praiseH;
    } else if (praiseH == 0 && discussH != 0) {
        return discussH;
    } else {
        return praiseH + discussH + kHEIGHT(10);
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
