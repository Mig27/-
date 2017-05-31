//
//  DDPromptCell.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-6-9.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "DDPromptCell.h"
#import "UIView+Addition.h"
#import <Masonry/Masonry.h>
@implementation DDPromptCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _promptLabel = [MLLinkLabel new];
//        _promptLabel.delegate = self;
        [_promptLabel setClipsToBounds:YES];
        [_promptLabel setFont:kFONT(10)];//systemFont(11)
        [_promptLabel.layer setCornerRadius:5];
        [_promptLabel setTextColor:RGB(255, 255, 255)];
        [_promptLabel setBackgroundColor:RGBA(100, 100, 100, 0.2)];
        _promptLabel.numberOfLines = 0;
        [_promptLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_promptLabel];
        [self.contentView setBackgroundColor:RGB(235, 235, 235)];//[UIColor clearColor]
        [self setBackgroundColor:RGB(235, 235, 235)];//[UIColor clearColor]
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
//        self.addBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        self.addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [self.addBtn setBackgroundImage:[UIImage imageWithColor:RGB(226, 226,226)] forState:UIControlStateHighlighted];
        
        self.addBtn.titleLabel.font = kFONT(10);
        [self.addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.addBtn];
        self.addBtn.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setprompt:(NSString*)prompt
{
    self.addBtn.hidden = YES;
    CGRect size = [prompt boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFONT(10),NSFontAttributeName, nil] context:nil];//systemFont(11)
    [_promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(size.size.width+8, size.size.height + 6));//size.size.height + 6
    }];
    [_promptLabel setText:prompt];
}
-(void)setPromptAttr:(NSString *)prompt
{
    CGRect size = [prompt boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFONT(10),NSFontAttributeName, nil] context:nil];//systemFont(11)
    [_promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(size.size.width, size.size.height + 6));//size.size.height + 6
    }];
    self.promptLabel.text = prompt;
    self.addBtn.hidden = NO;
//    self.addBtn.backgroundColor = [UIColor redColor];
    CGRect size1 = [@"添加好友" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFONT(10),NSFontAttributeName, nil] context:nil];
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_promptLabel.mas_right).offset(0);
        make.bottom.equalTo(_promptLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(2*size1.size.width, size.size.height + 6));
    }];
    self.addBtn.titleEdgeInsets = UIEdgeInsetsMake(size.size.height/2+3, 0, 0, 0);

}
-(void)clickAddBtn
{
    if (self.clickPromptLabel)
    {
        self.clickPromptLabel(self.indexPath);
    }
}
@end
