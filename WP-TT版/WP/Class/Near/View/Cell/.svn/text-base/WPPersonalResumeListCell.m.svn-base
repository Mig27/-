//
//  WPPersonalResumeListCell.m
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPPersonalResumeListCell.h"

@implementation WPPersonalResumeListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(37), kHEIGHT(37))];
        _headImageView.image = [UIImage imageNamed:@"head_default"];
        _headImageView.layer.cornerRadius = 5;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [_headImageView addGestureRecognizer:tap];
        [self addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, kHEIGHT(10), SCREEN_WIDTH-_headImageView.right-kHEIGHT(10)-kHEIGHT(10), 20)];
        _nameLabel.text = @"成龙";
        _nameLabel.font = kFONT(15);
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickName)];
        [_nameLabel addGestureRecognizer:nameTap];
        [self addSubview:_nameLabel];
        
        _positionAndCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.bottom-15-3, _nameLabel.width, 15)];
        _positionAndCompanyLabel.font = kFONT(12);
        _positionAndCompanyLabel.textColor = RGB(127, 127, 127);
        _positionAndCompanyLabel.text = @"经理 | 莱达商贸有限公司";
        _positionAndCompanyLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapPosition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPosition)];
        [_positionAndCompanyLabel addGestureRecognizer:tapPosition];
        [self addSubview:_positionAndCompanyLabel];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.bottom, SCREEN_WIDTH-_headImageView.right-10-kHEIGHT(10), 0.5) ];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
        
//        UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
////        self.cover = cover;
////        self.cover.userInteractionEnabled = YES;
//////        [self addSubview:cover];
//        [cover mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_nameLabel.mas_left);
//            make.centerY.equalTo(_headImageView);
//            make.height.equalTo(_headImageView);
//            make.width.equalTo(@(SCREEN_WIDTH/2));
//        }];
        
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_headImageView.right+10, line.bottom+10, kHEIGHT(43), kHEIGHT(43))];
        _contentImageView.image = [UIImage imageNamed:@"head_default"];
        [self addSubview:_contentImageView];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView.right+10, line.bottom+10, SCREEN_WIDTH-_contentImageView.right-10-kHEIGHT(10), 20)];//_headImageView.right-10-kHEIGHT(10)
        _contentLabel.text = @"求职 : 房产销售员";
        _contentLabel.font = kFONT(15);
        [self addSubview:_contentLabel];
        
        _contentDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_contentImageView.right+10, _contentLabel.bottom+10, SCREEN_WIDTH-_headImageView.right-10-kHEIGHT(10), 20)];
        _contentDetailLabel.font = kFONT(12);
        _contentDetailLabel.textColor = RGB(127, 127, 127);
        _contentDetailLabel.text = @"JACK 男 本科 5-10年";
        [self addSubview:_contentDetailLabel];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(_headImageView.right+10, line.bottom+10, SCREEN_WIDTH-_headImageView.right-10, 80);
//        [button addTarget:self action:@selector(interViewClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.right+10, _contentImageView.bottom+10, SCREEN_WIDTH-_headImageView.right-10-kHEIGHT(10), 15)];
        _timeLabel.textColor = RGB(127, 127, 127);
        _timeLabel.font = kFONT(12);
        _timeLabel.text = @"4小时前";
        [self addSubview:_timeLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_contentImageView);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@(8));
            make.height.equalTo(@(14));
        }];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, [WPPersonalResumeListCell cellHeight]-6, SCREEN_WIDTH, 6)];
        label.backgroundColor = RGB(226, 226, 226);
        [self addSubview:label];
        
        
        UIButton *bottomCover = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomCover addTarget:self action:@selector(bottomCoverClick) forControlEvents:UIControlEventTouchUpInside];
        self.bottomCover = bottomCover;
        [self addSubview:bottomCover];
        [bottomCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(line.mas_bottom);
            make.height.equalTo(@(kHEIGHT(43)+10+15+10));
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
        
    }
    return self;
}
-(void)setModel:(WPNewResumeModel *)model
{
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nameLabel.text = model.nick_name;
    self.positionAndCompanyLabel.text = [NSString stringWithFormat:@"%@ | %@",model.position,model.company];
    
    CGSize size = [self.nameLabel.text getSizeWithFont:FUCKFONT(15) Height:20];
    CGRect rect = self.nameLabel.frame;
    rect.size.width = size.width;
    self.nameLabel.frame = rect;

    
}
-(void)setResumeModel:(WPNewResumeListModel *)resumeModel
{
    NSURL *url1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:resumeModel.avatar]];
    [self.contentImageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.contentLabel.text = resumeModel.position;
    self.contentDetailLabel.text = _isRecruit?resumeModel.enterpriseName:[NSString stringWithFormat:@"%@ %@ %@ %@",resumeModel.nike_name,resumeModel.sex,resumeModel.education,resumeModel.worktime];
    self.timeLabel.text = resumeModel.updateTime;
}
-(void)tapImage
{
  self.coverClickBlock();
}
-(void)clickName
{
  self.coverClickBlock();
}
-(void)bottomCoverClick{
    self.bottomCoverBlock();
}
-(void)clickPosition
{
  self.bottomCoverBlock();
}
-(void)coverClick{
//    self.coverClickBlock();
}

//- (void)interViewClick:(UIButton *)sender{
//    if (self.contentActionBlock) {
//        self.contentActionBlock(self.indexPath);
//    }
//}

+ (CGFloat)cellHeight{
    CGFloat height = kHEIGHT(10)+kHEIGHT(37)+10+kHEIGHT(43)+10+15+10+kHEIGHT(6);
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.backgroundColor = [UIColor whiteColor];
}

@end
