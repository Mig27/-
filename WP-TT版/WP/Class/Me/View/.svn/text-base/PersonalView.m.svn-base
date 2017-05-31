//
//  PersonalView.m
//  test
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "PersonalView.h"

#import "UIButton+WebCache.h"
#import "MacroDefinition.h"
#import "UIButton+Extension.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "THLabel.h"
#import "BaseModel.h"
#import "WPDownLoadVideo.h"
//#import "RACEXTScope.h"//﻿

#define ItemWidth 73

@implementation PersonalModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"nameStr":@"user_name",
             @"nicknameStr":@"nick_name",
             @"WPidStr":@"wp_id",
             @"headImageStr":@"avatar",
             @"attentionCount":@"attention",
             @"friendsCount":@"friend",
             @"fansCount":@"fans",
             @"photoWallArr":@"Photolist"
             };
}

+(NSDictionary *)objectClassInArray
{
    return @{
             @"photoWallArr":[Pohotolist class]
             };
}

@end

@interface PersonalView ()

@property (strong, nonatomic) UIScrollView *scrollView;/**< 照片墙 */
//@property (strong, nonatomic) PersonalButton *backgroundImageBtn;
//@property (strong, nonatomic) PersonalButton *headImageBtn;
@property (strong, nonatomic) UIButton *editBtn;

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (strong, nonatomic) THLabel *nameLabel;
@property (strong, nonatomic) THLabel *wpLabel;
@property (strong, nonatomic) UILabel *attentionLabel;
@property (strong, nonatomic) UILabel *fansLabel;
@property (strong, nonatomic) UILabel *friendsLabel;

@property (strong, nonatomic) UIView *photosView;
@property (strong, nonatomic) UIView *labelView;


@property (strong, nonatomic) UILabel *positionLabel;
@property (strong, nonatomic) UILabel *companyLabel;

@property (strong, nonatomic) UIView *line;

@end

@implementation PersonalView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initWithSubViews];
    }
    return self;
}

#pragma mark - 初始化控件
-(void)initWithSubViews
{
    ////背景图
    //UIButton *backgroundImageBtn = [UIButton creatUIButtonWithFrame:CGRectMake(0, 0, self.width, GetHeight(SCREEN_WIDTH)) ImageName:NULLNAME Target:self Action:@selector(click:)];
    //backgroundImageBtn.tag = 10;
    //[self addSubview:backgroundImageBtn];
    
    //_backgroundImageView = [[UIImageView alloc]initWithFrame:backgroundImageBtn.frame];
    //_backgroundImageView.image = [UIImage imageNamed:@"back_default"];
    //[self addSubview:_backgroundImageView];
    
    //头像
    //UIButton *headImageBtn = [UIButton creatUIButtonWithFrame:CGRectMake(10, kHEIGHT(10), kHEIGHT(54), kHEIGHT(54)) ImageName:NULLNAME Target:self Action:@selector(click:)];
    //headImageBtn.tag = 20;
    //[self addSubview:headImageBtn];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * position = [defaults objectForKey:@"personalPosition"];
    NSString * company = [defaults objectForKey:@"personalCompany"];
    NSString * name = [defaults objectForKey:@"personalName"];
    NSString * imageStr = [defaults objectForKey:@"personalImage"];
//    _nameLabel.text = name;
//    _wpLabel.text = [NSString stringWithFormat:@"%@ | %@",position,company];
//    NSData * data = [self imageData:imageStr];
//    _headImageView.image = [UIImage imageWithData:data];
    
    
    
    UIButton *backview = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, kHEIGHT(72))];
    backview.backgroundColor = [UIColor whiteColor];
    backview.tag = 30;
    [backview setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    [backview addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backview];
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(14), kHEIGHT(10), kHEIGHT(54), kHEIGHT(54)) ];
    _headImageView.image = [UIImage imageNamed:@"head_default"];
    _headImageView.layer.cornerRadius = 5;
    _headImageView.clipsToBounds = YES;
    NSData * data = [self imageData:imageStr];
    if (data) {
       _headImageView.image = [UIImage imageWithData:data];
    }
    [backview addSubview:_headImageView];
    
    ////编辑
    //_editBtn = [UIButton creatUIButtonWithFrame:CGRectMake(backgroundImageBtn.right-10-40, backgroundImageBtn.height-10-20, 40, 20) BackgroundColor:RGBA(0, 0, 0, 0.5) Title:@"编辑 >" TitleColor:[UIColor whiteColor] Font:12 Target:self Action:@selector(click:)];
    //_editBtn.layer.cornerRadius = 2;
    //_editBtn.tag = 30;
    //_editBtn.hidden = !self.isAllowEdit;
    //[self addSubview:_editBtn];
    
    //名称
//    CGFloat width = SCREEN_WIDTH-10-8-_headImageView.right-kHEIGHT(10);
    _nameLabel = [[THLabel alloc]init];//WithFrame:CGRectMake(_headImageView.right+kHEIGHT(10), _headImageView.center.y-18, 0, 18)
    _nameLabel.text = @"名称：N/A";
    _nameLabel.font = kFONT(15);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.text = name;
    [backview addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).with.offset(kHEIGHT(10));
        make.bottom.equalTo(_headImageView.mas_centerY).with.offset(-4);
    }];
    
    //微聘号
    _wpLabel = [[THLabel alloc]init]; //WithFrame:CGRectMake(_headImageView.right+kHEIGHT(10), _nameLabel.bottom+8, width, 15)
    _wpLabel.text = @"快聘号：N/A";
    _wpLabel.text = [NSString stringWithFormat:@"%@ | %@",position,company];
    _wpLabel.textColor = RGB(127, 127, 127);
    _wpLabel.font = kFONT(12);
    [backview addSubview:_wpLabel];
    [_wpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(8);
    }];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, _headImageView.center.y-7, 8, 14)];
    imageView.image = [UIImage imageNamed:@"jinru"];
    [backview addSubview:imageView];
    
    
    self.positionLabel = [[UILabel alloc] init];
    self.positionLabel.font = kFONT(12);
    self.positionLabel.textColor = RGB(127, 127, 127);
    [backview addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(8);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    
    self.line = [[UIView alloc] init];
    self.line .backgroundColor = RGB(226, 226, 226);
    [backview addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positionLabel.mas_right).with.offset(6);
        make.centerY.equalTo(self.positionLabel);
        make.height.equalTo(@(12));
        make.width.equalTo(@0.5);
    }];
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.font = kFONT(12);
    self.companyLabel.textColor = RGB(127, 127, 127);
    self.companyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [backview addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).with.offset(6);
        make.centerY.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(imageView.mas_right).with.offset(-8);
    }];

    
    
    
    //_photosView = [[UIView alloc]initWithFrame:CGRectMake(0, backgroundImageBtn.bottom+5, SCREEN_WIDTH, 73)];
    //[self addSubview:_photosView];
    
    ////照片墙
    //_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10-10-10, 73)];
    //_scrollView.backgroundColor = [UIColor whiteColor];
    //_scrollView.showsHorizontalScrollIndicator = NO;
    //[_photosView addSubview:_scrollView];
    
    ////照片墙翻页
    //UIButton *photosScrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-10-10-10, 0, 30, 73) ImageName:@"common_icon_arrow" Target:self Action:@selector(click:)];
    //photosScrollBtn.backgroundColor = [UIColor whiteColor];
    //photosScrollBtn.tag = 60;
    //[_photosView addSubview:photosScrollBtn];
    
    //用户关系
    _attentionLabel = [[UILabel alloc]init];
    _fansLabel = [[UILabel alloc]init];
    _friendsLabel = [[UILabel alloc]init];
    
    _labelView = [[UIView alloc]initWithFrame:CGRectMake(0, backview.bottom, SCREEN_WIDTH, kHEIGHT(43))];
    [self addSubview:_labelView];

    //NSArray *titleArr = @[@"好友",@"关注",@"粉丝"];
    //NSArray *labels = @[_attentionLabel,_fansLabel,_friendsLabel];
    //for (int i = 0; i < 3; i++) {
        
        //UIButton *button = [UIButton creatUIButtonWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, kHEIGHT(43)) ImageName:NULLNAME Target:self Action:@selector(click:)];
        //[button setImage:[UIImage imageNamed:@"white_background"] forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
        //button.tag = 50+i;
        
        //[_labelView addSubview:button];
        ////用户关系数量
        //UILabel *label = labels[i];
        //label.frame = button.frame;
        //label.font = kFONT(15);
        //label.text = [NSString stringWithFormat:@"%@ ：%@",titleArr[i],@"N/A"];
        //label.tag = 70+i;
        //label.textAlignment = NSTextAlignmentCenter;
        //[_labelView addSubview:label];
        
        //if (i!=0) {
            //UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, kHEIGHT(43)/2-7.5, 0.5, 15)];
            //line.backgroundColor = RGB(226, 226, 226);
            //[_labelView addSubview:line];
        //}
    //}
    
    //UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    //line.backgroundColor = RGB(226, 226, 226);
    //[_labelView addSubview:line];
}
-(void)setHidePosition:(BOOL)hidePosition
{
    if (hidePosition) {
        self.positionLabel.hidden = YES;
        self.companyLabel.hidden = YES;
        self.line.hidden = YES;
    }
    else
    {
        self.positionLabel.hidden = NO;
        self.companyLabel.hidden = NO;
        self.line.hidden = NO;
    }
}
#pragma mark - 点击事件
-(void)click:(UIButton *)sender
{
    
    switch (sender.tag/10) {
        case 1:/**< 背景图 */
//            if (self.photoWall) {
//                self.photoWall(@[_model.backgroundImageStr],0);
            //[self showBigImageArray:@[_model.backgroundImageStr] number:0 view:self.backgroundImageView];
//            }
            break;
        case 2:/**< 头像 */
//            if (self.photoWall) {
//                self.photoWall(@[_model.headImageStr],0);
//            }
            [self showBigImageArray:@[_model.headImageStr] number:0 view:self.headImageView];
            break;
        case 3:/**< 编辑 */
            if (self.editPersonalInfo) {
                self.editPersonalInfo();
            }
            break;
        case 4:/**< 照片墙 */
//            if (self.photoWall) {
//                self.photoWall(_model.photoWallArr,sender.tag%10);
//            }
            [self showBigImageArray:_model.photoWallArr number:sender.tag%10 view:self.scrollView];
            break;
        case 5:/**< 用户关系 */
            if (self.personalConenction) {
                self.personalConenction(sender.tag%10);
            }
            break;
        case 6:/**< 照片墙滚动 */
            if (self.photoWallDetail) {
                self.photoWallDetail();
            }
            break;
        default:
            break;
    }
}
-(void)scrollAnimation
{
    if (_scrollView.contentSize.width > _scrollView.width) {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width-_scrollView.width, 0);
        }];
    }
}

-(void)showBigImageArray:(NSArray *)photos number:(NSInteger)number view:(UIView *)view
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < photos.count; i++) {/**< 头像或背景图 */
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([photos[i] isKindOfClass:[NSString class]]) {
            photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:photos[i]]];
            photo.srcImageView = (UIImageView *)view;
            [arr addObject:photo];
        }else{/**< 照片墙 */
            Pohotolist *model = photos[i];
            photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.original_path]];
            photo.srcImageView = (UIImageView *)[view viewWithTag:80+i];
            [arr addObject:photo];
        }
    }
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.currentPhotoIndex = number;
    brower.photos = arr;
    [brower show];
    
}
#pragma mark - 刷新数据
-(void)reloadData
{
    if (_model.photoWallArr.count != 0) {
    
        Pohotolist *photoModel = _model.photoWallArr[0];
        NSData * data = [self imageData:[IPADDRESS stringByAppendingString:photoModel.thumb_path]];
        if (data) {
           _headImageView.image = [UIImage imageWithData:data];
        }
        else
        {
            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
            [down downLoadImage:[IPADDRESS stringByAppendingString:photoModel.thumb_path] success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   _headImageView.image = [UIImage imageWithData:response];
                });
            } failed:^(NSError *error) {
                _headImageView.image = [UIImage imageNamed:@"head_default"];
            }];
        }
        
//        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:photoModel.thumb_path]] placeholderImage:[UIImage imageNamed:@"head_default"]];
    }
    
    if ([_model.nicknameStr isEqualToString:@""]) {
        _nameLabel.text = _model.nameStr;
    }else{
        _nameLabel.text = _model.nicknameStr; // 名称两个字去掉
    }
    _wpLabel.text = [NSString stringWithFormat:@"%@ | %@",_model.position,_model.company];
    
    self.positionLabel.text = _model.position;
    self.companyLabel.text = _model.company;
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //将数据保存
    if (_model)
    {
        [defaults setObject:_model.position forKey:@"personalPosition"];
        [defaults setObject:_model.company forKey:@"personalCompany"];
        [defaults setObject:_model.nicknameStr.length?_model.nicknameStr:_model.nameStr forKey:@"personalName"];
        Pohotolist *photoModel = _model.photoWallArr[0];
        NSString * imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,photoModel.thumb_path];
        NSData * data = [self imageData:imageStr];
        if (!data) {
            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [down downLoadImage:imageStr success:^(id response) {
                } failed:^(NSError *error) {
                }];
            });
        }
        [defaults setObject:[NSString stringWithFormat:@"%@%@",IPADDRESS,photoModel.thumb_path] forKey:@"personalImage"];
        
    }
    else
    {
        NSString * position = [defaults objectForKey:@"personalPosition"];
        NSString * company = [defaults objectForKey:@"personalCompany"];
        NSString * name = [defaults objectForKey:@"personalName"];
        NSString * imageStr = [defaults objectForKey:@"personalImage"];
         _nameLabel.text = name;
        _wpLabel.text = [NSString stringWithFormat:@"%@ | %@",position,company];
        NSData * data = [self imageData:imageStr];
        _headImageView.image = [UIImage imageWithData:data];
    }
    
    
    
    
    _attentionLabel.text = [NSString stringWithFormat:@"好友：%@",_model.friendsCount];
    _fansLabel.text = [NSString stringWithFormat:@"关注：%@",_model.attentionCount];
    _friendsLabel.text = [NSString stringWithFormat:@"粉丝：%@",_model.fansCount];
}
-(NSData*)imageData:(NSString*)imageStr
{
    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
@end
