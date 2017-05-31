//
//  AnonymousView.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "AnonymousView.h"
@interface AnonymousView()
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *professional;
@property (nonatomic, strong)UILabel *defultLabel;
@property (nonatomic, strong)UILabel *anonyLabel;
@property (nonatomic, strong)UIView *line;
@end

@implementation AnonymousView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self createUI];
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.anonyLabel.right+6, self.anonyLabel.origin.y, 0.5, kHEIGHT(12))];
        self.line = [[UIView alloc]init];
//        view.center = CGPointMake(self.anonyLabel.right+6, self.anonyLabel.origin.y+self.anonyLabel.size.height/2);
        [self addSubview:self.line];
        self.line.backgroundColor = RGB(226, 226, 226);
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, kHEIGHT(12)));
            make.left.equalTo(self.professional.mas_right).offset(6);
            make.top.equalTo(self.professional.mas_top).offset(2);
        }];
    }
    return self;
}

-(void)createUI{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.image = [UIImage imageNamed:@"head_default"];
    [self addSubview:self.imageView];
//    self.imageView.frame = CGRectMake(kHEIGHT(10), 0, kHEIGHT(54), kHEIGHT(54));
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(kHEIGHT(10));
        make.top.equalTo(self);
        make.height.width.equalTo(@(kHEIGHT(54)));
    }];
    
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    //上面的名字
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = kFONT(15);
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.offset(kHEIGHT(10));
        make.top.equalTo(@(((kHEIGHT(54) - normalSize1.height- normalSize2.height - 10)/2)));
    }];
    
    //职位
    self.professional = [[UILabel alloc] init];
    self.professional.font = kFONT(12);
//    self.professional.backgroundColor = [UIColor redColor];
    self.professional.textColor = RGB(127, 127, 127);
    [self addSubview:self.professional];
    [self.professional mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        
    }];
    
    self.defultLabel = [[UILabel alloc]init];
    self.defultLabel.font = kFONT(12);
    self.defultLabel.textColor = RGB(127, 127, 127);
    self.defultLabel.text = @"(系统默认)";
    [self addSubview:self.defultLabel];
    [self.defultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(12);
        make.top.equalTo(self.nameLabel.mas_top);
    }];
    
    //匿名
    self.anonyLabel = [[UILabel alloc]init];
    self.anonyLabel.font = kFONT(12);
    self.anonyLabel.text = @"匿名";
    self.anonyLabel.textColor = RGB(127, 127, 127);
    [self addSubview:self.anonyLabel];
    [self.anonyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.professional.mas_right).with.offset(12);
        make.bottom.equalTo(self.professional.mas_bottom);
    }];
}
//
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.professional.text.length) {
        [self.anonyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.professional.mas_right).with.offset(12);
            make.top.equalTo(self.defultLabel.mas_bottom).with.offset(10);
        }];
        
        self.line.hidden = YES;
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, kHEIGHT(12)));
            make.left.equalTo(self.professional.mas_right).offset(6);
            make.top.equalTo(self.professional.mas_top).offset(2);
        }];
    }
    else
    {
      self.line.hidden = NO;
    }
//    else
//    {
//        
//        [self.anonyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.professional.mas_right).with.offset(12);
//            make.bottom.equalTo(self.professional.mas_bottom);
//        }];
//        
//        
//        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(1, kHEIGHT(12)));
//            make.left.equalTo(self.professional.mas_right).offset(6);
//            make.top.equalTo(self.professional.mas_top).offset(2);
//        }];
//    }
}

- (void)setModel:(AnonymousModel *)model
{
    NSString *url;
    if (model.photo) {
        url = [IPADDRESS stringByAppendingString:model.photo];
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    self.nameLabel.text = model.name;
    
    self.professional.text = model.postionName;
    
    if ([model.is_default integerValue]) {
        [self.defultLabel removeFromSuperview];
     }
    
    [self layoutSubviews];
}
@end
