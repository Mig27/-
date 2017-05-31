//
//  SelectTableViewCell.m
//  test
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "SelectTableViewCell.h"

#import "MacroDefinition.h"

@implementation SelectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(235, 235, 235)]];
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = kFONT(15);
        self.titleLabel.numberOfLines = 0;
        
        self.localImage = [[UIImageView alloc]init];
        self.localImage.image = [UIImage imageNamed:@"dingwei@2x"];
        self.localImage.hidden = YES;

        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);//
        [self.contentView addSubview:line];
        
        self.selecImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(15)-kHEIGHT(10), (self.height-kHEIGHT(15))/2, kHEIGHT(15), kHEIGHT(15))];
        self.selecImage.image = [UIImage imageNamed:@"common_xuanzhong"];
        self.selecImage.hidden = YES;
        
        CGSize size = [@"最新求职" getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(43)];
        self.redBot = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12)+size.width+4, 12, 8, 8)];
        self.redBot.backgroundColor = [UIColor redColor];
        self.redBot.layer.cornerRadius = 4;
        self.redBot.clipsToBounds = YES;
        self.redBot.hidden = YES;
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.hidden = YES;
        _chooseBtn.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(43), 0, kHEIGHT(43), kHEIGHT(43));
        [_chooseBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        _chooseBtn.userInteractionEnabled = NO;
        [_chooseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
        [_chooseBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _chooseBtn.hidden = YES;
        [self.contentView addSubview:_chooseBtn];
        
        [self.contentView addSubview:self.selecImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.localImage];
        [self.contentView addSubview:self.redBot];
    }
    return self;
}
-(void)setHideOrNot:(BOOL)hideOrNot
{
    self.chooseBtn.hidden = hideOrNot;
}
-(void)btnAction:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (self.clickBtn) {
        self.clickBtn(self.indexpath,btn.selected);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

@end
