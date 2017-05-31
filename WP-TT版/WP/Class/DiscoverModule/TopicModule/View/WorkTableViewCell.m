//
//  WorkTableViewCell.m
//  WP
//
//  Created by 沈亮亮 on 15/7/6.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WorkTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "UIImage+MR.h"
#import "WPHttpTool.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"
#import <CoreText/CoreText.h>
#import "WPMySecurities.h"
#import "WPThreeBackView.h"
#import "WPWhitrBackView.h"
#import "WPDownLoadVideo.h"
@implementation WorkTableViewCell
{
    CTTypesetterRef typesetter;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

//        self.isNeedMore = NO;
//        self.contentView.backgroundColor = RGBColor(235, 235, 235);//RGBColor(235, 235, 235)
//        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200 - 6)];
//        self.backView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.backView];
//        
//        self.iconBtn = [[WPButton alloc] init];
//        self.iconBtn.frame = CGRectMake(kHEIGHT(10), 10, kHEIGHT(37), kHEIGHT(37));
//        self.iconBtn.clipsToBounds = YES;
//        self.iconBtn.layer.cornerRadius = 5;
//        self.iconBtn.contentMode = UIViewContentModeScaleAspectFill;
//        [self.iconBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.iconBtn];
//        
//        self.nickName = [[MLLinkLabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10, SCREEN_WIDTH - kHEIGHT(37) - 42 - 20 - 2*kHEIGHT(10) , 20)];
//        self.nickName.userInteractionEnabled = YES;
//        //        self.nickName.backgroundColor = [UIColor redColor];
//        self.nickName.textColor = AttributedColor;
//        self.nickName.font = kFONT(15);
//        self.nickName.text = @"华仔";
//        self.nickName.activeLinkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor,NSBackgroundColorAttributeName:WPGlobalBgColor};
//        [self.contentView addSubview:self.nickName];
//        
//        // 去掉、没有显示
//        self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 42, 10, 42, 18)];
//        self.attentionBtn.clipsToBounds = YES;
//        self.attentionBtn.layer.cornerRadius = 5;
//        self.attentionBtn.layer.borderColor = RGBColor(226, 226, 226).CGColor;
//        self.attentionBtn.layer.borderWidth = 0.5;
//        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
//        [self.attentionBtn setTitleColor:RGBColor(90, 118, 172) forState:UIControlStateNormal];
//        self.attentionBtn.titleLabel.font = GetFont(12);
//        
//        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 30, 34, 15)];
//        self.positionLabel.textColor = RGBColor(127, 127, 127);
//        self.positionLabel.text = @"经理";
//        self.positionLabel.font = kFONT(12);
//        [self.contentView addSubview:self.positionLabel];
//        
//        self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(101, 30, SCREEN_WIDTH - 111, 15)];
//        self.businessLabel.text = @"莱达商贸有限公司";
//        self.businessLabel.textColor = RGBColor(127, 127, 127);
//        self.businessLabel.font = kFONT(12);
//        [self.contentView addSubview:self.businessLabel];
//        
//        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10 + kHEIGHT(37), SCREEN_WIDTH - kHEIGHT(37) - 10 - 2*kHEIGHT(10), 0.5)];
//        line2.backgroundColor = RGBColor(226, 226, 226);
//        [self.contentView addSubview:line2];
//        
//        self.descriptionLabel = [[RSCopyLabel alloc] initWithFrame:CGRectMake(line2.right, line2.bottom + 8, SCREEN_WIDTH - kHEIGHT(37) - 10 - 2*kHEIGHT(10), 0)];
//        self.descriptionLabel.copyType = RSCopyTypeDynamic;
//        self.descriptionLabel.text = @"我是谁的水";
//        self.descriptionLabel.numberOfLines = 0;
//        self.descriptionLabel.font = kFONT(14);
//        self.descriptionLabel.userInteractionEnabled = YES;
//        self.descriptionLabel.contentMode = UIViewContentModeTop;
//        [self.contentView addSubview:self.descriptionLabel];
//        
//        self.stateLabel = [[UILabel alloc]init];
//        self.stateLabel.font = kFONT(14);
//        self.stateLabel.userInteractionEnabled= YES;
//        self.stateLabel.numberOfLines = 1;
//        self.stateLabel.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.stateLabel];
//        
//        
//        
//        self.allTetBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//        self.allTetBtn.frame = CGRectMake(line2.right, self.descriptionLabel.bottom-14, 30, 0);
//        [self.allTetBtn setTitle:@"全文" forState:UIControlStateNormal];
//        [self.allTetBtn setTitle:@"收起" forState:UIControlStateSelected];
//        [self.allTetBtn addTarget:self action:@selector(clickAllTextBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.allTetBtn addTarget:self action:@selector(clickThreeBtnDown:) forControlEvents:UIControlEventTouchDown];
//        [self.allTetBtn setTitleColor:AttributedColor forState:UIControlStateNormal];
//         [self.allTetBtn setTitleColor:AttributedColor forState:UIControlStateSelected];
//        self.allTetBtn.hidden = YES;
//        self.allTetBtn.titleLabel.font = kFONT(14);
//        self.allTetBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//        self.allTetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.allTetBtn.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.allTetBtn];
//        
//        self.whiteBackView =[[UIView alloc]initWithFrame:CGRectMake(self.allTetBtn.right, self.allTetBtn.top, SCREEN_WIDTH-self.allTetBtn.right, self.allTetBtn.height)];
//        self.whiteBackView.backgroundColor = [UIColor whiteColor];
//        self.whiteBackView.hidden = YES;
//        [self.contentView addSubview:self.whiteBackView];
//        
//        
//        self.photos = [[imageConsider alloc] initWithFrame:CGRectMake(0, self.descriptionLabel.bottom, SCREEN_WIDTH, 0)];
//        [self.contentView addSubview:self.photos];
//        
//        // 分享,简历招聘的背景
//        self.resume = [[ShareResume alloc] init];
//        [self.contentView addSubview:self.resume];
//        
//        self.dynamic = [[ShareDynamic alloc] init];
//        [self.contentView addSubview:self.dynamic];
//        
//        self.adressLabel = [[UILabel alloc] init];
//        self.adressLabel.textColor = RGB(127, 127, 127);
//        self.adressLabel.text = @"中绿广场";
//        self.adressLabel.font = kFONT(12);
//        [self.contentView addSubview:self.adressLabel];
//        
//        self.timeLabel = [[UILabel alloc] init];
//        self.timeLabel.text = @"4小时前";
//        self.timeLabel.textColor = RGB(127, 127, 127);
//        self.timeLabel.font = kFONT(12);
//        [self.contentView addSubview:self.timeLabel];
//        
//        self.dustbinBtn = [[UIButton alloc] init];
//        [self.dustbinBtn setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
//        [self.dustbinBtn addTarget:self action:@selector(dustbinClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.dustbinBtn];
//        
//        self.functionBtn = [WPButton buttonWithType:UIButtonTypeCustom];
//        [self.functionBtn setImage:[UIImage imageNamed:@"small_backgound_button"] forState:UIControlStateNormal];
//        [self.functionBtn setImage:[UIImage imageNamed:@"small_button_"] forState:UIControlStateHighlighted];
//        self.functionBtn.selected = NO;
//        
//        self.praiseLabel = [[UILabel alloc] init];
//        self.praiseLabel.text = @"30";
//        self.praiseLabel.font = kFONT(12);
//        
//        self.commentLabel = [[UILabel alloc] init];
//        self.commentLabel.text = @"30";
//        self.commentLabel.font = kFONT(12);
//        
//        // 底部的评论等
//        self.bottomView = [[DynamicBottomView alloc] init];
//        [self.contentView addSubview:self.bottomView];
    }
    
    return self;
    
}
#pragma mark 点击全文和收起
-(void)clickAllTextBtn:(UIButton*)sender
{
    if (self.clickAllTextBtn) {
        self.clickAllTextBtn(self.indexPath,sender);
    }
    [sender setBackgroundColor:[UIColor whiteColor]];
}
-(void)clickThreeBtnDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
#pragma mark 点击分享的简历和招聘
-(void)clickShareResumemian
{
    if (self.clickShareResume) {
        self.clickShareResume(self.indexPath);
    }

}
- (void)check
{
    NSString *is_hide = [NSString stringWithFormat:@"%@",_myDic[@"is_hide"]];
    if ([is_hide isEqualToString:@"3"]) {
        return;
    }
    //    NSLog(@"查看主页");
    if (self.checkActionBlock) {
        self.checkActionBlock(self.indexPath);
    }
}

- (void)dustbinClick
{
    //    NSLog(@"删除");
    if (self.deleteActionBlock) {
        self.deleteActionBlock(self.indexPath);
    }
}

- (void)longPressToDo
{
    //    self.descriptionLabel.backgroundColor = [UIColor lightGrayColor];
    //    self.nickName.backgroundColor = RGB(226, 226, 226);
    
    //    NSNotification *notification = [NSNotification notificationWithName:@"dynamicJump" object:nil userInfo:self.myDic];
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}

- (void)delay
{
    self.nickName.backgroundColor = [UIColor whiteColor];
}

-(void)addSubviews
{
    self.isNeedMore = NO;
    self.contentView.backgroundColor = RGBColor(235, 235, 235);//RGBColor(235, 235, 235)
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200 - 6)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.iconBtn = [[WPButton alloc] init];
    self.iconBtn.frame = CGRectMake(kHEIGHT(10), 10, kHEIGHT(37), kHEIGHT(37));
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.cornerRadius = 5;
    self.iconBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.iconBtn];
    
    self.nickName = [[MLLinkLabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10, SCREEN_WIDTH - kHEIGHT(37) - 42 - 20 - 2*kHEIGHT(10) , 20)];
    self.nickName.userInteractionEnabled = YES;
    //        self.nickName.backgroundColor = [UIColor redColor];
    self.nickName.textColor = AttributedColor;
    self.nickName.font = kFONT(15);
    self.nickName.text = @"华仔";
    self.nickName.activeLinkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor,NSBackgroundColorAttributeName:WPGlobalBgColor};
    [self.contentView addSubview:self.nickName];
    
    // 去掉、没有显示
    self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 42, 10, 42, 18)];
    self.attentionBtn.clipsToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 5;
    self.attentionBtn.layer.borderColor = RGBColor(226, 226, 226).CGColor;
    self.attentionBtn.layer.borderWidth = 0.5;
    [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:RGBColor(90, 118, 172) forState:UIControlStateNormal];
    self.attentionBtn.titleLabel.font = GetFont(12);
    
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 30, 34, 15)];
    self.positionLabel.textColor = RGBColor(127, 127, 127);
    self.positionLabel.text = @"经理";
    self.positionLabel.font = kFONT(12);
    [self.contentView addSubview:self.positionLabel];
    
    
    self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(101, 30, SCREEN_WIDTH - 111-kHEIGHT(10), 15)];
    self.businessLabel.text = @"莱达商贸有限公司";
    self.businessLabel.textColor = RGBColor(127, 127, 127);
    self.businessLabel.font = kFONT(12);
    [self.contentView addSubview:self.businessLabel];
    
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10 + kHEIGHT(37), SCREEN_WIDTH - kHEIGHT(37) - 10 - 2*kHEIGHT(10), 0.5)];
    line2.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line2];
    
    self.descriptionLabel = [[RSCopyLabel alloc] initWithFrame:CGRectMake(line2.right, line2.bottom + 8, SCREEN_WIDTH - kHEIGHT(37) - 10 - 2*kHEIGHT(10), 0)];
    self.descriptionLabel.copyType = RSCopyTypeDynamic;
    self.descriptionLabel.text = @"我是谁的水";
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = kFONT(14);
    self.descriptionLabel.userInteractionEnabled = YES;
    self.descriptionLabel.contentMode = UIViewContentModeTop;
    [self.contentView addSubview:self.descriptionLabel];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.font = kFONT(14);
    self.stateLabel.userInteractionEnabled= YES;
    self.stateLabel.numberOfLines = 1;
    self.stateLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.stateLabel];
    
    
    
    self.allTetBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    self.allTetBtn.frame = CGRectMake(line2.right, self.descriptionLabel.bottom-14, 30, 0);
    [self.allTetBtn setTitle:@"全文" forState:UIControlStateNormal];
    [self.allTetBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.allTetBtn addTarget:self action:@selector(clickAllTextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.allTetBtn addTarget:self action:@selector(clickThreeBtnDown:) forControlEvents:UIControlEventTouchDown];
    [self.allTetBtn setTitleColor:AttributedColor forState:UIControlStateNormal];
    [self.allTetBtn setTitleColor:AttributedColor forState:UIControlStateSelected];
    self.allTetBtn.hidden = YES;
    self.allTetBtn.titleLabel.font = kFONT(14);
    self.allTetBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.allTetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.allTetBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.allTetBtn];
    
    self.whiteBackView =[[UIView alloc]initWithFrame:CGRectMake(self.allTetBtn.right, self.allTetBtn.top, SCREEN_WIDTH-self.allTetBtn.right, self.allTetBtn.height)];
    self.whiteBackView.backgroundColor = [UIColor whiteColor];
    self.whiteBackView.hidden = YES;
    [self.contentView addSubview:self.whiteBackView];
    
    
    self.photos = [[imageConsider alloc] initWithFrame:CGRectMake(0, self.descriptionLabel.bottom, SCREEN_WIDTH, 0)];
    [self.contentView addSubview:self.photos];
    
    // 分享,简历招聘的背景
    self.resume = [[ShareResume alloc] init];
    [self.contentView addSubview:self.resume];
    
    self.dynamic = [[ShareDynamic alloc] init];
    [self.contentView addSubview:self.dynamic];
    
    self.adressLabel = [[UILabel alloc] init];
    self.adressLabel.textColor = RGB(127, 127, 127);
    self.adressLabel.text = @"中绿广场";
    self.adressLabel.font = kFONT(12);
    [self.contentView addSubview:self.adressLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = @"4小时前";
    self.timeLabel.textColor = RGB(127, 127, 127);
    self.timeLabel.font = kFONT(12);
    [self.contentView addSubview:self.timeLabel];
    
    self.dustbinBtn = [[UIButton alloc] init];
    [self.dustbinBtn setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
    [self.dustbinBtn addTarget:self action:@selector(dustbinClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dustbinBtn];
    
    self.functionBtn = [WPButton buttonWithType:UIButtonTypeCustom];
    [self.functionBtn setImage:[UIImage imageNamed:@"small_backgound_button"] forState:UIControlStateNormal];
    [self.functionBtn setImage:[UIImage imageNamed:@"small_button_"] forState:UIControlStateHighlighted];
    self.functionBtn.selected = NO;
    
    self.praiseLabel = [[UILabel alloc] init];
    self.praiseLabel.text = @"30";
    self.praiseLabel.font = kFONT(12);
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.text = @"30";
    self.commentLabel.font = kFONT(12);
    
    // 底部的评论等
    self.bottomView = [[DynamicBottomView alloc] init];
    [self.contentView addSubview:self.bottomView];
}
-(NSData*)imageData:(NSString*)imageString
{
    NSArray * pathArray = [imageString componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}

- (void)confineCellwithData:(NSDictionary *)dic
{
    
//    self.screenBtn = [[modeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.screenBtn.clickButton = ^(){
//       
//    };
//    self.screenBtn.backgroundColor = [UIColor redColor];
    
    
    
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self addSubviews];
    NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
    CGFloat x = kHEIGHT(10) + kHEIGHT(37) + 10;
    self.myDic = dic;
    self.descriptionLabel.dic = dic;
    if (self.type == WorkCellTypeSpecial ) {
        self.descriptionLabel.isDetail = YES;
    } else {
        self.descriptionLabel.isDetail = NO;
    }
    self.descriptionLabel.selectIndex = self.indexPath;
    
    
    NSInteger count = [dic[@"imgCount"] integerValue];
    NSInteger videoCount = [dic[@"videoCount"] integerValue];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar"]];//[IPADDRESS stringByAppendingString:dic[@"avatar"]]
    
    NSData * data = [self imageData:urlStr];
    if (data) {
        [self.iconBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }
    else
    {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [down downLoadImage:urlStr success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.iconBtn setImage:[UIImage imageWithData:response] forState:UIControlStateNormal];
                });
            } failed:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.iconBtn setImage:[UIImage imageNamed:@"small_cell_person"] forState:UIControlStateNormal];
                });
            }];
        });
       
        
    }
    
//    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];

    NSString *nameStr = dic[@"nick_name"];
    NSString *nameStr1 = [nameStr stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:nameStr2];
    [attStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(0,nameStr2.length)];
    
    self.nickName.userInteractionEnabled = YES;
    self.nickName.numberOfLines = 0;
    self.nickName.attributedText = attStr;
    //可以从这里改颜色
    for (MLLink *link in self.nickName.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [self.nickName invalidateDisplayForLinks];
    WS(ws);
    [self.nickName setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        [ws check];
    }];
    
    self.positionLabel.text = dic[@"POSITION"];
    self.businessLabel.text = dic[@"company"];
    self.timeLabel.text = dic[@"speak_add_time"];
    NSString *description = dic[@"speak_comment_content"];
//    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    NSString *description1 = [WPMySecurities textFromBase64String:description];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];

    if (description3.length == 0) {
        self.descriptionLabel.userInteractionEnabled = NO;
    }
    NSString *speak_comment_state = dic[@"speak_comment_state"];
    NSString *lastDestription = [NSString stringWithFormat:@"%@\n%@",speak_comment_state,description3];
    
    if (!description3.length) {
        lastDestription = speak_comment_state;
        if (![shareType isEqualToString:@"0"]) {
            lastDestription = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
        }
    }
    else
    {
        if ([description3 isEqualToString:@"分享"]) {
            lastDestription = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
        }
    }
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    NSString *attributedText;
    CGFloat descriptionLabelHeight;//内容的显示高度
    //    if ([dic[@"speak_comment_content"] length] == 0) {
    //        descriptionLabelHeight = normalSize.height;
    //    } else {
    descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
    CGFloat allHeight = descriptionLabelHeight;
    if (descriptionLabelHeight > normalSize.height *9) {//6
        if (self.type == WorkCellTypeNormal) {
            descriptionLabelHeight = normalSize.height *9 ;//6
            self.isNeedMore = YES;
            NSString *count = [self getCountWithString:lastDestription];
            NSString *subStr = [lastDestription substringToIndex:count.integerValue];//-3
            attributedText = [NSString stringWithFormat:@"%@...",subStr];
            for (NSIndexPath*indexpath in self.choiseArray) {
                if (self.indexPath == indexpath) {
                    descriptionLabelHeight = allHeight;
                    attributedText = lastDestription;
                }
            }
        } else {
            descriptionLabelHeight = descriptionLabelHeight;
            self.isNeedMore = NO;
            attributedText = lastDestription;
        }
    } else {
        self.isNeedMore = NO;
        descriptionLabelHeight = descriptionLabelHeight;
        attributedText = lastDestription;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedText];
    
    [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, speak_comment_state.length)];
    if (description3.length && [description3 isEqualToString:@"分享"]) {
        NSString * string = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
        [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, string.length)];
    }
    
    
    
    if (self.isNeedMore) {
//        [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(attributedText.length - 2, 2)];
    }
    
    self.descriptionLabel.attributedText = str;
    self.descriptionLabel.lineBreakMode = NSLineBreakByClipping;
    self.descriptionLabel.frame = CGRectMake(x, kHEIGHT(37) + 2*kHEIGHT(10), SCREEN_WIDTH - kHEIGHT(37) - kHEIGHT(10)*2 - 10, descriptionLabelHeight);
    
    
    self.stateLabel.frame = CGRectMake(self.descriptionLabel.left, self.descriptionLabel.top-10, self.descriptionLabel.width, normalSize.height+10);
    
    if (description3.length && ![description3 isEqualToString:@"分享"])
    {
        self.stateLabel.frame = CGRectMake(self.descriptionLabel.left, self.descriptionLabel.top-10, self.descriptionLabel.width, normalSize.height+10);
    }
    else
    {
        self.stateLabel.frame = CGRectMake(self.descriptionLabel.left, self.descriptionLabel.top-6, self.descriptionLabel.width, normalSize.height+10);
        
    }
    self.stateLabel.text = speak_comment_state;
    
    if ([description3 isEqualToString:@"分享"]) {
        self.stateLabel.text = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
    }
    self.stateLabel.textColor = AttributedColor;
    //加上全文的高度
    if (self.isNeedMore) {
        descriptionLabelHeight += normalSize.height+10;
    }
    
    
    //新添加的全文和收起的按钮
    if (self.isNeedMore == YES) {
        self.allTetBtn.hidden = NO;
        self.allTetBtn.frame = CGRectMake(x, self.descriptionLabel.bottom+10, 40, normalSize.height);
        for (NSIndexPath*indexpath in self.choiseArray) {
            if (indexpath == self.indexPath) {
                self.allTetBtn.selected = YES;
            }
        }
        self.whiteBackView.frame =CGRectMake(self.allTetBtn.right, self.allTetBtn.top, SCREEN_WIDTH-self.allTetBtn.right, self.allTetBtn.height);
    }
    else
    {
        
        self.allTetBtn.hidden = YES;
         self.whiteBackView.hidden = YES;
    }
    //    self.descriptionLabel.backgroundColor = [UIColor redColor];
    
    
    //    if (self.isNeedMore) {
    //        UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 120 - 10, self.descriptionLabel.bottom + 10, 120, normalSize.height)];
    ////        more.backgroundColor = [UIColor redColor];
    //        more.text = @"全文";
    //        more.textAlignment = NSTextAlignmentRight;
    //        more.textColor = AttributedColor;
    //        more.font = kFONT(14);
    //        [self.contentView addSubview:more];
    ////        UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(self.descriptionLabel.width - Size.width, normalSize.height*5, Size.width, Size.height)];
    ////        more.text = @"...全文";
    ////        more.backgroundColor = [UIColor whiteColor];
    ////        more.textColor = RGBColor(90, 118, 172);
    ////        more.font = kFONT(14);
    ////        [self.descriptionLabel addSubview:more];
    //
    //    }
    
    __block CGFloat photosHeight;//定义照片的高度
    self.resume.user_id = dic[@"user_id"];
    self.resume.sid = dic[@"sid"];
    self.resume.dic = dic;
    self.resume.index = self.indexPath;
    NSLog(@"当前shareMsg == %@", dic[@"shareMsg"]);
    if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) {
        photosHeight = kHEIGHT(43);
        
        //        if (self.isNeedMore) {
        //            self.resume.frame = CGRectMake(self.iconBtn.right + 10, self.descriptionLabel.bottom + 10 + normalSize.height + 10, SCREEN_WIDTH - kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
        //        } else {
        
        self.resume.frame = CGRectMake(self.iconBtn.right + 10, self.descriptionLabel.bottom + 10, SCREEN_WIDTH - kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
        //        }
        
        //加上全文的高度
        if (self.isNeedMore) {
           self.resume.frame = CGRectMake(self.iconBtn.right + 10, self.descriptionLabel.bottom + 10+10+normalSize.height, SCREEN_WIDTH - kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
        }
        
        
        if ([shareType isEqualToString:@"2"]) {
            self.resume.type = ShareResumeTypeJOb;
        } else {
            self.resume.type = ShareResumeTypeInvite;
        }
        self.resume.canTap = YES;
        self.resume.resumeInfo = dic[@"shareMsg"];
        
    } else if ([shareType isEqualToString:@"1"]) { //分享的说说
        //        photosHeight = [ShareDynamic calculateHeightWithInfo:dic[@"shareMsg"]];
        photosHeight = kHEIGHT(43);
        //        if (self.isNeedMore) {
        //            self.resume.frame = CGRectMake(self.iconBtn.right + 10, self.descriptionLabel.bottom + 10 + normalSize.height + 10, SCREEN_WIDTH - kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
        //        } else {
        
        self.resume.frame = CGRectMake(self.iconBtn.right + 10, self.descriptionLabel.bottom + 10, SCREEN_WIDTH - kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
        //        }
        //加上全文的高度
        if (self.isNeedMore) {
            self.resume.frame = CGRectMake(self.iconBtn.right + 10, self.descriptionLabel.bottom + 10+10+normalSize.height, SCREEN_WIDTH - kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
        }
        self.resume.type = ShareResumeTypeDynamic;
        self.resume.canTap = YES;
        self.resume.resumeInfo = dic[@"shareMsg"];
        //        self.dynamic.dynamicInfo = dic[@"shareMsg"];
        
    }else { //原说说
        CGFloat photoWidth;
        CGFloat videoWidth;
        
        photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
//        videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
        videoWidth = (SCREEN_WIDTH == 320) ? 112 : ((SCREEN_WIDTH == 375) ? 131 : 145);
        if (videoCount == 1) {
            NSLog(@"cell 有视频");
            photosHeight = videoWidth;
        } else {
            if (count == 0) {
                photosHeight = 0;
            } else if (count >= 1 && count <= 3) {
                photosHeight = photoWidth;
            } else if (count >= 4 && count <= 6) {
                photosHeight = photoWidth*2 + 3;
            } else {
                photosHeight = photoWidth*3 + 6;
            }
            
        }
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//            self.photos.workNetState = self.workNetState;
//            self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom + 10, SCREEN_WIDTH, photosHeight);
//            //加上全文的高度
//            if (self.isNeedMore) {
//                self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom + 10+10+normalSize.height, SCREEN_WIDTH, photosHeight);
//            }
//            self.photos.dicInfo = dic;
//            self.photos.index = self.indexPath;
//        
//        
//        });
        
        self.photos.isDetail = self.isFromDetail;
        self.photos.workNetState = self.workNetState;
        self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom + 10, SCREEN_WIDTH, photosHeight);
        //加上全文的高度
        if (self.isNeedMore) {
            self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom + 10+10+normalSize.height, SCREEN_WIDTH, photosHeight);
        }
        self.photos.dicInfo = dic;
        self.photos.index = self.indexPath;
    }
    
    CGFloat backViewHeight;
    //    backViewHeight = descriptionLabelHeight + photosHeight + 125 - 9;
    
    if ([dic[@"address"] length] == 0) { //没有地址
        
        if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
            //                if (self.isNeedMore) {
            //                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10;
            //                } else {
            backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32);
            //                }
        } else { //不是简历，求职
            if ([dic[@"original_photos"] count] == 0) {
                //                if (self.isNeedMore) {
                //                    backViewHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10;
                //                } else {
                backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32);
                //                }
            } else {
                //                if (self.isNeedMore) {
                //                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10;
                //                } else {
                backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32);
                //                }
            }
            
        }
        //        }
    } else { //有地址
        
        if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
            //                if (self.isNeedMore) {
            //                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10;
            //                } else {
            backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32);
            //                }
            //            }
        } else {
            if ([dic[@"original_photos"] count] == 0) {
                //                if (self.isNeedMore) {
                //                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10;
                //                } else {
                backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32);
                //                }
            } else {
                //                if (self.isNeedMore) {
                //                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10;
                //
                //                } else {
                backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32);
                //                }
            }
        }
        
    }
    
    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight);
    
#pragma 更改下面的坐标
    
    CGSize nickNameSize = [dic[@"nick_name"] sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize positionSize = [dic[@"POSITION"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(37) - nickNameSize.height - positionSize.height - 8)/2;
    self.nickName.frame =  (CGRect){{self.iconBtn.right + 10, self.iconBtn.top + y},nickNameSize};
    
    self.positionLabel.frame = (CGRect){{self.iconBtn.right + 10,self.nickName.bottom + 4},positionSize};
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.positionLabel.right + 6, self.nickName.bottom + 6, 0.5, 12)];
    //        line1.image = [UIImage imageNamed:@"small_bounds"];
    line1.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line1];
    
    CGSize businessSize = [dic[@"company"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    businessSize.width = SCREEN_WIDTH-positionSize.width-kHEIGHT(37)-kHEIGHT(10)-kHEIGHT(10)-kHEIGHT(20);
    self.businessLabel.frame = (CGRect){{self.positionLabel.right + 12,self.nickName.bottom + 4},businessSize};
    
    
    UIImageView *adress = [[UIImageView alloc] init];
    if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) { //分享的简历，求职
        adress.frame = CGRectMake(x, self.resume.bottom + 10, 10, 13);
        adress.image = [UIImage imageNamed:@"small_address"];
        [self.contentView addSubview:adress];
        
        CGSize adressSize = [dic[@"address"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        adressSize.width = SCREEN_WIDTH-adress.right-6-kHEIGHT(12);
        
        
        self.adressLabel.frame = (CGRect){{adress.right + 6, self.resume.bottom + 10},adressSize};
        
    } else if ([shareType isEqualToString:@"1"]) { //分享的说说
        adress.frame = CGRectMake(x, self.resume.bottom + 12, 10, 13);
        adress.image = [UIImage imageNamed:@"small_address"];
        [self.contentView addSubview:adress];
        
        CGSize adressSize = [dic[@"address"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        adressSize.width = SCREEN_WIDTH-adress.right-6-kHEIGHT(12);
        self.adressLabel.frame = (CGRect){{adress.right + 6, self.resume.bottom + 10},adressSize};
        
    }else {
        adress.frame = CGRectMake(x, self.photos.bottom + 12, 10, 13);
        adress.image = [UIImage imageNamed:@"small_address"];
        [self.contentView addSubview:adress];
        
        CGSize adressSize = [dic[@"address"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        adressSize.width = SCREEN_WIDTH-adress.right-6-kHEIGHT(12);
        if ([dic[@"original_photos"] count] == 0) {
                        if (self.isNeedMore) {
                            adress.frame = CGRectMake(x, self.descriptionLabel.bottom + 10 + normalSize.height + 12, 10, 13);
                            self.adressLabel.frame = (CGRect){{adress.right + 6, self.descriptionLabel.bottom + 10 + normalSize.height + 10},adressSize};
                        } else {
            adress.frame = CGRectMake(x, self.descriptionLabel.bottom + 12, 10, 13);
            self.adressLabel.frame = (CGRect){{adress.right + 6, self.descriptionLabel.bottom + 10},adressSize};
                        }
        } else {
            self.adressLabel.frame = (CGRect){{adress.right + 6, self.photos.bottom + 10},adressSize};
        }
    }
    
    self.adressLabel.text = dic[@"address"];
    self.commentLabel.text = dic[@"speak_trends_person"];
    self.praiseLabel.text = dic[@"speak_praise_count"];
    NSString *is_own = [NSString stringWithFormat:@"%@",dic[@"is_own"]];
    if ([is_own isEqualToString:@"0"]) {
        self.attentionBtn.hidden = YES;
        self.dustbinBtn.hidden = NO;
    } else {
        self.attentionBtn.hidden = NO;
        self.dustbinBtn.hidden = YES;
    }
    
    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
    if ([attention_state isEqualToString:@"0"]) {
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    } else if([attention_state isEqualToString:@"1"]) {
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else if ([attention_state isEqualToString:@"2"]) {
        [self.attentionBtn setTitle:@"粉丝" forState:UIControlStateNormal];
    } else if ([attention_state isEqualToString:@"3"]) {
        [self.attentionBtn setTitle:@"好友" forState:UIControlStateNormal];
    }
    
    UIImageView *line3 = [[UIImageView alloc] init];
    
    if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) { //分享的简历，求职
        if ([dic[@"address"] length] == 0) {
            adress.hidden = YES;
            line3.frame = CGRectMake(x, self.resume.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
        } else {
            line3.frame = CGRectMake(x, self.adressLabel.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
        }
    } else if ([shareType isEqualToString:@"1"]) { //分享的说说
        if ([dic[@"address"] length] == 0) {
            adress.hidden = YES;
            line3.frame = CGRectMake(x, self.resume.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
        } else {
            line3.frame = CGRectMake(x, self.adressLabel.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
        }
    }else {//原说说
        if ([dic[@"address"] length] == 0) {
            adress.hidden = YES;
            if ([dic[@"original_photos"] count] == 0) {
                //                if (self.isNeedMore) {
                //                    line3.frame = CGRectMake(x, self.descriptionLabel.bottom + kHEIGHT(10) + 26.702, SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
                //                } else {
                line3.frame = CGRectMake(x, self.descriptionLabel.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
                
                //无图片有更多时改变位置
                if (self.isNeedMore) {
                  line3.frame = CGRectMake(x, self.descriptionLabel.bottom + kHEIGHT(10)+normalSize.height+10, SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
                }
                //                }
            } else {
                line3.frame = CGRectMake(x, self.photos.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
            }
        } else {
            line3.frame = CGRectMake(x, self.adressLabel.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
        }
    }
    line3.backgroundColor = RGBColor(226, 226, 226);//
    [self.contentView addSubview:line3];
    
    WPThreeBackView * back = [[WPThreeBackView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-18-6, line3.bottom,3*kHEIGHT(57), kHEIGHT(32)-2)];
    [self.contentView addSubview:back];
    
    _threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _threeBtn.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-18-6, line3.bottom, 6+18+kHEIGHT(10), kHEIGHT(32)-2);
    BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
    if (isOrNot) {
      [_threeBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_not"] forState:UIControlStateNormal];
        [self.dustbinBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_nos"] forState:UIControlStateNormal];
    }
    else
    {
     [_threeBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zhankai"] forState:UIControlStateNormal];
    [self.dustbinBtn setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
    }
//    [_threeBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zhankai"] forState:UIControlStateNormal];
    [_threeBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zhankai_pre"] forState:UIControlStateHighlighted];
    
    
    
    _threeBtn.backgroundColor = [UIColor whiteColor];
    _threeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_threeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0,kHEIGHT(10))];
    [_threeBtn addTarget:self action:@selector(clickThreeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_threeBtn];
    
//    WPThreeBackView * back = [[WPThreeBackView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-6-3*kHEIGHT(57)-18, line3.bottom,3*kHEIGHT(57), kHEIGHT(32))];//SCREEN_WIDTH-kHEIGHT(10)-6-3*kHEIGHT(57)-18/／3*kHEIGHT(57)
//    //    back.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:back];
    __weak typeof(back) weak = back;
    back.clickShareButton = ^(NSIndexPath*indexpath){
        weak.hidden = YES;
        if (self.shareActionBlock) {
            self.shareActionBlock(indexpath);
        }
    };
    back.clickCommentButton = ^(NSIndexPath*indexpath){
        if (self.commentActionBlock) {
            self.commentActionBlock(indexpath);
        }
    };
    back.clickPraiseButton = ^(NSIndexPath*indexpath){
        if (self.praiseActionBlock) {
            self.praiseActionBlock(indexpath);
        }
    };
    back.is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//    back.hidden = YES;
//    WPWhitrBackView *whiteView = [[WPWhitrBackView alloc]initWithFrame:CGRectMake(back.right, back.top, SCREEN_WIDTH-back.right, back.height)];
//    [self.contentView addSubview:whiteView];
//    whiteView.hidden = YES;

    CGSize timeSize = [dic[@"speak_add_time"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.timeLabel.frame = (CGRect){{x,line3.bottom + kHEIGHT(32)/2 - timeSize.height/2},timeSize};
    self.dustbinBtn.frame = CGRectMake(self.timeLabel.right + 10, line3.bottom + kHEIGHT(32)/2 - 11, 10 + 10, 12 + 10);
    //    [self.dustbinBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.functionBtn.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 22, line3.bottom , kHEIGHT(10) + 22, kHEIGHT(32));
    [self.functionBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
    
    NSString *praise = [NSString stringWithFormat:@"  %@",dic[@"speak_praise_count"]];
    NSString *praiseCount = [NSString stringWithFormat:@"%@",dic[@"speak_praise_count"]];
    if ([praiseCount isEqualToString:@"0"]) {
        praise = @"  赞";
    }
    
    CGSize prasieSize = [praise sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.praiseLabel.frame = (CGRect){{SCREEN_WIDTH - 22 - prasieSize.width,line3.bottom + 10},prasieSize};
    
    
#pragma mark 点赞按钮
    RSClikcButton *praiseBtn = [[RSClikcButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 22 - prasieSize.width - 16, line3.bottom + kHEIGHT(32)/2 - 10.5, prasieSize.width + 16, 11 + 10)];
    //    praiseBtn.backgroundColor = [UIColor lightGrayColor];
    //    [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [praiseBtn setImage:[UIImage imageNamed:@"small_good"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"praise_blue"] forState:UIControlStateSelected];
    [praiseBtn setTitle:praise forState:UIControlStateNormal];
    [praiseBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    praiseBtn.titleLabel.font = kFONT(12);
    self.praiseBtn = praiseBtn;
    self.praiseBtn.tag = 10000;
    if (self.type == WorkCellTypeSpecial) {
        //        [self.praiseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.praiseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:praiseBtn];
    
    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
    if ([is_good isEqualToString:@"0"]) {
        self.praiseBtn.selected = NO;
    } else {
        self.praiseBtn.selected = YES;
    }
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(praiseBtn.left - 13, line3.bottom + 5, 0.5, 15)];
    //    line5.image = [UIImage imageNamed:@"small_bounds"];
    line5.backgroundColor = RGBColor(226, 226, 226);
    //    [self.contentView addSubview:line5];
    
    NSString *comment = [NSString stringWithFormat:@" %@",dic[@"speak_trends_person"]];
    NSString *commentCount = [NSString stringWithFormat:@"%@",dic[@"speak_trends_person"]];
    if ([commentCount isEqualToString:@"0"]) {
        comment = @" 评论";
    }
    
#pragma mark 评论的按钮
    CGSize commentSize = [comment sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.commentLabel.frame = (CGRect){{self.praiseBtn.left-22-commentSize.width,line3.bottom + 10},commentSize};
    
    RSClikcButton *commentBtn = [[RSClikcButton alloc] initWithFrame:CGRectMake(self.praiseBtn.left - 22 - commentSize.width - 16, line3.bottom + kHEIGHT(32)/2 - 10.5, commentSize.width + 16, 11 + 10)];
    [commentBtn setImage:[UIImage imageNamed:@"small_message"] forState:UIControlStateNormal];
    [commentBtn setTitle:comment forState:UIControlStateNormal];
    [commentBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    commentBtn.titleLabel.font = kFONT(12);
    self.commentBtn = commentBtn;
    self.commentBtn.tag = 10001;
    if (self.type == WorkCellTypeSpecial) {
        //        [self.commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
//    [self.contentView addSubview:commentBtn];
    [self.commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *share = [NSString stringWithFormat:@" %@",dic[@"shareCount"]];
    if ([dic[@"shareCount"] isEqualToString:@"0"]) {
        share = @" 分享";
    }
    CGSize shareSize = [share sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    
#pragma mark 分享的按钮
    RSClikcButton *btn = [[RSClikcButton alloc] initWithFrame:CGRectMake(self.commentBtn.left - 22 - shareSize.width - 20, line3.bottom + kHEIGHT(32)/2 - 10.5, shareSize.width + 20, 21)];
    //    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setImage:[UIImage imageNamed:@"dynamic_share"] forState:UIControlStateNormal];
    [btn setTitle:share forState:UIControlStateNormal];
    btn.tag = 10002;
    btn.titleLabel.font = kFONT(12);
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//    [self.contentView addSubview:btn];
    NSArray *praiseArr = dic[@"praiseUser"];
    NSArray *shareArr = dic[@"shareUser"];
    NSArray *discussArr = dic[@"DiscussUser"];
    
    CGFloat bottomHeight; //底部的高度
    if (self.type == WorkCellTypeNormal) {
        if (praiseArr.count == 0 && shareArr.count == 0 && discussArr.count == 0) {
            return;
        } else {
            UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(x, line3.bottom + kHEIGHT(32), SCREEN_WIDTH - x - kHEIGHT(10), 0.5)];
            line4.backgroundColor = RGB(226, 226, 226);
            [self.contentView addSubview:line4];
            
            bottomHeight = [DynamicBottomView calculateHeightWithInfo:dic];
            self.bottomView.frame = CGRectMake(0, line4.bottom + kHEIGHT(10), SCREEN_WIDTH, bottomHeight);
            self.bottomView.indexPath = self.indexPath;
            self.bottomView.dynamicInfo = dic;
#pragma mark - 重新计算backView的高度
            
            if ([dic[@"address"] length] == 0) { //没有地址
                
                if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                } else { //不是简历，求职
                    if ([dic[@"original_photos"] count] == 0) {
                        backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                    } else {
                        backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                    }
                    
                }
            } else { //有地址
                
                if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                } else {
                    if ([dic[@"original_photos"] count] == 0) {
                        backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                    } else {
                        backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                    }
                }
                
            }
#pragma mark - 重新设置backView的高度
            self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight);
        }
    }
}

-(BOOL)clickNotFinish:(NSString*)guid
{
    BOOL isOrNot = NO;
    NSMutableArray * muarray = [NSMutableArray array];
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"UPLOAdSHUOSHUO"];
    if (array.count) {
        for (NSDictionary * dic in array) {
            NSArray * array1 = [dic allKeys];
            [muarray addObject:array1[0]];
        }
    }
    NSArray * dicArray = [NSArray arrayWithArray:muarray];
    for (NSString * string in dicArray) {
        if ([string isEqualToString:guid]) {
            isOrNot = YES;
            break;
        }
    }
    return isOrNot;
}
-(void)layoutSubviews
{

  
}

#pragma mark 点击分享，评论，赞的按钮
-(void)clickThreeBtn
{
    if (self.clickThreeButton) {
        self.clickThreeButton(self.indexPath);
    }
}
- (void)buttonClick:(UIButton *)btn
{
    //    btn.selected = !btn.isSelected;
    if (btn.tag == 10000) {
        //        NSLog(@"赞");
        if (self.praiseActionBlock) {
            self.praiseActionBlock(self.indexPath);
        }
    } else if (btn.tag == 10001) {
        //        NSLog(@"评论");
        if (self.commentActionBlock) {
            self.commentActionBlock(self.indexPath);
        }
    } else if (btn.tag == 10002) {
        //        NSLog(@"分享");
        if (self.shareActionBlock) {
            self.shareActionBlock(self.indexPath);
        }
    }
}

- (NSString *)accordingToSpeakType:(NSString *)sepak_type
{
    NSString *type;
    
    return type;
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

#pragma mark - 获取6行的字数
- (NSString *)getCountWithString:(NSString *)string
{
    //    NSLog(@"%@",string);
    NSLog(@"%lu",(unsigned long)string.length);
    NSMutableAttributedString *stttribute = [[NSMutableAttributedString alloc] initWithString:string];
    [stttribute addAttribute:NSFontAttributeName value:kFONT(14) range:NSMakeRange(0, string.length)];
    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                        (stttribute));
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat w = SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10;
    //    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [stttribute length];
    int tempK = 0;
    while (start < length){
//                CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, w);
        
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= normalSize.height;
        CFRelease(line);
        tempK++;
        if (tempK == 9) {//6
            //            NSLog(@"%ld",start);
            NSString *count = [NSString stringWithFormat:@"%ld",start];
            return count;
            //            break;
        }
    }
    
    return 0;
    
}

////功能按钮
//- (void)functionClick:(UIButton *)sender{
//    NSLog(@"功能按钮");
//    _btn1.hidden = NO;
//    if (sender.isSelected == YES) {
//        self.functionBtn.selected = NO;
//        self.btn1 = nil;
//        self.btn2 = nil;
//        self.line = nil;
//        [self.btn1 removeFromSuperview];
//        [self.btn2 removeFromSuperview];
//        [self.line removeFromSuperview];
//        [UIView animateWithDuration:0.2 animations:^{
//           self.functionImage.frame = CGRectMake(SCREEN_WIDTH - 32, self.y, 0, 32);
//
//        }];
//        [self performSelector:@selector(hide) withObject:self afterDelay:0.2];
//
//
//    } else {
//        self.functionBtn.selected = YES;
//        [UIView animateWithDuration:0.2 animations:^{
//            self.functionImage.frame = CGRectMake(SCREEN_WIDTH - 32 - 142, self.y, 142, 32);
//            [self btn1];
//            [self btn2];
//            [self line];
//            self.functionImage.hidden = NO;
//        }];
//        
//        
//    }
//}
//
//- (void)hide{
//    self.functionImage.hidden = YES;
//}
//
////赞和评论的按钮点击事件
//- (void)btnClick:(UIButton *)sender
//{
////    self.functionImage.hidden = YES;
//    self.functionBtn.selected = NO;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.functionImage.frame = CGRectMake(SCREEN_WIDTH - 32, self.y, 0, 32);
//    }];
//    _btn1.hidden = YES;
//    if (sender.tag == 10) {
//        NSLog(@"评论");
////        if ([self.delegate respondsToSelector:@selector(commentWithInfo:)]) {
//            [self.delegate commentWithInfo:@{@"sid" : self.myDic[@"sid"]} andObj:self];
////        }
//        
//    } else {
//        NSLog(@"赞");
//        
//    }
//}
//
//- (void)commentBtnClick{
//    self.functionBtn.selected = NO;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.functionImage.frame = CGRectMake(SCREEN_WIDTH - 32, self.y, 0, 32);
//    }];
//    _btn1.hidden = YES;
//}
//

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
