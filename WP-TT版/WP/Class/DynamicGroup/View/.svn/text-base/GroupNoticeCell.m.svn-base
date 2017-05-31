//
//  GroupNoticeCell.m
//  WP
//
//  Created by 沈亮亮 on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupNoticeCell.h"
#import <UIImageView+WebCache.h>
#import <CoreText/CoreText.h>
#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "NewDetailViewController.h"

@implementation GroupNoticeCell
{
    CTTypesetterRef typesetter;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = BackGroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 200)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 8, SCREEN_WIDTH - kHEIGHT(10), kHEIGHT(32))];
    self.titleLabel.font = kFONT(15);
    [self.contentView addSubview:self.titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.contentView addSubview:line];
//    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), 16 + 8, kHEIGHT(102), kHEIGHT(102))];
    self.photoImage = [[UIImageView alloc] init];
    self.photoImage.userInteractionEnabled = YES;
    self.photoImage.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:self.photoImage];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.photoImage addGestureRecognizer:tap1];

    
    self.contentText = [[UILabel alloc] init];
//    self.contentText = [[UILabel alloc] initWithFrame:CGRectMake(self.photoImage.right + 10, self.photoImage.top, SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, kHEIGHT(102))];
    self.contentText.font = kFONT(14);
    self.contentText.numberOfLines = 0;
    [self.contentView addSubview:self.contentText];
    
    self.moreLabel = [[UILabel alloc] init];
    self.moreLabel.font = kFONT(14);
    self.moreLabel.numberOfLines = 0;
    [self.contentView addSubview:self.moreLabel];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.font = kFONT(12);
    self.infoLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.infoLabel];
    
    self.dustbinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dustbinBtn setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
    [self.dustbinBtn addTarget:self action:@selector(dustBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.dustbinBtn];
}

- (void)setModel:(GroupNoticeListModel *)model
{
    _model = model;
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGSize normalSize1 = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.titleLabel.text = model.notice_title;
    CGFloat photoAndTextHeight = 0;
    if (model.notice_photo.length != 0) { //有图片
        
        self.photoImage.frame = CGRectMake(kHEIGHT(10), self.titleLabel.bottom + 16, kHEIGHT(102), kHEIGHT(102));
        NSString *url = [IPADDRESS stringByAppendingString:model.notice_photo];
//        [self.photoImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
        
        [self.photoImage sd_setImageWithURL:URLWITHSTR(url)];
        
        
        self.photoImage.clipsToBounds = YES;
        self.photoImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat textH = [model.notice_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
        if (textH <= normalSize.height*6) { //字数不超过6行
            self.contentText.frame = CGRectMake(self.photoImage.right + 10, self.photoImage.top, SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, textH);
            self.contentText.text = model.notice_content;
            photoAndTextHeight = kHEIGHT(102);
            self.infoLabel.frame = CGRectMake(kHEIGHT(10), self.photoImage.bottom + kHEIGHT(10), 200, normalSize1.height);
        } else {
            NSString *count = [self getCountWithString:model.notice_content width:SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10 lines:6];
            if (!self.isDetail) {//不是详情
                self.contentText.frame = CGRectMake(self.photoImage.right + 10, self.photoImage.top, SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, kHEIGHT(102));
                NSString *subStr = [model.notice_content substringToIndex:count.integerValue - 3];
                NSString   *attributedText = [NSString stringWithFormat:@"%@...全文",subStr];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedText];
                [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(attributedText.length - 2, 2)];
                self.contentText.attributedText = str;
                photoAndTextHeight = kHEIGHT(102);
                self.infoLabel.frame = CGRectMake(kHEIGHT(10), self.photoImage.bottom + kHEIGHT(10), 200, normalSize1.height);
            } else { //是详情
                if (SCREEN_WIDTH == 320) {
                    self.contentText.frame = CGRectMake(self.photoImage.right + 10, self.photoImage.top, SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, kHEIGHT(102));
                } else {
                    self.contentText.frame = CGRectMake(self.photoImage.right + 10, self.photoImage.top + 2, SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, kHEIGHT(102));
                }
                NSString *subStr = [model.notice_content substringToIndex:count.integerValue];
                self.contentText.text = subStr;
                NSString *otherStr = [model.notice_content substringFromIndex:count.integerValue];
                CGFloat moreH = [otherStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
                self.moreLabel.frame = CGRectMake(kHEIGHT(10), self.photoImage.bottom, SCREEN_WIDTH - 2*kHEIGHT(10), moreH);
                self.moreLabel.text = otherStr;
                photoAndTextHeight = kHEIGHT(102) + moreH;
                self.infoLabel.frame = CGRectMake(kHEIGHT(10), self.moreLabel.bottom + kHEIGHT(10), 200, normalSize1.height);
            }
        }
        
    } else { //没有图片
        
        CGFloat textH = [model.notice_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
        if (textH <= normalSize.height*6) { //字数不超过6行
            self.contentText.frame = CGRectMake(kHEIGHT(10), self.titleLabel.bottom + 16, SCREEN_WIDTH - 2*kHEIGHT(10), textH);
            self.contentText.text = model.notice_content;
            photoAndTextHeight = textH;
        } else { //超过6行
            NSString *count = [self getCountWithString:model.notice_content width:SCREEN_WIDTH - 2*kHEIGHT(10) lines:6];
            if (!self.isDetail) {//不是详情
                self.contentText.frame = CGRectMake(kHEIGHT(10), self.titleLabel.bottom + 16, SCREEN_WIDTH- 2*kHEIGHT(10), normalSize.height*6);
                NSString *subStr = [model.notice_content substringToIndex:count.integerValue - 3];
                NSString   *attributedText = [NSString stringWithFormat:@"%@...全文",subStr];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedText];
                [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(attributedText.length - 2, 2)];
                self.contentText.attributedText = str;
                photoAndTextHeight = normalSize.height*6;
            } else { //是详情
                self.contentText.frame = CGRectMake(kHEIGHT(10), self.titleLabel.bottom + 16, SCREEN_WIDTH - 2*kHEIGHT(10), textH);
                self.contentText.text = model.notice_content;
                photoAndTextHeight = textH;
            }
        }
        self.infoLabel.frame = CGRectMake(kHEIGHT(10), self.contentText.bottom + kHEIGHT(10), 200, normalSize1.height);
    }
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@",model.nick_name,model.add_time];
    [self.infoLabel sizeToFit];
    
    self.dustbinBtn.frame = CGRectMake(self.infoLabel.right, self.infoLabel.top, 12 + 2*kHEIGHT(10), normalSize1.height);
    self.dustbinBtn.centerY = self.infoLabel.centerY;
    if (self.isOwner) {
        self.dustbinBtn.hidden = NO;
    } else {
        self.dustbinBtn.hidden = YES;
    }
    self.backView.frame = CGRectMake(0, 8, SCREEN_WIDTH, kHEIGHT(32) + 16 + photoAndTextHeight + kHEIGHT(10) + normalSize1.height + 16);
    
}

#pragma mark - 垃圾箱按钮点击事件
- (void)dustBtnClick
{
    NSLog(@"删除公告");
    if (self.deleteBlock) {
        self.deleteBlock(self.index);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"GroupNoticeCellID";
    GroupNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[GroupNoticeCell alloc] init];
    }
    return cell;
}

- (CGFloat)calculateHeightWithInfo:(GroupNoticeListModel *)model isDetail:(BOOL)isDetail
{
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGSize normalSize1 = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat photoAndTextHeight = 0;
    if (model.notice_photo.length != 0) { //有图片
        
        CGFloat textH = [model.notice_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
        if (textH <= normalSize.height*6) { //字数不超过6行
            photoAndTextHeight = kHEIGHT(102);
        } else {
            NSString *count = [self getCountWithString:model.notice_content width:SCREEN_WIDTH - kHEIGHT(102) - 2*kHEIGHT(10) - 10 lines:6];
            if (!isDetail) {//不是详情
                photoAndTextHeight = kHEIGHT(102);
            } else { //是详情
                NSString *otherStr = [model.notice_content substringFromIndex:count.integerValue];
                CGFloat moreH = [otherStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
                photoAndTextHeight = kHEIGHT(102) + moreH;
            }
        }
        
    } else { //没有图片
        
        CGFloat textH = [model.notice_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
        if (textH <= normalSize.height*6) { //字数不超过6行
            photoAndTextHeight = textH;
        } else { //超过6行
            if (!self.isDetail) {//不是详情
                photoAndTextHeight = normalSize.height*6;
            } else { //是详情
                photoAndTextHeight = textH;
            }
        }
    }
    
    return kHEIGHT(32) + 16 + photoAndTextHeight + kHEIGHT(10) + normalSize1.height + 16 + 8;
}

#pragma mark - 获取指定行数的字数
- (NSString *)getCountWithString:(NSString *)string width:(CGFloat)width lines:(int)row
{
    //    NSLog(@"%@",string);
    NSMutableAttributedString *stttribute = [[NSMutableAttributedString alloc] initWithString:string];
    [stttribute addAttribute:NSFontAttributeName value:kFONT(14) range:NSMakeRange(0, string.length)];
    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                        (stttribute));
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat w = width;
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
        if (tempK == row) {
            //            NSLog(@"%ld",start);
            NSString *count = [NSString stringWithFormat:@"%ld",start];
            return count;
            //            break;
        }
    }
    
    return 0;
    
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    UIViewController *controller = [self viewController];
    //    NSLog(@"%@",controller);
    if ([[controller class] isEqual:[NewDetailViewController class]]) {
        //        NSLog(@"yes");
        NewDetailViewController *detail = (NewDetailViewController *)controller;
        [detail keyBoardDismiss];
    }
    
    NSMutableArray *photos = [NSMutableArray array];
    NSLog(@"%@",self.model.notice_photo);
    NSString *url = [IPADDRESS stringByAppendingString:self.model.notice_photo];
        
        //        MJPhoto *photo = [[MJPhoto alloc] init];
        //        photo.sid = self.dicInfo[@"sid"];
        //        photo.url = [NSURL URLWithString:url];
        //        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        //        photo.srcImageView = imageV;
        //        [photos addObject:photo];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
//        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        //        photo.sid = self.dicInfo[@"user_id"];
        photo.toView = self.photoImage;
        [photos addObject:photo];
    
    //    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //    brower.currentPhotoIndex = tap.view.tag - 1;
    //    brower.photos = photos;
    //    [brower show];
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    photoBrowser.currentStr = url;
    photoBrowser.reloadIndex = self.index;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:[self viewController]];
    
}


#pragma mark - 获取view所在的控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
