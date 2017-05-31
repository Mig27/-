//
//  SPItemView.m
//  WP
//
//  Created by CBCCBC on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPItemView.h"
#import "NSString+StringType.h"
//#import "CouldnotbenNil.h"



@interface SPItemView () <UITextFieldDelegate>
{
    BOOL isNeedTip;
    BOOL resetTitle;
}
@property (strong, nonatomic) NSString *cellType;
@property (copy, nonatomic) NSString *placeholder;



@end

@implementation SPItemView

-(void)setTitle:(NSString *)title placeholder:(NSString *)placeholder style:(NSString *)type
{
    NSLog(@"title为什么 == %@", title);
    self.backgroundColor = [UIColor whiteColor];
    _cellType = type;
    _placeholder = placeholder;
    
    
    CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
    CGSize size1 = [@"卧       槽:" getSizeWithFont:FUCKFONT(15) Height:self.height];
    CGFloat width = size.width > size1.width ? size.width : size1.width;
    
//    UIImageView *tipLbl = [[UIImageView alloc]initWithFrame:CGRectMake(FUCKFONT(10), 0, 7, 8)];
//    tipLbl.image = [UIImage imageNamed:@"bitian_neirong"];
//    tipLbl.center = CGPointMake(FUCKFONT(10)+7/2, self.frame.size.height/2);
//    tipLbl.backgroundColor = [UIColor redColor];
//    [self addSubview:tipLbl];
    
    // 包含*的，添加为空提示
    if ([self isHiddenWithString:title])
    {
//        tipLbl.hidden = YES;
//        title = [title substringFromIndex:1];
        isNeedTip = YES;
    }
    else
    {
        isNeedTip = NO;
//        tipLbl.hidden = YES;
    }
    
    if ([title isEqualToString:@"手机号码:"]) {
        isNeedTip = YES;
    }
    
    //这个lable就是必填项左侧位置
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, width, self.height)];//+ _padding*2
    
    label.text = title;
    label.font = kFONT(15);
    CGFloat leftEdge = label.right + 6;
//    label.backgroundColor = [UIColor redColor];
    if ([type isEqualToString:kCellTypeText])
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(leftEdge, 0, self.width - 120, self.height)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        
        _textField = [[WPtextFiled alloc]initWithFrame:CGRectMake(leftEdge, 1, self.width - 120, self.height)];//self.height
        UIColor *color = RGB(170, 170, 170);
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _textField.tintColor = color;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.font = kFONT(15);
        _textField.delegate = self;
       
//        _textField.backgroundColor = [UIColor redColor];
        if ([title isEqualToString:@"手       机:"] || [title isEqualToString:@"手机号码:"] ) {
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        _textField.returnKeyType = UIReturnKeyDone;
//        _textField.borderStyle= UITextBorderStyleRoundedRect;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        (self.height ? [self addSubview:_textField]:0);
        (self.height ? [self addSubview:label]     :0);
        
    }
    else if ([type isEqualToString:kCellTypeTextWithSwitch]){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(leftEdge, 0, self.width - 120, self.height)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        
        _textField = [[WPtextFiled alloc]initWithFrame:CGRectMake(leftEdge, 1, self.width - 120, self.height)];//self.height
        UIColor *color = RGB(170, 170, 170);
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
        _textField.tintColor = color;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.font = kFONT(15);
        _textField.delegate = self;
        _textField.tag = 91;
        //        _textField.backgroundColor = [UIColor redColor];
        if ([title isEqualToString:@"手       机:"] || [title isEqualToString:@"手机号码:"] ) {
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        _textField.returnKeyType = UIReturnKeyDone;
        //        _textField.borderStyle= UITextBorderStyleRoundedRect;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        
        
        (self.height ? [self addSubview:_textField]:0);
        (self.height ? [self addSubview:label]     :0);
        //再添加一个switch button在右侧
        (self.height ? [self addSubview:self.selectButton]:0);
    }
    else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.width, self.height);
        [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonItemClick) forControlEvents:UIControlEventTouchUpInside];
        
        (self.height?[self addSubview:button]:0);
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.enabled = NO;
        _button.frame = CGRectMake(leftEdge, 0, self.width-100-40, self.height);
        _button.titleLabel.font = kFONT(15);
        [_button setTitle:placeholder forState:UIControlStateNormal];
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        //[_button addTarget:self action:@selector(buttonItemClick) forControlEvents:UIControlEventTouchUpInside];
        (self.height?[button addSubview:_button]:0);
        
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        _rightImageView.frame = CGRectMake(self.width-kHEIGHT(12)-8, self.height/2-7, 8,14);
        //        [self addSubview:_rightImageView];
        (self.height?[button addSubview:_rightImageView]:0);
        
        (self.height?[button addSubview:label]:0);
        
        //UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        //button1.frame = CGRectMake(0, 0, leftEdge, self.height);
        //[button1 addTarget:self action:@selector(buttonItemClick) forControlEvents:UIControlEventTouchUpInside];
        //(self.height?[self addSubview:button1]:0);
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    (self.height?[self addSubview:line]:0);
  
}

//kHEIGHT(43)
- (UIButton *)selectButton{
    if (!_selectButton) {
        NSString * tempString = @"显示";
        CGSize size = [tempString getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(18)];
        _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-size.width - 1 -kHEIGHT(29)- 8 -kHEIGHT(12), (self.height- kHEIGHT(19))/2,size.width + 1 +kHEIGHT(29)+ 8,kHEIGHT(18))];
        //selectButtonWidth = size.width - 1 -kHEIGHT(29)- 8;
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
    
    if (_textField.text.length == 11) {
        self.openShowTelephone = YES;
        UIImageView * imgView = [self.selectButton viewWithTag:1011];
        imgView.image = IMAGENAMED(@"common_kai");
        if ([self.delegate respondsToSelector:@selector(SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:)]) {
            [self.delegate SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:YES];
        }
    }else{
        self.openShowTelephone = NO;
        UIImageView * imgView = [self.selectButton viewWithTag:1011];
        imgView.image = IMAGENAMED(@"common_guan");
        if ([self.delegate respondsToSelector:@selector(SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:)]) {
            [self.delegate SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:NO];
        }
    }
}

//手动
- (void)clickSwitchButton:(id)sender{
    UIButton * button = (UIButton *)sender;
    if (_textField.text.length == 11) {
        if (self.openShowTelephone) {
            self.openShowTelephone = NO;
            //变为隐藏
            UIImageView * imgView = [button viewWithTag:1011];
            imgView.image = IMAGENAMED(@"common_guan");
            if ([self.delegate respondsToSelector:@selector(SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:)]) {
                [self.delegate SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:NO];
            }
        }else{
            self.openShowTelephone = YES;
            //变成显示
            UIImageView * imgView = [button viewWithTag:1011];
            imgView.image = IMAGENAMED(@"common_kai");
            if ([self.delegate respondsToSelector:@selector(SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:)]) {
                [self.delegate SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:YES];
            }
        }
    }else{
        self.openShowTelephone = NO;
        UIImageView * imgView = [self.selectButton viewWithTag:1011];
        imgView.image = IMAGENAMED(@"common_guan");
        if ([self.delegate respondsToSelector:@selector(SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:)]) {
            [self.delegate SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:NO];
        }
    }
}


-(void)textFieldDidChange:(UITextField*)text
{
//    UIScrollView * scroller = text.superview;
//    [text.superview setNeedsUpdateConstraints];
//    [UIView animateWithDuration:0.1 animations:^{
//        [text.superview updateConstraintsIfNeeded];
//    }];
     [text invalidateIntrinsicContentSize];
   
    //获取键盘上的内容
//    NSString * toBeString = text.text;
//    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange * selectedRange = [text markedTextRange];
//        UITextPosition * position = [text positionFromPosition:selectedRange.start offset:0];
//        if (!position) {
//            if (toBeString.length > 4) {
//                text.text = [toBeString substringToIndex:4];
//            }
//        }
//        
//        else{
//            
//        }
//    }
//    else
//    {
//        if (toBeString.length > 4) {
//            text.text = [toBeString substringToIndex:4];
//        }
//    }
    
    //获取键盘上的内容
    NSString * toBeString = text.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [text markedTextRange];
        UITextPosition * position = [text positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            
            if (toBeString.length > 4 && text.tag != 91) {
                text.text = [toBeString substringToIndex:4];
            }else if (text.tag == 91){
                if (toBeString.length >= 11){
                    text.text = [toBeString substringToIndex:11];
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
        if (toBeString.length > 4 && text.tag != 91) {
            text.text = [toBeString substringToIndex:4];
        }else if (toBeString.length > 11){
            text.text = [toBeString substringToIndex:11];
        }
    }
    
    
    
    
    
//    //判断是否有非法字符
    BOOL isOrNot = NO;//-/：；（）¥@“”。，、？！.【】｛｝#%^*+=_—\|～《》$&·…,^_^?!'[]{}#%^*+=•£€$<>~|\_.,?!'
//    NSString * inLagalStr = @"{}[];:'/?>.<,=+_-)\(*&^%$#@!~`1234567890|；：‘“”】}【{、|-）（……￥！·。，》《？•";
    NSString * inLagalStr = @"-/：；¥@“”。，、？！【】｛｝#%^*+=_—|～《》$·…,^_^?!'[]{}#%^*+=•£€$<>~|_,?!':;""";
    NSString * textStr = text.text;
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
//        [self removeTipViews];
//        [self addSubview:self.textTipView];
        if (!self.isName) {
          text.text = [text.text substringToIndex:text.text.length-1];  
        }
//        text.text = [text.text substringToIndex:text.text.length-1];
    }
    else
    {
//        [self removeTipViews];
    }

    if (self.textChanged) {
        self.textChanged(self.title);
    }
}

- (void)removeTipViews
{
    if (self.tipView.superview) {
        [self.tipView removeFromSuperview];
    }
    if (self.textTipView.superview) {
        [self.textTipView removeFromSuperview];
    }
    if (self.telTipView.superview) {
        [self.telTipView removeFromSuperview];
    }
}

- (CommonTipView *)textTipView
{
    if (!_textTipView) {
        _textTipView = [[CommonTipView alloc] init];
        _textTipView.title = @"2-4个汉字或字母";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.textTipView.size.width/2);
        _textTipView.center = CGPointMake(x, self.height/2);
    }
    return _textTipView;
}

- (BOOL)textFieldIsnotNil
{
    BOOL commit = NO;
    
    if ([_cellType isEqualToString:kCellTypeText]) {
        if ((self.textField.text.length == 0) && isNeedTip) {
            
            [self addSubview:self.tipView];
            commit = YES;
        }
    }
    else if ([_cellType isEqualToString:kCellTypeTextWithSwitch]) {
        if ((self.textField.text.length >0) && isNeedTip && ![NSString validateMobile:self.textField.text]) {
            
            [self addSubview:self.telTipView];
            commit = YES;
        }
    }
    else{
        if (!resetTitle && isNeedTip) {
            [self addSubview:self.tipView];
            commit = YES;
        }
    }
    return commit;
}

//提示必填项不能为空
- (CommonTipView *)tipView
{
    if (!_tipView) {
        
        _tipView = [[CommonTipView alloc] init];
        
        _tipView.title = @"不能为空";
        
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.tipView.size.width/2);
        _tipView.center = CGPointMake(x, self.frame.size.height/2);
    }
    
    return _tipView;
}

//提示必填项不能为空
- (CommonTipView *)telTipView
{
    if (!_telTipView) {
        
        _telTipView = [[CommonTipView alloc] init];
        
        _telTipView.title = @"格式错误";
        
        CGFloat x = SCREEN_WIDTH-8-16-8-(_telTipView.size.width/2);
        _telTipView.center = CGPointMake(x - 50, self.frame.size.height/2);
    }
    
    return _telTipView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.tipView superview]) {
        [self.tipView removeFromSuperview];
    }
    if ([self.telTipView superview]) {
        [self.telTipView removeFromSuperview];
    }
 
    return YES;
}

// 包含*的，添加为空提示
- (BOOL)isHiddenWithString:(NSString *)string
{
    if (_personalInfo)//在个人资料中的
    {
        return [string isEqualToString:@"所在企业:"]||[string isEqualToString:@"姓       名:"]||[string isEqualToString:@"职       位:"]||[string isEqualToString:@"生       日:"];
    }
    else
    {
     return [string isEqualToString:@"企业名称:"]||[string isEqualToString:@"企业行业:"]||[string isEqualToString:@"企业性质:"]||[string isEqualToString:@"企业规模:"]||[string isEqualToString:@"企业区域:"]||[string isEqualToString:@"联  系 人:"]||[string isEqualToString:@"招聘职位:"]||[string isEqualToString:@"工资待遇:"]||[string isEqualToString:@"工作经验:"]||[string isEqualToString:@"招聘人数:"]||[string isEqualToString:@"工作区域:"]||[string isEqualToString:@"详细地点:"]||[string isEqualToString:@"姓       名:"]||[string isEqualToString:@"详细地址:"]||[string isEqualToString:@"性       别:"]||[string isEqualToString:@"出生年月:"]||[string isEqualToString:@"学       历:"];
    }
}

//- (CouldnotbenNil *)rightView
//{
//    if (!_rightView) {
//        self.rightView = [[CouldnotbenNil alloc]init];
//        self.rightView.title = @"不能为空";
//        CGFloat x = SCREEN_WIDTH-8-16-8-(self.rightView.size.width/2);
//        self.rightView.center = CGPointMake(x, self.frame.size.height/2);
//    }
//    return _rightView;
//}


#pragma mark -
-(void)buttonItemClick
{
    [_textField resignFirstResponder];
    if (self.SPItemBlock) {
        self.SPItemBlock(self.tag);     // 将view的tag 传进去
    }
}

-(NSString *)title
{
    if ([_cellType isEqualToString:kCellTypeText] || [_cellType isEqualToString:kCellTypeTextWithSwitch]) {
        _title = _textField.text;
    }else{
        _title = _button.titleLabel.text;
    }
    return _title;
}

-(void)resetTitle:(NSString *)title
{
    if ([_cellType isEqualToString:kCellTypeText]) {
        _textField.text = title;
        if (![title isEqualToString:@""]) {
            [self.tipView removeFromSuperview];
        }
    }else if ([_cellType isEqualToString:kCellTypeTextWithSwitch]) {
        _textField.text = title;
        if (![title isEqualToString:@""] && [NSString validateMobile:title]) {
            [self.telTipView removeFromSuperview];
        }
    }else {
        if ([title isEqualToString:@""]) {
            [_button setTitle:_placeholder forState:UIControlStateNormal];
            [_button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        }else{
            [_button setTitle:title forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            resetTitle = YES;
            [self.tipView removeFromSuperview];
        }
    }
}


- (void)resetPlacehoder:(NSString *)placehoder
{
    if ([_cellType isEqualToString:kCellTypeText]) {
        _textField.placeholder = placehoder;
    }else{
        [_button setTitle:placehoder forState:UIControlStateNormal];
        [_button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    }
}


-(void)deleteTitle:(NSString *)title
{
    if ([_cellType isEqualToString:kCellTypeText]) {
        _textField.text = title;
    }else{
        [_button setTitle:title forState:UIControlStateNormal];
        [_button setTitleColor:RGB(205, 205, 205) forState:UIControlStateNormal];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.showToFont) {
        self.showToFont();
    }

//    for (UIView * view  in textField.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            UIScrollView * scroller = (UIScrollView*)view;
//        }
//    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.hideFromFont)
    {
        self.hideFromFont(self.tag,self.title);
    }
}



@end
