//
//  WPCommonCommentHeadCell.m
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCommonCommentHeadCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "WPMySecurities.h"
#import "MLLinkLabel.h"
typedef NS_ENUM(NSInteger, WPCommonCommentHeadCellControlType) {
    WPCommonCommentHeadCellControlTypeIcon = 10000,
    WPCommonCommentHeadCellControlTypeName = 20000,
    WPCommonCommentHeadCellControlTypePosition = 30000,
    WPCommonCommentHeadCellControlTypeTime = 40000,
    WPCommonCommentHeadCellControlTypeContent = 50000,
    WPCommonCommentHeadCellControlTypeClick = 60000,
};
@interface WPCommonCommentHeadCell ()
@property (nonatomic ,strong)UIButton *iconBtn;
@property (nonatomic, strong)UILabel *positionLabel;
@property (nonatomic, strong)UIButton *nickName;
@property (nonatomic ,strong)UILabel *descriptionLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic ,strong)UIButton * toName;

@property (nonatomic, strong) MLLinkLabel *titleLabel;
@property (nonatomic, strong) MLLinkLabel *subTitleLabel;
@end
@implementation WPCommonCommentHeadCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = WPCommonCommentHeadCellControlTypeClick;
        button.frame = self.bounds;
//        [self addSubview:button];
        [button addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
        
        
        //添加下划线
       UILabel* lineLa = [[UILabel alloc] initWithFrame:CGRectMake(0,kHEIGHT(50)-0.5, SCREEN_WIDTH, 0.5)];
        lineLa.backgroundColor = RGBColor(226, 226, 226);
//        _line.tag = 1000;
//        [self addSubview:lineLa];
        
        [self.iconBtn addTarget:self action:@selector(checkCommentPersonHomePage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.iconBtn];
        
        //        NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
        //        [iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
        
        [self addSubview:self.nickName];
        
        [self addSubview:self.positionLabel];
        
        [self addSubview:self.subTitleLabel];
        
        [self addSubview:self.timeLabel];
        
//        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

- (UIButton *)iconBtn // 头像
{
    if (!_iconBtn) {
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.frame = CGRectMake(kHEIGHT(16.5), kHEIGHT(10), kHEIGHT(30), kHEIGHT(30));
        self.iconBtn.layer.cornerRadius = 5;
        self.iconBtn.clipsToBounds = YES;
    }
    return _iconBtn;
}

- (UILabel *)positionLabel  // 职位和公司
{
    if (!_positionLabel) {
        self.positionLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(_nickName.right + 10, _nickName.origin.y, SCREEN_WIDTH - 120, 12)];
        self.positionLabel.font = kFONT(10);
        self.positionLabel.textColor = RGBColor(126, 126, 126);
        self.positionLabel.text = @"职位和公司";
        self.positionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _positionLabel;
}

- (UIButton *)nickName
{
    if (!_nickName) {
        self.nickName = [UIButton buttonWithType:UIButtonTypeCustom];//WithFrame:CGRectMake(_iconBtn.right + 10, _positionLabel.top-20-8, SCREEN_WIDTH - 120, 20)];
        self.nickName.titleLabel.font = kFONT(12);
//        [self.nickName setTintColor:RGB(90, 110, 150)]
        [self.nickName setTitleColor:RGB(90, 110, 150) forState:UIControlStateNormal];
        [self.nickName addTarget:self action:@selector(checkCommentPersonHomePage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nickName;
}
- (UILabel *)descriptionLabel // 留言内容
{
    if (!_descriptionLabel) {
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = kFONT(12);
    }
    return _descriptionLabel;
}

- (UILabel *)subTitleLabel // 留言内容
{
    if (!_subTitleLabel) {
        self.subTitleLabel = [[MLLinkLabel alloc] init];
        self.subTitleLabel.numberOfLines = 0;
        self.subTitleLabel.font = kFONT(12);
        self.subTitleLabel.userInteractionEnabled = YES;
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-120, kHEIGHT(10), 120, 12)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = kFONT(10);
        self.timeLabel.textColor = RGBColor(170, 170, 170);
        self.timeLabel.text = @"时间";
    }
    return _timeLabel;
}

- (void)reply{
    if (self.ReplyBlock) {
        self.ReplyBlock(self.tag);
    }
}

- (void)checkCommentPersonHomePage:(UIButton *)sender{
    if (self.UserInfoBlock) {
        self.UserInfoBlock(_model.createdUserId,_model.userName);
    }
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (void)setModel:(WPResumeCheckMessageModel *)model{
    _model = model;
    if (model.avatar) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
        [self.iconBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    }
    
    //设置距左边的距离(和头部对齐)
    CGRect rect = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
    CGFloat center = kHEIGHT(43)/2+10;
    UIView * view = [[UIView alloc]initWithFrame:rect];
    view.center = CGPointMake(center, center);
    CGFloat leftDistance = view.frame.size.width + view.frame.origin.x;
    
    NSString * nameStr = [NSString stringWithFormat:@"%@",model.userName];
    if (nameStr.length > 6) {
        nameStr = [nameStr substringToIndex:6];
    }
    [self.nickName setTitle:nameStr forState:UIControlStateNormal];
//    [self.nickName setBackgroundColor:[UIColor redColor]];
    self.nickName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGSize size = [nameStr getSizeWithFont:FUCKFONT(12) Height:20];
    self.nickName.frame = CGRectMake(leftDistance+12, kHEIGHT(10), size.width+4, 15);//_iconBtn.origin.y
    [self.nickName setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(size.width+4, 20)] forState:UIControlStateHighlighted];

    
    NSString * positionStr = [NSString stringWithFormat:@"%@",model.position];
    NSString * companyStr = [NSString stringWithFormat:@"%@",model.company];
    if (positionStr.length > 6) {
        positionStr = [positionStr substringToIndex:6];
    }
    if (companyStr.length > 6) {
        companyStr = [companyStr substringToIndex:6];
    }
    
    self.positionLabel.text = [NSString stringWithFormat:@"%@ | %@",positionStr,companyStr];
    size = [self.positionLabel.text getSizeWithFont:FUCKFONT(10) Height:20];
    self.positionLabel.frame = CGRectMake(_nickName.right+6, kHEIGHT(10), size.width, 15);
    self.timeLabel.text = model.addTime;
    
    //评论
    NSString *commentStr;
    NSMutableAttributedString *commentAttStr;
    NSString * by_nick_name = [NSString stringWithFormat:@"%@",model.to_nick_name];
    //    NSString *speak_comment_content = [WPMySecurities textFromEmojiString:dic[@"speak_comment_content"]];
    
    
    
    
    NSString * commentString = model.commentContent;
    commentString = [WPMySecurities textFromBase64String:commentString];
    commentString = [WPMySecurities textFromEmojiString:commentString];
    if (!commentString.length) {
        commentString = model.commentContent;
    }
    
//    commentString = [commentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    commentString = [commentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (by_nick_name.length == 0) {
        commentStr = [NSString stringWithFormat:@"%@",commentString];//[WPMySecurities textFromEmojiString:model.commentContent]
        commentAttStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
    } else {
        commentStr = [NSString stringWithFormat:@"回复 %@ ：%@",by_nick_name,commentString];//[WPMySecurities textFromEmojiString:model.commentContent]
        commentAttStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
        [commentAttStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(3,by_nick_name.length)];
        
    }
    self.subTitleLabel.attributedText = commentAttStr;
//    self.subTitleLabel.backgroundColor = [UIColor greenColor];
    //可以从这里改颜色
    for (MLLink *link in self.subTitleLabel.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [self.subTitleLabel invalidateDisplayForLinks];
    //    WS(ws);
    __weak typeof(self) weakSelf = self;
    [self.subTitleLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSLog(@"点击人名");
        if (weakSelf.UserInfoBlock) {
            weakSelf.UserInfoBlock(model.to_user_id,model.to_user_name);
        }
    }];
    CGFloat height = [self sizeWithString:commentStr fontSize:FUCKFONT(12)].height;
    self.subTitleLabel.frame = CGRectMake(self.nickName.left, self.nickName.bottom+3 , SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, height);
    self.subTitleLabel.font = kFONT(12);
    
//    self.line.frame = CGRectMake(0, self.subTitleLabel.bottom + kHEIGHT(10) - 0.5, SCREEN_WIDTH, 0.5)
    
//    NSString * toNickName = [NSString stringWithFormat:@"%@",model.to_nick_name];
//    if (toNickName.length && ![toNickName isEqualToString:@"(null)"]) {
//        NSString * comcontentStr = [NSString stringWithFormat:@"回复%@:%@",toNickName,model.commentContent];
//        
//        
//    }
//    else
//    {
//    
//        size = [model.commentContent getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH - kHEIGHT(30) - 43];
//        self.descriptionLabel.frame = CGRectMake(_iconBtn.right+16.5, _positionLabel.bottom, SCREEN_WIDTH - kHEIGHT(30) - 43, size.height);
//        self.descriptionLabel.text = model.commentContent;
//        
//        CGFloat height = [WPCommonCommentHeadCell cellHeight:model.commentContent];
//        
//        UIButton *button = [self viewWithTag:WPCommonCommentHeadCellControlTypeClick];
//        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+self.nickName.bottom);
//    button.backgroundColor = [UIColor redColor];
//    }
}
#pragma mark - 根据字体大小获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}


+ (CGFloat)cellHeight:(NSString *)string{//SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10//SCREEN_WIDTH-kHEIGHT(30) - 40
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil].size;
    CGFloat height = kHEIGHT(10+30+11);
    NSLog(@"%f",height);
    CGFloat h = [@"姓名" getSizeWithFont:FUCKFONT(12) Height:20].height;
    CGFloat Height = lroundf((kHEIGHT(20)+h+size.height));
    return height>Height?height:Height;
}

//【super layoutsubviews】【self lauoutifneed】

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}
//
//- (void)layoutIfNeeded
//{
//    [self layoutIfNeeded];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
