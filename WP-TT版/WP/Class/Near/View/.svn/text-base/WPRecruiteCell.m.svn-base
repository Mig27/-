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
@interface WPRecruiteCell ()
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIImageView *mandatory;
@property (nonatomic , strong)UIImageView *image;
@property (nonatomic , strong)CommonTipView *tipView;
@property (nonatomic , strong)CommonTipView *textTipView;
//@property (nonatomic , strong)UIImageView *image;
@end

@implementation WPRecruiteCell

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
            if (toBeString.length > 4) {
                textField.text = [toBeString substringToIndex:4];
            }
        }
        
        else{
           
        }
    }
    else
    {
        if (toBeString.length > 4) {
            textField.text = [toBeString substringToIndex:4];
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
    if ([self isHiddenWithString:self.title]) {
        if (isNil) {
            [self removeTipViews];
            [self.contentView addSubview:self.tipView];
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
    if ([string isEqualToString:@"姓       名:"]||[string isEqualToString:@"性       别:"]||[string isEqualToString:@"出生年月:"]||[string isEqualToString:@"学       历:"]||[string isEqualToString:@"工作经验:"]||[string isEqualToString:@"期望职位:"]||[string isEqualToString:@"期望薪资:"]||[string isEqualToString:@"期望地区:"]) {
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
