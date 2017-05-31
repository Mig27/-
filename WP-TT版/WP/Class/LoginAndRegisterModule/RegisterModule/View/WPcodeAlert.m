//
//  WPcodeAlert.m
//  WP
//
//  Created by CC on 16/10/13.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPcodeAlert.h"

@interface WPcodeAlert ()

@end

@implementation WPcodeAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)oneCreatAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:messag preferredStyle:UIAlertControllerStyleAlert];
    
    
    NSMutableAttributedString *hoganq = [[NSMutableAttributedString alloc] initWithString:messag attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:AttributedColor}];
    [hoganq setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0,messag.length)];
    [hoganq setAttributes:@{NSForegroundColorAttributeName:RGB(0, 172, 255)} range:NSMakeRange(6,messag.length-6)];
//    [alert setValue:hoganq forKey:@"attributedMessage"];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:defaultStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.clickDefault) {
            self.clickDefault();
        }
    }];
    
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        if (self.clickCancle) {
//            self.clickCancle();
//        }
//    }];
    
    
    [alert addAction:action1];
//    [alert addAction:action2];
    alert.view.tintColor = RGB(0, 172, 255);//改变按钮颜色
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)creatAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:messag preferredStyle:UIAlertControllerStyleAlert];

    
    NSMutableAttributedString *hoganq = [[NSMutableAttributedString alloc] initWithString:messag attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:AttributedColor}];
    [hoganq setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0,messag.length)];
    [hoganq setAttributes:@{NSForegroundColorAttributeName:RGB(0, 172, 255)} range:NSMakeRange(6,messag.length-6)];
    [alert setValue:hoganq forKey:@"attributedMessage"];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:defaultStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.clickDefault) {
            self.clickDefault();
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (self.clickCancle) {
            self.clickCancle();
        }
    }];
    

    [alert addAction:action1];
    [alert addAction:action2];
    alert.view.tintColor = RGB(0, 172, 255);//改变按钮颜色
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)creatAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr clickCancel:(void(^)(id))Cancel clickSure:(void(^)(id))Sure
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:messag preferredStyle:UIAlertControllerStyleAlert];
    
    
    NSMutableAttributedString *hoganq = [[NSMutableAttributedString alloc] initWithString:messag attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:AttributedColor}];
    [hoganq setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0,messag.length)];
    [hoganq setAttributes:@{NSForegroundColorAttributeName:RGB(0, 172, 255)} range:NSMakeRange(6,messag.length-6)];
    [alert setValue:hoganq forKey:@"attributedMessage"];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:defaultStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Sure(@"");
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        Cancel(@"");
    }];
    
    
    [alert addAction:action1];
    [alert addAction:action2];
    alert.view.tintColor = RGB(0, 172, 255);//改变按钮颜色
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)creatBottomAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:messag preferredStyle:UIAlertControllerStyleAlert];
    
    
//    NSMutableAttributedString *hoganq = [[NSMutableAttributedString alloc] initWithString:messag attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:AttributedColor}];
//    [hoganq setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0,messag.length)];
//    [hoganq setAttributes:@{NSForegroundColorAttributeName:RGB(0, 172, 255)} range:NSMakeRange(6,messag.length-6)];
//    [alert setValue:hoganq forKey:@"attributedMessage"];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:defaultStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.clickDefault) {
            self.clickDefault();
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (self.clickCancle) {
            self.clickCancle();
        }
    }];
    
    
    [alert addAction:action1];
    [alert addAction:action2];
    alert.view.tintColor = RGB(0, 172, 255);//改变按钮颜色
    [self presentViewController:alert animated:YES completion:nil];
  
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
