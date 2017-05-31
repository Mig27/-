//
//  NearPersonalCell.m
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "NearPersonalCell.h"

@implementation NearPersonalCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(37), kHEIGHT(37))];
        _headImageView1.layer.cornerRadius = 5;
        _headImageView1.clipsToBounds = YES;
        _headImageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView)];
        [_headImageView1 addGestureRecognizer:tap];
        
        
        [self addSubview:_headImageView1];
        
        _nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, kHEIGHT(10), SCREEN_WIDTH-_headImageView1.right-kHEIGHT(10)-kHEIGHT(10), 20)];
        _nameLabel1.font = kFONT(15);
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView)];
        _nameLabel1.userInteractionEnabled = YES;
        [_nameLabel1 addGestureRecognizer:tap1];
        [self addSubview:_nameLabel1];
        
        _positionLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _headImageView1.bottom-15-3, 120, 15)];
        _positionLabel1.font = kFONT(12);
        _positionLabel1.textColor = RGB(153, 153, 153);
        _positionLabel1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverClick)];
        [_positionLabel1 addGestureRecognizer:tap2];
        [self addSubview:_positionLabel1];
        
        //关注功能取消
//        _attentionBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        _attentionBtn1.frame = CGRectMake(SCREEN_WIDTH-50-kHEIGHT(10), kHEIGHT(10), 50, 20);
//        _attentionBtn1.layer.cornerRadius = 5;
//        _attentionBtn1.layer.masksToBounds = YES;
//        _attentionBtn1.layer.borderWidth = 0.5;
//        _attentionBtn1.layer.borderColor = RGB(226, 226, 226).CGColor;
//        _attentionBtn1.titleLabel.font = kFONT(12);
//        [_attentionBtn1 setTitle:@"+关注" forState:UIControlStateNormal];
//        [_attentionBtn1 setTitleColor:RGB(90, 118, 172) forState:UIControlStateNormal];
//        [_attentionBtn1 addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_attentionBtn1];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(_positionLabel1.right+10, _positionLabel1.top, 0.5, 15)];
        _line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:_line];
        
        _companyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_line.right+10, _headImageView1.bottom-15-3, SCREEN_WIDTH-_line.right-10-kHEIGHT(10), 15)];
        _companyLabel1.font = kFONT(12);
        _companyLabel1.textColor = RGB(153, 153, 153);
        _companyLabel1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverClick)];
        [_companyLabel1 addGestureRecognizer:tap3];
        [self addSubview:_companyLabel1];
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _headImageView1.bottom, SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10), 0.5)  ];
        line1.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line1];
        
        // 透明遮罩按钮  点击进入个人资料 而且只有好友非好友的却别
        UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        self.topCover = cover;
        [self addSubview:cover];
//        cover.backgroundColor = [UIColor redColor];
        cover.frame = CGRectMake(_nameLabel1.left+80, 0, SCREEN_WIDTH-_nameLabel1.left-80, _headImageView1.height);
//        [self.topCover mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView);
//            make.height.equalTo(_headImageView1);
//            make.centerY.equalTo(_headImageView1);
//            make.width.equalTo(@(SCREEN_WIDTH));
//        }];
        
        
        _contentImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line1.bottom+10, kHEIGHT(43), kHEIGHT(43))];
        [self addSubview:_contentImageView1];
        
        _contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView1.right+10, line1.bottom+10, SCREEN_WIDTH-_contentImageView1.right-10-kHEIGHT(10)-20, 20)];
        _contentLabel1.font = kFONT(15);
        [self addSubview:_contentLabel1];
        
        _contentDetailLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView1.right+10, _contentLabel1.bottom+10, SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10), 20)];
        _contentDetailLabel1.font = kFONT(12);
        _contentDetailLabel1.textColor = RGB(153, 153, 153);
        [self addSubview:_contentDetailLabel1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, line1.bottom+10, SCREEN_WIDTH, 80);//_headImageView1.right+10//-_headImageView1.right-10
        [button addTarget:self action:@selector(interViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, _contentLabel1.bottom, 8, 14)];
        imageView.image = [UIImage imageNamed:@"jinru"];
        [self addSubview:imageView];
        
        _timeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _contentImageView1.bottom+10, SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10), 15)];
        _timeLabel1.textColor = RGB(170, 170, 170);
        _timeLabel1.font = kFONT(12);
        [self addSubview:_timeLabel1];
        
        //UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, _timeLabel1.bottom+10, SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10), 0.5)];
        //line2.backgroundColor = RGB(226, 226, 226);
        //[self addSubview:line2];
        
        //UILabel *sysMess = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line2.bottom, 120, kHEIGHT(36))];
        //sysMess.text = @"系统信息";
        //sysMess.textColor = RGB(153, 153, 153);
        //sysMess.font = kFONT(12);
        //[self addSubview:sysMess];
        
        //_sysButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        //_sysButton1.frame = CGRectMake(_headImageView1.right+10, line2.bottom, imageView.left-_headImageView1.right-10-6, kHEIGHT(36));
////        _sysButton1.backgroundColor = [UIColor redColor];
        //_sysButton1.titleLabel.font = kFONT(12);
        //[_sysButton1 setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        //[_sysButton1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        //[self addSubview:_sysButton1];
        
        //UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, sysMess.bottom, SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10), 0.5)  ];
        //line3.backgroundColor = RGB(226, 226, 226);
        //[self addSubview:line3];
        
        //_messageLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView1.right+10, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10))/3, kHEIGHT(36))];
        //_messageLabel1.font = kFONT(12);
        //[self addSubview:_messageLabel1];
        
        //UILabel *lineMess = [[UILabel alloc]initWithFrame:CGRectMake(_messageLabel1.right, line3.bottom+(kHEIGHT(36)-15)/2, 0.5, 15)];
        //lineMess.backgroundColor = RGB(226, 226, 226);
        //[self addSubview:lineMess];
        //_applyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_messageLabel1.right, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10))/3, kHEIGHT(36))];
        //_applyLabel1.font = kFONT(12);
        //_applyLabel1.textAlignment = NSTextAlignmentCenter;
        //[self addSubview:_applyLabel1];
        
        //UILabel *lineApply = [[UILabel alloc]initWithFrame:CGRectMake(_applyLabel1.right, line3.bottom+(kHEIGHT(36)-15)/2, 0.5, 15)];
        //lineApply.backgroundColor = RGB(226, 226, 226);
        //[self addSubview:lineApply];
        
        //_broweLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_applyLabel1.right, line3.bottom, (SCREEN_WIDTH-_headImageView1.right-10-kHEIGHT(10))/3, kHEIGHT(36))];
        //_broweLabel1.font = kFONT(12);
        //_broweLabel1.textAlignment = NSTextAlignmentRight;
        //[self addSubview:_broweLabel1];
        
        UILabel *line5 = [[UILabel alloc]initWithFrame:CGRectMake(0, _timeLabel1.bottom+kListEdge, SCREEN_WIDTH, kHEIGHT(6))];
        line5.backgroundColor = RGB(235, 235, 235);
        [self addSubview:line5];
    }
    return self;
}
-(void)clickImageView
{
   self.coverClickBlock();
}
- (void)interViewClick:(UIButton *)sender{
    if (self.NearPersonalBlock) {
        self.NearPersonalBlock(self.tag-10);
    }
}

+ (CGFloat)cellHeight{
    CGFloat height = kHEIGHT(10)+kHEIGHT(37)+10+kHEIGHT(43)+10+15+10+kHEIGHT(6);
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.backgroundColor = [UIColor whiteColor];
}

-(void)coverClick{
    if (self.clickDetail) {
        self.clickDetail(self.indexPath);
    }
}

- (void)attentionClick:(UIButton *)sender{
    if (self.attentionBlock) {
        self.attentionBlock();
    }
}

@end
