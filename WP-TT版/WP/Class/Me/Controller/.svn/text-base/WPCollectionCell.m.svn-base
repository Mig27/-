//
//  WPCollectionCell.m
//  WP
//
//  Created by CBCCBC on 16/4/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCollectionCell.h"

#import "VideoBrowser.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "WPMySecurities.h"
#import "ShareResume.h"
#define photoWidth (SCREEN_WIDTH==320)?74:((SCREEN_WIDTH==375)?79:86)
#define videoWidth (SCREEN_WIDTH==320)?112:((SCREEN_WIDTH==375)?131:145)
//CGFloat viWidth;
//if (SCREEN_WIDTH == 320) {
//    viWidth = 112;
//} else if (SCREEN_WIDTH == 375) {
//    viWidth = 131;
//} else {
//    viWidth = 145;
//}

@interface WPCollectionCell ()
{
    CGFloat left;
    CTTypesetterRef typesetter;
}
@property (nonatomic , strong)UIButton *button;
@property (nonatomic , assign)CGFloat CellHeight;
@property (nonatomic , strong)UIImageView *bottomLine;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIButton *headerView;
@property (nonatomic , strong)UILabel *positionLabel;
@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic , strong)UILabel *companyLabel;
@property (nonatomic , strong)UIView *imagesView;
@property (nonatomic , strong)UILabel *bodyLabel;
@property (nonatomic , strong)UIView *voiceView;
@property (nonatomic , strong)WPApplyView *applyView;

@property (nonatomic , strong)ShareResume *resume;

@property (nonatomic , strong)UIView * applyBackView;
@property (nonatomic , strong)UIView * muchView;//多个面试和招聘

@property (nonatomic , strong) UIView * JobIntBackView;//面试招聘的背景

@property (nonatomic , strong) UIView * personCard;//名片背景
@property (nonatomic , strong) UIView * urlBackView;//url的背景
@property (nonatomic , strong) UIView * shareUrlBack;//说说中收藏的别人分享的说说的链接


@end

@implementation WPCollectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)setSelect:(BOOL)select
{
    _select = select;
    left = select?28:0;
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
//        [self.button setBackgroundColor:[UIColor redColor]];
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.model.selected = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedOfbuttonChanged)]) {
        [self.delegate selectedOfbuttonChanged];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)choiseCell:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (self.clickBtn) {
        self.clickBtn(self.indexpath,sender);
    }
}
-(UIButton*)selectbtn
{
    if (!_selectbtn)
    {
        _selectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        [_selectbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10))];
        [_selectbtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_selectbtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [_selectbtn addTarget:self action:@selector(choiseCell:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _selectbtn;
}
- (void)setInfo:(NSDictionary *)info
{
    _info = [[NSDictionary alloc]init];
    _info = info;
    [self clearSubViews];
    self.CellHeight = self.headerView.bottom;
     NSString *classN = info[@"classN"];
    if ([classN isEqualToString:@"5"]||[classN isEqualToString:@"6"])
    {
        NSString * col4 = info[@"col4"];
        NSString * jobId = [NSString stringWithFormat:@"%@",info[@"jobid"]];
        NSArray * array = [jobId componentsSeparatedByString:@","];
        if (array.count > 1 &&  (![info[@"classType"] isEqualToString:@"22"]))
        {
            self.headerView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(10), kHEIGHT(22),kHEIGHT(22));
            [self.headerView setImage:[UIImage imageNamed:[classN isEqualToString:@"5"]?@"shoucang_qiyezhaopin":@"shoucang_mianshi"] forState:UIControlStateNormal];
            [self setNameToTitleLabelWithName:[classN isEqualToString:@"5"]?@"招聘":@"面试"];// 名称
            [self setPositionToPositionLabelWithPosition:@""];//职位
            [self setAdd_timeToTimeLabelWithAdd_Time:@""];//时间
            [self setCompanyToCompanyLabelWithCompany:@""];//公司
            UIView * line = (UIView*)[self.contentView viewWithTag:1];
            line.height = 0;
        }
        else
        {
            [self setImageToHeaderViewWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,info[@"avatar"]]]];//头像
            [self setNameToTitleLabelWithName:col4.length?[NSString stringWithFormat:@"%@-%@",info[@"nick_name"],col4]:info[@"nick_name"]];// 名称
            [self setPositionToPositionLabelWithPosition:col4.length?@"":info[@"position"]];//职位
            [self setAdd_timeToTimeLabelWithAdd_Time:info[@"add_time"]];//时间
            [self setCompanyToCompanyLabelWithCompany:col4.length?@"":info[@"companName"]];//公司
        }
    }
    else
    {
        NSString * col3 = info[@"col3"];
        NSString * col4 = info[@"col4"];
        if (col3.length)
        {
            NSArray * array = [col3 componentsSeparatedByString:@","];
            [self setImageToHeaderViewWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,array[2]]]];//头像
            [self setNameToTitleLabelWithName:col4.length?[NSString stringWithFormat:@"%@-%@",array[0],col4]:array[0]];// 名称
            [self setPositionToPositionLabelWithPosition:col4.length?@"":[NSString stringWithFormat:@"%@  |  匿名",array[1]]];//职位
            [self setAdd_timeToTimeLabelWithAdd_Time:info[@"add_time"]];//时间
            [self setCompanyToCompanyLabelWithCompany:@""];//公司
            
            UIView *line = (UIView *)[self.contentView viewWithTag:1];
            line.height= 0;;

            
        }
        else
        {
            [self setImageToHeaderViewWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,info[@"avatar"]]]];//头像
            [self setNameToTitleLabelWithName:col4.length?[NSString stringWithFormat:@"%@-%@",info[@"nick_name"],col4]:info[@"nick_name"]];// 名称
            [self setPositionToPositionLabelWithPosition:col4.length?@"":info[@"position"]];//职位
            [self setAdd_timeToTimeLabelWithAdd_Time:info[@"add_time"]];//时间
            [self setCompanyToCompanyLabelWithCompany:col4.length?@"":info[@"companName"]];//公司
//            UIView *line = (UIView *)[self.contentView viewWithTag:1];
//            line.hidden = NO;
        }
        
        
//        if ([classN isEqualToString:@"7"])
//        {
//                [self setImageToHeaderViewWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,info[@"avatar"]]]];//头像
//                [self setNameToTitleLabelWithName:info[@"nick_name"]];// 名称
//                [self setPositionToPositionLabelWithPosition:info[@"position"]];//职位
//                [self setAdd_timeToTimeLabelWithAdd_Time:info[@"add_time"]];//时间
//                [self setCompanyToCompanyLabelWithCompany:info[@"companName"]];//公司
//        }
//        else
//        {
//                [self setImageToHeaderViewWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,info[@"avatar"]]]];//头像
//                [self setNameToTitleLabelWithName:info[@"nick_name"]];// 名称
//                [self setPositionToPositionLabelWithPosition:info[@"position"]];//职位
//                [self setAdd_timeToTimeLabelWithAdd_Time:info[@"add_time"]];//时间
//                [self setCompanyToCompanyLabelWithCompany:info[@"companName"]];//公司
//        }
    }
    
    
    
    if ([classN isEqualToString:@"0"]) {                // 添加文字信息
        [self removeSubViews];
        [self.contentView addSubview:self.bodyLabel];
        NSString * str = [NSString stringWithFormat:@"%@",info[@"content"]];
        NSString *description1 = [WPMySecurities textFromBase64String:str];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        if (description3.length)
        {
           [self setContentToBodyLabelWithContent:description3];
        }
        else
        {
           [self setContentToBodyLabelWithContent:str];
        }
//        [self setContentToBodyLabelWithContent:description3];//info[@"content"]
    }else if ([classN isEqualToString:@"1"]||[classN isEqualToString:@"2"]){           // 添加图片信息
        [self removeSubViews];
        [self.contentView addSubview:self.imagesView];
        if ([classN isEqualToString:@"2"])
        {
            NSArray * imageArr = info[@"img_url"];
            if (imageArr.count == 0)
            {
                NSArray * urlArr = info[@"url"];
                if (!urlArr.count) {
                    return;
                }
                NSString * small_address = urlArr[0][@"small_address"];
                small_address = [small_address stringByReplacingOccurrencesOfString:@"mp4" withString:@"png"];
                NSArray * arr = [small_address componentsSeparatedByString:@"/"];
                NSString * lastStr = arr[arr.count-1];
                lastStr = [@"thumb_" stringByAppendingString:lastStr];
                NSMutableArray * muArr = [NSMutableArray array];
                [muArr addObjectsFromArray:arr];
                [muArr removeLastObject];
                [muArr insertObject:lastStr atIndex:muArr.count];
                NSString * imageUr = [muArr componentsJoinedByString:@"/"];
                [self setImagePhotoToImageViewWithImagePhoto:@[@{@"small_address":imageUr}]];
            }
            else
            {
               [self setImagePhotoToImageViewWithImagePhoto:info[@"img_url"]];
            }
        }
        else
        {
         [self setImagePhotoToImageViewWithImagePhoto:info[@"img_url"]];
        }
        
        
        
        
//        [self setImagePhotoToImageViewWithImagePhoto:info[@"img_url"]];//img_url
    }else if ([classN isEqualToString:@"3"]){           // 添加语音信息
        
        [self removeSubViews];
        [self.contentView addSubview:self.voiceView];
        
    }else if ([classN isEqualToString:@"4"]){
        
        [self removeSubViews];
        [self.contentView addSubview:self.bodyLabel];
        
        NSString * string = [NSString stringWithFormat:@"%@",info[@"content"]];
        NSArray * array = [string componentsSeparatedByString:@":"];
        NSString * str = [NSString string];
        if (array.count >1) {
            str = [NSString stringWithFormat:@"%@",array[1]];
        }
        else
        {
           str = [NSString stringWithFormat:@"%@",array[0]];
        }
        NSString *description1 = [WPMySecurities textFromBase64String:str];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        [self setResumeView];
        self.CellHeight += kHEIGHT(43)+2*kHEIGHT(10);
    }else if ([classN isEqualToString:@"5"]||[classN isEqualToString:@"6"]){//招聘求职

        NSString * jobId = [NSString stringWithFormat:@"%@",info[@"jobid"]];
        NSArray * jobArray = [jobId componentsSeparatedByString:@","];
        
        if (jobArray.count > 1)//判断是否是多个
        {
            [self removeSubViews];
            [self.contentView addSubview:self.muchView];
            
            [self getMuchView];
            self.CellHeight += kHEIGHT(43)+2*kHEIGHT(10);
        }
        else if(jobArray.count == 1)
        {
            [self removeSubViews];
            [self.contentView addSubview:self.applyBackView];
            
            [self applyViewSubview];
            self.CellHeight += kHEIGHT(43)+2*kHEIGHT(10);
        }
    }
    else if ([classN isEqualToString:@"7"]){//网络url
        [self removeSubViews];
        NSString * address = [NSString stringWithFormat:@"%@",info[@"jobid"]];
        NSArray * arary = [address componentsSeparatedByString:@","];
        if (arary.count > 1)
        {
            [self.contentView addSubview:self.muchView];
            [self getMuchView];
        }
        else
        {
            [self.contentView addSubview:self.urlBackView];
            [self getOneUrlData];
        }
         self.CellHeight += kHEIGHT(43)+2*kHEIGHT(10);
//        [self.contentView addSubview:self.applyBackView];
//        NSArray *arr = info[@"img_url"];
//        self.applyView.image = arr[0][@"small_address"];
//        NSString * string = [NSString stringWithFormat:@"%@",info[@"address"]];
//        self.applyView.title = string;//info[@"title"]
//        self.applyView.company = info[@"company"];
        
    }else if ([classN isEqualToString:@"8"]){//名片
        [self removeSubViews];
        [self.contentView addSubview:self.personCard];
//        self.personCard.frame = CGRectMake(0, 0, 100, 30);
        [self personSubview];
        self.CellHeight += kHEIGHT(43)+2*kHEIGHT(10);
        
//        [self.contentView addSubview:self.applyBackView];
//        self.applyView.image = info[@"avatar"];
//        self.applyView.title = info[@"nick_title"];
//        self.applyView.company = [NSString stringWithFormat:@"微聘号:%@",info[@"address"]];
    }
    
    else if ([classN isEqualToString:@"15"])//批量收藏单个
    {
        [self removeSubViews];
//        [self.contentView addSubview:self.bodyLabel];
        [self getCollectionBack];
    }
    else if ([classN isEqualToString:@"16"])//批量收藏群聊
    {
        [self removeSubViews];
        //        [self.contentView addSubview:self.bodyLabel];
        [self getgroupCollectionBack];
    }
    
    if (_isFromChat)
    {
        [self.contentView addSubview:self.selectbtn];
    }
}
-(void)getgroupCollectionBack
{
    [self.contentView addSubview:self.shareUrlBack];
    if (self.isFromChat)
    {
        self.shareUrlBack.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left-20-kHEIGHT(10), kHEIGHT(43));//self.bodyLabel.bottom+kHEIGHT(10)->kHEIGHT(42)
    }
    else
    {
        self.shareUrlBack.frame = CGRectMake(kHEIGHT(10)+left,  kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, kHEIGHT(43));
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];//
    titleLabel.frame = CGRectMake(10, 0, self.shareUrlBack.width-10, kHEIGHT(43));
    
    titleLabel.text = _info[@"title"];
    titleLabel.font = kFONT(14);
    titleLabel.numberOfLines = 1;
    [self.shareUrlBack addSubview:titleLabel];
}
-(void)getCollectionBack
{
    [self.contentView addSubview:self.shareUrlBack];
    if (self.isFromChat)
    {
        self.shareUrlBack.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left-20-kHEIGHT(10), kHEIGHT(43));//self.bodyLabel.bottom+kHEIGHT(10)->kHEIGHT(42)
    }
    else
    {
        self.shareUrlBack.frame = CGRectMake(kHEIGHT(10)+left,  kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, kHEIGHT(43));
    }
 
    UILabel *titleLabel = [[UILabel alloc] init];//
    titleLabel.frame = CGRectMake(10, 0, self.shareUrlBack.width-10, kHEIGHT(43));
    
    titleLabel.text = _info[@"title"];
    titleLabel.font = kFONT(14);
    titleLabel.numberOfLines = 1;
    [self.shareUrlBack addSubview:titleLabel];
}
#pragma mark  简历招聘的子视图
-(void)applyViewSubview//applyBackView
{
    if (_isFromChat)
    {
       self.applyBackView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-2*kHEIGHT(10)-left-20-kHEIGHT(10), kHEIGHT(43));
    }
    else
    {
     self.applyBackView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-2*kHEIGHT(10)-left, kHEIGHT(43));
    }
//  self.applyBackView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-2*kHEIGHT(10)-left, kHEIGHT(43));
    
//    self.applyView.image = [info[@"img_url"][0]objectForKey:@"small_address"];
    //            self.applyView.title = [classN isEqualToString:@"6"]?[NSString stringWithFormat:@"求职 : %@",info[@"title"]]:[NSString stringWithFormat:@"招聘 : %@",info[@"title"]];
    //            self.applyView.company = info[@"company"];
    NSString * classN = [NSString stringWithFormat:@"%@",_info[@"classN"]];
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
    NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,[_info[@"img_url"][0]objectForKey:@"small_address"]];
    [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
    [self.applyBackView addSubview:imageV];
    
    CGSize titleSize1 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGSize titleSize2 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(43) - titleSize1.height - titleSize2.height -8)/2;
    UILabel *titleLabel = [[UILabel alloc] init];
    
    
    titleLabel.frame = CGRectMake(imageV.right + 10, y,self.applyBackView.width-imageV.right-10 , titleSize1.height);//self.width - kHEIGHT(43) - 10
    NSString * string = [_info[@"title"] stringByReplacingOccurrencesOfString:@"招聘：" withString:@""];
    titleLabel.text = [classN isEqualToString:@"6"]?[NSString stringWithFormat:@"求职：%@",_info[@"title"]]:[NSString stringWithFormat:@"招聘：%@",string];
    titleLabel.font = kFONT(14);
    titleLabel.textColor = [UIColor blackColor];
    [self.applyBackView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.frame = CGRectMake(imageV.right + 10, titleLabel.bottom + 8, titleLabel.width, titleSize2.height);
    subTitleLabel.text = [NSString stringWithFormat:@"%@",_info[@"company"]];
    subTitleLabel.font = kFONT(12);
    subTitleLabel.textColor = RGB(127, 127, 127);
    [self.applyBackView addSubview:subTitleLabel];
}
#pragma mark 设置名牌上的视图
-(void)personSubview
{
    if (_isFromChat)
    {
       self.personCard.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-2*kHEIGHT(10)-left-20-kHEIGHT(10), kHEIGHT(43));
    }
    else
    {
       self.personCard.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-2*kHEIGHT(10)-left, kHEIGHT(43));
    }
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
    NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,_info[@"avatar"]];
    [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
    [self.personCard addSubview:imageV];
    
    CGSize titleSize1 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGSize titleSize2 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(43) - titleSize1.height - titleSize2.height -8)/2;
    UILabel *titleLabel = [[UILabel alloc] init];
    
    
    //        titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.frame = CGRectMake(imageV.right + 10, y,self.personCard.width-imageV.right-10 , titleSize1.height);//self.width - kHEIGHT(43) - 10
    titleLabel.text = _info[@"nick_title"];
    titleLabel.font = kFONT(14);
    titleLabel.textColor = [UIColor blackColor];
    [self.personCard addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.frame = CGRectMake(imageV.right + 10, titleLabel.bottom + 8, titleLabel.width, titleSize2.height);
    subTitleLabel.text = [NSString stringWithFormat:@"%@ | %@",_info[@"position"],_info[@"companName"]];//@"微聘号:%@",_info[@"address"]
    subTitleLabel.font = kFONT(12);
    subTitleLabel.textColor = RGB(127, 127, 127);
    [self.personCard addSubview:subTitleLabel];
}
#pragma mark 分享中只有一个面试和招聘的url
-(void)getOneUrlData
{
    if (_isFromChat)
    {
       self.urlBackView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left-20-kHEIGHT(10), kHEIGHT(43));
    }
    else
    {
      self.urlBackView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, kHEIGHT(43));
    }
//    self.urlBackView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, kHEIGHT(43));
    CGSize titleSize1 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGSize titleSize2 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(43) - titleSize1.height - titleSize2.height -8)/2;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
    NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,_info[@"img_url"][0][@"small_address"]];
    [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
    [self.urlBackView addSubview:imageV];
    if ([_info[@"share"] isEqualToString:@"1"] || [_info[@"share"] isEqualToString:@"0"])
    {
        NSString * addressstr = [NSString stringWithFormat:@"%@",_info[@"address"]];
//        NSArray * array = [addressstr componentsSeparatedByString:@":"];
//        
//        NSString * string = [NSString string];
//        NSString * string1 = [NSString string];
//        NSString * string2 = [NSString string];
//        if (array.count)
//        {
//            if (array.count>2) {
//                string = [NSString stringWithFormat:@"%@",array[0]];
//                string1 = [NSString stringWithFormat:@"%@",array[1]];
//                string2 = [NSString stringWithFormat:@"%@",array[2]];
//            }
//            else if (array.count>1)
//            {
//                string = [NSString stringWithFormat:@"%@",array[0]];
//                string1 = [NSString stringWithFormat:@"%@",array[1]];
//                string2 = @"";
//            }
//            else
//            {
//                string = [NSString stringWithFormat:@"%@",array[0]];
//                string1 = @"";
//                string2 = @"";
//            }
//        }
//        else
//        {
//            string = @"";
//            string1 = @"";
//            string2 = @"";
//        }
//        
//        
//        NSString *lastDestription = [NSString stringWithFormat:@"%@ : %@  %@",string,string1,string2];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:lastDestription];
//        [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, string.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(string.length + 2 + 1, string1.length + 1)];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        //        titleLabel.backgroundColor = [UIColor lightGrayColor];
        titleLabel.frame = CGRectMake(imageV.right + 10,0,self.urlBackView.width-imageV.right-10 , kHEIGHT(43));//self.width - kHEIGHT(43) - 10
        titleLabel.text = addressstr;
        titleLabel.font = kFONT(14);
        titleLabel.numberOfLines = 2;
//        titleLabel.textColor = [UIColor blackColor];
        [self.urlBackView addSubview:titleLabel];
    }
    else
    {
        
       
        UILabel *titleLabel = [[UILabel alloc] init];
       
        NSString *companyStr = [NSString stringWithFormat:@"%@",_info[@"company"]];
        if (companyStr.length)
        {
            titleLabel.frame = CGRectMake(imageV.right + 10, y,self.urlBackView.width-imageV.right-10 , titleSize1.height);
            titleLabel.numberOfLines = 1;
        }
        else
        {
          titleLabel.frame = CGRectMake(imageV.right + 10, y,self.urlBackView.width-imageV.right-10 ,kHEIGHT(43));
            titleLabel.numberOfLines = 2;
        }
        NSString * contentStr = [NSString stringWithFormat:@"%@",_info[@"address"]];
        NSArray * array = [contentStr componentsSeparatedByString:@":"];
        NSString * string = [NSString string];
        NSString * string1 = [NSString string];
        NSString * string2 = [NSString string];
        if ([_info[@"share"] isEqualToString:@"2"]) {//求职
            string = [NSString stringWithFormat:@"%@",array[0]];
        }
        else
        {
            string = [NSString stringWithFormat:@"%@",array[1]];
        }
//        NSMutableArray * muArray = [NSMutableArray array];
//        [muArray addObjectsFromArray:array];
       
//        if (muArray.count)
//        {
//            if (muArray.count>2) {
//                string = [NSString stringWithFormat:@"%@",muArray[0]];
//                string1 = [NSString stringWithFormat:@"%@",muArray[1]];
//                string2 = [NSString stringWithFormat:@"%@",muArray[2]];
//            }
//            else if (muArray.count>1)
//            {
//                string = [NSString stringWithFormat:@"%@",muArray[0]];
//                string1 = [NSString stringWithFormat:@"%@",muArray[1]];
//                string2 = @"";
//            }
//            else
//            {
//                string = [NSString stringWithFormat:@"%@",muArray[0]];
//                string1 = @"";
//                string2 = @"";
//            }
//        }
//        else
//        {
//            string = @"";
//            string1 = @"";
//            string2 = @"";
//         }

//        NSString *lastDestription = [NSString stringWithFormat:@"%@ : %@  %@",string,string1,string2];
        titleLabel.text = string;//lastDestription
        titleLabel.font = kFONT(14);
        [self.urlBackView addSubview:titleLabel];
        
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.frame = CGRectMake(imageV.right + 10, titleLabel.bottom + 8, titleLabel.width, titleSize2.height);
        subTitleLabel.text = [NSString stringWithFormat:@"%@",_info[@"company"]];
        NSLog(@"company:%@",_info[@"company"]);
        subTitleLabel.font = kFONT(12);
        subTitleLabel.textColor = RGB(127, 127, 127);
       
        [self.urlBackView addSubview:subTitleLabel];
    }
}
#pragma mark  多个招聘和面试
-(void)getMuchView
{
    NSString * classN= [NSString stringWithFormat:@"%@",_info[@"classN"]];
    NSString * jobId = [NSString stringWithFormat:@"%@",_info[@"jobid"]];
    NSString * urlShare = [NSString stringWithFormat:@"%@",_info[@"share"]];
    NSArray * jobArray = [jobId componentsSeparatedByString:@","];
    CGFloat muchphotoWidth;
    CGFloat line = 2;//0.5->2
    if (jobArray.count == 0) {
        muchphotoWidth = kHEIGHT(43);
    } else {
        muchphotoWidth = (kHEIGHT(43) - 6)/2;//1.5->6
    }
    
    if (_isFromChat)
    {
      self.muchView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left-20-kHEIGHT(10), kHEIGHT(43));
    }
    else
    {
     self.muchView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, kHEIGHT(43));
    }
    
    UIView *imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43))];
    imageBackView.backgroundColor = RGB(221, 221, 221);
    [self.muchView addSubview:imageBackView];
    
    
    NSString * address = [NSString stringWithFormat:@"%@",_info[@"address"]];
    NSArray * addressArray = [NSArray array];
    if (address.length)
    {
       addressArray  = [address componentsSeparatedByString:@":"];
    }
    
   
    if (jobArray.count == 2)
    {
        UIImageView *imageV1 = [[UIImageView alloc] init];
        imageV1.frame = CGRectMake(line, line, muchphotoWidth, muchphotoWidth);
        NSString *url1 = [IPADDRESS stringByAppendingString:_info[@"img_url"][0][@"small_address"]];
        [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        imageV1.layer.cornerRadius = 2.5;
        imageV1.clipsToBounds = YES;
        [self.muchView addSubview:imageV1];
        
        UIImageView *imageV2 = [[UIImageView alloc] init];
        imageV2.frame = CGRectMake(imageV1.right + line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
        NSString *url2 = [IPADDRESS stringByAppendingString:_info[@"img_url"][1][@"small_address"]];
        [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        imageV2.layer.cornerRadius = 2.5;
        imageV2.clipsToBounds = YES;
        [self.muchView addSubview:imageV2];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV2.right + 11, 0,self.muchView.width-kHEIGHT(43)-11 , kHEIGHT(43))];//self.width - 2*muchphotoWidth - 13
        
        
       
        titleLabel.text = ([classN isEqualToString:@"6"])?[NSString stringWithFormat:@"%@",_info[@"company"]]:([classN isEqualToString:@"5"]?[NSString stringWithFormat:@"%@",_info[@"company"]]:([urlShare isEqualToString:@"2"]?[NSString stringWithFormat:@"%@",_info[@"address"]]:[NSString stringWithFormat:@"%@",((addressArray.count>1)?addressArray[1]:@"")]));//_info[@"address"]
        
        
        titleLabel.font = kFONT(14);
         titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor blackColor];
        [self.muchView addSubview:titleLabel];
    }
    else if (jobArray.count == 3)
    {
        UIImageView *imageV1 = [[UIImageView alloc] init];
        imageV1.frame = CGRectMake(line + muchphotoWidth/2, line, muchphotoWidth, muchphotoWidth);
        NSString *url1 = [IPADDRESS stringByAppendingString:_info[@"img_url"][0][@"small_address"]];
        [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        imageV1.layer.cornerRadius = 2.5;
        imageV1.clipsToBounds = YES;
        [self.muchView addSubview:imageV1];
        
        UIImageView *imageV2 = [[UIImageView alloc] init];
        imageV2.frame = CGRectMake(line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
        NSString *url2 = [IPADDRESS stringByAppendingString:_info[@"img_url"][1][@"small_address"]];
        [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        imageV2.layer.cornerRadius = 2.5;
        imageV2.clipsToBounds = YES;
        [self.muchView addSubview:imageV2];
        
        UIImageView *imageV3 = [[UIImageView alloc] init];
        imageV3.frame = CGRectMake(imageV2.right + line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
        NSString *url3 = [IPADDRESS stringByAppendingString:_info[@"img_url"][2][@"small_address"]];
        [imageV3 sd_setImageWithURL:URLWITHSTR(url3) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        imageV3.layer.cornerRadius = 2.5;
        imageV3.clipsToBounds = YES;
        [self.muchView addSubview:imageV3];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV3.right + 11, 0,self.muchView.width-kHEIGHT(43)-11 , kHEIGHT(43))];//self.muchView.width-kHEIGHT(43)-11//self.width - 2*muchphotoWidth - 13
        titleLabel.numberOfLines = 2;
//      titleLabel.text = ([classN isEqualToString:@"6"])?[NSString stringWithFormat:@"%@等人的求职简历",_info[@"company"]]:[NSString stringWithFormat:@"%@等公司的招聘信息",_info[@"company"]];
     titleLabel.text = ([classN isEqualToString:@"6"])?[NSString stringWithFormat:@"%@",_info[@"company"]]:([classN isEqualToString:@"5"]?[NSString stringWithFormat:@"%@",_info[@"company"]]:([urlShare isEqualToString:@"2"]?[NSString stringWithFormat:@"%@",_info[@"address"]]:[NSString stringWithFormat:@"%@",((addressArray.count>1)?addressArray[1]:@"")]));
        titleLabel.font = kFONT(14);
        titleLabel.textColor = [UIColor blackColor];
        [self.muchView addSubview:titleLabel];

    }
    else
    {
    
        for (int i = 0; i<4; i++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = CGRectMake(line + (line + muchphotoWidth)*(i%2), line + (line + muchphotoWidth)*(i/2), muchphotoWidth, muchphotoWidth);
            NSString *url = [IPADDRESS stringByAppendingString:_info[@"img_url"][i][@"small_address"]];
            [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
            imageV.layer.cornerRadius = 2.5;
            imageV.clipsToBounds = YES;
            [self.muchView addSubview:imageV];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(43) + 11, 0,self.muchView.width-kHEIGHT(43)-11, kHEIGHT(43))];//self.width - kHEIGHT(43) - 11
//        titleLabel.backgroundColor = [UIColor redColor];
         titleLabel.numberOfLines = 2;
        titleLabel.text = ([classN isEqualToString:@"6"])?[NSString stringWithFormat:@"%@",_info[@"company"]]:([classN isEqualToString:@"5"]?[NSString stringWithFormat:@"%@",_info[@"company"]]:([urlShare isEqualToString:@"2"]?[NSString stringWithFormat:@"%@",_info[@"address"]]:[NSString stringWithFormat:@"%@",((addressArray.count>1)?addressArray[1]:@"")]));
        titleLabel.font = kFONT(14);
        titleLabel.textColor = [UIColor blackColor];
        [self.muchView addSubview:titleLabel];

    }
}
#pragma mark
-(void)setResumeView
{
    NSString * share = [NSString stringWithFormat:@"%@",_info[@"share"]];
    if ([share isEqualToString:@"2"]||[share isEqualToString:@"3"])
    {
        NSString * address = [NSString stringWithFormat:@"%@",_info[@"address"]];
        NSArray * array = [address componentsSeparatedByString:@","];
        if (array.count > 1)
        {
            [self getShareViewBack];
//            [self.contentView addSubview:self.JobIntBackView];
//            if (self.isFromChat)
//            {
//              self.JobIntBackView.frame = CGRectMake(self.bodyLabel.left, kHEIGHT(42), self.bodyLabel.width-20-kHEIGHT(10), kHEIGHT(43));//self.bodyLabel.bottom+kHEIGHT(10)->kHEIGHT(42)
//            }
//            else
//            {
//              self.JobIntBackView.frame = CGRectMake(self.bodyLabel.left, kHEIGHT(42), self.bodyLabel.width, kHEIGHT(43));
//            }
//            
////            self.JobIntBackView.frame = CGRectMake(self.bodyLabel.left, self.bodyLabel.bottom+kHEIGHT(10), self.bodyLabel.width, kHEIGHT(43));
//            
//            CGFloat muchphotoWidth;
//            CGFloat line = 0.5;
//            if (array.count == 0) {
//                muchphotoWidth = kHEIGHT(43);
//            } else {
//                muchphotoWidth = (kHEIGHT(43) - 1.5)/2;
//            }
//            if (array.count == 2)
//            {
//                UIImageView *imageV1 = [[UIImageView alloc] init];
//                imageV1.frame = CGRectMake(line, line, muchphotoWidth, muchphotoWidth);
//                NSString *url1 = [IPADDRESS stringByAppendingString:_info[@"img_url"][0][@"small_address"]];
//                [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//                imageV1.layer.cornerRadius = 2.5;
//                imageV1.clipsToBounds = YES;
//                [self.JobIntBackView addSubview:imageV1];
//                
//                UIImageView *imageV2 = [[UIImageView alloc] init];
//                imageV2.frame = CGRectMake(imageV1.right + line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
//                NSString *url2 = [IPADDRESS stringByAppendingString:_info[@"img_url"][1][@"small_address"]];
//                [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//                imageV2.layer.cornerRadius = 2.5;
//                imageV2.clipsToBounds = YES;
//                [self.JobIntBackView addSubview:imageV2];
//                
//                
//                UILabel *titleLabel = [[UILabel alloc] init];
//                titleLabel.frame = CGRectMake(imageV2.right + 10, 0,self.JobIntBackView.width-imageV2.right-10 , kHEIGHT(43));//self.width - kHEIGHT(43) - 10
//                titleLabel.text = [share isEqualToString:@"2"]?[NSString stringWithFormat:@"%@", self.info[@"address"]]:[NSString stringWithFormat:@"%@", self.info[@"address"]];
//                titleLabel.font = kFONT(14);
//                titleLabel.numberOfLines = 2;
//                titleLabel.textColor = [UIColor blackColor];
//                [self.JobIntBackView addSubview:titleLabel];
//
//                
//            }
//            else if (array.count == 3)
//            {
//                UIImageView *imageV1 = [[UIImageView alloc] init];
//                imageV1.frame = CGRectMake(line + muchphotoWidth/2, line, muchphotoWidth, muchphotoWidth);
//                NSString *url1 = [IPADDRESS stringByAppendingString:_info[@"img_url"][0][@"small_address"]];
//                [imageV1 sd_setImageWithURL:URLWITHSTR(url1) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//                imageV1.layer.cornerRadius = 2.5;
//                imageV1.clipsToBounds = YES;
//                [self.JobIntBackView addSubview:imageV1];
//                
//                UIImageView *imageV2 = [[UIImageView alloc] init];
//                imageV2.frame = CGRectMake(line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
//                NSString *url2 = [IPADDRESS stringByAppendingString:_info[@"img_url"][1][@"small_address"]];
//                [imageV2 sd_setImageWithURL:URLWITHSTR(url2) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//                imageV2.layer.cornerRadius = 2.5;
//                imageV2.clipsToBounds = YES;
//                [self.JobIntBackView addSubview:imageV2];
//                
//                UIImageView *imageV3 = [[UIImageView alloc] init];
//                imageV3.frame = CGRectMake(imageV2.right + line, imageV1.bottom + line, muchphotoWidth, muchphotoWidth);
//                NSString *url3 = [IPADDRESS stringByAppendingString:_info[@"img_url"][2][@"small_address"]];
//                [imageV3 sd_setImageWithURL:URLWITHSTR(url3) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//                imageV3.layer.cornerRadius = 2.5;
//                imageV3.clipsToBounds = YES;
//                [self.JobIntBackView addSubview:imageV3];
//                
//                UILabel *titleLabel = [[UILabel alloc] init];
//                titleLabel.frame = CGRectMake(imageV3.right + 10, 0,self.JobIntBackView.width-imageV3.right-10 , kHEIGHT(43));//self.width - kHEIGHT(43) - 10
//                titleLabel.text = [share isEqualToString:@"2"]?[NSString stringWithFormat:@"%@", self.info[@"address"]]:[NSString stringWithFormat:@"%@", self.info[@"address"]];
//                titleLabel.font = kFONT(14);
////                titleLabel.backgroundColor = [UIColor redColor];
//                titleLabel.numberOfLines = 2;
//                titleLabel.textColor = [UIColor blackColor];
//                [self.JobIntBackView addSubview:titleLabel];
//            }
//            else
//            {
//                for (int i = 0; i<4; i++)
//                {
//                    UIImageView *imageV = [[UIImageView alloc] init];
//                    imageV.frame = CGRectMake(line + (line + muchphotoWidth)*(i%2), line + (line + muchphotoWidth)*(i/2), muchphotoWidth, muchphotoWidth);
//                    NSString *url = [IPADDRESS stringByAppendingString:_info[@"img_url"][i][@"small_address"]];
//                    [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//                    imageV.layer.cornerRadius = 2.5;
//                    imageV.clipsToBounds = YES;
//                    [self.JobIntBackView addSubview:imageV];
//                }
//                UILabel *titleLabel = [[UILabel alloc] init];
//                titleLabel.frame = CGRectMake(kHEIGHT(43) + 11, 0,self.JobIntBackView.width-kHEIGHT(43)-11, kHEIGHT(43));//self.width - kHEIGHT(43) - 11
//                titleLabel.text = [share isEqualToString:@"2"]?[NSString stringWithFormat:@"%@", self.info[@"address"]]:[NSString stringWithFormat:@"%@", self.info[@"address"]];
//                titleLabel.font = kFONT(14);
//                titleLabel.numberOfLines = 2;
//                titleLabel.textColor = [UIColor blackColor];
//                [self.JobIntBackView addSubview:titleLabel];
//            }
        }
        else
        {
            [self getShareViewBack];
//            CGSize titleSize1 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
//            CGSize titleSize2 = [@"我擦" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
//            CGFloat y = (kHEIGHT(43) - titleSize1.height - titleSize2.height -8)/2;
//            
//            [self.contentView addSubview:self.JobIntBackView];
//            self.JobIntBackView.frame = CGRectMake(self.bodyLabel.left, self.bodyLabel.bottom+kHEIGHT(10), self.bodyLabel.width, kHEIGHT(43));
//            
//            UIImageView *imageV = [[UIImageView alloc] init];
//            imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
//            NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,self.info[@"url"][0][@"small_address"]];
//            [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"placeImage"]];
//            [self.JobIntBackView addSubview:imageV];
//            
//            
//            
//            UILabel *titleLabel = [[UILabel alloc] init];
//            titleLabel.frame = CGRectMake(imageV.right + 10, y,self.JobIntBackView.width-imageV.right-10 , titleSize1.height);//self.width - kHEIGHT(43) - 10
//            titleLabel.text = [share isEqualToString:@"2"]?[NSString stringWithFormat:@"求职 : %@", self.info[@"address"]]:[NSString stringWithFormat:@"招聘 : %@", self.info[@"address"]];
//            titleLabel.font = kFONT(14);
//            titleLabel.textColor = [UIColor blackColor];
//            [self.JobIntBackView addSubview:titleLabel];
//            
//            UILabel *subTitleLabel = [[UILabel alloc] init];
//            //        subTitleLabel.backgroundColor = [UIColor lightGrayColor];
//            subTitleLabel.frame = CGRectMake(imageV.right + 10, titleLabel.bottom + 8, titleLabel.width, titleLabel.height);
//            if ([share isEqualToString:@"2"]) {
//                subTitleLabel.text = [NSString stringWithFormat:@"%@",self.info[@"company"]];
//            } else {
//                subTitleLabel.text = [NSString stringWithFormat:@"%@",self.info[@"company"]];
//            }
//            subTitleLabel.font = kFONT(12);
//            subTitleLabel.textColor = RGB(127, 127, 127);
//            [self.JobIntBackView addSubview:subTitleLabel];
        }
    }
    else//收藏的原说说或分享的说说
    {
        if ([share isEqualToString:@"1"])//分享的说说
        {
//            self.bodyLabel.height = 0;
            [self getShareViewBack];
        }
        else//原说说
        {
            [self getShareViewBack];
//            [self.contentView addSubview:self.imagesView];
//            [self setImagePhotoToImageViewWithImagePhoto:_info[@"img_url"]];
        }
    }
}
#pragma mark
-(void)getShareViewBack
{
    [self.contentView addSubview:self.shareUrlBack];
    
    if (self.isFromChat)
    {
       self.shareUrlBack.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left-20-kHEIGHT(10), kHEIGHT(43));//self.bodyLabel.bottom+kHEIGHT(10)->kHEIGHT(42)
    }
    else
    {
     self.shareUrlBack.frame = CGRectMake(kHEIGHT(10)+left,  kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, kHEIGHT(43));
    }

    BOOL isVideoOrNot = NO;
    NSArray * videoArr = _info[@"url"];
    if (videoArr.count) {
        NSString * videoStr = videoArr[0][@"small_address"];
        if ([videoStr hasSuffix:@".mp4"]) {
            isVideoOrNot = YES;
        }
    }
    
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
    NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,[_info[@"img_url"] count]?_info[@"img_url"][0][@"small_address"]:@""];
    [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@""]];
    [self.shareUrlBack addSubview:imageV];
    
    //如果是视频则 添加按钮
    if (isVideoOrNot) {
        UIImageView * videoImage = [[UIImageView alloc]initWithFrame:CGRectMake((kHEIGHT(43)-20)/2, (kHEIGHT(43)-20)/2, 20, 20)];
        videoImage.image = [UIImage imageNamed:@"video_play"];
        [self.shareUrlBack addSubview:videoImage];
    }
    
    NSString * contentStr = [NSString string];
    NSString * firstStr = [NSString string];
   
    if ([_info[@"share"] isEqualToString:@"0"]) {
        
        firstStr = _info[@"speak_class"];
        contentStr = [NSString stringWithFormat:@"%@",_info[@"content"]];
//        NSArray * array = [string componentsSeparatedByString:@":"];
//        if (array.count >=2) {
//            NSString *description1 = [WPMySecurities textFromBase64String:array[1]];
//            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//            contentStr = description3;
//        }
//        else
//        {
//           contentStr = array[0];
//        }
        
        
//        NSString *description1 = [WPMySecurities textFromBase64String:array[1]];
//        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//        contentStr = description3;
        
//        firstStr = array[0];
        if (!contentStr.length) {
            NSArray * array = _info[@"url"];
            if (array.count) {
                NSString * firstString = array[0][@"small_address"];
                if ([firstString hasSuffix:@".jpg"]||[firstString hasSuffix:@".png"]) {
                    contentStr = @"[图片]";
                }
                if ([firstString hasSuffix:@".mp4"]) {
                    contentStr = @"[视频]";
                }
            }
       }
    }
    else if([_info[@"share"] isEqualToString:@"2"]||[_info[@"share"] isEqualToString:@"3"])
    {
      NSString * string = [NSString stringWithFormat:@"%@",_info[@"content"]];
        NSArray * array = [string componentsSeparatedByString:@":"];
      NSString *description1 = [WPMySecurities textFromBase64String:array[1]];
      NSString *description3 = [WPMySecurities textFromEmojiString:description1];
      contentStr = description3;
        //firstStr = array[0];
        firstStr = [string stringByReplacingOccurrencesOfString:@":" withString:@"/"];
    }
    else if ([_info[@"share"] isEqualToString:@"1"])
    {
      NSString * string = [NSString stringWithFormat:@"%@",_info[@"content"]];
//      NSString *description1 = [WPMySecurities textFromBase64String:string];
//      NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        NSArray * strArray = [string componentsSeparatedByString:@":"];
        if (strArray.count >1) {
            NSString * secondStr = [NSString stringWithFormat:@"%@",strArray[1]];
            if ([secondStr isEqualToString:@"分享"]) {
                string = [NSString stringWithFormat:@"%@/分享",strArray[0]];
            }
        }
      contentStr = string;
    }
    UILabel *titleLabel = [[UILabel alloc] init];//
    if ([_info[@"img_url"] count])
    {
       titleLabel.frame = CGRectMake(imageV.right + 10, 0, self.shareUrlBack.width-imageV.right-10, kHEIGHT(43));
    }
    else
    {
       titleLabel.frame = CGRectMake(10, 0, self.shareUrlBack.width-10, kHEIGHT(43));
    }
//    titleLabel.text = [_info[@"share"] isEqualToString:@"1"]?(contentStr.length?[NSString stringWithFormat:@"%@",contentStr]:@"职场日记/分享"):([_info[@"share"] isEqualToString:@"0"]?(contentStr.length?[NSString stringWithFormat:@"%@：%@",firstStr,contentStr]:[NSString stringWithFormat:@"%@",firstStr]):(contentStr.length?[NSString stringWithFormat:@"%@：%@",firstStr,contentStr]:[NSString stringWithFormat:@"%@",firstStr]));
    titleLabel.font = kFONT(14);
    titleLabel.numberOfLines = 2;

    NSString * shareString = _info[@"share"];
    NSString * textString = nil;
    if ([shareString isEqualToString:@"1"]) {
        if (contentStr.length) {
            //textString = contentStr;
            NSArray * array = [contentStr componentsSeparatedByString:@":"];
            if (array.count >=2) {
                NSString * secondString = array[1];
                if (secondString.length) {
                    textString = contentStr;
                }
                else
                {
                    textString = [NSString stringWithFormat:@"%@",array[0]];
                }
            }
            else
            {
                textString = [NSString stringWithFormat:@"%@",array[0]];
            }
            /*
            NSString * secondString = array[1];
            if (secondString.length) {
                textString = contentStr;
            }
            else
            {
                textString = [NSString stringWithFormat:@"%@",array[0]];
            }
            */
           
        }
        else
        {
          textString = @"职场日记/分享";
        }
    }
    else if ([shareString isEqualToString:@"0"])
    {
        if (contentStr.length) {
            if (firstStr.length) {
                textString = [NSString stringWithFormat:@"%@：%@",firstStr,contentStr];
            }
            else
            {
                //textString = contentStr;
                NSArray * array = [contentStr componentsSeparatedByString:@":"];
                NSString * secondString = array[1];
                if (secondString.length) {
                    textString = contentStr;
                }
                else
                {
                    
                    textString = [NSString stringWithFormat:@"%@",array[0]];
                    NSArray * array = _info[@"url"];
                    if (array.count) {
                        NSString * firstString = array[0][@"small_address"];
                        if ([firstString hasSuffix:@".jpg"]||[firstString hasSuffix:@".png"]) {
                            textString = [contentStr stringByAppendingString:@"[图片]"];
                           // contentStr = @"[图片]";
                        }
                        if ([firstString hasSuffix:@".mp4"]) {
                          textString = [contentStr stringByAppendingString:@"[视频]"];
                           // contentStr = @"[视频]";
                        }
                    }
                }
                
            }
        }
        else
        {
            textString = firstStr;
        }
    }
    else
    {
        if (contentStr.length) {
            if (firstStr.length) {
               textString = [NSString stringWithFormat:@"%@：%@",firstStr,contentStr];
            }
            else
            {
               textString = contentStr;
            }
           
        }
        else
        {
            textString = firstStr;
        }
    }
    
    titleLabel.text = textString;

    [self.shareUrlBack addSubview:titleLabel];

}
- (void)setModel:(WPCollectionModel *)model
{
    _model = model;
    self.button.selected = model.selected;
    if (_isFromChat)
    {
      self.selectbtn.selected = model.selected;
    }
    
}
-(UIView*)personCard
{
    
    if (!_personCard) {
        _personCard = [[UIView alloc]init];
        _personCard.backgroundColor = RGB(235, 235, 235);
    }
    return _personCard;
//    if (!_personCard) {
//        if ([self.firstStr isEqualToString:@"8"]) {
//            self.personCard = [[UIView alloc]initWithFrame:CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(10), kHEIGHT(43))];
//            self.applyView = [[WPApplyView alloc]initWithFrame:CGRectMake(0, 0, _personCard.frame.size.width, _personCard.frame.size.height)];
//            [self.personCard addSubview:self.applyView];
//        }
//    }
//    return _personCard;
}
-(UIView*)shareUrlBack
{
    if (!_shareUrlBack) {
        _shareUrlBack = [[UIView alloc]init];
        _shareUrlBack.backgroundColor = RGB(235, 235, 235);
    }
    return _shareUrlBack;
}
-(UIView*)JobIntBackView
{
    if (!_JobIntBackView) {
        _JobIntBackView = [[UIView alloc]init];
        _JobIntBackView.backgroundColor = RGB(235, 235, 235);
    }
    return _JobIntBackView;
}
-(UIView*)muchView
{
    if (!_muchView) {
        _muchView = [[UIView alloc]init];
        _muchView.backgroundColor = RGB(235, 235, 235);
    }
    return _muchView;
}
-(UIView *)urlBackView
{
    if (!_urlBackView) {
        _urlBackView = [[UIView alloc]init];
        _urlBackView.backgroundColor = RGB(236, 235, 235);
    }
    return _urlBackView;
}
- (void)removeSubViews
{
    if ([self.selectbtn superview]) {
        [self.selectbtn removeFromSuperview];
        self.selectbtn = nil;
    }
    
    if ([self.shareUrlBack superview]) {
        [self.shareUrlBack removeFromSuperview];
        self.shareUrlBack = nil;
    }
    
    if ([self.urlBackView superview]) {
        [self.urlBackView removeFromSuperview];
        self.urlBackView = nil;
    }
    
    if ([self.personCard superview]) {
        [self.personCard removeFromSuperview];
        self.personCard = nil;
    }
    
    if ([self.applyBackView superview]) {
        [self.applyBackView removeFromSuperview];
        self.applyBackView = nil;
    }
    

    if ([self.bodyLabel superview]) {
        [self.bodyLabel removeFromSuperview];
        self.bodyLabel = nil;
    }
    if ([self.imagesView superview]) {
        [self.imagesView removeFromSuperview];
        self.imagesView = nil;
    }
    
    if ([self.JobIntBackView superview]) {
        [self.JobIntBackView removeFromSuperview];
        self.JobIntBackView = nil;
    }
    if ([self.muchView superview]) {
        [self.muchView removeFromSuperview];
        self.muchView = nil;
    }
}


-(UIView*)applyBackView
{
    if (!_applyBackView) {//!([self.firstStr isEqualToString:@"5"]||[self.firstStr isEqualToString:@"6"])  && ([self.secondStr isEqualToString:@"5"]||[self.secondStr isEqualToString:@"6"])
        if ([self.firstStr isEqualToString:@"5"]||[self.firstStr isEqualToString:@"6"]) {
            _applyBackView = [[UIView alloc]init];
            _applyBackView.backgroundColor = RGB(235, 235, 235);
            
//            self.applyBackView = [[UIView alloc]initWithFrame:CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-2*kHEIGHT(10)-left, kHEIGHT(43))];
//            self.applyView = [[WPApplyView alloc]initWithFrame:CGRectMake(0, 0, _applyBackView.frame.size.width, _applyBackView.frame.size.height)];
//            self.applyView.backgroundColor = RGB(235, 235, 235);
//            [self.applyBackView addSubview:self.applyView];
        }

//        self.applyBackView = [[UIView alloc]initWithFrame:CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(10), kHEIGHT(43))];
////        self.applyBackView.backgroundColor = [UIColor redColor];
//        self.applyView = [[WPApplyView alloc]initWithFrame:CGRectMake(0, 0, _applyBackView.frame.size.width, _applyBackView.frame.size.height)];
//        self.applyView.backgroundColor = [UIColor greenColor];
//        [self.applyBackView addSubview:self.applyView];
    }

    return _applyBackView;
}
//- (WPApplyView *)applyView
//{
//    if (!_applyView) {
//        
//        self.applyView = [[WPApplyView alloc]initWithFrame:CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(10), kHEIGHT(43))];
////        self.applyView.backgroundColor = [UIColor redColor];
//    }
//    return _applyView;
//}

- (UIView *)voiceView
{
    if (!_voiceView) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"shoucang-yuyin"] forState:UIControlStateNormal];
        button.frame = CGRectMake(left, 0, kHEIGHT(43), kHEIGHT(43));
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(43)+10, 0, 50, 38)];
        label.text = @"语音";
        label.font = kFONT(15);
    }
    return _voiceView;
}

- (void)setImagePhotoToImageViewWithImagePhoto:(NSArray *)imgPhoto
{
    
    if (imgPhoto.count < 1)return;
    int k = 3;
    if (imgPhoto.count == 4) {
        k = 2;
    }
    NSInteger i = 0;
    CGFloat width = photoWidth;
    NSString *classN = self.info[@"classN"];
    if ([classN isEqualToString:@"2"]) {
        width = videoWidth/3*4;
    }
    for (NSDictionary *dic in imgPhoto) {
        NSString *imageStr = dic[@"small_address"];
        if (imageStr.length < 1) {
            break;
        }
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((i%k)*(width+5), (i/k)*(width+5), width, width)];
        if ([classN isEqualToString:@"2"]) {
            image.frame = CGRectMake((i%k)*(width+5), (i/k)*(width+5), width, videoWidth);
        }
        
        
        image.userInteractionEnabled = YES;
        
        NSString *url = [NSString string];
        NSArray * iageArray = [imageStr componentsSeparatedByString:@":"];
        if ([iageArray[0] isEqualToString:@"http"]) {
            url = imageStr;
        }
        else
        {
            url = [NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr];
        }
        url = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
        NSArray * imageArray = [url componentsSeparatedByString:@"/"];
        NSString * lastStr = imageArray[imageArray.count-1];
        lastStr = [@"thumb_" stringByAppendingString:lastStr];
        NSMutableArray * muarray = [NSMutableArray array];
        [muarray addObjectsFromArray:imageArray];
        [muarray replaceObjectAtIndex:imageArray.count-1 withObject:lastStr];
        url = [muarray componentsJoinedByString:@"/"];
        
        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head_default"]];
        
        //从分享中收藏的视频
        NSArray * vdArray = self.info[@"url"];
        NSString * vdStr = [NSString stringWithFormat:@"%@",vdArray[0][@"small_address"]];
//        if ([vdStr hasSuffix:@".mp4"])
//        {
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//            [button setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
//             [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//            [button addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
//            [image addSubview:button];
//        }
        
        [self.imagesView addSubview:image];
        image.tag = i+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [image addGestureRecognizer:tap];
        
        if ([classN isEqualToString:@"2"]) {
            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            playBtn.frame = CGRectMake(0, 0, width, videoWidth);
            [playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
            [playBtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:playBtn];
//            [playBtn setBackgroundColor:[UIColor greenColor]];
        }
        i ++;
    }
    if (i == 0) {
        return;
    }
    self.CellHeight += kHEIGHT(10);
    BOOL num = i>=k;//i>k
    self.imagesView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), num?(width+5)*3:((i%k+1)*width+(i%k)*5), (i/k+1)*width+(i/k)*5);
    if ([classN isEqualToString:@"4"]) {
        NSString *string = self.info[@"content"];
        if (string.length > 0) {
            self.imagesView.frame = CGRectMake(kHEIGHT(10)+left, self.bodyLabel.bottom+kHEIGHT(12), num?(width+5)*3:((i%k+1)*width+(i%k)*5), ((i-1)/k+1)*width+((i-1)/k)*5);//(i/k+1)*width+(i/k)*5
        }
    }
//    self.imagesView.backgroundColor = [UIColor redColor];
    self.CellHeight += self.imagesView.height;
    
}

- (void)videoClick
{
    if (self.clickImageAndVideo) {
        self.clickImageAndVideo(self.indexpath);
    }
//    VideoBrowser *video = [[VideoBrowser alloc] init];
//    video.videoUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,[self.info[@"url"][0]objectForKey:@"small_address"]];
//    [video show];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
    if (self.clickImageAndVideo) {
        self.clickImageAndVideo(self.indexpath);
    }
//    NSLog(@"%ld",tap.view.tag);
//    NSInteger count = [self.info[@"url"] count];
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        NSString * string = [NSString stringWithFormat:@"%@",self.info[@"url"][i][@"small_address"]];
//        NSArray * array = [string componentsSeparatedByString:@"/"];
//        
//        NSString * string1 = [NSString stringWithFormat:@"%@",array[array.count-1]];
//        NSArray * array1 = [string1 componentsSeparatedByString:@"_"];
//        NSString *urlStr = [NSString string];
//        if (array1.count == 1)
//        {
//            urlStr = [NSString stringWithFormat:@"%@",self.info[@"url"][i][@"small_address"]];
//        }
//        else
//        {
//            NSMutableArray * muarray = [NSMutableArray array];
//            [muarray addObjectsFromArray:array1];
//            [muarray removeFirstObject];
//            
//            NSMutableArray * addArray= [NSMutableArray array];
//            for (int i = 0 ; i < 4; i++) {
//                [addArray addObject:array[i]];
//            }
//            [addArray addObject:muarray[0]];
//            urlStr = [addArray componentsJoinedByString:@"/"];
//        }
//       
//        NSString * url = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
//        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
//        photo.photoURL = [NSURL URLWithString:url];
//        UIImageView *imageV = (UIImageView *)[self.imagesView viewWithTag:i+1];
//        photo.sid = self.info[@"user_id"];
//        photo.toView = imageV;
//        [photos addObject:photo];
//    }
//    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//    // 缩放动画
//    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
//    photoBrowser.photos = photos;
//    photoBrowser.isNeedShow = YES;
//    // 当前选中的值
//    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tap.view.tag-1 inSection:0];
//    // 展示控制器
//    [photoBrowser showPickerVc:[self viewController]];
}

- (void)setContentToBodyLabelWithContent:(NSString *)content
{
    NSString *description1 = [content stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    
    
    if (content.length<1)return;
    self.CellHeight += kHEIGHT(10);
    CGSize size = [description3 getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)-left];
    
    CGSize normalSize = [@"蛋疼不疼" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    NSString *attributedText = description3;
    BOOL more = NO;
    if (size.height > normalSize.height *8) {//5
        size.height = normalSize.height *8 ;
        NSString *count = [self getCountWithString:description3];
        NSString *subStr = [description3 substringToIndex:count.integerValue - 3];
        attributedText = [NSString stringWithFormat:@"%@...",subStr];
        more = YES;
    }
    
    size = [attributedText getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)-left];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:attributedText];
//    NSArray *array = [content componentsSeparatedByString:@":"];
    if ([_info[@"classN"] isEqualToString:@"4"]) {
        NSString *string = [_info[@"share"] isEqualToString:@"1"]?@"职场日记：分享":@"职场日记";//array[0]
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, string.length)];
    }
//    if (array.count > 1) {
//        NSString *string = @"职场日记";//array[0]
//        [AttributedStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, string.length)];
    
//    }
    if (more) {
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(attributedText.length - 2, 2)];
    }
    if (_isFromChat)
    {
        self.bodyLabel.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left-20-kHEIGHT(10), size.height);
    }
    else
    {
       self.bodyLabel.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, size.height);
    }
//    self.bodyLabel.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(20)-left, size.height);
    self.bodyLabel.attributedText = AttributedStr;
    self.CellHeight += size.height;
}

- (NSString *)getCountWithString:(NSString *)string
{
    NSMutableAttributedString *stttribute = [[NSMutableAttributedString alloc] initWithString:string];
    [stttribute addAttribute:NSFontAttributeName value:kFONT(14) range:NSMakeRange(0, string.length)];
    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                        (stttribute));
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat w = SCREEN_WIDTH-kHEIGHT(20)-left;
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [stttribute length];
    int tempK = 0;
    while (start < length){
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        start += count;
        y -= normalSize.height;
        CFRelease(line);
        tempK++;
        if (tempK == 8) {//5
            NSString *count = [NSString stringWithFormat:@"%ld",start];
            return count;
        }
    }
    return 0;
}

- (void)setAdd_timeToTimeLabelWithAdd_Time:(NSString *)add_time
{
    NSArray *time = [add_time componentsSeparatedByString:@" "];
    CGSize size = [time[0] getSizeWithFont:FUCKFONT(10) Height:120];
//    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-size.width, self.titleLabel.top, size.width, size.height);
    if (_isFromChat)
    {
      self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-size.width-20-kHEIGHT(10), self.titleLabel.top, size.width, size.height);
    }
    else
    {
     self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-size.width, self.titleLabel.top, size.width, size.height);
    }
    
    
    self.timeLabel.text = time[0];
}

- (void)setCompanyToCompanyLabelWithCompany:(NSString *)company
{
    CGSize size = [company getSizeWithFont:FUCKFONT(10) Height:20];
    CGFloat width = SCREEN_WIDTH-self.positionLabel.right-8-self.timeLabel.width-kHEIGHT(10)-6-left;
    
    self.companyLabel.frame = CGRectMake(self.positionLabel.right+8, 0, width, size.height);
    self.companyLabel.bottom = self.titleLabel.bottom-2;
    self.companyLabel.text = company;
}

- (void)setPositionToPositionLabelWithPosition:(NSString *)position
{
    UIView *line = (UIView *)[self.contentView viewWithTag:1];
    CGSize size = [position getSizeWithFont:FUCKFONT(10) Height:20];
    self.positionLabel.text = position;
    self.positionLabel.frame = CGRectMake(self.titleLabel.right+6, 0, size.width, size.height);
    self.positionLabel.bottom = self.titleLabel.bottom-2;
    if (position.length) {
       line.frame = CGRectMake(0, 0, 0.5, size.height-2);
    }
    else
    {
      line.frame = CGRectMake(0, 0, 0, size.height-2);
    }
    
//    line.frame = CGRectMake(0, 0, 0.5, size.height-2);
    line.center = CGPointMake(self.positionLabel.right+4, self.positionLabel.top+size.height/2);
}

- (void)setImageToHeaderViewWithURL:(NSURL *)URL
{
    [self.headerView sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    self.headerView.frame = CGRectMake(kHEIGHT(10)+left, kHEIGHT(10), kHEIGHT(22),kHEIGHT(22));
}

- (void)setNameToTitleLabelWithName:(NSString *)name
{
    NSString * col4 = _info[@"col4"];
    NSArray *time = [_info[@"add_time"] componentsSeparatedByString:@" "];
    CGSize timeSize = [time[0] getSizeWithFont:FUCKFONT(10) Height:120];
    CGSize positionSize =  [_info[@"position"] getSizeWithFont:FUCKFONT(10) Height:20];
    CGSize companySize = [_info[@"companName"] getSizeWithFont:FUCKFONT(10) Height:20];
    CGSize size = [name getSizeWithFont:FUCKFONT(15) Height:20];
    CGFloat allWidth = self.headerView.right+10+kHEIGHT(10)+timeSize.width+positionSize.width+companySize.width+18+size.width;
    CGFloat labelWidth = 0;
    if (col4.length) {
        positionSize = CGSizeMake(0, 0);
        companySize = CGSizeMake( 0, 0);
    }
    
    
    if (allWidth>SCREEN_WIDTH) {
        labelWidth =  SCREEN_WIDTH-self.headerView.right-10-kHEIGHT(10)-timeSize.width-positionSize.width-companySize.width;
    }
    else
    {
        labelWidth = size.width;
    }
    
    
    self.titleLabel.text = name;
    self.titleLabel.frame = CGRectMake(self.headerView.right+10, self.headerView.top, labelWidth, size.height);
//    self.titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
//    self.titleLabel.center = CGPointMake(self.headerView.right+10+size.width/2, self.headerView.top+self.headerView.height/2);
}
- (UIImageView *)bottomLine
{
    if (!_bottomLine) {
        self.bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-8, SCREEN_WIDTH, 8)];
        self.bottomLine.image = [UIImage imageWithColor:RGB(235, 235, 235) size:CGSizeMake(SCREEN_WIDTH, 8)];
        
    }
    return _bottomLine;
}

- (UIButton *)headerView
{
    if (!_headerView) {
        self.headerView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerView.layer.cornerRadius = kHEIGHT(11);
        self.headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = kFONT(15);
    }
    return _titleLabel;
}

- (UILabel *)positionLabel
{
    if (!_positionLabel) {
        self.positionLabel = [[UILabel alloc]init];
        self.positionLabel.font = kFONT(10);
        self.positionLabel.textColor = RGB(127, 127, 127);
        UIView *line = [[UIView alloc]init];
        line.tag = 1;
        line.backgroundColor = RGB(127, 127, 127);
        [self.contentView addSubview:line];
    }
    return _positionLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        self.companyLabel = [[UILabel alloc]init];
        self.companyLabel.font = kFONT(10);
        self.companyLabel.textColor = RGB(127, 127, 127);
    }
    return _companyLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = kFONT(10);
        self.timeLabel.textColor = RGB(170, 170, 170);
    }
    return _timeLabel;
}


- (UIView *)imagesView
{
    if (!_imagesView) {
        self.imagesView = [[UIView alloc]init];
//        self.imagesView.backgroundColor = [UIColor redColor];
    }
    return _imagesView;
}

- (UILabel *)bodyLabel
{
    if (!_bodyLabel) {
        self.bodyLabel = [[UILabel alloc]init];
        self.bodyLabel.font = kFONT(14);
//        self.bodyLabel.textColor = [UIColor redColor];
        self.bodyLabel.numberOfLines = 0;
    }
    return _bodyLabel;
}

- (void)setCellHeight:(CGFloat)CellHeight
{
    _CellHeight = CellHeight;
//    self.bottomLine.top = CellHeight+kHEIGHT(10);
}

- (void)layoutSubviews
{
    self.bottomLine.top = self.height - 8;
    if (self.button.superview) {
        [self.button removeFromSuperview];
    }
    if (_select)
    {
        [self.contentView addSubview:self.button];
        self.button.frame = CGRectMake(0, 0, 38, self.height-8);
        self.applyView = [[WPApplyView alloc]initWithFrame:CGRectMake(kHEIGHT(10)+left, kHEIGHT(42), SCREEN_WIDTH-kHEIGHT(10), kHEIGHT(43))];
    }
    
    if (_isFromChat)
    {
        _selectbtn.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 30, 0,kHEIGHT(10)+30, self.height);
//        self.timeLabel.left = self.positionLabel.right+8-20-kHEIGHT(10);
    }
}

- (CGFloat)getCellHeight
{
    return _CellHeight;
}

- (void)clearSubViews
{
    self.imagesView.frame = CGRectMake(0, 0, 0, 0);
    [self.imagesView removeAllSubviews];
    
    self.bodyLabel.text = @"";
    self.bodyLabel.frame = CGRectMake(0 , 0, 0, 0);
//    [self.bodyLabel removeAllSubviews];
    
    
//    self.applyView.frame = CGRectMake(0, 0, 0, 0);
//    [self.applyView removeAllSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
