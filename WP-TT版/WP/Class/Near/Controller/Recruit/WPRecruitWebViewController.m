//
//  WPRecruitWebViewController.m
//  WP
//
//  Created by CBCCBC on 16/3/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRecruitWebViewController.h"
#import "UIImage+autoGenerate.h"
#import "WPInterviewDraftEditController.h"
#import "WPInterviewDraftInfoModel.h"

#define PERSONALURL @"/webMobile/November/resumeuserinfo.aspx?resume_id="
#define APPLYURL @"/webMobile/November/resumeinfo.aspx?resume_id="

@interface SelectView ()
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)UIImageView *image;
@end

@implementation SelectView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if ([super initWithFrame:frame]) {
        self.image = [[UIImageView alloc]initWithImage:image highlightedImage:highlightedImage];
        self.image.frame = CGRectMake(frame.size.width/3, frame.size.height/3, frame.size.height/3, frame.size.height/3);
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/3+frame.size.height/3, frame.size.height/3, frame.size.width/3, frame.size.height/3)];
        
    }
    return self;
}

@end

@interface WPRecruitWebViewBtn ()
@property (nonatomic, strong)UIButton *personalBtn;
@property (nonatomic, strong)UIButton *applyBtn;
@property (nonatomic, strong)UIView *verticaline;
@property (nonatomic, strong)UIView *horizontaline;
@end

@implementation WPRecruitWebViewBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.personalBtn];
        [self addSubview:self.applyBtn];
        [self addSubview:self.verticaline];
        [self addSubview:self.horizontaline];
        [self addSubview:self.scrolline];
        self.applyBtn.selected = YES;
    }
    return self;
}

- (UIButton *)personalBtn
{
    if (!_personalBtn) {
        self.personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.personalBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, kHEIGHT(36));
        [self.personalBtn setImage:[UIImage imageNamed:@"common_gerenxinxihui"] forState:UIControlStateNormal];
        [self.personalBtn setImage:[UIImage imageNamed:@"common_gerenxinxilan"] forState:UIControlStateSelected];
        self.personalBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [self.personalBtn setTitle:@"个人信息" forState:UIControlStateNormal];
        self.personalBtn.titleLabel.font = kFONT(14);
        [self.personalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.personalBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
//        [self.personalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        self.personalBtn.backgroundColor = [UIColor whiteColor];
        
    }
    return _personalBtn;
}

- (UIButton *)applyBtn
{
    if (!_applyBtn) {
        self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.applyBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, kHEIGHT(36));
        [self.applyBtn setImage:[UIImage imageNamed:@"common_qiuzhixinxihui"] forState:UIControlStateNormal];
        [self.applyBtn setImage:[UIImage imageNamed:@"common_qiuzhixinxilan"] forState:UIControlStateSelected];
        self.applyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [self.applyBtn setTitle:@"求职信息" forState:UIControlStateNormal];
        self.applyBtn.titleLabel.font = kFONT(14);
        [self.applyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.applyBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        self.applyBtn.backgroundColor = [UIColor whiteColor];
//        [self.applyBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _applyBtn;
}

- (UIView *)verticaline
{
    if (!_verticaline) {
        self.verticaline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, kHEIGHT(11), 1, kHEIGHT(14))];
        self.verticaline.backgroundColor = RGB(226, 226, 226);
    }
    return _verticaline;
}

- (UIView *)scrolline
{
    if (!_scrolline) {
        self.scrolline = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(36)-2, SCREEN_WIDTH/2, 2)];
        self.scrolline.backgroundColor = RGB(0, 172, 255);
    }
    return _scrolline;
}

- (UIView *)horizontaline
{
    if (!_horizontaline) {
        self.horizontaline = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(36)-1, SCREEN_WIDTH, 1)];
        self.horizontaline.backgroundColor = RGB(0, 0, 0);
    }
    return _horizontaline;
}

@end

@interface WPRecruitWebViewController ()<UIScrollViewDelegate,WPInterviewDraftEditControllerDelegate>
@property (nonatomic, strong)WPRecruitWebViewBtn *button;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIWebView *personalView;
@property (nonatomic, strong)UIWebView *applyView;
@property (nonatomic, strong)UIButton *editBtn;
@end

@implementation WPRecruitWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.button];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.editBtn];
    [self setNavAccording];
}
// 设置导航栏显示
- (void)setNavAccording
{
//    [self.navigationItem.leftBarButtonItem setTitle:@"返回"];
    self.title = @"简历信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    NSArray *arr = [self.navigationController viewControllers];
    [self.navigationController popToViewController:arr[2] animated:YES];
    
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHEIGHT(36)+64, SCREEN_WIDTH, SCREEN_HEIGHT-kHEIGHT(36)-49-64)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-kHEIGHT(36)-49-64);
        [self.scrollView addSubview:self.personalView];
        [self.scrollView addSubview:self.applyView];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIWebView *)personalView
{
    if (!_personalView) {
        self.personalView = [[UIWebView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kHEIGHT(36)-49-64)];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.personalUrl]];
        [self.personalView loadRequest:request];
    }
    return _personalView;
}

- (UIWebView *)applyView
{
    if (!_applyView) {
        self.applyView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kHEIGHT(36)-49-64)];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.applyUrl]];
        [self.applyView loadRequest:request];
    }
    return _applyView;
}

- (WPRecruitWebViewBtn *)button
{
    if (!_button) {
        self.button = [[WPRecruitWebViewBtn alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(36))];
        [self.button.personalBtn addTarget:self action:@selector(buttonTouchAction:) forControlEvents:UIControlEventTouchDown];
        [self.button.applyBtn addTarget:self action:@selector(buttonTouchAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _button;
}

// 编辑按钮
- (UIButton *)editBtn
{
    if (!_editBtn) {
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        self.editBtn.backgroundColor = [UIColor whiteColor];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.editBtn setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(SCREEN_WIDTH, 44)] forState:UIControlStateHighlighted];
        [self.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchDown];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(178, 178, 178);
        [self.editBtn addSubview:lineView];
    }
    return _editBtn;
}

- (void)editBtnAction:(UIButton *)sender
{
    WS(ws);
//    [self getInterviewResumeDraftDetail:self.model.resume_id success:^(WPInterviewDraftInfoModel *model) {
//        
//        WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
//        edit.type = WPInterviewEditTypeEdit;
//        edit.draftInfoModel = model;
//        edit.delegate = ws;
//        [ws.navigationController pushViewController:edit animated:YES];
//    }];
    
    [self getInterviewResumeDraftDetail:self.model.userId success:^(WPInterviewDraftInfoModel *model) {
        
        WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
        edit.type = WPInterviewEditTypeEdit;
        edit.draftInfoModel = model;
        edit.delegate = ws;
        [ws.navigationController pushViewController:edit animated:YES];
    }];
}

- (void)reloadView
{
    [self.personalView reload];
    [self.applyView reload];
}

#pragma mark -- 计算函数 获取到当前URL
//- (void)setModel:(WPRecruitApplyChooseListModel *)model
//{
//    _model = model;
//    NSString *urlSuffix = [NSString stringWithFormat:@"%@%@%@",model.resume_id,@"&user_id=",kShareModel.userId];
//    self.personalUrl = [NSString stringWithFormat:@"%@%@%@",IPADDRESS,PERSONALURL,urlSuffix];
//    self.applyUrl = [NSString stringWithFormat:@"%@%@%@",IPADDRESS,APPLYURL,urlSuffix];
//}

- (void)setModel:(WPResumeUserModel *)model
{
    _model = model;
    NSString *urlSuffix = [NSString stringWithFormat:@"%@%@%@",model.userId,@"&user_id=",kShareModel.userId];
    self.personalUrl = [NSString stringWithFormat:@"%@%@%@",IPADDRESS,PERSONALURL,urlSuffix];
    self.applyUrl = [NSString stringWithFormat:@"%@%@%@",IPADDRESS,APPLYURL,urlSuffix];
}

- (void)getInterviewResumeDraftDetail:(NSString *)resumeId success:(void (^)(WPInterviewDraftInfoModel *model))success{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"resume_id":resumeId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPInterviewDraftInfoModel *model = [WPInterviewDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}



#pragma mark -- 滑动效果
- (void)buttonTouchAction:(UIButton *)sender
{
    NSString *string = sender.titleLabel.text;
    if ([string isEqualToString:@"个人信息"]) {
        [self currentWebPersonalview];
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }else{
        [self currentWebApplyview];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int contentOffset = (int)(self.scrollView.contentOffset.x / SCREEN_WIDTH);
    if (contentOffset) {
        [self currentWebPersonalview];
    }else {
        [self currentWebApplyview];
    }
}

// 当前显示View
- (void)currentWebPersonalview
{
    self.button.personalBtn.selected = YES;
    self.button.applyBtn.selected = NO;
    [self animationOfScrollineWithFrame:CGRectMake(SCREEN_WIDTH/2, kHEIGHT(36)-2, SCREEN_WIDTH/2, 2)];
}

- (void)animationOfScrollineWithFrame:(CGRect)frame
{
    [UIView animateWithDuration:.3 animations:^{
        self.button.scrolline.frame = frame;
    }];
}

- (void)currentWebApplyview
{
    self.button.personalBtn.selected = NO;
    self.button.applyBtn.selected = YES;
    [self animationOfScrollineWithFrame:CGRectMake(0, kHEIGHT(36)-2, SCREEN_WIDTH/2, 2)];
}

@end
