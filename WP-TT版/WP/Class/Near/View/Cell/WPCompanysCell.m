//
//  WPCompanysCell.m
//  WP
//
//  Created by CBCCBC on 15/10/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPCompanysCell.h"
#import "UIImageView+WebCache.h"
#import "THLabel.h"

#define BackTag 100
#define HeadTag 101
#define CompanyTag 102
#define DetailTag 103
#define EditTag 104
#define ChooseTag 105

@interface WPCompanysCell ()
//@property (nonatomic , strong)UIImageView *imageView;
//@property (nonatomic , strong)

@end

@implementation WPCompanysCell
#pragma mark -- 此为我的企业页面的cell
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(12),(kHEIGHT(58)-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43))];
        imageV.tag = BackTag;
        imageV.layer.cornerRadius = 5;
        imageV.clipsToBounds = YES;
        [self.contentView addSubview:imageV];
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, imageV.height/2-25, 15, 15)];
        _imageV.image = [UIImage imageNamed:@"bianji"];
        _imageV.hidden = YES;
        _imageV.layer.cornerRadius = 5;
        _imageV.clipsToBounds = YES;
        [self.contentView addSubview:_imageV];
        
        _editLabel = [[THLabel alloc]initWithFrame:CGRectMake(_imageV.right, imageV.height/2-25, 120, 20)];
        _editLabel.text = @"编辑";
        _editLabel.font = kFONT(12);
        _editLabel.textColor = [UIColor blackColor];
        _editLabel.shadowColor = kShadowColor1;
        _editLabel.shadowOffset = kShadowOffset;
        _editLabel.shadowBlur = kShadowBlur;
        _editLabel.hidden = YES;
        [self.contentView addSubview:_editLabel];
        
        
        THLabel *companyLabel = [[THLabel alloc]initWithFrame:CGRectMake(74, imageV.origin.y+2, SCREEN_WIDTH/2, 20)];
        companyLabel.text = @"杭州阿里巴巴";
        companyLabel.font = kFONT(15);
        companyLabel.tag = CompanyTag;
        
        companyLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:companyLabel];
        
        THLabel *detailLabel = [[THLabel alloc]initWithFrame:CGRectMake(74, imageV.bottom-17, SCREEN_WIDTH-74-kHEIGHT(46), 15)];
        detailLabel.text = @"杭州阿里巴巴";
        detailLabel.tag = DetailTag;
        detailLabel.font = kFONT(12);
        detailLabel.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:detailLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = kFONT(13);
        button.tag = ChooseTag;
        button.frame = CGRectMake(0, kHEIGHT(0), kHEIGHT(44), kHEIGHT(58));//SCREEN_WIDTH-kHEIGHT(44)
        [button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0,0)];
        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"gray_background"] forState :UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        _chooseButton=button;
    
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(58)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.contentView addSubview:line];
        
    }
    return self;
}
-(void)setChoiseCompany:(BOOL)choiseCompany
{
    CGRect rect = _chooseButton.frame;
    rect = CGRectMake(SCREEN_WIDTH-kHEIGHT(44), kHEIGHT(0), kHEIGHT(44), kHEIGHT(58));
    [_chooseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_chooseButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10))];
    _chooseButton.frame = rect;
}
- (void)buttonClick:(UIButton *)sender
{
    
    if (sender.tag == EditTag) {
        sender.selected = !sender.selected;
    }
    if (self.listModel) {
        self.listModel.itemIsSelected = sender.selected;
    }
    if (self.personModel) {
        self.personModel.selected = sender.selected;
    }
    if (self.companyModel) {
        self.companyModel.selected = sender.selected;
    }
    
    if (sender.tag == ChooseTag) {
        sender.selected = !sender.selected;
        if (self.ChooseCurrentCompanyForResumeBlock) {
            self.ChooseCurrentCompanyForResumeBlock(self.tag);
        }
    }
}

+(instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"WPCompanysCellId";
    WPCompanysCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPCompanysCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.tag = indexPath.row;
    return cell;
}

- (void)setListModel:(WPCompanyListDetailModel *)listModel
{
    _listModel = listModel;
    UIImageView *imageV = (UIImageView *)[self viewWithTag:BackTag];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.QRCode]];
    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"back_default"]];
    
    UILabel *label = (UILabel *)[self viewWithTag:CompanyTag];
    label.text = listModel.enterpriseName;
    
    UILabel *label1 = (UILabel *)[self viewWithTag:DetailTag];
    label1.text = [NSString stringWithFormat:@"%@ %@ %@",listModel.dataIndustry,listModel.enterpriseProperties,listModel.enterpriseScale];
    
    UIButton *button = (UIButton *)[self viewWithTag:ChooseTag];
    button.selected = listModel.itemIsSelected;
}
//-(void)setIsEdit:(BOOL)isEdit
//{
//    if (isEdit)
//    {
//        self.distance = kHEIGHT(10)+18;
//    }
//    else
//    {
//        if (self.distance>0) {
//            self.distance = -kHEIGHT(10)-18;
//        }
//    }
//}
-(void)setIsHideChoise:(BOOL)isHideChoise
{

    
    UIImageView *imageV = (UIImageView *)[self viewWithTag:BackTag];
    UILabel *label = (UILabel *)[self viewWithTag:CompanyTag];
    UILabel *label1 = (UILabel *)[self viewWithTag:DetailTag];
    
    CGRect imageRect  = imageV.frame;
    CGRect labelRect  = label.frame;
    CGRect label1Rect = label1.frame;
    if (isHideChoise) {
        _chooseButton.hidden = YES;
        imageRect.origin.x  = kHEIGHT(12);
        labelRect.origin.x  = 74;
        label1Rect.origin.x = 74;
       
    }
    else
    {
        _chooseButton.hidden = NO;
        imageRect.origin.x  = kHEIGHT(12)+ kHEIGHT(10)+18;
        labelRect.origin.x  = 74+ kHEIGHT(10)+18;
        label1Rect.origin.x = 74+ kHEIGHT(10)+18;
    }
    [UIView animateWithDuration:0.3 animations:^{
        imageV.frame = imageRect;
        label.frame = labelRect;
        label1.frame = label1Rect;
    }];
    
}

- (void)setPersonModel:(WPPersonModel *)personModel
{
    _personModel = personModel;
    UIImageView *imageV = (UIImageView *)[self viewWithTag:BackTag];
    NSURL *url ;
    if (personModel.PhotoList.count > 0) {
        Photos *photo = personModel.PhotoList[0];
        url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:photo.thumb_path]];
    }
    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"back_default"]];
    
    UILabel *label = (UILabel *)[self viewWithTag:CompanyTag];
    label.text = personModel.name;
    
    UILabel *label1 = (UILabel *)[self viewWithTag:DetailTag];
    label1.text = [NSString stringWithFormat:@"%@ %@ %@ %@",personModel.sex,personModel.age,personModel.education,personModel.WorkTime];
    
    UIButton *button = (UIButton *)[self viewWithTag:ChooseTag];
    button.selected = personModel.selected;
}

- (void)setCompanyModel:(CompanyModel *)companyModel
{
    _companyModel = companyModel;
    UIImageView *imageV = (UIImageView *)[self viewWithTag:BackTag];
    NSURL *url ;
    if (companyModel.QR_code) {
        url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:companyModel.QR_code]];
    }
    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"back_default"]];
    
    UILabel *label = (UILabel *)[self viewWithTag:CompanyTag];
    label.text = companyModel.enterprise_name;
    
    UILabel *label1 = (UILabel *)[self viewWithTag:DetailTag];
    label1.text = [NSString stringWithFormat:@"%@ %@ %@",companyModel.dataIndustry,companyModel.enterprise_properties,companyModel.enterprise_scale];
    
    UIButton *button = (UIButton *)[self viewWithTag:ChooseTag];
    button.selected = companyModel.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
