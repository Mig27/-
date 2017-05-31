//
//  WPSelfResumeListCell.m
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPSelfResumeListCell.h"
#import "SPButton1.h"


@implementation WPSelfResumeListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:[UIColor clearColor]]];
        UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43)+kHEIGHT(10)+10)];
        [backbutton setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [backbutton addTarget:self action:@selector(fuckTheCompanyForever) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backbutton];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(43), kHEIGHT(43))];
        _headImageView.layer.cornerRadius = 5;
        _headImageView.clipsToBounds = YES;
        [backbutton addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, kHEIGHT(10), SCREEN_WIDTH-_headImageView.right-10-10, 20)];
        //        _nameLabel1.backgroundColor = [UIColor lightGrayColor];
        _nameLabel.font = kFONT(15);
        [backbutton addSubview:_nameLabel];
        
        _positionAndCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.bottom-15-3, _nameLabel.width, 15)];
        _positionAndCompanyLabel.font = kFONT(12);
        _positionAndCompanyLabel.textColor = RGB(153, 153, 153);
        //        _positionLabel1.backgroundColor = [UIColor darkGrayColor];
        [backbutton addSubview:_positionAndCompanyLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-10, 10, 100, 20)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"时间";
        _timeLabel.textColor = RGB(153, 153, 153);
        _timeLabel.font = kFONT(12);
        [backbutton addSubview:_timeLabel];
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _headImageView.bottom+10, SCREEN_WIDTH, 0.5)];
        line1.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = kFONT(14);
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, line1.bottom+10, SCREEN_WIDTH, 80);
        [button addTarget:self action:@selector(interViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        UILabel *sysMess = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom, 120, kHEIGHT(36))];
        sysMess.text = @"系统信息";
        sysMess.textColor = RGB(153, 153, 153);
        sysMess.font = kFONT(12);
        //        sysMess.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:sysMess];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-8-kHEIGHT(10), line1.bottom+(kHEIGHT(36)-14)/2, 8, 14)];
        imageView.image = [UIImage imageNamed:@"jinru"];
        [self addSubview:imageView];
        
        _sysMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sysMessageBtn.frame = CGRectMake(10, line1.bottom, SCREEN_WIDTH-8-kHEIGHT(10)-10, kHEIGHT(36));
        //        _sysButton1.backgroundColor = [UIColor darkGrayColor];
        _sysMessageBtn.titleLabel.font = kFONT(12);
        [_sysMessageBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [_sysMessageBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self addSubview:_sysMessageBtn];
        
        UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, sysMess.bottom, SCREEN_WIDTH, 0.5)];
        line3.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line3];
        
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        applyBtn.frame = CGRectMake(0, line3.bottom, SCREEN_WIDTH/3, kHEIGHT(36));
        applyBtn.tag = 30;
        [applyBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [applyBtn addTarget:self action:@selector(listActions:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:applyBtn];
        
        _applyNumberLabel = [[UILabel alloc]initWithFrame:applyBtn.bounds];
        _applyNumberLabel.font = kFONT(12);
        _applyNumberLabel.textAlignment = NSTextAlignmentCenter;
        //        _messageLabel1.backgroundColor = [UIColor lightGrayColor];
        [applyBtn addSubview:_applyNumberLabel];
        
        UILabel *lineMess = [[UILabel alloc]initWithFrame:CGRectMake(applyBtn.right, line3.bottom+(kHEIGHT(36)-15)/2, 0.5, 15)];
        lineMess.backgroundColor = RGB(226, 226, 226);
        [self addSubview:lineMess];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.frame = CGRectMake(applyBtn.right, line3.bottom, SCREEN_WIDTH/3, kHEIGHT(36));
        messageBtn.tag = 31;
        [messageBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [messageBtn addTarget:self action:@selector(listActions:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:messageBtn];
        
        _messageNumberLabel = [[UILabel alloc]initWithFrame:messageBtn.bounds];
        _messageNumberLabel.font = kFONT(12);
        _messageNumberLabel.textAlignment = NSTextAlignmentCenter;
        //        _applyLabel1.backgroundColor = [UIColor darkGrayColor];
        [messageBtn addSubview:_messageNumberLabel];
        
        
        UILabel *lineApply = [[UILabel alloc]initWithFrame:CGRectMake(messageBtn.right, line3.bottom+(kHEIGHT(36)-15)/2, 0.5, 15)];
        lineApply.backgroundColor = RGB(226, 226, 226);
        [self addSubview:lineApply];
        
        UIButton *glanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        glanceBtn.frame = CGRectMake(messageBtn.right, line3.bottom, SCREEN_WIDTH/3, kHEIGHT(36));
        glanceBtn.tag = 32;
        [glanceBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [glanceBtn addTarget:self action:@selector(listActions:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:glanceBtn];
        
        _glanceNumberLabel = [[UILabel alloc]initWithFrame:glanceBtn.bounds];
        _glanceNumberLabel.font = kFONT(12);
        _glanceNumberLabel.textAlignment = NSTextAlignmentCenter;
        //        _broweLabel1.backgroundColor = [UIColor lightGrayColor];
        [glanceBtn addSubview:_glanceNumberLabel];
        
        
        UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(0, glanceBtn.bottom, SCREEN_WIDTH, 0.5)  ];
        line4.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line4];
        
        SPButton1 *delButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(0, line4.bottom, SCREEN_WIDTH/5, kHEIGHT(36)) title:@"删除" ImageName:@"shanchu_1" Target:self Action:@selector(operationClick:)];
        [delButton1 setContentLabelSize:@"删除" font:FUCKFONT(12)];
        [delButton1 setContentAlignment:SPButtonContentAlignmentCenter];
        delButton1.tag = 20;
        [self addSubview:delButton1];
        
        SPButton1 *editButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(delButton1.right, line4.bottom, SCREEN_WIDTH/5, kHEIGHT(36)) title:@"修改" ImageName:@"xiugai_1" Target:self Action:@selector(operationClick:)];
        [editButton1 setContentLabelSize:@"修改" font:FUCKFONT(12)];
        [editButton1 setContentAlignment:SPButtonContentAlignmentCenter];
        editButton1.tag = 21;
        [self addSubview:editButton1];
        
        SPButton1 *refButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(editButton1.right, line4.bottom, SCREEN_WIDTH/5, kHEIGHT(36)) title:@"刷新" ImageName:@"shuaxin" Target:self Action:@selector(operationClick:)];
        [refButton1 setContentLabelSize:@"刷新" font:FUCKFONT(12)];
        [refButton1 setContentAlignment:SPButtonContentAlignmentCenter];
        refButton1.tag = 22;
        [self addSubview:refButton1];
        
        SPButton1 *downButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(refButton1.right, line4.bottom, SCREEN_WIDTH/5, kHEIGHT(36)) title:@"下架" ImageName:@"xiajia" Target:self Action:@selector(operationClick:)];
        [downButton1 setContentLabelSize:@"下架" font:FUCKFONT(12)];
        [downButton1 setContentAlignment:SPButtonContentAlignmentCenter];
        downButton1.tag = 23;
        [self addSubview:downButton1];
        
        SPButton1 *upButton1 = [[SPButton1 alloc]initWithFrame:CGRectMake(downButton1.right, line4.bottom, SCREEN_WIDTH/5, kHEIGHT(36)) title:@"推广" ImageName:@"tuiguang" Target:self Action:@selector(operationClick:)];
        [upButton1 setContentLabelSize:@"推广" font:FUCKFONT(12)];
        [upButton1 setContentAlignment:SPButtonContentAlignmentCenter];
        upButton1.tag = 24;
        [self addSubview:upButton1];
        
        UILabel *line5 = [[UILabel alloc]initWithFrame:CGRectMake(0, upButton1.bottom, SCREEN_WIDTH, kHEIGHT(6))];
        line5.backgroundColor = RGB(235, 235, 235);
        [self addSubview:line5];
    }
    return self;
}

- (void)fuckTheCompanyForever{
    if (self.DidSelectedBlock) {
        self.DidSelectedBlock(self.tag-10);
    }
}

- (void)listActions:(UIButton *)sender{
    if (self.NearCheckBlock) {
        self.NearCheckBlock(self.tag-10,sender.tag-30);
    }
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
    
    CGFloat height = kHEIGHT(10)+kHEIGHT(43)+10+kHEIGHT(36)+kHEIGHT(36)+kHEIGHT(36)+kHEIGHT(6);
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
