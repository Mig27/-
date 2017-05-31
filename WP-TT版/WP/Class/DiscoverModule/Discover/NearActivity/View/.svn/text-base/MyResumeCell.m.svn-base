//
//  WPInterviewListCell.m
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "MyResumeCell.h"
#import "SPButton.h"
#import "UIImageView+WebCache.h"

@interface MyResumeCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) SPButton *editBtn;
@property (strong, nonatomic) SPButton *chooseBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

#define ItemWidth SCREEN_WIDTH/2-12-6
#define ItemHeights ItemWidth+43
#define EdgeWidth 12

@implementation MyResumeCell

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
        _imageView.image = [UIImage imageNamed:@"defaultHead"];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.height-25, ItemWidth, 25)];
        _label.backgroundColor = RGBA(0, 0, 0, 0.3);
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = GetFont(15);
        _label.text = @"JACK 男 30 本科 6-7年";
        [_imageView addSubview:_label];
        
        _editBtn = [[SPButton alloc]initWithFrame:CGRectMake(left, _imageView.bottom, _imageView.width/2, 43) title:@"编辑" ImageName:@"bianji" Target:self Action:@selector(editAction:)];
        [self addSubview:_editBtn];
        
        _chooseBtn = [[SPButton alloc]initWithFrame:CGRectMake(_editBtn.right, _imageView.bottom, _imageView.width/2, 43) title:@"选择" ImageName:@"xuanze" Target:self Action:@selector(chooseAction:)];
        [self addSubview:_chooseBtn];
    }
    return self;
}

- (void)initWithSubViews:(NSIndexPath *)indexPath
{
    CGFloat left =EdgeWidth-(indexPath.row%2)*EdgeWidth/2;
    _imageView.left = left;
    _editBtn.left = left;
    _chooseBtn.left = _editBtn.right;
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
    if ([self.delegate respondsToSelector:@selector(didChooseItemAtIndexPath:)]) {
        [self.delegate didChooseItemAtIndexPath:_indexPath];
    }
}

- (void)updateData:(DefaultParamsModel *)model{
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    self.label.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.name,model.sex,model.age,model.education,model.workTime];
}

+(instancetype)cellectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyResumeCell";
    MyResumeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    WPInterviewListCell *cell = [[WPInterviewListCell alloc]init];
    [cell initWithSubViews:indexPath];
    return cell;
}

+(CGFloat)getCellHeight
{
    return ItemHeights+EdgeWidth;
}

@end
