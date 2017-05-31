//
//  ShareResume.m
//  WP
//
//  Created by 沈亮亮 on 16/1/27.
//  Copyright © 2016年 WP. All rights reserved.
//  分享的简历或者招聘

#import "ShareResume.h"
#import "UIImageView+WebCache.h"

#import "ShareDetailController.h"
#import "WPMySecurities.h"

@interface ShareResume ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation ShareResume


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
//        self.backView = [[UIView alloc] initWithFrame:frame];
//        self.backView.backgroundColor = [UIColor redColor];
//       self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43))];
//        self.backView.backgroundColor = [UIColor greenColor];
//        [self addSubview:self.backView];
        self.backgroundColor = RGB(235, 235, 235);
        [self attachTapHandler];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)attachTapHandler{
    //    self.userInteractionEnabled =YES;  //用户交互的总开关
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    recognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:recognizer];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDETHREEVIEW" object:nil];
    
    self.backgroundColor = RGB(200, 200, 200);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //        CopyCell *cell = (CopyCell *)recognizer.view;
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        //        [menuController setMenuVisible:NO];
        //设置菜单
//        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuItem3:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2, nil]];//,menuItem3
        //设置菜单栏位置
        [menuController setTargetRect:self.frame inView:self.superview];
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

#pragma mark - 复制
- (void)menuItem:(id)sender
{
    NSString *description = self.dic[@"speak_comment_content"];
//    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    NSString *description1 = [WPMySecurities textFromBase64String:description];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = description3;
}

#pragma mark - 收藏
- (void)menuItem2:(id)sender
{
    NSLog(@"**%@\n user_id:%@",self.resumeInfo,self.user_id);
    NSLog(@"当前收藏类型为 %ld", (long)self.type);
    if (self.type == ShareResumeTypeDynamic) {
        
        NSString * nickName = [NSString stringWithFormat:@"%@",self.resumeInfo[@"nick_name"]];
        NSString * speak_comment_content = [NSString stringWithFormat:@"%@",self.resumeInfo[@"speak_comment_content"]];
        NSString *description1 = [WPMySecurities textFromBase64String:speak_comment_content];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        NSString * speak_comment_state = [NSString stringWithFormat:@"%@",self.resumeInfo[@"speak_comment_state"]];
        NSArray * contentArray = @[speak_comment_state,description3];//nickName,
        NSString * contentStr = [contentArray componentsJoinedByString:@":"];
        
        
        NSArray *images = self.resumeInfo[@"small_photos"];
        NSMutableArray *image_urls = [NSMutableArray array];
        for (NSDictionary *dic in images) {
            NSString *small_address = dic[@"small_address"];
            [image_urls addObject:small_address];
        }
        NSDictionary *userInfo = @{@"collect_class" : @"4",
                                   @"user_id" : self.user_id,
                                   @"content" : contentStr,//self.resumeInfo[@"speak_comment_content"]
                                   @"img_url" : self.resumeInfo[@"avatar"],//a//[image_urls componentsJoinedByString:@","]
                                   @"vd_url" : @"",
                                   @"jobid" : self.resumeInfo[@"sid"],//self.sid
                                   @"url" : self.resumeInfo[@"share_url"],
                                   @"share":@"1"
                                   };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collect" object:nil userInfo:userInfo];
    } else {
        NSMutableArray * titleMuarr = [[NSMutableArray alloc]init];
        NSArray * jobPhoto = self.resumeInfo[@"jobPosition"];
        for (NSDictionary * dic  in jobPhoto)
        {
            NSString * address = [NSString stringWithFormat:@"%@",dic[@"position"]];
            [titleMuarr addObject:address];
        }
        NSString * titleStr = [titleMuarr componentsJoinedByString:@","];
        NSString  * nameStr = [NSString string];
        nameStr = (self.type ==ShareResumeTypeJOb)?[NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.resumeInfo[@"name"],self.resumeInfo[@"sex"],self.resumeInfo[@"birthday"],self.resumeInfo[@"education"],self.resumeInfo[@"WorkTime"]]:[NSString stringWithFormat:@"%@",self.resumeInfo[@"name"]];
        
        NSString * shareStr = (self.type ==ShareResumeTypeJOb)?@"2":@"3";//2求职,3招聘
        
        NSArray *images = self.resumeInfo[@"jobPhoto"];
        NSMutableArray *image_urls = [NSMutableArray array];
        NSMutableArray * resume_user_ids = [NSMutableArray array];
        for (NSDictionary *dic in images) {
            NSString *small_address = dic[@"small_address"];
            [image_urls addObject:small_address];
            if (dic[@"resume_user_id"] != nil) {
                [resume_user_ids addObject:dic[@"resume_user_id"]];
            }else if (dic[@"ep_id"] != nil){
                [resume_user_ids addObject:dic[@"ep_id"]];
            }
        }
        
        NSString * contentString = (self.type == ShareResumeTypeJOb)? self.resumeInfo[@"share_title"]:[NSString stringWithFormat:@"招聘 : %@", self.resumeInfo[@"share_title"]];
        
        NSString * resume_user_id_string = [resume_user_ids componentsJoinedByString:@","];
        NSString * typeString = (self.type ==ShareResumeTypeJOb)?@"6":@"5";
        
        if (![contentString hasPrefix:@"招聘"] && ![contentString hasPrefix:@"求职"]) {
            typeString = @"7";
            resume_user_id_string = self.user_id;
        }
        
        NSString * speak_comment_state = self.dic[@"speak_comment_state"];
        NSDictionary *userInfo = @{@"collect_class" : typeString,
                                   @"user_id" : resume_user_id_string,
                                   @"content" : contentString,
                                   @"company" : nameStr,
                                   @"img_url" : [image_urls componentsJoinedByString:@","],
                                   @"vd_url" : @"",
                                   @"jobid" : self.dic[@"jobids"],//@""
                                   @"share" : shareStr,
                                   @"url" : self.resumeInfo[@"share_url"],
                                   @"title":titleStr,
                                   @"isNiMing":speak_comment_state,
                                            @"dic":self.dic};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collect" object:nil userInfo:userInfo];
    }
}

#pragma mark - 举报
- (void)menuItem3:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"report" object:nil userInfo:@{@"sid" : self.sid}];
}

-(void)WillHideMenu:(id)sender

{
    self.backgroundColor = RGB(235, 235, 235);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.resumeInfo) {
        return;
    }
//    NSLog(@"%@---%d \n %@",self.resumeInfo,self.type,self.dic);
    if (self.canTap) {
        self.userInteractionEnabled = YES;
    } else {
        self.userInteractionEnabled = NO;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tap];

    if (self.type == ShareResumeTypeJOb || self.type == ShareResumeTypeInvite) {
        
        for (UIView * view in self.subviews) {
            [view removeFromSuperview];
        }
        NSInteger num = [self.resumeInfo[@"jobPhoto"] count];
        CGFloat photoWidth;
        CGFloat line = 2;//0.5->2
        if (num == 0) {
            photoWidth = kHEIGHT(43);
        } else {
            photoWidth = (kHEIGHT(43) - 6)/2;//1.5->6
        }
        
        UIView * imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43))];
        imageBackView.backgroundColor = RGB(221, 221, 221);
        [self addSubview:imageBackView];
        
        CGSize titleSize1 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        CGSize titleSize2 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        CGFloat y = (kHEIGHT(43) - titleSize1.height - titleSize2.height -8)/2;
        if (num == 0) {
            NSString * string = (self.type == ShareResumeTypeJOb)?@"抱歉，此求职已被删除":@"抱歉，此招聘已被删除";
            UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10, kHEIGHT(43))];
            deleteLabel.font = kFONT(14);
            deleteLabel.textColor = RGB(127, 127, 127);
            deleteLabel.text =string;
            self.userInteractionEnabled = NO;
            [imageBackView removeFromSuperview];
//            deleteLabel.backgroundColor = [UIColor redColor];
            [self addSubview:deleteLabel];
       }else if (num == 1) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
            
            NSString * imageString =[self getImageStr:self.resumeInfo[@"jobPhoto"][0][@"small_address"]];
            NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,imageString];//self.resumeInfo[@"jobPhoto"][0][@"small_address"]
            [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            [self addSubview:imageV];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(imageV.right + 10, y, self.width - kHEIGHT(43) - 10, titleSize1.height);
            titleLabel.text = self.resumeInfo[@"share_title"];
            titleLabel.font = kFONT(14);
            titleLabel.textColor = [UIColor blackColor];
            [self addSubview:titleLabel];
            
            UILabel *subTitleLabel = [[UILabel alloc] init];
            subTitleLabel.frame = CGRectMake(imageV.right + 10, titleLabel.bottom + 8, titleLabel.width, titleSize2.height);
            if (self.type == ShareResumeTypeJOb) {
                subTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.resumeInfo[@"name"],self.resumeInfo[@"sex"],self.resumeInfo[@"birthday"],self.resumeInfo[@"education"],self.resumeInfo[@"WorkTime"]];
            } else {
                subTitleLabel.text = [NSString stringWithFormat:@"%@",self.resumeInfo[@"name"]];
            }
            subTitleLabel.font = kFONT(12);
            subTitleLabel.textColor = RGB(127, 127, 127);
            [self addSubview:subTitleLabel];
        } else if (num == 2) {
            UIImageView *imageV1 = [[UIImageView alloc] init];
            imageV1.frame = CGRectMake(line, line, photoWidth, photoWidth);
            NSString *url1 = [IPADDRESS stringByAppendingString:[self getImageStr:self.resumeInfo[@"jobPhoto"][0][@"small_address"]]];
            [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV1.layer.cornerRadius = 2.5;
            imageV1.clipsToBounds = YES;
            [self addSubview:imageV1];
            
            UIImageView *imageV2 = [[UIImageView alloc] init];
            imageV2.frame = CGRectMake(imageV1.right + line, imageV1.bottom + line, photoWidth, photoWidth);
            NSString *url2 = [IPADDRESS stringByAppendingString:[self getImageStr:self.resumeInfo[@"jobPhoto"][1][@"small_address"]]];
            [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV2.layer.cornerRadius = 2.5;
            imageV2.clipsToBounds = YES;
            [self addSubview:imageV2];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV2.right + 11, 0, self.width - 2*photoWidth - 13, kHEIGHT(43))];
            titleLabel.text = self.resumeInfo[@"share_title"];
            titleLabel.font = kFONT(14);
            titleLabel.textColor = [UIColor blackColor];
            [self addSubview:titleLabel];
        } else if (num == 3) {
            UIImageView *imageV1 = [[UIImageView alloc] init];
            imageV1.frame = CGRectMake(line + photoWidth/2, line, photoWidth, photoWidth);
            
//            NSString * imageStr1 = [self getImageStr:self.resumeInfo[@"jobPhoto"][0][@"small_address"]];
//            NSString * imageStr2 = [self getImageStr:self.resumeInfo[@"jobPhoto"][1][@"small_address"]];
//            NSString * imageStr3 = [self getImageStr:self.resumeInfo[@"jobPhoto"][2][@"small_address"]];
            
            NSString *url1 = [IPADDRESS stringByAppendingString:[self getImageStr:self.resumeInfo[@"jobPhoto"][0][@"small_address"]]];//self.resumeInfo[@"jobPhoto"][0][@"small_address"]
            [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV1.layer.cornerRadius = 2.5;
            imageV1.clipsToBounds = YES;
            [self addSubview:imageV1];
            
            UIImageView *imageV2 = [[UIImageView alloc] init];
            imageV2.frame = CGRectMake(line, imageV1.bottom + line, photoWidth, photoWidth);
            NSString *url2 = [IPADDRESS stringByAppendingString:[self getImageStr:self.resumeInfo[@"jobPhoto"][1][@"small_address"]]];//self.resumeInfo[@"jobPhoto"][1][@"small_address"]
            [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV2.layer.cornerRadius = 2.5;
            imageV2.clipsToBounds = YES;
            [self addSubview:imageV2];
            
            UIImageView *imageV3 = [[UIImageView alloc] init];
            imageV3.frame = CGRectMake(imageV2.right + line, imageV1.bottom + line, photoWidth, photoWidth);
            NSString *url3 = [IPADDRESS stringByAppendingString:[self getImageStr:self.resumeInfo[@"jobPhoto"][2][@"small_address"]]];//self.resumeInfo[@"jobPhoto"][2][@"small_address"]
            [imageV3 sd_setImageWithURL:URLWITHSTR(url3) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV3.layer.cornerRadius = 2.5;
            imageV3.clipsToBounds = YES;
            [self addSubview:imageV3];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV3.right + 11, 0, self.width - 2*photoWidth - 13, kHEIGHT(43))];
            titleLabel.text = self.resumeInfo[@"share_title"];
            titleLabel.font = kFONT(14);
            titleLabel.textColor = [UIColor blackColor];
            [self addSubview:titleLabel];
            
        } else  {
            for (int i = 0; i<4; i++) {
                UIImageView *imageV = [[UIImageView alloc] init];
                imageV.frame = CGRectMake(line + (line + photoWidth)*(i%2), line + (line + photoWidth)*(i/2), photoWidth, photoWidth);
                
                NSString *url = [IPADDRESS stringByAppendingString:[self getImageStr:self.resumeInfo[@"jobPhoto"][i][@"small_address"]]];
                [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
                imageV.layer.cornerRadius = 2.5;
                imageV.clipsToBounds = YES;
                [self addSubview:imageV];
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(43) + 11, 0, self.width - kHEIGHT(43) - 11, kHEIGHT(43))];
            titleLabel.text = self.resumeInfo[@"share_title"];
            titleLabel.font = kFONT(14);
            titleLabel.textColor = [UIColor blackColor];
            [self addSubview:titleLabel];
            
        }
        
    }
    else {
        
        NSString *is_del = [NSString stringWithFormat:@"%@",self.resumeInfo[@"is_del"]];
        if ([is_del isEqualToString:@"0"]) { //该说说已删除
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10, kHEIGHT(43))];
            titleLabel.font = kFONT(14);
            titleLabel.textColor = RGB(127, 127, 127);
            titleLabel.text = @"抱歉，此说说已被作者删除";
            [self addSubview:titleLabel];
            self.userInteractionEnabled = NO;

        } else {
            //        NSInteger count = [self.resumeInfo[@"imgCount"] integerValue];
            //        NSInteger videoCount = [self.resumeInfo[@"videoCount"] integerValue];
            NSString *nick_name = self.resumeInfo[@"nick_name"];
            //        NSString *POSITION = self.resumeInfo[@"POSITION"];
            //        NSString *company = self.resumeInfo[@"company"];
            NSString *description = self.resumeInfo[@"speak_comment_content"];
            
//            NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//            NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//            NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@" "];
            NSString *description1 = [WPMySecurities textFromBase64String:description];
            NSString *description3 = [NSString stringWithFormat:@"%@",[WPMySecurities textFromEmojiString:description1]];
            if (!description3) {
                description3 = @"";
            }
            
            
            if (!description3.length) {
                description3 = @"";
            }
            
            
            
            NSString *speak_comment_state = self.resumeInfo[@"speak_comment_state"];
            NSString *lastDestription =nil;//[NSString stringWithFormat:@"%@ : %@  %@",nick_name,speak_comment_state,description3.length?description3 : ([self.resumeInfo[@"videoCount"]  isEqualToString:@"1"] ? @" [视频]" : @" [图片]")];
            
            if (description3.length)
            {
                lastDestription = [NSString stringWithFormat:@"%@：%@ %@",nick_name,speak_comment_state,description3];
            
            }
            else
            {
            if ([[NSString stringWithFormat:@"%@",self.resumeInfo[@"videoCount"]] isEqualToString:@"1"]) {
                    lastDestription = [NSString stringWithFormat:@"%@：%@ %@",nick_name,speak_comment_state,@"[视频]"];
                }
                else
                {
                  lastDestription = [NSString stringWithFormat:@"%@：%@ %@",nick_name,speak_comment_state,@"[图片]"];
                }
            }
            
            
            
            
            //        CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
            //        CGFloat descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:lastDestription];
            
            [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, nick_name.length)];
            
            //        [str addAttribute:NSForegroundColorAttributeName value:RGB(127, 127, 127) range:NSMakeRange(nick_name.length + 2 - 1, POSITION.length + 1 + 1 + 1 + company.length + 1)];
            //
            //        [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(nick_name.length + 2 - 1, POSITION.length + 1 + 1 + 1 + company.length + 1)];
            
            [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(nick_name.length + 1, speak_comment_state.length + 1)];
            
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
            [self addSubview:imageV];
            
            NSString *url = [[NSString alloc] init];
            //        if (videoCount == 0 && count == 0) {
            //        NSLog(@"%@",self.resumeInfo);
            url = [IPADDRESS stringByAppendingString:self.resumeInfo[@"avatar"]];
            //        } else {
            //            url = [IPADDRESS stringByAppendingString:self.resumeInfo[@"small_photos"][0][@"small_address"]];
            //        }
            [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            //        if (videoCount == 1) {
            //            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //            button.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
            //            [button setImage:[UIImage imageNamed:@"播放小"] forState:UIControlStateNormal];
            //            [imageV addSubview:button];
            //        }
            //
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(43) + 10, 0, self.width - kHEIGHT(43) - 10, kHEIGHT(43))];
            titleLabel.font = kFONT(14);
            titleLabel.attributedText = str;
            titleLabel.numberOfLines = 0;
            //        titleLabel.textColor = [UIColor blackColor];
            [self addSubview:titleLabel];
        }

    }
}
-(NSString*)getImageStr:(NSString*)string
{
    
    if (!string) {
        return @"";
    }
    
    NSString * imageStr = string;
    imageStr = [imageStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
    imageStr = [imageStr stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
    NSArray * imageArr = [imageStr componentsSeparatedByString:@"/"];
    NSString * lastStr = imageArr[imageArr.count-1];
   // lastStr = [@"thumb_" stringByAppendingString:lastStr];
    lastStr = [NSString stringWithFormat:@"thumb_%@",lastStr];
    NSMutableArray * muImageArr = [NSMutableArray array];
    [muImageArr addObjectsFromArray:imageArr];
    [muImageArr replaceObjectAtIndex:imageArr.count-1 withObject:lastStr];
    imageStr = [muImageArr componentsJoinedByString:@"/"];
    return imageStr;
}
#pragma mark - 获取string的size
//- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
//{
//    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20 - kHEIGHT(43) - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
//    //    NSLog(@"^^^^^^^^%@",NSStringFromCGSize(size));
//    return size;
//}

#pragma mark 点击分享
- (void)onTap
{
    self.backgroundColor = RGB(200, 200, 200);
    NSLog(@"点击跳转");
    if (self.type == ShareResumeTypeJOb || self.type == ShareResumeTypeInvite) {
        NSString *jobNo = [NSString stringWithFormat:@"%@",self.dic[@"jobNo"]];
        NSString *jobids = [NSString stringWithFormat:@"%@",self.dic[@"jobids"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shareJump" object:nil userInfo:@{@"url" : self.resumeInfo[@"share_url"] , @"jobNo" : jobNo, @"jobids" : jobids, @"index" : self.index}];
    
    } else {
//        NSLog(@"%@--%@---%@",self.resumeInfo[@"sid"],self.resumeInfo[@"nick_name"],self.index);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeJumpToDynamic" object:nil userInfo:@{@"sid" : self.resumeInfo[@"sid"],@"nick_name" : self.resumeInfo[@"nick_name"],@"index" : self.index}];
    }
    
    [self performSelector:@selector(delayTime) withObject:nil afterDelay:0.5];
    
}
-(void)delayTime
{
    self.backgroundColor = RGB(235, 235, 235);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
