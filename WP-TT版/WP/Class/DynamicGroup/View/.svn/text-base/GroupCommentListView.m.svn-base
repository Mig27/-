//
//  GroupCommentListView.m
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupCommentListView.h"
#import "GroupCommentCell.h"
#import "WPMySecurities.h"

@interface GroupCommentListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *clickIndex;
@property (nonatomic, strong) GroupCommentCell *clickCell;

@end

@implementation GroupCommentListView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clickCell = [[GroupCommentCell alloc] init];
        //        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.discussArr.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCommentCell *cell = [GroupCommentCell cellWithTableView:tableView];
    cell.dataSource = self.discussArr;
    cell.currentIndex = indexPath;
    cell.discussIndexPath = self.discussIndex;
    cell.dic = self.discussArr[indexPath.row];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    recognizer.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:recognizer];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GroupCommentCell cellHeightWithIndex:indexPath andDatasource:self.discussArr];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    if (self.discussCount.integerValue > 6) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, normalSize.height + 10)];
        bottomView.userInteractionEnabled = YES;
        bottomView.backgroundColor = [UIColor whiteColor];
        [bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
        NSString *str = [NSString stringWithFormat:@"查看全部%@条评论...",self.discussCount];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10) + kHEIGHT(37) + 10, 10, SCREEN_WIDTH - 2*kHEIGHT(10) - kHEIGHT(37) - 10, normalSize.height)];
        label.font = kFONT(12);
        label.textColor = AttributedColor;
        label.text = str;
        [bottomView addSubview:label];
        return bottomView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    if (self.discussCount.integerValue > 6) {
        return normalSize.height + 10;
    } else {
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.commentLabel.backgroundColor = RGB(226, 226, 226);
    CommentListModel *discssDic = self.discussArr[indexPath.row];
    self.clickIndex = indexPath;
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *userid = userInfo[@"userid"];
    NSString *user_id = discssDic.created_user_id;
//    NSString *speak_id = discssDic.album_id;
    NSString *sid = discssDic.commentId;
    NSString *nick_name = discssDic.created_nick_name;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[userid isEqualToString:user_id] ? @"deletAlumDiscuss" : @"commentAlumTopic" object:nil userInfo:@{@"user_id" : user_id, @"sid" : sid , @"nick_name" : nick_name, @"index" : self.discussIndex}];
    
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}

- (void)delay
{
    GroupCommentCell *cell = [self.tableView cellForRowAtIndexPath:self.clickIndex];
    cell.commentLabel.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 点击footer进入详情
- (void)onTap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlumJumpToDetail" object:nil userInfo:@{@"index" : self.discussIndex}];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        GroupCommentCell *cell = (GroupCommentCell *)recognizer.view;
        self.clickCell = cell;
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        self.clickIndex = index;
        //        NSLog(@"%@",self.clickIndex);
        cell.commentLabel.backgroundColor = RGB(226, 226, 226);
        [cell becomeFirstResponder];
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(flag:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:cell.commentLabel.frame inView:cell.commentLabel.superview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - 粘贴文字,这里需要把安卓的表情替换过来
- (void)flag:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [WPMySecurities textFromEmojiString:[self.discussArr[self.clickIndex.row] comment_content]];
}

-(void)WillHideMenu:(id)sender

{
    self.clickCell.commentLabel.backgroundColor = [UIColor whiteColor];
}


#pragma mark - 计算评论的高度
+ (CGFloat)calculateHeightWithInfo:(NSArray *)arr andCount:(NSString *)count
{
    NSMutableArray *discussStrs = [NSMutableArray array];
    //默认一行的高度
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    for (int i=0; i<arr.count; i++) { //把聊天的内容拼接起来
        CommentListModel *dic = arr[i];
        NSString *nick_name = dic.created_nick_name;
        NSString *by_nick_name = dic.replay_nick_name;
        NSString *speak_comment_content = [WPMySecurities textFromEmojiString:dic.comment_content];
        speak_comment_content = [WPMySecurities textFromBase64String:speak_comment_content];
        if (!speak_comment_content.length) {
            speak_comment_content = [WPMySecurities textFromEmojiString:dic.comment_content];
        }
        
        
        NSString *discussStr;
        if (by_nick_name.length == 0) {
            discussStr = [NSString stringWithFormat:@"%@ ：%@",nick_name,speak_comment_content];
        } else {
            discussStr = [NSString stringWithFormat:@"%@ 回复 %@ ：%@",nick_name,by_nick_name,speak_comment_content];
        }
        [discussStrs addObject:discussStr];
    }
    
    //计算View的高度
    if (discussStrs.count == 0) {//没有评论
        return 0;
    } else { //有评论
        CGFloat viewHeight = 0;
        for (int i = 0; i<discussStrs.count; i++) {
            CGFloat strH = [discussStrs[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
            viewHeight = viewHeight + strH;
        }
        viewHeight = count.integerValue > 6 ? (viewHeight + normalSize.height + 10*6) : (viewHeight + (discussStrs.count - 1)*10);//10
        return viewHeight;
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
