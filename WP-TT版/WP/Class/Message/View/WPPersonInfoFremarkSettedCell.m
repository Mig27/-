//
//  WPPersonInfoFremarkSettedCell.m
//  WP
//
//  Created by Kokia on 16/5/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonInfoFremarkSettedCell.h"
#import "WPDownLoadVideo.h"
@interface WPPersonInfoFremarkSettedCell()

@property (nonatomic,strong) UIImageView *accessory;

@end

@implementation WPPersonInfoFremarkSettedCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
//        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    
    return self;
}

- (void)createUI
{
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(72) - normalSize1.height - normalSize2.height -normalSize2.height - kHEIGHT(8))/2;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, kHEIGHT(72)/2 - kHEIGHT(54)/2, kHEIGHT(54), kHEIGHT(54))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.nameLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.iconImage.right + kHEIGHT(10), y, 50, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).with.offset(kHEIGHT(10));
        make.top.equalTo(self.contentView.mas_top).with.offset(y);
    }];
    
    self.wpLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.iconImage.right + kHEIGHT(10), self.nameLabel.bottom + 10, SCREEN_WIDTH - 100, normalSize2.height)];
    
    self.wpLabel.font = kFONT(12);
    self.wpLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.wpLabel];
    [self.wpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-kHEIGHT(54)-kHEIGHT(10)-16-kHEIGHT(20)-kHEIGHT(10), 20));
    }];
    
    
    UIImageView *accessory = [[UIImageView alloc] init];
    [accessory setImage:[UIImage imageNamed:@"jinru"]];
    self.accessory = accessory;
    [self.contentView addSubview:accessory];
    [accessory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.positionLabel = [[UILabel alloc] init];
    self.positionLabel.font = kFONT(12);
    self.positionLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.positionLabel];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(8);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    
    self.line = [[UIView alloc] init];
    self.line .backgroundColor = RGB(226, 226, 226);
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positionLabel.mas_right).with.offset(6);
        make.centerY.top.equalTo(self.positionLabel);
        make.width.equalTo(@0.5);
        make.height.equalTo(@12);
    }];
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.font = kFONT(12);
    self.companyLabel.textColor = RGB(127, 127, 127);
    self.companyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).with.offset(6);
        make.centerY.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(accessory.mas_right).with.offset(-12);
    }];
    
    
    self.nikenameLabel = [[UILabel alloc] init];
    self.nikenameLabel.font = kFONT(12);
    self.nikenameLabel.textColor = RGB(127, 127, 127);
//    self.nikenameLabel.backgroundColor = [UIColor redColor];
    self.nikenameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.nikenameLabel];
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wpLabel);
        make.top.equalTo(self.wpLabel.mas_bottom).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-kHEIGHT(54)-kHEIGHT(10)-16-kHEIGHT(20), 20));
    }];
    
    
}

- (void)constraintSetting{
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(72) - normalSize1.height - normalSize2.height - kHEIGHT(4))/2;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, kHEIGHT(72)/2 - kHEIGHT(54)/2, kHEIGHT(54), kHEIGHT(54))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];

    
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//      
//    }];
//    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).with.offset(kHEIGHT(10));
        make.top.equalTo(self.contentView.mas_top).with.offset(y);
        
    }];
    
    
    [self.accessory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
    

    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(8);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positionLabel.mas_right).with.offset(6);
        make.centerY.top.equalTo(self.positionLabel);
        make.width.equalTo(@0.5);
        make.height.equalTo(@12);
    }];
    

    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).with.offset(6);
        make.centerY.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(self.accessory.mas_right).with.offset(-8);
    }];
    

    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
       make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-kHEIGHT(54)-kHEIGHT(10)-16-kHEIGHT(20), 20));
    }];
    
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
- (void)setModel:(MessagePersonalModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    NSData * data = [self imageData:url];
    if (data) {
        self.iconImage.image = [UIImage imageWithData:data];
    }
    else
    {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [down downLoadImage:url success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconImage.image = [UIImage imageWithData:response];
                });
            } failed:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconImage.image = [UIImage imageNamed:@"small_cell_person"];
                });
            }];
        });
    }
    
//    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = model.fremark;
//    if (model.wp_id.length > 0) {
        self.wpLabel.text = [NSString stringWithFormat:@"%@ | %@",model.position,model.company];
//    }else{
//         WPShareModel *model1 = [WPShareModel sharedModel];
//        if ([model.uid isEqualToString:model1.userId]) {
//           self.wpLabel.text = [NSString stringWithFormat:@"微聘号 ：%@",@"未设置"];
//        }else{
//            [self constraintSetting];
//        }
//    }
    self.positionLabel.text = @"";//model.position
    self.companyLabel.text = @"";//model.company
//    self.companyLabel.hidden = YES;
//    self.positionLabel.hidden = YES;
    self.line.hidden = YES;
    self.nikenameLabel.text =[NSString stringWithFormat:@"昵称 ：%@",model.nick_name];
   // self.nikenameLabel.text =[NSString stringWithFormat:@"%@ | %@",model.position,model.company];
}



@end
