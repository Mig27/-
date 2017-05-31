//
//  ShareDynamic.m
//  WP
//
//  Created by 沈亮亮 on 16/1/27.
//  Copyright © 2016年 WP. All rights reserved.
//  分享的动态

#import "ShareDynamic.h"

#import "imageConsider.h"

#define PHOTOWIDTH (SCREEN_WIDTH == 320) ? 74.5 : ((SCREEN_WIDTH == 375)? 79.5 : 86.5)
#define VIDEOWIDTH (SCREEN_WIDTH == 320) ? 140.5 : ((SCREEN_WIDTH == 375) ? 164.5 : 172.5)

@interface ShareDynamic ()

@property (nonatomic,assign) BOOL isNeedMore;

@end

@implementation ShareDynamic

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.dynamicInfo) {
        return;
    }
    self.backgroundColor = RGB(235, 235, 235);
    NSInteger count = [self.dynamicInfo[@"imgCount"] integerValue];
    NSInteger videoCount = [self.dynamicInfo[@"videoCount"] integerValue];
    NSString *nick_name = self.dynamicInfo[@"nick_name"];
    NSString *POSITION = self.dynamicInfo[@"POSITION"];
    NSString *company = self.dynamicInfo[@"company"];
    NSString *description = self.dynamicInfo[@"speak_comment_content"];
    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    NSString *speak_comment_state = self.dynamicInfo[@"speak_comment_state"];
    
    NSString *lastDestription = [NSString stringWithFormat:@"%@  %@ | %@  %@：%@",nick_name,POSITION,company,speak_comment_state,description3];
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:lastDestription];
    
    [str addAttribute:NSForegroundColorAttributeName value:RGB(0, 172, 255) range:NSMakeRange(0, nick_name.length)];
    
    [str addAttribute:NSForegroundColorAttributeName value:RGB(127, 127, 127) range:NSMakeRange(nick_name.length + 2 - 1, POSITION.length + 1 + 1 + 1 + company.length + 1)];

    [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(nick_name.length + 2 - 1, POSITION.length + 1 + 1 + 1 + company.length + 1)];
    
    [str addAttribute:NSForegroundColorAttributeName value:RGB(0, 172, 255) range:NSMakeRange(nick_name.length + 2 + POSITION.length + 1 + 1 + 1 + company.length + 2 - 1, speak_comment_state.length + 1)];
    
    if (descriptionLabelHeight >= normalSize.height *6) {
        descriptionLabelHeight = normalSize.height *6 ;
        self.isNeedMore = YES;
    } else {
        self.isNeedMore = NO;
        descriptionLabelHeight = descriptionLabelHeight;
    }
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kHEIGHT(10), SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10 -20, descriptionLabelHeight)];
//    descriptionLabel.backgroundColor = [UIColor redColor];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = kFONT(14);
    descriptionLabel.attributedText = str;
    [self addSubview:descriptionLabel];
    
    if (self.isNeedMore) {
        UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(descriptionLabel.right - 120, descriptionLabel.bottom + 10, 120, normalSize.height)];
        more.text = @"全文";
        more.textAlignment = NSTextAlignmentRight;
        more.textColor = RGBColor(0, 172, 255);
        more.font = kFONT(14);
        [self addSubview:more];
    }
    
    CGFloat photosHeight;//定义照片的高度
//    CGFloat photoWidth;
//    CGFloat videoWidth;
//    
//    photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
//    videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);

    if (videoCount == 1) {
        NSLog(@"cell 有视频");
        photosHeight = VIDEOWIDTH;
    } else {
        if (count == 0) {
            photosHeight = 0;
        } else if (count >= 1 && count <= 3) {
            photosHeight = PHOTOWIDTH;
        } else if (count >= 4 && count <= 6) {
            photosHeight = PHOTOWIDTH*2 + 3;
        } else {
            photosHeight = PHOTOWIDTH*3 + 6;
        }
    }
    
    imageConsider *photos = [[imageConsider alloc] init];
    photos.condiderType = ConsiderLayoutTypeQuestion;
    if (self.isNeedMore) {
        photos.frame = CGRectMake(0, descriptionLabel.bottom + 10 + normalSize.height + 10, SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
    } else {
        
        photos.frame = CGRectMake(0, descriptionLabel.bottom + 10, SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, photosHeight);
    }
    photos.dicInfo = self.dynamicInfo;
    [self addSubview:photos];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tap];

}

- (void)onTap
{
    NSLog(@"点击跳转");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareJumpToDynamic" object:nil userInfo:@{@"sid" : self.dynamicInfo[@"sid"],@"nick_name" : self.dynamicInfo[@"nick_name"]}];

}

+ (CGFloat)calculateHeightWithInfo:(NSDictionary *)info
{
    CGFloat viewHeight;
    NSInteger count = [info[@"imgCount"] integerValue];
    NSInteger videoCount = [info[@"videoCount"] integerValue];
    NSString *nick_name = info[@"nick_name"];
    NSString *POSITION = info[@"POSITION"];
    NSString *company = info[@"company"];
    NSString *description = info[@"speak_comment_content"];
    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    NSString *speak_comment_state = info[@"speak_comment_state"];
    
    NSString *lastDestription = [NSString stringWithFormat:@"%@  %@ | %@  %@：%@",nick_name,POSITION,company,speak_comment_state,description3];
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat descriptionLabelHeight = [lastDestription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10 -20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
    BOOL isMore;
    if (descriptionLabelHeight >= normalSize.height *6) {
        descriptionLabelHeight = normalSize.height *6 ;
        isMore = YES;
    } else {
        isMore = NO;
        descriptionLabelHeight = descriptionLabelHeight;
    }
    
    CGFloat photosHeight;//定义照片的高度
    CGFloat photoWidth;
    CGFloat videoWidth;
    
    photoWidth = (SCREEN_WIDTH == 320) ? 74.5 : ((SCREEN_WIDTH == 375) ? 79.5 : 86.5);
    videoWidth = (SCREEN_WIDTH == 320) ? 140.5 : ((SCREEN_WIDTH == 375) ? 164.5 : 172.5);
    
    if (videoCount == 1) {
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
    
//    NSLog(@"***%f*****",photosHeight);
    
    if (isMore) {
        viewHeight = descriptionLabelHeight + 10 + normalSize.height + 10 + photosHeight + 20;
    } else {
        viewHeight = descriptionLabelHeight + 10 + photosHeight + 20;
    }
    
    return viewHeight;
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10 -20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    //    NSLog(@"^^^^^^^^%@",NSStringFromCGSize(size));
    return size;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
