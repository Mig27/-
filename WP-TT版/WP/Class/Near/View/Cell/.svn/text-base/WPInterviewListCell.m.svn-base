//
//  WPInterviewListCell.m
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewListCell.h"
#import "SPButton.h"
#import "UIImageView+WebCache.h"
#import "THLabel.h"

@interface WPInterviewListCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) SPButton *editBtn;
@property (strong, nonatomic) UIButton *chooseBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

#define ItemWidth (SCREEN_WIDTH/2-4-2)
#define ItemHeights (ItemWidth+43)
#define EdgeWidth 4

@implementation WPInterviewListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = WPColor(235, 235, 235);
        int index = 0;
        CGFloat left =EdgeWidth-(index%2)*EdgeWidth/2;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left, EdgeWidth, ItemWidth, ItemWidth)];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.image = [UIImage imageNamed:@"defaultHead"];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.height-25, ItemWidth, 25)];
        _label.backgroundColor = RGBA(0, 0, 0, 0.3);
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = kFONT(15);
        _label.text = @"JACK 男 30 本科 6-7年";
        [_imageView addSubview:_label];
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(ItemWidth/2-30, ItemHeights/2-20, 15, 15)];
        _imageV.image = [UIImage imageNamed:@"bianji"];
        _imageV.hidden = YES;
        [self addSubview:_imageV];
        
        _editLabel = [[THLabel alloc]initWithFrame:CGRectMake(_imageV.right, ItemHeights/2-20, 120, 20)];
        _editLabel.text = @"编辑";
        _editLabel.font = kFONT(12);
        _editLabel.textColor = [UIColor whiteColor];
        _editLabel.shadowColor = kShadowColor1;
        _editLabel.shadowOffset = kShadowOffset;
        _editLabel.shadowBlur = kShadowBlur;
        _editLabel.hidden = YES;
        [self addSubview:_editLabel];
//        _editBtn = [[SPButton alloc]initWithFrame:CGRectMake(left, _imageView.bottom, _imageView.width/2, 43) title:@"编辑" ImageName:@"bianji" Target:self Action:@selector(editAction:)];
//        [self addSubview:_editBtn];
        
//        _chooseBtn = [[SPButton alloc]initWithFrame:CGRectMake(_imageView.width-30, 0, 30, 30) title:@"选择" ImageName:@"xuanze" Target:self Action:@selector(chooseAction:)];
//        [self addSubview:_chooseBtn];
        
        _chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(_imageView.width-26, 4, 22, 22)];
        [_chooseBtn setImage:[UIImage imageNamed:@"userinfo_unselected"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"userinfo_selected"] forState:UIControlStateSelected];
        [_chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:_chooseBtn];
        
    }
    return self;
}

- (void)initWithSubViews:(NSIndexPath *)indexPath
{
    CGFloat left =EdgeWidth-(indexPath.row%2)*EdgeWidth/2;
    _imageView.left = left;
    _indexPath = indexPath;
    
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(left, EdgeWidth, ItemWidth, ItemWidth)];
//    imageV.image = [UIImage imageNamed:@"defaultHead"];
//    [self addSubview:imageV];
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(left, imageV.bottom-25, ItemWidth, 25)];
//    label.backgroundColor = RGBA(0, 0, 0, 0.3);
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = GetFont(15);
//    label.text = @"JACK 男 30 本科 6-7年";
//    [self addSubview:label];
//    
//    SPButton *editBtn = [[SPButton alloc]initWithFrame:CGRectMake(left, imageV.bottom, imageV.width/2, 30) title:@"编辑" ImageName:@"bianji" Target:self Action:@selector(editAction:)];
//    [self addSubview:editBtn];
//    
//    SPButton *chooseBtn = [[SPButton alloc]initWithFrame:CGRectMake(editBtn.right, imageV.bottom, imageV.width/2, 30) title:@"选择" ImageName:@"xuanze" Target:self Action:@selector(chooseAction:)];
//    [self addSubview:chooseBtn];
}

- (void)editAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didEditItemAtIndexPath:)]) {
        [self.delegate didEditItemAtIndexPath:_indexPath];
    }
}

- (void)chooseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(didChooseItemAtIndexPath:)]) {
        [self.delegate didChooseItemAtIndexPath:_indexPath];
    }
}

- (void)updateData:(WPDraftListContentModel *)model{
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    self.label.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.name,model.sex,model.age,model.education,model.WorkTime];
    self.chooseBtn.selected = model.itemIsSelected;
}

+(instancetype)cellectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"WPInterviewListCell";
    WPInterviewListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    WPInterviewListCell *cell = [[WPInterviewListCell alloc]init];
    [cell initWithSubViews:indexPath];
    return cell;
}

+(CGFloat)getCellHeight
{
    return ItemHeights+EdgeWidth;
}

@end
