//
//  ReportViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportView.h"

#import "UIPlaceHolderTextView.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"

@interface ReportViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong) UIPlaceHolderTextView *textView;
@property (nonatomic,strong) NSString *re_class;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self createUI];
    self.re_class = @"";
}

- (void)initNav
{
    self.view.backgroundColor = RGB(235, 235, 235);
    self.title = @"举报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
    if (self.re_class.length == 0) {
        [MBProgressHUD createHUD:@"请选择举报类别!" View:self.view];
        return;
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/report.ashx"];
    NSDictionary *params = @{@"action" : @"AddReport",
                             @"username" : model.username,
                             @"password" : model.password,
                             @"user_id" : userInfo[@"userid"],
                             @"category" : @(_type),
                             @"fk_id" : self.speak_trends_id,
                             @"re_class" : self.re_class,
                             @"re_content" : _textView.text};
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@---%@",json,json[@"info"]);
        [[[UIAlertView alloc] initWithTitle:json[@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    NSArray *title = @[@"欺诈",
                       @"色情",
                       @"暴力",
                       @"中介机构",
                       @"虚假信息",
                       @"反动/政治谣言",
                       @"广告/恶意营销"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, title.count*ItemHeightAndLine + kHEIGHT(80) + 2*normalSize.width + 50);

    [self.view addSubview:scrollView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, normalSize.height)];
    firstLabel.text = @"请选择举报类型";
    firstLabel.textColor = kLightColor;
    firstLabel.font = kFONT(12);
    [scrollView addSubview:firstLabel];
    
    
    ReportView *reoprt = [[ReportView alloc] initWithFrame:CGRectMake(0, firstLabel.bottom + 10, SCREEN_WIDTH, ItemHeightAndLine*title.count) items:title];
    reoprt.selectItem = ^(NSString *item) {
        self.re_class = item;
    };
    [scrollView addSubview:reoprt];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, reoprt.bottom + 10, SCREEN_WIDTH - 20, normalSize.height)];
    secondLabel.text = @"举例补充说明";
    secondLabel.textColor = kLightColor;
    secondLabel.font = kFONT(12);
    [scrollView addSubview:secondLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, secondLabel.bottom + 10, SCREEN_WIDTH, kHEIGHT(80))];
    backView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:backView];
    
    _textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, kHEIGHT(80) - 10)];
    _textView.placeholder = @"详细描述举报原因（选填）";
    _textView.font = kFONT(15);
    [backView addSubview:_textView];
    
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
