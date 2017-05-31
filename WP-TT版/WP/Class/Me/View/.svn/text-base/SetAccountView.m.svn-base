//
//  SetAccountView.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "SetAccountView.h"
#import "PersonalView.h"
#import "BaseModel.h"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"

@interface SetAccountView ()<UITextFieldDelegate>
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *testLabel;
@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong)UILabel *attentionLabel;
@property (nonatomic, strong)UIView *view;
@property (nonatomic , strong)PersonalModel *model;
@end

@implementation SetAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.view];
        [self addSubview:self.textField];
        [self addSubview:self.attentionLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.testLabel];
        [self getDatas];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(54), kHEIGHT(54))];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
//        self.imageView.backgroundColor = [UIColor redColor];
//        self.imageView.image = kShareModel.headImage;
    }
    return _imageView;
}

- (UILabel *)testLabel
{
    if (!_testLabel) {
        CGFloat width = SCREEN_WIDTH - self.imageView.right - kHEIGHT(10);
        self.testLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageView.right+kHEIGHT(10), self.imageView.center.y+8, width, kHEIGHT(12))];
        self.testLabel.text = @"微聘号:";
        self.testLabel.font = kFONT(12);
        self.testLabel.textColor = RGB(127, 127, 127);
    }
    return _testLabel;
}

- (void)getDatas
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *dic = @{@"action":@"userinfo",@"username":model.username,@"password":model.password,@"user_id":model.userId};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        self.model = [PersonalModel mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)setModel:(PersonalModel *)model
{
    _model = model;
    if (_model.photoWallArr.count != 0) {
        
        Pohotolist *photoModel = _model.photoWallArr[0];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:photoModel.thumb_path]] placeholderImage:[UIImage imageNamed:@"head_default"]];
    }
    if ([_model.nicknameStr isEqualToString:@""]) {
        self.nameLabel.text = self.model.nameStr;
    }else{
        self.nameLabel.text = self.model.nicknameStr;
    }

}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        CGFloat width = SCREEN_WIDTH - self.imageView.right - kHEIGHT(10);
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageView.right+kHEIGHT(10), self.imageView.center.y-18, width, kHEIGHT(15))];
        self.nameLabel.font = kFONT(15);
        self.nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)attentionLabel
{
    if (!_attentionLabel) {
        self.attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(117), SCREEN_WIDTH-kHEIGHT(20), kHEIGHT(40))];
        self.attentionLabel.textColor = RGB(127, 127, 127);
        self.attentionLabel.text = @"注意:账号一旦确认,将不能修改!";
        self.attentionLabel.font = kFONT(12);
    }
    return _attentionLabel;
}
- (UIView *)view
{
    if (!_view) {
        self.view = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(74), SCREEN_WIDTH, kHEIGHT(43))];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return _view;
}

- (UITextField *)textField
{
    if (!_textField) {
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(74), SCREEN_WIDTH-kHEIGHT(20), kHEIGHT(43))];
        self.textField.delegate = self;
        self.textField.placeholder = @"微聘号";
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([self.textField.text length]>=6) {
        [self useEntrustWithSelected:YES];
    }else{
        [self useEntrustWithSelected:NO];
    }
    if (textField == self.textField) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
    self.testLabel.text = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%lu,%lu,%@",(unsigned long)range.length,(unsigned long)range.location,string);
    if (range.location == 0) {
        BOOL is_right = [self screeningRightWordWithString:string];
        [self changeColorAndTextWith:is_right];
        return YES;
    }
    
    for (int i = 0; i < range.location; i ++) {
        NSString *str = [textField.text substringWithRange:NSMakeRange(i, 1)];
        NSLog(@"%@",str);
        BOOL canChange = [self screeningRightWordWithString:str];
        if (canChange) {
            NSLog(@"%d",canChange);
            [self rightWord];
        }else{
            [self errorWord];
            return YES;
        }
    }
    if (!range.length) {
        BOOL canChange = [self screeningRightWordWithString:string];
        if (canChange) {
            NSLog(@"%d",canChange);
            [self rightWord];
        }else{
            [self errorWord];
            return YES;
        }
    }
    
    return YES;
}

- (void)changeColorAndTextWith:(BOOL)canChange
{
    if (canChange) {
        [self rightWord];
    }else{
        [self errorWord];
    }
}

- (void)errorWord
{
    self.attentionLabel.text = @"支持6-20为字母.数字.减号和下划线,以字母开头";
    self.attentionLabel.textColor = RGB(240, 43, 43);
    [self useEntrustWithSelected:NO];
}

- (void)rightWord
{
    self.attentionLabel.text = @"注意:账号一旦确认,将不能修改!";
    self.attentionLabel.textColor = RGB(127, 127, 127);
    [self useEntrustWithSelected:YES];
}

- (BOOL)screeningRightWordWithString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}

- (void)useEntrustWithSelected:(BOOL)selected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeToFinishEditingWithSelected:)]) {
        [self.delegate timeToFinishEditingWithSelected:selected];
    }
}










@end
