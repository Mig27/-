//
//  NearAddCell.m
//  WP
//
//  Created by 沈亮亮 on 15/10/14.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "NearAddCell.h"

#define NearAddCellHeight kHEIGHT(43)

@implementation NearAddCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor cyanColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(12), kListEdge, 90, NearAddCellHeight-kListEdge*2)];
        self.titleLabel.text = @"活动详情:";
        self.titleLabel.font = kFONT(15);
        [self.contentView addSubview:self.titleLabel];
        
        //添加箭头
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-8,self.titleLabel.center.y-7, 8, 14)];
        self.rightImage.image = [UIImage imageNamed:@"jinru"];
        [self.contentView addSubview:self.rightImage];
        
        //亮点描述
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 8, SCREEN_WIDTH-kHEIGHT(12)-kHEIGHT(12), NearAddCellHeight)];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.font = kFONT(15);
        self.contentLabel.textColor = RGB(226, 226, 226);
        self.contentLabel.backgroundColor = [UIColor whiteColor];
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        
        CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGFloat width = size.width + 6;
        self.TextField = [[UITextField alloc]initWithFrame:CGRectMake(width+kHEIGHT(12), 0, SCREEN_WIDTH-(width+kHEIGHT(12))-kHEIGHT(12)-8, NearAddCellHeight)];
        self.TextField.placeholder = @"请填写亮点描述";
        self.TextField.enabled = NO;
         [self.contentView addSubview:self.TextField];
        
        
        
        //加号按钮
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectMake((SCREEN_WIDTH - 25)/2, 8, 40, NearAddCellHeight-8*2);
        [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn setImage:[UIImage imageNamed:@"near_act_add"] forState:UIControlStateNormal];
//      [self.contentView addSubview:self.addBtn];
        //文字和图片
        self.segment = [[RSSegmentControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, kListEdge, 80, NearAddCellHeight-kListEdge*2)];
        self.segment.hidden = YES;
        __weak typeof(self) weakSelf = self;
        self.segment.SegmentClickBlock = ^(NSInteger index) {
            weakSelf.addBtn.hidden = NO;
            weakSelf.segment.hidden = YES;
            if (weakSelf.selectType) {
                weakSelf.selectType(index);
            }
        };
//        [self.contentView addSubview:self.segment];
    }
    
    return self;
}

- (void)addBtnClick{
    self.addBtn.hidden = YES;
    self.segment.hidden = NO;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"NearAddCell";
    NearAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NearAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
