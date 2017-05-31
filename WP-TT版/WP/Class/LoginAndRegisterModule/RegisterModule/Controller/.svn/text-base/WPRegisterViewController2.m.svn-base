//
//  WPRegisterViewController2.m
//  WP
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRegisterViewController2.h"
#import "ZCControl.h"
#import "WPRegisterViewController3.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "WPRegisterViewController2-1.h"
#import "WPRegisterViewController2-3.h"
#import "UISelectCity.h"

@interface WPRegisterViewController2 ()<FuckTheSBcompanyDelegate>
{
    UILabel* label;
    UILabel* industryLabel;
    UILabel* positionLabel;
    UILabel* addressLabel;
    
    UIButton* btn1;
    UIButton* btn2;
    UIButton* btn3;
}

@property (strong, nonatomic) UISelectCity *city;
@property (assign, nonatomic) NSInteger number;

@end

@implementation WPRegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"个人资料";

    //设置右按钮
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:NULLNAME Target:self Action:@selector(nextClick) Title:@"下一步"];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)nextClick
{
    if ([industryLabel.text isEqualToString:@"请选择工作行业"]){
        //弹出选择框
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"选择您的行业" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else if([positionLabel.text isEqualToString:@"请选择工作职位"]){
        //弹出选择框
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"选择您的职位" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else if([addressLabel.text isEqualToString:@"请选择工作地点"]){
        //弹出选择框
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"选择您的地址" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else{
        
        WPRegisterViewController3* vc=[[WPRegisterViewController3 alloc] init];
        vc.headImage = _headImage;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)createView
{
    UIImageView* rightimage1=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-29, 15, 9, 14)];
    rightimage1.image=[UIImage imageNamed:@"选择"];
    UIImageView* rightimage2=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-29, 15, 9, 14)];
    rightimage2.image=[UIImage imageNamed:@"选择"];
    UIImageView* rightimage3=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-29, 15, 9, 14)];
    rightimage3.image=[UIImage imageNamed:@"选择"];
    
    label=[[UILabel alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width, 30)];
    label.text=@"请填写以下信息:";
    label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
    //行业的view
    UIView*industryView=[ZCControl viewWithFrame:CGRectMake(0, 94, self.view.frame.size.width, 43)];
    industryView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:industryView];
    
    //创建行业图片
    UIImageView*industryImageView=[ZCControl createImageViewWithFrame:CGRectMake(10,14, 14, 14) ImageName:@"行业"];
    [industryView addSubview:industryImageView];
    
    //行业的label
    industryLabel=[ZCControl createLabelWithFrame:CGRectMake(40, 12, self.view.frame.size.width-160, 20) Font:15 Text:@"请选择工作行业"];
    //设置文字为灰色
    industryLabel.textColor=[UIColor lightGrayColor];
    [industryView addSubview:industryLabel];
    [industryView addSubview:rightimage1];
    //最后添加点击事件
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    [industryView addSubview:btn1];
    [industryView bringSubviewToFront:btn1];
    btn1.tag=100;
    [btn1 addTarget:self action:@selector(industryControlPicker) forControlEvents:UIControlEventTouchUpInside];
    
    //职位的view
    UIView*positionView=[ZCControl viewWithFrame:CGRectMake(0, 94+43+10, self.view.frame.size.width, 43)];
    positionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:positionView];
    
    //创建职位图片
    UIImageView*positionImageView=[ZCControl createImageViewWithFrame:CGRectMake(10,14, 14, 10) ImageName:@"职位"];
    [positionView addSubview:positionImageView];
    //职位的label
    positionLabel=[ZCControl createLabelWithFrame:CGRectMake(40, 12, self.view.frame.size.width-160, 20) Font:15 Text:@"请选择工作职位"];
    //设置文字为灰色
    positionLabel.textColor=[UIColor lightGrayColor];
    [positionView addSubview:positionLabel];
    [positionView addSubview:rightimage2];
    //最后添加点击事件
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    [positionView addSubview:btn2];
    [positionView bringSubviewToFront:btn2];
    btn2.tag=101;
    [btn2 addTarget:self action:@selector(positionControlPicker) forControlEvents:UIControlEventTouchUpInside];
    
    //地点的view
    UIView*addressView=[ZCControl viewWithFrame:CGRectMake(0, 94+43+10+53, self.view.frame.size.width, 43)];
    addressView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:addressView];
    //创建地点图片
    UIImageView*addressImageView=[ZCControl createImageViewWithFrame:CGRectMake(10,14, 14, 15) ImageName:@"地址1"];
    [addressView addSubview:addressImageView];
    //地点的label
    addressLabel=[ZCControl createLabelWithFrame:CGRectMake(40, 12, self.view.frame.size.width-160, 20) Font:15 Text:@"请选择工作地点"];
    //设置文字为灰色
    addressLabel.textColor=[UIColor lightGrayColor];
    [addressView addSubview:addressLabel];
    [addressView addSubview:rightimage3];
    //最后添加点击事件
    btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    [addressView addSubview:btn3];
    [addressView bringSubviewToFront:btn3];
    btn3.tag=102;
    [btn3 addTarget:self action:@selector(addressControlPicker) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(12, 240+9, 6, 8)];
    imageView.image=[UIImage imageNamed:@"保密注意"];
    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(24, 240, SCREEN_WIDTH-24, 26)];
    label1.text=@"以上信息只有指定好友可以查看";
    label1.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label1.textAlignment=NSTextAlignmentLeft;
    label1.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:label1];
    [self.view addSubview:imageView];
    
    WPShareModel* model=[WPShareModel sharedModel];
    model.btn1=btn1.tag;
    model.btn1=btn1.tag;
    model.btn1=btn1.tag;
}

-(void)industryControlPicker
{
    NSLog(@"选择行业");
    _number = 0;
    WPRegisterViewController2_1 *vc = [[WPRegisterViewController2_1 alloc]init];
    vc.urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    vc.params = @{@"action":@"getIndustry",@"fatherid":@"0"};
    vc.delegate = self;
    vc.isIndustry = YES;
    vc.isArea=  NO;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)positionControlPicker
{
    NSLog(@"职位选择");
    _number = 1;
    WPRegisterViewController2_1 *vc = [[WPRegisterViewController2_1 alloc]init];
    vc.urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    vc.params = @{@"action":@"getPosition",@"fatherid":@"0"};
    vc.delegate = self;
    vc.isIndustry = NO;
    vc.isArea=  NO;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)addressControlPicker
{
    NSLog(@"地点选择");
    _number = 2;
    WPRegisterViewController2_1 *vc = [[WPRegisterViewController2_1 alloc]init];
    vc.urlStr = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    vc.params = @{@"action":@"getarea",@"fatherid":@"0"};
    vc.delegate = self;
    vc.isIndustry = NO;
    vc.isArea=  YES;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)FuckTheSBcompanyDelegate:(IndustryModel *)model
{
    WPShareModel* shareModel=[WPShareModel sharedModel];
    switch (_number) {
        case 0:
            shareModel.industryModel = model;
            industryLabel.text = model.industryName;
            break;
        case 1:
            shareModel.positionModel = model;
            positionLabel.text = model.industryName;
            break;
        case 2:
            shareModel.addressModel = model;
            addressLabel.text = model.industryName;
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
