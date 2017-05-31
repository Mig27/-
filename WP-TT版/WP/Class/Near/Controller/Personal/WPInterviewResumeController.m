//
//  WPInterviewResumeController.m
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewResumeController.h"
#import "NearInterViewController.h"
#import "ApplyForActivityController.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyController.h"
#import "SPPreview.h"
#import "SPButton.h"
#import "UIWebView+AFNetworking.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MBProgressHUD+MJ.h"
#import "IQKeyboardManager.h"
#import "WPRecruitApplyChooseModel.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPRecruitApplyChooseController.h"
#import "WPInterviewApplyController.h"
#import "WPInterviewApplyChooseController.h"
#import "WPResumeCheckController.h"
#import "WPPersonalResumeListController.h"

@interface WPInterviewResumeController () <UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *bottomManagerView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *webViewProgressView;
@property (strong, nonatomic) NJKWebViewProgress *webViewProgress;

@property (strong, nonatomic) UIView *messageView;

@end

@implementation WPInterviewResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //    [self.view addSubview:self.preview];
    _isSelf?0:[self bottomManagerView];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,(_isSelf?(SCREEN_HEIGHT-64):(SCREEN_HEIGHT-64-49)))];
    _webView.detectsPhoneNumbers=NO;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAppendingFormat:@"&isVisible=1"]]];
    [_webView loadRequest:request];
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[NearInterViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NearInterViewController class]];
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    
    if ([array[0] hasSuffix:@"/webMobile/November/user_id"]) {
        WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
        list.userId = array[1];
        list.isSelf = NO;
        [self.navigationController pushViewController:list animated:YES];
        return NO;
    }
    
    return YES;
}

- (UIView *)bottomManagerView{
    if (!_bottomManagerView) {
        _bottomManagerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"查看" ImageName:@"bianji" Target:self Action:@selector(editClick:)];
        button.tag = 100;
        [_bottomManagerView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomManagerView addSubview:line];
        
        [self.view addSubview:_bottomManagerView];
    }
    return _bottomManagerView;
}
- (void)editClick:(UIButton *)sender{
    WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
    list.userId = self.userId;
    list.isSelf = YES;
    [self.navigationController pushViewController:list animated:YES];

}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)dealloc
{
    _webViewProgress = nil;
    [_webViewProgressView removeFromSuperview];
}
@end
