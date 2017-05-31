//
//  TelePhoneViewController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "TelePhoneViewController.h"
#import "VerificationPassWordController.h"

@interface TelePhoneViewController ()
@property (nonatomic, strong)UILabel *label;
@property (nonatomic ,strong)UIButton *next;
@end

@implementation TelePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.title = @"修改绑定手机号";
    [self.view addSubview:self.label];
    [self.view addSubview:self.next];
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHEIGHT(50))];
        self.label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)setTelephoneNumber:(NSString *)telephoneNumber
{
    _telephoneNumber = telephoneNumber;
    NSString *headString = [telephoneNumber substringToIndex:3];
    NSString *footString = [telephoneNumber substringFromIndex:9];
    self.label.text = [NSString stringWithFormat:@"您已绑定手机号：%@******%@",headString,footString];
}

- (UIButton *)next
{
    if (!_next) {
        self.next = [UIButton buttonWithType:UIButtonTypeCustom];
        self.next.frame = CGRectMake(0, kHEIGHT(50)+64, SCREEN_WIDTH, kHEIGHT(43));
        self.next.backgroundColor = [UIColor whiteColor];
        [self.next addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, kHEIGHT(14), SCREEN_WIDTH, kHEIGHT(15))];
        label.text = @"修改绑定手机";
        [self.next addSubview:label];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, kHEIGHT(14), kHEIGHT(8), kHEIGHT(15))];
        image.image = [UIImage imageNamed:@"jinru"];
        [self.next addSubview:image];
    }
    return _next;
}

- (void)buttonAction:(UIButton *)sender
{
    VerificationPassWordController *verVC = [[VerificationPassWordController alloc]init];
    [self.navigationController pushViewController:verVC animated:YES];
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
