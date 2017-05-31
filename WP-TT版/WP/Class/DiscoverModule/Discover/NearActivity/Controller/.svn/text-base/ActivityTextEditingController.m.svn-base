//
//  ActivityTextEditingController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/18.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityTextEditingController.h"
#import "RichTextEditor.h"
#import "MBProgressHUD+MJ.h"

@interface ActivityTextEditingController ()<UIAlertViewDelegate,UITextViewDelegate>

//@property (nonatomic,strong) RichTextEditor *editor;

@end

@implementation ActivityTextEditingController
{
    RichTextEditor *_editor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setTranslucent:NO];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUI];
    
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [_editor resignFirstResponder];
//}
- (void)createUI
{
    if ([self.title isEqualToString:@"专业描述"]) {
        
    }
    else if([self.title isEqualToString:@"职位描述"])
    {
        
    }
    else if ([self.title isEqualToString:@"任职要求"])
    {
     
    }
    else if ([self.title isEqualToString:@"企业描述"])
    {
      
    }
    else if ([self.title isEqualToString:@"企业简介"])
    {
    
    }
    else
    {
     self.title = @"亮点描述";
    }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scroll];
    _editor = [[RichTextEditor alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-kHEIGHT(10)*2, SCREEN_HEIGHT - 216 - 64)];
    _editor.placeholder = @"写点什么...";
    if (self.textFieldString.length) {
        _editor.text = self.textFieldString;
    }
    _editor.delegate = self;
    _editor.font = kFONT(15);
//    [_editor setBorderColor:[UIColor lightGrayColor]];
//    [_editor setBorderWidth:0.5];
    [scroll addSubview:_editor];
    if (self.attributedString.length >0) {
        _editor.attributedText = self.attributedString;
    }
    [_editor becomeFirstResponder];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
//    NSString * textStr = textView.text;
//    NSArray * array = [textStr componentsSeparatedByString:@" "];
//    int begin = 0;
//    int end = 0;
//    for (int i = 0 ; i < array.count; i++) {
//        NSString * string = [NSString stringWithFormat:@"%@",array[i]];
//        if ( [string isEqualToString:@" "]) {
//            continue;
//        }
//        else
//        {
//            begin = i;
//            break;
//        }
//    }
//    
//    for ( int i = (int)array.count-1; i < array.count; i--) {
//        NSString * string = [NSString stringWithFormat:@"%@",array[i]];
//        if ([string isEqualToString:@" "]) {
//            continue;
//        }
//        else
//        {
//            end = i;
//            break;
//        }
//    }
//    if (begin == 0 && end == 0) {
//        textView.text = textStr;
//    }
//    else if (begin == 0 && end != 0)
//    {
//        NSString * string = @"";
//        for (int i = 0 ; i <array.count-end+1; i++) {
//            string = [NSString stringWithFormat:@"%@%@",string,array[i]];
//        }
//        textView.text = string;
//    }
//    else if (begin != 0 && end == 0)
//    {
//      NSString * string = @"";
//        for (int i = begin; i < array.count; i++) {
//            string = [NSString stringWithFormat:@"%@%@",string,array[i]];
//        }
//        textView.text = string;
//    }
//    else
//    {
//     NSString  * string = @"";
//        for (int i = begin ; i < end; i++) {
//            string = [NSString stringWithFormat:@"%@%@",string,array[i]];
//        }
//        textView.text = string;
//        
//    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
//    NSString * toBeString = textView.text;
//    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange * selectedRange = [textView markedTextRange];
//        UITextPosition * position = [textView positionFromPosition:selectedRange.start offset:0];
//        if (!position) {
//            NSArray * array = [toBeString componentsSeparatedByString:@" "];
//            NSInteger begin= 0;
//            NSInteger end = 0;
//            for (int i = 0 ; i < array.count; i++) {
//                NSString * string = [NSString stringWithFormat:@"%@",array[i]];
//                if ([string isEqualToString:@" "]) {
//                    continue;
//                }
//                else
//                {
//                    begin = i;
//                    break;
//                }
//            }
//            
//            for (int i = (int)array.count-1 ; i < array.count; i--) {
//                NSString * string = [NSString stringWithFormat:@"%@",array[i]];
//                if ([string isEqualToString:@" "]) {
//                    continue;
//                }
//                else
//                {
//                    end = i;
//                    break;
//                }
//            }
//            if (begin == 0 && end == 0) {
//                textView.text = toBeString;
//            }
//            else
//            {
//                if (begin == 0 && end != 0) {
//                    textView.text = [NSString stringWithFormat:@"%@",array[0]];
//                }
//                else if (begin != 0 && end == 0)
//                {
//                    textView.text = [NSString stringWithFormat:@"%@",array[array.count-1]];
//                }
//                else
//                {
//                    textView.text = [NSString stringWithFormat:@"%@",array[begin]];
//                }
//            }
//
//            
////            NSString * str = @"";
////            for (int i = begin; i < array.count-end; i++) {
////                str = [NSString stringWithFormat: @"%@",array[i+1]];
////            }
////            NSRange range = NSMakeRange(begin, array.count-begin-end);
////            NSString * textString = [toBeString substringWithRange:range];
////            textView.text = textString;
//        }
//        else{
//            
//        }
//    }
//    else
//    {
////        if (toBeString.length > 4) {
////            textView.text = [toBeString substringToIndex:4];
////        }
//    }

}
//-(void)textViewDidChange:(UITextView *)textView
//{
//    NSString * textStr = [NSString stringWithFormat:@"%@",textView.text];
//    NSLog(@"7788%@",textStr);
//    NSArray * array = [textStr componentsSeparatedByString:@" "];
//    int begin= -1;
//    int end = -1;
//    for (int i = 0 ; i < array.count; i++) {
//        NSString * string = [NSString stringWithFormat:@"%@",array[i]];
//        if (![string isEqualToString:@" "]) {
//            begin = i;
//            break;
//        }
//    }
//    
//    for (int i = (int)array.count-1 ; i < array.count; i--) {
//        NSString * string = [NSString stringWithFormat:@"%@",array[i]];
//        if (![string isEqualToString:@" "]) {
//            end = i;
//        }
//    }
//    
//    NSRange range = NSMakeRange(begin, array.count-begin-end-1);
//    NSString * textString = [textStr substringWithRange:range];
//    textView.text = textString;
//
//}
#pragma makr 点击右键确认
- (void)rightBtnClick
{
//    NSLog(@"%@",@"确认");
//    if (_editor.text.length == 0) {
//        [MBProgressHUD alertView:nil Message:@"亲,写点什么再确认呗！"];
//        return;
//    }
    NSString * textStr = [NSString stringWithFormat:@"%@",_editor.text];
    NSArray * array = [textStr componentsSeparatedByString:@" "];
    int begin = 0 ;
    int end = 0;
    for (int i = 0; i< array.count; i++) {
        NSString * string = [NSString stringWithFormat:@"%@",array[i]];
        if ( [string isEqualToString:@" "]) {
            continue;
        }
        else
        {
            begin = i;
            break;
        }
    }
    
    for ( int i = (int)array.count-1 ; i < array.count; i--) {
        NSString * string = [NSString stringWithFormat:@"%@",array[i]];
        if ( [string isEqualToString:@" "]) {
            continue;
        }
        else
        {
            end = i;
            break;
        }
    }
        NSString  * string = @"";
        NSMutableArray * muArray = [[NSMutableArray alloc]init];
        for (int i = begin ; i <= end; i++) {
            [muArray addObject:array[i]];
            
        
        }
    string = [muArray componentsJoinedByString:@" "];
        textStr = string;
    if (self.verifyClickBlock) {
        self.verifyClickBlock(_editor.text);
    }
    
    NSString *text = [NSString stringWithFormat:@"%@",_editor.attributedText];
    NSArray *arr = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];

    NSMutableArray *attStr = [NSMutableArray array];
    int i = (int)(arr.count - 1)/2;
    for (int j = 0 ; j<i; j++) {
        NSString *detail = arr[2*j];
        NSString *attribute = arr[2*j+1];
        NSDictionary *attibuteTex = @{@"detail" : detail,
                                      @"attribute" : attribute};
        [attStr addObject:attibuteTex];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 重写返回的方法
-(void)backToFromViewController:(UIButton *)sender
{
    if (self.textFieldString.length) {
        if (![self.textFieldString isEqualToString:_editor.text]) {
            [_editor resignFirstResponder];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if (_editor.text.length) {
            [_editor resignFirstResponder];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
           
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0) {
            
        }
        else
        {
            if (self.verifyClickBlock) {
                if (self.textFieldString.length) {
                    self.verifyClickBlock(self.textFieldString);
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
//            [_editor resignFirstResponder];
        }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
