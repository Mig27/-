//
//  ActivityPreViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/22.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityPreViewController.h"
#import "ActivityPreViewItem.h"

#import "FeeModel.h"
#import "TYAttributedLabel.h"
#import "ActivityPreViewCell.h"
#import "ActivityConditionController.h"
#import "WPShareModel.h"
#import "OtherActivityController.h"
#import "MBProgressHUD+MJ.h"

@interface ActivityPreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ActivityPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"附近的活动";
    self.view.backgroundColor = RGB(235, 235, 235);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
//    NSLog(@"%@",self.previewModel.activityName);
    [self createUI];
    [self createBottom];
}

- (void)rightBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(67)+kHEIGHT(32)*6+7*0.5)];
    tableHeadView.backgroundColor = [UIColor whiteColor];
    NSArray *images = @[@"activity_time",
                        @"activity_end",
                        @"activity_addres",
                        @"activity_applied",
                        @"activity_message",
                        @"activity_fee"];
    NSDateFormatter*formatter=[[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString*timeStr=[formatter stringFromDate:[NSDate date]];
//    NSLog(@"*****%@",timeStr);
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(67)+0.5)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH- 20, kHEIGHT(67)+0.5 - 18.5)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.previewModel.activityName;
    titleLabel.font = kFONT(16);
    [header addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, kHEIGHT(67)+0.5 - 18.5, 120, 12)];
    timeLabel.text = timeStr;
    timeLabel.font = GetFont(12);
    timeLabel.textColor = RGB(153, 153, 153);
    [header addSubview:timeLabel];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 136, kHEIGHT(67)+0.5 - 18.5, 120, 12)];
    shareLabel.text = @"阅览 0    分享 0";
    shareLabel.font = GetFont(12);
    shareLabel.textColor = RGB(153, 153, 153);
    shareLabel.textAlignment = NSTextAlignmentRight;
    [header addSubview:shareLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, kHEIGHT(67), SCREEN_WIDTH - 20, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [header addSubview:line];
    
    [tableHeadView addSubview:header];
    
    NSString *start = [NSString stringWithFormat:@"%@ 至 %@",self.previewModel.startTime,self.previewModel.finishTime];
    NSMutableAttributedString *startStr = [[NSMutableAttributedString alloc] initWithString:@"活动时间"];
    ActivityPreViewItem *item1 = [[ActivityPreViewItem alloc] initWithFrame:CGRectMake(0, header.bottom, SCREEN_WIDTH, kHEIGHT(32) + 0.5) title:startStr image:images[0] text:start isArrow:NO];
    [tableHeadView addSubview:item1];
    
    NSMutableAttributedString *endStr = [[NSMutableAttributedString alloc] initWithString:@"报名截止"];
    ActivityPreViewItem *item2 = [[ActivityPreViewItem alloc] initWithFrame:CGRectMake(0, item1.bottom, SCREEN_WIDTH, kHEIGHT(32) + 0.5) title:endStr image:images[1] text:self.previewModel.endTime isArrow:NO];
    [tableHeadView addSubview:item2];
    
    NSMutableAttributedString *addressStr = [[NSMutableAttributedString alloc] initWithString:@"地点"];
    ActivityPreViewItem *item3 = [[ActivityPreViewItem alloc] initWithFrame:CGRectMake(0, item2.bottom, SCREEN_WIDTH, kHEIGHT(32) + 0.5) title:addressStr image:images[2] text:self.previewModel.location isArrow:YES];
    [tableHeadView addSubview:item3];
    
    NSString *apply = [NSString stringWithFormat:@"已报名  ( 限%@人 )",self.previewModel.admitNum];
    NSMutableAttributedString *applyStr = [[NSMutableAttributedString alloc] initWithString:apply];
    [applyStr addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:NSMakeRange(3,apply.length - 3)];
    ActivityPreViewItem *item4 = [[ActivityPreViewItem alloc] initWithFrame:CGRectMake(0, item3.bottom, SCREEN_WIDTH, kHEIGHT(32) + 0.5) title:applyStr image:images[3] text:@"0" isArrow:YES];
    [tableHeadView addSubview:item4];
    
    NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:@"留言"];
    ActivityPreViewItem *item5 = [[ActivityPreViewItem alloc] initWithFrame:CGRectMake(0, item4.bottom, SCREEN_WIDTH, kHEIGHT(32) + 0.5) title:messageStr image:images[4] text:@"0" isArrow:YES];
    [tableHeadView addSubview:item5];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (FeeModel *model in self.previewModel.fees) {
        NSString *fee = [NSString stringWithFormat:@"%@%@",model.name,model.money];
        [arr addObject:fee];
    }
    
    NSString *lastFee = [arr componentsJoinedByString:@"/"];
    
    NSMutableAttributedString *feeStr = [[NSMutableAttributedString alloc] initWithString:@"费用"];
    
    ActivityPreViewItem *item6 = [[ActivityPreViewItem alloc] initWithFrame:CGRectMake(0, item5.bottom, SCREEN_WIDTH, kHEIGHT(32) + 0.5) title:feeStr image:images[5] text:lastFee isArrow:YES];
    [tableHeadView addSubview:item6];

    [self.view addSubview:tableHeadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT + 64) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = tableHeadView;
    [self.view addSubview:_tableView];
}

#pragma mark - 创建底部
- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOMHEIGHT - 3, SCREEN_WIDTH, BOTTOMHEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOMHEIGHT - 3 , SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    
    UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletBtn.frame = CGRectMake(0, 0, 34, BOTTOMHEIGHT);
    [deletBtn setImage:[UIImage imageNamed:@"delet_info"] forState:UIControlStateNormal];
    [deletBtn addTarget:self action:@selector(deletBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:deletBtn];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(34, 0, SCREEN_WIDTH - 34*2, BOTTOMHEIGHT);
    [publishBtn setImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [publishBtn setTitle:@"  发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
    publishBtn.titleLabel.font = kFONT(15);
    [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:publishBtn];
}

- (void)deletBtnClick{
    NSLog(@"删除");
}

- (void)publishBtnClick{
//    NSLog(@"发布");
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSMutableArray *contentList = [NSMutableArray array];
    NSMutableArray *photoData = [NSMutableArray array];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    UIImage *image = self.previewModel.iconImage[0];
    WPFormData *formData = [[WPFormData alloc]init];
    formData.data = UIImageJPEGRepresentation(image, 0.5);
    formData.name = [NSString stringWithFormat:@"img0"];
    formData.filename = [NSString stringWithFormat:@"img0.jpg"];
    formData.mimeType = @"application/octet-stream";
    [photoData addObject:formData];
    
    //封装图片和文字
    for (int i = 0 ; i<self.previewModel.textAndImage.count; i ++) {
        if ([self.previewModel.textAndImage[i] isKindOfClass:[NSAttributedString class]]) {//文字
//            NSAttributedString *str = self.previewModel.textAndImage[i];
            NSString *text = [NSString stringWithFormat:@"%@",self.previewModel.textAndImage[i]];
            //        NSLog(@"#####%@",str);
            NSArray *arr = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
//            NSLog(@"%@----%lu",arr,(unsigned long)arr.count);
            NSMutableArray *attStr = [NSMutableArray array];
            NSInteger index = (arr.count - 1)/2;
            for (int j = 0 ; j<index; j++) {
                NSString *detail = arr[2*j];
                NSString *attribute = arr[2*j+1];
                NSDictionary *attibuteTex = @{@"detail" : detail,
                                              @"attribute" : attribute};
                [attStr addObject:attibuteTex];
            }
//            NSLog(@"#####%@",attStr);
            NSDictionary *textDic = @{@"txt": attStr};
            [contentList addObject:textDic];
        } else { //图片
            MLSelectPhotoAssets *asset = self.previewModel.textAndImage[i];
            UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
            WPFormData *formData = [[WPFormData alloc]init];
            formData.data = UIImageJPEGRepresentation(img, 0.5);
            formData.name = [NSString stringWithFormat:@"img%d",i+1];
            formData.filename = [NSString stringWithFormat:@"img%d.jpg",i+1];
            formData.mimeType = @"application/octet-stream";
            [photoData addObject:formData];
            NSString *value = [NSString stringWithFormat:@"img%d",i+1];
            NSDictionary *photoDic = @{@"txt":value};
            [contentList addObject:photoDic];
        }
    }
    
    NSMutableArray *moneyList = [NSMutableArray array];
    for (FeeModel *model in self.previewModel.fees) {
        NSDictionary *dic =@{@"name" : model.name,
                             @"money" : model.money,
                             @"limit" : model.num};
        [moneyList addObject:dic];
    }
    
    NSMutableArray *conditionArr = [NSMutableArray array];
    for (ConditionModel *model in self.previewModel.conditions) {
        NSString *str = model.name;
        [conditionArr addObject:str];
    }
    NSString *apply_condition = [conditionArr componentsJoinedByString:@"/"];
    NSString *moneyrows = [NSString stringWithFormat:@"%lu",(unsigned long)self.previewModel.fees.count];
    NSString *contentrows = [NSString stringWithFormat:@"%lu",(unsigned long)self.previewModel.textAndImage.count];
    NSString *game_cost = [[NSString alloc] init];
    if (self.previewModel.fees.count == 0) {
        game_cost = @"0";
    } else {
        game_cost = @"1";
    }
    NSDictionary *jsonDic = @{@"game_type" : self.previewModel.activityType,
                              @"moneyrows" : moneyrows,
                              @"bigen_time" : self.previewModel.startTime,
                              @"group_id" : self.previewModel.relevanceGroup.sid,
                              @"contentrows" : contentrows,
                              @"deadline_time" : self.previewModel.endTime,
                              @"moneylist" : moneyList,
                              @"title" : self.previewModel.activityName,
                              @"Address_2" : self.previewModel.location,
                              @"Address_1" : self.previewModel.Address_1,
                              @"Address_1ID" : self.previewModel.Address_1ID,
                              @"end_time" : self.previewModel.finishTime,
                              @"contentlist" : contentList,
                              @"pople_sum": self.previewModel.admitNum,
                              @"game_cost" : game_cost,
                              @"user_id" : userInfo[@"userid"],
                              @"apply_Condition" : apply_condition,
                              @"longitude" : @"",
                              @"latitude" : @""};
//    NSLog(@"1111111%@",jsonDic);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    NSDictionary *params = @{@"action" : @"addgame",
                             @"username" : model.username,
                             @"password" : model.password,
                             @"Json" : jsonString};
//    NSLog(@"22222%@",params);
    [WPHttpTool postWithURL:url params:params formDataArray:photoData success:^(id json) {
//        NSLog(@"*****%@",json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OtherActivityController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        } else {
            [MBProgressHUD alertView:@"发布失败" Message:json[@"info"]];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD alertView:@"发布失败" Message:error.localizedDescription];
    }];

}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.previewModel.textAndImage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityPreViewCell *cell = [ActivityPreViewCell cellWithTableView:tableView];
    cell.pictureShow.image = nil;
    cell.textShow.text = nil;
    if ([self.previewModel.textAndImage[indexPath.row] isKindOfClass:[MLSelectPhotoAssets class]]) {
        cell.asset = self.previewModel.textAndImage[indexPath.row];
    } else {
        cell.attributedString = self.previewModel.textAndImage[indexPath.row];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.previewModel.textAndImage[indexPath.row] isKindOfClass:[MLSelectPhotoAssets class]]) {
        MLSelectPhotoAssets *asset = self.previewModel.textAndImage[indexPath.row];
        ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
        CGFloat height;
        CGSize dimension = [representation dimensions];
        height = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
        return height + 10;
    } else {
        //            return 102;
        TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
        [label setAttributedText:self.previewModel.textAndImage[indexPath.row]];
        label.linesSpacing = 4;
        label.characterSpacing = -1;
        [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
//        CGFloat height;
        CGFloat textHeight = label.frame.size.height;
//        if (textHeight > 80) {
//            height = textHeight + 22;
//        } else {
//            height = 102;
//        }
        return textHeight + 10;
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
