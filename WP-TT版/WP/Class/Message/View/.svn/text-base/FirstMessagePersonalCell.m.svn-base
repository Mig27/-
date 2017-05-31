//
//  FirstMessagePersonalCell.m
//  WP
//
//  Created by 沈亮亮 on 16/1/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "FirstMessagePersonalCell.h"
#import "WPDownLoadVideo.h"
#import "UIImageView+WebCache.h"


@interface FirstMessagePersonalCell()

@property (nonatomic,strong) UIImageView *accessory;

@end

@implementation FirstMessagePersonalCell

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
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(72) - normalSize1.height - normalSize2.height - 10)/2;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, kHEIGHT(72)/2 - kHEIGHT(54)/2, kHEIGHT(54), kHEIGHT(54))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];

    self.nameLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.iconImage.right + kHEIGHT(10), y, 50, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).with.offset(kHEIGHT(10));
        make.bottom.equalTo(self.iconImage.mas_centerY).with.offset(-2);
    }];
    
    self.wpLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(self.iconImage.right + kHEIGHT(10), self.nameLabel.bottom + 10, SCREEN_WIDTH - 100, normalSize2.height)];

    self.wpLabel.font = kFONT(12);
    self.wpLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.wpLabel];
    [self.wpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.nameLabel);
    }];
    
    UIImageView *accessory = [[UIImageView alloc] init];
    [accessory setImage:[UIImage imageNamed:@"jinru"]];
    self.accessory  = accessory;
    [self.contentView addSubview:accessory];
    [accessory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
    
   // self.positionLabel = [[UILabel alloc] init];
   // self.positionLabel.font = kFONT(12);
   // self.positionLabel.textColor = RGB(127, 127, 127);
   // [self.contentView addSubview:self.positionLabel];
   // [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
   //     make.left.equalTo(self.nameLabel.mas_right).with.offset(8);
   //     make.centerY.equalTo(self.nameLabel);
   // }];
    
    
   // self.line = [[UIView alloc] init];
    //self.line .backgroundColor = RGB(226, 226, 226);
    //[self.contentView addSubview:self.line];
   // [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.left.equalTo(self.positionLabel.mas_right).with.offset(6);
    //    make.centerY.equalTo(self.positionLabel);
    //    make.height.equalTo(@(12));
     //   make.width.equalTo(@0.5);
   // }];
    
    //self.companyLabel = [[UILabel alloc] init];
    //self.companyLabel.font = kFONT(12);
   // self.companyLabel.textColor = RGB(127, 127, 127);
    //self.companyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //[self.contentView addSubview:self.companyLabel];
    //[self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     //   make.left.equalTo(self.line.mas_right).with.offset(6);
     //   make.centerY.equalTo(self.nameLabel);
      //  make.right.lessThanOrEqualTo(accessory.mas_right).with.offset(-8);
   // }];
    
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"FirstMessagePersonalCellID";
    FirstMessagePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FirstMessagePersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}


- (void)constraintSetting{
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, kHEIGHT(72)/2 - kHEIGHT(54)/2, kHEIGHT(54), kHEIGHT(54))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).with.offset(kHEIGHT(10));
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(-4);
    }];
    

    [self.accessory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

   // [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.left.equalTo(self.nameLabel.mas_right).with.offset(8);
     //   make.centerY.equalTo(self.nameLabel);
    //}];
    

  //  [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
  //      make.left.equalTo(self.positionLabel.mas_right).with.offset(6);
  //      make.centerY.equalTo(self.positionLabel);
   //     make.height.equalTo(@(12));
   //     make.width.equalTo(@0.5);
  //  }];
    
    
   // [self.contentView addSubview:self.companyLabel];
   // [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
   //     make.left.equalTo(self.line.mas_right).with.offset(6);
    //    make.centerY.equalTo(self.nameLabel);
    //    make.right.lessThanOrEqualTo(self.accessory.mas_right).with.offset(-8);
   // }];
    
    [self.wpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.nameLabel);
    }];
    
    
//    self.companyLabel.hidden = YES;
//    self.line.hidden = YES;
//    self.positionLabel.hidden = YES;
    
}

- (void)setModel:(MessagePersonalModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:[NSString stringWithFormat:@"%@",model.avatar]];
    
    NSArray * pathArray = [url componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
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
    self.nameLabel.text = model.nick_name;

   // if (model.wp_id.length > 0) {
    //    self.wpLabel.text = [NSString stringWithFormat:@"%@ | %@",model.position,model.company];
  //  }else{  ///这里选择另外一套布局方式，是不是也可以把约束设置抽取出来
        WPShareModel *model1 = [WPShareModel sharedModel];
       // if ([model.uid isEqualToString:model1.userId]) {
            self.wpLabel.text = [NSString stringWithFormat:@"%@ | %@",model.position,model.company];
//}else{
           // [self constraintSetting];
        //}
    //}
    self.positionLabel.text = @"";
    self.companyLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
