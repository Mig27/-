
//  Created by Caoyq on 16/5/10.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import "HCInputBar.h"
#import "HCHeader.h"
#import "ExpandingCell.h"

#define BOOKMARK_WORD_LIMIT 300

@interface HCInputBar ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *expandingView;
@property (assign, nonatomic) InputBarStyle style;

@property (strong, nonatomic) NSMutableArray *imgAry;
@property (strong, nonatomic) NSMutableArray *selectedImgAry;
@property (assign, nonatomic) NSInteger PreSelectedRow;
@property (assign, nonatomic) NSInteger selectedRow;

/**< textView的placeHodle */
@property (strong, nonatomic) UILabel *placeHolderLabel;

@end
@implementation HCInputBar

- (instancetype)initWithStyle:(InputBarStyle)style {
    _style = style;
    CGFloat height;
    if (_style == ExpandingInputBarStyle) {
        height = kInputBarHeight+kExpandingHeight;
    }else{
        height = kInputBarHeight;
    }
    self = [super initWithFrame:CGRectMake(-0.5, ScreenHeight-height, ScreenWidth+1, height)];
    self.backgroundColor = [UIColor backgroundColor];
    self.layer.borderColor = RGB(178, 178, 178).CGColor;//[[UIColor bigBorderColor] CGColor]
    self.layer.borderWidth = 0.5;
    
    if (self) {
        _keyboard = [HCEmojiKeyboard sharedKeyboard];
        [_keyboard sendEmojis:^{
            [self didClickSendEmojis];
        }];
        [self addSubview:self.inputView];
        [self addSubview:self.placeHolderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _PreSelectedRow = kPreSelectedRow;
    _selectedRow = kSelectedRow;
    [self getImgData];
    if (_style == ExpandingInputBarStyle) {
        [self addSubview:self.expandingView];
    }else{
        [self addSubview:self.keyboardTypeBtn];
    }
}


#pragma mark - load
- (UIButton *)keyboardTypeBtn {
    if (!_keyboardTypeBtn) {
        _keyboardTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kInputViewWidth + kInputViewOtherX, 0, kKeyboardWidth + kInputViewOtherX*2, kInputBarHeight)];
        _keyboardTypeBtn.tag = 0;
        //        _keyboardTypeBtn.backgroundColor = [UIColor redColor];
        [_keyboardTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(11, kInputViewOtherX, 11, kInputViewOtherX)];
        [_keyboardTypeBtn setImage:ImgName(emoji) forState:UIControlStateNormal];
        [_keyboardTypeBtn addTarget:self action:@selector(ClickedKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyboardTypeBtn;
}

- (UITextView *)inputView {
    if (!_inputView) {
        if (_style == ExpandingInputBarStyle) {
            _inputView = [[UITextView alloc]initWithFrame:CGRectMake(kInputViewOtherX, kInputViewY, kInputViewOtherWidth, kInputViewHeight)];
        }else{
            _inputView = [[UITextView alloc]initWithFrame:CGRectMake(kInputViewOtherX, kInputViewY, kInputViewWidth, kInputViewHeight)];
        }
        _inputView.returnKeyType = UIReturnKeySend;
        _inputView.showsVerticalScrollIndicator = NO;
        _inputView.scrollEnabled = NO;
        _inputView.delegate = self;
        _inputView.font = [UIFont inputViewFont];
        _inputView.backgroundColor = [UIColor whiteColor];
        //        _inputView.backgroundColor = [UIColor greenColor];
        
        
        
        
        [self setBorderinView:_inputView CornerRadius:7 Color:RGB(178, 178, 178)];//[UIColor borderColor]
    }
    return _inputView;
}
- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        if (_style == ExpandingInputBarStyle) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(kInputViewOtherX+kKeyboardX, kInputViewY, kInputViewOtherWidth-kKeyboardX, kInputViewHeight)];
        }else{
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(kInputViewOtherX+kKeyboardX, kInputViewY, kInputViewWidth-kKeyboardX, kInputViewHeight)];
        }
        _placeHolderLabel.adjustsFontSizeToFitWidth = YES;
        _placeHolderLabel.font = [UIFont inputViewFont];
        _placeHolderLabel.minimumScaleFactor = 0.9;
        _placeHolderLabel.textColor = [UIColor sendTitleNormalColor];
        _placeHolderLabel.userInteractionEnabled = NO;
        _placeHolderLabel.text = _placeHolder;
        //        _placeHolderLabel.backgroundColor = [UIColor redColor];
        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPlaceLabel)];
        //        [_placeHolderLabel addGestureRecognizer:tap];
    }
    return _placeHolderLabel;
}
-(void)clickPlaceLabel
{
    //    NSLog(@"hahahahahahahahhabjabsjdf");
    if (self.inputView.inputView) {
        [self ClickedKeyboard:_keyboardTypeBtn];
    }
    
}
- (UICollectionView *)expandingView {
    if (!_expandingView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat space = (ScreenWidth-self.imgAry.count*kItemSize)/(self.imgAry.count+1)-0.01;
        [layout setItemSize:CGSizeMake(kItemSize, kItemSize)];
        layout.minimumInteritemSpacing = space;
        [layout setSectionInset:UIEdgeInsetsMake(kTopSpace, space, kBottomSpace, space)];
        _expandingView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kInputBarHeight, ScreenWidth, kExpandingHeight) collectionViewLayout:layout];
        _expandingView.delegate = self;
        _expandingView.dataSource = self;
        _expandingView.backgroundColor = [UIColor backgroundColor];
        [_expandingView registerClass:[ExpandingCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _expandingView;
}

- (void)getImgData {
    if (!_expandingAry || _expandingAry.count == 0) {
        _imgAry = [NSMutableArray arrayWithObjects:voice,video,photo,camera,emoji, nil];
        _selectedImgAry = [NSMutableArray arrayWithObjects:selectedVoice,selectedVideo,selectedPhoto,selectedCamera,selectedEmoji, nil];
    }else{
        _imgAry = [NSMutableArray new];
        _selectedImgAry = [NSMutableArray new];
        for (NSNumber *number in _expandingAry){
            NSInteger img = [number integerValue];
            NSString *showImg = [NSString new];
            NSString *selectedImg = [NSString new];
            switch (img) {
                case ImgStyleWithVoice:{
                    showImg = voice;
                    selectedImg = selectedVoice;
                }
                    break;
                case ImgStyleWithVideo:{
                    showImg = video;
                    selectedImg = selectedVideo;
                }
                    break;
                case ImgStyleWithPhoto:{
                    showImg = photo;
                    selectedImg = selectedPhoto;
                }
                    break;
                case ImgStyleWithCamera:{
                    showImg = camera;
                    selectedImg = selectedCamera;
                }
                    break;
                case ImgStyleWithEmoji:{
                    showImg = emoji;
                    selectedImg = selectedEmoji;
                }
                    break;
                default:
                    break;
            }
            [_imgAry addObject:showImg];
            [_selectedImgAry addObject:selectedImg];
        }
    }
}


#pragma mark - Set 方法
//接口处.placeHolder 会调用set方法
- (void)setPlaceHolder:(NSString *)placeHolder {
    self.placeHolderLabel.text = placeHolder;
}

static int  i = 0;
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{

    if (_keyboardTypeBtn.tag && i == 1) {
        i = 3;
      [self ClickedKeyboard:_keyboardTypeBtn];
    }
    return NO;
}

#pragma mark - click 点击切换表情和键盘
- (void)ClickedKeyboard:(UIButton *)btn {
    [self judgeStatue];
    if (btn.tag == 0) { //文字键盘 --> 转表情键盘
        i = 1;
        //        _placeHolderLabel.userInteractionEnabled = YES;
        [_keyboard setTextInput:_inputView];
        [btn setImage:ImgName(keyboard) forState:UIControlStateNormal];
    }else{              //表情键盘 ---> 转文字键盘

        //        _placeHolderLabel.userInteractionEnabled = NO;
        _inputView.inputView = nil;
        [btn setImage:ImgName(emoji) forState:UIControlStateNormal];
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        [UIMenuController sharedMenuController].arrowDirection = UIMenuControllerArrowLeft;
    }
    [_inputView reloadInputViews];
    btn.tag = btn.tag == 0 ? 1 : 0;
    [_inputView becomeFirstResponder];
}


- (void)judgeStatue
{
    if (_inputView.text.length > 0) {
        _keyboard.emojiToolBar.sendBtn.enabled = YES;
        [_keyboard.emojiToolBar.sendBtn setTitleColor:[UIColor sendTitleHighlightedColor] forState:UIControlStateNormal];
        _keyboard.emojiToolBar.sendBtn.backgroundColor = [UIColor sendBgHighlightedColor];
    }
}

#pragma mark 点击发送按钮
- (void)didClickSendEmojis {
    if (_inputView.text.length == 0) {
        return;
    }
    _keyboardTypeBtn.tag = 0;
    //    [_keyboard setTextInput:_inputView];
    //    [_keyboardTypeBtn setImage:ImgName(emoji) forState:UIControlStateNormal];
    //    [_inputView reloadInputViews];
    
#pragma mark 键盘注释
    //    [self ClickedKeyboard:_keyboardTypeBtn];
    [self.inputView resignFirstResponder];
    if (self.block) {
        self.block(_inputView.text);
    }
    _inputView.text = @"";
    [self layout];
}

#pragma mark - set border
- (void)setBorderinView:(UIView *)view CornerRadius:(CGFloat)f Color:(UIColor *)color{
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = f;
}

#pragma mark - 随着文字增多，改变布局
- (void)layout {
    
    _placeHolderLabel.hidden = _inputView.text.length > 0 ? YES : NO;
    CGSize textSize = [_inputView sizeThatFits:CGSizeMake(CGRectGetWidth(_inputView.frame), MAXFLOAT)];
    CGFloat offset = 10;
    _inputView.scrollEnabled = (textSize.height > kInputViewMaxHeight - offset);
    [_inputView setHeight:MAX(kInputViewHeight, MIN(kInputViewMaxHeight, textSize.height))];
    [_expandingView setY:CGRectGetHeight(_inputView.frame)+CGRectGetMinY(_inputView.frame)*2];
    //此时的self.frame.origin.y已经改变了，因为键盘升起
    CGFloat maxY = CGRectGetMaxY(self.frame);
    [self setHeight:CGRectGetHeight(_inputView.frame)+CGRectGetMinY(_inputView.frame)*2+CGRectGetHeight(_expandingView.frame)];
    [self setY:maxY - CGRectGetHeight(self.frame)];
    _keyboardTypeBtn.center = CGPointMake(CGRectGetMidX(_keyboardTypeBtn.frame), CGRectGetHeight(self.frame)/2);
}

#pragma mark - 块方法

- (void)showInputViewContents:(InputViewContents)string {
    self.block = string;
}

#pragma mark - 收到通知、监控键盘

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         CGRect newInputViewFrame = self.frame;
                         newInputViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.frame)-kbSize.height;
                         self.frame = newInputViewFrame;
                     }
                     completion:nil];
    //    if (self.isHidden) {
    //        self.hidden = NO;
    //    }
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
    //                          delay:0
    //                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
    //                     animations:^{
    //                         self.center = CGPointMake(self.bounds.size.width/2.0f, height-CGRectGetHeight(self.frame)/2.0);
    //                     }
    //                     completion:nil];
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         self.center = CGPointMake(self.bounds.size.width/2.0f, height-CGRectGetHeight(self.frame)/2.0);
                     } completion:^(BOOL finished) {
                         if (self.keyBoardHidden) {
                             self.keyBoardHidden();
                         }
                     }];
    //    if (self.isHidden) {
    //        self.hidden = YES;
    //    }
    //    if (self.keyBoardHidden) {
    //        self.keyBoardHidden();
    //    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    //    if (textView.text.length > BOOKMARK_WORD_LIMIT)
    //    {
    //        [MBProgressHUD createHUD:@"评论字数最多不能超过300!" View:[UIApplication sharedApplication].keyWindow];
    //        textView.text = [textView.text substringToIndex:BOOKMARK_WORD_LIMIT];
    //    }
    NSInteger value=textView.text.length;
    //高亮不进入统计 避免未输入的中文在拼音状态被统计入总长度限制
    value -= [textView textInRange:[textView markedTextRange]].length;
    if (value<=BOOKMARK_WORD_LIMIT) {
        //        NSLog(@"%@",[NSString stringWithFormat:@"%d/%d",(int)value,BOOKMARK_WORD_LIMIT]);
    } else {
        //        [MBProgressHUD createHUD:@"评论字数最多不能超过300!" View:[UIApplication sharedApplication].keyWindow];
        //截断长度限制以后的字符 避免截断字符
        NSString *tempStr = [textView.text substringWithRange:[textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, BOOKMARK_WORD_LIMIT)]];
        textView.text=tempStr;
    }
    [self layout];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //    if (!_inputView.inputView) {
    //      [self ClickedKeyboard:_keyboardTypeBtn];
    //    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"hahaha");
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //点击系统键盘上的表情
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        //        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        //点击系统键盘上的发送
        [self didClickSendEmojis];
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text,text];
    if (str.length > BOOKMARK_WORD_LIMIT)
    {
        //        [MBProgressHUD createHUD:@"评论字数最多不能超过300!" View:[UIApplication sharedApplication].keyWindow];
        textView.text = [str substringToIndex:BOOKMARK_WORD_LIMIT];
        return NO;
    }
    
    return YES;
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ExpandingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imgView.image = ImgName(_imgAry[indexPath.row]);
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //对上一个选择的cell作处理
    if (_PreSelectedRow != indexPath.row && _PreSelectedRow != kPreSelectedRow) {
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:_PreSelectedRow inSection:0];
        ExpandingCell *cell = (ExpandingCell *)[_expandingView cellForItemAtIndexPath:preIndexPath];
        cell.imgView.image = ImgName(_imgAry[_PreSelectedRow]);
    }
    //对当前选中cell作处理
    ExpandingCell *cell = (ExpandingCell *)[_expandingView cellForItemAtIndexPath:indexPath];
    if (_selectedRow != indexPath.row) {
        _selectedRow = indexPath.row;
        cell.imgView.image = ImgName(_selectedImgAry[indexPath.row]);
    }else{
        _selectedRow = kSelectedRow;
        cell.imgView.image = ImgName(_imgAry[indexPath.row]);
    }
    
    //选中对应cell，确定做的事
    if ([_imgAry[indexPath.row] isEqualToString:voice]) {
        NSLog(@"语音处理");
        [self handleVoice:_selectedRow];
    }else if ([_imgAry[indexPath.row] isEqualToString:video]){
        NSLog(@"视频处理");
    }else if ([_imgAry[indexPath.row] isEqualToString:photo]){
        NSLog(@"照片处理");
    }else if ([_imgAry[indexPath.row] isEqualToString:camera]){
        NSLog(@"相机处理");
    }else if ([_imgAry[indexPath.row] isEqualToString:emoji]){
        NSLog(@"表情处理");
        [self handleEmoji:_selectedRow];
    }
    
    //
    _PreSelectedRow = indexPath.row;
    
}

#pragma mark - cell点击之后的处理事件
- (void)handleVoice:(NSInteger)selected {
    if (selected == kSelectedRow) {
        //取消
        
    }else{
        //开启
        
    }
}

- (void)handleVideo:(NSInteger)selected {
    if (selected == kSelectedRow) {
        //取消
        
    }else{
        //开启
        
    }
}

- (void)handlePhoto:(NSInteger)selected {
    if (selected == kSelectedRow) {
        //取消
        
    }else{
        //开启
        
    }
}

- (void)handleCamera:(NSInteger)selected {
    if (selected == kSelectedRow) {
        //取消
        
    }else{
        //开启
        
    }
}

- (void)handleEmoji:(NSInteger)selected {
    if (selected == kSelectedRow) {
        //取消
        _inputView.inputView = nil;
    }else{
        //开启
        [_keyboard setTextInput:_inputView];
    }
    [_inputView reloadInputViews];
    [_inputView becomeFirstResponder];
}

@end
