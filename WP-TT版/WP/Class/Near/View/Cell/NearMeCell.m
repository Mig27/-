//
//  NearMeCell.m
//  WP
//
//  Created by CBCCBC on 15/9/25.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "NearMeCell.h"
#import "SPButton.h"

@interface NearMeCell ()
@property (strong, nonatomic) UILabel *timeLabel1;
@end

@implementation NearMeCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:[UIColor clearColor]]];
        
        _headImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(37), kHEIGHT(37))];
        _headImageView1.layer.cornerRadius = 5;
        _headImageView1.userInteractionEnabled = YES;
        _headImageView1.clipsToBounds = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImageClick)];
        [_headImageView1 addGestureRecognizer:tap];
        
        [self addSubview:_headImageView1];
        
        _nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, kHEIGHT(10), SCREEN_WIDTH-_headImageView1.right-10-10, 20)];
        
        _nameLabel1.font = kFONT(15);
        _nameLabel1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNameClick)];
        [_nameLabel1 addGestureRecognizer:tap1];
        [self addSubview:_nameLabel1];
        
        _positionLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _headImageView1.bottom-15-3, 120, 15)];
        _positionLabel1.font = kFONT(12);
        _positionLabel1.textColor = RGB(127, 127, 127);
        [self addSubview:_positionLabel1];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(_positionLabel1.right+10, _positionLabel1.top, 0.5, 15)];
        _line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:_line];
        
        _companyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_line.right+10, _headImageView1.bottom-15-3, SCREEN_WIDTH-_line.right-10-10, 15)];
        _companyLabel1.font = kFONT(12);
        _companyLabel1.textColor = RGB(127, 127, 127);
        [self addSubview:_companyLabel1];
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _headImageView1.bottom, SCREEN_WIDTH-_headImageView1.right-10-10, 0.5)];
        line1.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line1];
        
        _contentImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line1.bottom+kHEIGHT(10), kHEIGHT(43), kHEIGHT(43))];
        [self addSubview:_contentImageView1];
        
        _contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView1.right+10, line1.bottom+10, SCREEN_WIDTH-_contentImageView1.right-10-10, 20)];
        _contentLabel1.font = kFONT(15);
        [self addSubview:_contentLabel1];
        
        _contentDetailLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView1.right+10, _contentImageView1.bottom-20, SCREEN_WIDTH-_contentImageView1.right-10-10, 20)];
        _contentDetailLabel1.font = kFONT(12);
        _contentDetailLabel1.textColor = RGB(127, 127, 127);
        [self addSubview:_contentDetailLabel1];
        /*
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.titleLabel.font = kFONT(14);
        //[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //button.frame = CGRectMake(_headImageView1.right+10, line1.bottom+10, SCREEN_WIDTH-_headImageView1.right-10, 80);
        //[button addTarget:self action:@selector(interViewClick:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:button];
        */
        UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _contentImageView1.bottom+kHEIGHT(10), SCREEN_WIDTH-_headImageView1.right-10, 0.5)];
        line4.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line4];
        
        _timeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line4.bottom+10, SCREEN_WIDTH-_headImageView1.right-10-10, 15)];
        _timeLabel1.font = kFONT(12);
        _timeLabel1.textColor = RGB(127, 127, 127);
        [self addSubview:_timeLabel1];
        
//        self.deleteBtn = [[SPButton1 alloc]initWithFrame:CGRectMake(_timeLabel1.right+5, line4.bottom+10, kHEIGHT(25), kHEIGHT(25)) title:nil ImageName:@"small_rubish" Target:self Action:@selector(operationClick:)];
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.tag = 20;
        self.deleteBtn.frame = CGRectMake(0, 0, kHEIGHT(25), kHEIGHT(25));
        self.deleteBtn.center = CGPointMake(_timeLabel1.right+5+kHEIGHT(25)/2, line4.bottom+10+15/2);
        [self addSubview:self.deleteBtn];
        /*
//        UILabel *sysMess = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line2.bottom, 120, kHEIGHT(36))];
//        sysMess.text = @"系统信息";
//        //sysMess.textColor = RGB(153, 153, 153);
//        sysMess.font = kFONT(12);
////        sysMess.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:sysMess];
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-8-kHEIGHT(10), line2.bottom+(kHEIGHT(36)-14)/2, 8, 14)];
//        imageView.image = [UIImage imageNamed:@"jinru"];
//        [self addSubview:imageView];
//        
//        _sysButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sysButton1.frame = CGRectMake(_headImageView1.right+10, line2.bottom, imageView.left-_headImageView1.right-10-6, kHEIGHT(36));
////        _sysButton1.backgroundColor = [UIColor darkGrayColor];
//        _sysButton1.titleLabel.font = kFONT(12);
//        [_sysButton1 setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        [_sysButton1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [self addSubview:_sysButton1];
        
//        UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, sysMess.bottom, SCREEN_WIDTH-_headImageView1.right-10-10, 0.5)];
//        line3.backgroundColor = RGB(226, 226, 226);
//        [self addSubview:line3];
        */
        /**     删除 修改 刷新 已上架 等功能按键
         
        _delButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36)) title:@"删除" ImageName:@"shanchu_1" Target:self Action:@selector(operationClick:)];
        [_delButton1 setContentLabelSize:@"删除" font:FUCKFONT(12)];
        [_delButton1 setContentAlignment:SPButtonContentAlignmentLeft];
        _delButton1.tag = 20;
        [self addSubview:_delButton1];
        
        _editButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(_delButton1.right, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36)) title:@"修改" ImageName:@"xiugai_1" Target:self Action:@selector(operationClick:)];
        [_editButton1 setContentLabelSize:@"修改" font:FUCKFONT(12)];
        [_editButton1 setContentAlignment:SPButtonContentAlignmentLeft];
        _editButton1.tag = 21;
        [self addSubview:_editButton1];
        
        _refButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(_editButton1.right, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36)) title:@"刷新" ImageName:@"shuaxin" Target:self Action:@selector(operationClick:)];
        [_refButton1 setContentLabelSize:@"刷新" font:FUCKFONT(12)];
        [_refButton1 setContentAlignment:SPButtonContentAlignmentLeft];
        _refButton1.tag = 22;
        [self addSubview:_refButton1];
        
         
        _upButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(_downButton1.right, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/5, kHEIGHT(36)) title:@"推广" ImageName:@"tuiguang" Target:self Action:@selector(operationClick:)];
        [_upButton1 setContentLabelSize:@"推广" font:FUCKFONT(12)];
        [_upButton1 setContentAlignment:SPButtonContentAlignmentLeft];
        _upButton1.tag = 24;
        [self addSubview:_upButton1];
        */// 删除 20 修改 21 刷新 22 推广 24 已上架 等功能按键
        CGFloat downButton1Height = (SCREEN_WIDTH-_headImageView1.right-10)/4;
//         _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-downButton1Height-kHEIGHT(12), 0, downButton1Height, kHEIGHT(20))];
//        _signLabel.center = CGPointMake(SCREEN_WIDTH - downButton1Height/2, line4.bottom+10+15/2);
//        _signLabel.text = @"已上架";
//        _signLabel.textAlignment = NSTextAlignmentRight;
//        _signLabel.font = kFONT(12);
//        _signLabel.textColor = RGB(127, 127, 127);
//        [self addSubview:_signLabel];
        
        _downButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(0, 0, downButton1Height, kHEIGHT(20)) title:@"已上架" ImageName:nil Target:self Action:@selector(operationClick:)];
        [_downButton1 setContentLabelSize:@"已上架" font:FUCKFONT(12)];
        [_downButton1 setContentAlignment:SPButtonContentAlignmentLeft];
        _downButton1.tag = 23;
//        [_downButton1 setContentLabelTextColor:[UIColor redColor]];
//        [_downButton1 titleColor:[UIColor grayColor]];
        _downButton1.center = CGPointMake(SCREEN_WIDTH - downButton1Height/2, line4.bottom+10+15/2);
        [self addSubview:_downButton1];

        /*
        
//        _broweLabel1 = [[UIButton alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line4.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36))];
//        _broweLabel1.tag = 24;
//        _broweLabel1.titleLabel.font = kFONT(12);
//        [_broweLabel1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_broweLabel1 setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//        [_broweLabel1 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
//        [_broweLabel1 addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_broweLabel1];
//        
//        _shareLabel = [[UIButton alloc]initWithFrame:CGRectMake(_broweLabel1.right, line4.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36))];
//        _shareLabel.tag = 25;
//        _shareLabel.titleLabel.font = kFONT(12);
//        [_shareLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_shareLabel setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//        [_shareLabel setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
//        [_shareLabel addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_shareLabel];
//        
//        _messageLabel1 = [[UIButton alloc]initWithFrame:CGRectMake(_shareLabel.right, line4.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36))];
//        _messageLabel1.tag = 26;
//        _messageLabel1.titleLabel.font = kFONT(12);
//        [_messageLabel1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_messageLabel1 setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//        [_messageLabel1 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
//        [_messageLabel1 addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_messageLabel1];
//        
//        //UILabel *lineMess = [[UILabel alloc]initWithFrame:CGRectMake(_messageLabel1.right, line4.bottom+(kHEIGHT(36)-15)/2, 0.5, 15)];
//        //lineMess.backgroundColor = RGB(226, 226, 226);
//        //[self addSubview:lineMess];
//        
//        _applyLabel1 = [[UIButton alloc]initWithFrame:CGRectMake(_messageLabel1.right, line4.bottom, (SCREEN_WIDTH-_headImageView1.right-10)/4, kHEIGHT(36))];
//        _applyLabel1.tag = 27;
//        _applyLabel1.titleLabel.font = kFONT(12);
//        [_applyLabel1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_applyLabel1 setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//        [_applyLabel1 setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
//        [_applyLabel1 addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_applyLabel1];
        
        //UILabel *lineApply = [[UILabel alloc]initWithFrame:CGRectMake(_applyLabel1.right, line4.bottom+(kHEIGHT(36)-15)/2, 0.5, 15)];
        //lineApply.backgroundColor = RGB(226, 226, 226);
        //[self addSubview:lineApply];
        */
       UILabel*line5 = [[UILabel alloc]initWithFrame:CGRectMake(0, line4.bottom+35, SCREEN_WIDTH, 8)];
        line5.backgroundColor = RGB(235, 235, 235);
        [self addSubview:line5];
        
    }
    return self;
}
#pragma mark 点击头像
-(void)clickHeadImageClick
{
    if (self.clickHeadImage) {
        self.clickHeadImage();
    }
}
#pragma mark 点击名称
-(void)clickNameClick
{
    if (self.clickName) {
        self.clickName();
    }
}
- (void)setTime:(NSString *)time
{
    _time = time;
    _timeLabel1.text = time;
    CGSize size = [time getSizeWithFont:FUCKFONT(12) Height:15];
    _timeLabel1.frame = CGRectMake(_headImageView1.right+10, _timeLabel1.origin.y, size.width, 15);
    self.deleteBtn.center = CGPointMake(_timeLabel1.right + kHEIGHT(25)/2+5, _timeLabel1.origin.y+15/2);
}

- (void)operationClick:(UIButton *)sender{
//    NSLog(@"个人操作");
    if (self.NearOperationBlock) {
        self.NearOperationBlock(self.tag-10,sender.tag-20);
    }
}

- (void)interViewClick:(UIButton *)sender{
    if (self.NearMeBlock) {
        self.NearMeBlock(self.tag-10);
    }
}

+ (CGFloat)cellHeight{
    
    CGFloat height = 3*kHEIGHT(10)+kHEIGHT(37)+kHEIGHT(43)+35+8;//kHEIGHT(10)+kHEIGHT(37)+10+kHEIGHT(43)+10+15+10+kHEIGHT(36)+9
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
