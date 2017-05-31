//
//  collectionMuchCell.m
//  WP
//
//  Created by CC on 16/9/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "collectionMuchCell.h"
#import "WPMySecurities.h"
#import "collectionMuchLabel.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "ZacharyPlayManager.h"
#define shuoShuoVideo @"/shuoShuoVideo"
@implementation collectionMuchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), fHEIGHT(28), fHEIGHT(28))];
        self.icon.layer.cornerRadius = 5;
        self.icon.clipsToBounds = YES;
        [self.contentView addSubview:self.icon];
        
        self.backVideoImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.backVideoImageView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = kFONT(12);
        self.nameLabel.textColor = [UIColor blackColor];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.nameLabel];

        self.positionLabel = [[UILabel alloc]init];
        self.positionLabel.font = kFONT(10);
        self.positionLabel.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:self.positionLabel];
        
        self.companyLabel = [[UILabel alloc]init];
        self.companyLabel.font = kFONT(10);
        self.companyLabel.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:self.companyLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = kFONT(10);
        self.timeLabel.textColor = RGB(170, 170, 170);
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}
-(void)setDetailDic:(NSDictionary *)detailDic
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,detailDic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    NSString * nameStr = [NSString stringWithFormat:@"%@",detailDic[@"nick_name"]];
    if (nameStr.length > 6)
    {
        nameStr = [nameStr substringToIndex:6];
    }
    
    CGSize nameSize = [self sizeWithText:detailDic[@"nick_name"] font:kFONT(12) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    NSString * positionStr = [NSString stringWithFormat:@"%@",detailDic[@"position"]];
    NSString * companyStr = [NSString stringWithFormat:@"%@",detailDic[@"company"]];
    if (positionStr.length > 6) {
        positionStr = [positionStr substringToIndex:6];
    }
    if (companyStr.length > 6) {
        companyStr = [companyStr substringToIndex:6];
    }
    CGSize positionSize = [positionStr getSizeWithFont:FUCKFONT(10) Height:nameSize.height];
    CGSize companySize = [companyStr getSizeWithFont:FUCKFONT(10) Height:nameSize.height];
    
    self.nameLabel.text = detailDic[@"nick_name"];
    self.nameLabel.frame = CGRectMake(self.icon.right+10, kHEIGHT(10), nameSize.width, nameSize.height);
    
    self.positionLabel.text = detailDic[@"position"];
    self.positionLabel.frame = CGRectMake(self.nameLabel.right+6, self.nameLabel.top, positionSize.width, nameSize.height);
    
    //添加线条
//    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(self.positionLabel.right+4, self.nameLabel.top+1, 0.5, nameSize.height-2)];
     UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(self.positionLabel.right+4,self.nameLabel.top+self.nameLabel.height/2-5, 0.5, 10)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.contentView addSubview:line];
    
    self.companyLabel.text = detailDic[@"company"];
    self.companyLabel.frame = CGRectMake(line.right+4, self.nameLabel.top, companySize.width, nameSize.height);
    
    
    NSString * dateDtr = detailDic[@"create_time"];
    NSTimeInterval timer = [dateDtr integerValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timer];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString * dateSTr = [formatter stringFromDate:date];
    CGSize timeSize = [self sizeWithText:dateSTr font:kFONT(10) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.timeLabel.text = dateSTr;
    
    
//    self.timeLabel.text = detailDic[@"create_time"];
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-timeSize.width, self.nameLabel.top, timeSize.width, nameSize.height);
    
    
    NSString * display_type = [NSString stringWithFormat:@"%@",detailDic[@"display_type"]];
    
    [self removeMySubviews];
    if ([display_type isEqualToString:@"1"])//添加文字
    {
        [self textLabel:detailDic andSize:nameSize];
    }
    else if ([display_type isEqualToString:@"6"]||[display_type isEqualToString:@"8"]||[display_type isEqualToString:@"9"]||[display_type isEqualToString:@"11"]||[display_type isEqualToString:@"10"]||[display_type isEqualToString:@"15"]||[display_type isEqualToString:@"16"])//名片
    {
        [self setPersonalCard:detailDic andSize:nameSize andDieTypy:display_type];
    }
    else if ([display_type isEqualToString:@"2"])//图片
    {
        [self setImageBack:detailDic];
    }
    else if ([display_type isEqualToString:@"7"])//视频
    {
        [self setVideoDetail:detailDic];
    }
    
}

-(void)reloadStart
{
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance]startWithLocalPath:self.fileStr WithVideoBlock:^(CGImageRef imageData, NSString *filePath) {
        if ([filePath isEqualToString:weakSelf.fileStr]) {
            self.backVideoImageView.layer.contents=(__bridge id _Nullable)(imageData);
        }
    }];
    
    [[ZacharyPlayManager sharedInstance]reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:weakSelf.fileStr]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:self.fileStr];
}
-(void)removeMySubviews
{
    [self.backImageView removeFromSuperview];
    [self.personalCardView removeFromSuperview];
    [_video.playerLayer removeFromSuperlayer];
    [self.collectionLabel removeFromSuperview];
    [self.backVideoImageView removeFromSuperview];

}
#pragma mark 设置视频
-(void)setVideoDetail:(NSDictionary*)dictionary
{
     CGFloat videHeight;
    videHeight = (SCREEN_WIDTH == 320) ? 112 : ((SCREEN_WIDTH == 375) ? 131 : 145);
   
    
    
    NSString * str = dictionary[@"content"];
    NSString *description1 = [WPMySecurities textFromBase64String:str];
    //    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    NSData * data = [description1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dontentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
   
    if (dontentDic.count) {
        description1 = dontentDic[@"url"];
        if (![description1 hasPrefix:@"http"]) {
          description1 = [NSString stringWithFormat:@"%@%@",IPADDRESS,dontentDic[@"url"]];
        }
        
    }
    else
    {
        NSArray * arr = [description1 componentsSeparatedByString:@":"];
        if (![arr[0] isEqualToString:@"http"]) {
            description1 = [NSString stringWithFormat: @"%@%@",IPADDRESS,description1];
        }
    }
    [self.contentView addSubview:self.backVideoImageView];
     self.backVideoImageView.frame = CGRectMake(self.icon.right+10, self.nameLabel.bottom+6,videHeight/3*4,videHeight);
    NSArray * array = [description1 componentsSeparatedByString:@"/"];
    NSMutableArray * muarr = [NSMutableArray array];
    [muarr addObjectsFromArray:array];
    NSString * lastStr = [array lastObject];
    lastStr = [lastStr stringByReplacingOccurrencesOfString:@"mp4" withString:@"png"];
    lastStr = [@"thumb_" stringByAppendingString:lastStr];
    [muarr removeLastObject];
    [muarr insertObject:lastStr atIndex:muarr.count];
    NSString * videoImagr = [muarr componentsJoinedByString:@"/"];
    self.backVideoImageView.backgroundColor = RGB(226, 226, 226);
//    [self.backVideoImageView sd_setImageWithURL:[NSURL URLWithString:videoImagr]];

    
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(concurrentQueue, ^(){
//        _video = [WPDDChatVideo videoWithUrl:[NSURL URLWithString:description1]];
//        _video.playerLayer.frame = CGRectMake(self.icon.right+10, self.nameLabel.bottom+6,videHeight/3*4,videHeight);
//        [self.contentView.layer addSublayer:_video.playerLayer];
//    });
    
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray *specialUrlArr = [description1 componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
    if (isOrNot) {
        self.fileStr = fileName1;
        [self reloadStart];
    }
  
    
    
    self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoBtn.frame = CGRectMake(self.icon.right+10, self.nameLabel.bottom+6, videHeight, videHeight);
    [self.videoBtn addTarget:self action:@selector(clickVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.videoBtn];

//    NSLog(@"%@",dontentDic);
}
#pragma mark 设置图片
-(void)setImageBack:(NSDictionary*)dictionary
{
    NSString * str = dictionary[@"content"];
    NSString *description1 = [WPMySecurities textFromBase64String:str];
//    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    NSData * data = [description1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dontentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString * urlString = dontentDic[@"url"];
    urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
    if (urlString.length) {
        urlString = [self getThumbimage:urlString];
    }
    
    NSURL* url = [NSURL URLWithString:urlString];
    if (!url) {
        NSString * urlString = description1;
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
        urlString = [self getThumbimage:urlString];
        url = [NSURL URLWithString:urlString];
    }
    CGFloat phoWidth;
    phoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.icon.right+10, self.nameLabel.bottom+6,phoWidth,phoWidth)];
    [self.contentView addSubview:self.backImageView];
//    [self.backImageView sd_setImageWithURL:url];
    [self.backImageView sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:RGB(127, 127, 127)]];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
    self.backImageView.userInteractionEnabled = YES;
    [self.backImageView addGestureRecognizer:tap];
    
}
-(NSString*)getThumbimage:(NSString*)imageStr
{
    NSArray * arrary = [imageStr componentsSeparatedByString:@"/"];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:arrary];
    NSString * lastStr = arrary[arrary.count-1];
    lastStr = [@"thumb_" stringByAppendingString:lastStr];
    [muarray replaceObjectAtIndex:arrary.count-1 withObject:lastStr];
    lastStr = [muarray componentsJoinedByString:@"/"];
    return lastStr;
}
-(void)clickVideo
{
    if (self.clickVideoBtn) {
        self.clickVideoBtn(self.indexpath);
    }
}
-(void)clickImage:(UITapGestureRecognizer*)tap
{
    if (self.clickImage) {
        self.clickImage(self.indexpath,self.backImageView);
    }
}
#pragma mark 设置文字
-(void)textLabel:(NSDictionary*)dictionary andSize:(CGSize)nameSize
{
    NSString * str = dictionary[@"content"];
    NSString *description1 = [WPMySecurities textFromBase64String:str];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (!description3.length)
    {
        description3 = str;
    }
    NSDictionary * dic = @{@"content":description3};
    CGFloat height = [self getHeightForContentStringWithDic:dic];
    _collectionLabel = [[collectionMuchLabel alloc]initWithFrame:CGRectMake(self.icon.right+10, self.nameLabel.bottom+6, SCREEN_WIDTH-kHEIGHT(20)-10-self.icon.width, height)];
    _collectionLabel.text = description3;
    _collectionLabel.numberOfLines = 0;
    _collectionLabel.font = kFONT(14);
    _collectionLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_collectionLabel];
}
#pragma mark 设置名片
-(void)setPersonalCard:(NSDictionary*)dictionary andSize:(CGSize)nameSize andDieTypy:(NSString*)type
{
    NSString * content = dictionary[@"content"];
    NSString * textStr = [WPMySecurities textFromBase64String:content];
    NSData * data = [textStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    self.personalCardView = [[UIView alloc]initWithFrame:CGRectMake(self.icon.right+10, self.nameLabel.bottom+6, SCREEN_WIDTH-kHEIGHT(20)-10-self.icon.width, kHEIGHT(43))];
    self.personalCardView.backgroundColor = RGB(235, 235, 235);
    self.personalCardView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBack:)];
    [self.personalCardView addGestureRecognizer:tap];
    
    [self.contentView addSubview:self.personalCardView];
    
    NSString * imageStr = @"";
    if ([type isEqualToString:@"6"]) {
        imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,contentDic[@"avatar"]];
    }
    else if ([type isEqualToString:@"8"])
    {
        imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,contentDic[@"qz_avatar"]];
    }
    else if ([type isEqualToString:@"9"])
    {
        imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,contentDic[@"zp_avatar"]];
    }
    else if ([type isEqualToString:@"11"])
    {
        imageStr = contentDic[@"avatar"];
    }
    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43))];
    if ([type isEqualToString:@"10"])//多个面试和招聘
    {
        iconImage.backgroundColor = RGB(221, 221, 221);
        [self.personalCardView addSubview:iconImage];
        NSString * idStr = contentDic[@"id"];
        NSArray *jobArray = [idStr componentsSeparatedByString:@","];
        CGFloat muchphotoWidth;
        CGFloat line = 2;//0.5
        if (jobArray.count == 0) {
            muchphotoWidth = kHEIGHT(43);
        } else {
            muchphotoWidth = (kHEIGHT(43) - 6)/2;//1.5
        }
        
        if (jobArray.count == 1)
        {
            UIImageView *imageV1 = [[UIImageView alloc] init];
            imageV1.frame = CGRectMake(line, line, muchphotoWidth, muchphotoWidth);
            NSString *url1 = [IPADDRESS stringByAppendingString:contentDic[@"avatar_0"]];
            [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV1.layer.cornerRadius = 3;
            imageV1.clipsToBounds = YES;
            [self.personalCardView addSubview:imageV1];
        }
         else if (jobArray.count == 2)
        {
            UIImageView *imageV1 = [[UIImageView alloc] init];
            imageV1.frame = CGRectMake(line, line, muchphotoWidth, muchphotoWidth);
            NSString *url1 = [IPADDRESS stringByAppendingString:contentDic[@"avatar_0"]];
            [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV1.layer.cornerRadius = 3;
            imageV1.clipsToBounds = YES;
            [self.personalCardView addSubview:imageV1];
            
            UIImageView *imageV2 = [[UIImageView alloc] init];
            imageV2.frame = CGRectMake(imageV1.right + line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
            NSString *url2 = [IPADDRESS stringByAppendingString:contentDic[@"avatar_1"]];
            [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV2.layer.cornerRadius = 3;
            imageV2.clipsToBounds = YES;
            [self.personalCardView addSubview:imageV2];
        }
        else if (jobArray.count == 3)
        {
            UIImageView *imageV1 = [[UIImageView alloc] init];
            imageV1.frame = CGRectMake(line + muchphotoWidth/2, line, muchphotoWidth, muchphotoWidth);
            NSString *url1 = [IPADDRESS stringByAppendingString:contentDic[@"avatar_0"]];
            [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV1.layer.cornerRadius = 3;
            imageV1.clipsToBounds = YES;
            [self.personalCardView addSubview:imageV1];
            
            UIImageView *imageV2 = [[UIImageView alloc] init];
            imageV2.frame = CGRectMake(line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
            NSString *url2 = [IPADDRESS stringByAppendingString:contentDic[@"avatar_1"]];
            [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV2.layer.cornerRadius = 3;
            imageV2.clipsToBounds = YES;
            [self.personalCardView addSubview:imageV2];
            
            UIImageView *imageV3 = [[UIImageView alloc] init];
            imageV3.frame = CGRectMake(imageV2.right + line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
            NSString *url3 = [IPADDRESS stringByAppendingString:contentDic[@"avatar_2"]];
            [imageV3 sd_setImageWithURL:URLWITHSTR(url3) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV3.layer.cornerRadius = 3;
            imageV3.clipsToBounds = YES;
            [self.personalCardView addSubview:imageV3];
        }
        else if ([type isEqualToString:@"15"]||[type isEqualToString:@"16"])//收藏别人收藏的单个的聊天记录
        {
        
        }
        else
        {
            for (int i = 0; i<4; i++) {
                UIImageView *imageV = [[UIImageView alloc] init];
                imageV.frame = CGRectMake(line + (line + muchphotoWidth)*(i%2), line + (line + muchphotoWidth)*(i/2), muchphotoWidth, muchphotoWidth);
                
                NSString * imageStr = [NSString stringWithFormat:@"avatar_%d",i];
                
                NSString *url = [IPADDRESS stringByAppendingString:contentDic[imageStr]];
                [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
                imageV.layer.cornerRadius = 3;
                imageV.clipsToBounds = YES;
                [self.personalCardView addSubview:imageV];
            }
        }
    }
    else
    {
//        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(00, 0, kHEIGHT(43), kHEIGHT(43))];
        iconImage.userInteractionEnabled = YES;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""]];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.personalCardView addSubview:iconImage];
    }
//    UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(00, 0, kHEIGHT(43), kHEIGHT(43))];
//    iconImage.userInteractionEnabled = YES;
//    [iconImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""]];
//    [self.personalCardView addSubview:iconImage];
    
    NSString * name =@"" ;//contentDic[@"nick_name"]
    NSString * WPID = @"";//contentDic[@"wp_id"]
    if ([type isEqualToString:@"6"]) {
        name = [NSString stringWithFormat:@"%@的名片",contentDic[@"nick_name"]];
        WPID = [NSString stringWithFormat:@"%@ | %@",contentDic[@"position"],contentDic[@"company"]];
    }
    else if ([type isEqualToString:@"8"])
    {
        name = [NSString stringWithFormat:@"求职:%@",contentDic[@"qz_position"]];
//        NSString * string = contentDic[@"info"];
//        NSArray * array = [string componentsSeparatedByString:@" "];
//        NSMutableArray * muarra= [NSMutableArray array];
//        [muarra addObjectsFromArray:array];
//        [muarra removeLastObject];
//        string = [muarra componentsJoinedByString:@" "];
//        WPID = string;
//        WPID = [NSString stringWithFormat:@"%@",contentDic[@"info"]];
        WPID = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",contentDic[@"qz_name"],contentDic[@"qz_sex"],contentDic[@"qz_age"],contentDic[@"qz_educaiton"],contentDic[@"qz_workTime"]];
    }
    else if ([type isEqualToString:@"9"])
    {
        name = [NSString stringWithFormat:@"招聘:%@",contentDic[@"zp_position"]];
//        WPID = contentDic[@"info"];
        NSString * string = contentDic[@"info"];
        NSArray * array = [string componentsSeparatedByString:@" "];
        NSMutableArray * muarra= [NSMutableArray array];
        [muarra addObjectsFromArray:array];
        [muarra removeLastObject];
        string = [muarra componentsJoinedByString:@" "];
        WPID = string;
    }
    else if ([type isEqualToString:@"11"])
    {
        name = [NSString stringWithFormat:@"%@",contentDic[@"message"]];
        WPID = @"";
    }
    else if ([type isEqualToString:@"10"])
    {
        name = [NSString stringWithFormat:@"%@",contentDic[@"title"]];
        WPID = @"";
    }
    else if ([type isEqualToString:@"15"]||[type isEqualToString:@"16"])
    {
        name = [NSString stringWithFormat:@"%@",contentDic[@"title"]];
        WPID = @"";
    }
    
    CGSize namSize = [@"你好啊" getSizeWithFont:kFONT(14) Width:self.personalCardView.width-kHEIGHT(43)-10-kHEIGHT(10)];
    CGSize idSize = [@"我很好" getSizeWithFont:kFONT(12) Width:self.personalCardView.width-kHEIGHT(43)-10-kHEIGHT(10)];
    
    CGFloat topAndBottom = (kHEIGHT(43)-8-namSize.height-idSize.height)/2;
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.right+10, topAndBottom, self.personalCardView.width-kHEIGHT(43)-10-kHEIGHT(10), namSize.height)];
    nameLabel.text = name;
    nameLabel.font = kFONT(14);
    nameLabel.userInteractionEnabled = YES;
//    nameLabel.backgroundColor = [UIColor greenColor];
    [self.personalCardView addSubview:nameLabel];
    if (!WPID.length) {
        nameLabel.frame = CGRectMake(iconImage.right+10, 0, self.personalCardView.width-kHEIGHT(43)-10-kHEIGHT(10), kHEIGHT(43));
        nameLabel.numberOfLines = 2;
    }
    if ([type isEqualToString:@"15"]||[type isEqualToString:@"16"])
    {
        CGRect rect = nameLabel.frame;
        rect.origin.x -= kHEIGHT(43);
        rect.size.width = self.personalCardView.width-20;
        nameLabel.frame = rect;
    }
    UILabel * idLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.right+10, nameLabel.bottom+8, self.personalCardView.width-kHEIGHT(43)-10-kHEIGHT(10), idSize.height)];
    idLabel.text = WPID;
    idLabel.textAlignment = NSTextAlignmentLeft;
    idLabel.userInteractionEnabled = YES;
    idLabel.font = kFONT(12);
    idLabel.textColor = RGB(127, 127, 127);
//    idLabel.backgroundColor = [UIColor redColor];
    [self.personalCardView addSubview:idLabel];
    
    if (!WPID.length) {
        CGRect rect = idLabel.frame;
        rect.size.height = 0;
        idLabel.frame = rect;
    }
}

-(void)clickBack:(UITapGestureRecognizer*)tap
{
//    self.personalCardView.backgroundColor = RGB(200, 200, 200);
//    NSLog(@"点击了");
    if (self.clickBackView) {
        self.clickBackView(self.indexpath);
    }
}
- (CGFloat)getHeightForContentStringWithDic:(NSDictionary *)dic
{
    CGFloat height = 0 ;
    NSString *string = dic[@"content"];
    if (string.length > 0) {
        CGSize size = [string getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)-10-self.icon.width];
        height = size.height;
    }
    return height;
}
-(void)removeSubviews
{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
