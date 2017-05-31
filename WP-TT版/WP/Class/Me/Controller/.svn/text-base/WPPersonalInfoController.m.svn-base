//
//  WPPersonalInfoController.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonalInfoController.h"
#import "WPResumeEditVC.h"
#import "WPCompanyEditController.h"

@interface WPPersonalInfoController ()
@property (nonatomic ,strong)UIWebView *webView;
@end

@implementation WPPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_personModel.name) {
        self.title=_personModel.name;
    } else {
        self.title=_conpanyModel.enterprise_name;

    }
    [self.view addSubview:self.webView];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if (self.personModel) {
        WPResumeEditVC *VC = [[WPResumeEditVC alloc]init];
        VC.isEdit=self.isedit;
        VC.isPerson=100;
        VC.personModel = self.personModel;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        WPCompanyEditController *VC = [[WPCompanyEditController alloc]init];
        VC.isEditCompany=self.isedit;
        VC.isCompany=100;
        VC.companyModel = self.conpanyModel;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (UIWebView *)webView
{
    if (!_webView ) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        
    }
    return _webView;
}

- (void)setPersonModel:(WPPersonModel *)personModel
{
    _personModel = personModel;
    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/resume.aspx?resume_user_id=%@&user_id=%@",IPADDRESS,self.personModel.sid,kShareModel.userId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)setConpanyModel:(CompanyModel *)conpanyModel
{
    _conpanyModel = conpanyModel;
    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/CompanyEx.aspx?ep_id=%@&user_id=%@",IPADDRESS,self.conpanyModel.ep_id,kShareModel.userId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


@end
