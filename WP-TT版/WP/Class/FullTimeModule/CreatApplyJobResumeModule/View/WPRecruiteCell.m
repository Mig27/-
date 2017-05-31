//
//  WPRecruiteCell.m
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRecruiteCell.h"
#import "CommonTipView.h"
#import "WPtextFiled.h"
#import "NSString+StringType.h"
#import "masonry.h"
@interface WPRecruiteCell ()
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIImageView *mandatory;
@property (nonatomic , strong)UIImageView *image;
@property (nonatomic , strong)CommonTipView *tipView;
@property (nonatomic , strong)CommonTipView *textTipView;
//@property (nonatomic , strong)UIImageView *image;
@end

@implementation WPRecruiteCell
{

    CGFloat selectButtonWidth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.mandatory];
        [self.contentView addSubview:self.textFied];
        _swithEnable = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];
}

- (UIImageView *)image
{
    if (!_image) {
        self.image = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        self.image.frame = CGRectMake(self.width-kHEIGHT(12)-8, self.height/2-7, 8,14);
    }
    return _image;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGSize size1 = [@"卧       槽:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGFloat width = size.width > size1.width ? size.width : size1.width;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, width, kHEIGHT(43))];
        self.titleLabel.font = kFONT(15);
    }
    return _titleLabel;
}

- (UIView *)mandatory
{
    if (!_mandatory) {
        self.mandatory = [[UIImageView alloc]initWithFrame:CGRectMake(FUCKFONT(10), 0, 7, 8)];
        self.mandatory.image = [UIImage imageNamed:@"bitian_neirong"];
        self.mandatory.center = CGPointMake(FUCKFONT(10)+7/2, kHEIGHT(43)/2);
    }
    return _mandatory;
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    self.textFied.enabled = enable;
    if (enable) {
        [self.image removeFromSuperview];
        [self.textFied addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.textFied addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
    }else{
        [self.contentView addSubview:self.image];
        [self.textFied removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.textFied removeTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    }
}

- (void)setSwithEnable:(BOOL)swithEnable{
    _swithEnable = swithEnable;
    if (!swithEnable) {
        [self.selectButton removeFromSuperview];
    }else{
        [self.contentView addSubview:self.selectButton];
    }
}

//kHEIGHT(43)
- (UIButton *)selectButton{
    if (!_selectButton) {
        NSString * tempString = @"显示";
        CGSize size = [tempString getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(18)];
        _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-size.width - 1 -kHEIGHT(29)- 8 -kHEIGHT(12), (self.height- kHEIGHT(19))/2,size.width + 1 +kHEIGHT(29)+ 8,kHEIGHT(18))];
        selectButtonWidth = size.width - 1 -kHEIGHT(29)- 8;
        UILabel * nameLabel = [UILabel new];
        [_selectButton addSubview:nameLabel];
        nameLabel.textColor = RGB(127, 127, 127);
        nameLabel.tag = 1010;
        nameLabel.font = kFONT(15);
        nameLabel.text = @"显示";
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectButton.mas_left).offset(0);
            make.centerY.equalTo(_selectButton.mas_centerY).offset(0);
            make.width.mas_equalTo(size.width + 1);
            make.height.mas_equalTo(size.height);
        }];

        UIImageView * switchImage = [UIImageView new];
        [_selectButton addSubview:switchImage];
        switchImage.tag = 1011;

        
        [switchImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(8);
            make.centerY.equalTo(_selectButton.mas_centerY).offset(0);
            make.width.mas_equalTo(kHEIGHT(29));
            make.height.mas_equalTo(kHEIGHT(18));
        }];
        [_selectButton addTarget:self action:@selector(clickSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIImageView * switchImage = [_selectButton viewWithTag:1011];
    if (self.openShowTelephone) {
        switchImage.image = IMAGENAMED(@"common_kai");
    }else{
        switchImage.image = IMAGENAMED(@"common_guan");
    }
    return _selectButton;
}

//根据textFielc的长度改变button样式
- (void)textFieldCheckWithClickButton{
    
    if (self.textFied.text.length == 11) {
        self.openShowTelephone = YES;
        UIImageView * imgView = [self.selectButton viewWithTag:1011];
        imgView.image = IMAGENAMED(@"common_kai");
        if ([self.delegate respondsToSelector:@selector(WPRecruiteCellDelegateClickeSwitchButton:)]) {
            [self.delegate WPRecruiteCellDelegateClickeSwitchButton:YES];
        }
    }else{
        self.openShowTelephone = NO;
        UIImageView * imgView = [self.selectButton viewWithTag:1011];
        imgView.image = IMAGENAMED(@"common_guan");
        if ([self.delegate respondsToSelector:@selector(WPRecruiteCellDelegateClickeSwitchButton:)]) {
            [self.delegate WPRecruiteCellDelegateClickeSwitchButton:NO];
        }
    }
}

//手动
- (void)clickSwitchButton:(id)sender{
    UIButton * button = (UIButton *)sender;
    if (self.textFied.text.length == 11) {
        if (self.openShowTelephone) {
            self.openShowTelephone = NO;
            //变为隐藏
            UIImageView * imgView = [button viewWithTag:1011];
            imgView.image = IMAGENAMED(@"common_guan");
            if ([self.delegate respondsToSelector:@selector(WPRecruiteCellDelegateClickeSwitchButton:)]) {
                [self.delegate WPRecruiteCellDelegateClickeSwitchButton:NO];
            }
        }else{
            self.openShowTelephone = YES;
            //变成显示
            UIImageView * imgView = [button viewWithTag:1011];
            imgView.image = IMAGENAMED(@"common_kai");
            if ([self.delegate respondsToSelector:@selector(WPRecruiteCellDelegateClickeSwitchButton:)]) {
                [self.delegate WPRecruiteCellDelegateClickeSwitchButton:YES];
            }
        }
    }else{
        self.openShowTelephone = NO;
        UIImageView * imgView = [self.selectButton viewWithTag:1011];
        imgView.image = IMAGENAMED(@"common_guan");
        if ([self.delegate respondsToSelector:@selector(WPRecruiteCellDelegateClickeSwitchButton:)]) {
            [self.delegate WPRecruiteCellDelegateClickeSwitchButton:NO];
        }
    }
}

#pragma mark  若名字的内容过长则截取最前面的4个字符
- (void)textFieldDidChange:(UITextField *)textField
{
    //获取键盘上的内容
    NSString * toBeString = textField.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textField markedTextRange];
        UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {

            if (toBeString.length > 4 && textField.tag != 91) {
                textField.text = [toBeString substringToIndex:4];
            }else if (textField.tag == 91){
                if (toBeString.length >= 11){
                    textField.text = [toBeString substringToIndex:11];
                }
                [self textFieldCheckWithClickButton];
            }
        }
        
        else{
           
        }
    }
    else
    {
//        if (toBeString.length > 4) {
//            textField.text = [toBeString substringToIndex:4];
//        }
        if (toBeString.length > 4 && textField.tag != 91) {
            textField.text = [toBeString substringToIndex:4];
        }else if (toBeString.length > 11){
            textField.text = [toBeString substringToIndex:11];
        }
    }
    
    //判断是否有非法字符
    BOOL isOrNot = NO;
    NSString * inLagalStr = @"-/：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&·…,^_^?!'[]{}#%^*+=•£€$<>~|_.,?!':;()""";
    NSString * textStr = textField.text;
    for (int i = 0 ; i < inLagalStr.length; i++) {
        NSRange reange = NSMakeRange(i, 1);
        NSString * ongStr = [inLagalStr substringWithRange:reange];
        for (int j = 0 ; j < textStr.length; j++) {
            NSRange range = NSMakeRange(j, 1);
            NSString * string1 = [textStr substringWithRange:range];
            if ([ongStr isEqualToString:string1]) {
                isOrNot = YES;
            }
            
        }
    }
    if (isOrNot) {
        [self removeTipViews];
        [self.contentView addSubview:self.textTipView];
        textField.text = @"";
    }
    else
    {
        [self removeTipViews];
    }
}

#pragma mark 编辑结束
-(void)textFieldDidEndEditing:(UITextField*)textField
{
//    if (textField.text.length < 2) {
//        [self removeTipViews];
//        [self.contentView addSubview:self.textTipView];
//    }
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    if ([self isHiddenWithString:title]) {
        self.mandatory.hidden = YES;
//        self.titleLabel.text = [title substringFromIndex:1];
        self.titleLabel.text = title;
    }else{
        self.mandatory.hidden = YES;
        self.titleLabel.text = title;
    }
}

- (void)textFieldIsnotNil:(BOOL)isNil
{
    NSLog(@"手机号码 == %@", self.title);
    if ([self isHiddenWithString:self.title]) {
        if (isNil) {
            [self removeTipViews];
            if ([self.title isEqualToString:@"手机号码:"]) {
                if (self.swithEnable && self.textFied.text.length >0 && ![NSString validateMobile:self.textFied.text]) {
                    self.tipView.title = @"格式错误";
                    CGFloat x = SCREEN_WIDTH-8-16-8-(self.tipView.size.width/2);
                    self.tipView.center = CGPointMake(x - 50, self.height/2);
                    [self.contentView addSubview:self.tipView];
                }else{
                    [self removeTipViews];
                }

            }else{
                self.tipView.title = @"不能为空";
                [self.contentView addSubview:self.tipView];
            }
        }else{
            [self removeTipViews];
        }
    }else{
        [self removeTipViews];
    }
    [self moreTypeForTextCell];
}

- (void)moreTypeForTextCell
{
    NSLog(@"当前的title== %@", self.title);
    if ([self.title isEqualToString:@"姓       名:"]) {
        if (_textFied.text.length>0) {
            if (_textFied.text.length < 2 || _textFied.text.length > 4) {
                [self removeTipViews];
                [self.contentView addSubview:self.textTipView];
            }else{
//                [self removeTipViews];
                //判断是否有非法字符
                BOOL isOrNot = NO;
                NSString * inLagalStr = @"{}[];:'/?>.<,=+_-)(*&^%$#@!~`123456789\0|；：‘“】}【{、|-）（……￥！·。，》《？";
                NSString * string = _textFied.text;
                for (int i = 0 ; i < inLagalStr.length; i++) {
                    NSRange reange = NSMakeRange(i, 1);
                    NSString * ongStr = [inLagalStr substringWithRange:reange];
                    for (int j = 0 ; j < string.length; j++) {
                        NSRange range = NSMakeRange(j, 1);
                        NSString * string1 = [string substringWithRange:range];
                        if ([ongStr isEqualToString:string1]) {
                            isOrNot = YES;
                        }
                        
                    }
                }
                if (isOrNot) {
                    [self removeTipViews];
                    [self.contentView addSubview:self.textTipView];
                }
                else
                {
                  [self removeTipViews];
                }
               
                
                
//                NSString * string = [NSString stringWithFormat:@"%@",_textFied.text];
//                for (int i = 0 ; i < string.length; i++) {
//                    NSRange range = NSMakeRange(i, 1);
//                    NSString * string1 = [string substringWithRange:range];
//                    BOOL isOrNot = [self isChinese:string1];
//                    if (!isOrNot) {
//                        const char * isOrNot1  = [string1 cStringUsingEncoding:NSASCIIStringEncoding];
//                        NSString * string2 = [NSString stringWithFormat:@"%s",isOrNot1];
//                        if ((string2.intValue <=60 && string2.intValue >= 41)|| (string2.intValue <=80 && string2.intValue >= 61)) {
//                           [self removeTipViews];
//                        }
//                        else
//                        {
//                            [self removeTipViews];
//                            [self.contentView addSubview:self.textTipView];
//                        }
//                    }
//                    
//                }
            }
        }
    }
}
#pragma mark 判断一个字符是不是汉字
-( BOOL )isChinese:( NSString *)c{
    int strlength = 0 ;
    char * p = ( char *)[c cStringUsingEncoding : NSUnicodeStringEncoding ];
    for ( int i= 0 ; i<[c lengthOfBytesUsingEncoding : NSUnicodeStringEncoding ] ;i++) {
        
        if (*p) {
            
            p++;
            
            strlength++;
            
        }
        else {
            p++;
        }
    }
    return ((strlength/ 2 )== 1 )? YES : NO ;
}


- (void)removeTipViews
{
    if (self.tipView.superview) {
        [self.tipView removeFromSuperview];
    }
    if (self.textTipView.superview) {
        [self.textTipView removeFromSuperview];
    }
}

- (CommonTipView *)textTipView
{
    if (!_textTipView) {
        _textTipView = [[CommonTipView alloc] init];
        _textTipView.title = @"2-4个汉字或字母";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.tipView.size.width/2);
        _textTipView.center = CGPointMake(x, self.height/2);
    }
    return _textTipView;
}

- (CommonTipView *)tipView
{
    if (!_tipView) {
        _tipView = [[CommonTipView alloc] init];
        _tipView.title = @"不能为空";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.tipView.size.width/2);
        _tipView.center = CGPointMake(x, self.height/2);
    }
    return _tipView;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textFied.placeholder = placeHolder;
    UIColor * color = RGB(170, 170, 170);
    self.textFied.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: color}];
    self.textFied.tintColor = color;
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textFied.text = text;
}

- (BOOL)isHiddenWithString:(NSString *)string
{
//    return [[string substringWithRange:NSMakeRange(0,1)] isEqualToString:@"*"];
    BOOL isOrNot = NO;
    if ([string isEqualToString:@"姓       名:"]||[string isEqualToString:@"性       别:"]||[string isEqualToString:@"出生年月:"]||[string isEqualToString:@"学       历:"]||[string isEqualToString:@"工作经验:"]||[string isEqualToString:@"手机号码:"]||[string isEqualToString:@"期望职位:"]||[string isEqualToString:@"期望薪资:"]||[string isEqualToString:@"期望地区:"]) {
        isOrNot = YES;
    }
    else
    {
        isOrNot = NO;
    }
    return isOrNot;
}

- (UITextField *)textFied
{
    if (!_textFied) {
        
        self.textFied = [[WPtextFiled alloc]initWithFrame:CGRectMake(self.titleLabel.right+6, 1, SCREEN_WIDTH-self.titleLabel.right-kHEIGHT(27), kHEIGHT(43))];
        self.textFied.font = kFONT(15);
    }
    return _textFied;
}



- (void)resignFirstResponder
{
    [self.textFied resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
