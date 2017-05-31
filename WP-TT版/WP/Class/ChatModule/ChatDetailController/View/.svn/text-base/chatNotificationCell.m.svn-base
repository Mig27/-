//
//  chatNotificationCell.m
//  WP
//
//  Created by CC on 16/9/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "chatNotificationCell.h"

@implementation chatNotificationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icomImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(43)/2, kHEIGHT(43), kHEIGHT(43))];
        self.icomImage.layer.cornerRadius = 5;
        self.icomImage.clipsToBounds = YES;
        [self.contentView addSubview:self.icomImage];
        
        CGSize normalSize1 = [@"哈哈哈" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
        CGSize normalSize2 = [@"哈哈哈" sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
        CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 6)/2;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icomImage.right + 10, y, SCREEN_WIDTH - kHEIGHT(41)-self.icomImage.right-10-10, kHEIGHT(15))];
        self.nameLabel.font = kFONT(15);
//        self.nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.descriLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icomImage.right + 10, self.nameLabel.bottom + 8, SCREEN_WIDTH - kHEIGHT(41)-self.icomImage.right-10-10, 12)];
        self.descriLabel.font = kFONT(12);
        self.descriLabel.textColor = RGB(127, 127, 127);
//        self.descriLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.descriLabel];
        
        self.stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stateBtn.titleLabel.font = kFONT(12);
        self.stateBtn.layer.cornerRadius = 3;
        [self.stateBtn addTarget:self action:@selector(agreeAllpy) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.stateBtn];
        [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).with.offset(kHEIGHT(-10));
            make.height.equalTo(@(kHEIGHT(26)));
            make.width.equalTo(@(kHEIGHT(41)));
        }];
    }
    return self;
}
-(void)agreeAllpy
{
    if (self.clickAgree) {
        self.clickAgree(self.indexPath);
    }
}

-(NSString *)getNick:(NSString * )bickName andUserName:(NSString*)userName
{
    if (bickName.length)
    {
        return bickName;
    }
    else
    {
        return userName;
    }
}
//被移除 / 群主转移 / 申请加入群被拒绝 时显示的是群头像 其他是对应人头像
-(void)setModel:(NSDictionary *)model
{
    NSLog(@"我的id:%@",kShareModel.userId);
    NSString * state = [NSString stringWithFormat:@"%@",model[@"status"]];
    NSString * b_user_id = [NSString stringWithFormat:@"%@",model[@"b_user_id"]];
    NSString * a_user_id = [NSString stringWithFormat:@"%@",model[@"a_user_id"]];
    if (![b_user_id isEqualToString:kShareModel.userId] && [a_user_id isEqualToString:@"0"])
    {  //群主消息
        switch (state.intValue) {
            case 0:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = [self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]];
                self.descriLabel.text = [NSString stringWithFormat:@"申请加入%@:大家好,我是%@",model[@"group_name"],[self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]]];;
                
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"已同意" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = [self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]];
                self.descriLabel.text = [NSString stringWithFormat:@"申请加入%@:大家好,我是%@",model[@"group_name"],[self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]]];
                
                self.stateBtn.userInteractionEnabled = YES;
                [self.stateBtn setTitle:@"同意" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:RGB(0, 172, 255)];
                [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            }
                break;
            case 3:
            {
            
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = [self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]];
//                self.descriLabel.text = [NSString stringWithFormat:@"申请加入%@:大家好,我是%@",model[@"group_name"],[self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]]];;
                self.descriLabel.text = [NSString stringWithFormat:@"申请加入%@",model[@"group_name"]];
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
             }
                break;
            case 6:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = [self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]];
                self.descriLabel.text = [NSString stringWithFormat:@"已退出%@",[self getNick:model[@"group_name"] andUserName:model[@"group_name"]]];
                
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
           
            }
                break;
            default:
                break;
        }
    }
    else if ([a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {   //群成员消息 之 申请被拒绝
        if (state.intValue == 2)
        {
            //显示群头像
            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
            self.nameLabel.text = model[@"group_name"];
            //self.descriLabel.text = @"群主拒绝了你的加群申请";
            self.descriLabel.text = [NSString stringWithFormat:@"群主拒绝了你的加群申请: %@", model[@"denial"]];
            self.stateBtn.userInteractionEnabled = NO;
            [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    else if ([a_user_id isEqualToString:kShareModel.userId])
    {   //群成员主动消息 之 邀请被拒绝
        if (state.intValue == 2)
        {
            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
            self.nameLabel.text = model[@"b_nick_name"];
            self.descriLabel.text = [NSString stringWithFormat:@"拒绝加入%@",model[@"group_name"]];
            self.stateBtn.userInteractionEnabled = NO;
            [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    else if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId])
    {   //群成员被动消息
        switch (state.intValue) {
            case 0:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"a_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//                self.nameLabel.text = model[@"group_name"];
                self.nameLabel.text = model[@"a_nick_name"];
//                self.descriLabel.text = [NSString stringWithFormat:@"%@邀请你加入群组",[self getNick:model[@"a_nick_name"] andUserName:model[@"a_user_name"]]];//model[@"a_nick_name"]
                self.descriLabel.text = [NSString stringWithFormat:@"邀请你加入%@",[self getNick:model[@"group_name"] andUserName:model[@"group_name"]]];
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"已同意" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"a_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = model[@"a_nick_name"];
                self.descriLabel.text = [NSString stringWithFormat:@"邀请你加入%@",[self getNick:model[@"group_name"] andUserName:model[@"group_name"]]];
                
                self.stateBtn.userInteractionEnabled = YES;
                [self.stateBtn setTitle:@"同意" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:RGB(0, 172, 255)];
                [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"a_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                //self.nameLabel.text = model[@"group_name"];
//                self.nameLabel.text = [self getNick:model[@"b_nick_name"] andUserName:model[@"b_user_name"]];
//                self.descriLabel.text = [NSString stringWithFormat:@"%@邀请你加入群组",[self getNick:model[@"a_nick_name"] andUserName:model[@"a_user_name"]]];
                self.nameLabel.text = model[@"a_nick_name"];
                self.descriLabel.text = [NSString stringWithFormat:@"邀请你加入%@",model[@"group_name"]];
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                //群头像
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = model[@"group_name"];
                self.descriLabel.text =@"群主已将你移出群组";
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];

            }
                break;
            case 5:
            {
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = model[@"group_name"];
                self.descriLabel.text =@"群主已解散群组";
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];

            }
                break;
            case 7:
            {
                //群头像
                [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
                self.nameLabel.text = model[@"group_name"];
                self.descriLabel.text = [NSString stringWithFormat:@"%@已将群主权限转移给你,你已成为群主",[self getNick:model[@"a_nick_name"] andUserName:model[@"a_user_name"]]];
                self.stateBtn.userInteractionEnabled = NO;
                [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
                [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
                [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    
    
    
    
    
//    [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//    self.nameLabel.text = model[@"nick_name"];
//    self.descriLabel.text = model[@"post_remark"];
    
    
//    NSString * state = [NSString stringWithFormat:@"%@",model[@"status"]];
//    switch (state.intValue) {
//        case 0:
//        {
//            
//            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"group_name"];
//            self.descriLabel.text = @"已同意你的加入";
//            
//            
//            self.stateBtn.userInteractionEnabled = NO;
//            [self.stateBtn setTitle:@"已同意" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
//            [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }
//            break;
//        case 1:
//        {
//            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"b_nick_name"];
//            self.descriLabel.text = model[@"denial"];
//            
//            self.stateBtn.userInteractionEnabled = YES;
//            [self.stateBtn setTitle:@"同意" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:RGB(0, 172, 255)];
//            [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//            break;
//        case 2:
//        {
//            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"group_name"];
//            self.descriLabel.text =model[@"denial"];
//            
//            self.stateBtn.userInteractionEnabled = NO;
//            [self.stateBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
//            [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }
//            break;
//        case 6:
//        {
//            
//            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"b_avatar"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"b_nick_name"];
//            self.descriLabel.text = [NSString stringWithFormat:@"已退出群组"];
//            
//            self.stateBtn.userInteractionEnabled = NO;
//            [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
//            [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }
//            break;
//        case 5://解散群
//        {
//            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"group_name"];
//            self.descriLabel.text =@"该群已被解散";
//            
//            self.stateBtn.userInteractionEnabled = NO;
//            [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
//            [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }
//            break;
//        case 4:
//        {
//             [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"group_name"];
//            self.descriLabel.text =@"你已被群主移出";
//            
//            self.stateBtn.userInteractionEnabled = NO;
//            [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
//            [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }
//            break;
//        case 7:
//        {
//            [self.icomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,model[@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
//            self.nameLabel.text = model[@"group_name"];
//            self.descriLabel.text =@"群主已将群转移给你,你已成为群主";
//            
//            self.stateBtn.userInteractionEnabled = NO;
//            [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
//            [self.stateBtn setBackgroundColor:[UIColor whiteColor]];
//            [self.stateBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
