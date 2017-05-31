//
//  GroupChooseMemberCell.m
//  WP
//
//  Created by 沈亮亮 on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupChooseMemberCell.h"

@implementation GroupChooseMemberCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    
//    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backBtn.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(58), 0, kHEIGHT(58),kHEIGHT(58));
////    [self.backBtn setBackgroundColor:[UIColor redColor]];
//    [self.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    self.backBtn.hidden = YES;
//    [self.contentView addSubview:self.backBtn];
    
    self.selectBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - 9, 18, 18)];
    self.selectBtnImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.selectBtnImg];
    
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(58), 0, kHEIGHT(58),kHEIGHT(58));
    //    [self.backBtn setBackgroundColor:[UIColor redColor]];
    [self.backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.hidden = YES;
    [self.contentView addSubview:self.backBtn];
    
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectBtnImg.right + kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + kHEIGHT(10), kHEIGHT(58)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 100, 20)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
}
-(void)clickBackBtn:(UIButton*)sender
{
    if (self.btnClick) {
        self.btnClick(sender);
    }
}
-(void)setIsFromChat:(BOOL)isFromChat
{
    if (isFromChat)
    {
        self.backBtn.hidden = NO;
        CGRect iconRect = self.icon.frame;
        CGRect seleBtnRect = self.selectBtnImg.frame;
        CGRect nameLabelRect = self.nameLabel.frame;
        
        
        iconRect = CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32));
        seleBtnRect = CGRectMake(SCREEN_WIDTH-kHEIGHT(24)-18, kHEIGHT(58)/2 - 9, 18, 18);
        nameLabelRect = CGRectMake(kHEIGHT(32) + 2*kHEIGHT(10), kHEIGHT(58)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 100, 20);
        
        self.icon.frame = iconRect;
        self.selectBtnImg.frame = seleBtnRect;
        self.nameLabel.frame = nameLabelRect;
   
    }
    else
    {
//        self.selectBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - 9, 18, 18)];
//        [self.contentView addSubview:self.selectBtnImg];
//        
//        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectBtnImg.right + kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    
    }
}
-(void)setIsFromTranmit:(BOOL)isFromTranmit
{
    if (isFromTranmit) {
        self.backBtn.hidden = YES;
        self.selectBtnImg.hidden = YES;
        CGRect iconRect = self.icon.frame;
        CGRect seleBtnRect = self.selectBtnImg.frame;
        CGRect nameLabelRect = self.nameLabel.frame;
        
        
        iconRect = CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32));
        seleBtnRect = CGRectMake(SCREEN_WIDTH-kHEIGHT(20)-18, kHEIGHT(58)/2 - 9, 18, 18);
        nameLabelRect = CGRectMake(kHEIGHT(32) + 2*kHEIGHT(10), kHEIGHT(58)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 100, 20);
        
        self.icon.frame = iconRect;
        self.selectBtnImg.frame = seleBtnRect;
        self.nameLabel.frame = nameLabelRect;
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"GroupChooseMemberCellId";
    GroupChooseMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[GroupChooseMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (void)setModel:(LinkManListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = model.nick_name;
    if ([model.is_be isEqualToString:@"1"]) {
        self.selectBtnImg.image = [UIImage imageNamed:@"group_enable"];
    } else {
        self.selectBtnImg.image = [UIImage imageNamed:[model.is_selected isEqualToString:@"1"] ? @"group_selected" : @"group_unselected"];
    }
}

- (void)setMemberModel:(GroupMemberListModel *)memberModel
{
    NSString *url = [IPADDRESS stringByAppendingString:memberModel.avatar];
    [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = memberModel.nick_name;
    self.selectBtnImg.image = [UIImage imageNamed:[memberModel.is_selected isEqualToString:@"1"] ? @"group_selected" : @"group_unselected"];

}

+ (CGFloat)cellHeight
{
    return kHEIGHT(58);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
