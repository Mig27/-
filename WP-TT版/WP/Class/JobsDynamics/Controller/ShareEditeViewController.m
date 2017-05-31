//
//  ShareEditeViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/2/2.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈分享界面

#import "ShareEditeViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ShareResume.h"
#import "ShareEditeCell.h"
#import "LocationViewController.h"
#import "OpenViewController.h"
#import "TopicViewController.h"
#import "IQKeyboardManager.h"
#import "HCEmojiKeyboard.h"

static NSString *emoji = @"common_biaoqing";
static NSString *keyboard = @"common_jianpan";

@interface ShareEditeViewController ()<UITableViewDelegate,UITableViewDataSource,sendBackLocation,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIPlaceHolderTextView *text;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *comment_type;    //说说的类型
@property (nonatomic, strong) NSString *is_anoymous;     //公开类型
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSIndexPath* openIndex;

@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UIButton *faceBtn;

@property (nonatomic, copy)NSString * is_Look;
@property (nonatomic, copy)NSString * not_look;

@end

@implementation ShareEditeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用滑动手势
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    
    [self initDatasource];
    [self initNav];
    [self tableView];
    
    UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    faceBtn.tag = 0;
    //    faceBtn.backgroundColor = [UIColor redColor];
    [faceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    [faceBtn setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.faceBtn = faceBtn;
    
    UIButton *completBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
    completBtn.titleLabel.font = FONT(15);
    [completBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [completBtn addTarget:self action:@selector(resignKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = [UIColor whiteColor];
    toolView.layer.borderColor = RGB(177, 177, 177).CGColor;
    toolView.layer.borderWidth = 0.5;
    [toolView addSubview:faceBtn];
    [toolView addSubview:completBtn];
    self.toolView = toolView;
    [self.view addSubview:self.toolView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ShareEditeViewController class]];
    
    [self createEmojiView];

}

- (void)createEmojiView {
    
    _emojiKeyboard = [HCEmojiKeyboard sharedKeyboard];
    _emojiKeyboard.showAddBtn = NO;
    _emojiKeyboard.hiddenSend = YES;
    [_emojiKeyboard addBtnClicked:^{
        NSLog(@"clicked add btn");
    }];
    [_emojiKeyboard sendEmojis:^{
        //赋值
        _text.text = _text.text;
    }];
}

- (void)resignKeyboard
{
    [_text resignFirstResponder];
    [self reductionKeyboard];
}

#pragma mark - 键盘还原
- (void)reductionKeyboard
{
    self.text.inputView = nil;
    _faceBtn.tag = 0;
    [_faceBtn setImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    [self.text reloadInputViews];
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         CGRect newInputViewFrame = self.toolView.frame;
                         newInputViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.toolView.frame)-kbSize.height;
                         self.toolView.frame = newInputViewFrame;
                     }
                     completion:nil];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //do something
    self.toolView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 50);
}

//改变键盘状态
- (void)clickedFaceBtn:(UIButton *)button{
    if (button.tag == 1){
        self.text.inputView = nil;
        [button setImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:keyboard] forState:UIControlStateNormal];
        [_emojiKeyboard setTextInput:self.text];
    }
    [self.text reloadInputViews];
    button.tag = (button.tag+1)%2;
    [_text becomeFirstResponder];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([[scrollView class] isEqual:[UITableView class]]) {
        [self resignKeyboard];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

#pragma mark - 当textView 进入编辑状态的时候,执行代理函数
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGSize size = [textView.text sizeWithFont:[textView font]];
    int length = size.height;
    int colomNumber = textView.contentSize.height/length;
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    [textView scrollRangeToVisible:NSMakeRange(cursorPosition.y, 0)];
}
- (void)textViewDidChange:(UITextView *)textView {
    [textView becomeFirstResponder];
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    //    [textView scrollRangeToVisible:NSMakeRange(0, colomNumber)];
    [textView scrollRangeToVisible:NSMakeRange(cursorPosition.y - textView.height + (SCREEN_WIDTH == 414 ? 2*normalSize.height : normalSize.height), 0)];
}

- (void)initDatasource{
    NSArray *arr = @[@{@"title" : @"所在位置",
                       @"subtitle" : @"",
                       @"image" : @"share_address"},
                     @{@"title" : @"公开",
                       @"subtitle" : @"所有人可见",
                       @"image" : @"share_open"},
                     @{@"title" : @"话题",
                       @"subtitle" : @"默认·职场日记",
                       @"image" : @"share_topic"}];
    self.dataSource = [[NSMutableArray alloc] initWithArray:arr];
    self.comment_type = @"2";
    self.index = 0;
    self.openIndex = 0;
    self.is_anoymous = @"0";
}

- (void)initNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"话题";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    
}

- (void)rightButtonClick
{
    NSLog(@"发布");
    [MBProgressHUD showMessage:@"" toView:self.view];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"releaseDynamic";
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"speak_content"] = self.text.text;
    params[@"is_anoymous"] = self.is_anoymous;
    params[@"comment_type"] = self.comment_type;
    params[@"speak_address"] = [self.dataSource[0][@"title"] isEqualToString:@"所在位置"]?@"":self.dataSource[0][@"title"];
    
    
    NSString *shareType = [NSString stringWithFormat:@"%@",self.shareInfo[@"share"]];
    NSInteger jobNo = [self.shareInfo[@"jobNo"] integerValue];
    NSString *jobids = [NSString stringWithFormat:@"%@",self.shareInfo[@"jobids"]];
    NSString *sid = [NSString stringWithFormat:@"%@",self.shareInfo[@"sid"] == NULL ? @"" : self.shareInfo[@"sid"]];
//    NSString *share_farther_id = [NSString stringWithFormat:@"%@",self.shareInfo[@"share_farther_id"]];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    if ([shareType isEqualToString:@"0"]) {
        params[@"jobid"] = sid;
        params[@"share"] = @"1";
    } else if([shareType isEqualToString:@"1"]) {
        params[@"jobid"] = [NSString stringWithFormat:@"%@,%@",sid,jobids];
        params[@"share"] = @"1";
    } else if ([shareType isEqualToString:@"2"]) {
        params[@"jobid"] = jobids;
//        params[@"speak_id"] = [share_farther_id isEqualToString:@"0"] ? sid : [NSString stringWithFormat:@"%@,%@",sid,share_farther_id];
        params[@"speak_id"] = sid;
        params[@"share"] = @"2";
    } else if ([shareType isEqualToString:@"3"]) {
        params[@"jobid"] = jobids;
//        params[@"speak_id"] = [share_farther_id isEqualToString:@"0"] ? sid : [NSString stringWithFormat:@"%@,%@",sid,share_farther_id];
        params[@"speak_id"] = sid;
        params[@"share"] = @"3";
    }
    
    if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) {
        if (jobNo == 1) {
            params[@"imp"] = @"1";
        } else {
            params[@"imp"] = @"2";
        }
    }
    
    
    [self.is_anoymous isEqualToString:@"4"]?(params[@"is_look"] = self.is_Look):([self.is_anoymous isEqualToString:@"5"]?(params[@"not_look"]=self.not_look):0);
    
    NSLog(@"---------%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
            if (self.shareSuccessedBlock) {
                self.shareSuccessedBlock(json);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD alertView:@"分享失败" Message:json[@"info"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD alertView:@"分享失败" Message:error.localizedDescription];

    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.rowHeight = [ShareEditeCell cellHeight];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43) + kHEIGHT(93) + 10 + 8)];
        _headView.backgroundColor = RGB(235, 235, 235);
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43) + kHEIGHT(93) + 10)];
        bgView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:bgView];
        
        _text = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, kHEIGHT(93) - 5)];
        self.text.font = kFONT(15);
        _text.placeholder = @"说些什么...";
        _text.delegate = self;
        self.text.tintColor = RGB(127, 127, 127);
        self.text.layoutManager.allowsNonContiguousLayout = NO;
        [_headView addSubview:_text];
        
        NSString *shareType = [NSString stringWithFormat:@"%@",self.shareInfo[@"share"]];
        ShareResume *resume = [[ShareResume alloc] initWithFrame:CGRectMake(10, _text.bottom + 5, SCREEN_WIDTH - 20, kHEIGHT(43))];
        
        if ([shareType isEqualToString:@"0"]) {
            resume.type = ShareResumeTypeDynamic;
            resume.resumeInfo = self.shareInfo;
        } else if ([shareType isEqualToString:@"1"]) {
            resume.type = ShareResumeTypeDynamic;
            resume.resumeInfo = self.shareInfo[@"shareMsg"];
        } else if ([shareType isEqualToString:@"2"]) {
            resume.type = ShareResumeTypeJOb;
            resume.resumeInfo = self.shareInfo[@"shareMsg"];
        } else if ([shareType isEqualToString:@"3"]) {
            resume.type = ShareResumeTypeInvite;
            resume.resumeInfo = self.shareInfo[@"shareMsg"];
        }
        [_headView addSubview:resume];
    }
    
    return _headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareEditeCell *cell = [ShareEditeCell cellWithTableView:tableView];
    cell.dic = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LocationViewController *location = [[LocationViewController alloc] init];
        location.delegate = self;
        location.isFromShuoShuo = YES;
        [self.navigationController pushViewController:location animated:YES];
    } else if (indexPath.row == 1) {
//        NSLog(@"公开");
        OpenViewController *open = [[OpenViewController alloc] init];
        open.selectIndex = self.openIndex;
//        open.openDidselectBlock = ^(NSDictionary *dic,NSInteger index) {
//            NSDictionary *replacrDic =                       @{@"title" : dic[@"title"],
//                                                               @"subtitle" : dic[@"subTitle"],
//                                                               @"image" : @"share_open"};
//            [self.dataSource replaceObjectAtIndex:1 withObject:replacrDic];
//            self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index];
//            self.openIndex = index;
//            [_tableView reloadData];
//            
//        };
        
        open.clickComplete = ^(NSDictionary*dic,NSIndexPath*index){
            NSDictionary *replacrDic =                       @{@"title" : @"公开",
                                                               @"subtitle" : dic[@"title"],
                                                               @"image" : @"share_open"};
            [self.dataSource replaceObjectAtIndex:1 withObject:replacrDic];
            if (index.section <= 3) {
                self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index];
            }
            else
            {
                self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index-1];
                if (index.section == 5) {
                    self.is_Look = dic[@"userID"];
                }
                else
                {
                    self.not_look = dic[@"userID"];
                }
            }
            self.openIndex = index;
            [_tableView reloadData];
        };
        
        [self.navigationController pushViewController:open animated:YES];
    } else if (indexPath.row == 2) {
//        NSLog(@"话题");
        TopicViewController *topic = [[TopicViewController alloc] init];
        topic.selectIndex = self.index;
        topic.topicDidselectBlock = ^(DynamicTopicTypeModel *model,NSIndexPath *clickIndex) {
            NSDictionary *replaceDic = @{@"title" : @"话题",
                                         @"subtitle" : model.type_name,
                                         @"image" : @"share_topic"};
            [self.dataSource replaceObjectAtIndex:2 withObject:replaceDic];
            self.comment_type = model.sid;
            self.index = clickIndex.row;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:topic animated:YES];
    }
}

- (void)sendBackLocationWith:(NSString *)location
{
//    NSLog(@"%@",location);
    NSDictionary *replaceDic = @{@"title" : location,
                                 @"subtitle" : @"",
                                 @"image" : @"share_address"};
    [self.dataSource replaceObjectAtIndex:0 withObject:replaceDic];
    [_tableView reloadData];

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
