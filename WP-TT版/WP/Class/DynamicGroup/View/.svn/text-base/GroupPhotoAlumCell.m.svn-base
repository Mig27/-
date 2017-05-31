//
//  GroupPhotoAlumCell.m
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupPhotoAlumCell.h"

#import "UIImageView+WebCache.h"
#import "UIImage+MR.h"
#import "WPHttpTool.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"
#import <CoreText/CoreText.h>
#import "WPMySecurities.h"

@implementation GroupPhotoAlumCell
{
    CTTypesetterRef typesetter;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(235, 235, 235);
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200 - 6)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.iconBtn = [[WPButton alloc] init];
        self.iconBtn.frame = CGRectMake(kHEIGHT(10), 10, kHEIGHT(37), kHEIGHT(37));
        self.iconBtn.clipsToBounds = YES;
        self.iconBtn.layer.cornerRadius = 5;
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
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 30, 34, 15)];
        self.positionLabel.textColor = RGBColor(127, 127, 127);
        self.positionLabel.text = @"经理";
        self.positionLabel.font = kFONT(12);
        [self.contentView addSubview:self.positionLabel];
        
        self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(101, 30, SCREEN_WIDTH - 111, 15)];
        self.businessLabel.text = @"莱达商贸有限公司";
        self.businessLabel.textColor = RGBColor(127, 127, 127);
        self.businessLabel.font = kFONT(12);
        [self.contentView addSubview:self.businessLabel];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10 + kHEIGHT(37), SCREEN_WIDTH - kHEIGHT(37) - 10 - 2*kHEIGHT(10), 0.5)];
        line2.backgroundColor = RGBColor(226, 226, 226);
        [self.contentView addSubview:line2];
        
        self.descriptionLabel = [[RSCopyLabel alloc] initWithFrame:CGRectMake(line2.right, line2.bottom + 8, SCREEN_WIDTH - kHEIGHT(37) - 10 - 2*kHEIGHT(10), 0)];
        self.descriptionLabel.copyType = RSCopyTypeGroup;
        self.descriptionLabel.text = @"我是谁的水";
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = kFONT(14);
        self.descriptionLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:self.descriptionLabel];
        
        
        self.allTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.allTextBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.allTextBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.allTextBtn setTitleColor:AttributedColor forState:UIControlStateNormal];
        [self.allTextBtn setTitleColor:AttributedColor forState:UIControlStateSelected];
        [self.allTextBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.allTextBtn addTarget:self action:@selector(clickAllTextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.allTextBtn addTarget:self action:@selector(clickAllTextBtnDown:) forControlEvents:UIControlEventTouchDown];
        self.allTextBtn.hidden = YES;
        self.allTextBtn.titleLabel.font = kFONT(14);
        [self.contentView addSubview:self.allTextBtn];
        
        
        self.photos = [[GroupPhotoConsider alloc] initWithFrame:CGRectMake(0, self.descriptionLabel.bottom, SCREEN_WIDTH, 0)];
        [self.contentView addSubview:self.photos];
        
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
        
        // 底部的评论等
        self.bottomView = [[GroupBottomView alloc] init];
        [self.contentView addSubview:self.bottomView];
        
       
        
        
    }
    
    return self;
    
}
#pragma mark 点击评论按钮
-(void)clickTwoBtn:(UIButton*)sender
{
    if (self.clickTwoBtn) {
        self.clickTwoBtn(self.indexPath);
    }
}
-(void)clickAllTextBtn:(UIButton*)sender
{
    if (self.clickAllTextBtn) {
        self.clickAllTextBtn(self.indexPath,sender);
    }
    [sender setBackgroundColor:[UIColor whiteColor]];
}
-(void)clickAllTextBtnDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
- (void)setDic:(GroupPhotoAlumListModel *)dic
{
    CGFloat x = kHEIGHT(10) + kHEIGHT(37) + 10;
    self.descriptionLabel.model = dic;
    self.descriptionLabel.copyType = RSCopyTypeGroup;
    self.descriptionLabel.selectIndex = self.indexPath;
    if (self.isDetail) {
        self.descriptionLabel.isDetail = YES;
    } else {
        self.descriptionLabel.isDetail = NO;
    }
    NSInteger count = dic.PhotoList.count;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,dic.avatar];//[IPADDRESS stringByAppendingString:dic.avatar]
    [self.iconBtn sd_setBackgroundImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *nameStr = dic.user_name;
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
    
    self.positionLabel.text = dic.position;
    self.businessLabel.text = dic.company;
    
    self.timeLabel.text = dic.add_time;
    
    NSString *description = dic.remark;
//    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
//    NSString *lastDestription = [WPMySecurities textFromEmojiString:description3];
    
    NSString *description1 = [WPMySecurities textFromBase64String:description];
    NSString *lastDestription = [WPMySecurities textFromEmojiString:description1];

//    NSLog(@"%@",lastDestription);
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    NSString *attributedText;
    CGFloat descriptionLabelHeight;//内容的显示高度
    descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
    
    CGFloat allHeight = descriptionLabelHeight;
//            NSLog(@"%f",descriptionLabelHeight);
    if (descriptionLabelHeight > normalSize.height *8) {//6
        if (!self.isDetail) {
            descriptionLabelHeight = normalSize.height *8 ;//6
            self.isNeedMore = YES;
            NSString *count = [self getCountWithString:lastDestription];
            NSString *subStr = [lastDestription substringToIndex:count.integerValue];//- 3
            attributedText = [NSString stringWithFormat:@"%@...",subStr];
            
            for (NSIndexPath*index in self.choiseArray) {
                if (index == self.indexPath) {
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
    if (dic.remark.length == 0) {
        descriptionLabelHeight = 0;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedText];
    if (self.isNeedMore) {
//        [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(attributedText.length - 2, 2)];
    }
    self.descriptionLabel.attributedText = str;
    self.descriptionLabel.frame = CGRectMake(x, kHEIGHT(37) + 2*kHEIGHT(10), SCREEN_WIDTH - kHEIGHT(37) - kHEIGHT(10)*2 - 10, descriptionLabelHeight);
    
    
    
    if (self.isNeedMore)
    {
        self.allTextBtn.hidden = NO;
        self.allTextBtn.frame = CGRectMake(x, self.descriptionLabel.bottom+10, 40, normalSize.height);
        //加上全文的高度
        descriptionLabelHeight += normalSize.height+10;
        BOOL isOrNot = NO;
        for (NSIndexPath*index in self.choiseArray) {
            if (index == self.indexPath) {
                isOrNot = YES;
            }
        }
        if (isOrNot) {
            self.allTextBtn.selected = YES;
        }
        else
        {
            self.allTextBtn.selected = NO;
        }
        
    }
    else
    {
        self.allTextBtn.hidden = YES;
    }
    
    
    __block CGFloat photosHeight;//定义照片的高度
        CGFloat photoWidth;
    
        photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
        if (count == 0) {
            photosHeight = 0;
        } else if (count >= 1 && count <= 3) {
            photosHeight = photoWidth;
        } else if (count >= 4 && count <= 6) {
            photosHeight = photoWidth*2 + 3;
        } else {
            photosHeight = photoWidth*3 + 6;
        }
    if (dic.remark.length != 0) {
        self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom + 10, SCREEN_WIDTH, photosHeight);
        
        //加上全文的高度
        if (self.isNeedMore) {
           self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom + 10 + normalSize.height + 10, SCREEN_WIDTH, photosHeight);
        }
    } else {
        self.photos.frame = CGRectMake(0, kHEIGHT(37) + 2*kHEIGHT(10), SCREEN_WIDTH, photosHeight);

    }
//    self.photos.isFromColume = self.isFromColume;
    self.photos.dicInfo = dic;
    
    CGFloat backViewHeight;
    
    if ([dic.address length] == 0) { //没有地址
        
            if ([dic.PhotoList count] == 0) {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32);
            } else {
                if (dic.remark.length != 0) {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32);
                } else {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + kHEIGHT(10) + kHEIGHT(32);
                }
            }
    } else { //有地址
        
            if ([dic.PhotoList count] == 0) {
                backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32);
            } else {
                if (dic.remark.length != 0) {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32);
                } else {
                    backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32);
                }
            }
    }
    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight);
    
#pragma 更改下面的坐标
    
    CGSize nickNameSize = [dic.user_name sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize positionSize = [dic.position sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(37) - nickNameSize.height - positionSize.height - 8)/2;
    self.nickName.frame =  (CGRect){{self.iconBtn.right + 10, self.iconBtn.top + y},nickNameSize};
    
    self.positionLabel.frame = (CGRect){{self.iconBtn.right + 10,self.nickName.bottom + 4},positionSize};
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.positionLabel.right + 6, self.nickName.bottom + 6, 0.5, 12)];
    line1.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line1];
    
    CGSize businessSize = [dic.company sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.businessLabel.frame = (CGRect){{self.positionLabel.right + 12,self.nickName.bottom + 4},businessSize};
    
    UIImageView *adress = [[UIImageView alloc] init];
        adress.frame = CGRectMake(x, self.photos.bottom + 12, 10, 13);
        adress.image = [UIImage imageNamed:@"small_address"];
        [self.contentView addSubview:adress];
        
        CGSize adressSize = [dic.address sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        if ([dic.PhotoList count] == 0) {
            adress.frame = CGRectMake(x, self.descriptionLabel.bottom + 12, 10, 13);
            self.adressLabel.frame = (CGRect){{adress.right + 6, self.descriptionLabel.bottom + 10},adressSize};
        } else {
            self.adressLabel.frame = (CGRect){{adress.right + 6, self.photos.bottom + 10},adressSize};
        }
    
    self.adressLabel.text = dic.address;
        self.dustbinBtn.hidden = NO;
    
    UIImageView *line3 = [[UIImageView alloc] init];
    
        if ([dic.address length] == 0) {
            adress.hidden = YES;
            if ([dic.PhotoList count] == 0) {
                line3.frame = CGRectMake(x, self.descriptionLabel.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
                
                //加上全文的高度
                if (self.isNeedMore) {
                  line3.frame = CGRectMake(x, self.descriptionLabel.bottom + kHEIGHT(10)+normalSize.height+10, SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
                }
            } else {
                line3.frame = CGRectMake(x, self.photos.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
            }
        } else {
            line3.frame = CGRectMake(x, self.adressLabel.bottom + kHEIGHT(10), SCREEN_WIDTH - x - kHEIGHT(10), 0.5);
        }
        
    
    line3.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line3];
    
    CGSize timeSize = [dic.add_time sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.timeLabel.frame = (CGRect){{x,line3.bottom + kHEIGHT(32)/2 - timeSize.height/2},timeSize};
    self.dustbinBtn.frame = CGRectMake(self.timeLabel.right + 10, line3.bottom + kHEIGHT(32)/2 - 11, 10 + 10, 12 + 10);
    
#pragma mark 设置两个按钮的位置
    GroupAlbumCommentAndPraise * comPraView = [[GroupAlbumCommentAndPraise alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-18-6, line3.bottom,2*kHEIGHT(57), kHEIGHT(32))];
    comPraView.indexpath = self.indexPath;
    [self.contentView addSubview:comPraView];
    comPraView.clickPraiseBtn = ^(NSIndexPath*indexpath){
        if (self.praiseActionBlock) {
            self.praiseActionBlock(indexpath);
        }
    };
    comPraView.clickCommentBtn = ^(NSIndexPath*indexpath){
        if (self.commentActionBlock) {
            self.commentActionBlock(indexpath);
        }
        
    };
    
    comPraView.isGood = dic.myPraise;
    self.twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twoBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zhankai"] forState:UIControlStateNormal];
    [self.twoBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zhankai_pre"] forState:UIControlStateHighlighted];
    [self.twoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.twoBtn setImageEdgeInsets:UIEdgeInsetsMake((kHEIGHT(32)-14)/2, 0, (kHEIGHT(32)-14)/2,kHEIGHT(10))];
    [self.twoBtn addTarget:self action:@selector(clickTwoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.twoBtn];
    self.twoBtn.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-18-6, line3.bottom, 6+18+kHEIGHT(10), kHEIGHT(32));
    self.twoBtn.backgroundColor = [UIColor whiteColor];
    
#pragma mark 赞按钮
    NSString *praise = [NSString stringWithFormat:@"  %@",dic.praiseCount];
    NSString *praiseCount = [NSString stringWithFormat:@"%@",dic.praiseCount];
    if ([praiseCount isEqualToString:@"0"]) {
        praise = @"  赞";
    }
    
    CGSize prasieSize = [praise sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 22 - prasieSize.width - 16, line3.bottom + kHEIGHT(32)/2 - 10.5, prasieSize.width + 16, 11 + 10)];
    [praiseBtn setImage:[UIImage imageNamed:@"small_good"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"praise_blue"] forState:UIControlStateSelected];
    [praiseBtn setTitle:praise forState:UIControlStateNormal];
    [praiseBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    praiseBtn.titleLabel.font = kFONT(12);
    [praiseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.praiseBtn = praiseBtn;
    self.praiseBtn.tag = 10000;
//    [self.contentView addSubview:praiseBtn];
    
    NSString *is_good = [NSString stringWithFormat:@"%@",dic.myPraise];
    if ([is_good isEqualToString:@"0"]) {
        self.praiseBtn.selected = NO;
    } else {
        self.praiseBtn.selected = YES;
    }
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(praiseBtn.left - 13, line3.bottom + 5, 0.5, 15)];
    //    line5.image = [UIImage imageNamed:@"small_bounds"];
    line5.backgroundColor = RGBColor(226, 226, 226);
    //    [self.contentView addSubview:line5];
    
    NSString *comment = [NSString stringWithFormat:@" %@",dic.commentCount];
    NSString *commentCount = [NSString stringWithFormat:@"%@",dic.commentCount];
    if ([commentCount isEqualToString:@"0"]) {
        comment = @" 评论";
    }

//    self.dustbinBtn.hidden = self.isOwner ? NO : ([dic.created_user_id isEqualToString:kShareModel.userId] ? NO :YES);
    
    
    
    if (self.isDetailInfo)
    {
     self.dustbinBtn.hidden = ![dic.is_del intValue];
    }
    else
    {
      self.dustbinBtn.hidden = self.isOwner ? NO : ([dic.created_user_id isEqualToString:kShareModel.userId] ? NO :YES);
    }
    
#pragma mark   评论按钮
    CGSize commentSize = [comment sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.praiseBtn.left - 22 - commentSize.width - 16, line3.bottom + kHEIGHT(32)/2 - 10.5, commentSize.width + 16, 11 + 10)];
    [commentBtn setImage:[UIImage imageNamed:@"small_message"] forState:UIControlStateNormal];
    [commentBtn setTitle:comment forState:UIControlStateNormal];
    [commentBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    commentBtn.titleLabel.font = kFONT(12);
    [commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn = commentBtn;
    self.commentBtn.tag = 10001;
//    [self.contentView addSubview:commentBtn];
    NSArray *praiseArr = dic.PraiseList;
    NSArray *discussArr = dic.CommentList;
    
    CGFloat bottomHeight; //底部的高度
    if (!self.isDetail) {
        if (praiseArr.count == 0  && discussArr.count == 0) {
            return;
        } else {
            UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(x, line3.bottom + kHEIGHT(32), SCREEN_WIDTH - x - kHEIGHT(10), 0.5)];
            line4.backgroundColor = RGB(226, 226, 226);
            [self.contentView addSubview:line4];
            
            bottomHeight = [GroupBottomView calculateHeightWithInfo:dic];
            self.bottomView.frame = CGRectMake(0, line4.bottom + kHEIGHT(10), SCREEN_WIDTH, bottomHeight);
            self.bottomView.indexPath = self.indexPath;
            self.bottomView.dynamicInfo = dic;
#pragma mark - 重新计算backView的高度
            
            if ([dic.address length] == 0) { //没有地址
                
                    if ([dic.PhotoList count] == 0) {
                        backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                    } else {
                        if (dic.remark.length != 0) {
                            backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                        } else {
                            backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);

                        }
                    }
                    
                
            } else { //有地址
                
                    if ([dic.PhotoList count] == 0) {
                        backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                    } else {
                        if (dic.remark.length != 0) {
                            backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                        } else {
                            backViewHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10);
                        }
                    }
                }
                
#pragma mark - 重新设置backView的高度
            self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight);
        }
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
    }
}

- (void)check
{
    //    NSLog(@"查看主页");
    if (self.checkActionBlock) {
        self.checkActionBlock(self.indexPath);
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"GroupPhotoAlumCellID";
    GroupPhotoAlumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[GroupPhotoAlumCell alloc] init];
    }
    return cell;
}

+ (CGFloat)calculateHeightWithInfo:(GroupPhotoAlumListModel *)dic isDetail:(BOOL)isDetail
{
    if (!isDetail) { //不是详情的cell高度
        
        NSInteger count = dic.PhotoList.count;
//        NSInteger videoCount = [dic[@"videoCount"] integerValue];
        
        NSString *description = dic.remark;
//        NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
////        NSString *lastDestription = [NSString stringWithFormat:@"%@",description3];
//        NSString *lastDestription = [WPMySecurities textFromEmojiString:description3];
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *lastDestription = [WPMySecurities textFromEmojiString:description1];
        
        
        
        CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        CGFloat descriptionLabelHeight;//内容的显示高度
        descriptionLabelHeight = [lastDestription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
        
        CGFloat allHeight = descriptionLabelHeight;
        if (descriptionLabelHeight > normalSize.height *8) {//6
            descriptionLabelHeight = normalSize.height *8;//6
            
//            for (NSIndexPath*index in self->choiseArray) {
//                if (index == self.indexPath) {
//                    descriptionLabelHeight = allHeight;
//                }
//            }
            
        } else {
            descriptionLabelHeight = descriptionLabelHeight;
        }
        
        //加上全文的高度
        if (descriptionLabelHeight > normalSize.height*8) {
            descriptionLabelHeight += normalSize.height+10;
        }
        
        if (dic.remark.length == 0) {
            descriptionLabelHeight = 0;
        }
        CGFloat photosHeight;//定义照片的高度
        
        CGFloat photoWidth;
        CGFloat videoWidth;
        photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
        videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
        if (count == 0) {
            photosHeight = 0;
        } else if (count >= 1 && count <= 3) {
            photosHeight = photoWidth;
        } else if (count >= 4 && count <= 6) {
            photosHeight = photoWidth*2 + 3;
        } else {
            photosHeight = photoWidth*3 + 6;
        }
        
        NSArray *praiseArr = dic.PraiseList;
        NSArray *discussArr = dic.CommentList;
        CGFloat bottomHeight = [GroupBottomView calculateHeightWithInfo:dic];
//        NSLog(@"******%f",bottomHeight);
        CGFloat cellHeight;
        
        if (praiseArr.count == 0  && discussArr.count == 0) { //没有bottom
            
            if ([dic.address length] == 0) { //有地址
                
                    if ([dic.PhotoList count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                    } else {
                        if (dic.remark.length != 0) {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                        } else {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                        }
                    }
                    
                
            } else { //没地址
                
                    if ([dic.PhotoList count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    } else {
                        if (dic.remark.length != 0) {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                        } else {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                        }
                    }
                
            }
            
        } else { //有bottom
            
            if ([dic.address length] == 0) { //没有地址
                
                    if ([dic.PhotoList count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                    } else {
                        if (dic.remark.length != 0) {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10) + 8;
                        } else {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10) + 8;
                        }
                    }
                    
            } else { //有地址
                    if ([dic.PhotoList count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                    } else {
                        if (dic.remark.length != 0) {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                        } else {
                            cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                        }
                    }
                }
            
        }
        
        return cellHeight;

    } else { //详情的cell高度
        NSInteger count = dic.PhotoList.count;
        NSString *description = dic.remark;
//        NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
//        NSString *lastDestription = [NSString stringWithFormat:@"%@",description3];
//        NSString *lastDestription = [WPMySecurities textFromEmojiString:description3];
//        CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *lastDestription = [WPMySecurities textFromEmojiString:description1];
        
        
        CGFloat descriptionLabelHeight;//内容的显示高度
        if ([dic.remark length] == 0) {
            descriptionLabelHeight = 0;
        } else {
            CGSize size = [lastDestription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size;
            
            descriptionLabelHeight = size.height;
        }
        CGFloat photosHeight;//定义照片的高度
        
            CGFloat photoWidth;
            CGFloat videoWidth;
            photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
            videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
            if (count == 0) {
                photosHeight = 0;
            } else if (count >= 1 && count <= 3) {
                photosHeight = photoWidth;
            } else if (count >= 4 && count <= 6) {
                photosHeight = photoWidth*2 + 3;
            } else {
                photosHeight = photoWidth*3 + 6;
            }
        
        CGFloat cellHeight;
        
        if ([dic.address length] == 0) { //有地址
            
                if ([dic.PhotoList count] == 0) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                } else {
                    if (dic.remark.length != 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                    } else {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                    }
                }
            
        } else { //没地址
            
                if ([dic.PhotoList count] == 0) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                } else {
                    if (dic.remark.length != 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    } else {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    }
                }
            
        }
        
        return cellHeight;

    }
    
}
 
#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

#pragma mark - 获取6行的字数
- (NSString *)getCountWithString:(NSString *)string
{
    //    NSLog(@"%@",string);
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
        //        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, w);
        //        NSLog(@"%ld",count);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= normalSize.height;
        CFRelease(line);
        tempK++;
        if (tempK == 8) {//6
            //            NSLog(@"%ld",start);
            NSString *count = [NSString stringWithFormat:@"%ld",start];
            return count;
            //            break;
        }
    }
    
    return 0;
    
}

- (void)dustbinClick
{
    if (self.deleteActionBlock) {
        self.deleteActionBlock(self.indexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
