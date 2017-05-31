//
//  WPCompanyInfoController.m
//  WP
//
//  Created by CBCCBC on 15/10/18.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCompanyInfoController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MBProgressHUD+MJ.h"

#import "WPCompanyController.h"
#import "WPRecruitController.h"
#import "WPCompanyEditController.h"

@interface WPCompanyInfoController () <UIWebViewDelegate,NJKWebViewProgressDelegate,UITextFieldDelegate,RefreshCompanyInfoDelegate>

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *webViewProgressView;
@property (strong, nonatomic) NJKWebViewProgress *webViewProgress;

@end

@implementation WPCompanyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    //    [self.view addSubview:self.preview];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-43)];
    [self.view addSubview:_webView];
    
    NSString *str = [NSString stringWithFormat:@"%@/webMobile/November/recruitCompany.aspx?ep_id=%@",IPADDRESS,self.subId];;
    
//    if (self.isCompany) {
//        str = [NSString stringWithFormat:@"%@/webMobile/recruitCompany.aspx?company_id=%@",IPADDRESS,self.subId];
//    }else{
//        if (self.isRecuilist) {
//            str = [NSString stringWithFormat:@"%@/webMobile/recruitSingle.aspx?recruit_id=%@",IPADDRESS,self.subId];
//        }else{
//            str = [NSString stringWithFormat:@"%@/webMobile/Job.aspx?resume_id=%@",IPADDRESS,self.subId];
//        }
//    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [_webView loadRequest:request];
    
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    //    NSMutableString
    //    NSString *str = [NSString stringWithString:<#(nonnull NSString *)#>]
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(chooseClick)];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-43, SCREEN_WIDTH, 43)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 43);
        button.titleLabel.font = kFONT(15);
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button setTitleColor:RGB(178, 178, 178) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

- (void)editClick
{
    WPCompanyEditController *company = [[WPCompanyEditController alloc]init];
    company.delegate = self;
    company.title = @"企业信息";
    [self.navigationController pushViewController:company animated:YES];
}

- (void)RefreshCompanyInfo
{
    
}

- (NSObject *)model
{
    if (!_model) {
        _model = [[NSObject alloc]init];
    }
    return _model;
}

- (void)chooseClick
{
    if (self.delegate) {
        [self.delegate WPCompanyInfoDelegate:self.model];
        WPRecruitController *company = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:company animated:YES];
    }
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
