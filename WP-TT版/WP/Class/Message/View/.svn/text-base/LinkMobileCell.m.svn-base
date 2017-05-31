//
//  LinkMobileCell.m
//  WP
//
//  Created by 沈亮亮 on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "LinkMobileCell.h"

#import "UIImageView+WebCache.h"
#import "WPDownLoadVideo.h"
@implementation LinkMobileCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:nil];
    if (self) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(43)/2, kHEIGHT(43), kHEIGHT(43))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 6)/2;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, y, SCREEN_WIDTH - 120, kHEIGHT(15))];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, self.nameLabel.bottom + 6, SCREEN_WIDTH - 120, 12)];
    self.describeLabel.font = kFONT(12);
    self.describeLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.describeLabel];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.titleLabel.font = kFONT(12);
    [self.contentView addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(kHEIGHT(-10));
        make.height.equalTo(@(kHEIGHT(26)));
        make.width.equalTo(@(kHEIGHT(41)));
    }];
}

#pragma 关注按钮点击事件
- (void)attentionBtnClick
{
    NSString *title = [self.addButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"接受"])
    {
        self.acceptActionBlock(self.model.user_id);
        if (self.clickAccept) {
            self.clickAccept(self.model.user_id,self.index);
        }
    }
    if (self.opertionAddBlock)
    {
        self.opertionAddBlock(self.index,title);
    }
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
- (void)setModel:(LinkMobileListModel *)model
{
    _model = model;
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
    if (!self.isMobile)
    {
        self.nameLabel.text = model.user_name;
        if (model.mobileName.length>0)
        {
            self.describeLabel.text = [NSString stringWithFormat:@"手机联系人:%@",model.mobileName];
        }
        if ([model.isatt isEqualToString:@"0"])
        {  // 好友
            [self.addButton setTitle:@"已添加" forState:UIControlStateNormal];
            self.addButton.titleLabel.font = kFONT(12);
            self.describeLabel.text = model.belongGroup;
            [self.addButton setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.addButton .backgroundColor = [UIColor whiteColor];
        }
        else if ([model.isatt isEqualToString:@"1"])
        {
            if ([model.form_state isEqualToString:@"1"])
            {
                self.addButton.hidden = YES;
                UILabel *valiLabel = [[UILabel alloc] init];
                valiLabel.text = @"等待验证";
                valiLabel.font = kFONT(12);
                valiLabel.textAlignment = NSTextAlignmentRight;
                [valiLabel sizeToFit];
                self.valiLabel = valiLabel;
                self.valiLabel.font = kFONT(12);
                valiLabel.textColor = RGB(170, 170, 170);
                if (model.belongGroup == nil ||model.belongGroup.length == 0) {
                    self.describeLabel.text = @"请求添加你为好友";
                }else{
                    self.describeLabel.text = model.belongGroup;
                }
                
                [self.contentView addSubview:valiLabel];
                [self.valiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.contentView);
                    make.right.equalTo(self.contentView.mas_right).with.offset(kHEIGHT(-10));
                    make.height.equalTo(@(kHEIGHT(26)));
                    make.width.equalTo(@(kHEIGHT(55)));
                }];

            }
            else if ([model.form_state isEqualToString:@"2"])
            {
                [self.addButton setTitle:@"接受" forState:UIControlStateNormal];
                self.addButton.titleLabel.font = kFONT(12);
                self.addButton.layer.masksToBounds = YES;
                self.addButton.layer.cornerRadius = 5;
                self.addButton.layer.borderWidth = 0.5;
                self.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
                [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.addButton.backgroundColor = RGB(0, 172, 255);
                self.addButton.enabled = YES;
                [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
                if (model.belongGroup == nil ||model.belongGroup.length == 0)
                {
                    self.describeLabel.text = @"请求添加你为好友";
                }
                else
                {
                    self.describeLabel.text = model.belongGroup;
                }
            }
            else
            {
                [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
                self.addButton.titleLabel.font = kFONT(12);
                [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.addButton .backgroundColor = RGB(247, 247, 247);
                self.addButton.layer.masksToBounds = YES;
                self.addButton.layer.cornerRadius = 5;
                self.addButton.layer.borderWidth = 0.5;
                self.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
                [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
                self.addButton.enabled = YES;
            }
        }
        else if ([model.isatt isEqualToString:@"2"])
        {
            [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
            self.addButton.titleLabel.font = kFONT(12);
            [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.addButton .backgroundColor = RGB(247, 247, 247);
            self.addButton.layer.masksToBounds = YES;
            self.addButton.layer.cornerRadius = 5;
            self.addButton.layer.borderWidth = 0.5;
            self.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
            [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.addButton.enabled = YES;
        }
        else if ([model.isatt isEqualToString:@"3"] ||[model.isatt isEqualToString:@"5"])
        {   //这里是等待验证  上面没有执行
            [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
            self.addButton.titleLabel.font = kFONT(12);
            [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.addButton .backgroundColor = RGB(247, 247, 247);
            self.addButton.layer.masksToBounds = YES;
            self.addButton.layer.cornerRadius = 5;
            self.addButton.layer.borderWidth = 0.5;
            self.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
            [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.addButton.enabled = YES;
        }
    }
    else
    {  //添加手机联系人展示的cell 只有添加和已添加
        self.nameLabel.text = model.mobileName;
        self.describeLabel.text = [NSString stringWithFormat:@"快聘:%@",model.user_name];
        self.addButton.frame = CGRectMake(SCREEN_WIDTH - 20 - kHEIGHT(36), kHEIGHT(58)/2 - kHEIGHT(20)/2, kHEIGHT(36), kHEIGHT(20));
        // 非0的情况下都不是好友
        if ([model.isatt isEqualToString:@"2"])
        {
            [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
            self.addButton.titleLabel.font = kFONT(12);
            [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.addButton .backgroundColor =  RGB(0, 172, 255);
            self.addButton.layer.masksToBounds = YES;
            self.addButton.layer.cornerRadius = 5;
            self.addButton.layer.borderWidth = 0.5;
            self.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
            [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.addButton.enabled = YES;
          
        }
        else if ([model.isatt isEqualToString:@"0"] )
        {
            [self.addButton setTitle:@"已添加" forState:UIControlStateNormal];
            [self.addButton setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.addButton.enabled = NO;
            self.addButton.titleLabel.font = kFONT(12);
            self.addButton .backgroundColor = [UIColor whiteColor];
        }
        else if ([model.isatt isEqualToString:@"1"])
        {
            [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
            self.addButton.titleLabel.font = kFONT(12);
            [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.addButton .backgroundColor = RGB(0, 172, 255);
            self.addButton.layer.masksToBounds = YES;
            self.addButton.layer.cornerRadius = 5;
            self.addButton.layer.borderWidth = 0.5;
            self.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
            [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.addButton.enabled = YES;
        }
        else if([model.isatt isEqualToString:@"6"])
        { //只显示一次
            self.addButton.hidden = YES;
            UILabel *valiLabel = [[UILabel alloc] init];
            valiLabel.text = @"等待验证";
            valiLabel.font = kFONT(12);
            valiLabel.textAlignment = NSTextAlignmentRight;
            [valiLabel sizeToFit];
            self.valiLabel = valiLabel;
            self.valiLabel.font = kFONT(12);
            valiLabel.textColor = RGB(170, 170, 170);
            [self.contentView addSubview:valiLabel];
            [self.valiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).with.offset(kHEIGHT(-10));
                make.height.equalTo(@(kHEIGHT(26)));
                make.width.equalTo(@(kHEIGHT(55)));
            }];
        }
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"LinkMobileCellID";
    LinkMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[LinkMobileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
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
